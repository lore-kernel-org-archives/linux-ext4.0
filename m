From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: found a scenario for BUG at fs/ext4/super.c:804!
Date: Sat, 03 Aug 2013 16:44:40 +0200
Message-ID: <51FD1758.40107@gmx.de>
References: <51A79353.7030604@gmx.de> <51AA0CA1.6080600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, trinity@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:60864 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab3HCOoo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 Aug 2013 10:44:44 -0400
Received: from [92.224.123.131] ([92.224.123.131]) by mail.gmx.com (mrgmx002)
 with ESMTPSA (Nemesis) id 0MDhba-1UphR631x8-00H7hr for
 <linux-ext4@vger.kernel.org>; Sat, 03 Aug 2013 16:44:43 +0200
In-Reply-To: <51AA0CA1.6080600@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/01/2013 05:00 PM, Eric Sandeen wrote:
> On 5/30/13 12:58 PM, Toralf F=C3=B6rster wrote:
>> With kernel 3.10-rcX there's a big likelihood to observe that issue =
if I do the following steps:=20
>>
>>  1. create a 257 MB file /mnt/ramdisk/disk0
>>  2. create an EXT4 fs onto it
>>  3. mount it onto /mnt/ramdisk/victims/
>>  4. create files and directories in /mnt/ramdisk/victims/v1/v2
>>  5. exportfs the directory /mnt/ramdisk/victims/ via NFS=20
>>  6. start a user mode linux
>>  7. within UML nfs-mount the exported directory /mnt/ramdisk/victims=
/ onto 3 different UML directories /mnt/nfsv[234] - just to test all 3 =
NFS versions
>>  8. run trinity within the UML guest using a victims directory /mnt/=
nfsv[234]/v1/v2 for a longer period (rather hours)
>=20
> And therein lies the unknown magic.
>=20
> Again, trinity's job is to try to corrupt the kernel by fuzzing sysca=
lls.  We've had "xfs bug reports" after running trinity as well... and =
all indications are that xfs is the victim, not the root cause.
>=20
> It could be a filesystem bug, or just as easily some other bug in a s=
yscall that allowed trinity to corrupt memory.
>=20
> I do not think these bug reports are actionable until you can figure =
out how to narrow down the trinity operations that cause the problem.
>=20
> -Eric

Hhm,

whilst I'm not able to narrow it down to a certain trinity syscall - I =
can narrow it down to EXT3/EXT4 which have to be created onto a file an=
d loop mounted to local file system and then exported via NFS at a NFS =
server

I can reproduce the issue using 2 user-mode-linux images within ~ 1 hou=
r (not 100% but very often after 1 hour of fuzzying).

Trinity runs at the NFS client as a unprivileged user. It hammers the N=
=46S server with fuzzy NFS calls. This let the NFS server image crash a=
s soon as it then tries to unmount the NFS share.

/me wonders whether a bisect would help - assuming that it is bisectibl=
e issue.



What I get from the NFS server (UML image of a 32 bit stable Gentoo Lin=
ux) is however not too much :

Kernel panic - not syncing: BUG!
CPU: 0 PID: 1441 Comm: umount Not tainted 3.11.0-rc3-00288-gabe0308-dir=
ty #17
652a7d68 652a7d94 08400940 084a5f7c 085d6ce0 084977e5 652a7da0 00000000=
=20
       66342390 650e0f50 66342450 652a7dd0 08168632 084977e5 084ac7f4 0=
00001c5=20
       0841eb4c 0000182c 65e18254 000081ff 00000000 00000000 66342450 6=
50e0f50 652a7d3c:  [<0805fb1f>] show_stack+0xcf/0x100
652a7d60:  [<08403897>] dump_stack+0x26/0x28
652a7d70:  [<08400940>] panic+0x7a/0x18b
652a7d98:  [<08168632>] ext3_put_super+0x1b2/0x240
652a7dd4:  [<08101092>] generic_shutdown_super+0x52/0xc0
652a7df0:  [<0810205a>] kill_block_super+0x2a/0x80
652a7e08:  [<08100f2a>] deactivate_locked_super+0x2a/0x70
652a7e1c:  [<08100fc1>] deactivate_super+0x51/0x70
652a7e30:  [<08118dec>] mntput_no_expire+0xdc/0xf0
652a7e4c:  [<0811a2d5>] SyS_umount+0x325/0x380
652a7e9c:  [<0811a349>] SyS_oldumount+0x19/0x20
652a7eac:  [<080618e2>] handle_syscall+0x82/0xb0
652a7ef4:  [<08073c0d>] userspace+0x46d/0x590
652a7fec:  [<0805e65c>] fork_handler+0x6c/0x70
652a7ffc:  [<5a5a5a5a>] 0x5a5a5a5a


EIP: 0073:[<40001282>] CPU: 0 Not tainted ESP: 007b:bfe44348 EFLAGS: 00=
000296
    Not tainted
EAX: ffffffda EBX: 0804f980 ECX: 00000000 EDX: 40064ff4
ESI: 0804f878 EDI: 0804f980 EBP: 40066688 DS: 007b ES: 007b
652a7d0c:  [<0807802f>] show_regs+0x10f/0x120
652a7d28:  [<0806138c>] panic_exit+0x2c/0x50
652a7d38:  [<0809a388>] notifier_call_chain+0x38/0x60
652a7d60:  [<0809a4d3>] atomic_notifier_call_chain+0x23/0x30
652a7d70:  [<08400968>] panic+0xa2/0x18b
652a7d98:  [<08168632>] ext3_put_super+0x1b2/0x240
652a7dd4:  [<08101092>] generic_shutdown_super+0x52/0xc0
652a7df0:  [<0810205a>] kill_block_super+0x2a/0x80
652a7e08:  [<08100f2a>] deactivate_locked_super+0x2a/0x70
652a7e1c:  [<08100fc1>] deactivate_super+0x51/0x70
652a7e30:  [<08118dec>] mntput_no_expire+0xdc/0xf0
652a7e4c:  [<0811a2d5>] SyS_umount+0x325/0x380
652a7e9c:  [<0811a349>] SyS_oldumount+0x19/0x20
652a7eac:  [<080618e2>] handle_syscall+0x82/0xb0
652a7ef4:  [<08073c0d>] userspace+0x46d/0x590
652a7fec:  [<0805e65c>] fork_handler+0x6c/0x70
652a7ffc:  [<5a5a5a5a>] 0x5a5a5a5a

Terminated

=20
>>  9. stop UML, Ctrl-C any running trinity / UML process
>> 10. try to umount mnt/ramdisk/victims/
>> 11. if that attempt fails stop the nfs service and run the umount co=
mmand again - it segfaults now
>> 12. if the 1st umount is however successfully then make a :-/
>>
>>
>> 2013-05-30T19:20:28.000+02:00 n22 rpc.mountd[2921]: authenticated un=
mount request from 192.168.1.63:798 for /mnt/ramdisk/victims (/mnt/ramd=
isk/victims)
>> 2013-05-30T19:20:28.000+02:00 n22 rpc.mountd[2921]: authenticated un=
mount request from 192.168.1.63:799 for /mnt/ramdisk/victims (/mnt/ramd=
isk/victims)
>> 2013-05-30T19:20:42.569+02:00 n22 kernel: br0: port 1(tap0) entered =
disabled state
>> 2013-05-30T19:21:10.000+02:00 n22 rpc.mountd[2921]: Caught signal 15=
, un-registering and exiting.
>> 2013-05-30T19:21:10.336+02:00 n22 kernel: lockd: couldn't shutdown h=
ost module for net c161c200!
>> 2013-05-30T19:21:10.338+02:00 n22 kernel: nfsd: last server has exit=
ed, flushing export cache
>> 2013-05-30T19:21:12.227+02:00 n22 kernel: EXT4-fs (loop0): sb orphan=
 head is 32315
>> 2013-05-30T19:21:12.227+02:00 n22 kernel: sb_info orphan list:
>> 2013-05-30T19:21:12.227+02:00 n22 kernel: inode loop0:32315 at e8702=
158: mode 102357, nlink 0, next 32173
>> 2013-05-30T19:21:12.227+02:00 n22 kernel: inode loop0:32173 at e773a=
860: mode 100406, nlink 0, next 32383
>> 2013-05-30T19:21:12.227+02:00 n22 kernel: inode loop0:32383 at e93bb=
d78: mode 102041, nlink 0, next 32233
>> 2013-05-30T19:21:12.227+02:00 n22 kernel: inode loop0:32233 at e7e74=
2e0: mode 103267, nlink 0, next 32421
>> 2013-05-30T19:21:12.227+02:00 n22 kernel: inode loop0:32421 at e84fa=
d10: mode 100102, nlink 0, next 32155
>> 2013-05-30T19:21:12.227+02:00 n22 kernel: inode loop0:32155 at e8700=
538: mode 100700, nlink 0, next 32230
>> 2013-05-30T19:21:12.227+02:00 n22 kernel: inode loop0:32230 at e7739=
7f8: mode 102747, nlink 0, next 32313
>> 2013-05-30T19:21:12.227+02:00 n22 kernel: inode loop0:32313 at e8701=
ca8: mode 102667, nlink 0, next 32244
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32244 at e79b3=
670: mode 100353, nlink 0, next 32361
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32361 at e8703=
b20: mode 100206, nlink 0, next 32271
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32271 at e79b3=
b20: mode 100000, nlink 0, next 32255
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32255 at eb8ec=
088: mode 104657, nlink 0, next 32366
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32366 at e8701=
f00: mode 105711, nlink 0, next 32281
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32281 at e7738=
2e0: mode 101637, nlink 0, next 32151
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32151 at e92cc=
e98: mode 101557, nlink 0, next 32138
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32138 at e932a=
608: mode 101327, nlink 0, next 32013
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32013 at e74be=
158: mode 101527, nlink 0, next 32012
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32012 at e74be=
3b0: mode 102427, nlink 0, next 32110
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32110 at e74bd=
f00: mode 101303, nlink 0, next 32112
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32112 at e74be=
ab8: mode 100000, nlink 0, next 32066
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32066 at e79f9=
a50: mode 104607, nlink 0, next 32148
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32148 at e9331=
ca8: mode 102507, nlink 0, next 32158
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32158 at e84c3=
1c0: mode 100000, nlink 0, next 32139
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32139 at e84c1=
ca8: mode 101507, nlink 0, next 32115
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: inode loop0:32115 at e9331=
0f0: mode 104037, nlink 0, next 0
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: ------------[ cut here ]--=
----------
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: kernel BUG at fs/ext4/supe=
r.c:804!
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: invalid opcode: 0000 [#1] =
SMP 2013-05-30T19:21:12.228+02:00 n22 kernel: Modules linked in: loop n=
fsd auth_rpcgss oid_registry lockd sunrpc ip6t_REJECT ip6table_filter i=
p6_tables ipt_MASQUERADE xt_owner xt_LOG xt_limit xt_multiport ipt_REJE=
CT xt_tcpudp xt_recent xt_conntrack iptable_nat nf_conntrack_ipv4 nf_de=
frag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_ta=
bles af_packet pppoe pppox ppp_generic slhc bridge stp llc ipv6 tun fus=
e dm_mod coretemp kvm_intel kvm aesni_intel i915 xts aes_i586 lrw gf128=
mul ablk_helper arc4 hid_cherry hid_generic iwldvm fbcon snd_hda_codec_=
conexant cfbfillrect cfbimgblt cryptd i2c_algo_bit sr_mod cfbcopyarea i=
ntel_agp sdhci_pci cdrom intel_gtt evdev mac80211 sdhci bitblit mmc_cor=
e softcursor font acpi_cpufreq mperf psmouse usbhid drm_kms_helper usbl=
p snd_hda_intel e1000e uvcvideo drm videobuf2_vmalloc hid agpgart video=
buf2_memops videobuf2_core videodev fb 8250_pci snd_hda_codec ptp i!
>  2c!
>>  _i801 8250
>>  pps_core processor battery fbdev iwlwifi i2c_core cfg80211 thermal =
wmi tpm_tis snd_pcm snd_page_alloc snd_timer tpm tpm_bios thinkpad_acpi=
 video nvram snd soundcore ac rfkill thermal_sys button serial_core hwm=
on [last unloaded: microcode]
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: CPU: 1 PID: 11831 Comm: um=
ount Not tainted 3.10.0-rc3+ #6
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: Hardware name: LENOVO 4180=
=4665/4180F65, BIOS 83ET73WW (1.43 ) 11/30/2012
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: task: eec69aa0 ti: eb4b600=
0 task.ti: eb4b6000
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: EIP: 0060:[<c11ba6ec>] EFL=
AGS: 00010287 CPU: 1
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: EIP is at ext4_put_super+0=
x2dc/0x2e0
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: EAX: 0000003d EBX: eaa3d40=
0 ECX: eaa3d550 EDX: eaa3d550
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: ESI: eaa3f000 EDI: eaa3d51=
4 EBP: eb4b7efc ESP: eb4b7ecc
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: DS: 007b ES: 007b FS: 00d8=
 GS: 00e0 SS: 0068
>> 2013-05-30T19:21:12.228+02:00 n22 kernel: CR0: 80050033 CR2: b6bab00=
0 CR3: 2edc6000 CR4: 000407f0
>> 2013-05-30T19:21:12.229+02:00 n22 kernel: DR0: 00000000 DR1: 0000000=
0 DR2: 00000000 DR3: 00000000
>> 2013-05-30T19:21:12.229+02:00 n22 kernel: DR6: ffff0ff0 DR7: 0000040=
0
>> 2013-05-30T19:21:12.229+02:00 n22 kernel: Stack:
>> 2013-05-30T19:21:12.229+02:00 n22 kernel: c1567fa0 eaa3f1bc 00007d73=
 e93310f0 0000881f 00000000 00000000 e93310d0
>> 2013-05-30T19:21:12.229+02:00 n22 kernel: eaa3d550 eaa3f000 eaa3f058=
 c14a06e0 eb4b7f18 c111f771 eb4b7f28 eb4b7f18
>> 2013-05-30T19:21:12.229+02:00 n22 kernel: f1d70400 00000083 eaa3f000=
 eb4b7f28 c111f819 eaa3f000 c15fde28 eb4b7f38
>> 2013-05-30T19:21:12.229+02:00 n22 kernel: Call Trace:
>> 2013-05-30T19:21:12.229+02:00 n22 kernel: [<c111f771>] generic_shutd=
own_super+0x51/0xd0
>> 2013-05-30T19:21:12.229+02:00 n22 kernel: [<c111f819>] kill_block_su=
per+0x29/0x70
>> 2013-05-30T19:21:12.229+02:00 n22 kernel: [<c111fa64>] deactivate_lo=
cked_super+0x44/0x70
>> 2013-05-30T19:21:12.229+02:00 n22 kernel: [<c1120437>] deactivate_su=
per+0x47/0x60
>> 2013-05-30T19:21:12.229+02:00 n22 kernel: [<c11371bd>] mntput_no_exp=
ire+0xcd/0x120
>> 2013-05-30T19:21:12.229+02:00 n22 kernel: [<c113807e>] SyS_umount+0x=
ae/0x330
>> 2013-05-30T19:21:12.229+02:00 n22 kernel: [<c113831e>] SyS_oldumount=
+0x1e/0x20
>> 2013-05-30T19:21:12.229+02:00 n22 kernel: [<c1482701>] sysenter_do_c=
all+0x12/0x22
>> 2013-05-30T19:21:12.229+02:00 n22 kernel: Code: 24 a0 7f 56 c1 05 bc=
 01 00 00 89 44 24 04 e8 d2 f8 2b 00 8b 4d ec 8b 55 f0 8b 09 39 ca 75 b=
2 39 93 50 01 00 00 0f 84 9a fe ff ff <0f> 0b 66 90 55 89 e5 83 ec 20 6=
6 66 66 66 90 8d 45 18 c7 04 24
>> 2013-05-30T19:21:12.229+02:00 n22 kernel: EIP: [<c11ba6ec>] ext4_put=
_super+0x2dc/0x2e0 SS:ESP 0068:eb4b7ecc
>> 2013-05-30T19:21:12.229+02:00 n22 kernel: ---[ end trace 2a52a524ae1=
76def ]---
>>
>>
>=20
>=20


--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
