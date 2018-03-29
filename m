From: valdis.kletnieks@vt.edu
Subject: linux-next 20180327 - "SELinux: (dev dm-3, type ext4) getxattr errno 34"
Date: Thu, 29 Mar 2018 13:57:53 -0400
Message-ID: <24018.1522346273@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1522346273_3116P";
         micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
        linux-ext4@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>,
        "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--==_Exmh_1522346273_3116P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Seeing this error trying to mount ext4 disks. next-20180320 was OK.

SELinux: (dev dm-3, type ext4) getxattr errno 34

and for /var, it refused to mount entirely (which brought the boot
process to a screeching halt).

git log shows commits in the past few days against both selinux and ext4,=

but nothing obvious.

This ring any bells, or is it time to start bisecting?

dmesg follows...

=5B    0.000000=5D microcode: microcode updated early to revision 0x1f, d=
ate =3D 2018-02-07
=5B    0.000000=5D Linux version 4.16.0-rc7-next-20180327-dirty (source=
=40turing-police.cc.vt.edu) (gcc version 8.0.1 20180317 (Red Hat 8.0.1-0.=
19) (GCC)) =23565 SMP PREEMPT Wed Mar 28 01:01:48 EDT 2018
=5B    0.000000=5D Command line: BOOT_IMAGE=3D/vmlinuz-4.16.0-rc7-next-20=
180327-dirty root=3D/dev/mapper/turing--police-root ro rd.md=3D0 rd.dm=3D=
0 rd.lvm.lv=3Dturing-police/00 console.keymap=3D rd.luks.uuid=3Dluks-665b=
b147-9e39-4003-b3ae-7be925f51a97 rd.lvm.lv=3Dturing-police/swap rd.lvm.lv=
=3Dturing-police/root quiet LANG=3Den_US.UTF-8 nouveau.modeset=3D0 rd.dri=
ver.blacklist=3Dnouveau video=3Dvesa:off modprobe.blacklist=3Dnouveau nvi=
dia-drm.modeset=3D1 single
=5B    0.000000=5D KERNEL supported cpus:
=5B    0.000000=5D   Intel GenuineIntel
=5B    0.000000=5D x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating=
 point registers'
=5B    0.000000=5D x86/fpu: Supporting XSAVE feature 0x002: 'SSE register=
s'
=5B    0.000000=5D x86/fpu: Supporting XSAVE feature 0x004: 'AVX register=
s'
=5B    0.000000=5D x86/fpu: xstate_offset=5B2=5D:  576, xstate_sizes=5B2=
=5D:  256
=5B    0.000000=5D x86/fpu: Enabled xstate features 0x7, context size is =
832 bytes, using 'standard' format.
=5B    0.000000=5D e820: BIOS-provided physical RAM map:
=5B    0.000000=5D BIOS-e820: =5Bmem 0x0000000000000000-0x000000000009cff=
f=5D usable
=5B    0.000000=5D BIOS-e820: =5Bmem 0x000000000009d000-0x000000000009eff=
f=5D reserved
=5B    0.000000=5D BIOS-e820: =5Bmem 0x000000000009f000-0x000000000009fff=
f=5D usable
=5B    0.000000=5D BIOS-e820: =5Bmem 0x0000000000100000-0x00000000ca709ff=
f=5D usable
=5B    0.000000=5D BIOS-e820: =5Bmem 0x00000000ca70a000-0x00000000ca7ffff=
f=5D reserved
=5B    0.000000=5D BIOS-e820: =5Bmem 0x00000000ca800000-0x00000000caf52ff=
f=5D usable
=5B    0.000000=5D BIOS-e820: =5Bmem 0x00000000caf53000-0x00000000cafffff=
f=5D reserved
=5B    0.000000=5D BIOS-e820: =5Bmem 0x00000000cb000000-0x00000000cb7b1ff=
f=5D usable
=5B    0.000000=5D BIOS-e820: =5Bmem 0x00000000cb7b2000-0x00000000cb7ffff=
f=5D ACPI data
=5B    0.000000=5D BIOS-e820: =5Bmem 0x00000000cb800000-0x00000000ccefdff=
f=5D usable
=5B    0.000000=5D BIOS-e820: =5Bmem 0x00000000ccefe000-0x00000000ccfffff=
f=5D ACPI NVS
=5B    0.000000=5D BIOS-e820: =5Bmem 0x00000000cd000000-0x00000000ce5aeff=
f=5D usable
=5B    0.000000=5D BIOS-e820: =5Bmem 0x00000000ce5af000-0x00000000cefa5ff=
f=5D reserved
=5B    0.000000=5D BIOS-e820: =5Bmem 0x00000000cefa6000-0x00000000cefe8ff=
f=5D ACPI NVS
=5B    0.000000=5D BIOS-e820: =5Bmem 0x00000000cefe9000-0x00000000cf2b1ff=
f=5D usable
=5B    0.000000=5D BIOS-e820: =5Bmem 0x00000000cf2b2000-0x00000000cf7efff=
f=5D reserved
=5B    0.000000=5D BIOS-e820: =5Bmem 0x00000000cf7f0000-0x00000000cf7ffff=
f=5D usable
=5B    0.000000=5D BIOS-e820: =5Bmem 0x00000000f8000000-0x00000000fbfffff=
f=5D reserved
=5B    0.000000=5D BIOS-e820: =5Bmem 0x00000000fec00000-0x00000000fec00ff=
f=5D reserved
=5B    0.000000=5D BIOS-e820: =5Bmem 0x00000000fed00000-0x00000000fed03ff=
f=5D reserved
=5B    0.000000=5D BIOS-e820: =5Bmem 0x00000000fed1c000-0x00000000fed1fff=
f=5D reserved
=5B    0.000000=5D BIOS-e820: =5Bmem 0x00000000fee00000-0x00000000fee00ff=
f=5D reserved
=5B    0.000000=5D BIOS-e820: =5Bmem 0x00000000ff000000-0x00000000fffffff=
f=5D reserved
=5B    0.000000=5D BIOS-e820: =5Bmem 0x0000000100000000-0x000000040dfacff=
f=5D usable
=5B    0.000000=5D BIOS-e820: =5Bmem 0x000000040dfad000-0x000000040dfadff=
f=5D unusable
=5B    0.000000=5D BIOS-e820: =5Bmem 0x000000040dfae000-0x000000040dfaeff=
f=5D usable
=5B    0.000000=5D BIOS-e820: =5Bmem 0x000000040dfaf000-0x000000040dfafff=
f=5D unusable
=5B    0.000000=5D BIOS-e820: =5Bmem 0x000000040dfb0000-0x000000040dfeaff=
f=5D usable
=5B    0.000000=5D BIOS-e820: =5Bmem 0x000000040dfeb000-0x000000040dfebff=
f=5D unusable
=5B    0.000000=5D BIOS-e820: =5Bmem 0x000000040dfec000-0x000000042dfffff=
f=5D usable
=5B    0.000000=5D NX (Execute Disable) protection: active
=5B    0.000000=5D e820: update =5Bmem 0xc7b50018-0xc7b6ce57=5D usable =
=3D=3D> usable
=5B    0.000000=5D e820: update =5Bmem 0xc7b50018-0xc7b6ce57=5D usable =
=3D=3D> usable
=5B    0.000000=5D extended physical RAM map:
=5B    0.000000=5D reserve setup_data: =5Bmem 0x0000000000000000-0x000000=
000009cfff=5D usable
=5B    0.000000=5D reserve setup_data: =5Bmem 0x000000000009d000-0x000000=
000009efff=5D reserved
=5B    0.000000=5D reserve setup_data: =5Bmem 0x000000000009f000-0x000000=
000009ffff=5D usable
=5B    0.000000=5D reserve setup_data: =5Bmem 0x0000000000100000-0x000000=
00c7b50017=5D usable
=5B    0.000000=5D reserve setup_data: =5Bmem 0x00000000c7b50018-0x000000=
00c7b6ce57=5D usable
=5B    0.000000=5D reserve setup_data: =5Bmem 0x00000000c7b6ce58-0x000000=
00ca709fff=5D usable
=5B    0.000000=5D reserve setup_data: =5Bmem 0x00000000ca70a000-0x000000=
00ca7fffff=5D reserved
=5B    0.000000=5D reserve setup_data: =5Bmem 0x00000000ca800000-0x000000=
00caf52fff=5D usable
=5B    0.000000=5D reserve setup_data: =5Bmem 0x00000000caf53000-0x000000=
00caffffff=5D reserved
=5B    0.000000=5D reserve setup_data: =5Bmem 0x00000000cb000000-0x000000=
00cb7b1fff=5D usable
=5B    0.000000=5D reserve setup_data: =5Bmem 0x00000000cb7b2000-0x000000=
00cb7fffff=5D ACPI data
=5B    0.000000=5D reserve setup_data: =5Bmem 0x00000000cb800000-0x000000=
00ccefdfff=5D usable
=5B    0.000000=5D reserve setup_data: =5Bmem 0x00000000ccefe000-0x000000=
00ccffffff=5D ACPI NVS
=5B    0.000000=5D reserve setup_data: =5Bmem 0x00000000cd000000-0x000000=
00ce5aefff=5D usable
=5B    0.000000=5D reserve setup_data: =5Bmem 0x00000000ce5af000-0x000000=
00cefa5fff=5D reserved
=5B    0.000000=5D reserve setup_data: =5Bmem 0x00000000cefa6000-0x000000=
00cefe8fff=5D ACPI NVS
=5B    0.000000=5D reserve setup_data: =5Bmem 0x00000000cefe9000-0x000000=
00cf2b1fff=5D usable
=5B    0.000000=5D reserve setup_data: =5Bmem 0x00000000cf2b2000-0x000000=
00cf7effff=5D reserved
=5B    0.000000=5D reserve setup_data: =5Bmem 0x00000000cf7f0000-0x000000=
00cf7fffff=5D usable
=5B    0.000000=5D reserve setup_data: =5Bmem 0x00000000f8000000-0x000000=
00fbffffff=5D reserved
=5B    0.000000=5D reserve setup_data: =5Bmem 0x00000000fec00000-0x000000=
00fec00fff=5D reserved
=5B    0.000000=5D reserve setup_data: =5Bmem 0x00000000fed00000-0x000000=
00fed03fff=5D reserved
=5B    0.000000=5D reserve setup_data: =5Bmem 0x00000000fed1c000-0x000000=
00fed1ffff=5D reserved
=5B    0.000000=5D reserve setup_data: =5Bmem 0x00000000fee00000-0x000000=
00fee00fff=5D reserved
=5B    0.000000=5D reserve setup_data: =5Bmem 0x00000000ff000000-0x000000=
00ffffffff=5D reserved
=5B    0.000000=5D reserve setup_data: =5Bmem 0x0000000100000000-0x000000=
040dfacfff=5D usable
=5B    0.000000=5D reserve setup_data: =5Bmem 0x000000040dfad000-0x000000=
040dfadfff=5D unusable
=5B    0.000000=5D reserve setup_data: =5Bmem 0x000000040dfae000-0x000000=
040dfaefff=5D usable
=5B    0.000000=5D reserve setup_data: =5Bmem 0x000000040dfaf000-0x000000=
040dfaffff=5D unusable
=5B    0.000000=5D reserve setup_data: =5Bmem 0x000000040dfb0000-0x000000=
040dfeafff=5D usable
=5B    0.000000=5D reserve setup_data: =5Bmem 0x000000040dfeb000-0x000000=
040dfebfff=5D unusable
=5B    0.000000=5D reserve setup_data: =5Bmem 0x000000040dfec000-0x000000=
042dffffff=5D usable
=5B    0.000000=5D efi: EFI v2.31 by American Megatrends
=5B    0.000000=5D efi:  ACPI=3D0xcb7f1000  ACPI 2.0=3D0xcb7f1000  SMBIOS=
=3D0xf0000=20
=5B    0.000000=5D secureboot: Secure boot disabled
=5B    0.000000=5D random: fast init done
=5B    0.000000=5D SMBIOS 2.7 present.
=5B    0.000000=5D DMI: Dell Inc. Latitude E6530/07Y85M, BIOS A20 05/08/2=
017
=5B    0.000000=5D e820: update =5Bmem 0x00000000-0x00000fff=5D usable =
=3D=3D> reserved
=5B    0.000000=5D e820: remove =5Bmem 0x000a0000-0x000fffff=5D usable
=5B    0.000000=5D e820: last_pfn =3D 0x42e000 max_arch_pfn =3D 0x4000000=
00
=5B    0.000000=5D MTRR default type: uncachable
=5B    0.000000=5D MTRR fixed ranges enabled:
=5B    0.000000=5D   00000-9FFFF write-back
=5B    0.000000=5D   A0000-DFFFF uncachable
=5B    0.000000=5D   E0000-FFFFF write-protect
=5B    0.000000=5D MTRR variable ranges enabled:
=5B    0.000000=5D   0 base 000000000 mask C00000000 write-back
=5B    0.000000=5D   1 base 400000000 mask FE0000000 write-back
=5B    0.000000=5D   2 base 420000000 mask FF8000000 write-back
=5B    0.000000=5D   3 base 428000000 mask FFC000000 write-back
=5B    0.000000=5D   4 base 42C000000 mask FFE000000 write-back
=5B    0.000000=5D   5 base 0E0000000 mask FE0000000 uncachable
=5B    0.000000=5D   6 base 0D0000000 mask FF0000000 uncachable
=5B    0.000000=5D   7 disabled
=5B    0.000000=5D   8 disabled
=5B    0.000000=5D   9 disabled
=5B    0.000000=5D x86/PAT: Configuration =5B0-7=5D: WB  WC  UC- UC  WB  =
WP  UC- WT =20
=5B    0.000000=5D e820: update =5Bmem 0xd0000000-0xffffffff=5D usable =
=3D=3D> reserved
=5B    0.000000=5D e820: last_pfn =3D 0xcf800 max_arch_pfn =3D 0x40000000=
0
=5B    0.000000=5D Base memory trampoline at =5B        (ptrval)=5D 97000=
 size 24576
=5B    0.000000=5D BRK =5B0x403b91000, 0x403b91fff=5D PGTABLE
=5B    0.000000=5D BRK =5B0x403b92000, 0x403b92fff=5D PGTABLE
=5B    0.000000=5D BRK =5B0x403b93000, 0x403b93fff=5D PGTABLE
=5B    0.000000=5D BRK =5B0x403b94000, 0x403b94fff=5D PGTABLE
=5B    0.000000=5D BRK =5B0x403b95000, 0x403b95fff=5D PGTABLE
=5B    0.000000=5D BRK =5B0x403b96000, 0x403b96fff=5D PGTABLE
=5B    0.000000=5D BRK =5B0x403b97000, 0x403b97fff=5D PGTABLE
=5B    0.000000=5D BRK =5B0x403b98000, 0x403b98fff=5D PGTABLE
=5B    0.000000=5D BRK =5B0x403b99000, 0x403b99fff=5D PGTABLE
=5B    0.000000=5D BRK =5B0x403b9a000, 0x403b9afff=5D PGTABLE
=5B    0.000000=5D BRK =5B0x403b9b000, 0x403b9bfff=5D PGTABLE
=5B    0.000000=5D BRK =5B0x403b9c000, 0x403b9cfff=5D PGTABLE
=5B    0.000000=5D RAMDISK: =5Bmem 0x3b87d000-0x3c441fff=5D
=5B    0.000000=5D ACPI: Early table checksum verification disabled
=5B    0.000000=5D ACPI: RSDP 0x00000000CB7F1000 000024 (v02 DELL  )
=5B    0.000000=5D ACPI: XSDT 0x00000000CB7F1088 000094 (v01 DELL   CBX3 =
    01072009 AMI  00010013)
=5B    0.000000=5D ACPI: FACP 0x00000000CB7FB720 00010C (v05 DELL   CBX3 =
    01072009 AMI  00010013)
=5B    0.000000=5D ACPI: DSDT 0x00000000CB7F11B0 00A56F (v02 DELL   CBX3 =
    00000021 INTL 20091112)
=5B    0.000000=5D ACPI: FACS 0x00000000CCFED080 000040
=5B    0.000000=5D ACPI: APIC 0x00000000CB7FB830 000072 (v03 DELL   CBX3 =
    01072009 AMI  00010013)
=5B    0.000000=5D ACPI: FPDT 0x00000000CB7FB8A8 000044 (v01 DELL   CBX3 =
    01072009 AMI  00010013)
=5B    0.000000=5D ACPI: TCPA 0x00000000CB7FB8F0 000032 (v02 APTIO4 NAPAA=
SF  00000001 MSFT 01000013)
=5B    0.000000=5D ACPI: MCFG 0x00000000CB7FB928 00003C (v01 DELL   CBX3 =
    01072009 MSFT 00000097)
=5B    0.000000=5D ACPI: HPET 0x00000000CB7FB968 000038 (v01 DELL   CBX3 =
    01072009 AMI. 00000005)
=5B    0.000000=5D ACPI: SSDT 0x00000000CB7FB9A0 000415 (v01 SataRe SataT=
abl 00001000 INTL 20091112)
=5B    0.000000=5D ACPI: SSDT 0x00000000CB7FBDB8 0009B9 (v01 PmRef  Cpu0I=
st  00003000 INTL 20051117)
=5B    0.000000=5D ACPI: SSDT 0x00000000CB7FC778 000B22 (v01 PmRef  CpuPm=
    00003000 INTL 20051117)
=5B    0.000000=5D ACPI: DMAR 0x00000000CB7FD2A0 000080 (v01 INTEL  SNB  =
    00000001 INTL 00000001)
=5B    0.000000=5D ACPI: ASF=21 0x00000000CB7FD320 0000A5 (v32 INTEL   HC=
G     00000001 TFSM 000F4240)
=5B    0.000000=5D ACPI: SSDT 0x00000000CB7FD3C8 000579 (v01 AMITCG PROC =
    00000001 INTL 20051117)
=5B    0.000000=5D ACPI: BGRT 0x00000000CB7FD948 000038 (v00 ??          =
    01072009 AMI  00010013)
=5B    0.000000=5D ACPI: SSDT 0x00000000CB7FD980 00198A (v01 NvdRef NvdTa=
bl  00001000 INTL 20091112)
=5B    0.000000=5D ACPI: Local APIC address 0xfee00000
=5B    0.000000=5D tsc: Fast TSC calibration using PIT
=5B    0.000000=5D Zone ranges:
=5B    0.000000=5D   DMA32    =5Bmem 0x0000000000001000-0x00000000fffffff=
f=5D
=5B    0.000000=5D   Normal   =5Bmem 0x0000000100000000-0x000000042dfffff=
f=5D
=5B    0.000000=5D Movable zone start for each node
=5B    0.000000=5D Early memory node ranges
=5B    0.000000=5D   node   0: =5Bmem 0x0000000000001000-0x000000000009cf=
ff=5D
=5B    0.000000=5D   node   0: =5Bmem 0x000000000009f000-0x000000000009ff=
ff=5D
=5B    0.000000=5D   node   0: =5Bmem 0x0000000000100000-0x00000000ca709f=
ff=5D
=5B    0.000000=5D   node   0: =5Bmem 0x00000000ca800000-0x00000000caf52f=
ff=5D
=5B    0.000000=5D   node   0: =5Bmem 0x00000000cb000000-0x00000000cb7b1f=
ff=5D
=5B    0.000000=5D   node   0: =5Bmem 0x00000000cb800000-0x00000000ccefdf=
ff=5D
=5B    0.000000=5D   node   0: =5Bmem 0x00000000cd000000-0x00000000ce5aef=
ff=5D
=5B    0.000000=5D   node   0: =5Bmem 0x00000000cefe9000-0x00000000cf2b1f=
ff=5D
=5B    0.000000=5D   node   0: =5Bmem 0x00000000cf7f0000-0x00000000cf7fff=
ff=5D
=5B    0.000000=5D   node   0: =5Bmem 0x0000000100000000-0x000000040dfacf=
ff=5D
=5B    0.000000=5D   node   0: =5Bmem 0x000000040dfae000-0x000000040dfaef=
ff=5D
=5B    0.000000=5D   node   0: =5Bmem 0x000000040dfb0000-0x000000040dfeaf=
ff=5D
=5B    0.000000=5D   node   0: =5Bmem 0x000000040dfec000-0x000000042dffff=
ff=5D
=5B    0.000000=5D Initmem setup node 0 =5Bmem 0x0000000000001000-0x00000=
0042dffffff=5D
=5B    0.000000=5D On node 0 totalpages: 4179247
=5B    0.000000=5D   DMA32 zone: 13205 pages used for memmap
=5B    0.000000=5D   DMA32 zone: 23 pages reserved
=5B    0.000000=5D   DMA32 zone: 845106 pages, LIFO batch:31
=5B    0.000000=5D   Normal zone: 52096 pages used for memmap
=5B    0.000000=5D   Normal zone: 3334141 pages, LIFO batch:31
=5B    0.000000=5D Reserved but unavailable: 97 pages
=5B    0.000000=5D ACPI: PM-Timer IO Port: 0x408
=5B    0.000000=5D ACPI: Local APIC address 0xfee00000
=5B    0.000000=5D ACPI: LAPIC_NMI (acpi_id=5B0xff=5D high edge lint=5B0x=
1=5D)
=5B    0.000000=5D IOAPIC=5B0=5D: apic_id 2, version 32, address 0xfec000=
00, GSI 0-23
=5B    0.000000=5D ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl df=
l)
=5B    0.000000=5D ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high l=
evel)
=5B    0.000000=5D ACPI: IRQ0 used by override.
=5B    0.000000=5D ACPI: IRQ9 used by override.
=5B    0.000000=5D Using ACPI (MADT) for SMP configuration information
=5B    0.000000=5D ACPI: HPET id: 0x8086a701 base: 0xfed00000
=5B    0.000000=5D smpboot: Allowing 4 CPUs, 0 hotplug CPUs
=5B    0.000000=5D e820: =5Bmem 0xcf800000-0xf7ffffff=5D available for PC=
I devices
=5B    0.000000=5D clocksource: refined-jiffies: mask: 0xffffffff max_cyc=
les: 0xffffffff, max_idle_ns: 1910969940391419 ns
=5B    0.000000=5D setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4=
 nr_node_ids:1
=5B    0.000000=5D percpu: Embedded 497 pages/cpu =40        (ptrval) s19=
95800 r8192 d31720 u2097152
=5B    0.000000=5D pcpu-alloc: s1995800 r8192 d31720 u2097152 alloc=3D1*2=
097152
=5B    0.000000=5D pcpu-alloc: =5B0=5D 0 =5B0=5D 1 =5B0=5D 2 =5B0=5D 3=20
=5B    0.000000=5D Built 1 zonelists, mobility grouping on.  Total pages:=
 4113923
=5B    0.000000=5D Kernel command line: BOOT_IMAGE=3D/vmlinuz-4.16.0-rc7-=
next-20180327-dirty root=3D/dev/mapper/turing--police-root ro rd.md=3D0 r=
d.dm=3D0 rd.lvm.lv=3Dturing-police/00 console.keymap=3D rd.luks.uuid=3Dlu=
ks-665bb147-9e39-4003-b3ae-7be925f51a97 rd.lvm.lv=3Dturing-police/swap rd=
.lvm.lv=3Dturing-police/root quiet LANG=3Den_US.UTF-8 nouveau.modeset=3D0=
 rd.driver.blacklist=3Dnouveau video=3Dvesa:off modprobe.blacklist=3Dnouv=
eau nvidia-drm.modeset=3D1 single
=5B    0.000000=5D Dentry cache hash table entries: 2097152 (order: 12, 1=
6777216 bytes)
=5B    0.000000=5D Inode-cache hash table entries: 1048576 (order: 11, 83=
88608 bytes)
=5B    0.000000=5D Memory: 16175608K/16716988K available (22540K kernel c=
ode, 11268K rwdata, 4472K rodata, 3784K init, 15076K bss, 541380K reserve=
d, 0K cma-reserved)
=5B    0.000000=5D Kernel/User page tables isolation: enabled
=5B    0.000000=5D ftrace: allocating 36386 entries in 143 pages
=5B    0.000000=5D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=5B    0.000000=5D UBSAN: Undefined behaviour in lib/radix-tree.c:123:14
=5B    0.000000=5D member access within null pointer of type 'const struc=
t radix_tree_node'
=5B    0.000000=5D CPU: 0 PID: 0 Comm: swapper/0 Tainted: G              =
  T 4.16.0-rc7-next-20180327-dirty =23565
=5B    0.000000=5D Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A=
20 05/08/2017
=5B    0.000000=5D Call Trace:
=5B    0.000000=5D  dump_stack+0x83/0xca
=5B    0.000000=5D  ubsan_epilogue+0xd/0x3a
=5B    0.000000=5D  handle_null_ptr_deref+0x85/0x90
=5B    0.000000=5D  __ubsan_handle_type_mismatch_v1+0x5e/0x70
=5B    0.000000=5D  __radix_tree_replace+0x1e4/0x1f0
=5B    0.000000=5D  radix_tree_iter_replace+0x25/0x50
=5B    0.000000=5D  idr_alloc_u32+0x166/0x1f0
=5B    0.000000=5D  idr_alloc+0x7e/0xd0
=5B    0.000000=5D  worker_pool_assign_id+0x61/0xd0
=5B    0.000000=5D  ? mutex_lock_nested+0x1b/0x20
=5B    0.000000=5D  workqueue_init_early+0x58f/0xc53
=5B    0.000000=5D  start_kernel+0x4f7/0x813
=5B    0.000000=5D  x86_64_start_reservations+0x40/0x61
=5B    0.000000=5D  x86_64_start_kernel+0x7b/0x9e
=5B    0.000000=5D  secondary_startup_64+0xa5/0xb0
=5B    0.000000=5D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=5B    0.000000=5D Running RCU self tests
=5B    0.000000=5D Preemptible hierarchical RCU implementation.
=5B    0.000000=5D 	RCU lockdep checking is enabled.
=5B    0.000000=5D 	RCU debug extended QS entry/exit.
=5B    0.000000=5D 	Tasks RCU enabled.
=5B    0.000000=5D NR_IRQS: 4352, nr_irqs: 456, preallocated irqs: 16
=5B    0.000000=5D Console: colour dummy device 160x64
=5B    0.000000=5D console =5Btty0=5D enabled
=5B    0.000000=5D Lock dependency validator: Copyright (c) 2006 Red Hat,=
 Inc., Ingo Molnar
=5B    0.000000=5D ... MAX_LOCKDEP_SUBCLASSES:  8
=5B    0.000000=5D ... MAX_LOCK_DEPTH:          48
=5B    0.000000=5D ... MAX_LOCKDEP_KEYS:        8191
=5B    0.000000=5D ... CLASSHASH_SIZE:          4096
=5B    0.000000=5D ... MAX_LOCKDEP_ENTRIES:     32768
=5B    0.000000=5D ... MAX_LOCKDEP_CHAINS:      65536
=5B    0.000000=5D ... CHAINHASH_SIZE:          32768
=5B    0.000000=5D  memory used by lock dependency info: 7903 kB
=5B    0.000000=5D  per task-struct memory footprint: 2688 bytes
=5B    0.000000=5D ACPI: Core revision 20180313
=5B    0.000000=5D clocksource: hpet: mask: 0xffffffff max_cycles: 0xffff=
ffff, max_idle_ns: 133484882848 ns
=5B    0.000000=5D hpet clockevent registered
=5B    0.000000=5D APIC: Switch to symmetric I/O mode setup
=5B    0.000000=5D DMAR: Host address width 36
=5B    0.000000=5D DMAR: DRHD base: 0x000000fed90000 flags: 0x1
=5B    0.000000=5D DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap c90080=
20660262 ecap f0105a
=5B    0.000000=5D DMAR: RMRR base: 0x000000ce715000 end: 0x000000ce734ff=
f
=5B    0.000000=5D DMAR-IR: IOAPIC id 2 under DRHD base  0xfed90000 IOMMU=
 0
=5B    0.000000=5D DMAR-IR: HPET id 0 under DRHD base 0xfed90000
=5B    0.000000=5D DMAR-IR: Queued invalidation will be enabled to suppor=
t x2apic and Intr-remapping.
=5B    0.000000=5D DMAR-IR: Enabled IRQ remapping in x2apic mode
=5B    0.000000=5D x2apic enabled
=5B    0.000000=5D Switched APIC routing to cluster x2apic.
=5B    0.000000=5D ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 p=
in2=3D-1
=5B    0.005000=5D tsc: Fast TSC calibration using PIT
=5B    0.006000=5D tsc: Detected 2691.328 MHz processor
=5B    0.007000=5D clocksource: tsc-early: mask: 0xffffffffffffffff max_c=
ycles: 0x26cb3e4c6e2, max_idle_ns: 440795296607 ns
=5B    0.007000=5D Calibrating delay loop (skipped), value calculated usi=
ng timer frequency.. 5382.65 BogoMIPS (lpj=3D2691328)
=5B    0.007000=5D pid_max: default: 32768 minimum: 301
=5B    0.007000=5D Security Framework initialized
=5B    0.007000=5D Yama: becoming mindful.
=5B    0.007000=5D SELinux:  Initializing.
=5B    0.007000=5D SELinux:  Starting in permissive mode
=5B    0.007000=5D Mount-cache hash table entries: 32768 (order: 6, 26214=
4 bytes)
=5B    0.007000=5D Mountpoint-cache hash table entries: 32768 (order: 6, =
262144 bytes)
=5B    0.008383=5D CPU: Physical Processor ID: 0
=5B    0.008386=5D CPU: Processor Core ID: 0
=5B    0.008394=5D ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
=5B    0.008396=5D ENERGY_PERF_BIAS: View and update with x86_energy_perf=
_policy(8)
=5B    0.008402=5D mce: CPU supports 7 MCE banks
=5B    0.008425=5D process: using mwait in idle threads
=5B    0.008430=5D Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
=5B    0.008433=5D Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB =
0
=5B    0.008438=5D Spectre V2 : Mitigation: Full generic retpoline
=5B    0.008441=5D Spectre V2 : Spectre v2 mitigation: Enabling Indirect =
Branch Prediction Barrier
=5B    0.008443=5D Spectre V2 : Enabling Restricted Speculation for firmw=
are calls
=5B    0.008608=5D Freeing SMP alternatives memory: 32K
=5B    0.017782=5D TSC deadline timer enabled
=5B    0.017792=5D smpboot: CPU0: Intel(R) Core(TM) i5-3340M CPU =40 2.70=
GHz (family: 0x6, model: 0x3a, stepping: 0x9)
=5B    0.023059=5D Performance Events: PEBS fmt1+, IvyBridge events, 16-d=
eep LBR, full-width counters, Intel PMU driver.
=5B    0.023102=5D ... version:                3
=5B    0.023105=5D ... bit width:              48
=5B    0.023107=5D ... generic registers:      4
=5B    0.023110=5D ... value mask:             0000ffffffffffff
=5B    0.023113=5D ... max period:             00007fffffffffff
=5B    0.023115=5D ... fixed-purpose events:   3
=5B    0.023118=5D ... event mask:             000000070000000f
=5B    0.025039=5D Hierarchical SRCU implementation.
=5B    0.029314=5D NMI watchdog: Enabled. Permanently consumes one hw-PMU=
 counter.
=5B    0.031037=5D smp: Bringing up secondary CPUs ...
=5B    0.039236=5D x86: Booting SMP configuration:
=5B    0.039243=5D .... node  =230, CPUs:      =231 =232 =233
=5B    0.059150=5D smp: Brought up 1 node, 4 CPUs
=5B    0.059150=5D smpboot: Max logical packages: 1
=5B    0.059150=5D smpboot: Total of 4 processors activated (21530.62 Bog=
oMIPS)
=5B    0.061057=5D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=5B    0.061100=5D UBSAN: Undefined behaviour in arch/x86/mm/fault.c:1228=
:12
=5B    0.061126=5D member access within null pointer of type 'struct mm_s=
truct'
=5B    0.061154=5D CPU: 2 PID: 34 Comm: kdevtmpfs Tainted: G             =
   T 4.16.0-rc7-next-20180327-dirty =23565
=5B    0.061157=5D Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A=
20 05/08/2017
=5B    0.061160=5D Call Trace:
=5B    0.061169=5D  dump_stack+0x83/0xca
=5B    0.061179=5D  ubsan_epilogue+0xd/0x3a
=5B    0.061185=5D  handle_null_ptr_deref+0x85/0x90
=5B    0.061193=5D  __ubsan_handle_type_mismatch_v1+0x5e/0x70
=5B    0.061203=5D  __do_page_fault+0x8e4/0x990
=5B    0.061211=5D  ? error_entry+0x82/0x100
=5B    0.061224=5D  do_page_fault+0x43/0x480
=5B    0.061234=5D  page_fault+0x25/0x50
=5B    0.061239=5D RIP: 0010:copy_mount_options+0x191/0x2b0
=5B    0.061242=5D RSP: 0000:ffff99518016fe40 EFLAGS: 00010286
=5B    0.061248=5D RAX: 0000000000000000 RBX: 0000000000001000 RCX: 00000=
00000000ece
=5B    0.061251=5D RDX: ffff995180170000 RSI: 0000000000000001 RDI: ffff8=
9dbda9bc132
=5B    0.061254=5D RBP: ffff99518016fe78 R08: 0000000000000000 R09: 00000=
00000000000
=5B    0.061257=5D R10: 0000000000000000 R11: 0000000000000000 R12: ffff8=
9dbda9bc132
=5B    0.061259=5D R13: ffff89dbda9bc000 R14: ffff995180170ece R15: 00007=
ffffffff000
=5B    0.061287=5D  ksys_mount+0xdc/0x170
=5B    0.061298=5D  devtmpfsd+0xa8/0x1e0
=5B    0.061308=5D  kthread+0x1a9/0x280
=5B    0.061313=5D  ? handle_create+0x390/0x390
=5B    0.061317=5D  ? kthread_create_worker_on_cpu+0x70/0x70
=5B    0.061325=5D  ret_from_fork+0x3a/0x50
=5B    0.061345=5D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=5B    0.061585=5D devtmpfs: initialized
=5B    0.063212=5D clocksource: jiffies: mask: 0xffffffff max_cycles: 0xf=
fffffff, max_idle_ns: 1911260446275000 ns
=5B    0.063212=5D futex hash table entries: 1024 (order: 5, 131072 bytes=
)
=5B    0.064584=5D NET: Registered protocol family 16
=5B    0.065164=5D audit: initializing netlink subsys (disabled)
=5B    0.065260=5D audit: type=3D2000 audit(1522335052.065:1): state=3Din=
itialized audit_enabled=3D0 res=3D1
=5B    0.065402=5D cpuidle: using governor ladder
=5B    0.065444=5D cpuidle: using governor menu
=5B    0.065444=5D ACPI FADT declares the system doesn't support PCIe ASP=
M, so disable it
=5B    0.065444=5D ACPI: bus type PCI registered
=5B    0.066116=5D PCI: MMCONFIG for domain 0000 =5Bbus 00-3f=5D at =5Bme=
m 0xf8000000-0xfbffffff=5D (base 0xf8000000)
=5B    0.066124=5D PCI: MMCONFIG at =5Bmem 0xf8000000-0xfbffffff=5D reser=
ved in E820
=5B    0.066138=5D pmd_set_huge: Cannot satisfy =5Bmem 0xf8000000-0xf8200=
000=5D with a huge-page mapping due to MTRR override.
=5B    0.066265=5D PCI: Using configuration type 1 for base access
=5B    0.066435=5D core: PMU erratum BJ122, BV98, HSD29 worked around, HT=
 is on
=5B    0.076102=5D HugeTLB registered 2.00 MiB page size, pre-allocated 0=
 pages
=5B    0.077300=5D ACPI: Added _OSI(Module Device)
=5B    0.077305=5D ACPI: Added _OSI(Processor Device)
=5B    0.077309=5D ACPI: Added _OSI(3.0 _SCP Extensions)
=5B    0.077313=5D ACPI: Added _OSI(Processor Aggregator Device)
=5B    0.077318=5D ACPI: Added _OSI(Linux-Dell-Video)
=5B    0.114834=5D ACPI: 6 ACPI AML tables successfully acquired and load=
ed
=5B    0.141081=5D ACPI: =5BFirmware Bug=5D: BIOS _OSI(Linux) query ignor=
ed
=5B    0.148101=5D ACPI: Dynamic OEM Table Load:
=5B    0.148129=5D ACPI: SSDT 0xFFFF89DBDABB2800 000523 (v01 PmRef  Cpu0C=
st  00003001 INTL 20051117)
=5B    0.149820=5D ACPI: Dynamic OEM Table Load:
=5B    0.149846=5D ACPI: SSDT 0xFFFF89DBDABF1800 000303 (v01 PmRef  ApIst=
    00003000 INTL 20051117)
=5B    0.150910=5D ACPI: Dynamic OEM Table Load:
=5B    0.150936=5D ACPI: SSDT 0xFFFF89DBDA414A00 000119 (v01 PmRef  ApCst=
    00003000 INTL 20051117)
=5B    0.155118=5D ACPI: EC: EC started
=5B    0.155124=5D ACPI: EC: interrupt blocked
=5B    0.161343=5D ACPI: =5C_SB_.PCI0.LPCB.ECDV: Used as first EC
=5B    0.161350=5D ACPI: =5C_SB_.PCI0.LPCB.ECDV: GPE=3D0x10, EC_CMD/EC_SC=
=3D0x934, EC_DATA=3D0x930
=5B    0.161355=5D ACPI: =5C_SB_.PCI0.LPCB.ECDV: Used as boot DSDT EC to =
handle transactions
=5B    0.161358=5D ACPI: Interpreter enabled
=5B    0.161377=5D ACPI: (supports S0 S5)
=5B    0.161381=5D ACPI: Using IOAPIC for interrupt routing
=5B    0.161479=5D PCI: Using host bridge windows from ACPI; if necessary=
, use =22pci=3Dnocrs=22 and report a bug
=5B    0.162659=5D ACPI: Enabled 14 GPEs in block 00 to 3F
=5B    0.205434=5D acpi LNXIOBAY:00: ACPI dock station (docks/bays count:=
 1)
=5B    0.229963=5D ACPI: PCI Root Bridge =5BPCI0=5D (domain 0000 =5Bbus 0=
0-3e=5D)
=5B    0.229977=5D acpi PNP0A08:00: _OSC: OS supports =5BExtendedConfig A=
SPM ClockPM Segments MSI=5D
=5B    0.230738=5D acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASP=
M
=5B    0.232083=5D PCI host bridge to bus 0000:00
=5B    0.232090=5D pci_bus 0000:00: root bus resource =5Bio  0x0000-0x0cf=
7 window=5D
=5B    0.232094=5D pci_bus 0000:00: root bus resource =5Bio  0x0d00-0xfff=
f window=5D
=5B    0.232099=5D pci_bus 0000:00: root bus resource =5Bmem 0x000a0000-0=
x000bffff window=5D
=5B    0.232103=5D pci_bus 0000:00: root bus resource =5Bmem 0x000c0000-0=
x000c3fff window=5D
=5B    0.232107=5D pci_bus 0000:00: root bus resource =5Bmem 0x000c4000-0=
x000c7fff window=5D
=5B    0.232111=5D pci_bus 0000:00: root bus resource =5Bmem 0x000c8000-0=
x000cbfff window=5D
=5B    0.232115=5D pci_bus 0000:00: root bus resource =5Bmem 0x000cc000-0=
x000cffff window=5D
=5B    0.232120=5D pci_bus 0000:00: root bus resource =5Bmem 0x000d0000-0=
x000d3fff window=5D
=5B    0.232124=5D pci_bus 0000:00: root bus resource =5Bmem 0x000d4000-0=
x000d7fff window=5D
=5B    0.232128=5D pci_bus 0000:00: root bus resource =5Bmem 0x000d8000-0=
x000dbfff window=5D
=5B    0.232132=5D pci_bus 0000:00: root bus resource =5Bmem 0x000dc000-0=
x000dffff window=5D
=5B    0.232136=5D pci_bus 0000:00: root bus resource =5Bmem 0xd0000000-0=
xfeafffff window=5D
=5B    0.232142=5D pci_bus 0000:00: root bus resource =5Bbus 00-3e=5D
=5B    0.232172=5D pci 0000:00:00.0: =5B8086:0154=5D type 00 class 0x0600=
00
=5B    0.232715=5D pci 0000:00:01.0: =5B8086:0151=5D type 01 class 0x0604=
00
=5B    0.232798=5D pci 0000:00:01.0: PME=23 supported from D0 D3hot D3col=
d
=5B    0.233419=5D pci 0000:00:14.0: =5B8086:1e31=5D type 00 class 0x0c03=
30
=5B    0.233470=5D pci 0000:00:14.0: reg 0x10: =5Bmem 0xf7720000-0xf772ff=
ff 64bit=5D
=5B    0.233620=5D pci 0000:00:14.0: PME=23 supported from D3hot D3cold
=5B    0.234120=5D pci 0000:00:16.0: =5B8086:1e3a=5D type 00 class 0x0780=
00
=5B    0.234169=5D pci 0000:00:16.0: reg 0x10: =5Bmem 0xf773c000-0xf773c0=
0f 64bit=5D
=5B    0.234322=5D pci 0000:00:16.0: PME=23 supported from D0 D3hot D3col=
d
=5B    0.234807=5D pci 0000:00:19.0: =5B8086:1502=5D type 00 class 0x0200=
00
=5B    0.234852=5D pci 0000:00:19.0: reg 0x10: =5Bmem 0xf7700000-0xf771ff=
ff=5D
=5B    0.234870=5D pci 0000:00:19.0: reg 0x14: =5Bmem 0xf7739000-0xf7739f=
ff=5D
=5B    0.234889=5D pci 0000:00:19.0: reg 0x18: =5Bio  0xf040-0xf05f=5D
=5B    0.235042=5D pci 0000:00:19.0: PME=23 supported from D0 D3hot D3col=
d
=5B    0.235533=5D pci 0000:00:1a.0: =5B8086:1e2d=5D type 00 class 0x0c03=
20
=5B    0.235578=5D pci 0000:00:1a.0: reg 0x10: =5Bmem 0xf7738000-0xf77383=
ff=5D
=5B    0.235746=5D pci 0000:00:1a.0: PME=23 supported from D0 D3hot D3col=
d
=5B    0.236256=5D pci 0000:00:1b.0: =5B8086:1e20=5D type 00 class 0x0403=
00
=5B    0.236305=5D pci 0000:00:1b.0: reg 0x10: =5Bmem 0xf7730000-0xf7733f=
ff 64bit=5D
=5B    0.236480=5D pci 0000:00:1b.0: PME=23 supported from D0 D3hot D3col=
d
=5B    0.236970=5D pci 0000:00:1c.0: =5B8086:1e10=5D type 01 class 0x0604=
00
=5B    0.237170=5D pci 0000:00:1c.0: PME=23 supported from D0 D3hot D3col=
d
=5B    0.237213=5D pci 0000:00:1c.0: Enabling MPC IRBNCE
=5B    0.237220=5D pci 0000:00:1c.0: Intel PCH root port ACS workaround e=
nabled
=5B    0.237710=5D pci 0000:00:1c.1: =5B8086:1e12=5D type 01 class 0x0604=
00
=5B    0.237896=5D pci 0000:00:1c.1: PME=23 supported from D0 D3hot D3col=
d
=5B    0.237936=5D pci 0000:00:1c.1: Enabling MPC IRBNCE
=5B    0.237942=5D pci 0000:00:1c.1: Intel PCH root port ACS workaround e=
nabled
=5B    0.238447=5D pci 0000:00:1c.2: =5B8086:1e14=5D type 01 class 0x0604=
00
=5B    0.238636=5D pci 0000:00:1c.2: PME=23 supported from D0 D3hot D3col=
d
=5B    0.238675=5D pci 0000:00:1c.2: Enabling MPC IRBNCE
=5B    0.238680=5D pci 0000:00:1c.2: Intel PCH root port ACS workaround e=
nabled
=5B    0.239190=5D pci 0000:00:1c.3: =5B8086:1e16=5D type 01 class 0x0604=
00
=5B    0.239375=5D pci 0000:00:1c.3: PME=23 supported from D0 D3hot D3col=
d
=5B    0.239415=5D pci 0000:00:1c.3: Enabling MPC IRBNCE
=5B    0.239421=5D pci 0000:00:1c.3: Intel PCH root port ACS workaround e=
nabled
=5B    0.239916=5D pci 0000:00:1c.5: =5B8086:1e1a=5D type 01 class 0x0604=
00
=5B    0.240112=5D pci 0000:00:1c.5: PME=23 supported from D0 D3hot D3col=
d
=5B    0.240153=5D pci 0000:00:1c.5: Enabling MPC IRBNCE
=5B    0.240159=5D pci 0000:00:1c.5: Intel PCH root port ACS workaround e=
nabled
=5B    0.240658=5D pci 0000:00:1d.0: =5B8086:1e26=5D type 00 class 0x0c03=
20
=5B    0.240703=5D pci 0000:00:1d.0: reg 0x10: =5Bmem 0xf7737000-0xf77373=
ff=5D
=5B    0.240876=5D pci 0000:00:1d.0: PME=23 supported from D0 D3hot D3col=
d
=5B    0.241378=5D pci 0000:00:1f.0: =5B8086:1e55=5D type 00 class 0x0601=
00
=5B    0.242052=5D pci 0000:00:1f.2: =5B8086:1e03=5D type 00 class 0x0106=
01
=5B    0.242097=5D pci 0000:00:1f.2: reg 0x10: =5Bio  0xf090-0xf097=5D
=5B    0.242115=5D pci 0000:00:1f.2: reg 0x14: =5Bio  0xf080-0xf083=5D
=5B    0.242134=5D pci 0000:00:1f.2: reg 0x18: =5Bio  0xf070-0xf077=5D
=5B    0.242154=5D pci 0000:00:1f.2: reg 0x1c: =5Bio  0xf060-0xf063=5D
=5B    0.242172=5D pci 0000:00:1f.2: reg 0x20: =5Bio  0xf020-0xf03f=5D
=5B    0.242192=5D pci 0000:00:1f.2: reg 0x24: =5Bmem 0xf7736000-0xf77367=
ff=5D
=5B    0.242301=5D pci 0000:00:1f.2: PME=23 supported from D3hot
=5B    0.242780=5D pci 0000:00:1f.3: =5B8086:1e22=5D type 00 class 0x0c05=
00
=5B    0.242823=5D pci 0000:00:1f.3: reg 0x10: =5Bmem 0xf7735000-0xf77350=
ff 64bit=5D
=5B    0.242873=5D pci 0000:00:1f.3: reg 0x20: =5Bio  0xf000-0xf01f=5D
=5B    0.243499=5D pci 0000:01:00.0: =5B10de:0dfc=5D type 00 class 0x0300=
00
=5B    0.243527=5D pci 0000:01:00.0: reg 0x10: =5Bmem 0xf5000000-0xf5ffff=
ff=5D
=5B    0.243544=5D pci 0000:01:00.0: reg 0x14: =5Bmem 0xe0000000-0xefffff=
ff 64bit pref=5D
=5B    0.243561=5D pci 0000:01:00.0: reg 0x1c: =5Bmem 0xf0000000-0xf1ffff=
ff 64bit pref=5D
=5B    0.243573=5D pci 0000:01:00.0: reg 0x24: =5Bio  0xe000-0xe07f=5D
=5B    0.243585=5D pci 0000:01:00.0: reg 0x30: =5Bmem 0xf6000000-0xf607ff=
ff pref=5D
=5B    0.243595=5D pci 0000:01:00.0: enabling Extended Tags
=5B    0.243624=5D pci 0000:01:00.0: BAR 1: assigned to efifb
=5B    0.244367=5D pci 0000:01:00.1: =5B10de:0bea=5D type 00 class 0x0403=
00
=5B    0.244389=5D pci 0000:01:00.1: reg 0x10: =5Bmem 0xf6080000-0xf6083f=
ff=5D
=5B    0.244434=5D pci 0000:01:00.1: enabling Extended Tags
=5B    0.244708=5D pci 0000:00:01.0: PCI bridge to =5Bbus 01=5D
=5B    0.244713=5D pci 0000:00:01.0:   bridge window =5Bio  0xe000-0xefff=
=5D
=5B    0.244719=5D pci 0000:00:01.0:   bridge window =5Bmem 0xf5000000-0x=
f60fffff=5D
=5B    0.244725=5D pci 0000:00:01.0:   bridge window =5Bmem 0xe0000000-0x=
f1ffffff 64bit pref=5D
=5B    0.244849=5D pci 0000:00:1c.0: PCI bridge to =5Bbus 02=5D
=5B    0.245035=5D pci 0000:03:00.0: =5B14e4:4727=5D type 00 class 0x0280=
00
=5B    0.245095=5D pci 0000:03:00.0: reg 0x10: =5Bmem 0xf7600000-0xf7603f=
ff 64bit=5D
=5B    0.245181=5D pci 0000:03:00.0: enabling Extended Tags
=5B    0.245353=5D pci 0000:03:00.0: supports D1 D2
=5B    0.245357=5D pci 0000:03:00.0: PME=23 supported from D0 D3hot D3col=
d
=5B    0.245635=5D pci 0000:00:1c.1: PCI bridge to =5Bbus 03=5D
=5B    0.245648=5D pci 0000:00:1c.1:   bridge window =5Bmem 0xf7600000-0x=
f76fffff=5D
=5B    0.245775=5D pci 0000:00:1c.2: PCI bridge to =5Bbus 04-07=5D
=5B    0.245783=5D pci 0000:00:1c.2:   bridge window =5Bio  0xd000-0xdfff=
=5D
=5B    0.245791=5D pci 0000:00:1c.2:   bridge window =5Bmem 0xf6b00000-0x=
f74fffff=5D
=5B    0.245803=5D pci 0000:00:1c.2:   bridge window =5Bmem 0xf2b00000-0x=
f34fffff 64bit pref=5D
=5B    0.245919=5D pci 0000:00:1c.3: PCI bridge to =5Bbus 08-0b=5D
=5B    0.245927=5D pci 0000:00:1c.3:   bridge window =5Bio  0xc000-0xcfff=
=5D
=5B    0.245935=5D pci 0000:00:1c.3:   bridge window =5Bmem 0xf6100000-0x=
f6afffff=5D
=5B    0.245949=5D pci 0000:00:1c.3:   bridge window =5Bmem 0xf2100000-0x=
f2afffff 64bit pref=5D
=5B    0.246208=5D pci 0000:0c:00.0: =5B1217:8221=5D type 00 class 0x0805=
01
=5B    0.246295=5D pci 0000:0c:00.0: reg 0x10: =5Bmem 0xf7502000-0xf75021=
ff=5D
=5B    0.246683=5D pci 0000:0c:00.0: supports D1 D2
=5B    0.246687=5D pci 0000:0c:00.0: PME=23 supported from D0 D1 D2 D3hot=
 D3cold
=5B    0.249184=5D pci 0000:00:1c.5: PCI bridge to =5Bbus 0c=5D
=5B    0.249199=5D pci 0000:00:1c.5:   bridge window =5Bmem 0xf7500000-0x=
f75fffff=5D
=5B    0.249276=5D pci_bus 0000:00: on NUMA node 0
=5B    0.255867=5D ACPI: PCI Interrupt Link =5BLNKA=5D (IRQs 3 4 5 6 10 1=
1 12 14 15) *0, disabled.
=5B    0.256200=5D ACPI: PCI Interrupt Link =5BLNKB=5D (IRQs 3 4 5 6 10 1=
1 12 14 15) *0, disabled.
=5B    0.256516=5D ACPI: PCI Interrupt Link =5BLNKC=5D (IRQs 3 4 5 6 10 1=
1 12 14 15) *0, disabled.
=5B    0.256828=5D ACPI: PCI Interrupt Link =5BLNKD=5D (IRQs 3 4 5 6 10 1=
1 12 14 15) *0, disabled.
=5B    0.257153=5D ACPI: PCI Interrupt Link =5BLNKE=5D (IRQs 3 4 5 6 10 1=
1 12 14 15) *0, disabled.
=5B    0.257469=5D ACPI: PCI Interrupt Link =5BLNKF=5D (IRQs 3 4 5 6 10 1=
1 12 14 15) *0, disabled.
=5B    0.257784=5D ACPI: PCI Interrupt Link =5BLNKG=5D (IRQs 3 4 5 6 10 1=
1 12 14 15) *0, disabled.
=5B    0.258110=5D ACPI: PCI Interrupt Link =5BLNKH=5D (IRQs 3 4 5 6 10 1=
1 12 14 15) *0, disabled.
=5B    0.267278=5D ACPI: EC: interrupt unblocked
=5B    0.267314=5D ACPI: EC: event unblocked
=5B    0.267326=5D ACPI: =5C_SB_.PCI0.LPCB.ECDV: GPE=3D0x10, EC_CMD/EC_SC=
=3D0x934, EC_DATA=3D0x930
=5B    0.267334=5D ACPI: =5C_SB_.PCI0.LPCB.ECDV: Used as boot DSDT EC to =
handle transactions and events
=5B    0.268048=5D pci 0000:01:00.0: vgaarb: setting as boot VGA device
=5B    0.268054=5D pci 0000:01:00.0: vgaarb: VGA device added: decodes=3D=
io+mem,owns=3Dio+mem,locks=3Dnone
=5B    0.268061=5D pci 0000:01:00.0: vgaarb: bridge control possible
=5B    0.268065=5D vgaarb: loaded
=5B    0.268531=5D SCSI subsystem initialized
=5B    0.268570=5D libata version 3.00 loaded.
=5B    0.268595=5D ACPI: bus type USB registered
=5B    0.268679=5D usbcore: registered new interface driver usbfs
=5B    0.268722=5D usbcore: registered new interface driver hub
=5B    0.268823=5D usbcore: registered new device driver usb
=5B    0.268879=5D Linux video capture interface: v2.00
=5B    0.268903=5D pps_core: LinuxPPS API ver. 1 registered
=5B    0.268906=5D pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Ro=
dolfo Giometti <giometti=40linux.it>
=5B    0.268920=5D PTP clock support registered
=5B    0.269066=5D Registered efivars operations
=5B    0.276698=5D Advanced Linux Sound Architecture Driver Initialized.
=5B    0.276779=5D PCI: Using ACPI for IRQ routing
=5B    0.280492=5D PCI: pci_cache_line_size set to 64 bytes
=5B    0.280706=5D e820: reserve RAM buffer =5Bmem 0x0009d000-0x0009ffff=
=5D
=5B    0.280713=5D e820: reserve RAM buffer =5Bmem 0xc7b50018-0xc7ffffff=
=5D
=5B    0.280718=5D e820: reserve RAM buffer =5Bmem 0xca70a000-0xcbffffff=
=5D
=5B    0.280722=5D e820: reserve RAM buffer =5Bmem 0xcaf53000-0xcbffffff=
=5D
=5B    0.280726=5D e820: reserve RAM buffer =5Bmem 0xcb7b2000-0xcbffffff=
=5D
=5B    0.280730=5D e820: reserve RAM buffer =5Bmem 0xccefe000-0xcfffffff=
=5D
=5B    0.280735=5D e820: reserve RAM buffer =5Bmem 0xce5af000-0xcfffffff=
=5D
=5B    0.280739=5D e820: reserve RAM buffer =5Bmem 0xcf2b2000-0xcfffffff=
=5D
=5B    0.280744=5D e820: reserve RAM buffer =5Bmem 0xcf800000-0xcfffffff=
=5D
=5B    0.280748=5D e820: reserve RAM buffer =5Bmem 0x40dfad000-0x40ffffff=
f=5D
=5B    0.280752=5D e820: reserve RAM buffer =5Bmem 0x40dfaf000-0x40ffffff=
f=5D
=5B    0.280757=5D e820: reserve RAM buffer =5Bmem 0x40dfeb000-0x40ffffff=
f=5D
=5B    0.280761=5D e820: reserve RAM buffer =5Bmem 0x42e000000-0x42ffffff=
f=5D
=5B    0.281325=5D NetLabel: Initializing
=5B    0.281329=5D NetLabel:  domain hash size =3D 128
=5B    0.281331=5D NetLabel:  protocols =3D UNLABELED CIPSOv4 CALIPSO
=5B    0.281390=5D NetLabel:  unlabeled traffic allowed by default
=5B    0.281503=5D dcdbas dcdbas: Dell Systems Management Base Driver (ve=
rsion 5.6.0-3.2)
=5B    0.282119=5D wmi_bus wmi_bus-PNP0C14:00: WQBC data block query cont=
rol method not found
=5B    0.282549=5D hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0=

=5B    0.282576=5D hpet0: 8 comparators, 64-bit 14.318180 MHz counter
=5B    0.285071=5D clocksource: Switched to clocksource tsc-early
=5B    0.290212=5D Warning: could not register annotated branches stats
=5B    0.359621=5D VFS: Disk quotas dquot_6.6.0
=5B    0.359664=5D VFS: Dquot-cache hash table entries: 512 (order 0, 409=
6 bytes)
=5B    0.359905=5D pnp: PnP ACPI init
=5B    0.360387=5D system 00:00: =5Bio  0x0680-0x069f=5D has been reserve=
d
=5B    0.360395=5D system 00:00: =5Bio  0x1000-0x100f=5D has been reserve=
d
=5B    0.360401=5D system 00:00: =5Bio  0x1100-0x1103=5D has been reserve=
d
=5B    0.360407=5D system 00:00: =5Bio  0xffff=5D has been reserved
=5B    0.360413=5D system 00:00: =5Bio  0x0400-0x0453=5D has been reserve=
d
=5B    0.360418=5D system 00:00: =5Bio  0x0458-0x047f=5D has been reserve=
d
=5B    0.360424=5D system 00:00: =5Bio  0x0500-0x057f=5D has been reserve=
d
=5B    0.360430=5D system 00:00: =5Bio  0x164e-0x164f=5D has been reserve=
d
=5B    0.360458=5D system 00:00: Plug and Play ACPI device, IDs PNP0c02 (=
active)
=5B    0.360560=5D pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (act=
ive)
=5B    0.360774=5D system 00:02: =5Bio  0x0454-0x0457=5D has been reserve=
d
=5B    0.360788=5D system 00:02: Plug and Play ACPI device, IDs INT3f0d P=
NP0c02 (active)
=5B    0.360988=5D system 00:03: =5Bio  0x04d0-0x04d1=5D has been reserve=
d
=5B    0.361027=5D system 00:03: Plug and Play ACPI device, IDs PNP0c02 (=
active)
=5B    0.361194=5D pnp 00:04: Plug and Play ACPI device, IDs PNP0303 (act=
ive)
=5B    0.361284=5D pnp 00:05: Plug and Play ACPI device, IDs DLL0535 PNP0=
f13 (active)
=5B    0.364343=5D pnp 00:06: Plug and Play ACPI device, IDs PNP0401 (dis=
abled)
=5B    0.366665=5D system 00:07: =5Bmem 0xfed1c000-0xfed1ffff=5D has been=
 reserved
=5B    0.366672=5D system 00:07: =5Bmem 0xfed10000-0xfed17fff=5D has been=
 reserved
=5B    0.366678=5D system 00:07: =5Bmem 0xfed18000-0xfed18fff=5D has been=
 reserved
=5B    0.366684=5D system 00:07: =5Bmem 0xfed19000-0xfed19fff=5D has been=
 reserved
=5B    0.366689=5D system 00:07: =5Bmem 0xf8000000-0xfbffffff=5D has been=
 reserved
=5B    0.366695=5D system 00:07: =5Bmem 0xfed20000-0xfed3ffff=5D has been=
 reserved
=5B    0.366702=5D system 00:07: =5Bmem 0xfed90000-0xfed93fff=5D could no=
t be reserved
=5B    0.366707=5D system 00:07: =5Bmem 0xfed45000-0xfed8ffff=5D has been=
 reserved
=5B    0.366713=5D system 00:07: =5Bmem 0xff000000-0xffffffff=5D has been=
 reserved
=5B    0.366719=5D system 00:07: =5Bmem 0xfee00000-0xfeefffff=5D could no=
t be reserved
=5B    0.366725=5D system 00:07: =5Bmem 0xd0000000-0xd0000fff=5D has been=
 reserved
=5B    0.366739=5D system 00:07: Plug and Play ACPI device, IDs PNP0c02 (=
active)
=5B    0.376077=5D pnp 00:08: Plug and Play ACPI device, IDs PNP0c31 (act=
ive)
=5B    0.376101=5D pnp: PnP ACPI: found 9 devices
=5B    0.388681=5D clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xfff=
fff, max_idle_ns: 2085701024 ns
=5B    0.388771=5D pci 0000:00:01.0: PCI bridge to =5Bbus 01=5D
=5B    0.388776=5D pci 0000:00:01.0:   bridge window =5Bio  0xe000-0xefff=
=5D
=5B    0.388782=5D pci 0000:00:01.0:   bridge window =5Bmem 0xf5000000-0x=
f60fffff=5D
=5B    0.388787=5D pci 0000:00:01.0:   bridge window =5Bmem 0xe0000000-0x=
f1ffffff 64bit pref=5D
=5B    0.388794=5D pci 0000:00:1c.0: PCI bridge to =5Bbus 02=5D
=5B    0.388819=5D pci 0000:00:1c.1: PCI bridge to =5Bbus 03=5D
=5B    0.388831=5D pci 0000:00:1c.1:   bridge window =5Bmem 0xf7600000-0x=
f76fffff=5D
=5B    0.388847=5D pci 0000:00:1c.2: PCI bridge to =5Bbus 04-07=5D
=5B    0.388854=5D pci 0000:00:1c.2:   bridge window =5Bio  0xd000-0xdfff=
=5D
=5B    0.388864=5D pci 0000:00:1c.2:   bridge window =5Bmem 0xf6b00000-0x=
f74fffff=5D
=5B    0.388872=5D pci 0000:00:1c.2:   bridge window =5Bmem 0xf2b00000-0x=
f34fffff 64bit pref=5D
=5B    0.388884=5D pci 0000:00:1c.3: PCI bridge to =5Bbus 08-0b=5D
=5B    0.388889=5D pci 0000:00:1c.3:   bridge window =5Bio  0xc000-0xcfff=
=5D
=5B    0.388899=5D pci 0000:00:1c.3:   bridge window =5Bmem 0xf6100000-0x=
f6afffff=5D
=5B    0.388907=5D pci 0000:00:1c.3:   bridge window =5Bmem 0xf2100000-0x=
f2afffff 64bit pref=5D
=5B    0.388919=5D pci 0000:00:1c.5: PCI bridge to =5Bbus 0c=5D
=5B    0.388929=5D pci 0000:00:1c.5:   bridge window =5Bmem 0xf7500000-0x=
f75fffff=5D
=5B    0.388946=5D pci_bus 0000:00: resource 4 =5Bio  0x0000-0x0cf7 windo=
w=5D
=5B    0.388950=5D pci_bus 0000:00: resource 5 =5Bio  0x0d00-0xffff windo=
w=5D
=5B    0.388954=5D pci_bus 0000:00: resource 6 =5Bmem 0x000a0000-0x000bff=
ff window=5D
=5B    0.388957=5D pci_bus 0000:00: resource 7 =5Bmem 0x000c0000-0x000c3f=
ff window=5D
=5B    0.388961=5D pci_bus 0000:00: resource 8 =5Bmem 0x000c4000-0x000c7f=
ff window=5D
=5B    0.388964=5D pci_bus 0000:00: resource 9 =5Bmem 0x000c8000-0x000cbf=
ff window=5D
=5B    0.388968=5D pci_bus 0000:00: resource 10 =5Bmem 0x000cc000-0x000cf=
fff window=5D
=5B    0.388972=5D pci_bus 0000:00: resource 11 =5Bmem 0x000d0000-0x000d3=
fff window=5D
=5B    0.388975=5D pci_bus 0000:00: resource 12 =5Bmem 0x000d4000-0x000d7=
fff window=5D
=5B    0.388979=5D pci_bus 0000:00: resource 13 =5Bmem 0x000d8000-0x000db=
fff window=5D
=5B    0.388983=5D pci_bus 0000:00: resource 14 =5Bmem 0x000dc000-0x000df=
fff window=5D
=5B    0.388986=5D pci_bus 0000:00: resource 15 =5Bmem 0xd0000000-0xfeaff=
fff window=5D
=5B    0.388990=5D pci_bus 0000:01: resource 0 =5Bio  0xe000-0xefff=5D
=5B    0.388994=5D pci_bus 0000:01: resource 1 =5Bmem 0xf5000000-0xf60fff=
ff=5D
=5B    0.388997=5D pci_bus 0000:01: resource 2 =5Bmem 0xe0000000-0xf1ffff=
ff 64bit pref=5D
=5B    0.389022=5D pci_bus 0000:03: resource 1 =5Bmem 0xf7600000-0xf76fff=
ff=5D
=5B    0.389026=5D pci_bus 0000:04: resource 0 =5Bio  0xd000-0xdfff=5D
=5B    0.389029=5D pci_bus 0000:04: resource 1 =5Bmem 0xf6b00000-0xf74fff=
ff=5D
=5B    0.389033=5D pci_bus 0000:04: resource 2 =5Bmem 0xf2b00000-0xf34fff=
ff 64bit pref=5D
=5B    0.389037=5D pci_bus 0000:08: resource 0 =5Bio  0xc000-0xcfff=5D
=5B    0.389040=5D pci_bus 0000:08: resource 1 =5Bmem 0xf6100000-0xf6afff=
ff=5D
=5B    0.389044=5D pci_bus 0000:08: resource 2 =5Bmem 0xf2100000-0xf2afff=
ff 64bit pref=5D
=5B    0.389047=5D pci_bus 0000:0c: resource 1 =5Bmem 0xf7500000-0xf75fff=
ff=5D
=5B    0.389662=5D NET: Registered protocol family 2
=5B    0.390207=5D tcp_listen_portaddr_hash hash table entries: 8192 (ord=
er: 7, 720896 bytes)
=5B    0.390683=5D TCP established hash table entries: 131072 (order: 8, =
1048576 bytes)
=5B    0.391086=5D TCP bind hash table entries: 32768 (order: 9, 2621440 =
bytes)
=5B    0.392888=5D TCP: Hash tables configured (established 131072 bind 3=
2768)
=5B    0.393137=5D UDP hash table entries: 8192 (order: 8, 1572864 bytes)=

=5B    0.394144=5D UDP-Lite hash table entries: 8192 (order: 8, 1572864 b=
ytes)
=5B    0.395320=5D NET: Registered protocol family 1
=5B    0.416598=5D pci 0000:00:1a.0: quirk_usb_early_handoff+0x0/0x71a to=
ok 17777 usecs
=5B    0.434595=5D pci 0000:00:1d.0: quirk_usb_early_handoff+0x0/0x71a to=
ok 17533 usecs
=5B    0.434636=5D pci 0000:01:00.0: Video device with shadowed ROM at =
=5Bmem 0x000c0000-0x000dffff=5D
=5B    0.434671=5D pci 0000:01:00.1: Linked as a consumer to 0000:01:00.0=

=5B    0.434815=5D PCI: CLS mismatch (64 =21=3D 32), using 64 bytes
=5B    0.435143=5D Unpacking initramfs...
=5B    1.837656=5D Freeing initrd memory: 12052K
=5B    1.837761=5D DMAR: No ATSR found
=5B    1.837937=5D DMAR: dmar0: Using Queued invalidation
=5B    1.837980=5D DMAR: Setting RMRR:
=5B    1.838237=5D DMAR: Setting identity map for device 0000:00:14.0 =5B=
0xce715000 - 0xce734fff=5D
=5B    1.838397=5D DMAR: Setting identity map for device 0000:00:1a.0 =5B=
0xce715000 - 0xce734fff=5D
=5B    1.838529=5D DMAR: Setting identity map for device 0000:00:1d.0 =5B=
0xce715000 - 0xce734fff=5D
=5B    1.838547=5D DMAR: Prepare 0-16MiB unity mapping for LPC
=5B    1.838694=5D DMAR: Setting identity map for device 0000:00:1f.0 =5B=
0x0 - 0xffffff=5D
=5B    1.838805=5D DMAR: Intel(R) Virtualization Technology for Directed =
I/O
=5B    1.838982=5D iommu: Adding device 0000:00:00.0 to group 0
=5B    1.839074=5D iommu: Adding device 0000:00:01.0 to group 1
=5B    1.839123=5D iommu: Adding device 0000:00:14.0 to group 2
=5B    1.839190=5D iommu: Adding device 0000:00:16.0 to group 3
=5B    1.839238=5D iommu: Adding device 0000:00:19.0 to group 4
=5B    1.839286=5D iommu: Adding device 0000:00:1a.0 to group 5
=5B    1.839336=5D iommu: Adding device 0000:00:1b.0 to group 6
=5B    1.839384=5D iommu: Adding device 0000:00:1c.0 to group 7
=5B    1.839435=5D iommu: Adding device 0000:00:1c.1 to group 8
=5B    1.839484=5D iommu: Adding device 0000:00:1c.2 to group 9
=5B    1.839533=5D iommu: Adding device 0000:00:1c.3 to group 10
=5B    1.839581=5D iommu: Adding device 0000:00:1c.5 to group 11
=5B    1.839631=5D iommu: Adding device 0000:00:1d.0 to group 12
=5B    1.839731=5D iommu: Adding device 0000:00:1f.0 to group 13
=5B    1.839779=5D iommu: Adding device 0000:00:1f.2 to group 13
=5B    1.839827=5D iommu: Adding device 0000:00:1f.3 to group 13
=5B    1.839848=5D iommu: Adding device 0000:01:00.0 to group 1
=5B    1.839872=5D iommu: Adding device 0000:01:00.1 to group 1
=5B    1.839920=5D iommu: Adding device 0000:03:00.0 to group 14
=5B    1.839968=5D iommu: Adding device 0000:0c:00.0 to group 15
=5B    1.846429=5D RAPL PMU: API unit is 2=5E-32 Joules, 3 fixed counters=
, 163840 ms ovfl timer
=5B    1.846432=5D RAPL PMU: hw unit of domain pp0-core 2=5E-16 Joules
=5B    1.846435=5D RAPL PMU: hw unit of domain package 2=5E-16 Joules
=5B    1.846438=5D RAPL PMU: hw unit of domain pp1-gpu 2=5E-16 Joules
=5B    1.848846=5D cryptomgr_test (55) used greatest stack depth: 14352 b=
ytes left
=5B    1.850687=5D Initialise system trusted keyrings
=5B    1.850882=5D workingset: timestamp_bits=3D46 max_order=3D22 bucket_=
order=3D0
=5B    1.851129=5D zbud: loaded
=5B    1.851926=5D pstore: using deflate compression
=5B    1.852139=5D SELinux:  Registering netfilter hooks
=5B    1.853334=5D cryptomgr_test (57) used greatest stack depth: 14064 b=
ytes left
=5B    1.858646=5D Key type asymmetric registered
=5B    1.858664=5D Asymmetric key parser 'x509' registered
=5B    1.858689=5D io scheduler noop registered
=5B    1.858694=5D io scheduler deadline registered
=5B    1.858728=5D io scheduler cfq registered (default)
=5B    1.858847=5D atomic64_test: passed for x86-64 platform with CX8 and=
 with SSE
=5B    1.863448=5D efifb: probing for efifb
=5B    1.863490=5D efifb: framebuffer at 0xe0000000, using 8100k, total 8=
100k
=5B    1.863494=5D efifb: mode is 1920x1080x32, linelength=3D7680, pages=
=3D1
=5B    1.863497=5D efifb: scrolling: redraw
=5B    1.863500=5D efifb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
=5B    1.869999=5D Console: switching to colour frame buffer device 240x6=
7
=5B    1.875932=5D fb0: EFI VGA frame buffer device
=5B    1.875965=5D intel_idle: MWAIT substates: 0x21120
=5B    1.875968=5D intel_idle: v0.4.1 model 0x3A
=5B    1.876807=5D intel_idle: lapic_timer_reliable_states 0xffffffff
=5B    2.296273=5D ACPI: AC Adapter =5BAC=5D (off-line)
=5B    2.296559=5D input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/=
PNP0C0D:00/input/input0
=5B    2.296567=5D ACPI: Lid Switch =5BLID0=5D
=5B    2.296702=5D input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:0=
0/PNP0C0C:00/input/input1
=5B    2.296726=5D ACPI: Power Button =5BPBTN=5D
=5B    2.296868=5D input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:0=
0/PNP0C0E:00/input/input2
=5B    2.296876=5D ACPI: Sleep Button =5BSBTN=5D
=5B    2.297035=5D input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:0=
0/input/input3
=5B    2.297042=5D ACPI: Power Button =5BPWRF=5D
=5B    2.301507=5D ACPI: Video Device =5BVID=5D (multi-head: yes  rom: ye=
s  post: no)
=5B    2.303890=5D input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/P=
NP0A08:00/device:14/LNXVIDEO:00/input/input4
=5B    2.312351=5D thermal LNXTHERM:00: registered as thermal_zone0
=5B    2.312355=5D ACPI: Thermal Zone =5BTHM=5D (38 C)
=5B    2.313097=5D Serial: 8250/16550 driver, 4 ports, IRQ sharing enable=
d
=5B    2.316089=5D Hangcheck: starting hangcheck timer 0.9.1 (tick is 180=
 seconds, margin is 60 seconds).
=5B    2.321700=5D tpm_tis 00:08: 1.2 TPM (device-id 0x3204, rev-id 64)
=5B    2.384677=5D ACPI: Battery Slot =5BBAT0=5D (battery present)
=5B    2.386295=5D loop: module loaded
=5B    2.387443=5D zram: Added device: zram0
=5B    2.391425=5D ACPI: Battery Slot =5BBAT1=5D (battery absent)
=5B    2.395943=5D ACPI: Battery Slot =5BBAT2=5D (battery absent)
=5B    2.401129=5D ahci 0000:00:1f.2: version 3.0
=5B    2.401928=5D ahci 0000:00:1f.2: SSS flag set, parallel bus scan dis=
abled
=5B    2.401970=5D ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 G=
bps 0x33 impl SATA mode
=5B    2.401975=5D ahci 0000:00:1f.2: flags: 64bit ncq stag pm led clo pi=
o slum part ems sxs apst=20
=5B    2.416908=5D scsi host0: ahci
=5B    2.417588=5D scsi host1: ahci
=5B    2.418139=5D scsi host2: ahci
=5B    2.418596=5D scsi host3: ahci
=5B    2.419029=5D scsi host4: ahci
=5B    2.419462=5D scsi host5: ahci
=5B    2.419656=5D ata1: SATA max UDMA/133 abar m2048=400xf7736000 port 0=
xf7736100 irq 26
=5B    2.419664=5D ata2: SATA max UDMA/133 abar m2048=400xf7736000 port 0=
xf7736180 irq 26
=5B    2.419667=5D ata3: DUMMY
=5B    2.419669=5D ata4: DUMMY
=5B    2.419676=5D ata5: SATA max UDMA/133 abar m2048=400xf7736000 port 0=
xf7736300 irq 26
=5B    2.419680=5D ata6: SATA max UDMA/133 abar m2048=400xf7736000 port 0=
xf7736380 irq 26
=5B    2.420424=5D e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
=5B    2.420428=5D e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
=5B    2.421198=5D e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/s=
ec) set to dynamic conservative mode
=5B    2.561313=5D e1000e 0000:00:19.0 0000:00:19.0 (uninitialized): regi=
stered PHC clock
=5B    2.682275=5D e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x=
1) f0:1f:af:0c:8a:da
=5B    2.682315=5D e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Co=
nnection
=5B    2.682356=5D e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: 70=
11FF-0FF
=5B    2.682429=5D PPP generic driver version 2.4.2
=5B    2.682781=5D ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Dr=
iver
=5B    2.682785=5D ehci-pci: EHCI PCI platform driver
=5B    2.683474=5D ehci-pci 0000:00:1a.0: EHCI Host Controller
=5B    2.683801=5D ehci-pci 0000:00:1a.0: new USB bus registered, assigne=
d bus number 1
=5B    2.683846=5D ehci-pci 0000:00:1a.0: debug port 2
=5B    2.687819=5D ehci-pci 0000:00:1a.0: cache line size of 64 is not su=
pported
=5B    2.687898=5D ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7738000
=5B    2.694078=5D ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
=5B    2.694356=5D usb usb1: New USB device found, idVendor=3D1d6b, idPro=
duct=3D0002
=5B    2.694365=5D usb usb1: New USB device strings: Mfr=3D3, Product=3D2=
, SerialNumber=3D1
=5B    2.694368=5D usb usb1: Product: EHCI Host Controller
=5B    2.694372=5D usb usb1: Manufacturer: Linux 4.16.0-rc7-next-20180327=
-dirty ehci_hcd
=5B    2.694376=5D usb usb1: SerialNumber: 0000:00:1a.0
=5B    2.695129=5D hub 1-0:1.0: USB hub found
=5B    2.695187=5D hub 1-0:1.0: 2 ports detected
=5B    2.696675=5D ehci-pci 0000:00:1d.0: EHCI Host Controller
=5B    2.696900=5D ehci-pci 0000:00:1d.0: new USB bus registered, assigne=
d bus number 2
=5B    2.696926=5D ehci-pci 0000:00:1d.0: debug port 2
=5B    2.700878=5D ehci-pci 0000:00:1d.0: cache line size of 64 is not su=
pported
=5B    2.700932=5D ehci-pci 0000:00:1d.0: irq 21, io mem 0xf7737000
=5B    2.707150=5D ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
=5B    2.707397=5D usb usb2: New USB device found, idVendor=3D1d6b, idPro=
duct=3D0002
=5B    2.707403=5D usb usb2: New USB device strings: Mfr=3D3, Product=3D2=
, SerialNumber=3D1
=5B    2.707407=5D usb usb2: Product: EHCI Host Controller
=5B    2.707411=5D usb usb2: Manufacturer: Linux 4.16.0-rc7-next-20180327=
-dirty ehci_hcd
=5B    2.707415=5D usb usb2: SerialNumber: 0000:00:1d.0
=5B    2.708133=5D hub 2-0:1.0: USB hub found
=5B    2.708169=5D hub 2-0:1.0: 2 ports detected
=5B    2.708868=5D ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver=

=5B    2.708897=5D ohci-pci: OHCI PCI platform driver
=5B    2.708946=5D uhci_hcd: USB Universal Host Controller Interface driv=
er
=5B    2.709671=5D xhci_hcd 0000:00:14.0: xHCI Host Controller
=5B    2.709935=5D xhci_hcd 0000:00:14.0: new USB bus registered, assigne=
d bus number 3
=5B    2.711159=5D xhci_hcd 0000:00:14.0: hcc params 0x20007181 hci versi=
on 0x100 quirks 0x0000b930
=5B    2.711173=5D xhci_hcd 0000:00:14.0: cache line size of 64 is not su=
pported
=5B    2.711810=5D usb usb3: New USB device found, idVendor=3D1d6b, idPro=
duct=3D0002
=5B    2.711815=5D usb usb3: New USB device strings: Mfr=3D3, Product=3D2=
, SerialNumber=3D1
=5B    2.711819=5D usb usb3: Product: xHCI Host Controller
=5B    2.711823=5D usb usb3: Manufacturer: Linux 4.16.0-rc7-next-20180327=
-dirty xhci-hcd
=5B    2.711826=5D usb usb3: SerialNumber: 0000:00:14.0
=5B    2.712369=5D hub 3-0:1.0: USB hub found
=5B    2.712440=5D hub 3-0:1.0: 4 ports detected
=5B    2.714434=5D xhci_hcd 0000:00:14.0: xHCI Host Controller
=5B    2.714740=5D xhci_hcd 0000:00:14.0: new USB bus registered, assigne=
d bus number 4
=5B    2.714752=5D xhci_hcd 0000:00:14.0: Host supports USB 3.0  SuperSpe=
ed
=5B    2.714980=5D usb usb4: New USB device found, idVendor=3D1d6b, idPro=
duct=3D0003
=5B    2.714987=5D usb usb4: New USB device strings: Mfr=3D3, Product=3D2=
, SerialNumber=3D1
=5B    2.714990=5D usb usb4: Product: xHCI Host Controller
=5B    2.714994=5D usb usb4: Manufacturer: Linux 4.16.0-rc7-next-20180327=
-dirty xhci-hcd
=5B    2.714997=5D usb usb4: SerialNumber: 0000:00:14.0
=5B    2.715653=5D hub 4-0:1.0: USB hub found
=5B    2.715712=5D hub 4-0:1.0: 4 ports detected
=5B    2.717877=5D usbcore: registered new interface driver usb-storage
=5B    2.717967=5D i8042: PNP: PS/2 Controller =5BPNP0303:PS2K,PNP0f13:PS=
2M=5D at 0x60,0x64 irq 1,12
=5B    2.718538=5D i8042: Warning: Keylock active
=5B    2.720892=5D serio: i8042 KBD port at 0x60,0x64 irq 1
=5B    2.721128=5D serio: i8042 AUX port at 0x60,0x64 irq 12
=5B    2.721455=5D mousedev: PS/2 mouse device common for all mice
=5B    2.722860=5D rtc_cmos 00:01: RTC can wake from S4
=5B    2.723277=5D rtc_cmos 00:01: registered as rtc0
=5B    2.723356=5D rtc_cmos 00:01: alarms up to one month, y3k, 242 bytes=
 nvram, hpet irqs
=5B    2.723409=5D i2c /dev entries driver
=5B    2.724210=5D input: AT Translated Set 2 keyboard as /devices/platfo=
rm/i8042/serio0/input/input5
=5B    2.724916=5D i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
=5B    2.725777=5D ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)=

=5B    2.733220=5D ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) =
succeeded
=5B    2.733227=5D ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZ=
E LOCK) filtered out
=5B    2.733232=5D ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGU=
RATION OVERLAY) filtered out
=5B    2.733578=5D ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected =
by device (Stat=3D0x51 Err=3D0x04)
=5B    2.735622=5D ata1.00: ATA-8: ST500LX003-1AC15G, DEM4, max UDMA/133
=5B    2.735631=5D ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth=
 31/32)
=5B    2.743036=5D ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) =
succeeded
=5B    2.743046=5D ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZ=
E LOCK) filtered out
=5B    2.743055=5D ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGU=
RATION OVERLAY) filtered out
=5B    2.743330=5D ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected =
by device (Stat=3D0x51 Err=3D0x04)
=5B    2.745493=5D ata1.00: configured for UDMA/133
=5B    2.747325=5D scsi 0:0:0:0: Direct-Access     ATA      ST500LX003-1A=
C15 DEM4 PQ: 0 ANSI: 5
=5B    2.748823=5D sd 0:0:0:0: =5Bsda=5D 976773168 512-byte logical block=
s: (500 GB/466 GiB)
=5B    2.748837=5D sd 0:0:0:0: =5Bsda=5D 4096-byte physical blocks
=5B    2.748910=5D sd 0:0:0:0: =5Bsda=5D Write Protect is off
=5B    2.748917=5D sd 0:0:0:0: =5Bsda=5D Mode Sense: 00 3a 00 00
=5B    2.749059=5D sd 0:0:0:0: =5Bsda=5D Write cache: enabled, read cache=
: enabled, doesn't support DPO or FUA
=5B    2.755524=5D  sda: sda1 sda2 sda3
=5B    2.756442=5D usbcore: registered new interface driver uvcvideo
=5B    2.756448=5D USB Video Class driver (1.1.1)
=5B    2.757952=5D sd 0:0:0:0: =5Bsda=5D Attached SCSI disk
=5B    2.761080=5D iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
=5B    2.761159=5D iTCO_wdt: Found a Panther Point TCO device (Version=3D=
2, TCOBASE=3D0x0460)
=5B    2.761657=5D iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D=
0)
=5B    2.761688=5D iTCO_vendor_support: vendor-support=3D0
=5B    2.761716=5D device-mapper: uevent: version 1.0.3
=5B    2.761935=5D device-mapper: ioctl: 4.38.0-ioctl (2018-02-28) initia=
lised: dm-devel=40redhat.com
=5B    2.761949=5D intel_pstate: Intel P-state driver initializing
=5B    2.762623=5D sdhci: Secure Digital Host Controller Interface driver=

=5B    2.762629=5D sdhci: Copyright(c) Pierre Ossman
=5B    2.762743=5D sdhci-pci 0000:0c:00.0: SDHCI controller found =5B1217=
:8221=5D (rev 5)
=5B    2.762884=5D sdhci-pci 0000:0c:00.0: enabling device (0100 -> 0102)=

=5B    2.764062=5D mmc0 bounce up to 128 segments into one, max segment s=
ize 65536 bytes
=5B    2.765254=5D mmc0: SDHCI controller on PCI =5B0000:0c:00.0=5D using=
 DMA
=5B    2.765669=5D sdhci-pltfm: SDHCI platform and OF driver helper
=5B    2.765853=5D EFI Variables Facility v0.08 2004-May-17
=5B    2.778901=5D pstore: Registered efi as persistent store backend
=5B    2.778938=5D hidraw: raw HID events driver (C) Jiri Kosina
=5B    2.779029=5D usbcore: registered new interface driver usbhid
=5B    2.779031=5D usbhid: USB HID core driver
=5B    2.781172=5D snd_hda_intel 0000:01:00.1: enabling device (0000 -> 0=
002)
=5B    2.781300=5D snd_hda_intel 0000:01:00.1: Disabling MSI
=5B    2.782352=5D Initializing XFRM netlink socket
=5B    2.782445=5D NET: Registered protocol family 10
=5B    2.783368=5D Segment Routing with IPv6
=5B    2.783650=5D NET: Registered protocol family 17
=5B    2.783666=5D NET: Registered protocol family 15
=5B    2.783685=5D sctp: Hash tables configured (bind 32/51)
=5B    2.783792=5D Key type dns_resolver registered
=5B    2.783796=5D start plist test
=5B    2.789634=5D snd_hda_codec_idt hdaudioC0D0: autoconfig for 92HD93BX=
X: line_outs=3D1 (0xe/0x0/0x0/0x0/0x0) type:line
=5B    2.789645=5D snd_hda_codec_idt hdaudioC0D0:    speaker_outs=3D1 (0x=
d/0x0/0x0/0x0/0x0)
=5B    2.789651=5D snd_hda_codec_idt hdaudioC0D0:    hp_outs=3D1 (0xb/0x0=
/0x0/0x0/0x0)
=5B    2.789656=5D snd_hda_codec_idt hdaudioC0D0:    mono: mono_out=3D0x0=

=5B    2.789662=5D snd_hda_codec_idt hdaudioC0D0:    inputs:
=5B    2.789668=5D snd_hda_codec_idt hdaudioC0D0:      Dock Mic=3D0xf
=5B    2.789674=5D snd_hda_codec_idt hdaudioC0D0:      Internal Mic=3D0x1=
1
=5B    2.789679=5D snd_hda_codec_idt hdaudioC0D0:      Headset Mic=3D0xa
=5B    2.791587=5D end plist test
=5B    2.792771=5D microcode: sig=3D0x306a9, pf=3D0x10, revision=3D0x1f
=5B    2.793040=5D microcode: Microcode Update Driver: v2.2.
=5B    2.793106=5D sched_clock: Marking stable (2793008113, 0)->(28011394=
02, -8131289)
=5B    2.793894=5D registered taskstats version 1
=5B    2.793949=5D Loading compiled-in X.509 certificates
=5B    2.797686=5D modprobe (130) used greatest stack depth: 13408 bytes =
left
=5B    2.801984=5D Loaded X.509 cert 'Magrathea: Glacier signing key: bb7=
2777f81e5af93500bb2beebab944a32df62b5'
=5B    2.802118=5D zswap: loaded using pool lzo/zbud
=5B    2.814325=5D Key type big_key registered
=5B    2.818543=5D input: HDA Intel PCH Dock Mic as /devices/pci0000:00/0=
000:00:1b.0/sound/card0/input8
=5B    2.818983=5D input: HDA Intel PCH Headset Mic as /devices/pci0000:0=
0/0000:00:1b.0/sound/card0/input9
=5B    2.819363=5D input: HDA Intel PCH Dock Line Out as /devices/pci0000=
:00/0000:00:1b.0/sound/card0/input10
=5B    2.819739=5D input: HDA Intel PCH Headphone as /devices/pci0000:00/=
0000:00:1b.0/sound/card0/input11
=5B    2.821061=5D Key type encrypted registered
=5B    2.822397=5D console =5Bnetcon0=5D enabled
=5B    2.822400=5D netconsole: network logging started
=5B    2.822478=5D rtc_cmos 00:01: setting system clock to 2018-03-29 14:=
50:55 UTC (1522335055)
=5B    2.822805=5D cfg80211: Loading compiled-in X.509 certificates for r=
egulatory database
=5B    2.827660=5D cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9c=
ea7'
=5B    2.827713=5D ALSA device list:
=5B    2.827716=5D   =230: HDA Intel PCH at 0xf7730000 irq 29
=5B    2.828155=5D platform regulatory.0: Direct firmware load for regula=
tory.db failed with error -2
=5B    2.828174=5D cfg80211: failed to load regulatory.db
=5B    2.848296=5D tsc: Refined TSC clocksource calibration: 2691.258 MHz=

=5B    2.848334=5D clocksource: tsc: mask: 0xffffffffffffffff max_cycles:=
 0x26cafc29fa8, max_idle_ns: 440795270837 ns
=5B    2.848588=5D clocksource: Switched to clocksource tsc
=5B    3.019064=5D usb 1-1: new high-speed USB device number 2 using ehci=
-pci
=5B    3.035123=5D usb 2-1: new high-speed USB device number 2 using ehci=
-pci
=5B    3.037210=5D snd_hda_codec_generic hdaudioC1D0: autoconfig for Gene=
ric: line_outs=3D0 (0x0/0x0/0x0/0x0/0x0) type:line
=5B    3.037225=5D snd_hda_codec_generic hdaudioC1D0:    speaker_outs=3D0=
 (0x0/0x0/0x0/0x0/0x0)
=5B    3.037234=5D snd_hda_codec_generic hdaudioC1D0:    hp_outs=3D0 (0x0=
/0x0/0x0/0x0/0x0)
=5B    3.037242=5D snd_hda_codec_generic hdaudioC1D0:    mono: mono_out=
=3D0x0
=5B    3.037249=5D snd_hda_codec_generic hdaudioC1D0:    dig-out=3D0x5/0x=
0
=5B    3.037256=5D snd_hda_codec_generic hdaudioC1D0:    inputs:
=5B    3.054662=5D ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)=

=5B    3.056612=5D ata2.00: ATAPI: MATSHITA DVD+/-RW UJ8C2, 1.02, max UDM=
A/133
=5B    3.060153=5D ata2.00: configured for UDMA/133
=5B    3.065393=5D scsi 1:0:0:0: CD-ROM            MATSHITA DVD+-RW UJ8C2=
    1.02 PQ: 0 ANSI: 5
=5B    3.075215=5D snd_hda_codec_generic hdaudioC1D1: autoconfig for Gene=
ric: line_outs=3D0 (0x0/0x0/0x0/0x0/0x0) type:line
=5B    3.075230=5D snd_hda_codec_generic hdaudioC1D1:    speaker_outs=3D0=
 (0x0/0x0/0x0/0x0/0x0)
=5B    3.075239=5D snd_hda_codec_generic hdaudioC1D1:    hp_outs=3D0 (0x0=
/0x0/0x0/0x0/0x0)
=5B    3.075247=5D snd_hda_codec_generic hdaudioC1D1:    mono: mono_out=
=3D0x0
=5B    3.075254=5D snd_hda_codec_generic hdaudioC1D1:    dig-out=3D0x5/0x=
0
=5B    3.075261=5D snd_hda_codec_generic hdaudioC1D1:    inputs:
=5B    3.106739=5D sr 1:0:0:0: =5Bsr0=5D scsi3-mmc drive: 24x/24x writer =
dvd-ram cd/rw xa/form2 cdda tray
=5B    3.106751=5D cdrom: Uniform CD-ROM driver Revision: 3.20
=5B    3.107771=5D sr 1:0:0:0: Attached scsi CD-ROM sr0
=5B    3.112195=5D snd_hda_codec_generic hdaudioC1D2: autoconfig for Gene=
ric: line_outs=3D0 (0x0/0x0/0x0/0x0/0x0) type:line
=5B    3.112211=5D snd_hda_codec_generic hdaudioC1D2:    speaker_outs=3D0=
 (0x0/0x0/0x0/0x0/0x0)
=5B    3.112219=5D snd_hda_codec_generic hdaudioC1D2:    hp_outs=3D0 (0x0=
/0x0/0x0/0x0/0x0)
=5B    3.112225=5D snd_hda_codec_generic hdaudioC1D2:    mono: mono_out=
=3D0x0
=5B    3.112242=5D snd_hda_codec_generic hdaudioC1D2:    dig-out=3D0x5/0x=
0
=5B    3.112249=5D snd_hda_codec_generic hdaudioC1D2:    inputs:
=5B    3.148364=5D usb 1-1: New USB device found, idVendor=3D8087, idProd=
uct=3D0024
=5B    3.148390=5D usb 1-1: New USB device strings: Mfr=3D0, Product=3D0,=
 SerialNumber=3D0
=5B    3.150115=5D snd_hda_codec_generic hdaudioC1D3: autoconfig for Gene=
ric: line_outs=3D0 (0x0/0x0/0x0/0x0/0x0) type:line
=5B    3.150118=5D hub 1-1:1.0: USB hub found
=5B    3.150128=5D snd_hda_codec_generic hdaudioC1D3:    speaker_outs=3D0=
 (0x0/0x0/0x0/0x0/0x0)
=5B    3.150167=5D snd_hda_codec_generic hdaudioC1D3:    hp_outs=3D0 (0x0=
/0x0/0x0/0x0/0x0)
=5B    3.150175=5D snd_hda_codec_generic hdaudioC1D3:    mono: mono_out=
=3D0x0
=5B    3.150183=5D snd_hda_codec_generic hdaudioC1D3:    dig-out=3D0x5/0x=
0
=5B    3.150190=5D snd_hda_codec_generic hdaudioC1D3:    inputs:
=5B    3.150501=5D hub 1-1:1.0: 6 ports detected
=5B    3.165980=5D usb 2-1: New USB device found, idVendor=3D8087, idProd=
uct=3D0024
=5B    3.165989=5D usb 2-1: New USB device strings: Mfr=3D0, Product=3D0,=
 SerialNumber=3D0
=5B    3.167083=5D hub 2-1:1.0: USB hub found
=5B    3.167329=5D hub 2-1:1.0: 8 ports detected
=5B    3.184536=5D input: HDA NVidia HDMI as /devices/pci0000:00/0000:00:=
01.0/0000:01:00.1/sound/card1/input12
=5B    3.185135=5D input: HDA NVidia HDMI as /devices/pci0000:00/0000:00:=
01.0/0000:01:00.1/sound/card1/input13
=5B    3.185720=5D input: HDA NVidia HDMI as /devices/pci0000:00/0000:00:=
01.0/0000:01:00.1/sound/card1/input14
=5B    3.186377=5D input: HDA NVidia HDMI as /devices/pci0000:00/0000:00:=
01.0/0000:01:00.1/sound/card1/input15
=5B    3.333672=5D input: PS/2 Generic Mouse as /devices/platform/i8042/s=
erio1/input/input7
=5B    3.416091=5D ata5: SATA link down (SStatus 0 SControl 300)
=5B    3.424189=5D usb 1-1.2: new high-speed USB device number 3 using eh=
ci-pci
=5B    3.440178=5D usb 2-1.8: new full-speed USB device number 3 using eh=
ci-pci
=5B    3.471191=5D usb 3-1: new low-speed USB device number 2 using xhci_=
hcd
=5B    3.524311=5D usb 1-1.2: New USB device found, idVendor=3D13b1, idPr=
oduct=3D003e
=5B    3.524325=5D usb 1-1.2: New USB device strings: Mfr=3D1, Product=3D=
2, SerialNumber=3D3
=5B    3.524334=5D usb 1-1.2: Product: Linksys AE6000
=5B    3.524342=5D usb 1-1.2: Manufacturer: Cisco
=5B    3.524350=5D usb 1-1.2: SerialNumber: 0009
=5B    3.544086=5D usb 2-1.8: New USB device found, idVendor=3D0a5c, idPr=
oduct=3D5801
=5B    3.544101=5D usb 2-1.8: New USB device strings: Mfr=3D1, Product=3D=
2, SerialNumber=3D3
=5B    3.544110=5D usb 2-1.8: Product: 5880
=5B    3.544118=5D usb 2-1.8: Manufacturer: Broadcom Corp
=5B    3.544125=5D usb 2-1.8: SerialNumber: 0123456789ABCD
=5B    3.544913=5D usb 2-1.8: config 0 descriptor??
=5B    3.614393=5D usb 3-1: New USB device found, idVendor=3D045e, idProd=
uct=3D0023
=5B    3.614407=5D usb 3-1: New USB device strings: Mfr=3D1, Product=3D2,=
 SerialNumber=3D0
=5B    3.614416=5D usb 3-1: Product: Microsoft Trackball Optical=AE
=5B    3.614424=5D usb 3-1: Manufacturer: Microsoft
=5B    3.624796=5D input: Microsoft Microsoft Trackball Optical=AE as /de=
vices/pci0000:00/0000:00:14.0/usb3/3-1/3-1:1.0/0003:045E:0023.0001/input/=
input16
=5B    3.626655=5D hid-generic 0003:045E:0023.0001: input,hidraw0: USB HI=
D v1.00 Mouse =5BMicrosoft Microsoft Trackball Optical=AE=5D on usb-0000:=
00:14.0-1/input0
=5B    3.728120=5D ata6: SATA link down (SStatus 0 SControl 300)
=5B    3.740388=5D Freeing unused kernel memory: 3784K
=5B    3.740393=5D Write protecting the kernel read-only data: 30720k
=5B    3.741855=5D Freeing unused kernel memory: 2012K
=5B    3.745382=5D Freeing unused kernel memory: 1672K
=5B    3.745769=5D x86/mm: Checked W+X mappings: passed, no W+X pages fou=
nd.
=5B    3.745772=5D x86/mm: Checking user space page tables
=5B    3.745823=5D x86/mm: Checked W+X mappings: passed, no W+X pages fou=
nd.
=5B    3.798862=5D systemd=5B1=5D: systemd 238 running in system mode. (+=
PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP =
+GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN =
+PCRE2 default-hierarchy=3Dhybrid)
=5B    3.811514=5D systemd=5B1=5D: Detected architecture x86-64.
=5B    3.811535=5D systemd=5B1=5D: Running in initial RAM disk.
=5B    3.817275=5D systemd=5B1=5D: Set hostname to <turing-police.cc.vt.e=
du>.
=5B    3.817781=5D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=5B    3.817858=5D UBSAN: Undefined behaviour in net/ipv6/route.c:413:2
=5B    3.817900=5D member access within null pointer of type 'struct rt6_=
info'
=5B    3.817945=5D CPU: 1 PID: 1 Comm: systemd Tainted: G                =
T 4.16.0-rc7-next-20180327-dirty =23565
=5B    3.817948=5D Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A=
20 05/08/2017
=5B    3.817950=5D Call Trace:
=5B    3.817957=5D  dump_stack+0x83/0xca
=5B    3.817966=5D  ubsan_epilogue+0xd/0x3a
=5B    3.817971=5D  handle_null_ptr_deref+0x85/0x90
=5B    3.817976=5D  __ubsan_handle_type_mismatch_v1+0x5e/0x70
=5B    3.817985=5D  ip6_dst_destroy+0xd4/0xf0
=5B    3.817991=5D  dst_destroy+0x50/0x130
=5B    3.817997=5D  dst_release_immediate+0x47/0x5c
=5B    3.818002=5D  ip6_route_info_create+0x123/0xf10
=5B    3.818016=5D  ip6_route_add+0x3c/0xf0
=5B    3.818025=5D  addrconf_prefix_route+0xc9/0x180
=5B    3.818047=5D  inet6_addr_add+0x30d/0x360
=5B    3.818059=5D  inet6_rtm_newaddr+0x50b/0x7d0
=5B    3.818078=5D  rtnetlink_rcv_msg+0x1c1/0x5e0
=5B    3.818088=5D  ? rtnetlink_put_metrics+0x290/0x290
=5B    3.818093=5D  netlink_rcv_skb+0x4d/0x140
=5B    3.818103=5D  rtnetlink_rcv+0x15/0x20
=5B    3.818106=5D  netlink_unicast+0x215/0x340
=5B    3.818115=5D  netlink_sendmsg+0x2ee/0x6b0
=5B    3.818127=5D  sock_sendmsg+0x6a/0xf0
=5B    3.818133=5D  __sys_sendto+0x15d/0x220
=5B    3.818154=5D  ? do_syscall_64+0x43/0xe4d
=5B    3.818162=5D  SyS_sendto+0xe/0x20
=5B    3.818165=5D  do_syscall_64+0xb7/0xe4d
=5B    3.818172=5D  ? trace_hardirqs_off_thunk+0x1a/0x1c
=5B    3.818182=5D  entry_SYSCALL_64_after_hwframe+0x42/0xb7
=5B    3.818185=5D RIP: 0033:0x7fb92c516174
=5B    3.818188=5D RSP: 002b:00007ffe332ab508 EFLAGS: 00000246 ORIG_RAX: =
000000000000002c
=5B    3.818192=5D RAX: ffffffffffffffda RBX: 000056069dd124c0 RCX: 00007=
fb92c516174
=5B    3.818195=5D RDX: 000000000000002c RSI: 000056069dd126c0 RDI: 00000=
00000000004
=5B    3.818197=5D RBP: 000056069dd12770 R08: 00007ffe332ab510 R09: 00000=
00000000010
=5B    3.818199=5D R10: 0000000000000000 R11: 0000000000000246 R12: 00007=
ffe332ab574
=5B    3.818201=5D R13: 000056069c5980f0 R14: 00007ffe332ab620 R15: 00005=
6069dd122e0
=5B    3.818216=5D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=5B    3.818618=5D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=5B    3.818676=5D UBSAN: Undefined behaviour in net/ipv4/fib_trie.c:504:=
6
=5B    3.818717=5D member access within null pointer of type 'struct tnod=
e'
=5B    3.818761=5D CPU: 1 PID: 1 Comm: systemd Tainted: G                =
T 4.16.0-rc7-next-20180327-dirty =23565
=5B    3.818763=5D Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A=
20 05/08/2017
=5B    3.818765=5D Call Trace:
=5B    3.818770=5D  dump_stack+0x83/0xca
=5B    3.818777=5D  ubsan_epilogue+0xd/0x3a
=5B    3.818781=5D  handle_null_ptr_deref+0x85/0x90
=5B    3.818787=5D  __ubsan_handle_type_mismatch_v1+0x5e/0x70
=5B    3.818795=5D  tnode_free+0xdf/0x130
=5B    3.818802=5D  replace+0xc7/0x290
=5B    3.818811=5D  resize+0x717/0x1080
=5B    3.818820=5D  ? put_child+0x9d/0x3e0
=5B    3.818829=5D  fib_insert_alias+0x3da/0x900
=5B    3.818840=5D  fib_table_insert+0x20e/0x690
=5B    3.818855=5D  fib_magic+0x187/0x310
=5B    3.818873=5D  fib_add_ifaddr+0x15d/0x1a0
=5B    3.818880=5D  fib_netdev_event+0xb1/0x250
=5B    3.818887=5D  notifier_call_chain+0x4b/0x160
=5B    3.818896=5D  raw_notifier_call_chain+0x2e/0x50
=5B    3.818902=5D  call_netdevice_notifiers_info+0x66/0x110
=5B    3.818910=5D  __dev_notify_flags+0x6a/0x120
=5B    3.818915=5D  ? sched_clock_cpu+0x16b/0x1e0
=5B    3.818922=5D  dev_change_flags+0x62/0x90
=5B    3.818930=5D  do_setlink+0x3c5/0x1b20
=5B    3.818934=5D  ? cyc2ns_read_end+0x22/0x30
=5B    3.818938=5D  ? native_sched_clock+0x95/0x100
=5B    3.818949=5D  ? sched_clock_cpu+0x16b/0x1e0
=5B    3.818952=5D  ? sched_clock_cpu+0x16b/0x1e0
=5B    3.818960=5D  ? __lock_acquire+0x291/0x18c0
=5B    3.818964=5D  ? cyc2ns_read_end+0x22/0x30
=5B    3.818969=5D  ? nla_parse+0xce/0x1e0
=5B    3.818977=5D  rtnl_setlink+0x12e/0x1e0
=5B    3.819016=5D  rtnetlink_rcv_msg+0x1c1/0x5e0
=5B    3.819026=5D  ? rtnetlink_put_metrics+0x290/0x290
=5B    3.819032=5D  netlink_rcv_skb+0x4d/0x140
=5B    3.819041=5D  rtnetlink_rcv+0x15/0x20
=5B    3.819044=5D  netlink_unicast+0x215/0x340
=5B    3.819053=5D  netlink_sendmsg+0x2ee/0x6b0
=5B    3.819065=5D  sock_sendmsg+0x6a/0xf0
=5B    3.819071=5D  __sys_sendto+0x15d/0x220
=5B    3.819091=5D  ? do_syscall_64+0x43/0xe4d
=5B    3.819098=5D  SyS_sendto+0xe/0x20
=5B    3.819102=5D  do_syscall_64+0xb7/0xe4d
=5B    3.819109=5D  ? trace_hardirqs_off_thunk+0x1a/0x1c
=5B    3.819119=5D  entry_SYSCALL_64_after_hwframe+0x42/0xb7
=5B    3.819122=5D RIP: 0033:0x7fb92c516174
=5B    3.819125=5D RSP: 002b:00007ffe332ab508 EFLAGS: 00000246 ORIG_RAX: =
000000000000002c
=5B    3.819129=5D RAX: ffffffffffffffda RBX: 000056069dd124c0 RCX: 00007=
fb92c516174
=5B    3.819131=5D RDX: 0000000000000020 RSI: 000056069dd12310 RDI: 00000=
00000000004
=5B    3.819133=5D RBP: 000056069dd12770 R08: 00007ffe332ab510 R09: 00000=
00000000010
=5B    3.819136=5D R10: 0000000000000000 R11: 0000000000000246 R12: 00007=
ffe332ab574
=5B    3.819138=5D R13: 000056069c5980f0 R14: 00007ffe332ab640 R15: 00005=
6069dd12bb0
=5B    3.819153=5D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=5B    3.844389=5D ln (161) used greatest stack depth: 12880 bytes left
=5B    3.977471=5D systemd=5B1=5D: Reached target Slices.
=5B    3.977901=5D systemd=5B1=5D: Listening on Journal Socket (/dev/log)=
.
=5B    3.977919=5D systemd=5B1=5D: Reached target Swap.
=5B    3.981502=5D systemd=5B1=5D: Created slice system-systemd=5Cx2dcryp=
tsetup.slice.
=5B    3.981835=5D systemd=5B1=5D: Listening on udev Control Socket.
=5B    3.982195=5D systemd=5B1=5D: Listening on Journal Socket.
=5B    4.042198=5D audit: type=3D1130 audit(1522335056.718:2): pid=3D1 ui=
d=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsyst=
emd-sysctl comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=22 host=
name=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B    4.049881=5D audit: type=3D1130 audit(1522335056.726:3): pid=3D1 ui=
d=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsyst=
emd-tmpfiles-setup comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=
=22 hostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B    4.054149=5D systemd-tmpfile (188) used greatest stack depth: 12808=
 bytes left
=5B    4.059273=5D audit: type=3D1130 audit(1522335056.736:4): pid=3D1 ui=
d=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsyst=
emd-tmpfiles-setup-dev comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/sys=
temd=22 hostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B    4.060405=5D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=5B    4.060555=5D UBSAN: Undefined behaviour in kernel/params.c:582:43
=5B    4.060638=5D member access within null pointer of type 'struct modu=
le'
=5B    4.060735=5D CPU: 3 PID: 194 Comm: systemd-vconsol Tainted: G      =
          T 4.16.0-rc7-next-20180327-dirty =23565
=5B    4.060739=5D Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A=
20 05/08/2017
=5B    4.060743=5D Call Trace:
=5B    4.060754=5D  dump_stack+0x83/0xca
=5B    4.060769=5D  ubsan_epilogue+0xd/0x3a
=5B    4.060778=5D  handle_null_ptr_deref+0x85/0x90
=5B    4.060790=5D  __ubsan_handle_type_mismatch_v1+0x5e/0x70
=5B    4.060805=5D  param_attr_store+0x16c/0x1c0
=5B    4.060819=5D  module_attr_store+0x30/0x70
=5B    4.060827=5D  ? sysfs_file_ops+0x6a/0x100
=5B    4.060837=5D  sysfs_kf_write+0x68/0xc0
=5B    4.060848=5D  ? sysfs_file_ops+0x100/0x100
=5B    4.060855=5D  kernfs_fop_write+0x1a8/0x2c0
=5B    4.060862=5D  ? rcu_read_lock_sched_held+0x78/0x80
=5B    4.060877=5D  __vfs_write+0x3e/0xc0
=5B    4.060890=5D  vfs_write+0x18e/0x3c0
=5B    4.060907=5D  ksys_write+0x58/0xc0
=5B    4.060922=5D  SyS_write+0xe/0x10
=5B    4.060929=5D  do_syscall_64+0xb7/0xe4d
=5B    4.060944=5D  ? trace_hardirqs_off_thunk+0x1a/0x1c
=5B    4.060963=5D  entry_SYSCALL_64_after_hwframe+0x42/0xb7
=5B    4.060970=5D RIP: 0033:0x7f572fe72324
=5B    4.060975=5D RSP: 002b:00007ffe493f6338 EFLAGS: 00000246 ORIG_RAX: =
0000000000000001
=5B    4.060983=5D RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007=
f572fe72324
=5B    4.060988=5D RDX: 0000000000000002 RSI: 00005555a4e49b80 RDI: 00000=
00000000005
=5B    4.060992=5D RBP: 00005555a4e49b80 R08: 000000000000000a R09: 00007=
f5730141190
=5B    4.060997=5D R10: 000000000000000a R11: 0000000000000246 R12: 00005=
555a4e48260
=5B    4.061001=5D R13: 0000000000000002 R14: 00007f573013c760 R15: 00000=
00000000002
=5B    4.061034=5D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=5B    4.200215=5D audit: type=3D1130 audit(1522335056.877:5): pid=3D1 ui=
d=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsyst=
emd-vconsole-setup comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=
=22 hostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B    4.200274=5D audit: type=3D1131 audit(1522335056.877:6): pid=3D1 ui=
d=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsyst=
emd-vconsole-setup comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=
=22 hostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B    4.291667=5D audit: type=3D1130 audit(1522335056.968:7): pid=3D1 ui=
d=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsyst=
emd-journald comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=22 ho=
stname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B    4.454936=5D dracut-cmdline (186) used greatest stack depth: 12472 =
bytes left
=5B    4.457477=5D audit: type=3D1130 audit(1522335057.134:8): pid=3D1 ui=
d=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Ddrac=
ut-cmdline comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=22 host=
name=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B    4.565142=5D audit: type=3D1130 audit(1522335057.242:9): pid=3D1 ui=
d=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Ddrac=
ut-pre-udev comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=22 hos=
tname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B    4.594630=5D audit: type=3D1130 audit(1522335057.271:10): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsys=
temd-udevd comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=22 host=
name=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B    4.981955=5D udevadm (325) used greatest stack depth: 11784 bytes l=
eft
=5B    5.082663=5D e1000e 0000:00:19.0 eno1: renamed from eth0
=5B    5.489148=5D kauditd_printk_skb: 2 callbacks suppressed
=5B    5.489151=5D audit: type=3D1130 audit(1522335058.166:13): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsys=
temd-ask-password-plymouth comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd=
/systemd=22 hostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B    5.604733=5D audit: type=3D1130 audit(1522335058.281:14): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsys=
temd-vconsole-setup comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/system=
d=22 hostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B    5.604761=5D audit: type=3D1131 audit(1522335058.281:15): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsys=
temd-vconsole-setup comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/system=
d=22 hostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B    7.078194=5D usb 3-2: new full-speed USB device number 3 using xhci=
_hcd
=5B    7.206705=5D usb 3-2: New USB device found, idVendor=3D1050, idProd=
uct=3D0407
=5B    7.206715=5D usb 3-2: New USB device strings: Mfr=3D1, Product=3D2,=
 SerialNumber=3D3
=5B    7.206721=5D usb 3-2: Product: Yubikey 4 OTP+U2F+CCID
=5B    7.206726=5D usb 3-2: Manufacturer: Yubico
=5B    7.206731=5D usb 3-2: SerialNumber: 0004612067
=5B    7.214319=5D input: Yubico Yubikey 4 OTP+U2F+CCID as /devices/pci00=
00:00/0000:00:14.0/usb3/3-2/3-2:1.0/0003:1050:0407.0002/input/input17
=5B    7.269377=5D hid-generic 0003:1050:0407.0002: input,hidraw1: USB HI=
D v1.10 Keyboard =5BYubico Yubikey 4 OTP+U2F+CCID=5D on usb-0000:00:14.0-=
2/input0
=5B    7.271879=5D hid-generic 0003:1050:0407.0003: hidraw2: USB HID v1.1=
0 Device =5BYubico Yubikey 4 OTP+U2F+CCID=5D on usb-0000:00:14.0-2/input1=

=5B    8.686961=5D random: crng init done
=5B   16.966372=5D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=5B   16.966553=5D UBSAN: Undefined behaviour in lib/radix-tree.c:123:14
=5B   16.966645=5D member access within null pointer of type 'const struc=
t radix_tree_node'
=5B   16.966759=5D CPU: 0 PID: 405 Comm: systemd-cryptse Tainted: G      =
          T 4.16.0-rc7-next-20180327-dirty =23565
=5B   16.966764=5D Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A=
20 05/08/2017
=5B   16.966769=5D Call Trace:
=5B   16.966781=5D  dump_stack+0x83/0xca
=5B   16.966797=5D  ubsan_epilogue+0xd/0x3a
=5B   16.966806=5D  handle_null_ptr_deref+0x85/0x90
=5B   16.966818=5D  __ubsan_handle_type_mismatch_v1+0x5e/0x70
=5B   16.966833=5D  __radix_tree_delete+0xea/0x110
=5B   16.966850=5D  radix_tree_delete_item+0x5b/0xf0
=5B   16.966869=5D  idr_remove+0x25/0x40
=5B   16.966879=5D  ipc_rmid+0x5d/0x110
=5B   16.966896=5D  freeary+0x5d2/0xc10
=5B   16.966928=5D  ksys_semctl+0xc0b/0x1320
=5B   16.966941=5D  ? current_kernel_time64+0xe1/0x110
=5B   16.966954=5D  ? trace_hardirqs_on_caller+0x156/0x260
=5B   16.966967=5D  ? current_kernel_time64+0x8f/0x110
=5B   16.966986=5D  ? __audit_syscall_entry+0xf5/0x1e0
=5B   16.967002=5D  SyS_semctl+0xe/0x10
=5B   16.967010=5D  do_syscall_64+0xb7/0xe4d
=5B   16.967026=5D  ? trace_hardirqs_off_thunk+0x1a/0x1c
=5B   16.967048=5D  entry_SYSCALL_64_after_hwframe+0x42/0xb7
=5B   16.967056=5D RIP: 0033:0x7fc15b3dc049
=5B   16.967061=5D RSP: 002b:00007ffc0e24af40 EFLAGS: 00000246 ORIG_RAX: =
0000000000000042
=5B   16.967070=5D RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007=
fc15b3dc049
=5B   16.967075=5D RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000=
00000000000
=5B   16.967080=5D RBP: 000000000d4d850b R08: 0000000000000007 R09: 00000=
00000000006
=5B   16.967085=5D R10: 0000000000000000 R11: 0000000000000246 R12: 00007=
fc15940e8f0
=5B   16.967089=5D R13: 000055c1b12db4d0 R14: 000055c1b12dd878 R15: 00000=
00000000001
=5B   16.967124=5D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=5B   17.243892=5D audit: type=3D1130 audit(1522335069.920:16): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsys=
temd-cryptsetup=40luks=5Cx2d665bb147=5Cx2d9e39=5Cx2d4003=5Cx2db3ae=5Cx2d7=
be925f51a97 comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=22 hos=
tname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B   19.223171=5D audit: type=3D1130 audit(1522335071.900:17): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Ddra=
cut-initqueue comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=22 h=
ostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B   19.398092=5D audit: type=3D1130 audit(1522335072.074:18): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsys=
temd-fsck-root comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=22 =
hostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B   19.446713=5D EXT4-fs (dm-3): mounted filesystem with ordered data m=
ode. Opts: (null)
=5B   19.513274=5D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=5B   19.513392=5D UBSAN: Undefined behaviour in fs/ext4/readpage.c:129:1=
3
=5B   19.513472=5D member access within null pointer of type 'struct page=
'
=5B   19.513558=5D CPU: 3 PID: 697 Comm: systemd-fstab-g Tainted: G      =
          T 4.16.0-rc7-next-20180327-dirty =23565
=5B   19.513562=5D Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A=
20 05/08/2017
=5B   19.513566=5D Call Trace:
=5B   19.513578=5D  dump_stack+0x83/0xca
=5B   19.513592=5D  ubsan_epilogue+0xd/0x3a
=5B   19.513601=5D  handle_null_ptr_deref+0x85/0x90
=5B   19.513612=5D  __ubsan_handle_type_mismatch_v1+0x5e/0x70
=5B   19.513627=5D  ext4_mpage_readpages+0x11fa/0x13f7
=5B   19.513672=5D  ? __alloc_pages_nodemask+0x475/0x710
=5B   19.513691=5D  ext4_readpages+0x62/0xd0
=5B   19.513705=5D  __do_page_cache_readahead+0x36c/0x5d0
=5B   19.513741=5D  ondemand_readahead+0x284/0x5e0
=5B   19.513746=5D  ? ondemand_readahead+0x284/0x5e0
=5B   19.513764=5D  page_cache_sync_readahead+0x50/0xa0
=5B   19.513778=5D  generic_file_buffered_read+0x721/0x16a0
=5B   19.513798=5D  ? native_sched_clock+0x95/0x100
=5B   19.513813=5D  ? sched_clock_cpu+0x16b/0x1e0
=5B   19.513837=5D  generic_file_read_iter+0x121/0x230
=5B   19.513853=5D  ext4_file_read_iter+0xa8/0x130
=5B   19.513863=5D  new_sync_read+0x14d/0x2d0
=5B   19.513897=5D  __vfs_read+0x5c/0xc0
=5B   19.513910=5D  vfs_read+0x164/0x330
=5B   19.513926=5D  ksys_read+0x58/0xc0
=5B   19.513940=5D  SyS_read+0xe/0x10
=5B   19.513947=5D  do_syscall_64+0xb7/0xe4d
=5B   19.513961=5D  ? trace_hardirqs_off_thunk+0x1a/0x1c
=5B   19.513980=5D  entry_SYSCALL_64_after_hwframe+0x42/0xb7
=5B   19.513986=5D RIP: 0033:0x7f1896b812e4
=5B   19.513991=5D RSP: 002b:00007ffca2ce5b98 EFLAGS: 00000246 ORIG_RAX: =
0000000000000000
=5B   19.513999=5D RAX: ffffffffffffffda RBX: 0000562b66b4c260 RCX: 00007=
f1896b812e4
=5B   19.514003=5D RDX: 0000000000001000 RSI: 0000562b66b4e7b0 RDI: 00000=
00000000004
=5B   19.514008=5D RBP: 0000000000000d68 R08: 0000000000000003 R09: 00000=
00000000077
=5B   19.514012=5D R10: 0000562b66b4c010 R11: 0000000000000246 R12: 00007=
f1896e4b760
=5B   19.514017=5D R13: 00007f1896e4c2a0 R14: 0000000000000fff R15: 00005=
62b66b4c260
=5B   19.514047=5D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=5B   19.722875=5D audit: type=3D1130 audit(1522335072.399:19): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dini=
trd-parse-etc comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=22 h=
ostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B   19.722924=5D audit: type=3D1131 audit(1522335072.399:20): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dini=
trd-parse-etc comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=22 h=
ostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B   19.866908=5D audit: type=3D1130 audit(1522335072.543:21): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsys=
temd-fsck=40dev-mapper-turing=5Cx2d=5Cx2dpolice=5Cx2d00 comm=3D=22systemd=
=22 exe=3D=22/usr/lib/systemd/systemd=22 hostname=3D? addr=3D? terminal=
=3D? res=3Dsuccess'
=5B   19.918720=5D EXT4-fs (dm-1): mounted filesystem with ordered data m=
ode. Opts: (null)
=5B   19.961803=5D audit: type=3D1130 audit(1522335072.638:22): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsys=
temd-sysctl comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=22 hos=
tname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B   19.962060=5D audit: type=3D1131 audit(1522335072.638:23): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsys=
temd-sysctl comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=22 hos=
tname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B   19.978026=5D audit: type=3D1130 audit(1522335072.654:24): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Ddra=
cut-initqueue comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=22 h=
ostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B   19.978083=5D audit: type=3D1131 audit(1522335072.655:25): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Ddra=
cut-initqueue comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=22 h=
ostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B   20.266194=5D systemd-journald=5B191=5D: Received SIGTERM from PID 1=
 (systemd).
=5B   20.439273=5D systemd: 16 output lines suppressed due to ratelimitin=
g
=5B   21.920105=5D SELinux: 32768 avtab hash slots, 74868 rules.
=5B   21.964699=5D SELinux: 32768 avtab hash slots, 74868 rules.
=5B   22.047458=5D SELinux:  7 users, 14 roles, 3906 types, 270 bools, 16=
 sens, 1024 cats
=5B   22.047466=5D SELinux:  129 classes, 74868 rules
=5B   22.063289=5D SELinux:  Permission name_connect in class sctp_socket=
 not defined in policy.
=5B   22.063294=5D SELinux:  Permission association in class sctp_socket =
not defined in policy.
=5B   22.063353=5D SELinux:  Class bpf not defined in policy.
=5B   22.063355=5D SELinux: the above unknown classes and permissions wil=
l be denied
=5B   22.063385=5D SELinux:  policy capability network_peer_controls=3D1
=5B   22.063388=5D SELinux:  policy capability open_perms=3D1
=5B   22.063390=5D SELinux:  policy capability extended_socket_class=3D1
=5B   22.063392=5D SELinux:  policy capability always_check_network=3D0
=5B   22.063394=5D SELinux:  policy capability cgroup_seclabel=3D1
=5B   22.063396=5D SELinux:  policy capability nnp_nosuid_transition=3D1
=5B   22.063398=5D SELinux:  Completing initialization.
=5B   22.063400=5D SELinux:  Setting up existing superblocks.
=5B   22.113170=5D SELinux: (dev dm-3, type ext4) getxattr errno 34
=5B   22.113197=5D SELinux: (dev dm-1, type ext4) getxattr errno 34
=5B   22.142679=5D systemd=5B1=5D: Successfully loaded SELinux policy in =
384.345ms.
=5B   22.401128=5D systemd=5B1=5D: Relabelled /dev, /run and /sys/fs/cgro=
up in 46.734ms.
=5B   22.450420=5D systemd=5B1=5D: systemd 238 running in system mode. (+=
PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP =
+GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN =
+PCRE2 default-hierarchy=3Dhybrid)
=5B   22.463651=5D systemd=5B1=5D: Detected architecture x86-64.
=5B   22.470239=5D systemd=5B1=5D: Set hostname to <turing-police.cc.vt.e=
du>.
=5B   22.789850=5D systemd-cryptse (745) used greatest stack depth: 11336=
 bytes left
=5B   23.146719=5D kauditd_printk_skb: 23 callbacks suppressed
=5B   23.146723=5D audit: type=3D1400 audit(1522335075.823:49): avc:  den=
ied  =7B map_create =7D for  pid=3D1 comm=3D=22systemd=22 scontext=3Dsyst=
em_u:system_r:kernel_t:s15:c0.c1023 tcontext=3Dsystem_u:system_r:kernel_t=
:s15:c0.c1023 tclass=3Dbpf permissive=3D1
=5B   23.146767=5D audit: type=3D1400 audit(1522335075.823:50): avc:  den=
ied  =7B map_read map_write =7D for  pid=3D1 comm=3D=22systemd=22 scontex=
t=3Dsystem_u:system_r:kernel_t:s15:c0.c1023 tcontext=3Dsystem_u:system_r:=
kernel_t:s15:c0.c1023 tclass=3Dbpf permissive=3D1
=5B   23.146930=5D audit: type=3D1400 audit(1522335075.823:51): avc:  den=
ied  =7B prog_load =7D for  pid=3D1 comm=3D=22systemd=22 scontext=3Dsyste=
m_u:system_r:kernel_t:s15:c0.c1023 tcontext=3Dsystem_u:system_r:kernel_t:=
s15:c0.c1023 tclass=3Dbpf permissive=3D1
=5B   23.147233=5D audit: type=3D1400 audit(1522335075.824:52): avc:  den=
ied  =7B prog_run =7D for  pid=3D1 comm=3D=22systemd=22 scontext=3Dsystem=
_u:system_r:kernel_t:s15:c0.c1023 tcontext=3Dsystem_u:system_r:kernel_t:s=
15:c0.c1023 tclass=3Dbpf permissive=3D1
=5B   23.750831=5D systemd=5B1=5D: Unnecessary job for /dev/mapper/turing=
--police-00 was removed.
=5B   23.750845=5D systemd=5B1=5D: Unnecessary job for dev-disk-by=5Cx2du=
uid-665bb147=5Cx2d9e39=5Cx2d4003=5Cx2db3ae=5Cx2d7be925f51a97.device was r=
emoved.
=5B   23.774997=5D audit: type=3D1130 audit(1522335076.451:53): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dsystem_u:system_r:kernel=
_t:s15:c0.c1023 msg=3D'unit=3Dsystemd-journald comm=3D=22systemd=22 exe=
=3D=22/usr/lib/systemd/systemd=22 hostname=3D? addr=3D? terminal=3D? res=
=3Dsuccess'
=5B   23.775056=5D audit: type=3D1131 audit(1522335076.451:54): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dsystem_u:system_r:kernel=
_t:s15:c0.c1023 msg=3D'unit=3Dsystemd-journald comm=3D=22systemd=22 exe=
=3D=22/usr/lib/systemd/systemd=22 hostname=3D? addr=3D? terminal=3D? res=
=3Dsuccess'
=5B   23.778494=5D systemd=5B1=5D: Stopped Switch Root.
=5B   23.778919=5D audit: type=3D1130 audit(1522335076.455:55): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dsystem_u:system_r:kernel=
_t:s15:c0.c1023 msg=3D'unit=3Dinitrd-switch-root comm=3D=22systemd=22 exe=
=3D=22/usr/lib/systemd/systemd=22 hostname=3D? addr=3D? terminal=3D? res=
=3Dsuccess'
=5B   23.778952=5D audit: type=3D1131 audit(1522335076.455:56): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dsystem_u:system_r:kernel=
_t:s15:c0.c1023 msg=3D'unit=3Dinitrd-switch-root comm=3D=22systemd=22 exe=
=3D=22/usr/lib/systemd/systemd=22 hostname=3D? addr=3D? terminal=3D? res=
=3Dsuccess'
=5B   23.779371=5D systemd=5B1=5D: systemd-journald.service: Service has =
no hold-off time, scheduling restart.
=5B   23.779419=5D systemd=5B1=5D: systemd-journald.service: Scheduled re=
start job, restart counter is at 1.
=5B   23.779449=5D systemd=5B1=5D: Stopped Journal Service.
=5B   23.779549=5D audit: type=3D1130 audit(1522335076.456:57): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dsystem_u:system_r:kernel=
_t:s15:c0.c1023 msg=3D'unit=3Dsystemd-journald comm=3D=22systemd=22 exe=
=3D=22/usr/lib/systemd/systemd=22 hostname=3D? addr=3D? terminal=3D? res=
=3Dsuccess'
=5B   23.779578=5D audit: type=3D1131 audit(1522335076.456:58): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dsystem_u:system_r:kernel=
_t:s15:c0.c1023 msg=3D'unit=3Dsystemd-journald comm=3D=22systemd=22 exe=
=3D=22/usr/lib/systemd/systemd=22 hostname=3D? addr=3D? terminal=3D? res=
=3Dsuccess'
=5B   23.783972=5D systemd=5B1=5D: Starting Journal Service...
=5B   23.858769=5D EXT4-fs (dm-1): re-mounted. Opts: (null)
=5B   23.879665=5D EXT4-fs (dm-3): re-mounted. Opts: (null)
=5B   24.627397=5D udevadm (776) used greatest stack depth: 11000 bytes l=
eft
=5B   25.198372=5D bcma-pci-bridge 0000:03:00.0: enabling device (0100 ->=
 0102)
=5B   25.198740=5D bcma: bus0: Found chip with id 0x4313, rev 0x01 and pa=
ckage 0x08
=5B   25.198782=5D bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id =
0x800, rev 0x24, class 0x0)
=5B   25.198816=5D bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id=
 0x812, rev 0x18, class 0x0)
=5B   25.198876=5D bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820,=
 rev 0x11, class 0x0)
=5B   25.211934=5D bcma: bus0: Bus registered
=5B   25.409527=5D e1000e 0000:00:19.0 em1: renamed from eno1
=5B   25.956101=5D input: Dell WMI hotkeys as /devices/platform/PNP0C14:0=
0/wmi_bus/wmi_bus-PNP0C14:00/9DBB5994-A997-11DA-B012-B622A1EF5492/input/i=
nput18
=5B   25.996287=5D cryptd: max_cpu_qlen set to 1000
=5B   26.121735=5D dell_laptop: Using dell-rbtn acpi driver for receiving=
 events
=5B   26.471046=5D brcmsmac bcma0:1: mfg 4bf core 812 rev 24 class 0 irq =
17
=5B   26.474576=5D ieee80211 phy0: Selected rate control algorithm 'minst=
rel_ht'
=5B   26.511455=5D Adding 4079612k swap on /dev/mapper/turing--police-swa=
p.  Priority:-2 extents:1 across:4079612k FS
=5B   26.653226=5D brcmsmac bcma0:1 wlp3s0b1: renamed from wlan0
=5B   26.825907=5D EXT4-fs (sda2): mounted filesystem with ordered data m=
ode. Opts: (null)
=5B   26.863431=5D SELinux: (dev sda2, type ext4) getxattr errno 34
=5B   28.835377=5D kauditd_printk_skb: 20 callbacks suppressed
=5B   28.835380=5D audit: type=3D1130 audit(1522335081.512:79): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dsystem_u:system_r:kernel=
_t:s15:c0.c1023 msg=3D'unit=3Dlvm2-pvscan=40253:0 comm=3D=22systemd=22 ex=
e=3D=22/usr/lib/systemd/systemd=22 hostname=3D? addr=3D? terminal=3D? res=
=3Dsuccess'
=5B   29.108745=5D audit: type=3D1130 audit(1522335081.781:80): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dsystem_u:system_r:kernel=
_t:s15:c0.c1023 msg=3D'unit=3Dsystemd-fsck=40dev-mapper-turing=5Cx2d=5Cx2=
dpolice=5Cx2dlocal comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=
=22 hostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B   29.120076=5D audit: type=3D1130 audit(1522335081.792:81): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dsystem_u:system_r:kernel=
_t:s15:c0.c1023 msg=3D'unit=3Dsystemd-fsck=40dev-mapper-turing=5Cx2d=5Cx2=
dpolice=5Cx2dsrc comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=
=22 hostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B   29.129200=5D audit: type=3D1130 audit(1522335081.802:82): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dsystem_u:system_r:kernel=
_t:s15:c0.c1023 msg=3D'unit=3Dsystemd-fsck=40dev-mapper-turing=5Cx2d=5Cx2=
dpolice=5Cx2dvar comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=
=22 hostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B   29.136330=5D audit: type=3D1130 audit(1522335081.813:83): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dsystem_u:system_r:kernel=
_t:s15:c0.c1023 msg=3D'unit=3Dsystemd-fsck=40dev-mapper-turing=5Cx2d=5Cx2=
dpolice=5Cx2dvm comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=22=
 hostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B   29.144845=5D audit: type=3D1130 audit(1522335081.821:84): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dsystem_u:system_r:kernel=
_t:s15:c0.c1023 msg=3D'unit=3Dsystemd-fsck=40dev-mapper-turing=5Cx2d=5Cx2=
dpolice=5Cx2dopt comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=
=22 hostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B   29.151627=5D audit: type=3D1130 audit(1522335081.828:85): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dsystem_u:system_r:kernel=
_t:s15:c0.c1023 msg=3D'unit=3Dsystemd-fsck=40dev-mapper-turing=5Cx2d=5Cx2=
dpolice=5Cx2d01 comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=22=
 hostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B   29.161755=5D audit: type=3D1130 audit(1522335081.838:86): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dsystem_u:system_r:kernel=
_t:s15:c0.c1023 msg=3D'unit=3Dsystemd-fsck=40dev-mapper-turing=5Cx2d=5Cx2=
dpolice=5Cx2dmusic comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=
=22 hostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B   29.173484=5D audit: type=3D1130 audit(1522335081.850:87): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dsystem_u:system_r:kernel=
_t:s15:c0.c1023 msg=3D'unit=3Dsystemd-fsck=40dev-mapper-turing=5Cx2d=5Cx2=
dpolice=5Cx2dcatalogs comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/syst=
emd=22 hostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B   29.180903=5D audit: type=3D1130 audit(1522335081.857:88): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dsystem_u:system_r:kernel=
_t:s15:c0.c1023 msg=3D'unit=3Dsystemd-fsck=40dev-mapper-turing=5Cx2d=5Cx2=
dpolice=5Cx2dhome comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=
=22 hostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B   29.717406=5D EXT4-fs (dm-8): mounted filesystem with ordered data m=
ode. Opts: (null)
=5B   29.717443=5D SELinux: (dev dm-8, type ext4) getxattr errno 34
=5B   29.783941=5D EXT4-fs (dm-10): mounted filesystem with ordered data =
mode. Opts: (null)
=5B   29.783980=5D SELinux: (dev dm-10, type ext4) getxattr errno 34
=5B   29.941436=5D EXT4-fs (dm-9): mounted filesystem with ordered data m=
ode. Opts: (null)
=5B   29.941466=5D SELinux: (dev dm-9, type ext4) getxattr errno 34
=5B   30.040298=5D EXT4-fs (dm-7): mounted filesystem with ordered data m=
ode. Opts: (null)
=5B   30.040326=5D SELinux: (dev dm-7, type ext4) getxattr errno 34
=5B   30.057813=5D EXT4-fs (dm-5): mounted filesystem with ordered data m=
ode. Opts: (null)
=5B   30.057831=5D SELinux: (dev dm-5, type ext4) getxattr errno 34
=5B   30.271397=5D EXT4-fs (dm-4): mounted filesystem with ordered data m=
ode. Opts: (null)
=5B   30.271436=5D SELinux: (dev dm-4, type ext4) getxattr errno 34
=5B   30.304661=5D EXT4-fs (dm-6): mounted filesystem with ordered data m=
ode. Opts: (null)
=5B   30.304681=5D SELinux: (dev dm-6, type ext4) getxattr errno 34
=5B   30.378592=5D EXT4-fs (dm-12): mounted filesystem with ordered data =
mode. Opts: (null)
=5B   30.378608=5D SELinux: (dev dm-12, type ext4) getxattr errno 34
=5B   30.441804=5D EXT4-fs (dm-8): mounted filesystem with ordered data m=
ode. Opts: (null)
=5B   30.441828=5D SELinux: (dev dm-8, type ext4) getxattr errno 34
=5B   30.468088=5D EXT4-fs (dm-11): mounted filesystem with ordered data =
mode. Opts: (null)
=5B   30.468104=5D SELinux: (dev dm-11, type ext4) getxattr errno 34
=5B   30.861590=5D EXT4-fs (dm-8): mounted filesystem with ordered data m=
ode. Opts: (null)
=5B   30.861606=5D SELinux: (dev dm-8, type ext4) getxattr errno 34
=5B   31.051454=5D EXT4-fs (dm-8): mounted filesystem with ordered data m=
ode. Opts: (null)
=5B   31.051483=5D SELinux: (dev dm-8, type ext4) getxattr errno 34
=5B   31.216168=5D EXT4-fs (dm-8): mounted filesystem with ordered data m=
ode. Opts: (null)
=5B   31.216204=5D SELinux: (dev dm-8, type ext4) getxattr errno 34
=5B   51.700920=5D kauditd_printk_skb: 3 callbacks suppressed
=5B   51.700924=5D audit: type=3D1400 audit(1522335104.375:92): avc:  den=
ied  =7B transition =7D for  pid=3D1114 comm=3D=22sulogin=22 path=3D=22/u=
sr/bin/bash=22 dev=3D=22dm-1=22 ino=3D263319 scontext=3Dsystem_u:system_r=
:kernel_t:s15:c0.c1023 tcontext=3Droot:sysadm_r:sysadm_t:s0 tclass=3Dproc=
ess permissive=3D1
=5B   51.701028=5D audit: type=3D1400 audit(1522335104.375:92): avc:  den=
ied  =7B entrypoint =7D for  pid=3D1114 comm=3D=22sulogin=22 path=3D=22/u=
sr/bin/bash=22 dev=3D=22dm-1=22 ino=3D263319 scontext=3Droot:sysadm_r:sys=
adm_t:s0 tcontext=3Dsystem_u:object_r:unlabeled_t:s15:c0.c1023 tclass=3Df=
ile permissive=3D1
=5B   51.704229=5D audit: type=3D1400 audit(1522335104.375:92): avc:  den=
ied  =7B map =7D for  pid=3D1114 comm=3D=22bash=22 path=3D=22/usr/bin/bas=
h=22 dev=3D=22dm-1=22 ino=3D263319 scontext=3Droot:sysadm_r:sysadm_t:s0 t=
context=3Dsystem_u:object_r:unlabeled_t:s15:c0.c1023 tclass=3Dfile permis=
sive=3D1
=5B   51.704256=5D audit: type=3D1400 audit(1522335104.375:92): avc:  den=
ied  =7B execute =7D for  pid=3D1114 comm=3D=22bash=22 path=3D=22/usr/bin=
/bash=22 dev=3D=22dm-1=22 ino=3D263319 scontext=3Droot:sysadm_r:sysadm_t:=
s0 tcontext=3Dsystem_u:object_r:unlabeled_t:s15:c0.c1023 tclass=3Dfile pe=
rmissive=3D1
=5B   51.704509=5D audit: type=3D1300 audit(1522335104.375:92): arch=3Dc0=
00003e syscall=3D59 success=3Dyes exit=3D0 a0=3D556ac75f37b6 a1=3D7ffe015=
9b360 a2=3D556ac75ee7c0 a3=3D1 items=3D0 ppid=3D1107 pid=3D1114 auid=3D42=
94967295 uid=3D0 gid=3D0 euid=3D0 suid=3D0 fsuid=3D0 egid=3D0 sgid=3D0 fs=
gid=3D0 tty=3Dtty1 ses=3D4294967295 comm=3D=22bash=22 exe=3D=22/usr/bin/b=
ash=22 subj=3Droot:sysadm_r:sysadm_t:s0 key=3D(null)
=5B   51.704526=5D audit: type=3D1327 audit(1522335104.375:92): proctitle=
=3D=22bash=22
=5B   51.750815=5D audit: type=3D1400 audit(1522335104.425:93): avc:  den=
ied  =7B execute_no_trans =7D for  pid=3D1117 comm=3D=22bash=22 path=3D=
=22/usr/libexec/grepconf.sh=22 dev=3D=22dm-1=22 ino=3D263077 scontext=3Dr=
oot:sysadm_r:sysadm_t:s0 tcontext=3Dsystem_u:object_r:unlabeled_t:s15:c0.=
c1023 tclass=3Dfile permissive=3D1
=5B   51.768112=5D audit: type=3D1300 audit(1522335104.425:93): arch=3Dc0=
00003e syscall=3D59 success=3Dyes exit=3D0 a0=3D561e9d83f290 a1=3D561e9d8=
34840 a2=3D561e9d8404d0 a3=3D8 items=3D0 ppid=3D1114 pid=3D1117 auid=3D42=
94967295 uid=3D0 gid=3D0 euid=3D0 suid=3D0 fsuid=3D0 egid=3D0 sgid=3D0 fs=
gid=3D0 tty=3Dtty1 ses=3D4294967295 comm=3D=22grepconf.sh=22 exe=3D=22/us=
r/bin/bash=22 subj=3Droot:sysadm_r:sysadm_t:s0 key=3D(null)
=5B   51.768167=5D audit: type=3D1327 audit(1522335104.425:93): proctitle=
=3D2F62696E2F7368002F7573722F6C6962657865632F67726570636F6E662E7368002D63=

=5B   54.931450=5D audit: type=3D1400 audit(1522335107.608:94): avc:  den=
ied  =7B mounton =7D for  pid=3D1134 comm=3D=22mount=22 path=3D=22/var=22=
 dev=3D=22dm-3=22 ino=3D32001 scontext=3Droot:sysadm_r:sysadm_t:s0 tconte=
xt=3Dsystem_u:object_r:unlabeled_t:s15:c0.c1023 tclass=3Ddir permissive=
=3D1
=5B   55.064210=5D EXT4-fs (dm-8): mounted filesystem with ordered data m=
ode. Opts: (null)
=5B   55.064231=5D SELinux: (dev dm-8, type ext4) getxattr errno 34
=5B   77.584373=5D kauditd_printk_skb: 3 callbacks suppressed
=5B   77.584376=5D audit: type=3D1400 audit(1522335130.261:95): avc:  den=
ied  =7B write =7D for  pid=3D1140 comm=3D=22fsck.ext4=22 name=3D=22dm-8=
=22 dev=3D=22devtmpfs=22 ino=3D14187 scontext=3Droot:sysadm_r:sysadm_t:s0=
 tcontext=3Dsystem_u:object_r:fixed_disk_device_t:s15:c0.c1023 tclass=3Db=
lk_file permissive=3D1
=5B   77.584406=5D audit: type=3D1300 audit(1522335130.261:95): arch=3Dc0=
00003e syscall=3D257 success=3Dyes exit=3D4 a0=3Dffffff9c a1=3D55cb8b939d=
80 a2=3D82 a3=3D0 items=3D0 ppid=3D1139 pid=3D1140 auid=3D4294967295 uid=
=3D0 gid=3D0 euid=3D0 suid=3D0 fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=
=3Dtty1 ses=3D4294967295 comm=3D=22fsck.ext4=22 exe=3D=22/usr/sbin/fsck.e=
xt4=22 subj=3Droot:sysadm_r:sysadm_t:s0 key=3D(null)
=5B   77.584423=5D audit: type=3D1327 audit(1522335130.261:95): proctitle=
=3D6673636B2E65787434002F6465762F6D61707065722F747572696E672D2D706F6C6963=
652D766172
=5B  100.253729=5D EXT4-fs (dm-8): mounted filesystem with ordered data m=
ode. Opts: (null)
=5B  100.253760=5D SELinux: (dev dm-8, type ext4) getxattr errno 34


--==_Exmh_1522346273_3116P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.8.0 04/21/2017

iQEVAwUBWr0pIY0DS38y7CIcAQJlNwgAq719ibSjmonrYVpSIU2oy3Fsdqp8GPnJ
n2JABnekir5lNDNHDO2ZKpg2QBLFUm9LhkgGGbGrbTK3PdQ9jxHMXfPAri2ukuST
voItHSySdHJQ8aCryK/iubbNa7P7lpyJ2qmsqD8e463NkoHuniQZVYCqsq8r4eVe
V+mJg5NIBbTfkgDu+gXMKvr0Nccj9uUSMWz3gzvMIz4B0Z6gTUMpbPnbaBvzpTbt
fcyWTwv6bXmEYDbSw3Ok92S5hBjEYKbz4PLtDzKe7CRX6HfM1oH6bxaN3An+hqoP
6j35r5+jtbJw+f3NqNKfzLtgZfR1EsqkW2+FVylIGoXiR6+EQ2IVVQ==
=jlpc
-----END PGP SIGNATURE-----

--==_Exmh_1522346273_3116P--
