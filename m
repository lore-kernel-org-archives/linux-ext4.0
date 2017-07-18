From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: PROBLEM: lseek64 to END on directory returns INT64_MAX
Date: Tue, 18 Jul 2017 12:52:27 -0600
Message-ID: <021C45CB-9A6A-4C62-9690-EA8FFCCFF4DA@dilger.ca>
References: <CAGsgmAUQJMVjV-OGR4wBQqhwEV9T-bsn1qLyx0+g2shuMcwDTA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_F094D126-C737-46CD-A949-EA5866159EEC";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org
To: Mateusz S <muttdini@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:37217 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751392AbdGRSwd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Jul 2017 14:52:33 -0400
Received: by mail-it0-f44.google.com with SMTP id v127so8566085itd.0
        for <linux-ext4@vger.kernel.org>; Tue, 18 Jul 2017 11:52:33 -0700 (PDT)
In-Reply-To: <CAGsgmAUQJMVjV-OGR4wBQqhwEV9T-bsn1qLyx0+g2shuMcwDTA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_F094D126-C737-46CD-A949-EA5866159EEC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jul 18, 2017, at 4:13 AM, Mateusz S <muttdini@gmail.com> wrote:
>=20
> [1.] One line summary of the problem:
> lseek64 to END on directory returns INT64_MAX
>=20
> [2.] Full description of the problem/report:
> lseek64 to END on directory returns INT64_MAX.
> By INT64_MAX I mean: 9223372036854775807. This is when offset is set
> to 0, when offset is negative, then it will be added to the result,
> ex. 9223372036854775807 + (-1) =3D 9223372036854775806.
> I think that directory size is less than INT64_MAX, so this value
> seems completely off.

Seeking within a directory is related to the hash value of entries being
returned, and not the file (directory) byte offset.  Hashes start at 0,
and end at 2^63.  This is needed so that seekdir() and telldir() allow
restarting a readdir() call in the middle.

This is working as expected.

> Positive offset values will return -1 with EINVAL errno, which seems =
reasonable.

By this, I assume you mean "positive offset values beyond INT64_MAX"?

Cheers, Anderas

> I tried reproducing it on:
> - Manjaro Linux machine with 4.12.2 and 4.4.76 kernel
> - Ubuntu 17.04 virtual machine on QEMU/KVM with 4.10.0-26 kernel
>=20
> [3.] Keywords (i.e., modules, networking, kernel):
> filesystem, fs, kernel, ext, ext4
>=20
> [4.] Kernel version (from /proc/version):
> (output from Ubuntu 17.04 Virtual Machine)
> Linux version 4.10.0-26-generic (buildd@lcy01-09) (gcc version 6.3.0
> 20170406 (Ubuntu 6.3.0-12ubuntu2) ) #30-Ubuntu SMP Tue Jun 27 09:30:12
> UTC 2017
>=20
> [6.] A small shell script or example program which triggers the
>     problem (if possible)
>=20
> C++ code:
> #include <errno.h>
> #include <fcntl.h>
> #include <string>
> #include <string.h>
> #include <stdio.h>
> #include <unistd.h>
> #include <sys/stat.h>
> #include <sys/types.h>
>=20
> using namespace std;
>=20
> int main(int argc, char** argv)
> {
>    string targetdir =3D argv[1];
>    mkdir((targetdir + "/directory").c_str(), 0777);
>    int file =3D open((targetdir + "/directory").c_str(), O_DIRECTORY);
>=20
>    errno =3D 0;
>    off64_t lseekres =3D lseek64(file, -1, SEEK_END);
>    printf("lseek(%i, -1, SEEK_END) =3D %lli\terrno: %i (%s)\n", file,
> lseekres, errno, strerror(errno));
>=20
>    errno =3D 0;
>    lseekres =3D lseek64(file, 0, SEEK_END);
>    printf("lseek(%i, 0, SEEK_END) =3D %lli\terrno: %i (%s)\n", file,
> lseekres, errno, strerror(errno));
>=20
>    errno =3D 0;
>    lseekres =3D lseek64(file, 1, SEEK_END);
>    printf("lseek(%i, 1, SEEK_END) =3D %lli\terrno: %i (%s)\n", file,
> lseekres, errno, strerror(errno));
>=20
>    return 0;
> }
>=20
> How to run:
> ./program /path-to-directory-on-ext
>=20
> Output:
> lseek(3, -1, SEEK_END) =3D 9223372036854775806    errno: 0 (Success)
> lseek(3, 0, SEEK_END) =3D 9223372036854775807    errno: 0 (Success)
> lseek(3, 1, SEEK_END) =3D -1    errno: 22 (Invalid argument)
>=20
> [7.] Environment
> [7.1.] Software (add the output of the ver_linux script here)
> (output from Ubuntu VM)
>=20
> If some fields are empty or look unusual you may have an old version.
> Compare to the current minimal requirements in Documentation/Changes.
>=20
> DISTRIB_ID=3DUbuntu
> DISTRIB_RELEASE=3D17.04
> DISTRIB_CODENAME=3Dzesty
> DISTRIB_DESCRIPTION=3D"Ubuntu 17.04"
> NAME=3D"Ubuntu"
> VERSION=3D"17.04 (Zesty Zapus)"
> ID=3Dubuntu
> ID_LIKE=3Ddebian
> PRETTY_NAME=3D"Ubuntu 17.04"
> VERSION_ID=3D"17.04"
> HOME_URL=3D"https://www.ubuntu.com/"
> SUPPORT_URL=3D"https://help.ubuntu.com/"
> BUG_REPORT_URL=3D"https://bugs.launchpad.net/ubuntu/"
> =
PRIVACY_POLICY_URL=3D"https://www.ubuntu.com/legal/terms-and-policies/priv=
acy-policy"
> VERSION_CODENAME=3Dzesty
> UBUNTU_CODENAME=3Dzesty
> Linux ubuntu 4.10.0-26-generic #30-Ubuntu SMP Tue Jun 27 09:30:12 UTC
> 2017 x86_64 x86_64 x86_64 GNU/Linux
>=20
> Gnu C                  gcc (Ubuntu 6.3.0-12ubuntu2) 6.3.0 20170406
> util-linux             linux 2.29
> mount                  linux 2.29 (libmount 2.29.: selinux, btrfs,
> assert, debug)
> modutils               22
> e2fsprogs              1.43.4
> Linux C Library        > libc.2.24
> Dynamic linker (ldd)   2.24
> Procps                 3.3.12
> Net-tools              2.10-alpha
> iproute2              iproute2-ss161212
> Kbd                    2.0.3
> Sh-utils               8.26
> Modules Loaded         ebtable_filter ebtables ip6table_filter
> ip6_tables iptable_filter ppdev snd_hda_codec_generic snd_hda_intel
> snd_hda_codec snd_hda_core snd_hwdep snd_pcm snd_timer snd input_leds
> soundcore serio_raw i2c_piix4 parport_pc parport qemu_fw_cfg mac_hid
> ib_iser rdma_cm iw_cm ib_cm ib_core configfs iscsi_tcp libiscsi_tcp
> libiscsi scsi_transport_iscsi ip_tables x_tables autofs4 btrfs raid10
> raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor
> raid6_pq libcrc32c raid1 raid0 multipath linear crct10dif_pclmul
> crc32_pclmul ghash_clmulni_intel pcbc 8139too aesni_intel aes_x86_64
> crypto_simd glue_helper cryptd psmouse qxl ttm drm_kms_helper
> syscopyarea sysfillrect floppy sysimgblt fb_sys_fops 8139cp mii
> pata_acpi drm
>=20
> free reports:
>              total        used        free      shared  buff/cache   =
available
> Mem:        2045740       92516     1464428        3272      488796    =
 1796256
> Swap:        969960           0      969960
>=20
> [7.2.] Processor information (from /proc/cpuinfo):
> /proc/cpuinfo
> processor    : 0
> vendor_id    : GenuineIntel
> cpu family    : 6
> model        : 94
> model name    : Intel Core Processor (Skylake)
> stepping    : 3
> microcode    : 0x1
> cpu MHz        : 3408.000
> cache size    : 16384 KB
> physical id    : 0
> siblings    : 1
> core id        : 0
> cpu cores    : 1
> apicid        : 0
> initial apicid    : 0
> fpu        : yes
> fpu_exception    : yes
> cpuid level    : 13
> wp        : yes
> flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx rdtscp lm
> constant_tsc rep_good nopl xtopology pni pclmulqdq ssse3 fma cx16 pcid
> sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx
> f16c rdrand hypervisor lahf_lm abm 3dnowprefetch fsgsbase bmi1 hle
> avx2 smep bmi2 erms invpcid rtm mpx rdseed adx smap xsaveopt xsavec
> xgetbv1 arat
> bugs        :
> bogomips    : 6816.00
> clflush size    : 64
> cache_alignment    : 64
> address sizes    : 40 bits physical, 48 bits virtual
> power management:
>=20
> processor    : 1
> vendor_id    : GenuineIntel
> cpu family    : 6
> model        : 94
> model name    : Intel Core Processor (Skylake)
> stepping    : 3
> microcode    : 0x1
> cpu MHz        : 3408.000
> cache size    : 16384 KB
> physical id    : 1
> siblings    : 1
> core id        : 0
> cpu cores    : 1
> apicid        : 1
> initial apicid    : 1
> fpu        : yes
> fpu_exception    : yes
> cpuid level    : 13
> wp        : yes
> flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx rdtscp lm
> constant_tsc rep_good nopl xtopology pni pclmulqdq ssse3 fma cx16 pcid
> sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx
> f16c rdrand hypervisor lahf_lm abm 3dnowprefetch fsgsbase bmi1 hle
> avx2 smep bmi2 erms invpcid rtm mpx rdseed adx smap xsaveopt xsavec
> xgetbv1 arat
> bugs        :
> bogomips    : 6816.00
> clflush size    : 64
> cache_alignment    : 64
> address sizes    : 40 bits physical, 48 bits virtual
> power management:
>=20
> [7.3.] Module information (from /proc/modules):
> ebtable_filter 16384 0 - Live 0x0000000000000000
> ebtables 36864 1 ebtable_filter, Live 0x0000000000000000
> ip6table_filter 16384 0 - Live 0x0000000000000000
> ip6_tables 28672 1 ip6table_filter, Live 0x0000000000000000
> iptable_filter 16384 0 - Live 0x0000000000000000
> ppdev 20480 0 - Live 0x0000000000000000
> snd_hda_codec_generic 73728 1 - Live 0x0000000000000000
> snd_hda_intel 36864 0 - Live 0x0000000000000000
> snd_hda_codec 126976 2 snd_hda_codec_generic,snd_hda_intel, Live
> 0x0000000000000000
> snd_hda_core 81920 3
> snd_hda_codec_generic,snd_hda_intel,snd_hda_codec, Live
> 0x0000000000000000
> snd_hwdep 16384 1 snd_hda_codec, Live 0x0000000000000000
> snd_pcm 102400 3 snd_hda_intel,snd_hda_codec,snd_hda_core, Live
> 0x0000000000000000
> snd_timer 32768 1 snd_pcm, Live 0x0000000000000000
> snd 77824 6 =
snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_ti=
mer,
> Live 0x0000000000000000
> input_leds 16384 0 - Live 0x0000000000000000
> soundcore 16384 1 snd, Live 0x0000000000000000
> serio_raw 16384 0 - Live 0x0000000000000000
> i2c_piix4 24576 0 - Live 0x0000000000000000
> parport_pc 32768 0 - Live 0x0000000000000000
> parport 49152 2 ppdev,parport_pc, Live 0x0000000000000000
> qemu_fw_cfg 16384 0 - Live 0x0000000000000000
> mac_hid 16384 0 - Live 0x0000000000000000
> ib_iser 49152 0 - Live 0x0000000000000000
> rdma_cm 53248 1 ib_iser, Live 0x0000000000000000
> iw_cm 45056 1 rdma_cm, Live 0x0000000000000000
> ib_cm 49152 1 rdma_cm, Live 0x0000000000000000
> ib_core 196608 4 ib_iser,rdma_cm,iw_cm,ib_cm, Live 0x0000000000000000
> configfs 36864 2 rdma_cm, Live 0x0000000000000000
> iscsi_tcp 20480 0 - Live 0x0000000000000000
> libiscsi_tcp 20480 1 iscsi_tcp, Live 0x0000000000000000
> libiscsi 57344 3 ib_iser,iscsi_tcp,libiscsi_tcp, Live =
0x0000000000000000
> scsi_transport_iscsi 98304 4 ib_iser,iscsi_tcp,libiscsi, Live =
0x0000000000000000
> ip_tables 24576 1 iptable_filter, Live 0x0000000000000000
> x_tables 36864 5
> ebtables,ip6table_filter,ip6_tables,iptable_filter,ip_tables, Live
> 0x0000000000000000
> autofs4 40960 2 - Live 0x0000000000000000
> btrfs 1093632 0 - Live 0x0000000000000000
> raid10 49152 0 - Live 0x0000000000000000
> raid456 131072 0 - Live 0x0000000000000000
> async_raid6_recov 20480 1 raid456, Live 0x0000000000000000
> async_memcpy 16384 2 raid456,async_raid6_recov, Live =
0x0000000000000000
> async_pq 16384 2 raid456,async_raid6_recov, Live 0x0000000000000000
> async_xor 16384 3 raid456,async_raid6_recov,async_pq, Live =
0x0000000000000000
> async_tx 16384 5
> raid456,async_raid6_recov,async_memcpy,async_pq,async_xor, Live
> 0x0000000000000000
> xor 24576 2 btrfs,async_xor, Live 0x0000000000000000
> raid6_pq 114688 4 btrfs,raid456,async_raid6_recov,async_pq, Live
> 0x0000000000000000
> libcrc32c 16384 1 raid456, Live 0x0000000000000000
> raid1 40960 0 - Live 0x0000000000000000
> raid0 20480 0 - Live 0x0000000000000000
> multipath 16384 0 - Live 0x0000000000000000
> linear 16384 0 - Live 0x0000000000000000
> crct10dif_pclmul 16384 0 - Live 0x0000000000000000
> crc32_pclmul 16384 0 - Live 0x0000000000000000
> ghash_clmulni_intel 16384 0 - Live 0x0000000000000000
> pcbc 16384 0 - Live 0x0000000000000000
> 8139too 36864 0 - Live 0x0000000000000000
> aesni_intel 167936 0 - Live 0x0000000000000000
> aes_x86_64 20480 1 aesni_intel, Live 0x0000000000000000
> crypto_simd 16384 1 aesni_intel, Live 0x0000000000000000
> glue_helper 16384 1 aesni_intel, Live 0x0000000000000000
> cryptd 24576 3 ghash_clmulni_intel,aesni_intel,crypto_simd, Live
> 0x0000000000000000
> psmouse 139264 0 - Live 0x0000000000000000
> qxl 69632 1 - Live 0x0000000000000000
> ttm 98304 1 qxl, Live 0x0000000000000000
> drm_kms_helper 151552 1 qxl, Live 0x0000000000000000
> syscopyarea 16384 1 drm_kms_helper, Live 0x0000000000000000
> sysfillrect 16384 1 drm_kms_helper, Live 0x0000000000000000
> floppy 77824 0 - Live 0x0000000000000000
> sysimgblt 16384 1 drm_kms_helper, Live 0x0000000000000000
> fb_sys_fops 16384 1 drm_kms_helper, Live 0x0000000000000000
> 8139cp 28672 0 - Live 0x0000000000000000
> mii 16384 2 8139too,8139cp, Live 0x0000000000000000
> pata_acpi 16384 0 - Live 0x0000000000000000
> drm 352256 4 qxl,ttm,drm_kms_helper, Live 0x0000000000000000
>=20
> [7.4.] Loaded driver and hardware information (/proc/ioports, =
/proc/iomem)
> 0000-0000 : PCI Bus 0000:00
>  0000-0000 : dma1
>  0000-0000 : pic1
>  0000-0000 : timer0
>  0000-0000 : timer1
>  0000-0000 : keyboard
>  0000-0000 : keyboard
>  0000-0000 : rtc0
>  0000-0000 : dma page reg
>  0000-0000 : pic2
>  0000-0000 : dma2
>  0000-0000 : fpu
>  0000-0000 : 0000:00:01.1
>    0000-0000 : ata_piix
>  0000-0000 : 0000:00:01.1
>    0000-0000 : ata_piix
>  0000-0000 : 0000:00:01.1
>    0000-0000 : ata_piix
>  0000-0000 : vesafb
>  0000-0000 : floppy
>  0000-0000 : floppy
>  0000-0000 : 0000:00:01.1
>    0000-0000 : ata_piix
>  0000-0000 : floppy
>  0000-0000 : serial
>  0000-0000 : QEMU0002:00
>    0000-0000 : fw_cfg_io
>  0000-0000 : 0000:00:01.3
>    0000-0000 : ACPI PM1a_EVT_BLK
>    0000-0000 : ACPI PM1a_CNT_BLK
>    0000-0000 : ACPI PM_TMR
>  0000-0000 : 0000:00:01.3
>    0000-0000 : piix4_smbus
> 0000-0000 : PCI conf1
> 0000-0000 : PCI Bus 0000:00
>  0000-0000 : ACPI GPE0_BLK
>  0000-0000 : 0000:00:03.0
>    0000-0000 : 8139cp
>  0000-0000 : 0000:00:06.0
>  0000-0000 : 0000:00:02.0
>  0000-0000 : 0000:00:05.0
>    0000-0000 : uhci_hcd
>  0000-0000 : 0000:00:05.1
>    0000-0000 : uhci_hcd
>  0000-0000 : 0000:00:05.2
>    0000-0000 : uhci_hcd
>  0000-0000 : 0000:00:07.0
>  0000-0000 : 0000:00:01.1
>    0000-0000 : ata_piix
>=20
> [7.5.] PCI information ('lspci -vvv' as root)
> 00:00.0 Host bridge: Intel Corporation 440FX - 82441FX PMC [Natoma] =
(rev 02)
>    Subsystem: Red Hat, Inc Qemu virtual machine
>    Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>=20
> 00:01.0 ISA bridge: Intel Corporation 82371SB PIIX3 ISA [Natoma/Triton =
II]
>    Subsystem: Red Hat, Inc Qemu virtual machine
>    Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>=20
> 00:01.1 IDE interface: Intel Corporation 82371SB PIIX3 IDE
> [Natoma/Triton II] (prog-if 80 [Master])
>    Subsystem: Red Hat, Inc Qemu virtual machine
>    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>    Latency: 0
>    Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) =
[size=3D8]
>    Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable)
>    Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) =
[size=3D8]
>    Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable)
>    Region 4: I/O ports at c1e0 [size=3D16]
>    Kernel driver in use: ata_piix
>    Kernel modules: pata_acpi
>=20
> 00:01.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 03)
>    Subsystem: Red Hat, Inc Qemu virtual machine
>    Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>    Interrupt: pin A routed to IRQ 9
>    Kernel driver in use: piix4_smbus
>    Kernel modules: i2c_piix4
>=20
> 00:02.0 VGA compatible controller: Red Hat, Inc. QXL paravirtual
> graphic card (rev 04) (prog-if 00 [VGA controller])
>    Subsystem: Red Hat, Inc QEMU Virtual Machine
>    Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>    Interrupt: pin A routed to IRQ 11
>    Region 0: Memory at f4000000 (32-bit, non-prefetchable) [size=3D64M]
>    Region 1: Memory at f8000000 (32-bit, non-prefetchable) [size=3D64M]
>    Region 2: Memory at fc054000 (32-bit, non-prefetchable) [size=3D8K]
>    Region 3: I/O ports at c140 [size=3D32]
>    Expansion ROM at 000c0000 [disabled] [size=3D128K]
>    Kernel driver in use: qxl
>    Kernel modules: qxl
>=20
> 00:03.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL-8100/8101L/8139 PCI Fast Ethernet Adapter (rev 20)
>    Subsystem: Red Hat, Inc QEMU Virtual Machine
>    Physical Slot: 3
>    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>    Latency: 0, Cache Line Size: 64 bytes
>    Interrupt: pin A routed to IRQ 11
>    Region 0: I/O ports at c000 [size=3D256]
>    Region 1: Memory at fc056000 (32-bit, non-prefetchable) [size=3D256]
>    Expansion ROM at fc000000 [disabled] [size=3D256K]
>    Kernel driver in use: 8139cp
>    Kernel modules: 8139cp, 8139too
>=20
> 00:04.0 Audio device: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
> Family) High Definition Audio Controller (rev 01)
>    Subsystem: Red Hat, Inc QEMU Virtual Machine
>    Physical Slot: 4
>    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx+
>    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>    Latency: 0
>    Interrupt: pin A routed to IRQ 26
>    Region 0: Memory at fc050000 (32-bit, non-prefetchable) [size=3D16K]
>    Capabilities: [60] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
>        Address: 00000000fee00000  Data: 4061
>    Kernel driver in use: snd_hda_intel
>    Kernel modules: snd_hda_intel
>=20
> 00:05.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB
> UHCI Controller #1 (rev 03) (prog-if 00 [UHCI])
>    Subsystem: Red Hat, Inc QEMU Virtual Machine
>    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>    Latency: 0
>    Interrupt: pin A routed to IRQ 10
>    Region 4: I/O ports at c160 [size=3D32]
>    Kernel driver in use: uhci_hcd
>=20
> 00:05.1 USB controller: Intel Corporation 82801I (ICH9 Family) USB
> UHCI Controller #2 (rev 03) (prog-if 00 [UHCI])
>    Subsystem: Red Hat, Inc QEMU Virtual Machine
>    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>    Latency: 0
>    Interrupt: pin B routed to IRQ 11
>    Region 4: I/O ports at c180 [size=3D32]
>    Kernel driver in use: uhci_hcd
>=20
> 00:05.2 USB controller: Intel Corporation 82801I (ICH9 Family) USB
> UHCI Controller #3 (rev 03) (prog-if 00 [UHCI])
>    Subsystem: Red Hat, Inc QEMU Virtual Machine
>    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>    Latency: 0
>    Interrupt: pin C routed to IRQ 11
>    Region 4: I/O ports at c1a0 [size=3D32]
>    Kernel driver in use: uhci_hcd
>=20
> 00:05.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2
> EHCI Controller #1 (rev 03) (prog-if 20 [EHCI])
>    Subsystem: Red Hat, Inc QEMU Virtual Machine
>    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>    Latency: 0, Cache Line Size: 64 bytes
>    Interrupt: pin D routed to IRQ 10
>    Region 0: Memory at fc057000 (32-bit, non-prefetchable) [size=3D4K]
>    Kernel driver in use: ehci-pci
>=20
> 00:06.0 Communication controller: Red Hat, Inc Virtio console
>    Subsystem: Red Hat, Inc Virtio console
>    Physical Slot: 6
>    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx+
>    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>    Latency: 0
>    Interrupt: pin A routed to IRQ 11
>    Region 0: I/O ports at c100 [size=3D64]
>    Region 1: Memory at fc058000 (32-bit, non-prefetchable) [size=3D4K]
>    Region 4: Memory at febf8000 (64-bit, prefetchable) [size=3D16K]
>    Capabilities: [98] MSI-X: Enable+ Count=3D2 Masked-
>        Vector table: BAR=3D1 offset=3D00000000
>        PBA: BAR=3D1 offset=3D00000800
>    Capabilities: [84] Vendor Specific Information: VirtIO: <unknown>
>        BAR=3D0 offset=3D00000000 size=3D00000000
>    Capabilities: [70] Vendor Specific Information: VirtIO: Notify
>        BAR=3D4 offset=3D00003000 size=3D00001000 multiplier=3D00000004
>    Capabilities: [60] Vendor Specific Information: VirtIO: DeviceCfg
>        BAR=3D4 offset=3D00002000 size=3D00001000
>    Capabilities: [50] Vendor Specific Information: VirtIO: ISR
>        BAR=3D4 offset=3D00001000 size=3D00001000
>    Capabilities: [40] Vendor Specific Information: VirtIO: CommonCfg
>        BAR=3D4 offset=3D00000000 size=3D00001000
>    Kernel driver in use: virtio-pci
>=20
> 00:07.0 Unclassified device [00ff]: Red Hat, Inc Virtio memory balloon
>    Subsystem: Red Hat, Inc Virtio memory balloon
>    Physical Slot: 7
>    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>    Latency: 0
>    Interrupt: pin A routed to IRQ 11
>    Region 0: I/O ports at c1c0 [size=3D32]
>    Region 4: Memory at febfc000 (64-bit, prefetchable) [size=3D16K]
>    Capabilities: [84] Vendor Specific Information: VirtIO: <unknown>
>        BAR=3D0 offset=3D00000000 size=3D00000000
>    Capabilities: [70] Vendor Specific Information: VirtIO: Notify
>        BAR=3D4 offset=3D00003000 size=3D00001000 multiplier=3D00000004
>    Capabilities: [60] Vendor Specific Information: VirtIO: DeviceCfg
>        BAR=3D4 offset=3D00002000 size=3D00001000
>    Capabilities: [50] Vendor Specific Information: VirtIO: ISR
>        BAR=3D4 offset=3D00001000 size=3D00001000
>    Capabilities: [40] Vendor Specific Information: VirtIO: CommonCfg
>        BAR=3D4 offset=3D00000000 size=3D00001000
>    Kernel driver in use: virtio-pci
>=20
> [7.6.] SCSI information (from /proc/scsi/scsi)
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>  Vendor: ATA      Model: QEMU HARDDISK    Rev: 2.5+
>  Type:   Direct-Access                    ANSI  SCSI revision: 05
> Host: scsi0 Channel: 00 Id: 01 Lun: 00
>  Vendor: QEMU     Model: QEMU DVD-ROM     Rev: 2.5+
>  Type:   CD-ROM                           ANSI  SCSI revision: 05


Cheers, Andreas






--Apple-Mail=_F094D126-C737-46CD-A949-EA5866159EEC
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZbljspIg59Q01vtYRAixQAJ9LRhMZdg+qH8AJj1U26KlTXXyfPgCfQSJJ
p1xvIHH+KXbmyBRikbbpZcY=
=llC3
-----END PGP SIGNATURE-----

--Apple-Mail=_F094D126-C737-46CD-A949-EA5866159EEC--
