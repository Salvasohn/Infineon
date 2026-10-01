/* Minimal newlib hooks required when using the Infineon startup code together
 * with -nostartfiles. startup_XMC4500.S calls __libc_init_array(), whose
 * newlib implementation expects _init to exist. _fini is provided as the
 * matching bare-metal counterpart.
 */
void _init(void)
{
}

void _fini(void)
{
}
