SECTIONS
{
	/* The BIOS loads the code from the disk to this location.
	 * We must tell that to the linker so that it can properly
	 * calculate the addresses of the symbols we might jump to.
	 */
	 //. = 0x7c00;
	 . = 0x0600;
	 .text :
	 {
	 	_start = .;
	 	*(.text)
	 	/* Place the magic bytes at the end of the first 512 sector. */
	 	. = 0x1FE;
	 	SHORT(0xAA55)
	 }
}