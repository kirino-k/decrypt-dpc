/*********************************************************************
*
* Name	:	Split AES Key
*
*********************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

//----------------------------------------------------------------------

#define true 1
#define false 0

//----------------------------------------------------------------------
int main(int argc, char *argv[])
{
	char buf[4096];
	FILE *fpr, *fpw, *fpk;
	int contf = true;
	int ii, cnt, lenkey, leniv;
	char key[1024], iv[64];
	
	if (argc == 4)
	{
		fpr = fopen(argv[1], "r");
		if (fpr == NULL) {
			fprintf(stderr, "splitaeskey:main() 入力ファイルをオープンできません。\n");
			exit(1);
		}
		fpw = fopen(argv[2], "w");
		if (fpw == NULL) {
			fprintf(stderr, "splitaeskey:main() 出力ファイルをオープンできません。\n");
			fclose(fpr);
			exit(1);
		}
		fpk = fopen(argv[3], "w");
		if (fpk == NULL) {
			fprintf(stderr, "splitaeskey:main() 出力ファイルをオープンできません。\n");
			fclose(fpr);
			fclose(fpw);
			exit(1);
		}
		
		// Read length of encripted key.
		if((cnt = (int)(fread(buf, 4, (size_t)1, fpr))) != 1)
		{
			if (feof(fpr) == 0)
			{
				fprintf(stderr, "splitaeskey:main() Read error1.\n");
			}
			else
			{
				fprintf(stderr, "splitaeskey:main() File format error1.\n");
			}
			fclose(fpr);
			fclose(fpw);
			fclose(fpk);
			exit(1);
		}
		lenkey = (unsigned int)buf[0] + (unsigned int)buf[1] * 256;
		
		// Read length of IV.
		if((cnt = (int)(fread(buf, 4, (size_t)1, fpr))) != 1)
		{
			if (feof(fpr) == 0)
			{
				fprintf(stderr, "splitaeskey:main() Read error2.\n");
			}
			else
			{
				fprintf(stderr, "splitaeskey:main() File format error2.\n");
			}
			fclose(fpr);
			fclose(fpw);
			fclose(fpk);
			exit(1);
		}
		leniv = (unsigned int)buf[0] + (unsigned int)buf[1] * 256;
		
		// Read encripted key.
		if((cnt = (int)(fread(key, lenkey, (size_t)1, fpr))) != 1)
		{
			if (feof(fpr) == 0)
			{
				fprintf(stderr, "splitaeskey:main() Read error3.\n");
			}
			else
			{
				fprintf(stderr, "splitaeskey:main() File format error3.\n");
			}
			fclose(fpr);
			fclose(fpw);
			fclose(fpk);
			exit(1);
		}
		if (fwrite(key, (size_t)lenkey, 1, fpk) != 1)
		{
			fprintf(stderr, "splitaeskey:main() Write error3.\n");
			fclose(fpr);
			fclose(fpw);
			fclose(fpk);
			exit(1);
		}
		
		// Read IV.
		if((cnt = (int)(fread(iv, leniv, (size_t)1, fpr))) != 1)
		{
			if (feof(fpr) == 0)
			{
				fprintf(stderr, "splitaeskey:main() Read error4.\n");
			}
			else
			{
				fprintf(stderr, "splitaeskey:main() File format error4.\n");
			}
			fclose(fpr);
			fclose(fpw);
			fclose(fpk);
			exit(1);
		}

		while (contf)
		{
			if((cnt = (int)(fread(buf, 1, (size_t)4096, fpr))) != 4096)
			{
				if (feof(fpr) == 0)
				{
					fprintf(stderr, "splitaeskey:main() Read error.\n");
					fclose(fpr);
					fclose(fpw);
					fclose(fpk);
					exit(1);
				}
				contf = false;
			}
			if (cnt > 0)
			{
				if (fwrite(buf, (size_t)cnt, 1, fpw) != 1)
				{
					fprintf(stderr, "splitaeskey:main() Write error.\n");
					fclose(fpr);
					fclose(fpw);
					fclose(fpk);
					exit(1);
				}
			}
		}
		
		fclose(fpr);
		fclose(fpw);
		fclose(fpk);
		
		for (ii = 0; ii < leniv; ii++)
		{
			fprintf(stdout, "%02x", (unsigned char)iv[ii]);
		}
	}

	exit(0);
}

