#include "functions.h"
#include <string.h>
#include <stdio.h>
#include "ModelicaUtilities.h"

int size(const char *name)
{
  if (!strcmp(name, "foobar"))
    return 3;
  else
    ModelicaError("Unsupported name");
}

double compute(const char *name, double x)
{
  double y;
  char str[100];

  if (!strcmp(name, "foobar"))
    {
	  y = 1 + x*x;
	  if (y > 10.0)
	  {
	    snprintf(str, 100, "Value of x = %f could be too high\n", x);
		ModelicaWarning(str);
	  }
	  if (y > 17.0)
	  {
	    snprintf(str, 100, "Value of x = %f is too high\n", x);
		ModelicaError(str);
	  }
	  return y;
	}
  else
    ModelicaError("Unsupported name");
}
