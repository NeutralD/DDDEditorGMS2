/// @param string

// characters must be save to use as a file name; to keep things simple we'll
// use the A-Za-z0-9\_ pattern of variable names, although we don't care if
// they start with a digit in this case
return regex("[A-Za-z0-9_]+", argument0);