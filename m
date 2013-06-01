From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: found a scenario for BUG at fs/ext4/super.c:804!
Date: Sat, 01 Jun 2013 10:00:49 -0500
Message-ID: <51AA0CA1.6080600@redhat.com>
References: <51A79353.7030604@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Dave Jones <davej@redhat.com>
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978Ab3FAPA5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 1 Jun 2013 11:00:57 -0400
In-Reply-To: <51A79353.7030604@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/30/13 12:58 PM, Toralf F=C3=B6rster wrote:
> With kernel 3.10-rcX there's a big likelihood to observe that issue i=
f I do the following steps:=20
>=20
>  1. create a 257 MB file /mnt/ramdisk/disk0
>  2. create an EXT4 fs onto it
>  3. mount it onto /mnt/ramdisk/victims/
>  4. create files and directories in /mnt/ramdisk/victims/v1/v2
>  5. exportfs the directory /mnt/ramdisk/victims/ via NFS=20
>  6. start a user mode linux
>  7. within UML nfs-mount the exported directory /mnt/ramdisk/victims/=
 onto 3 different UML directories /mnt/nfsv[234] - just to test all 3 N=
=46S versions
>  8. run trinity within the UML guest using a victims directory /mnt/n=
fsv[234]/v1/v2 for a longer period (rather hours)

And therein lies the unknown magic.

Again, trinity's job is to try to corrupt the kernel by fuzzing syscall=
s.  We've had "xfs bug reports" after running trinity as well... and al=
l indications are that xfs is the victim, not the root cause.

It could be a filesystem bug, or just as easily some other bug in a sys=
call that allowed trinity to corrupt memory.

I do not think these bug reports are actionable until you can figure ou=
t how to narrow down the trinity operations that cause the problem.

-Eric

>  9. stop UML, Ctrl-C any running trinity / UML process
> 10. try to umount mnt/ramdisk/victims/
> 11. if that attempt fails stop the nfs service and run the umount com=
mand again - it segfaults now
> 12. if the 1st umount is however successfully then make a :-/
>=20
>=20
> 2013-05-30T19:20:28.000+02:00 n22 rpc.mountd[2921]: authenticated unm=
ount request from 192.168.1.63:798 for /mnt/ramdisk/victims (/mnt/ramdi=
sk/victims)
> 2013-05-30T19:20:28.000+02:00 n22 rpc.mountd[2921]: authenticated unm=
ount request from 192.168.1.63:799 for /mnt/ramdisk/victims (/mnt/ramdi=
sk/victims)
> 2013-05-30T19:20:42.569+02:00 n22 kernel: br0: port 1(tap0) entered d=
isabled state
> 2013-05-30T19:21:10.000+02:00 n22 rpc.mountd[2921]: Caught signal 15,=
 un-registering and exiting.
> 2013-05-30T19:21:10.336+02:00 n22 kernel: lockd: couldn't shutdown ho=
st module for net c161c200!
> 2013-05-30T19:21:10.338+02:00 n22 kernel: nfsd: last server has exite=
d, flushing export cache
> 2013-05-30T19:21:12.227+02:00 n22 kernel: EXT4-fs (loop0): sb orphan =
head is 32315
> 2013-05-30T19:21:12.227+02:00 n22 kernel: sb_info orphan list:
> 2013-05-30T19:21:12.227+02:00 n22 kernel: inode loop0:32315 at e87021=
58: mode 102357, nlink 0, next 32173
> 2013-05-30T19:21:12.227+02:00 n22 kernel: inode loop0:32173 at e773a8=
60: mode 100406, nlink 0, next 32383
> 2013-05-30T19:21:12.227+02:00 n22 kernel: inode loop0:32383 at e93bbd=
78: mode 102041, nlink 0, next 32233
> 2013-05-30T19:21:12.227+02:00 n22 kernel: inode loop0:32233 at e7e742=
e0: mode 103267, nlink 0, next 32421
> 2013-05-30T19:21:12.227+02:00 n22 kernel: inode loop0:32421 at e84fad=
10: mode 100102, nlink 0, next 32155
> 2013-05-30T19:21:12.227+02:00 n22 kernel: inode loop0:32155 at e87005=
38: mode 100700, nlink 0, next 32230
> 2013-05-30T19:21:12.227+02:00 n22 kernel: inode loop0:32230 at e77397=
f8: mode 102747, nlink 0, next 32313
> 2013-05-30T19:21:12.227+02:00 n22 kernel: inode loop0:32313 at e8701c=
a8: mode 102667, nlink 0, next 32244
> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32244 at e79b36=
70: mode 100353, nlink 0, next 32361
> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32361 at e8703b=
20: mode 100206, nlink 0, next 32271
> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32271 at e79b3b=
20: mode 100000, nlink 0, next 32255
> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32255 at eb8ec0=
88: mode 104657, nlink 0, next 32366
> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32366 at e8701f=
00: mode 105711, nlink 0, next 32281
> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32281 at e77382=
e0: mode 101637, nlink 0, next 32151
> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32151 at e92cce=
98: mode 101557, nlink 0, next 32138
> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32138 at e932a6=
08: mode 101327, nlink 0, next 32013
> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32013 at e74be1=
58: mode 101527, nlink 0, next 32012
> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32012 at e74be3=
b0: mode 102427, nlink 0, next 32110
> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32110 at e74bdf=
00: mode 101303, nlink 0, next 32112
> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32112 at e74bea=
b8: mode 100000, nlink 0, next 32066
> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32066 at e79f9a=
50: mode 104607, nlink 0, next 32148
> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32148 at e9331c=
a8: mode 102507, nlink 0, next 32158
> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32158 at e84c31=
c0: mode 100000, nlink 0, next 32139
> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32139 at e84c1c=
a8: mode 101507, nlink 0, next 32115
> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32115 at e93310=
f0: mode 104037, nlink 0, next 0
> 2013-05-30T19:21:12.228+02:00 n22 kernel: ------------[ cut here ]---=
---------
> 2013-05-30T19:21:12.228+02:00 n22 kernel: kernel BUG at fs/ext4/super=
=2Ec:804!
> 2013-05-30T19:21:12.228+02:00 n22 kernel: invalid opcode: 0000 [#1] S=
MP 2013-05-30T19:21:12.228+02:00 n22 kernel: Modules linked in: loop nf=
sd auth_rpcgss oid_registry lockd sunrpc ip6t_REJECT ip6table_filter ip=
6_tables ipt_MASQUERADE xt_owner xt_LOG xt_limit xt_multiport ipt_REJEC=
T xt_tcpudp xt_recent xt_conntrack iptable_nat nf_conntrack_ipv4 nf_def=
rag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tab=
les af_packet pppoe pppox ppp_generic slhc bridge stp llc ipv6 tun fuse=
 dm_mod coretemp kvm_intel kvm aesni_intel i915 xts aes_i586 lrw gf128m=
ul ablk_helper arc4 hid_cherry hid_generic iwldvm fbcon snd_hda_codec_c=
onexant cfbfillrect cfbimgblt cryptd i2c_algo_bit sr_mod cfbcopyarea in=
tel_agp sdhci_pci cdrom intel_gtt evdev mac80211 sdhci bitblit mmc_core=
 softcursor font acpi_cpufreq mperf psmouse usbhid drm_kms_helper usblp=
 snd_hda_intel e1000e uvcvideo drm videobuf2_vmalloc hid agpgart videob=
uf2_memops videobuf2_core videodev fb 8250_pci snd_hda_codec ptp i!
 2c!
>  _i801 8250
>  pps_core processor battery fbdev iwlwifi i2c_core cfg80211 thermal w=
mi tpm_tis snd_pcm snd_page_alloc snd_timer tpm tpm_bios thinkpad_acpi =
video nvram snd soundcore ac rfkill thermal_sys button serial_core hwmo=
n [last unloaded: microcode]
> 2013-05-30T19:21:12.228+02:00 n22 kernel: CPU: 1 PID: 11831 Comm: umo=
unt Not tainted 3.10.0-rc3+ #6
> 2013-05-30T19:21:12.228+02:00 n22 kernel: Hardware name: LENOVO 4180F=
65/4180F65, BIOS 83ET73WW (1.43 ) 11/30/2012
> 2013-05-30T19:21:12.228+02:00 n22 kernel: task: eec69aa0 ti: eb4b6000=
 task.ti: eb4b6000
> 2013-05-30T19:21:12.228+02:00 n22 kernel: EIP: 0060:[<c11ba6ec>] EFLA=
GS: 00010287 CPU: 1
> 2013-05-30T19:21:12.228+02:00 n22 kernel: EIP is at ext4_put_super+0x=
2dc/0x2e0
> 2013-05-30T19:21:12.228+02:00 n22 kernel: EAX: 0000003d EBX: eaa3d400=
 ECX: eaa3d550 EDX: eaa3d550
> 2013-05-30T19:21:12.228+02:00 n22 kernel: ESI: eaa3f000 EDI: eaa3d514=
 EBP: eb4b7efc ESP: eb4b7ecc
> 2013-05-30T19:21:12.228+02:00 n22 kernel: DS: 007b ES: 007b FS: 00d8 =
GS: 00e0 SS: 0068
> 2013-05-30T19:21:12.228+02:00 n22 kernel: CR0: 80050033 CR2: b6bab000=
 CR3: 2edc6000 CR4: 000407f0
> 2013-05-30T19:21:12.229+02:00 n22 kernel: DR0: 00000000 DR1: 00000000=
 DR2: 00000000 DR3: 00000000
> 2013-05-30T19:21:12.229+02:00 n22 kernel: DR6: ffff0ff0 DR7: 00000400
> 2013-05-30T19:21:12.229+02:00 n22 kernel: Stack:
> 2013-05-30T19:21:12.229+02:00 n22 kernel: c1567fa0 eaa3f1bc 00007d73 =
e93310f0 0000881f 00000000 00000000 e93310d0
> 2013-05-30T19:21:12.229+02:00 n22 kernel: eaa3d550 eaa3f000 eaa3f058 =
c14a06e0 eb4b7f18 c111f771 eb4b7f28 eb4b7f18
> 2013-05-30T19:21:12.229+02:00 n22 kernel: f1d70400 00000083 eaa3f000 =
eb4b7f28 c111f819 eaa3f000 c15fde28 eb4b7f38
> 2013-05-30T19:21:12.229+02:00 n22 kernel: Call Trace:
> 2013-05-30T19:21:12.229+02:00 n22 kernel: [<c111f771>] generic_shutdo=
wn_super+0x51/0xd0
> 2013-05-30T19:21:12.229+02:00 n22 kernel: [<c111f819>] kill_block_sup=
er+0x29/0x70
> 2013-05-30T19:21:12.229+02:00 n22 kernel: [<c111fa64>] deactivate_loc=
ked_super+0x44/0x70
> 2013-05-30T19:21:12.229+02:00 n22 kernel: [<c1120437>] deactivate_sup=
er+0x47/0x60
> 2013-05-30T19:21:12.229+02:00 n22 kernel: [<c11371bd>] mntput_no_expi=
re+0xcd/0x120
> 2013-05-30T19:21:12.229+02:00 n22 kernel: [<c113807e>] SyS_umount+0xa=
e/0x330
> 2013-05-30T19:21:12.229+02:00 n22 kernel: [<c113831e>] SyS_oldumount+=
0x1e/0x20
> 2013-05-30T19:21:12.229+02:00 n22 kernel: [<c1482701>] sysenter_do_ca=
ll+0x12/0x22
> 2013-05-30T19:21:12.229+02:00 n22 kernel: Code: 24 a0 7f 56 c1 05 bc =
01 00 00 89 44 24 04 e8 d2 f8 2b 00 8b 4d ec 8b 55 f0 8b 09 39 ca 75 b2=
 39 93 50 01 00 00 0f 84 9a fe ff ff <0f> 0b 66 90 55 89 e5 83 ec 20 66=
 66 66 66 90 8d 45 18 c7 04 24
> 2013-05-30T19:21:12.229+02:00 n22 kernel: EIP: [<c11ba6ec>] ext4_put_=
super+0x2dc/0x2e0 SS:ESP 0068:eb4b7ecc
> 2013-05-30T19:21:12.229+02:00 n22 kernel: ---[ end trace 2a52a524ae17=
6def ]---
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
