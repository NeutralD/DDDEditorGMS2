/// @param UIBitfield

var bitfield = argument0;

var base = bitfield.root;
base.value = base.value ^ (1 << bitfield.value);

script_execute(base.onvaluechange, base);