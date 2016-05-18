From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] New: Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Wed, 18 May 2016 11:41:03 +0000
Message-ID: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50668 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbcERLlO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 May 2016 07:41:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7026F2034B
	for <linux-ext4@vger.kernel.org>; Wed, 18 May 2016 11:41:10 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E62C8202EC
	for <linux-ext4@vger.kernel.org>; Wed, 18 May 2016 11:41:03 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D118401

            Bug ID: 118401
           Summary: Lenovo A740 gave up waiting for root device with
                    kernels >=3D 4.3
           Product: File System
           Version: 2.5
    Kernel Version: 4.3
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: unhammer+dill@mm.st
        Regression: No

(I posted at http://permalink.gmane.org/gmane.linux.kernel/2219523 but =
received
no reply, so as per instructions from
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1574178/comments/2=
3 I'm
opening a bug report here. I do not know what Component this bug belong=
s in, so
I took a wild guess, sorry if it's completely wrong.)


[2.] Full description of the problem/report:

I have a Lenovo A740 (running Xubuntu 16.04) which, with kernel
versions >=3D 4.3, gives this on trying to boot:

  Begin: Waiting for root file system ... Begin: Running
  /scripts/local-block ... done.
  Begin: Running /scripts/local-block ... done.
  Begin: Running /scripts/local-block ... done.
  [=E2=80=A6]
  done.
  Gave up waiting for root device.=20

and drops me into an (initramfs) shell, where my keyboard is
unresponsive. Images of the screen are at:
https://launchpadlibrarian.net/255781725/dropping.jpg
https://launchpadlibrarian.net/255781692/drop.jpg

It boots fine with earlier kernels, e.g. 4.2.0. After trying various
packages from http://kernel.ubuntu.com/~kernel-ppa/mainline/ it seems
anything 4.3 or higher gives the issue, while
linux-image-4.2.8-040208-generic_4.2.8-040208.201512150620_amd64.deb is
the highest version that I can get to boot.

I've filed an Ubuntu bug report at
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1574178 and was
asked to move the issue upstream.

[3.] Keywords (i.e., modules, networking, kernel):

filesystem maybe?

[4.] Kernel version (from /proc/version):

linux-image-4.3.0-040300-generic_4.3.0-040300.201511020949_amd64.deb
or higher

[5.] Output of Oops.. message (if applicable) with symbolic information=
=20
     resolved (see Documentation/oops-tracing.txt)
[6.] A small shell script or example program which triggers the
     problem (if possible)
[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)

I guess scripts/ver_linux isn't of much use since I can't boot 4.3 or
higher anyway, but here it is just in case:


$ sh scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux storepadda 4.2.0-35-generic #40-Ubuntu SMP Tue Mar 15 22:15:45 UT=
C 2016
x86_64 x86_64 x86_64 GNU/Linux

GNU C                   5.3.1
GNU Make                4.1
Binutils                2.26
Util-linux              2.27.1
Mount                   2.27.1
Module-init-tools       22
E2fsprogs               1.42.13
Pcmciautils             018
PPP                     2.4.7
Linux C Library         2.23
Dynamic linker (ldd)    2.23
Linux C++ Library       6.0.21
Procps                  3.3.10
Net-tools               1.60
Kbd                     1.15.5
Console-tools           1.15.5
Sh-utils                8.25
Udev                    229
Wireless-tools          30
Modules Loaded          8723au ablk_helper aesni_intel aes_x86_64 ahci =
autofs4
binfmt_misc btrfs cfg80211 coretemp crc32_pclmul crct10dif_pclmul crypt=
d drm
drm_kms_helper gf128mul glue_helper hid hid_generic hid_logitech_dj
hid_logitech_hidpp hid_multitouch i2c_algo_bit i915 input_leds intel_po=
werclamp
intel_rapl joydev kvm libahci lp lpc_ich lrw mac_hid media mei mei_me m=
emstick
mii nls_iso8859_1 parport parport_pc ppdev psmouse r8169 raid6_pq rtsx_=
pci
rtsx_pci_ms rtsx_pci_sdmmc serio_raw shpchp snd snd_hda_codec
snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_=
core
snd_hda_intel snd_hwdep snd_pcm snd_rawmidi snd_seq snd_seq_device snd_=
seq_midi
snd_seq_midi_event snd_timer soundcore ttm uas usbhid usb_storage uvcvi=
deo
v4l2_common video videobuf2_core videobuf2_memops videobuf2_vmalloc vid=
eodev
x86_pkg_temp_thermal xor

[7.2.] Processor information (from /proc/cpuinfo):

(from running 4.2)

processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 69
model name    : Intel(R) Core(TM) i7-4558U CPU @ 2.80GHz
stepping    : 1
microcode    : 0x17
cpu MHz        : 1189.453
cache size    : 4096 KB
physical id    : 0
siblings    : 4
core id        : 0
cpu cores    : 2
apicid        : 0
initial apicid    : 0
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca=
 cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pd=
pe1gb
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx=
 est tm2
ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm ida arat epb p=
ln pts
dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 a=
vx2 smep
bmi2 erms invpcid xsaveopt
bugs        :
bogomips    : 5586.93
clflush size    : 64
cache_alignment    : 64
address sizes    : 39 bits physical, 48 bits virtual
power management:

processor    : 1
vendor_id    : GenuineIntel
cpu family    : 6
model        : 69
model name    : Intel(R) Core(TM) i7-4558U CPU @ 2.80GHz
stepping    : 1
microcode    : 0x17
cpu MHz        : 1154.234
cache size    : 4096 KB
physical id    : 0
siblings    : 4
core id        : 0
cpu cores    : 2
apicid        : 1
initial apicid    : 1
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca=
 cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pd=
pe1gb
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx=
 est tm2
ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm ida arat epb p=
ln pts
dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 a=
vx2 smep
bmi2 erms invpcid xsaveopt
bugs        :
bogomips    : 5586.93
clflush size    : 64
cache_alignment    : 64
address sizes    : 39 bits physical, 48 bits virtual
power management:

processor    : 2
vendor_id    : GenuineIntel
cpu family    : 6
model        : 69
model name    : Intel(R) Core(TM) i7-4558U CPU @ 2.80GHz
stepping    : 1
microcode    : 0x17
cpu MHz        : 860.562
cache size    : 4096 KB
physical id    : 0
siblings    : 4
core id        : 1
cpu cores    : 2
apicid        : 2
initial apicid    : 2
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca=
 cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pd=
pe1gb
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx=
 est tm2
ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm ida arat epb p=
ln pts
dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 a=
vx2 smep
bmi2 erms invpcid xsaveopt
bugs        :
bogomips    : 5586.93
clflush size    : 64
cache_alignment    : 64
address sizes    : 39 bits physical, 48 bits virtual
power management:

processor    : 3
vendor_id    : GenuineIntel
cpu family    : 6
model        : 69
model name    : Intel(R) Core(TM) i7-4558U CPU @ 2.80GHz
stepping    : 1
microcode    : 0x17
cpu MHz        : 1000.015
cache size    : 4096 KB
physical id    : 0
siblings    : 4
core id        : 1
cpu cores    : 2
apicid        : 3
initial apicid    : 3
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca=
 cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pd=
pe1gb
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx=
 est tm2
ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm ida arat epb p=
ln pts
dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 a=
vx2 smep
bmi2 erms invpcid xsaveopt
bugs        :
bogomips    : 5586.93
clflush size    : 64
cache_alignment    : 64
address sizes    : 39 bits physical, 48 bits virtual
power management:


[7.3.] Module information (from /proc/modules):

(from running 4.2)

uas 24576 0 - Live 0x0000000000000000
usb_storage 69632 1 uas, Live 0x0000000000000000
cfg80211 557056 0 - Live 0x0000000000000000
binfmt_misc 20480 1 - Live 0x0000000000000000
nls_iso8859_1 16384 1 - Live 0x0000000000000000
snd_hda_codec_realtek 86016 1 - Live 0x0000000000000000
snd_hda_codec_generic 77824 1 snd_hda_codec_realtek, Live 0x00000000000=
00000
snd_hda_codec_hdmi 49152 1 - Live 0x0000000000000000
uvcvideo 90112 0 - Live 0x0000000000000000
videobuf2_vmalloc 16384 1 uvcvideo, Live 0x0000000000000000
videobuf2_memops 16384 1 videobuf2_vmalloc, Live 0x0000000000000000
snd_hda_intel 36864 5 - Live 0x0000000000000000
snd_hda_codec 135168 4
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_=
intel,
Live 0x0000000000000000
videobuf2_core 49152 1 uvcvideo, Live 0x0000000000000000
snd_hda_core 65536 5
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_=
intel,snd_hda_codec,
Live 0x0000000000000000
intel_rapl 20480 0 - Live 0x0000000000000000
x86_pkg_temp_thermal 16384 0 - Live 0x0000000000000000
intel_powerclamp 16384 0 - Live 0x0000000000000000
coretemp 16384 0 - Live 0x0000000000000000
snd_hwdep 16384 1 snd_hda_codec, Live 0x0000000000000000
v4l2_common 16384 1 videobuf2_core, Live 0x0000000000000000
videodev 172032 3 uvcvideo,videobuf2_core,v4l2_common, Live 0x000000000=
0000000
snd_pcm 106496 4 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_hda=
_core,
Live 0x0000000000000000
media 24576 2 uvcvideo,videodev, Live 0x0000000000000000
8723au 897024 0 - Live 0x0000000000000000 (OE)
snd_seq_midi 16384 0 - Live 0x0000000000000000
snd_seq_midi_event 16384 1 snd_seq_midi, Live 0x0000000000000000
hid_multitouch 20480 0 - Live 0x0000000000000000
joydev 20480 0 - Live 0x0000000000000000
snd_rawmidi 32768 1 snd_seq_midi, Live 0x0000000000000000
kvm 516096 0 - Live 0x0000000000000000
snd_seq 69632 2 snd_seq_midi,snd_seq_midi_event, Live 0x000000000000000=
0
crct10dif_pclmul 16384 0 - Live 0x0000000000000000
snd_seq_device 16384 3 snd_seq_midi,snd_rawmidi,snd_seq, Live
0x0000000000000000
crc32_pclmul 16384 0 - Live 0x0000000000000000
snd_timer 32768 2 snd_pcm,snd_seq, Live 0x0000000000000000
mei_me 36864 0 - Live 0x0000000000000000
input_leds 16384 0 - Live 0x0000000000000000
rtsx_pci_ms 20480 0 - Live 0x0000000000000000
mac_hid 16384 0 - Live 0x0000000000000000
memstick 20480 1 rtsx_pci_ms, Live 0x0000000000000000
aesni_intel 167936 0 - Live 0x0000000000000000
mei 98304 1 mei_me, Live 0x0000000000000000
snd 81920 21
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_=
intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_seq_devic=
e,snd_timer,
Live 0x0000000000000000
shpchp 36864 0 - Live 0x0000000000000000
serio_raw 16384 0 - Live 0x0000000000000000
aes_x86_64 20480 1 aesni_intel, Live 0x0000000000000000
lrw 16384 1 aesni_intel, Live 0x0000000000000000
gf128mul 16384 1 lrw, Live 0x0000000000000000
glue_helper 16384 1 aesni_intel, Live 0x0000000000000000
ablk_helper 16384 1 aesni_intel, Live 0x0000000000000000
soundcore 16384 1 snd, Live 0x0000000000000000
lpc_ich 24576 0 - Live 0x0000000000000000
cryptd 20480 2 aesni_intel,ablk_helper, Live 0x0000000000000000
parport_pc 32768 0 - Live 0x0000000000000000
ppdev 20480 0 - Live 0x0000000000000000
lp 20480 0 - Live 0x0000000000000000
parport 49152 3 parport_pc,ppdev,lp, Live 0x0000000000000000
autofs4 40960 2 - Live 0x0000000000000000
btrfs 978944 0 - Live 0x0000000000000000
xor 24576 1 btrfs, Live 0x0000000000000000
raid6_pq 102400 1 btrfs, Live 0x0000000000000000
hid_generic 16384 0 - Live 0x0000000000000000
hid_logitech_hidpp 20480 0 - Live 0x0000000000000000
hid_logitech_dj 20480 0 - Live 0x0000000000000000
usbhid 49152 0 - Live 0x0000000000000000
hid 118784 6
hid_multitouch,hid_generic,hid_logitech_hidpp,hid_logitech_dj,usbhid, L=
ive
0x0000000000000000
rtsx_pci_sdmmc 24576 0 - Live 0x0000000000000000
i915 1134592 5 - Live 0x0000000000000000
video 40960 1 i915, Live 0x0000000000000000
ttm 94208 0 - Live 0x0000000000000000
rtsx_pci 53248 2 rtsx_pci_ms,rtsx_pci_sdmmc, Live 0x0000000000000000
psmouse 126976 0 - Live 0x0000000000000000
i2c_algo_bit 16384 1 i915, Live 0x0000000000000000
drm_kms_helper 131072 1 i915, Live 0x0000000000000000
r8169 81920 0 - Live 0x0000000000000000
mii 16384 1 r8169, Live 0x0000000000000000
drm 356352 7 i915,ttm,drm_kms_helper, Live 0x0000000000000000
ahci 36864 3 - Live 0x0000000000000000
libahci 32768 1 ahci, Live 0x0000000000000000


[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iom=
em)

(from running 4.2)

/proc/ioports:
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0071 : rtc_cmos
  0070-0071 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0cf8-0cff : PCI conf1
1800-1803 : ACPI PM1a_EVT_BLK
1804-1805 : ACPI PM1a_CNT_BLK
1808-180b : ACPI PM_TMR
1830-1833 : iTCO_wdt.0.auto
1850-1850 : ACPI PM2_CNT_BLK
1860-187f : iTCO_wdt.0.auto
1880-189f : ACPI GPE0_BLK
3000-3fff : PCI Bus 0000:08
  3000-307f : 0000:08:00.0
4000-4fff : PCI Bus 0000:02
5000-5fff : PCI Bus 0000:01
  5000-50ff : 0000:01:00.0
    5000-50ff : r8169
6000-603f : 0000:00:02.0
6040-605f : 0000:00:1f.3
6060-607f : 0000:00:1f.2
  6060-607f : ahci
6080-6087 : 0000:00:1f.2
  6080-6087 : ahci
6088-608f : 0000:00:1f.2
  6088-608f : ahci
6090-6093 : 0000:00:1f.2
  6090-6093 : ahci
6094-6097 : 0000:00:1f.2
  6094-6097 : ahci

/proc/iomem:
00000000-00000fff : reserved
00001000-00057fff : System RAM
00058000-00058fff : reserved
00059000-00085fff : System RAM
00086000-0009ffff : reserved
000f0000-000fffff : System ROM
00100000-9a4cefff : System RAM
  02000000-027fdddc : Kernel code
  027fdddd-02f35d3f : Kernel data
  030ad000-031effff : Kernel bss
9a4cf000-9a6cefff : reserved
9a6cf000-9aebefff : reserved
9aebf000-9afbefff : ACPI Non-volatile Storage
9afbf000-9affefff : ACPI Tables
9afff000-9affffff : System RAM
9b000000-9b9fffff : RAM buffer
9ba00000-9f9fffff : reserved
  9ba00000-9f9fffff : Graphics Stolen Memory
a0000000-b1ffffff : PCI Bus 0000:08
  a0000000-afffffff : 0000:08:00.0
  b0000000-b1ffffff : 0000:08:00.0
b2000000-b2ffffff : PCI Bus 0000:02
b3000000-b3ffffff : PCI Bus 0000:08
  b3000000-b3ffffff : 0000:08:00.0
b4000000-b4ffffff : PCI Bus 0000:02
  b4000000-b4000fff : 0000:02:00.0
    b4000000-b4000fff : rtsx_pci
b5000000-b53fffff : 0000:00:02.0
b5400000-b54fffff : PCI Bus 0000:01
  b5400000-b5403fff : 0000:01:00.0
    b5400000-b5403fff : r8169
b5500000-b55fffff : PCI Bus 0000:01
  b5500000-b5500fff : 0000:01:00.0
    b5500000-b5500fff : r8169
b5600000-b560ffff : 0000:00:14.0
  b5600000-b560ffff : xhci-hcd
b5610000-b5613fff : 0000:00:03.0
  b5610000-b5613fff : ICH HD audio
b5614000-b5617fff : 0000:00:1b.0
  b5614000-b5617fff : ICH HD audio
b5618000-b56187ff : 0000:00:1f.2
  b5618000-b56187ff : ahci
b5619000-b56193ff : 0000:00:1d.0
b561a000-b561a0ff : 0000:00:1f.3
b561b000-b561b01f : 0000:00:16.0
  b561b000-b561b01f : mei_me
c0000000-cfffffff : 0000:00:02.0
e00f8000-e00f8fff : reserved
fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
fed1c000-fed1ffff : reserved
  fed1f410-fed1f414 : iTCO_wdt.0.auto
fee00000-fee00fff : Local APIC
ffb00000-ffffffff : reserved
100000000-25f5fffff : System RAM
25f600000-25fffffff : RAM buffer


[7.5.] PCI information ('lspci -vvv' as root)

(from running 4.2)

00:00.0 Host bridge: Intel Corporation Haswell-ULT DRAM Controller (rev=
 09)
    Subsystem: Lenovo Haswell-ULT DRAM Controller
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort-
<MAbort+ >SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [e0] Vendor Specific Information: Len=3D0c <?>
    Kernel driver in use: hsw_uncore

00:02.0 VGA compatible controller: Intel Corporation Haswell-ULT Integr=
ated
Graphics Controller (rev 09) (prog-if 00 [VGA controller])
    Subsystem: Lenovo Haswell-ULT Integrated Graphics Controller
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort-
<MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 47
    Region 0: Memory at b5000000 (64-bit, non-prefetchable) [size=3D4M]
    Region 2: Memory at c0000000 (64-bit, prefetchable) [size=3D256M]
    Region 4: I/O ports at 6000 [size=3D64]
    Expansion ROM at <unassigned> [disabled]
    Capabilities: [90] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
        Address: fee0200c  Data: 41b1
    Capabilities: [d0] Power Management version 2
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
    Capabilities: [a4] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: i915
    Kernel modules: i915

00:03.0 Audio device: Intel Corporation Haswell-ULT HD Audio Controller=
 (rev
09)
    Subsystem: Lenovo Haswell-ULT HD Audio Controller
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort-
<MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 50
    Region 0: Memory at b5610000 (64-bit, non-prefetchable) [size=3D16K=
]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
    Capabilities: [60] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
        Address: fee0e00c  Data: 41e1
    Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, M=
SI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0
            ExtTag- RBE-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupp=
orted-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- Tra=
nsPend-
    Kernel driver in use: snd_hda_intel
    Kernel modules: snd_hda_intel

00:14.0 USB controller: Intel Corporation 8 Series USB xHCI HC (rev 04)
(prog-if 30 [XHCI])
    Subsystem: Lenovo 8 Series USB xHCI HC
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort-
<MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 43
    Region 0: Memory at b5600000 (64-bit, non-prefetchable) [size=3D64K=
]
    Capabilities: [70] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
    Capabilities: [80] MSI: Enable+ Count=3D1/8 Maskable- 64bit+
        Address: 00000000fee0c00c  Data: 4171
    Kernel driver in use: xhci_hcd

00:16.0 Communication controller: Intel Corporation 8 Series HECI #0 (r=
ev 04)
    Subsystem: Lenovo 8 Series HECI
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort-
<MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 48
    Region 0: Memory at b561b000 (64-bit, non-prefetchable) [size=3D32]
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
    Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
        Address: 00000000fee0f00c  Data: 41c1
    Kernel driver in use: mei_me
    Kernel modules: mei_me

00:1b.0 Audio device: Intel Corporation 8 Series HD Audio Controller (r=
ev 04)
    Subsystem: Lenovo 8 Series HD Audio Controller
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort-
<MAbort- >SERR- <PERR- INTx-
    Latency: 32, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 49
    Region 0: Memory at b5614000 (64-bit, non-prefetchable) [size=3D16K=
]
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
    Capabilities: [60] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
        Address: 00000000fee0e00c  Data: 41d1
    Kernel driver in use: snd_hda_intel
    Kernel modules: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 8 Series PCI Express Root Port 3 =
(rev e4)
(prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort-
<MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin C routed to IRQ 40
    Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D=
0
    I/O behind bridge: 00005000-00005fff
    Memory behind bridge: b5500000-b55fffff
    Prefetchable memory behind bridge: 00000000b5400000-00000000b54ffff=
f
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort-
<MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0
            ExtTag- RBE+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupp=
orted-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ Tra=
nsPend-
        LnkCap:    Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, Exit La=
tency
L0s <512ns, L1 <16us
            ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLAc=
tive+
BWMgmt+ ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Sur=
prise-
            Slot #2, PowerLimit 10.000W; Interlock- NoCompl+
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIr=
q-
LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ In=
terlock-
            Changed: MRL- PresDet- LinkState+
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRS=
Visible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR+, OBFF=
 Not
Supported ARIFwd-
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, O=
BFF
Disabled ARIFwd-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range, EnterModifiedComp=
liance-
ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplet=
e-,
EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualization=
Request-
    Capabilities: [80] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
        Address: fee0f00c  Data: 4141
    Capabilities: [90] Subsystem: Lenovo 8 Series PCI Express Root Port=
 3
    Capabilities: [a0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
    Kernel driver in use: pcieport
    Kernel modules: shpchp

00:1c.3 PCI bridge: Intel Corporation 8 Series PCI Express Root Port 4 =
(rev e4)
(prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort-
<MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin D routed to IRQ 41
    Bus: primary=3D00, secondary=3D02, subordinate=3D07, sec-latency=3D=
0
    I/O behind bridge: 00004000-00004fff
    Memory behind bridge: b4000000-b4ffffff
    Prefetchable memory behind bridge: 00000000b2000000-00000000b2fffff=
f
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort-
<MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0
            ExtTag- RBE+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupp=
orted-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ Tra=
nsPend-
        LnkCap:    Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Exit La=
tency
L0s <512ns, L1 <16us
            ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLAc=
tive+
BWMgmt+ ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Sur=
prise+
            Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIr=
q+
LinkChg+
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ In=
terlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRS=
Visible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR+, OBFF=
 Not
Supported ARIFwd-
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, O=
BFF
Disabled ARIFwd-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range, EnterModifiedComp=
liance-
ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplet=
e-,
EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualization=
Request-
    Capabilities: [80] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
        Address: fee0f00c  Data: 4151
    Capabilities: [90] Subsystem: Lenovo 8 Series PCI Express Root Port=
 4
    Capabilities: [a0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
    Kernel driver in use: pcieport
    Kernel modules: shpchp

00:1c.4 PCI bridge: Intel Corporation 8 Series PCI Express Root Port 5 =
(rev e4)
(prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort-
<MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 42
    Bus: primary=3D00, secondary=3D08, subordinate=3D08, sec-latency=3D=
0
    I/O behind bridge: 00003000-00003fff
    Memory behind bridge: b3000000-b3ffffff
    Prefetchable memory behind bridge: 00000000a0000000-00000000b1fffff=
f
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort-
<MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0
            ExtTag- RBE+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupp=
orted-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ Tra=
nsPend-
        LnkCap:    Port #5, Speed 5GT/s, Width x4, ASPM L0s L1, Exit La=
tency
L0s <512ns, L1 <16us
            ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp-
        LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 5GT/s, Width x4, TrErr- Train- SlotClk+ DLActi=
ve+
BWMgmt+ ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Sur=
prise-
            Slot #4, PowerLimit 25.000W; Interlock- NoCompl+
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIr=
q-
LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ In=
terlock-
            Changed: MRL- PresDet- LinkState+
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRS=
Visible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR+, OBFF=
 Not
Supported ARIFwd-
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, O=
BFF
Disabled ARIFwd-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range, EnterModifiedComp=
liance-
ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-=
,
EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualization=
Request-
    Capabilities: [80] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
        Address: fee0f00c  Data: 4161
    Capabilities: [90] Subsystem: Lenovo 8 Series PCI Express Root Port=
 5
    Capabilities: [a0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
    Kernel driver in use: pcieport
    Kernel modules: shpchp

00:1d.0 USB controller: Intel Corporation 8 Series USB EHCI #1 (rev 04)
(prog-if 20 [EHCI])
    Subsystem: Lenovo 8 Series USB EHCI
    Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort-
<MAbort- >SERR- <PERR- INTx-
    Interrupt: pin A routed to IRQ 0
    Region 0: Memory at b5619000 (32-bit, non-prefetchable) [size=3D1K]
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
    Capabilities: [58] Debug port: BAR=3D1 offset=3D00a0
    Capabilities: [98] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-

00:1f.0 ISA bridge: Intel Corporation 8 Series LPC Controller (rev 04)
    Subsystem: Lenovo 8 Series LPC Controller
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort-
<MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [e0] Vendor Specific Information: Len=3D0c <?>
    Kernel driver in use: lpc_ich
    Kernel modules: lpc_ich

00:1f.2 SATA controller: Intel Corporation 8 Series SATA Controller 1 [=
AHCI
mode] (rev 04) (prog-if 01 [AHCI 1.0])
    Subsystem: Lenovo 8 Series SATA Controller 1 [AHCI mode]
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort-
<MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 44
    Region 0: I/O ports at 6088 [size=3D8]
    Region 1: I/O ports at 6094 [size=3D4]
    Region 2: I/O ports at 6080 [size=3D8]
    Region 3: I/O ports at 6090 [size=3D4]
    Region 4: I/O ports at 6060 [size=3D32]
    Region 5: Memory at b5618000 (32-bit, non-prefetchable) [size=3D2K]
    Capabilities: [80] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
        Address: fee0400c  Data: 4181
    Capabilities: [70] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
    Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=3D00000004
    Kernel driver in use: ahci
    Kernel modules: ahci

00:1f.3 SMBus: Intel Corporation 8 Series SMBus Controller (rev 04)
    Subsystem: Lenovo 8 Series SMBus Controller
    Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort-
<MAbort- >SERR- <PERR- INTx-
    Interrupt: pin C routed to IRQ 0
    Region 0: Memory at b561a000 (64-bit, non-prefetchable) [size=3D256=
]
    Region 4: I/O ports at 6040 [size=3D32]
    Kernel modules: i2c_i801

01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/81=
68/8411
PCI Express Gigabit Ethernet Controller (rev 0c)
    Subsystem: Lenovo RTL8111/8168/8411 PCI Express Gigabit Ethernet Co=
ntroller
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort-
<MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 46
    Region 0: I/O ports at 5000 [size=3D256]
    Region 2: Memory at b5500000 (64-bit, non-prefetchable) [size=3D4K]
    Region 4: Memory at b5400000 (64-bit, prefetchable) [size=3D16K]
    Capabilities: [40] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
    Capabilities: [50] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
        Address: 00000000fee0f00c  Data: 41a1
    Capabilities: [70] Express (v2) Endpoint, MSI 01
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512n=
s, L1
<64us
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupp=
orted-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 4096 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ Tra=
nsPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit =
Latency
L0s unlimited, L1 <64us
            ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLAc=
tive-
BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR+, OBF=
=46 Via
message/WAKE#
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, O=
BFF
Disabled
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range, EnterModifiedComp=
liance-
ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-=
,
EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualization=
Request-
    Capabilities: [b0] MSI-X: Enable- Count=3D4 Masked-
        Vector table: BAR=3D4 offset=3D00000000
        PBA: BAR=3D4 offset=3D00000800
    Capabilities: [d0] Vital Product Data
        Unknown small resource type 00, will not decode more.
    Kernel driver in use: r8169
    Kernel modules: r8169

02:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS522=
9 PCI
Express Card Reader (rev 01)
    Subsystem: Lenovo RTS5229 PCI Express Card Reader
    Physical Slot: 3
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort-
<MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 45
    Region 0: Memory at b4000000 (32-bit, non-prefetchable) [size=3D4K]
    Capabilities: [40] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA
PME(D0-,D1+,D2+,D3hot+,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
    Capabilities: [50] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
        Address: 00000000fee0f00c  Data: 4191
    Capabilities: [70] Express (v2) Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlim=
ited, L1
unlimited
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupp=
orted-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- Tra=
nsPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit =
Latency
L0s unlimited, L1 <64us
            ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLAc=
tive-
BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, =
OBFF Not
Supported
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, O=
BFF
Disabled
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range, EnterModifiedComp=
liance-
ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-=
,
EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualization=
Request-
    Kernel driver in use: rtsx_pci
    Kernel modules: rtsx_pci

08:00.0 3D controller: NVIDIA Corporation GM107M [GeForce GTX 850M] (re=
v a2)
    Subsystem: Lenovo GeForce GTX 850A
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort-
<MAbort- >SERR- <PERR- INTx-
    Interrupt: pin A routed to IRQ 0
    Region 0: Memory at b3000000 (32-bit, non-prefetchable) [disabled]
[size=3D16M]
    Region 1: Memory at a0000000 (64-bit, prefetchable) [disabled] [siz=
e=3D256M]
    Region 3: Memory at b0000000 (64-bit, prefetchable) [disabled] [siz=
e=3D32M]
    Region 5: I/O ports at 3000 [disabled] [size=3D128]
    Expansion ROM at <ignored> [disabled]
    Capabilities: [60] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
    Capabilities: [68] MSI: Enable- Count=3D1/1 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Capabilities: [78] Express (v2) Endpoint, MSI 00
        DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s unlim=
ited, L1
<64us
            ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupp=
orted-
            RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- Tra=
nsPend-
        LnkCap:    Port #0, Speed 8GT/s, Width x16, ASPM L0s L1, Exit L=
atency
L0s <512ns, L1 <4us
            ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
        LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 5GT/s, Width x4, TrErr- Train- SlotClk+ DLActi=
ve-
BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Range AB, TimeoutDis+, LTR+, OBFF =
Via
message
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, O=
BFF
Disabled
        LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range, EnterModifiedComp=
liance-
ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-=
,
EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualization=
Request-
    Kernel modules: nvidiafb, nouveau



[7.6.] SCSI information (from /proc/scsi/scsi)

(from running 4.2)

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST1000LM014-1EJ1 Rev: LIV6
  Type:   Direct-Access                    ANSI  SCSI revision: 05

[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):

Might not be relevant, but: The system also does not power off (nor
restart) on shutdown, I need to physically press the power key, and it
never has done with any of the kernels I've tried. It does restart with
ctrl+alt+delete from grub though. Reported at
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1463422

Lenovo's site has a BIOS update for Broadwell systems, but there is
nothing listed for Haswell.

[X.] Other notes, patches, fixes, workarounds:

I unfortunately know of no workarounds other than sticking with 4.2.


Please let me know if there's any more information I should upload.

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
