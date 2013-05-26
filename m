From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: BUG at fs/ext4/inode.c:1590!
Date: Sun, 26 May 2013 14:42:50 +0200
Message-ID: <51A2034A.8030709@gmx.de>
References: <5199514D.5090606@gmx.de> <20130519235504.GA8404@thunk.org> <51998A31.7060200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:50313 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab3EZMmx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 26 May 2013 08:42:53 -0400
Received: from mailout-de.gmx.net ([10.1.76.20]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0LuqoZ-1UGhVy4481-01083D for
 <linux-ext4@vger.kernel.org>; Sun, 26 May 2013 14:42:51 +0200
In-Reply-To: <51998A31.7060200@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/20/2013 04:28 AM, Eric Sandeen wrote:
> On 5/19/13 6:55 PM, Theodore Ts'o wrote:
>> So this BUG happened with a corrupted file system using a fuzzing
>> process?  What is trinity?  Is that the fuzzing process or the
>> workload?
>=20
> a system call fuzz tester
>=20
> http://codemonkey.org.uk/projects/trinity/
>=20
> It's probably possible that it's memory corruption too.
>=20
>> Can you replicate it?   Do you have the corrupted file system?
>=20
> Right, these bugs need to be narrowed down to be useful.

Today I run while fuzzying latest v3.10-rc2-448-g72de4c6 into a
nearly similar situation (32bit Gentoo Linux)

Till now I'm not able to gave a reproducible scenario just the bug mess=
ages.
All what I can tell till is that with stable kernel 3.9.x I never obser=
ved such issues
while 3.10-rcX produces it now for the 2nd time.

Unfortunately I lost the file containing the file system, the command m=
ount gave:
$> /mnt/ramdisk/disk0 (deleted) on /mnt/ramdisk/victims type ext4 (rw)


What happened after that was  :

$> rmdir /mnt/ramdisk/victims/
rmdir: failed to remove =E2=80=98/mnt/ramdisk/victims/=E2=80=99: Device=
 or resource busy

$> ll /mnt/ramdisk/victims/
total 0

$> umount /mnt/ramdisk/victims/
Segmentation fault

And the syslog for completeness :

2013-05-26T14:32:59.612+02:00 n22 kernel: EXT4-fs (loop0): sb orphan he=
ad is 32029
2013-05-26T14:32:59.612+02:00 n22 kernel: sb_info orphan list:
2013-05-26T14:32:59.612+02:00 n22 kernel: inode loop0:32029 at e85e57f8=
: mode 102002, nlink 0, next 32018
2013-05-26T14:32:59.612+02:00 n22 kernel: inode loop0:32018 at e8bf49e8=
: mode 105043, nlink 0, next 32023
2013-05-26T14:32:59.612+02:00 n22 kernel: inode loop0:32023 at e938bb20=
: mode 101247, nlink 0, next 32047
2013-05-26T14:32:59.612+02:00 n22 kernel: inode loop0:32047 at e840b418=
: mode 101027, nlink 0, next 0
2013-05-26T14:32:59.612+02:00 n22 kernel: ------------[ cut here ]-----=
-------
2013-05-26T14:32:59.612+02:00 n22 kernel: kernel BUG at fs/ext4/super.c=
:804!
2013-05-26T14:32:59.612+02:00 n22 kernel: invalid opcode: 0000 [#1] SMP=
=20
2013-05-26T14:32:59.612+02:00 n22 kernel: Modules linked in: loop nfsd =
auth_rpcgss oid_registry lockd sunrpc ipt_MASQUERADE xt_owner xt_multip=
ort ipt_REJECT xt_tcpudp xt_recent xt_conntrack xt_limit xt_LOG iptable=
_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack i=
ptable_filter ip_tables x_tables af_packet pppoe pppox ppp_generic slhc=
 bridge stp llc ipv6 tun fuse dm_mod coretemp kvm_intel kvm aesni_intel=
 hid_generic usblp xts hid_cherry usbhid aes_i586 rc_dib0700_rc5 i915 c=
fbfillrect cfbimgblt hid lrw i2c_algo_bit gf128mul ablk_helper arc4 iwl=
dvm mac80211 cfbcopyarea cryptd intel_agp dvb_usb_dib0700 dib3000mc dib=
8000 dvb_usb dib0070 dib7000m dib0090 dib7000p uvcvideo dvb_core dibx00=
0_common videobuf2_vmalloc rc_core videobuf2_memops videobuf2_core vide=
odev snd_hda_codec_conexant e1000e sr_mod snd_hda_intel intel_gtt think=
pad_acpi nvram snd_hda_codec snd_pcm snd_page_alloc snd_timer fbcon bit=
blit softcursor font drm_kms_helper psmouse sdhci_pci cdrom sdhci mmc_c=
ore w
mi iwlwifi cfg80211 ac snd evdev drm thermal acpi_cpufreq tpm_tis mperf=
 rfkill battery tpm video tpm_bios button i2c_i801 agpgart 8250_pci fb =
processor i2c_core 8250 ptp serial_core soundcore pps_core thermal_sys =
fbdev hwmon [last unloaded: microcode]
2013-05-26T14:32:59.613+02:00 n22 kernel: CPU: 1 PID: 25253 Comm: umoun=
t Not tainted 3.10.0-rc2+ #3
2013-05-26T14:32:59.613+02:00 n22 kernel: Hardware name: LENOVO 4180F65=
/4180F65, BIOS 83ET73WW (1.43 ) 11/30/2012
2013-05-26T14:32:59.613+02:00 n22 kernel: task: eaff27f0 ti: e9c28000 t=
ask.ti: e9c28000
2013-05-26T14:32:59.613+02:00 n22 kernel: EIP: 0060:[<c11ba55c>] EFLAGS=
: 00010287 CPU: 1
2013-05-26T14:32:59.613+02:00 n22 kernel: EIP is at ext4_put_super+0x2d=
c/0x2e0
2013-05-26T14:32:59.613+02:00 n22 kernel: EAX: 0000003d EBX: eb519400 E=
CX: eb519550 EDX: eb519550
2013-05-26T14:32:59.613+02:00 n22 kernel: ESI: eb51c400 EDI: eb519514 E=
BP: e9c29efc ESP: e9c29ecc
2013-05-26T14:32:59.613+02:00 n22 kernel: DS: 007b ES: 007b FS: 00d8 GS=
: 00e0 SS: 0068
2013-05-26T14:32:59.613+02:00 n22 kernel: CR0: 80050033 CR2: b773f0c0 C=
R3: 31a7d000 CR4: 000407f0
2013-05-26T14:32:59.613+02:00 n22 kernel: DR0: 00000000 DR1: 00000000 D=
R2: 00000000 DR3: 00000000
2013-05-26T14:32:59.614+02:00 n22 kernel: DR6: ffff0ff0 DR7: 00000400
2013-05-26T14:32:59.614+02:00 n22 kernel: Stack:
2013-05-26T14:32:59.614+02:00 n22 kernel: c1565830 eb51c5bc 00007d2f e8=
40b418 00008217 00000000 00000000 e840b3f8
2013-05-26T14:32:59.614+02:00 n22 kernel: eb519550 eb51c400 eb51c458 c1=
49e6a0 e9c29f18 c111f5e1 e9c29f28 e9c29f18
2013-05-26T14:32:59.614+02:00 n22 kernel: f1d74600 00000083 eb51c400 e9=
c29f28 c111f689 eb51c400 c15f9e28 e9c29f38
2013-05-26T14:32:59.614+02:00 n22 kernel: Call Trace:
2013-05-26T14:32:59.614+02:00 n22 kernel: [<c111f5e1>] generic_shutdown=
_super+0x51/0xd0
2013-05-26T14:32:59.614+02:00 n22 kernel: [<c111f689>] kill_block_super=
+0x29/0x70
2013-05-26T14:32:59.614+02:00 n22 kernel: [<c111f8d4>] deactivate_locke=
d_super+0x44/0x70
2013-05-26T14:32:59.614+02:00 n22 kernel: [<c11202a7>] deactivate_super=
+0x47/0x60
2013-05-26T14:32:59.615+02:00 n22 kernel: [<c113702d>] mntput_no_expire=
+0xcd/0x120
2013-05-26T14:32:59.615+02:00 n22 kernel: [<c1137eee>] SyS_umount+0xae/=
0x330
2013-05-26T14:32:59.615+02:00 n22 kernel: [<c113818e>] SyS_oldumount+0x=
1e/0x20
2013-05-26T14:32:59.615+02:00 n22 kernel: [<c1480901>] sysenter_do_call=
+0x12/0x22
2013-05-26T14:32:59.615+02:00 n22 kernel: [<c1480000>] ? tty_unlock+0x2=
0/0x50
2013-05-26T14:32:59.615+02:00 n22 kernel: Code: 24 30 58 56 c1 05 bc 01=
 00 00 89 44 24 04 e8 b4 db 2b 00 8b 4d ec 8b 55 f0 8b 09 39 ca 75 b2 3=
9 93 50 01 00 00 0f 84 9a fe ff ff <0f> 0b 66 90 55 89 e5 83 ec 20 66 6=
6 66 66 90 8d 45 18 c7 04 24
2013-05-26T14:32:59.615+02:00 n22 kernel: EIP: [<c11ba55c>] ext4_put_su=
per+0x2dc/0x2e0 SS:ESP 0068:e9c29ecc
2013-05-26T14:32:59.615+02:00 n22 kernel: ---[ end trace 4ebfe9c46d1fd9=
eb ]---



--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
