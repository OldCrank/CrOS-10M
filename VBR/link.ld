ENTRY(_start)				/* the name of the entry label */
/* Craig - attempting this as a minimum ld script */


SECTIONS
{
	// . = 0x10000;
	. = 0x7c00; 				// not sure about this?

	.text : 
	{
	*(.text)
	}

}