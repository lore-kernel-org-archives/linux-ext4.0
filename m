From: Matt <jackdachef@gmail.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Sun, 5 Dec 2010 14:30:57 +0100
Message-ID: <AANLkTimLLWZydmiYKj9Gzyc0nu5L107vyaAQZ8rZfS7Q@mail.gmail.com>
References: <AANLkTik_p0yxQBQ3ehHWYPLfiqxGbSNUT5XUk9dC5-x6@mail.gmail.com>
	<20101201165229.GC13415@redhat.com>
	<AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
	<4CF692D1.1010906@redhat.com>
	<AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
	<4CF6B3E8.2000406@redhat.com>
	<20101201212310.GA15648@redhat.com>
	<AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
	<20101204193828.GB13871@redhat.com>
	<AANLkTinX_av7A-xT6hD-Df=tHxOOWhi7QkVezAUO3pW5@mail.gmail.com>
	<20101205100954.GA6564@fritha.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>,
	Chris Mason <chris.mason@oracle.com>, htejun@gmail.com,
	linux-ext4@vger.kernel.org, Jon Nelson <jnelson@jamponi.net>
To: Heinz Diehl <htd@fritha.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101205100954.GA6564@fritha.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Dec 5, 2010 at 11:09 AM, Heinz Diehl <htd@fritha.org> wrote:
> On 05.12.2010, Matt wrote:
>
>> I should have made it clear that the results I get are observed when
>> using the kernels/checkouts *with* the dm-crypt multi-cpu patch,
>> without the patch I didn't see that kind of problems (hardlocks, fil=
es
>> missing, etc.)
>
> I have to take back my other two emails, stating that no corruption
> happened with the dm-crypt multi-cpu patch. Today, I encountered
> filesystem corruption on one, and a complete hardlock on another mach=
ine.
> No logfile entries, no m-sysrq, a complete deadlock. Filesystem was
> corrupted here too, had to reboot from CD.
>
> The machines with plain 2.6.37-rc4 are up and running...
>
>

Hi Heinz,

that's bad news :(
hopefully you had a backup available


to complete my last report with the corruption/empty file for
/var/db/pkg/sys-devel/patch-2.6.1/COUNTER

(kernel running was from commit bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8c=
c)

I got more and more corruption and the following BUG message in dmesg:

[ 6097.179452] ------------[ cut here ]------------
[ 6097.179456] kernel BUG at fs/ext4/inode.c:2717!
[ 6097.179457] invalid opcode: 0000 [#1] PREEMPT SMP
[ 6097.179459] last sysfs file:
/sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
[ 6097.179461] CPU 5
[ 6097.179462] Modules linked in: it87 hwmon_vid coretemp hwmon
fglrx(P) firewire_ohci firewire_core i2c_i801 e1000e wmi shpchp tg3
libphy e1000 scsi_wait_scan sl811_hcd ohci_hcd ssb usb_storage
ehci_hcd
[ 6097.179472]
[ 6097.179475] Pid: 4540, comm: jbd2/dm-2-8 Tainted: P
2.6.36-rc6_bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc+ #1 FMP55/ipower
G3710
[ 6097.179477] RIP: 0010:[<ffffffff8119cc50>]  [<ffffffff8119cc50>]
ext4_writepage+0x270/0x280
[ 6097.179482] RSP: 0018:ffff8801baec3b40  EFLAGS: 00010246
[ 6097.179483] RAX: 8000000000020069 RBX: ffffea0004222088 RCX: 0000000=
000000030
[ 6097.179485] RDX: 0000000000000a0f RSI: ffff8801baec3cc0 RDI: ffffea0=
004222088
[ 6097.179486] RBP: ffff8801472ca6a0 R08: ffff880183cc6de8 R09: 0000000=
000000000
[ 6097.179488] R10: 0000000000000008 R11: 0000000000000010 R12: 0000000=
000000a0f
[ 6097.179489] R13: 0000000000001000 R14: ffff8801baec3cc0 R15: ffff880=
1baec3c10
[ 6097.179491] FS:  0000000000000000(0000) GS:ffff880002140000(0000)
knlGS:0000000000000000
[ 6097.179492] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6097.179494] CR2: 00007f19058591f0 CR3: 0000000001c04000 CR4: 0000000=
0000006e0
[ 6097.179495] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[ 6097.179497] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[ 6097.179498] Process jbd2/dm-2-8 (pid: 4540, threadinfo
ffff8801baec2000, task ffff8801bfef0040)
[ 6097.179500] Stack:
[ 6097.179500]  ffff8801baec3c10 ffffffff810fce75 ffff8801472ca808
ffff8801472ca808
[ 6097.179503] <0> ffff8801472ca808 0000000000000a0f ffffea0004222088
0000000000000003
[ 6097.179506] <0> ffff8801baec3c10 ffffffff810a261d 000000000000000e
ffffffff810a2ab1
[ 6097.179509] Call Trace:
[ 6097.179513]  [<ffffffff810fce75>] ? __set_page_dirty_buffers+0x85/0x=
e0
[ 6097.179517]  [<ffffffff810a261d>] ? __writepage+0xd/0x40
[ 6097.179519]  [<ffffffff810a2ab1>] ? write_cache_pages+0x1b1/0x3d0
[ 6097.179521]  [<ffffffff810a2610>] ? __writepage+0x0/0x40
[ 6097.179525]  [<ffffffff811d1869>] ? journal_submit_data_buffers+0x99=
/0x100
[ 6097.179528]  [<ffffffff811d1db1>] ?
jbd2_journal_commit_transaction+0x331/0x1330
[ 6097.179532]  [<ffffffff8172097b>] ? schedule+0x37b/0x8d0
[ 6097.179534]  [<ffffffff817237f8>] ? _raw_spin_lock_irqsave+0x18/0x20
[ 6097.179538]  [<ffffffff810538c3>] ? lock_timer_base.clone.23+0x33/0x=
70
[ 6097.179540]  [<ffffffff8105396e>] ? try_to_del_timer_sync+0x6e/0x90
[ 6097.179542]  [<ffffffff811d5d91>] ? kjournald2+0xb1/0x210
[ 6097.179545]  [<ffffffff81062b80>] ? autoremove_wake_function+0x0/0x3=
0
[ 6097.179547]  [<ffffffff811d5ce0>] ? kjournald2+0x0/0x210
[ 6097.179549]  [<ffffffff811d5ce0>] ? kjournald2+0x0/0x210
[ 6097.179551]  [<ffffffff81062706>] ? kthread+0x96/0xa0
[ 6097.179555]  [<ffffffff81003394>] ? kernel_thread_helper+0x4/0x10
[ 6097.179557]  [<ffffffff81062670>] ? kthread+0x0/0xa0
[ 6097.179559]  [<ffffffff81003390>] ? kernel_thread_helper+0x0/0x10
[ 6097.179560] Code: ff f6 c4 40 0f 84 4a fe ff ff e9 77 ff ff ff 48
c7 c6 f0 3f 82 81 48 c7 c7 40 b1 9d 81 31 c0 e8 e0 34 58 00 e9 6e fe
ff ff 0f 0b <0f> 0b 4d 8b 6d 10 e9 96 fe ff ff 0f 1f 44 00 00 48 83 ec
08 ba
[ 6097.179580] RIP  [<ffffffff8119cc50>] ext4_writepage+0x270/0x280
[ 6097.179583]  RSP <ffff8801baec3b40>
[ 6097.179584] ---[ end trace 5199c452c07fe3ec ]---

I saved the output to my boot partition via dmesg > dmesg_bd2d.txt


after that when running eselect (only the command) while it parsed the
available config files - it would say that files are missing for
eselect mesa

-----------------------------------------------------------------------=
-------------------------------------------------------
*so it would look like so:*
-----------------------------------------------------------------------=
-------------------------------------------------------

eselect
Usage: eselect <global options> <module name> <module options>

Global options:
  --brief                   Make output shorter
  --no-color,--no-colour    Disable coloured output

Built-in modules:
  help                      Display a help message
  usage                     Display a usage message
  version                   Display version information

Extra modules:
  bashcomp                  Manage contributed bash-completion scripts
  binutils                  Manage installed versions of sys-devel/binu=
tils
  boost                     Manage boost installations
  cblas                     Manage installed CBLAS implementations
  ctags                     Manage /usr/bin/ctags implementations
  ecj                       Manage ECJ targets
  editor                    Manage the EDITOR environment variable
  env                       Manage environment variables set in /etc/en=
v.d/
  esd                       Select esound daemon or wrapper
  fontconfig                Manage fontconfig /etc/fonts/conf.d/ symlin=
ks
  java-nsplugin             Manage the Java plugin for Netscape-like Br=
owsers
  java-vm                   Manage the Java system and user VM
  kernel                    Manage the /usr/src/linux symlink
/usr/share/eselect/modules/mesa.eselect: line 15:
/usr/share/mesa/eselect-mesa.conf: No such file or directory
!!! Error: Failed to source config
Call stack:
    * source (mesa.eselect:15)
    * load_config (config.bash:105)
    * do_list (modules.eselect:58)
    * check_do (core.bash:24)
    * do_action (core.bash:89)
    * es_do_list_modules (eselect:122)
    * es_do_help (eselect:99)
    * main (eselect:194)
  mesa                      No description available
  modules                   A module for querying modules. By default, =
it lists
                            all available modules
  news                      Read Gentoo ("GLEP 42") news items
  opengl                    Manage the OpenGL implementation used by yo=
ur
                            system
  package-manager           Manage the PACKAGE_MANAGER environment vari=
able
  pager                     Manage the PAGER environment variable
  php                       Manage php installations
  pinentry                  Manage /usr/bin/pinentry symlink
  postgresql                Manage postgresql slots
  profile                   Manage the /etc/make.profile symlink
  python                    Manage Python symlinks
  rc                        Manage /etc/init.d scripts in runlevels
  ruby                      Manage ruby symlinks
  vi                        Manage /usr/bin/vi implementations
  visual                    Manage the VISUAL environment variable
  wxwidgets                 Manage the system default wxWidgets profile=
=2E
  xvmc                      Manage the XvMC implementation used by your=
 system
exiting

-----------------------------------------------------------------------=
-------------------------------------------------------
*normally it would look like:*
-----------------------------------------------------------------------=
-------------------------------------------------------

eselect
Usage: eselect <global options> <module name> <module options>

Global options:
  --brief                   Make output shorter
  --no-color,--no-colour    Disable coloured output

Built-in modules:
  help                      Display a help message
  usage                     Display a usage message
  version                   Display version information

Extra modules:
  bashcomp                  Manage contributed bash-completion scripts
  binutils                  Manage installed versions of sys-devel/binu=
tils
  boost                     Manage boost installations
  cblas                     Manage installed CBLAS implementations
  ctags                     Manage /usr/bin/ctags implementations
  ecj                       Manage ECJ targets
  editor                    Manage the EDITOR environment variable
  env                       Manage environment variables set in /etc/en=
v.d/
  esd                       Select esound daemon or wrapper
  fontconfig                Manage fontconfig /etc/fonts/conf.d/ symlin=
ks
  java-nsplugin             Manage the Java plugin for Netscape-like Br=
owsers
  java-vm                   Manage the Java system and user VM
  kernel                    Manage the /usr/src/linux symlink
  mesa                      Manage the OpenGL driver architecture used =
by
                            media-libs/mesa
  modules                   A module for querying modules. By default, =
it lists
                            all available modules
  news                      Read Gentoo ("GLEP 42") news items
  opengl                    Manage the OpenGL implementation used by yo=
ur
                            system
  package-manager           Manage the PACKAGE_MANAGER environment vari=
able
  pager                     Manage the PAGER environment variable
  php                       Manage php installations
  pinentry                  Manage /usr/bin/pinentry symlink
  postgresql                Manage postgresql slots
  profile                   Manage the /etc/make.profile symlink
  python                    Manage Python symlinks
  rc                        Manage /etc/init.d scripts in runlevels
  ruby                      Manage ruby symlinks
  vi                        Manage /usr/bin/vi implementations
  visual                    Manage the VISUAL environment variable
  wxwidgets                 Manage the system default wxWidgets profile=
=2E
  xvmc                      Manage the XvMC implementation used by your=
 system


then I continued some browsing on the web (reading stuff & research)
and letting music (mp3) run

rekonq was fired up, for some minutes it worked, and then it hang
and/or slowed down during loading of websites - it eventually finished
it couldn't really be closed - only via killlall
and it remained in D (daemon ?) state in htop

ps aux | grep rekonq showed:
[rekonq] <defunct>

addr2line didn't reveal much useful - only: inode.c:0

shortly before I wanted to shutdown my box I to tried to sync stuff to
post some info (if you guys need it) but syncing wouldn't work anymore

time sync && sdparm -C sync /dev/sdd

the Magic SYSRQ key still (half-way) worked: closing apps, etc. was
possible but syncing also didn't work anymore

so I did a Alt + Print + REI UO


short summary what happened:

the kernel running is from checkout/commit:
bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc
1) emerge -1 sys-devel/gcc
COUNTER file in /var/db/pkg/sys-devel/patch-2.6.1/ got corrupted/empty
2) config files of eselect mesa got corrupted
3) rekonq would hang/slow down for several moments while loading
websites - it would continue loading them eventually but further usage
wasn't possible anymore

4) somewhere between 1 and 3 the BUG message appeared in dmesg
5) syncing wouldn't work anymore

*) often un- and re-mounting is my /boot-partition
*) my portage-tree is on the XFS-partition with delayed logging
*) the other ext4-partition (dm-3) is my /home-partition mounted ro (re=
ad-only)

Seems like it's really some issues with ext4 ...

Below you'll find the output of dmesg for the full session

Thanks & Regards

Matt



[    0.000000] Linux version
2.6.36-rc6_bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc+ (root@lupus) (gcc
version 4.5.1 (Gentoo Hardened 4.5.1-r1 p1.4, pie-0.4.5) ) #1 SMP
PREEMPT Thu Dec 2 21:23:25 CET 2010
[    0.000000] Command line: dolvm root=3D/dev/ram0 init=3D/linuxrc
ramdisk=3D8192 crypt_root=3D/dev/sdd6 real_root=3D/dev/mapper/XPS-ROOT
noresume noresume2 udev ro elevator=3Ddeadline
snd-hda-intel.enable_msi=3D1 fbcon=3Dscrollback:256K pax_softmode=3D1
clocksource=3Dtsc usbcore.autosuspend=3D1 raid=3Dnoautodetect
video=3Dvesafb:mtrr:3,ywrap vga=3D794 nomodeset
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
[    0.000000]  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserve=
d)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserve=
d)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf780000 (usable)
[    0.000000]  BIOS-e820: 00000000bf780000 - 00000000bf78e000 (ACPI da=
ta)
[    0.000000]  BIOS-e820: 00000000bf78e000 - 00000000bf7d0000 (ACPI NV=
S)
[    0.000000]  BIOS-e820: 00000000bf7d0000 - 00000000bf7e0000 (reserve=
d)
[    0.000000]  BIOS-e820: 00000000bf7ed000 - 00000000c0000000 (reserve=
d)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserve=
d)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserve=
d)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001c0000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working aro=
und it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) =3D=3D> (reserved)
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000
(usable) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (=
usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x1c0000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DFFFF uncachable
[    0.000000]   E0000-E3FFF write-protect
[    0.000000]   E4000-E7FFF write-through
[    0.000000]   E8000-EBFFF write-protect
[    0.000000]   EC000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 1C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 000000000 mask E00000000 write-back
[    0.000000]   2 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x70106=
00070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 7GB, range: 1GB, type UC
[    0.000000] reg 1, base: 0GB, range: 8GB, type WB
[    0.000000] reg 2, base: 3GB, range: 1GB, type UC
[    0.000000] total RAM covered: 6144M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 64K 	num_reg: 4  	lose cove=
r RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 4GB, range: 2GB, type WB
[    0.000000] reg 3, base: 6GB, range: 1GB, type WB
[    0.000000] e820 update range: 00000000c0000000 - 0000000100000000
(usable) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0xbf780 max_arch_pfn =3D 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved=
)
[    0.000000]  modified: 0000000000010000 - 000000000009dc00 (usable)
[    0.000000]  modified: 000000000009dc00 - 00000000000a0000 (reserved=
)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved=
)
[    0.000000]  modified: 0000000000100000 - 00000000bf780000 (usable)
[    0.000000]  modified: 00000000bf780000 - 00000000bf78e000 (ACPI dat=
a)
[    0.000000]  modified: 00000000bf78e000 - 00000000bf7d0000 (ACPI NVS=
)
[    0.000000]  modified: 00000000bf7d0000 - 00000000bf7e0000 (reserved=
)
[    0.000000]  modified: 00000000bf7ed000 - 00000000c0000000 (reserved=
)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved=
)
[    0.000000]  modified: 00000000ffb00000 - 0000000100000000 (reserved=
)
[    0.000000]  modified: 0000000100000000 - 00000001c0000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf780000
[    0.000000]  0000000000 - 00bf600000 page 2M
[    0.000000]  00bf600000 - 00bf780000 page 4k
[    0.000000] kernel direct mapping tables up to bf780000 @ 16000-1b00=
0
[    0.000000] init_memory_mapping: 0000000100000000-00000001c0000000
[    0.000000]  0100000000 - 01c0000000 page 2M
[    0.000000] kernel direct mapping tables up to 1c0000000 @ 19000-210=
00
[    0.000000] RAMDISK: 37cd6000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f9cf0 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bf780100 0006C (v01 ACRSYS ACRPRDCT
20100329 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf780290 000F4 (v04 ACRSYS FACP1137
20100329 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf7805e0 07E42 (v02  926A1 926A1P15
00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf78e000 00040
[    0.000000] ACPI: APIC 00000000bf780390 0008C (v02 ACRSYS APIC1137
20100329 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf780420 0003C (v01 ACRSYS OEMMCFG
20100329 MSFT 00000097)
[    0.000000] ACPI: SLIC 00000000bf780460 00176 (v01 ACRSYS ACRPRDCT
20100329 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf78e040 00072 (v01 ACRSYS OEMB1137
20100329 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bf78a5e0 00038 (v01 ACRSYS OEMHPET
20100329 MSFT 00000097)
[    0.000000] ACPI: GSCI 00000000bf78e0c0 02024 (v01 ACRSYS GMCHSCI
20100329 MSFT 00000097)
[    0.000000] ACPI: AWMI 00000000bf7900f0 0004E (v01 ACRSYS OEMB1137
20100329 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf792c10 00363 (v01 DpgPmm    CpuPm
00000012 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00061fffff] PMD ->
[ffff880002600000-ffff8800079fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x001c0000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000bf780
[    0.000000]     0: 0x00100000 -> 0x001c0000
[    0.000000] On node 0 totalpages: 1570573
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3925 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 765880 pages, LIFO batch:31
[    0.000000]   Normal zone: 10752 pages used for memmap
[    0.000000]   Normal zone: 775680 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GS=
I 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high lev=
el)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 0000000=
00009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 0000000=
0000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000=
0000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000=
000100000
[    0.000000] PM: Registered nosave memory: 00000000bf780000 - 0000000=
0bf78e000
[    0.000000] PM: Registered nosave memory: 00000000bf78e000 - 0000000=
0bf7d0000
[    0.000000] PM: Registered nosave memory: 00000000bf7d0000 - 0000000=
0bf7e0000
[    0.000000] PM: Registered nosave memory: 00000000bf7e0000 - 0000000=
0bf7ed000
[    0.000000] PM: Registered nosave memory: 00000000bf7ed000 - 0000000=
0c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 0000000=
0fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 0000000=
0fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 0000000=
0ffb00000
[    0.000000] PM: Registered nosave memory: 00000000ffb00000 - 0000000=
100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap:
c0000000:3ee00000)
[    0.000000] early_res array is doubled to 64 at [1c000 - 1c7ff]
[    0.000000] setup_percpu: NR_CPUS:16 nr_cpumask_bits:16
nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880002000000 s81088
r8192 d21312 u262144
[    0.000000] pcpu-alloc: s81088 r8192 d21312 u262144 alloc=3D1*209715=
2
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 1545485
[    0.000000] Kernel command line: dolvm root=3D/dev/ram0 init=3D/linu=
xrc
ramdisk=3D8192 crypt_root=3D/dev/sdd6 real_root=3D/dev/mapper/XPS-ROOT
noresume noresume2 udev ro elevator=3Ddeadline
snd-hda-intel.enable_msi=3D1 fbcon=3Dscrollback:256K pax_softmode=3D1
clocksource=3Dtsc usbcore.autosuspend=3D1 raid=3Dnoautodetect
video=3Dvesafb:mtrr:3,ywrap vga=3D794 nomodeset
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11,
8388608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 41943=
04 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bai=
ling!
[    0.000000] Subtract (51 early reservations)
[    0.000000]   #1 [0001000000 - 0001ded3cc]   TEXT DATA BSS
[    0.000000]   #2 [0037cd6000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0001dee000 - 0001dee243]             BRK
[    0.000000]   #4 [00000ff790 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000ff780 - 00000ff790]    MP-table mpf
[    0.000000]   #6 [000009dc00 - 00000fced0]   BIOS reserved
[    0.000000]   #7 [00000fd074 - 00000ff780]   BIOS reserved
[    0.000000]   #8 [00000fced0 - 00000fd074]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #11 [0000016000 - 0000019000]         PGTABLE
[    0.000000]   #12 [0000019000 - 000001c000]         PGTABLE
[    0.000000]   #13 [0001dee280 - 0001def280]         BOOTMEM
[    0.000000]   #14 [0001ded400 - 0001ded880]         BOOTMEM
[    0.000000]   #15 [00025f0000 - 00025f1000]         BOOTMEM
[    0.000000]   #16 [00025f1000 - 00025f2000]         BOOTMEM
[    0.000000]   #17 [0002600000 - 0007a00000]        MEMMAP 0
[    0.000000]   #18 [0001ded880 - 0001dedb00]         BOOTMEM
[    0.000000]   #19 [0001def280 - 0001e17280]         BOOTMEM
[    0.000000]   #20 [0001e17280 - 0001e3f280]         BOOTMEM
[    0.000000]   #21 [0001e40000 - 0001e41000]         BOOTMEM
[    0.000000]   #22 [0001dedb00 - 0001dedb41]         BOOTMEM
[    0.000000]   #23 [0001dedb80 - 0001dedbc3]         BOOTMEM
[    0.000000]   #24 [0001dedc00 - 0001dedea0]         BOOTMEM
[    0.000000]   #25 [0001dedec0 - 0001dedee0]         BOOTMEM
[    0.000000]   #26 [0001dedf00 - 0001dedf20]         BOOTMEM
[    0.000000]   #27 [0001e3f280 - 0001e3f3b5]         BOOTMEM
[    0.000000]   #28 [0001e3f3c0 - 0001e3f4f5]         BOOTMEM
[    0.000000]   #29 [0002000000 - 000201b000]         BOOTMEM
[    0.000000]   #30 [0002040000 - 000205b000]         BOOTMEM
[    0.000000]   #31 [0002080000 - 000209b000]         BOOTMEM
[    0.000000]   #32 [00020c0000 - 00020db000]         BOOTMEM
[    0.000000]   #33 [0002100000 - 000211b000]         BOOTMEM
[    0.000000]   #34 [0002140000 - 000215b000]         BOOTMEM
[    0.000000]   #35 [0002180000 - 000219b000]         BOOTMEM
[    0.000000]   #36 [00021c0000 - 00021db000]         BOOTMEM
[    0.000000]   #37 [0001dedf40 - 0001dedf48]         BOOTMEM
[    0.000000]   #38 [0001dedf80 - 0001dedf88]         BOOTMEM
[    0.000000]   #39 [0001dedfc0 - 0001dedfe0]         BOOTMEM
[    0.000000]   #40 [0001e3f500 - 0001e3f540]         BOOTMEM
[    0.000000]   #41 [0001e3f540 - 0001e3f660]         BOOTMEM
[    0.000000]   #42 [0001e3f680 - 0001e3f6c8]         BOOTMEM
[    0.000000]   #43 [0001e3f700 - 0001e3f748]         BOOTMEM
[    0.000000]   #44 [0001e41000 - 0001e49000]         BOOTMEM
[    0.000000]   #45 [0007a00000 - 0008200000]         BOOTMEM
[    0.000000]   #46 [00021db000 - 00025db000]         BOOTMEM
[    0.000000]   #47 [0008200000 - 000c200000]         BOOTMEM
[    0.000000]   #48 [0001e49000 - 0001e69000]         BOOTMEM
[    0.000000]   #49 [0001e69000 - 0001ea9000]         BOOTMEM
[    0.000000]   #50 [000001c800 - 0000024800]         BOOTMEM
[    0.000000] Memory: 6099308k/7340032k available (7321k kernel code,
1057740k absent, 182984k reserved, 5818k data, 548k init)
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:744
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] --------------------------------------------------------=
--------------------
[    0.000000]                                  | spin |wlock |rlock
|mutex | wsem | rsem |
[    0.000000]
-----------------------------------------------------------------------=
---
[    0.000000]                      A-A deadlock:failed|failed|  ok
|failed|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok
|failed|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok
|failed|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok
|failed|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok
|failed|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok
|failed|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok
|failed|failed|failed|
[    0.000000]                     double unlock:  ok  |  ok  |failed|
 ok  |failed|failed|
[    0.000000]                   initialize
held:failed|failed|failed|failed|failed|failed|
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |
 ok  |  ok  |  ok  |
[    0.000000]
-----------------------------------------------------------------------=
---
[    0.000000]               recursive read-lock:             |  ok  |
            |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |
            |failed|
[    0.000000]             mixed read-write-lock:             |failed|
            |failed|
[    0.000000]             mixed write-read-lock:             |failed|
            |failed|
[    0.000000]
-----------------------------------------------------------------------=
---
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:failed|failed|  ok  =
|
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:failed|failed|  ok  =
|
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] --------------------------------------------------------
[    0.000000] 142 out of 218 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 2792.737 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated
using timer frequency.. 5585.47 BogoMIPS (lpj=3D2792737)
[    0.000011] pid_max: default: 32768 minimum: 301
[    0.000066] Mount-cache hash table entries: 256
[    0.000161] CPU: Physical Processor ID: 0
[    0.000164] CPU: Processor Core ID: 0
[    0.000169] mce: CPU supports 9 MCE banks
[    0.000182] CPU0: Thermal monitoring enabled (TM1)
[    0.000191] using mwait in idle threads.
[    0.000194] Performance Events: PEBS fmt1+, Nehalem events, Intel PM=
U driver.
[    0.000203] ... version:                3
[    0.000205] ... bit width:              48
[    0.000208] ... generic registers:      4
[    0.000211] ... value mask:             0000ffffffffffff
[    0.000215] ... max period:             000000007fffffff
[    0.000218] ... fixed-purpose events:   3
[    0.000221] ... event mask:             000000070000000f
[    0.000273] ACPI: Core revision 20100702
[    0.028502] Setting APIC routing to flat
[    0.028842] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin=
2=3D-1
[    0.038829] CPU0: Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz st=
epping 05
[    0.142448] NMI watchdog enabled, takes one hw-pmu counter.
[    0.145357] Booting Node   0, Processors  #1
[    0.236253] NMI watchdog enabled, takes one hw-pmu counter.
[    0.238184]  #2
[    0.329074] NMI watchdog enabled, takes one hw-pmu counter.
[    0.331006]  #3
[    0.421900] NMI watchdog enabled, takes one hw-pmu counter.
[    0.423829]  #4
[    0.514734] NMI watchdog enabled, takes one hw-pmu counter.
[    0.516650]  #5
[    0.607527] NMI watchdog enabled, takes one hw-pmu counter.
[    0.609475]  #6
[    0.700353] NMI watchdog enabled, takes one hw-pmu counter.
[    0.702295]  #7 Ok.
[    0.793176] NMI watchdog enabled, takes one hw-pmu counter.
[    0.794119] Brought up 8 CPUs
[    0.794125] Total of 8 processors activated (44680.64 BogoMIPS).
[    0.797213] xor: automatically using best checksumming function: gen=
eric_sse
[    0.802099]    generic_sse: 10436.000 MB/sec
[    0.802102] xor: using function: generic_sse (10436.000 MB/sec)
[    0.802143] NET: Registered protocol family 16
[    0.802312] ACPI FADT declares the system doesn't support PCIe
ASPM, so disable it
[    0.802317] ACPI: bus type pci registered
[    0.802390] dca service started, version 1.12.1
[    0.802429] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.802434] PCI: not using MMCONFIG
[    0.802436] PCI: Using configuration type 1 for base access
[    0.806651] bio: create slab <bio-0> at 0
[    0.823061] raid6: int64x1   2539 MB/s
[    0.840038] raid6: int64x2   3042 MB/s
[    0.857018] raid6: int64x4   2148 MB/s
[    0.873976] raid6: int64x8   2183 MB/s
[    0.890937] raid6: sse2x1    6937 MB/s
[    0.907901] raid6: sse2x2    8132 MB/s
[    0.924865] raid6: sse2x4    9089 MB/s
[    0.924868] raid6: using algorithm sse2x4 (9089 MB/s)
[    0.925935] ACPI: EC: Look up EC in DSDT
[    0.927582] ACPI: Executed 1 blocks of module-level executable AML c=
ode
[    0.931492] ACPI: SSDT 00000000bf790140 0244C (v01 DpgPmm  P001Ist
00000011 INTL 20051117)
[    0.931811] ACPI: Dynamic OEM Table Load:
[    0.931815] ACPI: SSDT (null) 0244C (v01 DpgPmm  P001Ist 00000011
INTL 20051117)
[    0.931995] ACPI: SSDT 00000000bf792590 00678 (v01  PmRef  P001Cst
00003001 INTL 20051117)
[    0.932266] ACPI: Dynamic OEM Table Load:
[    0.932270] ACPI: SSDT (null) 00678 (v01  PmRef  P001Cst 00003001
INTL 20051117)
[    0.932338] ACPI: Interpreter enabled
[    0.932341] ACPI: (supports S0 S3 S4 S5)
[    0.932357] ACPI: Using IOAPIC for interrupt routing
[    0.932381] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.934570] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved
in ACPI motherboard resources
[    0.969233] ACPI: No dock devices found.
[    0.969237] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=3Dnocrs" and report a bug
[    0.969433] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.969621] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0c=
f7]
[    0.969626] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xff=
ff]
[    0.969629] pci_root PNP0A08:00: host bridge window [mem
0x000a0000-0x000bffff]
[    0.969633] pci_root PNP0A08:00: host bridge window [mem
0x000d0000-0x000dffff]
[    0.969638] pci_root PNP0A08:00: host bridge window [mem
0xc0000000-0xdfffffff]
[    0.969641] pci_root PNP0A08:00: host bridge window [mem
0xf0000000-0xfed8ffff]
[    0.969725] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.969727] pci 0000:00:03.0: PME# disabled
[    0.969946] pci 0000:00:19.0: reg 10: [mem 0xfbcc0000-0xfbcdffff]
[    0.969953] pci 0000:00:19.0: reg 14: [mem 0xfbcfc000-0xfbcfcfff]
[    0.969960] pci 0000:00:19.0: reg 18: [io  0xbc00-0xbc1f]
[    0.970004] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.970007] pci 0000:00:19.0: PME# disabled
[    0.970044] pci 0000:00:1a.0: reg 10: [mem 0xfbcfa000-0xfbcfa3ff]
[    0.970110] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.970113] pci 0000:00:1a.0: PME# disabled
[    0.970145] pci 0000:00:1b.0: reg 10: [mem 0xfbcf4000-0xfbcf7fff 64b=
it]
[    0.970192] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.970195] pci 0000:00:1b.0: PME# disabled
[    0.970257] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.970260] pci 0000:00:1c.0: PME# disabled
[    0.970323] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.970326] pci 0000:00:1c.1: PME# disabled
[    0.970388] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.970391] pci 0000:00:1c.2: PME# disabled
[    0.970454] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.970457] pci 0000:00:1c.3: PME# disabled
[    0.970520] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.970523] pci 0000:00:1c.4: PME# disabled
[    0.970564] pci 0000:00:1d.0: reg 10: [mem 0xfbcf8000-0xfbcf83ff]
[    0.970630] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.970633] pci 0000:00:1d.0: PME# disabled
[    0.970816] pci 0000:00:1f.2: reg 10: [io  0xb880-0xb887]
[    0.970822] pci 0000:00:1f.2: reg 14: [io  0xb800-0xb803]
[    0.970829] pci 0000:00:1f.2: reg 18: [io  0xb480-0xb487]
[    0.970836] pci 0000:00:1f.2: reg 1c: [io  0xb400-0xb403]
[    0.970843] pci 0000:00:1f.2: reg 20: [io  0xb080-0xb09f]
[    0.970849] pci 0000:00:1f.2: reg 24: [mem 0xfbcf2000-0xfbcf27ff]
[    0.970879] pci 0000:00:1f.2: PME# supported from D3hot
[    0.970882] pci 0000:00:1f.2: PME# disabled
[    0.970907] pci 0000:00:1f.3: reg 10: [mem 0xfbcff800-0xfbcff8ff 64b=
it]
[    0.970926] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    0.970991] pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64b=
it pref]
[    0.971000] pci 0000:01:00.0: reg 18: [mem 0xfbde0000-0xfbdfffff 64b=
it]
[    0.971007] pci 0000:01:00.0: reg 20: [io  0xc000-0xc0ff]
[    0.971018] pci 0000:01:00.0: reg 30: [mem 0xfbdc0000-0xfbddffff pre=
f]
[    0.971034] pci 0000:01:00.0: supports D1 D2
[    0.971061] pci 0000:01:00.1: reg 10: [mem 0xfbdbc000-0xfbdbffff 64b=
it]
[    0.971102] pci 0000:01:00.1: supports D1 D2
[    0.971116] pci 0000:00:03.0: PCI bridge to [bus 01-01]
[    0.971120] pci 0000:00:03.0:   bridge window [io  0xc000-0xcfff]
[    0.971123] pci 0000:00:03.0:   bridge window [mem 0xfbd00000-0xfbdf=
ffff]
[    0.971126] pci 0000:00:03.0:   bridge window [mem
0xd0000000-0xdfffffff 64bit pref]
[    0.971161] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.971166] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (d=
isabled)
[    0.971169] pci 0000:00:1c.0:   bridge window [mem
0xfff00000-0x000fffff] (disabled)
[    0.971174] pci 0000:00:1c.0:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.971305] pci 0000:03:00.0: reg 24: [mem 0xfbefe000-0xfbefffff]
[    0.971346] pci 0000:03:00.0: PME# supported from D3hot
[    0.971350] pci 0000:03:00.0: PME# disabled
[    0.971396] pci 0000:03:00.1: reg 10: [io  0xdc00-0xdc07]
[    0.971409] pci 0000:03:00.1: reg 14: [io  0xd880-0xd883]
[    0.971421] pci 0000:03:00.1: reg 18: [io  0xd800-0xd807]
[    0.971434] pci 0000:03:00.1: reg 1c: [io  0xd480-0xd483]
[    0.971446] pci 0000:03:00.1: reg 20: [io  0xd400-0xd40f]
[    0.971512] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe
device.  You can enable it with 'pcie_aspm=3Dforce'
[    0.971517] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.971522] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.971525] pci 0000:00:1c.1:   bridge window [mem 0xfbe00000-0xfbef=
ffff]
[    0.971529] pci 0000:00:1c.1:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.971564] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
[    0.971569] pci 0000:00:1c.2:   bridge window [io  0xf000-0x0000] (d=
isabled)
[    0.971572] pci 0000:00:1c.2:   bridge window [mem
0xfff00000-0x000fffff] (disabled)
[    0.971577] pci 0000:00:1c.2:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.971612] pci 0000:00:1c.3: PCI bridge to [bus 05-05]
[    0.971616] pci 0000:00:1c.3:   bridge window [io  0xf000-0x0000] (d=
isabled)
[    0.971619] pci 0000:00:1c.3:   bridge window [mem
0xfff00000-0x000fffff] (disabled)
[    0.971624] pci 0000:00:1c.3:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.971659] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    0.971664] pci 0000:00:1c.4:   bridge window [io  0xf000-0x0000] (d=
isabled)
[    0.971667] pci 0000:00:1c.4:   bridge window [mem
0xfff00000-0x000fffff] (disabled)
[    0.971672] pci 0000:00:1c.4:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.971720] pci 0000:07:06.0: reg 10: [mem 0xfbfff800-0xfbffffff]
[    0.971729] pci 0000:07:06.0: reg 14: [io  0xec00-0xec7f]
[    0.971785] pci 0000:07:06.0: supports D2
[    0.971787] pci 0000:07:06.0: PME# supported from D2 D3hot D3cold
[    0.971790] pci 0000:07:06.0: PME# disabled
[    0.971823] pci 0000:00:1e.0: PCI bridge to [bus 07-07] (subtractive=
 decode)
[    0.971828] pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
[    0.971831] pci 0000:00:1e.0:   bridge window [mem 0xfbf00000-0xfbff=
ffff]
[    0.971836] pci 0000:00:1e.0:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.971838] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7]
(subtractive decode)
[    0.971839] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
[    0.971841] pci 0000:00:1e.0:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
[    0.971843] pci 0000:00:1e.0:   bridge window [mem
0x000d0000-0x000dffff] (subtractive decode)
[    0.971844] pci 0000:00:1e.0:   bridge window [mem
0xc0000000-0xdfffffff] (subtractive decode)
[    0.971846] pci 0000:00:1e.0:   bridge window [mem
0xf0000000-0xfed8ffff] (subtractive decode)
[    0.971871] pci_bus 0000:00: on NUMA node 0
[    0.971873] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.971979] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR1E._PRT]
[    0.972012] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR20._PRT]
[    0.972033] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR21._PRT]
[    0.972060] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR22._PRT]
[    0.972081] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR23._PRT]
[    0.972102] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR24._PRT]
[    0.979937] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 =
14 15)
[    0.979980] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[    0.980018] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 *11 12 =
14 15)
[    0.980059] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 1=
4 *15)
[    0.980100] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 *=
14 15)
[    0.980140] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12
14 15) *0, disabled.
[    0.980183] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 6 7 10 11 12 =
14 15)
[    0.980224] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 *7 10 11 12 =
14 15)
[    0.980262] HEST: Table is not found!
[    0.980407] SCSI subsystem initialized
[    0.980420] libata version 3.00 loaded.
[    0.980464] usbcore: registered new interface driver usbfs
[    0.980504] usbcore: registered new interface driver hub
[    0.980531] usbcore: registered new device driver usb
[    0.980649] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.980652] PCI: Using ACPI for IRQ routing
[    0.980655] PCI: pci_cache_line_size set to 64 bytes
[    0.980718] reserve RAM buffer: 000000000009dc00 - 000000000009ffff
[    0.980720] reserve RAM buffer: 00000000bf780000 - 00000000bfffffff
[    0.980824]   alloc irq_desc for 40 on node 0
[    0.980826]   alloc kstat_irqs on node 0
[    0.980831]   alloc irq_desc for 41 on node 0
[    0.980832]   alloc kstat_irqs on node 0
[    0.980835]   alloc irq_desc for 42 on node 0
[    0.980836]   alloc kstat_irqs on node 0
[    0.980839]   alloc irq_desc for 43 on node 0
[    0.980840]   alloc kstat_irqs on node 0
[    0.980844]   alloc irq_desc for 44 on node 0
[    0.980845]   alloc kstat_irqs on node 0
[    0.980847] HPET: 8 timers in total, 5 timers will be used for per-c=
pu timer
[    0.980856] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 40, 41, 42, 43, 44=
, 0
[    0.980863] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.983779] hpet: hpet2 irq 40 for MSI
[    0.983878] hpet: hpet3 irq 41 for MSI
[    0.984888] hpet: hpet4 irq 42 for MSI
[    0.985882] hpet: hpet5 irq 43 for MSI
[    0.986887] hpet: hpet6 irq 44 for MSI
[    0.990871] Switching to clocksource tsc
[    0.990940] pnp: PnP ACPI init
[    0.990948] ACPI: bus type pnp registered
[    0.993389] pnp: PnP ACPI: found 16 devices
[    0.993392] ACPI: ACPI bus type pnp unregistered
[    0.993401] system 00:01: [mem 0xfc000000-0xfcffffff] has been reser=
ved
[    0.993405] system 00:01: [mem 0xfd000000-0xfdffffff] has been reser=
ved
[    0.993409] system 00:01: [mem 0xfe000000-0xfebfffff] has been reser=
ved
[    0.993412] system 00:01: [mem 0xfed14000-0xfed19fff] has been reser=
ved
[    0.993419] system 00:08: [io  0x0a00-0x0a0f] has been reserved
[    0.993422] system 00:08: [io  0x0a10-0x0a1f] has been reserved
[    0.993426] system 00:08: [io  0x0a20-0x0a2f] has been reserved
[    0.993429] system 00:08: [io  0x0a30-0x0a3f] has been reserved
[    0.993434] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.993438] system 00:09: [io  0x0800-0x087f] has been reserved
[    0.993441] system 00:09: [io  0x0500-0x057f] has been reserved
[    0.993445] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reser=
ved
[    0.993449] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reser=
ved
[    0.993452] system 00:09: [mem 0xfed40000-0xfed8ffff] has been reser=
ved
[    0.993458] system 00:0c: [mem 0xffc00000-0xffefffff] has been reser=
ved
[    0.993463] system 00:0d: [mem 0xfec00000-0xfec00fff] could not be r=
eserved
[    0.993467] system 00:0d: [mem 0xfee00000-0xfee00fff] has been reser=
ved
[    0.993472] system 00:0e: [mem 0xe0000000-0xefffffff] has been reser=
ved
[    0.993479] system 00:0f: [mem 0x00000000-0x0009ffff] could not be r=
eserved
[    0.993482] system 00:0f: [mem 0x000c0000-0x000cffff] has been reser=
ved
[    0.993486] system 00:0f: [mem 0x000e0000-0x000fffff] could not be r=
eserved
[    0.993490] system 00:0f: [mem 0x00100000-0xbfffffff] could not be r=
eserved
[    0.993494] system 00:0f: [mem 0xfed90000-0xffffffff] could not be r=
eserved
[    0.999900] pci 0000:00:1c.0: BAR 8: assigned [mem 0xc0000000-0xc01f=
ffff]
[    0.999906] pci 0000:00:1c.0: BAR 9: assigned [mem
0xc0200000-0xc03fffff 64bit pref]
[    0.999911] pci 0000:00:1c.1: BAR 9: assigned [mem
0xc0400000-0xc05fffff 64bit pref]
[    0.999915] pci 0000:00:1c.2: BAR 8: assigned [mem 0xc0600000-0xc07f=
ffff]
[    0.999919] pci 0000:00:1c.2: BAR 9: assigned [mem
0xc0800000-0xc09fffff 64bit pref]
[    0.999923] pci 0000:00:1c.3: BAR 8: assigned [mem 0xc0a00000-0xc0bf=
ffff]
[    0.999927] pci 0000:00:1c.3: BAR 9: assigned [mem
0xc0c00000-0xc0dfffff 64bit pref]
[    0.999931] pci 0000:00:1c.4: BAR 8: assigned [mem 0xc0e00000-0xc0ff=
ffff]
[    0.999935] pci 0000:00:1c.4: BAR 9: assigned [mem
0xc1000000-0xc11fffff 64bit pref]
[    0.999940] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
[    0.999943] pci 0000:00:1c.2: BAR 7: assigned [io  0x2000-0x2fff]
[    0.999947] pci 0000:00:1c.3: BAR 7: assigned [io  0x3000-0x3fff]
[    0.999951] pci 0000:00:1c.4: BAR 7: assigned [io  0x4000-0x4fff]
[    0.999954] pci 0000:00:03.0: PCI bridge to [bus 01-01]
[    0.999958] pci 0000:00:03.0:   bridge window [io  0xc000-0xcfff]
[    0.999963] pci 0000:00:03.0:   bridge window [mem 0xfbd00000-0xfbdf=
ffff]
[    0.999967] pci 0000:00:03.0:   bridge window [mem
0xd0000000-0xdfffffff 64bit pref]
[    0.999973] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.999977] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.999982] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01f=
ffff]
[    0.999987] pci 0000:00:1c.0:   bridge window [mem
0xc0200000-0xc03fffff 64bit pref]
[    0.999994] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.999998] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    1.000004] pci 0000:00:1c.1:   bridge window [mem 0xfbe00000-0xfbef=
ffff]
[    1.000009] pci 0000:00:1c.1:   bridge window [mem
0xc0400000-0xc05fffff 64bit pref]
[    1.000016] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
[    1.000019] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
[    1.000025] pci 0000:00:1c.2:   bridge window [mem 0xc0600000-0xc07f=
ffff]
[    1.000030] pci 0000:00:1c.2:   bridge window [mem
0xc0800000-0xc09fffff 64bit pref]
[    1.000036] pci 0000:00:1c.3: PCI bridge to [bus 05-05]
[    1.000040] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    1.000045] pci 0000:00:1c.3:   bridge window [mem 0xc0a00000-0xc0bf=
ffff]
[    1.000050] pci 0000:00:1c.3:   bridge window [mem
0xc0c00000-0xc0dfffff 64bit pref]
[    1.000057] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    1.000061] pci 0000:00:1c.4:   bridge window [io  0x4000-0x4fff]
[    1.000066] pci 0000:00:1c.4:   bridge window [mem 0xc0e00000-0xc0ff=
ffff]
[    1.000071] pci 0000:00:1c.4:   bridge window [mem
0xc1000000-0xc11fffff 64bit pref]
[    1.000078] pci 0000:00:1e.0: PCI bridge to [bus 07-07]
[    1.000082] pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
[    1.000087] pci 0000:00:1e.0:   bridge window [mem 0xfbf00000-0xfbff=
ffff]
[    1.000092] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.000103]   alloc irq_desc for 16 on node -1
[    1.000104]   alloc kstat_irqs on node -1
[    1.000107] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IR=
Q 16
[    1.000112] pci 0000:00:03.0: setting latency timer to 64
[    1.000118] pci 0000:00:1c.0: enabling device (0104 -> 0107)
[    1.000122]   alloc irq_desc for 17 on node -1
[    1.000123]   alloc kstat_irqs on node -1
[    1.000126] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IR=
Q 17
[    1.000130] pci 0000:00:1c.0: setting latency timer to 64
[    1.000136] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IR=
Q 16
[    1.000141] pci 0000:00:1c.1: setting latency timer to 64
[    1.000147] pci 0000:00:1c.2: enabling device (0104 -> 0107)
[    1.000151]   alloc irq_desc for 18 on node -1
[    1.000152]   alloc kstat_irqs on node -1
[    1.000154] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IR=
Q 18
[    1.000159] pci 0000:00:1c.2: setting latency timer to 64
[    1.000165] pci 0000:00:1c.3: enabling device (0104 -> 0107)
[    1.000168]   alloc irq_desc for 19 on node -1
[    1.000169]   alloc kstat_irqs on node -1
[    1.000172] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IR=
Q 19
[    1.000177] pci 0000:00:1c.3: setting latency timer to 64
[    1.000182] pci 0000:00:1c.4: enabling device (0104 -> 0107)
[    1.000187] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IR=
Q 17
[    1.000191] pci 0000:00:1c.4: setting latency timer to 64
[    1.000196] pci 0000:00:1e.0: setting latency timer to 64
[    1.000199] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.000200] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.000202] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.000203] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    1.000205] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xdfffffff]
[    1.000206] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfed8ffff]
[    1.000208] pci_bus 0000:01: resource 0 [io  0xc000-0xcfff]
[    1.000209] pci_bus 0000:01: resource 1 [mem 0xfbd00000-0xfbdfffff]
[    1.000211] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff
64bit pref]
[    1.000212] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    1.000214] pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc01fffff]
[    1.000215] pci_bus 0000:02: resource 2 [mem 0xc0200000-0xc03fffff
64bit pref]
[    1.000217] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    1.000218] pci_bus 0000:03: resource 1 [mem 0xfbe00000-0xfbefffff]
[    1.000220] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff
64bit pref]
[    1.000222] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    1.000223] pci_bus 0000:04: resource 1 [mem 0xc0600000-0xc07fffff]
[    1.000225] pci_bus 0000:04: resource 2 [mem 0xc0800000-0xc09fffff
64bit pref]
[    1.000226] pci_bus 0000:05: resource 0 [io  0x3000-0x3fff]
[    1.000228] pci_bus 0000:05: resource 1 [mem 0xc0a00000-0xc0bfffff]
[    1.000229] pci_bus 0000:05: resource 2 [mem 0xc0c00000-0xc0dfffff
64bit pref]
[    1.000231] pci_bus 0000:06: resource 0 [io  0x4000-0x4fff]
[    1.000232] pci_bus 0000:06: resource 1 [mem 0xc0e00000-0xc0ffffff]
[    1.000234] pci_bus 0000:06: resource 2 [mem 0xc1000000-0xc11fffff
64bit pref]
[    1.000235] pci_bus 0000:07: resource 0 [io  0xe000-0xefff]
[    1.000237] pci_bus 0000:07: resource 1 [mem 0xfbf00000-0xfbffffff]
[    1.000238] pci_bus 0000:07: resource 4 [io  0x0000-0x0cf7]
[    1.000240] pci_bus 0000:07: resource 5 [io  0x0d00-0xffff]
[    1.000241] pci_bus 0000:07: resource 6 [mem 0x000a0000-0x000bffff]
[    1.000243] pci_bus 0000:07: resource 7 [mem 0x000d0000-0x000dffff]
[    1.000244] pci_bus 0000:07: resource 8 [mem 0xc0000000-0xdfffffff]
[    1.000246] pci_bus 0000:07: resource 9 [mem 0xf0000000-0xfed8ffff]
[    1.000285] NET: Registered protocol family 2
[    1.000335] IP route cache hash table entries: 262144 (order: 9,
2097152 bytes)
[    1.000669] TCP established hash table entries: 262144 (order: 10,
4194304 bytes)
[    1.001759] TCP bind hash table entries: 65536 (order: 9, 2097152 by=
tes)
[    1.002200] TCP: Hash tables configured (established 262144 bind 655=
36)
[    1.002204] TCP reno registered
[    1.002211] UDP hash table entries: 4096 (order: 6, 393216 bytes)
[    1.002295] UDP-Lite hash table entries: 4096 (order: 6, 393216 byte=
s)
[    1.002453] NET: Registered protocol family 1
[    1.002529] RPC: Registered udp transport module.
[    1.002532] RPC: Registered tcp transport module.
[    1.002534] RPC: Registered tcp NFSv4.1 backchannel transport module=
=2E
[    1.002606] pci 0000:01:00.0: Boot video device
[    1.002617] PCI: CLS 32 bytes, default 64
[    1.012488] Trying to unpack rootfs image as initramfs...
[    1.063737] Freeing initrd memory: 3176k freed
[    1.064087] PCI-DMA: Using software bounce buffering for IO (SWIOTLB=
)
[    1.064092] Placing 64MB software IO TLB between ffff880008200000 -
ffff88000c200000
[    1.064096] software IO TLB at phys 0x8200000 - 0xc200000
[    1.065672] microcode: CPU0 sig=3D0x106e5, pf=3D0x2, revision=3D0x3
[    1.065680] microcode: CPU1 sig=3D0x106e5, pf=3D0x2, revision=3D0x3
[    1.065688] microcode: CPU2 sig=3D0x106e5, pf=3D0x2, revision=3D0x3
[    1.065695] microcode: CPU3 sig=3D0x106e5, pf=3D0x2, revision=3D0x3
[    1.065703] microcode: CPU4 sig=3D0x106e5, pf=3D0x2, revision=3D0x3
[    1.065711] microcode: CPU5 sig=3D0x106e5, pf=3D0x2, revision=3D0x3
[    1.065717] microcode: CPU6 sig=3D0x106e5, pf=3D0x2, revision=3D0x3
[    1.065724] microcode: CPU7 sig=3D0x106e5, pf=3D0x2, revision=3D0x3
[    1.065754] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.065766] Scanning for low memory corruption every 60 seconds
[    1.065851] Intel AES-NI instructions are not detected.
[    1.065854] Intel PCLMULQDQ-NI instructions are not detected.
[    1.066196] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.066364] VFS: Disk quotas dquot_6.5.2
[    1.066393] Dquot-cache hash table entries: 512 (order 0, 4096 bytes=
)
[    1.066565] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.066675] fuse init (API version 7.15)
[    1.066791] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[    1.067912] SGI XFS with ACLs, security attributes, realtime, large
block/inode numbers, no debug enabled
[    1.068092] SGI XFS Quota Management subsystem
[    1.068192] Btrfs loaded
[    1.068196] msgmni has been set to 11918
[    1.068814] alg: No test for fcrypt (fcrypt-generic)
[    1.070044] alg: No test for stdrng (krng)
[    1.070067] async_tx: api initialized (async)
[    1.070103] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    1.070108] io scheduler noop registered
[    1.070110] io scheduler deadline registered (default)
[    1.070126] io scheduler cfq registered
[    1.071557] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.072222] vesafb: framebuffer at 0xd0000000, mapped to
0xffffc90010780000, using 5120k, total 16384k
[    1.072227] vesafb: mode is 1280x1024x16, linelength=3D2560, pages=3D=
5
[    1.072230] vesafb: scrolling: redraw
[    1.072233] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[    1.075837] Console: switching to colour frame buffer device 160x64
[    1.077207] fb0: VESA VGA frame buffer device
[    1.077253] intel_idle: MWAIT substates: 0x1120
[    1.077254] intel_idle: v0.4 model 0x1E
[    1.077255] intel_idle: lapic_timer_reliable_states 0x2
[    1.077512] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.077533] ACPI: Power Button [PWRB]
[    1.077587] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.077605] ACPI: Power Button [PWRF]
[    1.077791] ACPI: acpi_idle yielding to intel_idle
[    1.080443] ERST: Table is not found!
[    1.080686] Linux agpgart interface v0.103
[    1.080799] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180
seconds, margin is 60 seconds).
[    1.080819] Hangcheck: Using getrawmonotonic().
[    1.080833] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.082260] brd: module loaded
[    1.082402] Loading iSCSI transport class v2.0-870.
[    1.082590] SCSI Media Changer driver v0.25
[    1.082647] ahci 0000:00:1f.2: version 3.0
[    1.082657] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> I=
RQ 19
[    1.082697]   alloc irq_desc for 45 on node -1
[    1.082699]   alloc kstat_irqs on node -1
[    1.082706] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    1.082728] ahci: SSS flag set, parallel bus scan disabled
[    1.093750] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3
Gbps 0x3f impl SATA mode
[    1.093770] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led
clo pio slum part ems sxs apst
[    1.093791] ahci 0000:00:1f.2: setting latency timer to 64
[    1.103753] scsi0 : ahci
[    1.103849] scsi1 : ahci
[    1.103919] scsi2 : ahci
[    1.103990] scsi3 : ahci
[    1.104061] scsi4 : ahci
[    1.104131] scsi5 : ahci
[    1.104255] ata1: SATA max UDMA/133 abar m2048@0xfbcf2000 port
0xfbcf2100 irq 45
[    1.104274] ata2: SATA max UDMA/133 irq_stat 0x00400040, connection
status changed irq 45
[    1.104292] ata3: SATA max UDMA/133 irq_stat 0x00400040, connection
status changed irq 45
[    1.104310] ata4: SATA max UDMA/133 irq_stat 0x00400040, connection
status changed irq 45
[    1.104329] ata5: SATA max UDMA/133 irq_stat 0x00400040, connection
status changed irq 45
[    1.104347] ata6: SATA max UDMA/133 irq_stat 0x00400040, connection
status changed irq 45
[    1.104387] ahci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> I=
RQ 17
[    1.114713] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3
Gbps 0x3 impl SATA mode
[    1.114738] ahci 0000:03:00.0: flags: 64bit ncq led clo pmp pio
[    1.114756] ahci 0000:03:00.0: setting latency timer to 64
[    1.114838] scsi6 : ahci
[    1.114923] scsi7 : ahci
[    1.116223] ata7: SATA max UDMA/133 abar m8192@0xfbefe000 port
0xfbefe100 irq 17
[    1.117457] ata8: SATA max UDMA/133 abar m8192@0xfbefe000 port
0xfbefe180 irq 17
[    1.119341] pata_jmicron 0000:03:00.1: enabling device (0000 -> 0001=
)
[    1.120566] pata_jmicron 0000:03:00.1: PCI INT B -> GSI 18 (level,
low) -> IRQ 18
[    1.121797] pata_jmicron 0000:03:00.1: setting latency timer to 64
[    1.121843] scsi8 : pata_jmicron
[    1.123148] scsi9 : pata_jmicron
[    1.124710] ata9: PATA max UDMA/100 cmd 0xdc00 ctl 0xd880 bmdma 0xd4=
00 irq 18
[    1.125969] ata10: PATA max UDMA/100 cmd 0xd800 ctl 0xd480 bmdma
0xd408 irq 18
[    1.127755] tun: Universal TUN/TAP device driver, 1.6
[    1.129021] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.130387] uhci_hcd: USB Universal Host Controller Interface driver
[    1.131722] usbcore: registered new interface driver wusb-cbaf
[    1.133019] usbcore: registered new interface driver libusual
[    1.134363] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at
0x60,0x64 irq 1,12
[    1.135988] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.137223] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.138549] mice: PS/2 mouse device common for all mice
[    1.139959] rtc_cmos 00:03: RTC can wake from S4
[    1.141247] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.142518] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet=
 irqs
[    1.143823] lirc_dev: IR Remote Control driver registered, major 251
[    1.145056] Linux video capture interface: v2.00
[    1.146353] md: linear personality registered for level -1
[    1.147614] md: raid0 personality registered for level 0
[    1.148872] md: raid1 personality registered for level 1
[    1.150114] md: raid10 personality registered for level 10
[    1.151351] md: raid6 personality registered for level 6
[    1.152575] md: raid5 personality registered for level 5
[    1.153800] md: raid4 personality registered for level 4
[    1.155010] md: multipath personality registered for level -4
[    1.156256] device-mapper: uevent: version 1.0.3
[    1.157521] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29)
initialised: dm-devel@redhat.com
[    1.158744] device-mapper: multipath: version 1.1.1 loaded
[    1.159912] device-mapper: multipath round-robin: version 1.0.0 load=
ed
[    1.161107] EDAC MC: Ver: 2.1.0 Dec  2 2010
[    1.162921] cpuidle: using governor ladder
[    1.165149] cpuidle: using governor menu
[    1.166406] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.168373] usbcore: registered new interface driver hiddev
[    1.169624] usbcore: registered new interface driver usbhid
[    1.170856] usbhid: USB HID core driver
[    1.174417]   alloc irq_desc for 22 on node -1
[    1.174419]   alloc kstat_irqs on node -1
[    1.174425] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[    1.175639]   alloc irq_desc for 46 on node -1
[    1.175641]   alloc kstat_irqs on node -1
[    1.175649] HDA Intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[    1.175668] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    1.188725] hda_codec: ALC888: BIOS auto-probing.
[    1.195353] HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
[    1.196518]   alloc irq_desc for 47 on node -1
[    1.196519]   alloc kstat_irqs on node -1
[    1.196530] HDA Intel 0000:01:00.1: irq 47 for MSI/MSI-X
[    1.196545] HDA Intel 0000:01:00.1: setting latency timer to 64
[    1.201174] ALSA device list:
[    1.202347]   #0: HDA Intel at 0xfbcf4000 irq 46
[    1.203534]   #1: HD-Audio Generic at 0xfbdbc000 irq 47
[    1.204934] TCP cubic registered
[    1.206125] Initializing XFRM netlink socket
[    1.207364] NET: Registered protocol family 10
[    1.208809] lo: Disabled Privacy Extensions
[    1.210176] IPv6 over IPv4 tunneling driver
[    1.211645] sit0: Disabled Privacy Extensions
[    1.212977] NET: Registered protocol family 17
[    1.214171] NET: Registered protocol family 15
[    1.215353] lib80211: common routines for IEEE802.11 drivers
[    1.216521] lib80211_crypt: registered algorithm 'NULL'
[    1.216523] Registering the dns_resolver key type
[    1.220032] registered taskstats version 1
[    1.221577] rtc_cmos 00:03: setting system clock to 2010-12-05
01:00:38 UTC (1291510838)
[    1.407270] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.410068] ata1.00: ATA-8: WDC WD1001FALS-00J7B0, 05.00K05, max UDM=
A/133
[    1.411737] ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 3=
1/32), AA
[    1.414711] ata1.00: configured for UDMA/133
[    1.421313] ata7: SATA link down (SStatus 0 SControl 300)
[    1.423054] ata8: SATA link down (SStatus 0 SControl 300)
[    1.427351] scsi 0:0:0:0: Direct-Access     ATA      WDC
WD1001FALS-0 05.0 PQ: 0 ANSI: 5
[    1.429035] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[    1.429639] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.432412] sd 0:0:0:0: [sda] Write Protect is off
[    1.434037] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.434066] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.448255]  sda: sda1 sda2 < sda5 >
[    1.450882] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.150918] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.154315] ata2.00: ATAPI: ATAPI   iHAS324   Y, BL1Y, max UDMA/100
[    2.158058] ata2.00: configured for UDMA/100
[    2.172159] scsi 1:0:0:0: CD-ROM            ATAPI    iHAS324   Y
  BL1Y PQ: 0 ANSI: 5
[    2.178984] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw
xa/form2 cdda tray
[    2.180793] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.183013] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.183263] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.906521] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.910285] ata3.00: ATA-8: WDC WD10EADS-22M2B0, 01.00A01, max UDMA/=
133
[    2.912039] ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 3=
1/32), AA
[    2.916802] ata3.00: configured for UDMA/133
[    2.929597] scsi 2:0:0:0: Direct-Access     ATA      WDC
WD10EADS-22M 01.0 PQ: 0 ANSI: 5
[    2.932097] sd 2:0:0:0: [sdb] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[    2.932315] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    2.935905] sd 2:0:0:0: [sdb] Write Protect is off
[    2.937750] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.937778] sd 2:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.959664]  sdb: sdb1 sdb2 < sdb5 >
[    2.962264] sd 2:0:0:0: [sdb] Attached SCSI disk
[    3.654159] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.659099] ata4.00: ATAPI: HL-DT-ST DVDRAM GH41N, MN01, max UDMA/10=
0
[    3.664512] ata4.00: configured for UDMA/100
[    3.684402] scsi 3:0:0:0: CD-ROM            HL-DT-ST DVDRAM GH41N
  MN01 PQ: 0 ANSI: 5
[    3.708124] sr1: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw
xa/form2 cdda tray
[    3.710457] sr 3:0:0:0: Attached scsi CD-ROM sr1
[    3.710714] sr 3:0:0:0: Attached scsi generic sg3 type 5
[    4.433762] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.442378] ata5.00: ATA-7: SAMSUNG HD154UI, 1AG01118, max UDMA7
[    4.444363] ata5.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 3=
1/32), AA
[    4.453155] ata5.00: configured for UDMA/133
[    4.465797] scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG
HD154UI  1AG0 PQ: 0 ANSI: 5
[    4.468444] sd 4:0:0:0: [sdc] 2930277168 512-byte logical blocks:
(1.50 TB/1.36 TiB)
[    4.468743] sd 4:0:0:0: Attached scsi generic sg4 type 0
[    4.472475] sd 4:0:0:0: [sdc] Write Protect is off
[    4.474387] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    4.474414] sd 4:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    4.578267]  sdc: sdc1 sdc2 sdc3 sdc4 < sdc5 sdc6 sdc7 sdc8 sdc9 >
[    4.581629] sd 4:0:0:0: [sdc] Attached SCSI disk
[    5.190426] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.198462] ata6.00: ATA-8: SAMSUNG HD203WI, 1AN10003, max UDMA/133
[    5.200472] ata6.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 3=
1/32), AA
[    5.208528] ata6.00: configured for UDMA/133
[    5.220365] scsi 5:0:0:0: Direct-Access     ATA      SAMSUNG
HD203WI  1AN1 PQ: 0 ANSI: 5
[    5.223019] sd 5:0:0:0: [sdd] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    5.223153] sd 5:0:0:0: Attached scsi generic sg5 type 0
[    5.227355] sd 5:0:0:0: [sdd] Write Protect is off
[    5.229433] sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    5.229461] sd 5:0:0:0: [sdd] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    5.339571]  sdd: sdd1 sdd2 sdd3 < sdd5 sdd6 sdd7 sdd8 sdd9 sdd10 sd=
d11 >
[    5.342714] sd 5:0:0:0: [sdd] Attached SCSI disk
[    5.385840] Freeing unused kernel memory: 548k freed
[    5.388112] Write protecting the kernel read-only data: 12288k
[    5.390774] Freeing unused kernel memory: 852k freed
[    5.393234] Freeing unused kernel memory: 1472k freed
[    6.177325] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driv=
er
[    6.177329] Warning! ehci_hcd should always be loaded before
uhci_hcd and ohci_hcd, not after
[    6.177334] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    6.177382] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) =
-> IRQ 16
[    6.177444] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    6.177449] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    6.177477] drivers/usb/core/inode.c: creating file 'devices'
[    6.177482] drivers/usb/core/inode.c: creating file '001'
[    6.177754] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned
bus number 1
[    6.177769] ehci_hcd 0000:00:1a.0: reset hcs_params 0x200002 dbg=3D2
cc=3D0 pcc=3D0 ordered !ppc ports=3D2
[    6.177775] ehci_hcd 0000:00:1a.0: reset hcc_params 36881 caching
frame 1024 64 bit addr
[    6.177797] ehci_hcd 0000:00:1a.0: support lpm
[    6.177810] ehci_hcd 0000:00:1a.0: debug port 2
[    6.177816] ehci_hcd 0000:00:1a.0: reset command 0080002 (park)=3D0
ithresh=3D8 period=3D1024 Reset HALT
[    6.181704] ehci_hcd 0000:00:1a.0: cache line size of 32 is not supp=
orted
[    6.181708] ehci_hcd 0000:00:1a.0: supports USB remote wakeup
[    6.181734] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xfbcfa000
[    6.181740] ehci_hcd 0000:00:1a.0: reset command 0080002 (park)=3D0
ithresh=3D8 period=3D1024 Reset HALT
[    6.185618] ehci_hcd 0000:00:1a.0: init command 0010001 (park)=3D0
ithresh=3D1 period=3D1024 RUN
[    6.191604] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    6.191644] usb usb1: default language 0x0409
[    6.191655] usb usb1: udev 1, busnum 1, minor =3D 0
[    6.191658] usb usb1: New USB device found, idVendor=3D1d6b, idProdu=
ct=3D0002
[    6.191662] usb usb1: New USB device strings: Mfr=3D3, Product=3D2,
SerialNumber=3D1
[    6.191665] usb usb1: Product: EHCI Host Controller
[    6.191668] usb usb1: Manufacturer: Linux
2.6.36-rc6_bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc+ ehci_hcd
[    6.191672] usb usb1: SerialNumber: 0000:00:1a.0
[    6.191916] usb usb1: usb_probe_device
[    6.191921] usb usb1: configuration #1 chosen from 1 choice
[    6.191933] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    6.192165] hub 1-0:1.0: usb_probe_interface
[    6.192169] hub 1-0:1.0: usb_probe_interface - got id
[    6.192173] hub 1-0:1.0: USB hub found
[    6.192180] hub 1-0:1.0: 2 ports detected
[    6.192183] hub 1-0:1.0: standalone hub
[    6.192185] hub 1-0:1.0: no power switching (usb 1.0)
[    6.192188] hub 1-0:1.0: individual port over-current protection
[    6.192191] hub 1-0:1.0: power on to power good time: 20ms
[    6.192197] hub 1-0:1.0: local power source is good
[    6.192200] hub 1-0:1.0: trying to enable port power on non-switchab=
le hub
[    6.192409] drivers/usb/core/inode.c: creating file '001'
[    6.192486]   alloc irq_desc for 23 on node -1
[    6.192489]   alloc kstat_irqs on node -1
[    6.192497] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) =
-> IRQ 23
[    6.192516] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    6.192521] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    6.192532] drivers/usb/core/inode.c: creating file '002'
[    6.192782] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 2
[    6.192796] ehci_hcd 0000:00:1d.0: reset hcs_params 0x200002 dbg=3D2
cc=3D0 pcc=3D0 ordered !ppc ports=3D2
[    6.192801] ehci_hcd 0000:00:1d.0: reset hcc_params 36881 caching
frame 1024 64 bit addr
[    6.192819] ehci_hcd 0000:00:1d.0: support lpm
[    6.192832] ehci_hcd 0000:00:1d.0: debug port 2
[    6.192838] ehci_hcd 0000:00:1d.0: reset command 0080002 (park)=3D0
ithresh=3D8 period=3D1024 Reset HALT
[    6.196713] ehci_hcd 0000:00:1d.0: cache line size of 32 is not supp=
orted
[    6.196716] ehci_hcd 0000:00:1d.0: supports USB remote wakeup
[    6.196737] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xfbcf8000
[    6.196743] ehci_hcd 0000:00:1d.0: reset command 0080002 (park)=3D0
ithresh=3D8 period=3D1024 Reset HALT
[    6.200645] ehci_hcd 0000:00:1d.0: init command 0010001 (park)=3D0
ithresh=3D1 period=3D1024 RUN
[    6.206613] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    6.206647] usb usb2: default language 0x0409
[    6.206657] usb usb2: udev 1, busnum 2, minor =3D 128
[    6.206661] usb usb2: New USB device found, idVendor=3D1d6b, idProdu=
ct=3D0002
[    6.206665] usb usb2: New USB device strings: Mfr=3D3, Product=3D2,
SerialNumber=3D1
[    6.206668] usb usb2: Product: EHCI Host Controller
[    6.206672] usb usb2: Manufacturer: Linux
2.6.36-rc6_bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc+ ehci_hcd
[    6.206675] usb usb2: SerialNumber: 0000:00:1d.0
[    6.206970] usb usb2: usb_probe_device
[    6.206976] usb usb2: configuration #1 chosen from 1 choice
[    6.206989] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    6.207247] hub 2-0:1.0: usb_probe_interface
[    6.207252] hub 2-0:1.0: usb_probe_interface - got id
[    6.207257] hub 2-0:1.0: USB hub found
[    6.207265] hub 2-0:1.0: 2 ports detected
[    6.207267] hub 2-0:1.0: standalone hub
[    6.207270] hub 2-0:1.0: no power switching (usb 1.0)
[    6.207272] hub 2-0:1.0: individual port over-current protection
[    6.207276] hub 2-0:1.0: power on to power good time: 20ms
[    6.207282] hub 2-0:1.0: local power source is good
[    6.207285] hub 2-0:1.0: trying to enable port power on non-switchab=
le hub
[    6.207543] drivers/usb/core/inode.c: creating file '001'
[    6.239335] Initializing USB Mass Storage driver...
[    6.239500] usbcore: registered new interface driver usb-storage
[    6.239504] USB Mass Storage support registered.
[    6.281096] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    6.281101] ohci_hcd: block sizes: ed 80 td 96
[    6.291277] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001803 0
 ACK POWER sig=3Dj CSC CONNECT
[    6.291284] hub 1-0:1.0: port 1: status 0501 change 0001
[    6.306450] sl811: driver sl811-hcd, 19 May 2005
[    6.307260] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001803 0
 ACK POWER sig=3Dj CSC CONNECT
[    6.307267] hub 2-0:1.0: port 1: status 0501 change 0001
[    6.391098] hub 1-0:1.0: state 7 ports 2 chg 0002 evt 0000
[    6.391111] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    6.409005] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21=
-k6-NAPI
[    6.409009] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    6.442327] ehci_hcd 0000:00:1a.0: port 1 high speed
[    6.442336] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001005 0
 ACK POWER sig=3Dse0 PE CONNECT
[    6.493028] usb 1-1: new high speed USB device using ehci_hcd and ad=
dress 2
[    6.544151] ehci_hcd 0000:00:1a.0: port 1 high speed
[    6.544160] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001005 0
 ACK POWER sig=3Dse0 PE CONNECT
[    6.606965] ehci_hcd 0000:00:1a.0: set dev address 2 for port 1
[    6.606971] ehci_hcd 0000:00:1a.0: LPM: no device attached
[    6.607252] usb 1-1: udev 2, busnum 1, minor =3D 1
[    6.607257] usb 1-1: New USB device found, idVendor=3D8087, idProduc=
t=3D0020
[    6.607261] usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, S=
erialNumber=3D0
[    6.607534] usb 1-1: usb_probe_device
[    6.607540] usb 1-1: configuration #1 chosen from 1 choice
[    6.607746] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    6.607997] hub 1-1:1.0: usb_probe_interface
[    6.608002] hub 1-1:1.0: usb_probe_interface - got id
[    6.608006] hub 1-1:1.0: USB hub found
[    6.608060] hub 1-1:1.0: 6 ports detected
[    6.608063] hub 1-1:1.0: standalone hub
[    6.608066] hub 1-1:1.0: individual port power switching
[    6.608068] hub 1-1:1.0: individual port over-current protection
[    6.608071] hub 1-1:1.0: Single TT
[    6.608074] hub 1-1:1.0: TT requires at most 8 FS bit times (666 ns)
[    6.608077] hub 1-1:1.0: Port indicators are supported
[    6.608080] hub 1-1:1.0: power on to power good time: 100ms
[    6.608337] hub 1-1:1.0: local power source is good
[    6.608341] hub 1-1:1.0: enabling power on all ports
[    6.609369] drivers/usb/core/inode.c: creating file '002'
[    6.609406] hub 2-0:1.0: state 7 ports 2 chg 0002 evt 0000
[    6.609417] hub 2-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    6.659951] ehci_hcd 0000:00:1d.0: port 1 high speed
[    6.659958] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001005 0
 ACK POWER sig=3Dse0 PE CONNECT
[    6.708790] hub 1-1:1.0: port 1: status 0101 change 0001
[    6.709043] hub 1-1:1.0: port 2: status 0101 change 0001
[    6.709412] hub 1-1:1.0: port 4: status 0101 change 0001
[    6.710611] usb 2-1: new high speed USB device using ehci_hcd and ad=
dress 2
[    6.761776] ehci_hcd 0000:00:1d.0: port 1 high speed
[    6.761785] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001005 0
 ACK POWER sig=3Dse0 PE CONNECT
[    6.809517] usb 1-1: link qh256-0001/ffff8801bc2679c0 start 1 [1/0 u=
s]
[    6.824464] ehci_hcd 0000:00:1d.0: set dev address 2 for port 1
[    6.824471] ehci_hcd 0000:00:1d.0: LPM: no device attached
[    6.824713] usb 2-1: udev 2, busnum 2, minor =3D 129
[    6.824717] usb 2-1: New USB device found, idVendor=3D8087, idProduc=
t=3D0020
[    6.824721] usb 2-1: New USB device strings: Mfr=3D0, Product=3D0, S=
erialNumber=3D0
[    6.825088] usb 2-1: usb_probe_device
[    6.825093] usb 2-1: configuration #1 chosen from 1 choice
[    6.825251] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[    6.825566] hub 2-1:1.0: usb_probe_interface
[    6.825570] hub 2-1:1.0: usb_probe_interface - got id
[    6.825574] hub 2-1:1.0: USB hub found
[    6.825712] hub 2-1:1.0: 8 ports detected
[    6.825715] hub 2-1:1.0: standalone hub
[    6.825718] hub 2-1:1.0: individual port power switching
[    6.825720] hub 2-1:1.0: individual port over-current protection
[    6.825723] hub 2-1:1.0: Single TT
[    6.825726] hub 2-1:1.0: TT requires at most 8 FS bit times (666 ns)
[    6.825729] hub 2-1:1.0: Port indicators are supported
[    6.825732] hub 2-1:1.0: power on to power good time: 100ms
[    6.825996] hub 2-1:1.0: local power source is good
[    6.826001] hub 2-1:1.0: enabling power on all ports
[    6.827213] drivers/usb/core/inode.c: creating file '002'
[    6.827254] hub 1-1:1.0: state 7 ports 6 chg 0016 evt 0000
[    6.827319] hub 1-1:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    6.889515] usb 1-1.1: new low speed USB device using ehci_hcd and a=
ddress 3
[    6.901453] hub 1-1:1.0: port 1 not reset yet, waiting 10ms
[    6.927415] hub 2-1:1.0: port 7: status 0101 change 0001
[    6.979124] usb 1-1.1: skipped 1 descriptor after interface
[    6.979130] usb 1-1.1: skipped 1 descriptor after interface
[    6.979728] usb 1-1.1: default language 0x0409
[    6.981744] usb 1-1.1: udev 3, busnum 1, minor =3D 2
[    6.981749] usb 1-1.1: New USB device found, idVendor=3D046d, idProd=
uct=3Dc521
[    6.981753] usb 1-1.1: New USB device strings: Mfr=3D1, Product=3D2,
SerialNumber=3D0
[    6.981757] usb 1-1.1: Product: USB Receiver
[    6.981760] usb 1-1.1: Manufacturer: Logitech
[    6.982131] usb 1-1.1: usb_probe_device
[    6.982136] usb 1-1.1: configuration #1 chosen from 1 choice
[    6.983971] usb 1-1.1: adding 1-1.1:1.0 (config #1, interface 0)
[    6.984315] usbhid 1-1.1:1.0: usb_probe_interface
[    6.984319] usbhid 1-1.1:1.0: usb_probe_interface - got id
[    6.988522] input: Logitech USB Receiver as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.0/input/input2
[    6.989215] generic-usb 0003:046D:C521.0001: input,hidraw0: USB HID
v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-1.1/input0
[    6.989242] usb 1-1.1: adding 1-1.1:1.1 (config #1, interface 1)
[    6.989461] usbhid 1-1.1:1.1: usb_probe_interface
[    6.989465] usbhid 1-1.1:1.1: usb_probe_interface - got id
[    6.996760] input: Logitech USB Receiver as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.1/input/input3
[    6.996792] usb 1-1.1: link qh8-0e01/ffff8801bc37ecc0 start 2 [1/2 u=
s]
[    6.997274] usbhid 1-1.1:1.1: looking for a minor, starting at 0
[    6.997683] generic-usb 0003:046D:C521.0002: input,hiddev0,hidraw1:
USB HID v1.11 Device [Logitech USB Receiver] on
usb-0000:00:1a.0-1.1/input1
[    6.997895] drivers/usb/core/inode.c: creating file '003'
[    6.998069] hub 1-1:1.0: port 2, status 0101, change 0000, 12 Mb/s
[    7.009277] hub 1-1:1.0: port 2 not reset yet, waiting 10ms
[    7.027069] usb 2-1: link qh256-0001/ffff8801bffded40 start 1 [1/0 u=
s]
[    7.071213] usb 1-1.2: new high speed USB device using ehci_hcd and =
address 4
[    7.082151] hub 1-1:1.0: port 2 not reset yet, waiting 10ms
[    7.156809] usb 1-1.2: default language 0x0409
[    7.157554] usb 1-1.2: udev 4, busnum 1, minor =3D 3
[    7.157560] usb 1-1.2: New USB device found, idVendor=3D04f9, idProd=
uct=3D002a
[    7.157564] usb 1-1.2: New USB device strings: Mfr=3D1, Product=3D2,
SerialNumber=3D3
[    7.157568] usb 1-1.2: Product: HL-5240
[    7.157570] usb 1-1.2: Manufacturer: Brother
[    7.157573] usb 1-1.2: SerialNumber: H7J241026
[    7.157920] usb 1-1.2: usb_probe_device
[    7.157926] usb 1-1.2: configuration #1 chosen from 1 choice
[    7.157994] usb 1-1.2: adding 1-1.2:1.0 (config #1, interface 0)
[    7.158527] drivers/usb/core/inode.c: creating file '004'
[    7.158732] hub 1-1:1.0: port 4, status 0101, change 0000, 12 Mb/s
[    7.220958] usb 1-1.4: new low speed USB device using ehci_hcd and a=
ddress 5
[    7.233888] hub 1-1:1.0: port 4 not reset yet, waiting 10ms
[    7.319584] usb 1-1.4: skipped 1 descriptor after interface
[    7.319590] usb 1-1.4: skipped 1 descriptor after interface
[    7.320518] usb 1-1.4: default language 0x0409
[    7.330379] usb 1-1.4: udev 5, busnum 1, minor =3D 4
[    7.330384] usb 1-1.4: New USB device found, idVendor=3D045e, idProd=
uct=3D00db
[    7.330389] usb 1-1.4: New USB device strings: Mfr=3D1, Product=3D2,
SerialNumber=3D0
[    7.330393] usb 1-1.4: Product: Natural=AE Ergonomic Keyboard 4000
[    7.330396] usb 1-1.4: Manufacturer: Microsoft
[    7.330772] usb 1-1.4: usb_probe_device
[    7.330778] usb 1-1.4: configuration #1 chosen from 1 choice
[    7.331419] usb 1-1.4: adding 1-1.4:1.0 (config #1, interface 0)
[    7.331721] usbhid 1-1.4:1.0: usb_probe_interface
[    7.331726] usbhid 1-1.4:1.0: usb_probe_interface - got id
[    7.339696] input: Microsoft Natural=AE Ergonomic Keyboard 4000 as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input4
[    7.339729] usb 1-1.4: link qh8-0e01/ffff8801bc37e5c0 start 3 [1/2 u=
s]
[    7.340205] microsoft 0003:045E:00DB.0003: input,hidraw2: USB HID
v1.11 Keyboard [Microsoft Natural=AE Ergonomic Keyboard 4000] on
usb-0000:00:1a.0-1.4/input0
[    7.340235] usb 1-1.4: adding 1-1.4:1.1 (config #1, interface 1)
[    7.340458] usbhid 1-1.4:1.1: usb_probe_interface
[    7.340462] usbhid 1-1.4:1.1: usb_probe_interface - got id
[    7.351610] input: Microsoft Natural=AE Ergonomic Keyboard 4000 as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.1/input/input5
[    7.351641] usb 1-1.4: link qh8-0e01/ffff8801bc37e140 start 4 [1/2 u=
s]
[    7.352117] microsoft 0003:045E:00DB.0004: input,hidraw3: USB HID
v1.11 Device [Microsoft Natural=AE Ergonomic Keyboard 4000] on
usb-0000:00:1a.0-1.4/input1
[    7.352382] drivers/usb/core/inode.c: creating file '005'
[    7.352412] hub 1-1:1.0: state 7 ports 6 chg 0000 evt 0010
[    7.352558] hub 2-1:1.0: state 7 ports 8 chg 0080 evt 0000
[    7.352736] hub 2-1:1.0: port 7, status 0101, change 0000, 12 Mb/s
[    7.363527] hub 2-1:1.0: port 7 not reset yet, waiting 10ms
[    7.425472] usb 2-1.7: new high speed USB device using ehci_hcd and =
address 3
[    7.438415] hub 2-1:1.0: port 7 not reset yet, waiting 10ms
[    7.523852] usb 2-1.7: skipped 1 descriptor after interface
[    7.524474] usb 2-1.7: default language 0x0409
[    7.779614] usb 2-1.7: udev 3, busnum 2, minor =3D 130
[    7.779619] usb 2-1.7: New USB device found, idVendor=3D0bda, idProd=
uct=3D0182
[    7.779624] usb 2-1.7: New USB device strings: Mfr=3D1, Product=3D2,
SerialNumber=3D3
[    7.779628] usb 2-1.7: Product: USB2.0-CRW
[    7.779631] usb 2-1.7: Manufacturer: Generic
[    7.779633] usb 2-1.7: SerialNumber: 20060413092100000
[    7.780019] usb 2-1.7: usb_probe_device
[    7.780025] usb 2-1.7: configuration #1 chosen from 1 choice
[    7.782659] usb 2-1.7: adding 2-1.7:1.0 (config #1, interface 0)
[    7.786533] libusual 2-1.7:1.0: usb_probe_interface
[    7.786569] libusual 2-1.7:1.0: usb_probe_interface - got id
[    7.786589] usb-storage 2-1.7:1.0: usb_probe_interface
[    7.786596] usb-storage 2-1.7:1.0: usb_probe_interface - got id
[    7.786792] scsi10 : usb-storage 2-1.7:1.0
[    7.787471] usb 2-1.7: adding 2-1.7:1.1 (config #1, interface 1)
[    7.787733] usbhid 2-1.7:1.1: usb_probe_interface
[    7.787737] usbhid 2-1.7:1.1: usb_probe_interface - got id
[    7.794723] generic-usb: probe of 0003:0BDA:0182.0005 failed with er=
ror -22
[    7.794976] drivers/usb/core/inode.c: creating file '003'
[    7.795170] hub 2-1:1.0: state 7 ports 8 chg 0000 evt fe80
[    8.789063] scsi 10:0:0:0: Direct-Access     Generic- Compact Flash
   1.00 PQ: 0 ANSI: 0 CCS
[    8.792163] scsi 10:0:0:1: Direct-Access     Generic- xD-Picture
   1.00 PQ: 0 ANSI: 0 CCS
[    8.795530] scsi 10:0:0:2: Direct-Access     Generic- SD/MMC
   1.00 PQ: 0 ANSI: 0 CCS
[    8.798521] scsi 10:0:0:3: Direct-Access     Generic- MS/MS-Pro/HG
   1.00 PQ: 0 ANSI: 0 CCS
[    8.801642] scsi 10:0:0:4: Direct-Access     Generic- MicroSD
   1.00 PQ: 0 ANSI: 0 CCS
[    8.803878] sd 10:0:0:0: Attached scsi generic sg6 type 0
[    8.804720] sd 10:0:0:1: Attached scsi generic sg7 type 0
[    8.805553] sd 10:0:0:2: Attached scsi generic sg8 type 0
[    8.806297] sd 10:0:0:3: Attached scsi generic sg9 type 0
[    8.807057] sd 10:0:0:4: Attached scsi generic sg10 type 0
[    8.813581] sd 10:0:0:0: [sde] Attached SCSI removable disk
[    8.818867] sd 10:0:0:3: [sdh] Attached SCSI removable disk
[    8.821323] sd 10:0:0:2: [sdg] Attached SCSI removable disk
[    8.823809] sd 10:0:0:1: [sdf] Attached SCSI removable disk
[    8.829770] sd 10:0:0:4: [sdi] Attached SCSI removable disk
[   15.076182] alg: No test for xts(twofish) (xts(twofish-asm))
[   17.638932] EXT3-fs (dm-2): error: couldn't mount because of
unsupported optional features (240)
[   17.641941] EXT2-fs (dm-2): error: couldn't mount because of
unsupported optional features (240)
[   17.671951] EXT4-fs (dm-2): mounted filesystem with ordered data
mode. Opts: (null)
[   22.760051] udev[4924]: starting version 164
[   22.977989] usb 1-1.1: link qh8-0e01/ffff8801bc1edf40 start 5 [1/2 u=
s]
[   22.996108] shpchp: Standard Hot Plug PCI Controller Driver version:=
 0.4
[   22.997551] ACPI: WMI: Mapper loaded
[   23.005901] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.7-k2
[   23.005904] e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
[   23.005930]   alloc irq_desc for 20 on node -1
[   23.005932]   alloc kstat_irqs on node -1
[   23.005939] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) ->=
 IRQ 20
[   23.005947] e1000e 0000:00:19.0: setting latency timer to 64
[   23.006068]   alloc irq_desc for 48 on node -1
[   23.006070]   alloc kstat_irqs on node -1
[   23.006080] e1000e 0000:00:19.0: irq 48 for MSI/MSI-X
[   23.089803] usb 1-1.1: unlink qh8-0e01/ffff8801bc1edf40 start 5 [1/2=
 us]
[   23.101871] firewire_ohci 0000:07:06.0: PCI INT A -> GSI 19 (level,
low) -> IRQ 19
[   23.155845] firewire_ohci: Added fw-ohci device 0000:07:06.0, OHCI
v1.10, 4 IR + 8 IT contexts, quirks 0x1
[   23.233537] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width
x1) 90:fb:a6:46:2d:ec
[   23.233540] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Con=
nection
[   23.233574] e1000e 0000:00:19.0: eth0: MAC: 9, PHY: 9, PBA No: fffff=
f-0ff
[   23.233625] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level,
low) -> IRQ 18
[   23.562647] fglrx: module license 'Proprietary. (C) 2002 - ATI
Technologies, Starnberg, GERMANY' taints kernel.
[   23.562651] Disabling lock debugging due to kernel taint
[   23.580507] [fglrx] Maximum main memory to use for locked dma
buffers: 5765 MBytes.
[   23.580547] [fglrx]   vendor: 1002 device: 6899 count: 1
[   23.580832] [fglrx] ioport: bar 4, base 0xc000, size: 0x100
[   23.580844] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IR=
Q 16
[   23.580848] pci 0000:01:00.0: setting latency timer to 64
[   23.581084] [fglrx] Kernel PAT support is enabled
[   23.581097] [fglrx] module loaded - fglrx 8.79.4 [Oct 26 2010] with =
1 minors
[   23.655871] firewire_core: created device fw0: GUID 00016c20013727d2=
, S400
[   26.168563] EXT4-fs (dm-2): re-mounted. Opts: commit=3D600
[   26.316906] REISERFS (device sdd1): found reiserfs format "3.6"
with standard journal
[   26.316921] REISERFS (device sdd1): using ordered data mode
[   26.326028] REISERFS (device sdd1): journal params: device sdd1,
size 8192, journal first block 18, max trans len 1024, max batch 900,
max commit age 600, max trans age 600
[   26.326367] REISERFS (device sdd1): checking transaction log (sdd1)
[   26.340422] REISERFS (device sdd1): Using r5 hash to sort names
[   28.565078] e1000e 0000:00:19.0: irq 48 for MSI/MSI-X
[   28.615910] e1000e 0000:00:19.0: irq 48 for MSI/MSI-X
[   28.617174] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   30.096385] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow
Control: RX
[   30.096392] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   30.096944] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   32.838669] Adding 9420796k swap on /dev/mapper/XPS-SWAP.
Priority:-1 extents:1 across:9420796k
[   40.834555] eth0: no IPv6 routers present
[   45.016971] ehci_hcd 0000:00:1a.0: reused qh ffff8801bc1edf40 schedu=
le
[   45.016981] usb 1-1.1: link qh8-0e01/ffff8801bc1edf40 start 5 [1/2 u=
s]
[   46.251903] coretemp coretemp.0: TjMax is 99 C.
[   46.252070] coretemp coretemp.1: TjMax is 99 C.
[   46.252133] coretemp coretemp.2: TjMax is 99 C.
[   46.252309] coretemp coretemp.3: TjMax is 99 C.
[   46.279441] it87: Found IT8720F chip at 0xa10, revision 8
[   46.279450] it87: VID is disabled (pins used for GPIO)
[   46.279461] it87: Beeping is supported
[  106.621323]   alloc irq_desc for 49 on node -1
[  106.621325]   alloc kstat_irqs on node -1
[  106.621332] fglrx_pci 0000:01:00.0: irq 49 for MSI/MSI-X
[  106.621830] [fglrx] Firegl kernel thread PID: 6637
[  106.622092] [fglrx] IRQ 49 Enabled
[  107.000068] [fglrx] Gart USWC size:1280 M.
[  107.000070] [fglrx] Gart cacheable size:508 M.
[  107.000073] [fglrx] Reserved FB block: Shared offset:0, size:1000000
[  107.000074] [fglrx] Reserved FB block: Unshared offset:f8fd000, size=
:403000
[  107.000075] [fglrx] Reserved FB block: Unshared offset:3fff4000, siz=
e:c000
[  265.523684] EXT4-fs (dm-3): mounted filesystem with ordered data
mode. Opts: commit=3D600
[  951.897329] Enabling EXPERIMENTAL delayed logging feature - use at
your own risk.
[  951.954027] XFS mounting filesystem dm-4
[  952.157109] Ending clean XFS mount for filesystem: dm-4
[ 2116.735158] conftest[20068]: segfault at 7fff294acf80 ip
00007f61690981ba sp 00007fff294acf40 error 6 in
ld-2.12.1.so[7f6169092000+20000]
[ 3012.610585] hda-intel: IRQ timing workaround is activated for card
#1. Suggest a bigger bdl_pos_adj.
[ 6000.313047] REISERFS (device sdd1): found reiserfs format "3.6"
with standard journal
[ 6000.313066] REISERFS (device sdd1): using ordered data mode
[ 6000.323773] REISERFS (device sdd1): journal params: device sdd1,
size 8192, journal first block 18, max trans len 1024, max batch 900,
max commit age 600, max trans age 600
[ 6000.324033] REISERFS (device sdd1): checking transaction log (sdd1)
[ 6000.338187] REISERFS (device sdd1): Using r5 hash to sort names
[ 6037.155535] REISERFS (device sdd1): found reiserfs format "3.6"
with standard journal
[ 6037.155546] REISERFS (device sdd1): using ordered data mode
[ 6037.155677] REISERFS (device sdd1): journal params: device sdd1,
size 8192, journal first block 18, max trans len 1024, max batch 900,
max commit age 600, max trans age 600
[ 6037.155910] REISERFS (device sdd1): checking transaction log (sdd1)
[ 6037.205634] REISERFS (device sdd1): Using r5 hash to sort names
[ 6097.179452] ------------[ cut here ]------------
[ 6097.179456] kernel BUG at fs/ext4/inode.c:2717!
[ 6097.179457] invalid opcode: 0000 [#1] PREEMPT SMP
[ 6097.179459] last sysfs file:
/sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
[ 6097.179461] CPU 5
[ 6097.179462] Modules linked in: it87 hwmon_vid coretemp hwmon
fglrx(P) firewire_ohci firewire_core i2c_i801 e1000e wmi shpchp tg3
libphy e1000 scsi_wait_scan sl811_hcd ohci_hcd ssb usb_storage
ehci_hcd
[ 6097.179472]
[ 6097.179475] Pid: 4540, comm: jbd2/dm-2-8 Tainted: P
2.6.36-rc6_bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc+ #1 FMP55/ipower
G3710
[ 6097.179477] RIP: 0010:[<ffffffff8119cc50>]  [<ffffffff8119cc50>]
ext4_writepage+0x270/0x280
[ 6097.179482] RSP: 0018:ffff8801baec3b40  EFLAGS: 00010246
[ 6097.179483] RAX: 8000000000020069 RBX: ffffea0004222088 RCX: 0000000=
000000030
[ 6097.179485] RDX: 0000000000000a0f RSI: ffff8801baec3cc0 RDI: ffffea0=
004222088
[ 6097.179486] RBP: ffff8801472ca6a0 R08: ffff880183cc6de8 R09: 0000000=
000000000
[ 6097.179488] R10: 0000000000000008 R11: 0000000000000010 R12: 0000000=
000000a0f
[ 6097.179489] R13: 0000000000001000 R14: ffff8801baec3cc0 R15: ffff880=
1baec3c10
[ 6097.179491] FS:  0000000000000000(0000) GS:ffff880002140000(0000)
knlGS:0000000000000000
[ 6097.179492] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6097.179494] CR2: 00007f19058591f0 CR3: 0000000001c04000 CR4: 0000000=
0000006e0
[ 6097.179495] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[ 6097.179497] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[ 6097.179498] Process jbd2/dm-2-8 (pid: 4540, threadinfo
ffff8801baec2000, task ffff8801bfef0040)
[ 6097.179500] Stack:
[ 6097.179500]  ffff8801baec3c10 ffffffff810fce75 ffff8801472ca808
ffff8801472ca808
[ 6097.179503] <0> ffff8801472ca808 0000000000000a0f ffffea0004222088
0000000000000003
[ 6097.179506] <0> ffff8801baec3c10 ffffffff810a261d 000000000000000e
ffffffff810a2ab1
[ 6097.179509] Call Trace:
[ 6097.179513]  [<ffffffff810fce75>] ? __set_page_dirty_buffers+0x85/0x=
e0
[ 6097.179517]  [<ffffffff810a261d>] ? __writepage+0xd/0x40
[ 6097.179519]  [<ffffffff810a2ab1>] ? write_cache_pages+0x1b1/0x3d0
[ 6097.179521]  [<ffffffff810a2610>] ? __writepage+0x0/0x40
[ 6097.179525]  [<ffffffff811d1869>] ? journal_submit_data_buffers+0x99=
/0x100
[ 6097.179528]  [<ffffffff811d1db1>] ?
jbd2_journal_commit_transaction+0x331/0x1330
[ 6097.179532]  [<ffffffff8172097b>] ? schedule+0x37b/0x8d0
[ 6097.179534]  [<ffffffff817237f8>] ? _raw_spin_lock_irqsave+0x18/0x20
[ 6097.179538]  [<ffffffff810538c3>] ? lock_timer_base.clone.23+0x33/0x=
70
[ 6097.179540]  [<ffffffff8105396e>] ? try_to_del_timer_sync+0x6e/0x90
[ 6097.179542]  [<ffffffff811d5d91>] ? kjournald2+0xb1/0x210
[ 6097.179545]  [<ffffffff81062b80>] ? autoremove_wake_function+0x0/0x3=
0
[ 6097.179547]  [<ffffffff811d5ce0>] ? kjournald2+0x0/0x210
[ 6097.179549]  [<ffffffff811d5ce0>] ? kjournald2+0x0/0x210
[ 6097.179551]  [<ffffffff81062706>] ? kthread+0x96/0xa0
[ 6097.179555]  [<ffffffff81003394>] ? kernel_thread_helper+0x4/0x10
[ 6097.179557]  [<ffffffff81062670>] ? kthread+0x0/0xa0
[ 6097.179559]  [<ffffffff81003390>] ? kernel_thread_helper+0x0/0x10
[ 6097.179560] Code: ff f6 c4 40 0f 84 4a fe ff ff e9 77 ff ff ff 48
c7 c6 f0 3f 82 81 48 c7 c7 40 b1 9d 81 31 c0 e8 e0 34 58 00 e9 6e fe
ff ff 0f 0b <0f> 0b 4d 8b 6d 10 e9 96 fe ff ff 0f 1f 44 00 00 48 83 ec
08 ba
[ 6097.179580] RIP  [<ffffffff8119cc50>] ext4_writepage+0x270/0x280
[ 6097.179583]  RSP <ffff8801baec3b40>
[ 6097.179584] ---[ end trace 5199c452c07fe3ec ]---
