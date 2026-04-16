//Numpy array shape [4]
//Min 0.000000000000
//Max 0.125000000000
//Number of zeros 2

#ifndef B10_H_
#define B10_H_

#ifndef __SYNTHESIS__
bias10_t b10[4];
#else
bias10_t b10[4] = {0.125, 0.000, 0.000, 0.125};
#endif

#endif
