#include <enzos/system.h>

unsigned int strlen(const char* str)
{
	unsigned int ret = 0;
	while ( str[ret] != 0 )
		ret++;
	return ret;
}
