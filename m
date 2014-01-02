From: Ritesh Khadgaray <khadgaray@gmail.com>
Subject: ext4 goes into read only mode on using discard with
 htree_dirblock_to_tree ... bad entry in directory
Date: Thu, 02 Jan 2014 10:53:00 +0530
Message-ID: <1388640180.7804.1.camel@K43SA.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:65248 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaABFXI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Jan 2014 00:23:08 -0500
Received: by mail-pa0-f45.google.com with SMTP id fb1so14114556pad.18
        for <linux-ext4@vger.kernel.org>; Wed, 01 Jan 2014 21:23:07 -0800 (PST)
Received: from [192.168.1.8] ([117.218.242.123])
        by mx.google.com with ESMTPSA id xv2sm98706367pbb.39.2014.01.01.21.23.03
        for <linux-ext4@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Wed, 01 Jan 2014 21:23:06 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

summary :

fs goes into read-only mode while building LibreOffice.

description:
ext4 goes into read-only mode, when building libreoffice or doing a
large amount of IO (rsync of over ~250gb ) with discard option enabled.
Worst case, partition table corruption.  

from dmesg
[11822.935891] EXT4-fs error (device dm-1): htree_dirblock_to_tree:920:
inode #53629599: block 214443464: comm rm: bad entry in directory:
rec_len % 4 != 0 - offset=0(0), inode=1667681412, rec_len=45654,
name_len=39
[11822.935896] Aborting journal on device dm-1-8.
[11822.935998] EXT4-fs (dm-1): Remounting filesystem read-only

$ uname -a
Linux K43SA.local 3.13.0-999-generic #201312200414 SMP Fri Dec 20
09:16:44 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux


WORKAROUND: Disable discard option - /dev/mapper/volumegroup-root / ext4
discard,noatime,nodiratime,errors=remount-ro 0 1


Environment:
$ lsb_release  -rd
Description: Ubuntu Trusty Tahr (development branch)
Release: 14.04

$  /usr/src/linux-headers-3.13.0-999-generic/scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux K43SA.local 3.13.0-999-generic #201312200414 SMP Fri Dec 20
09:16:44 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
 
Gnu C                  4.8
Gnu make               3.81
binutils               2.24
util-linux             2.20.1
mount                  support
module-init-tools      15
e2fsprogs              1.42.8
jfsutils               1.1.15
reiserfsprogs          3.6.24
xfsprogs               3.1.9
pcmciautils            018
PPP                    2.4.5
Linux C Library        2.18
Dynamic linker (ldd)   2.18
Procps                 3.3.8
Net-tools              1.60
Kbd                    1.15.5
Sh-utils               8.21
wireless-tools         30
Modules Loaded         ctr ccm ipt_MASQUERADE iptable_nat nf_nat_ipv4
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack
ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp bridge stp llc
ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables
x_tables joydev parport_pc ppdev x86_pkg_temp_thermal intel_powerclamp
coretemp kvm_intel arc4 snd_hda_codec_hdmi kvm bnep
snd_hda_codec_realtek rfcomm asus_nb_wmi asus_wmi sparse_keymap
snd_hda_intel snd_hda_codec ath9k uvcvideo ath9k_common snd_hwdep
ath9k_hw videobuf2_vmalloc snd_pcm videobuf2_memops rts5139
videobuf2_core snd_page_alloc ath videodev mac80211 snd_seq_midi
snd_seq_midi_event dm_multipath snd_rawmidi scsi_dh snd_seq cfg80211
ath3k btusb snd_seq_device bluetooth snd_timer psmouse microcode snd
serio_raw soundcore mei_me mei lpc_ich mac_hid lp parport nls_iso8859_1
btrfs xor raid6_pq libcrc32c xts gf128mul dm_crypt radeon i2c_algo_bit
crct10dif_pclmul ttm crc32_pclmul ghash_clmulni_intel drm_kms_helper
cryptd drm ahci r8169 libahci mii wmi video

$ cat /proc/cpuinfo
processor : 0
vendor_id : GenuineIntel
cpu family : 6
model : 42
model name : Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
stepping : 7
microcode : 0x1a
cpu MHz : 2861.375
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 0
cpu cores : 4
apicid : 0
initial apicid : 0
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer xsave avx lahf_lm ida arat epb xsaveopt pln pts
dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips : 4389.99
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 1
vendor_id : GenuineIntel
cpu family : 6
model : 42
model name : Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
stepping : 7
microcode : 0x1a
cpu MHz : 2986.929
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 1
cpu cores : 4
apicid : 2
initial apicid : 2
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer xsave avx lahf_lm ida arat epb xsaveopt pln pts
dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips : 4389.99
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 2
vendor_id : GenuineIntel
cpu family : 6
model : 42
model name : Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
stepping : 7
microcode : 0x1a
cpu MHz : 2817.804
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 2
cpu cores : 4
apicid : 4
initial apicid : 4
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer xsave avx lahf_lm ida arat epb xsaveopt pln pts
dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips : 4389.99
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 3
vendor_id : GenuineIntel
cpu family : 6
model : 42
model name : Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
stepping : 7
microcode : 0x1a
cpu MHz : 2808.695
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 3
cpu cores : 4
apicid : 6
initial apicid : 6
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer xsave avx lahf_lm ida arat epb xsaveopt pln pts
dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips : 4389.99
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 4
vendor_id : GenuineIntel
cpu family : 6
model : 42
model name : Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
stepping : 7
microcode : 0x1a
cpu MHz : 1314.843
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 0
cpu cores : 4
apicid : 1
initial apicid : 1
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer xsave avx lahf_lm ida arat epb xsaveopt pln pts
dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips : 4389.99
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 5
vendor_id : GenuineIntel
cpu family : 6
model : 42
model name : Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
stepping : 7
microcode : 0x1a
cpu MHz : 2806.890
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 1
cpu cores : 4
apicid : 3
initial apicid : 3
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer xsave avx lahf_lm ida arat epb xsaveopt pln pts
dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips : 4389.99
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 6
vendor_id : GenuineIntel
cpu family : 6
model : 42
model name : Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
stepping : 7
microcode : 0x1a
cpu MHz : 2897.039
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 2
cpu cores : 4
apicid : 5
initial apicid : 5
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer xsave avx lahf_lm ida arat epb xsaveopt pln pts
dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips : 4389.99
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 7
vendor_id : GenuineIntel
cpu family : 6
model : 42
model name : Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
stepping : 7
microcode : 0x1a
cpu MHz : 2871.687
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 3
cpu cores : 4
apicid : 7
initial apicid : 7
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer xsave avx lahf_lm ida arat epb xsaveopt pln pts
dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips : 4389.99
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

$ cat /proc/modules
ctr 13193 1 - Live 0x0000000000000000
ccm 17856 1 - Live 0x0000000000000000
ipt_MASQUERADE 12880 3 - Live 0x0000000000000000
iptable_nat 13151 1 - Live 0x0000000000000000
nf_nat_ipv4 13316 1 iptable_nat, Live 0x0000000000000000
nf_nat 21952 3 ipt_MASQUERADE,iptable_nat,nf_nat_ipv4, Live
0x0000000000000000
nf_conntrack_ipv4 15063 2 - Live 0x0000000000000000
nf_defrag_ipv4 12758 1 nf_conntrack_ipv4, Live 0x0000000000000000
xt_conntrack 12760 1 - Live 0x0000000000000000
nf_conntrack 97542 6
ipt_MASQUERADE,iptable_nat,nf_nat_ipv4,nf_nat,nf_conntrack_ipv4,xt_conntrack, Live 0x0000000000000000
ipt_REJECT 12576 2 - Live 0x0000000000000000
xt_CHECKSUM 12549 1 - Live 0x0000000000000000
iptable_mangle 12734 1 - Live 0x0000000000000000
xt_tcpudp 12924 5 - Live 0x0000000000000000
bridge 116160 0 - Live 0x0000000000000000
stp 12976 1 bridge, Live 0x0000000000000000
llc 14597 2 bridge,stp, Live 0x0000000000000000
ip6table_filter 12815 0 - Live 0x0000000000000000
ip6_tables 27502 1 ip6table_filter, Live 0x0000000000000000
iptable_filter 12810 1 - Live 0x0000000000000000
ip_tables 27716 3 iptable_nat,iptable_mangle,iptable_filter, Live
0x0000000000000000
ebtable_nat 12807 0 - Live 0x0000000000000000
ebtables 31209 1 ebtable_nat, Live 0x0000000000000000
x_tables 34194 11
ipt_MASQUERADE,xt_conntrack,ipt_REJECT,xt_CHECKSUM,iptable_mangle,xt_tcpudp,ip6table_filter,ip6_tables,iptable_filter,ip_tables,ebtables, Live 0x0000000000000000
joydev 17575 0 - Live 0x0000000000000000
parport_pc 36962 0 - Live 0x0000000000000000
ppdev 17711 0 - Live 0x0000000000000000
x86_pkg_temp_thermal 14269 0 - Live 0x0000000000000000
intel_powerclamp 19031 0 - Live 0x0000000000000000
coretemp 17728 0 - Live 0x0000000000000000
kvm_intel 144426 0 - Live 0x0000000000000000
arc4 12573 2 - Live 0x0000000000000000
snd_hda_codec_hdmi 46898 1 - Live 0x0000000000000000
kvm 468147 1 kvm_intel, Live 0x0000000000000000
bnep 19884 2 - Live 0x0000000000000000
snd_hda_codec_realtek 61978 1 - Live 0x0000000000000000
rfcomm 74748 12 - Live 0x0000000000000000
asus_nb_wmi 16990 0 - Live 0x0000000000000000
asus_wmi 24794 1 asus_nb_wmi, Live 0x0000000000000000
sparse_keymap 13890 1 asus_wmi, Live 0x0000000000000000
snd_hda_intel 57222 5 - Live 0x0000000000000000
snd_hda_codec 199156 3
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel, Live
0x0000000000000000
ath9k 166504 0 - Live 0x0000000000000000
uvcvideo 82247 0 - Live 0x0000000000000000
ath9k_common 13551 1 ath9k, Live 0x0000000000000000
snd_hwdep 13613 1 snd_hda_codec, Live 0x0000000000000000
ath9k_hw 462940 2 ath9k,ath9k_common, Live 0x0000000000000000
videobuf2_vmalloc 13216 1 uvcvideo, Live 0x0000000000000000
snd_pcm 107140 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live
0x0000000000000000
videobuf2_memops 13362 1 videobuf2_vmalloc, Live 0x0000000000000000
rts5139 318332 0 - Live 0x0000000000000000 (C)
videobuf2_core 40972 1 uvcvideo, Live 0x0000000000000000
snd_page_alloc 18798 2 snd_hda_intel,snd_pcm, Live 0x0000000000000000
ath 29145 3 ath9k,ath9k_common,ath9k_hw, Live 0x0000000000000000
videodev 139761 2 uvcvideo,videobuf2_core, Live 0x0000000000000000
mac80211 654078 1 ath9k, Live 0x0000000000000000
snd_seq_midi 13324 0 - Live 0x0000000000000000
snd_seq_midi_event 14899 1 snd_seq_midi, Live 0x0000000000000000
dm_multipath 27401 0 - Live 0x0000000000000000
snd_rawmidi 30465 1 snd_seq_midi, Live 0x0000000000000000
scsi_dh 14873 1 dm_multipath, Live 0x0000000000000000
snd_seq 66061 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
cfg80211 509407 3 ath9k,ath,mac80211, Live 0x0000000000000000
ath3k 13368 0 - Live 0x0000000000000000
btusb 28326 0 - Live 0x0000000000000000
snd_seq_device 14497 3 snd_seq_midi,snd_rawmidi,snd_seq, Live
0x0000000000000000
bluetooth 411140 23 bnep,rfcomm,ath3k,btusb, Live 0x0000000000000000
snd_timer 30038 2 snd_pcm,snd_seq, Live 0x0000000000000000
psmouse 108513 0 - Live 0x0000000000000000
microcode 23788 0 - Live 0x0000000000000000
snd 73850 21
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq_midi,snd_rawmidi,snd_seq,snd_seq_device,snd_timer, Live 0x0000000000000000
serio_raw 13462 0 - Live 0x0000000000000000
soundcore 12680 1 snd, Live 0x0000000000000000
mei_me 18578 0 - Live 0x0000000000000000
mei 82671 1 mei_me, Live 0x0000000000000000
lpc_ich 21163 0 - Live 0x0000000000000000
mac_hid 13253 0 - Live 0x0000000000000000
lp 17799 0 - Live 0x0000000000000000
parport 42481 3 parport_pc,ppdev,lp, Live 0x0000000000000000
nls_iso8859_1 12713 1 - Live 0x0000000000000000
btrfs 867780 0 - Live 0x0000000000000000
xor 21411 1 btrfs, Live 0x0000000000000000
raid6_pq 97812 1 btrfs, Live 0x0000000000000000
libcrc32c 12644 1 btrfs, Live 0x0000000000000000
xts 12951 1 - Live 0x0000000000000000
gf128mul 14951 1 xts, Live 0x0000000000000000
dm_crypt 23417 1 - Live 0x0000000000000000
radeon 1565590 3 - Live 0x0000000000000000
i2c_algo_bit 13564 1 radeon, Live 0x0000000000000000
crct10dif_pclmul 14250 0 - Live 0x0000000000000000
ttm 89884 1 radeon, Live 0x0000000000000000
crc32_pclmul 13160 0 - Live 0x0000000000000000
ghash_clmulni_intel 13259 0 - Live 0x0000000000000000
drm_kms_helper 53224 1 radeon, Live 0x0000000000000000
cryptd 20530 1 ghash_clmulni_intel, Live 0x0000000000000000
drm 308397 5 radeon,ttm,drm_kms_helper, Live 0x0000000000000000
ahci 30063 3 - Live 0x0000000000000000
r8169 73299 0 - Live 0x0000000000000000
libahci 32277 1 ahci, Live 0x0000000000000000
mii 13981 1 r8169, Live 0x0000000000000000
wmi 19363 1 asus_wmi, Live 0x0000000000000000
video 19859 1 asus_wmi, Live 0x0000000000000000

$ cat /proc/ioports
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0062-0062 : EC data
  0064-0064 : keyboard
  0066-0066 : EC cmd
  0070-0077 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  0240-0259 : pnp 00:07
  0400-0403 : ACPI PM1a_EVT_BLK
  0404-0405 : ACPI PM1a_CNT_BLK
  0408-040b : ACPI PM_TMR
  0410-0415 : ACPI CPU throttle
  0420-042f : ACPI GPE0_BLK
  0430-0433 : iTCO_wdt
  0450-0450 : ACPI PM2_CNT_BLK
  0454-0457 : pnp 00:06
  0458-047f : pnp 00:04
    0460-047f : iTCO_wdt
  0500-057f : pnp 00:04
  0680-069f : pnp 00:04
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1000-100f : pnp 00:04
  164e-164f : pnp 00:04
  9000-9fff : PCI Bus 0000:05
    9000-90ff : 0000:05:00.0
      9000-90ff : r8169
  a000-afff : PCI Bus 0000:04
  b000-bfff : PCI Bus 0000:03
  c000-cfff : PCI Bus 0000:02
  d000-dfff : PCI Bus 0000:01
    d000-d0ff : 0000:01:00.0
  e000-e01f : 0000:00:1f.3
  e020-e03f : 0000:00:1f.2
    e020-e03f : ahci
  e040-e043 : 0000:00:1f.2
    e040-e043 : ahci
  e050-e057 : 0000:00:1f.2
    e050-e057 : ahci
  e060-e063 : 0000:00:1f.2
    e060-e063 : ahci
  e070-e077 : 0000:00:1f.2
    e070-e077 : ahci
  ffff-ffff : pnp 00:04
    ffff-ffff : pnp 00:04

$ cat /proc/iomem
00000000-00000fff : reserved
00001000-0009ffff : System RAM
000a0000-000fffff : reserved
  000a0000-000bffff : PCI Bus 0000:00
  000c0000-000cf1ff : Video ROM
  000d0000-000d3fff : PCI Bus 0000:00
  000d4000-000d7fff : PCI Bus 0000:00
  000d8000-000dbfff : PCI Bus 0000:00
  000dc000-000dffff : PCI Bus 0000:00
  000f0000-000fffff : System ROM
00100000-2004ffff : System RAM
  04000000-04771bdd : Kernel code
  04771bde-04d1beff : Kernel data
  04e78000-04fdcfff : Kernel bss
20050000-2024ffff : reserved
20250000-3fffffff : System RAM
40000000-401fffff : reserved
40200000-bf40bfff : System RAM
bf40c000-bf58dfff : reserved
bf58e000-bf593fff : System RAM
bf594000-bf594fff : reserved
bf595000-bf595fff : System RAM
bf596000-bf5b7fff : reserved
bf5b8000-bf5c5fff : System RAM
bf5c6000-bf5e7fff : reserved
bf5e8000-bf736fff : System RAM
bf737000-bf7e7fff : ACPI Non-volatile Storage
bf7e8000-bf7fcfff : System RAM
bf7fd000-bf7fffff : ACPI Tables
bf800000-bfffffff : reserved
c0000000-feafffff : PCI Bus 0000:00
  c0000000-cfffffff : PCI Bus 0000:01
    c0000000-cfffffff : 0000:01:00.0
  d0100000-d0afffff : PCI Bus 0000:05
    d0100000-d0103fff : 0000:05:00.0
      d0100000-d0103fff : r8169
    d0104000-d0104fff : 0000:05:00.0
      d0104000-d0104fff : r8169
  d0c00000-d15fffff : PCI Bus 0000:04
  d1700000-d20fffff : PCI Bus 0000:03
  d2200000-d2bfffff : PCI Bus 0000:02
  d2c00000-d2c00fff : pnp 00:0b
  dd600000-ddffffff : PCI Bus 0000:05
  de000000-de9fffff : PCI Bus 0000:04
    de000000-de007fff : 0000:04:00.0
      de000000-de007fff : xhci_hcd
  dea00000-df3fffff : PCI Bus 0000:03
    dea00000-dea0ffff : 0000:03:00.0
      dea00000-dea0ffff : ath9k
  df400000-dfdfffff : PCI Bus 0000:02
  dfe00000-dfefffff : PCI Bus 0000:01
    dfe00000-dfe1ffff : 0000:01:00.0
    dfe20000-dfe3ffff : 0000:01:00.0
    dfe40000-dfe43fff : 0000:01:00.1
      dfe40000-dfe43fff : ICH HD audio
  dff00000-dff03fff : 0000:00:1b.0
    dff00000-dff03fff : ICH HD audio
  dff05000-dff050ff : 0000:00:1f.3
  dff06000-dff067ff : 0000:00:1f.2
    dff06000-dff067ff : ahci
  dff07000-dff073ff : 0000:00:1d.0
    dff07000-dff073ff : ehci_hcd
  dff08000-dff083ff : 0000:00:1a.0
    dff08000-dff083ff : ehci_hcd
  dff0b000-dff0b00f : 0000:00:16.0
    dff0b000-dff0b00f : mei_me
  e0000000-e3ffffff : PCI MMCONFIG 0000 [bus 00-3f]
    e0000000-e3ffffff : reserved
      e0000000-e3ffffff : pnp 00:0a
fec00000-fec00fff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
fed10000-fed13fff : reserved
fed18000-fed19fff : reserved
  fed18000-fed18fff : pnp 00:0a
  fed19000-fed19fff : pnp 00:0a
fed1c000-fed1ffff : reserved
  fed1c000-fed1ffff : pnp 00:0a
    fed1f410-fed1f414 : iTCO_wdt
fed20000-fed3ffff : pnp 00:0a
fed40000-fed44fff : PCI Bus 0000:00
fed45000-fed8ffff : pnp 00:0a
fed90000-fed93fff : pnp 00:0a
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ff980000-ffbfffff : reserved
ffd80000-ffffffff : reserved
100000000-23f7fffff : System RAM
23f800000-23fffffff : RAM buffer

$ sudo lspci -vvv
[sudo] password for ritesh:
00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor
Family DRAM Controller (rev 09)
Subsystem: ASUSTeK Computer Inc. Device 1337
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort+ >SERR- <PERR- INTx-
Latency: 0
Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core
Processor Family PCI Express Root Port (rev 09) (prog-if 00 [Normal
decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
I/O behind bridge: 0000d000-0000dfff
Memory behind bridge: dfe00000-dfefffff
Prefetchable memory behind bridge: 00000000c0000000-00000000cfffffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [88] Subsystem: ASUSTeK Computer Inc. Device 1337
Capabilities: [80] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold
+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee00000  Data: 4071
Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #2, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <256ns,
L1 <4us
ClockPM- Surprise- LLActRep- BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt+
ABWMgmt+
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet+ LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [100 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
Status: NegoPending- InProgress-
Capabilities: [140 v1] Root Complex Link
Desc: PortNumber=02 ComponentID=01 EltType=Config
Link0: Desc: TargetPort=00 TargetComponent=01 AssocRCRB-
LinkType=MemMapped LinkValid+
Addr: 00000000fed19000
Kernel driver in use: pcieport

00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series
Chipset Family MEI Controller #1 (rev 04)
Subsystem: ASUSTeK Computer Inc. Device 1337
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 56
Region 0: Memory at dff0b000 (64-bit, non-prefetchable) [size=16]
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold
+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee00000  Data: 40c2
Kernel driver in use: mei_me

00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset
Family USB Enhanced Host Controller #2 (rev 05) (prog-if 20 [EHCI])
Subsystem: ASUSTeK Computer Inc. Device 1337
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 16
Region 0: Memory at dff08000 (32-bit, non-prefetchable) [size=1K]
Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot
+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Debug port: BAR=1 offset=00a0
Capabilities: [98] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: ehci-pci

00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset
Family High Definition Audio Controller (rev 05)
Subsystem: ASUSTeK Computer Inc. Device 1b63
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 57
Region 0: Memory at dff00000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot
+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee00000  Data: 40e2
Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE- FLReset+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
Capabilities: [100 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
Status: NegoPending- InProgress-
VC1: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=1 ArbSelect=Fixed TC/VC=22
Status: NegoPending- InProgress-
Capabilities: [130 v1] Root Complex Link
Desc: PortNumber=0f ComponentID=00 EltType=Config
Link0: Desc: TargetPort=00 TargetComponent=00 AssocRCRB-
LinkType=MemMapped LinkValid+
Addr: 00000000fed1c000
Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 1 (rev b5) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
I/O behind bridge: 0000c000-0000cfff
Memory behind bridge: df400000-dfdfffff
Prefetchable memory behind bridge: 00000000d2200000-00000000d2bfffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1
<16us
ClockPM- Surprise- LLActRep+ BwNot-
LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee00000  Data: 4081
Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 1337
Capabilities: [a0] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold
+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 2 (rev b5) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
I/O behind bridge: 0000b000-0000bfff
Memory behind bridge: dea00000-df3fffff
Prefetchable memory behind bridge: 00000000d1700000-00000000d20fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #2, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns,
L1 <16us
ClockPM- Surprise- LLActRep+ BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt
+ ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #1, PowerLimit 10.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet- LinkState+
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee00000  Data: 40a1
Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 1337
Capabilities: [a0] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold
+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 4 (rev b5) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
I/O behind bridge: 0000a000-0000afff
Memory behind bridge: de000000-de9fffff
Prefetchable memory behind bridge: 00000000d0c00000-00000000d15fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns,
L1 <16us
ClockPM- Surprise- LLActRep+ BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+
ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq+ LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee00000  Data: 40b1
Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 1337
Capabilities: [a0] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold
+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: pcieport

00:1c.5 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 6 (rev b5) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
I/O behind bridge: 00009000-00009fff
Memory behind bridge: dd600000-ddffffff
Prefetchable memory behind bridge: 00000000d0100000-00000000d0afffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #6, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns,
L1 <16us
ClockPM- Surprise- LLActRep+ BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt
+ ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #5, PowerLimit 10.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet- LinkState+
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee00000  Data: 40c1
Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 1337
Capabilities: [a0] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold
+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset
Family USB Enhanced Host Controller #1 (rev 05) (prog-if 20 [EHCI])
Subsystem: ASUSTeK Computer Inc. Device 1337
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 23
Region 0: Memory at dff07000 (32-bit, non-prefetchable) [size=1K]
Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot
+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Debug port: BAR=1 offset=00a0
Capabilities: [98] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: ehci-pci

00:1f.0 ISA bridge: Intel Corporation HM65 Express Chipset Family LPC
Controller (rev 05)
Subsystem: ASUSTeK Computer Inc. Device 1337
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Capabilities: [e0] Vendor Specific Information: Len=0c <?>
Kernel driver in use: lpc_ich

00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset
Family 6 port SATA AHCI Controller (rev 05) (prog-if 01 [AHCI 1.0])
Subsystem: ASUSTeK Computer Inc. Device 1337
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin B routed to IRQ 54
Region 0: I/O ports at e070 [size=8]
Region 1: I/O ports at e060 [size=4]
Region 2: I/O ports at e050 [size=8]
Region 3: I/O ports at e040 [size=4]
Region 4: I/O ports at e020 [size=32]
Region 5: Memory at dff06000 (32-bit, non-prefetchable) [size=2K]
Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee06000  Data: 40b3
Capabilities: [70] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot
+,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
Capabilities: [b0] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family
SMBus Controller (rev 05)
Subsystem: ASUSTeK Computer Inc. Device 1337
Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Interrupt: pin C routed to IRQ 5
Region 0: Memory at dff05000 (64-bit, non-prefetchable) [size=256]
Region 4: I/O ports at e000 [size=32]

01:00.0 VGA compatible controller: Advanced Micro Devices, Inc.
[AMD/ATI] Whistler [Radeon HD 6730M/6770M/7690M XT] (prog-if 00 [VGA
controller])
Subsystem: ASUSTeK Computer Inc. Radeon HD 6730M
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 55
Region 0: Memory at c0000000 (64-bit, prefetchable) [size=256M]
Region 2: Memory at dfe20000 (64-bit, non-prefetchable) [size=128K]
Region 4: I/O ports at d000 [size=256]
Expansion ROM at dfe00000 [disabled] [size=128K]
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1
unlimited
ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns,
L1 <1us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt-
ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee00000  Data: 40b2
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1
Len=010 <?>
Capabilities: [150 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP
+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap+ ChkEn-
Kernel driver in use: radeon

01:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI]
Turks/Whistler HDMI Audio [Radeon HD 6000 Series]
Subsystem: ASUSTeK Computer Inc. Device aa90
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin B routed to IRQ 58
Region 0: Memory at dfe40000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1
unlimited
ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns,
L1 <1us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt-
ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee00000  Data: 4023
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1
Len=010 <?>
Capabilities: [150 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP
+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap+ ChkEn-
Kernel driver in use: snd_hda_intel

03:00.0 Network controller: Qualcomm Atheros AR9285 Wireless Network
Adapter (PCI-Express) (rev 01)
Subsystem: AzureWave AW-NB037H 802.11bgn Wireless Half-size Mini PCIe
Card [AR9002WB-1NGCD]
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 17
Region 0: Memory at dea00000 (64-bit, non-prefetchable) [size=64K]
Capabilities: [40] Power Management version 3
Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA PME(D0+,D1+,D2-,D3hot
+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000  Data: 0000
Capabilities: [60] Express (v2) Legacy Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <64us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis+
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP
+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
Capabilities: [140 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
Status: NegoPending- InProgress-
Capabilities: [160 v1] Device Serial Number 00-15-17-ff-ff-24-14-12
Capabilities: [170 v1] Power Budgeting <?>
Kernel driver in use: ath9k

04:00.0 USB controller: ASMedia Technology Inc. ASM1042 SuperSpeed USB
Host Controller (prog-if 30 [XHCI])
Subsystem: ASUSTeK Computer Inc. Device 1059
Physical Slot: 3
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 19
Region 0: Memory at de000000 (64-bit, non-prefetchable) [size=32K]
Capabilities: [50] MSI: Enable- Count=1/8 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Capabilities: [68] MSI-X: Enable+ Count=8 Masked-
Vector table: BAR=0 offset=00002000
PBA: BAR=0 offset=00002080
Capabilities: [78] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0-,D1-,D2-,D3hot
+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [80] Express (v2) Legacy Endpoint, MSI 00
DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <64ns, L1 <2us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0
unlimited, L1 unlimited
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-
ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [100 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
Status: NegoPending- InProgress-
Kernel driver in use: xhci_hcd

05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
Subsystem: ASUSTeK Computer Inc. U6V/U31J laptop
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 53
Region 0: I/O ports at 9000 [size=256]
Region 2: Memory at d0104000 (64-bit, prefetchable) [size=4K]
Region 4: Memory at d0100000 (64-bit, prefetchable) [size=16K]
Capabilities: [40] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot
+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee00000  Data: 4092
Capabilities: [70] Express (v2) Endpoint, MSI 01
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 4096 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
unlimited, L1 <64us
ClockPM+ Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
Vector table: BAR=4 offset=00000000
PBA: BAR=4 offset=00000800
Capabilities: [d0] Vital Product Data
No end tag found
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP
+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
Capabilities: [140 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
Status: NegoPending- InProgress-
Capabilities: [160 v1] Device Serial Number 31-28-04-39-68-4c-e0-00
Kernel driver in use: r8169

$ cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Crucial_CT960M50 Rev: MU03
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: HL-DT-ST Model: BDDVDRW CT30F    Rev: YT04
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 00
  Vendor: Generic- Model: xD/SD/M.S.       Rev: 1.00
  Type:   Direct-Access                    ANSI  SCSI revision: 02

ls /proc/
1     1432  1918  2217  2665  3095  5     705   90
latency_stats
10    147   192   2227  2670  31    50    7056  92           loadavg
1047  1496  1927  2236  2675  3137  51    71    93           locks
1059  15    1930  2238  2681  3177  52    716   94           mdstat
1084  1500  1932  2240  2688  3183  53    72    95           meminfo
1092  1515  1934  2242  2693  32    54    729   96           misc
11    16    1936  2244  27    322   55    73    97           modules
110   1650  1947  2259  2700  3226  554   737   975          mounts
111   1669  1955  2263  2769  3256  560   738   98           mtrr
113   1682  1959  2292  2790  3261  566   74    acpi         net
114   1683  1968  2293  2796  33    567   75    asound
pagetypeinfo
1146  1691  197   2295  2798  332   57    76    buddyinfo    partitions
115   17    198   2298  28    333   58    77    bus          sched_debug
1154  1717  1981  2299  2810  34    59    78    cgroups      schedstat
116   1721  199   23    2834  3407  60    787   cmdline      scsi
1173  1723  1991  2303  2840  3486  61    79    consoles     self
1174  1725  1997  2365  2859  35    62    797   cpuinfo      slabinfo
1177  1731  2     2374  287   3553  627   8     crypto       softirqs
1192  1743  20    2379  288   36    63    80    devices      stat
12    1749  200   238   2885  37    64    81    diskstats    swaps
1204  1751  201   2385  2886  38    643   818   dma          sys
1216  1756  2013  2389  289   39    65    82    driver
sysrq-trigger
1235  1762  202   2390  29    40    66    825   execdomains  sysvipc
1256  1763  2020  2391  290   41    664   83    fb           timer_list
1282  1765  2022  2395  291   42    67    831   filesystems  timer_stats
13    1771  205   24    2975  43    679   84    fs           tty
1317  1779  2051  2401  3     44    68    849   interrupts   uptime
1320  1783  2056  2430  30    4469  6883  85    iomem        version
135   1786  2057  2434  302   4479  6886  86    ioports      vmallocinfo
1357  18    206   2494  303   45    69    87    irq          vmstat
136   1810  2078  2495  305   46    694   878   kallsyms     zoneinfo
14    1814  208   25    306   47    6962  88    kcore
1417  1817  209   2507  3081  48    7     882   key-users
1425  1823  21    26    3086  4802  70    89    kmsg
1430  1880  22    2650  3087  49    704   890   kpagecount
1431  19    2210  2659  3088  4909  7047  9     kpageflags

$ sudo smartctl -a /dev/sda
sudo: unable to open /var/lib/sudo/ritesh/4: No such file or directory
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.12.0-7-generic] (local
build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke,
www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model: Crucial_CT960M500SSD1
Serial Number: 1335094BE7CA
LU WWN Device Id: 5 00a075 1094be7ca
Firmware Version: MU03
User Capacity: 960,197,124,096 bytes [960 GB]
Sector Sizes: 512 bytes logical, 4096 bytes physical
Rotation Rate: Solid State Device
Device is: Not in smartctl database [for details use: -P showall]
ATA Version is: ACS-2, ATA8-ACS T13/1699-D revision 6
SATA Version is: SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is: Wed Dec 11 11:38:48 2013 IST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status: (0x80) Offline data collection activity
     was never started.
     Auto Offline Data Collection: Enabled.
Self-test execution status: ( 0) The previous self-test routine
completed
     without error or no self-test has ever
     been run.
Total time to complete Offline
data collection: ( 4470) seconds.
Offline data collection
capabilities: (0x7b) SMART execute Offline immediate.
     Auto Offline data collection on/off support.
     Suspend Offline collection upon new
     command.
     Offline surface scan supported.
     Self-test supported.
     Conveyance Self-test supported.
     Selective Self-test supported.
SMART capabilities: (0x0003) Saves SMART data before entering
     power-saving mode.
     Supports SMART auto save timer.
Error logging capability: (0x01) Error logging supported.
     General Purpose Logging supported.
Short self-test routine
recommended polling time: ( 2) minutes.
Extended self-test routine
recommended polling time: ( 74) minutes.
Conveyance self-test routine
recommended polling time: ( 3) minutes.
SCT capabilities: (0x0035) SCT Status supported.
     SCT Feature Control supported.
     SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME FLAG VALUE WORST THRESH TYPE UPDATED WHEN_FAILED
RAW_VALUE
  1 Raw_Read_Error_Rate 0x002f 100 100 000 Pre-fail Always - 21
  5 Reallocated_Sector_Ct 0x0033 100 100 000 Pre-fail Always - 0
  9 Power_On_Hours 0x0032 100 100 000 Old_age Always - 287
 12 Power_Cycle_Count 0x0032 100 100 000 Old_age Always - 32
171 Unknown_Attribute 0x0032 100 100 000 Old_age Always - 0
172 Unknown_Attribute 0x0032 100 100 000 Old_age Always - 0
173 Unknown_Attribute 0x0032 100 100 000 Old_age Always - 1
174 Unknown_Attribute 0x0032 100 100 000 Old_age Always - 13
180 Unused_Rsvd_Blk_Cnt_Tot 0x0033 000 000 000 Pre-fail Always - 16523
183 Runtime_Bad_Block 0x0032 100 100 000 Old_age Always - 0
184 End-to-End_Error 0x0032 100 100 000 Old_age Always - 0
187 Reported_Uncorrect 0x0032 100 100 000 Old_age Always - 0
194 Temperature_Celsius 0x0022 056 050 000 Old_age Always - 44 (Min/Max
22/50)
196 Reallocated_Event_Count 0x0032 100 100 000 Old_age Always - 16
197 Current_Pending_Sector 0x0032 100 100 000 Old_age Always - 0
198 Offline_Uncorrectable 0x0030 100 100 000 Old_age Offline - 0
199 UDMA_CRC_Error_Count 0x0032 100 100 000 Old_age Always - 0
202 Unknown_SSD_Attribute 0x0031 100 100 000 Pre-fail Offline - 0
206 Unknown_SSD_Attribute 0x000e 100 100 000 Old_age Always - 0
210 Unknown_Attribute 0x0032 100 100 000 Old_age Always - 4
246 Unknown_Attribute 0x0032 100 100 --- Old_age Always - 2001841864
247 Unknown_Attribute 0x0032 100 100 --- Old_age Always - 63823477
248 Unknown_Attribute 0x0032 100 100 --- Old_age Always - 84291328

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num Test_Description Status Remaining LifeTime(hours) LBA_of_first_error
# 1 Vendor (0xff) Completed without error 00% 279 -
# 2 Extended offline Completed without error 00% 273 -
# 3 Vendor (0xff) Completed without error 00% 90 -
# 4 Vendor (0xff) Completed without error 00% 5 -
# 5 Short offline Aborted by host 00% 2 -
# 6 Vendor (0xff) Completed without error 00% 2 -

SMART Selective self-test log data structure revision number 1
 SPAN MIN_LBA MAX_LBA CURRENT_TEST_STATUS
    1 0 0 Not_testing
    2 0 0 Not_testing
    3 0 0 Not_testing
    4 0 0 Not_testing
    5 0 0 Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute
delay.

[ritesh@x230t libreoffice-4.1.2~rc3]$ uname -a
Linux x230t 3.12.0-7-generic #15-Ubuntu SMP Sun Dec 8 23:39:27 UTC 2013
x86_64 x86_64 x86_64 GNU/Linux

$ mount
/dev/mapper/ubuntu--vg-root on / type ext4
(rw,noatime,errors=remount-ro,discard)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
none on /sys/fs/cgroup type tmpfs (rw)
none on /sys/fs/fuse/connections type fusectl (rw)
none on /sys/kernel/debug type debugfs (rw)
none on /sys/kernel/security type securityfs (rw)
none on /sys/firmware/efi/efivars type efivarfs (rw)
udev on /dev type devtmpfs (rw,mode=0755)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=0620)
tmpfs on /tmp type tmpfs (rw,noatime,mode=1777)
tmpfs on /run type tmpfs (rw,noexec,nosuid,size=10%,mode=0755)
none on /run/lock type tmpfs (rw,noexec,nosuid,nodev,size=5242880)
none on /run/shm type tmpfs (rw,nosuid,nodev)
none on /run/user type tmpfs
(rw,noexec,nosuid,nodev,size=104857600,mode=0755)
none on /sys/fs/pstore type pstore (rw)
tmpfs on /var/tmp type tmpfs (rw,noatime,mode=1777)
tmpfs on /var/log type tmpfs (rw,noatime,mode=0755)
cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,relatime,cpuset)
cgroup on /sys/fs/cgroup/cpu type cgroup (rw,relatime,cpu)
cgroup on /sys/fs/cgroup/cpuacct type cgroup (rw,relatime,cpuacct)
cgroup on /sys/fs/cgroup/memory type cgroup (rw,relatime,memory)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,relatime,devices)
cgroup on /sys/fs/cgroup/freezer type cgroup (rw,relatime,freezer)
cgroup on /sys/fs/cgroup/blkio type cgroup (rw,relatime,blkio)
cgroup on /sys/fs/cgroup/perf_event type cgroup (rw,relatime,perf_event)
cgroup on /sys/fs/cgroup/hugetlb type cgroup (rw,relatime,hugetlb)
/dev/sda2 on /boot type ext2 (rw)
/dev/sda1 on /boot/efi type vfat (rw)
systemd on /sys/fs/cgroup/systemd type cgroup
(rw,noexec,nosuid,nodev,none,name=systemd)
gvfsd-fuse on /run/user/1000/gvfs type fuse.gvfsd-fuse
(rw,nosuid,nodev,user=ritesh)

fsck/badblock (read only) says disk is clean.


downstream report -
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1259829



--
Ritesh Khadgaray
LinuX N Stuff
Ph: +919970164885
Eat Right, Exercise, Die Anyway.

