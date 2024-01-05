#include <stdio.h>

#include "GL/glew.h"
#include "GLFW/glfw3.h"
#include "GL/gl.h"
#include "vector_basic.h"

int main()
{
    vector_basic vb;
    vector_basic_init(&vb, 5, sizeof(int), NULL);
    printf("i ran.\n");
    hc_run();
    //glewInit();
    return 0;
}