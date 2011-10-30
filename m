From: NeilBrown <neilb@suse.de>
Subject: Re: PROBLEM: Kernel panic and system crash during RAID disk failure
Date: Sun, 30 Oct 2011 19:05:48 +1100
Message-ID: <20111030190548.2febafc0@notabene.brown>
References: <Pine.LNX.4.64.1110300257510.32513@hytron.hytron.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/LC/GYUQIkcX4L8_XxxIjeys"; protocol="application/pgp-signature"
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Darko <darko@hytron.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625Ab1J3IFu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Oct 2011 04:05:50 -0400
In-Reply-To: <Pine.LNX.4.64.1110300257510.32513@hytron.hytron.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Sig_/LC/GYUQIkcX4L8_XxxIjeys
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 30 Oct 2011 03:27:28 -0400 (EDT) Darko <darko@hytron.net> wrote:

> Hello,
>=20
> I have been doing some testing with the md RAID driver and I think I=20
> discovered a problem with it.
> Everything was performed on a system with a single hard drive using loop=
=20
> devices as virtual raid devices.
> So here is the setup:
> /dev/sdc is my main drive that hold entire Linux OS and has one partition.
> in the /tmp I created 7 files, 100MB each and associated them with loop=20
> devices:
>=20
> losetup -a
> /dev/loop0: [0821]:294820 (/var/tmp/raid-0)
> /dev/loop1: [0821]:294857 (/var/tmp/raid-1)
> /dev/loop2: [0821]:300120 (/var/tmp/raid-2)
> /dev/loop3: [0821]:301073 (/var/tmp/raid-3)
> /dev/loop4: [0821]:301074 (/var/tmp/raid-4)
> /dev/loop5: [0821]:301075 (/var/tmp/raid-5)
> /dev/loop6: [0821]:301076 (/var/tmp/raid-6)
>=20
> The next step was, created an RAID6 array:
> mdadm --create /dev/md10 --level=3D6 -raid-deviced=3D7 /dev/loop[0-6]
>=20
> Here is how it looks so far:
>=20
> cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md10 : active raid6 loop6[6] loop5[5] loop4[4] loop3[3] loop2[2] loop1[1]=
 loop0[0]
>        499200 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/7] [UU=
UUUUU]
>=20
>=20
> Then the filesystem...
> mkfs.ext4 -b 4096 -i 4096 -m 0 /dev/md10
>=20
> Mounting the file system to a folder called 'A' right in the root of my=20
> system:
>=20
> mount /dev/md10 /A
>=20
> Then I copied a few files on that file system. So far everything is good.
>=20
> Then I purposly failed 2 drives:
> mdadm --manage /dev/md10 --fail /dev/loop0
> mdadm --manage /dev/md10 --fail /dev/loop1
>=20
> The array continues to run fine in degraded mode. I was wondering what=20
> would happen if another drive fails. So while I was doing a write=20
> operating right in that filesystem (/dev/md10) using:
> dd if=3D/dev/zero of=3Dtestfile bs=3D1k count=3D360000  ...
>=20
> ...quickly switched to a different console and entered the command:
> mdadm --manage /dev/md10 --fail /dev/loop2
>=20
> ...which made 3 failed drives and the array can no longer work...
>=20
> Well I would be happy to see just the array not working, but kernel panic=
=20
> in both versions 2.6.37.4 and 3.0.8 made me worry that it is serious bug=
=20
> and appears to be in older and newer kernels as well.
> I repeated this several times, and mostly the machine gets locked up with=
=20
> kernel panic. But once I was able to get it not to lock up all the way,=20
> and that is how I have dmesg output.
>=20
> The attached files include dmesg from the system startup until the bug=20
> trace, and some additional information regarding my system that might be=
=20
> helpful.
>=20
> For any additional question, please feel free to contact me!
>=20
> I hope this info helps someone find and resolve the problem in the code.
>=20

The important part of your kernel log message is:


[ 1227.766202] ------------[ cut here ]------------
[ 1227.766259] kernel BUG at kernel/timer.c:681!
[ 1227.766311] invalid opcode: 0000 [#1] SMP=20
[ 1227.766365] last sysfs file: /sys/devices/virtual/block/md10/dev
[ 1227.766419] Modules linked in:
[ 1227.766471]=20
[ 1227.766520] Pid: 1507, comm: mount Not tainted 2.6.37.6-v5.0 #7 MICRO-ST=
AR INTERNATIONAL CO., LTD MS-7142/MS-7142
[ 1227.766633] EIP: 0060:[<c104f960>] EFLAGS: 00010246 CPU: 0
[ 1227.766690] EIP is at mod_timer+0x210/0x250
[ 1227.766742] EAX: 00000000 EBX: f5494e1c ECX: 00000000 EDX: 00000000
[ 1227.766796] ESI: 00000000 EDI: 05348416 EBP: f54a3c90 ESP: f54a3c74
[ 1227.766851]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1227.766904] Process mount (pid: 1507, ti=3Df54a2000 task=3Df2068880 task=
.ti=3Df54a2000)
[ 1227.767002] Stack:
[ 1227.767003]  f2068880 f54b159c 00000010 00000000 f1f8e400 f4efc57c 00001=
28d f54a3ca8
[ 1227.767003]  c11cb7ba c17d4e52 f4efc400 00000124 00000000 f54a3cb4 c11ce=
4e6 ecee6318
[ 1227.767003]  f54a3cdc c11cf7cc ecec7578 00000124 00000000 f4efc400 f54a3=
cd4 00000124
[ 1227.767003] Call Trace:
[ 1227.767003]  [<c11cb7ba>] ? __save_error_info.clone.61+0x7a/0xf0
[ 1227.767003]  [<c11ce4e6>] ? save_error_info+0x16/0x30
[ 1227.767003]  [<c11cf7cc>] ? ext4_error_inode+0x4c/0xf0
[ 1227.767003]  [<c11b57e1>] ? __ext4_get_inode_loc+0x201/0x410
[ 1227.767003]  [<c110b62a>] ? inode_init_always+0x1aa/0x1c0
[ 1227.767003]  [<c11b72f9>] ? ext4_iget+0x59/0x6f0
[ 1227.767003]  [<c11d2716>] ? ext4_fill_super+0x1ab6/0x2c70
[ 1227.767003]  [<c114896f>] ? disk_name+0xbf/0xd0
[ 1227.767003]  [<c10fa119>] ? mount_bdev+0x179/0x1c0
[ 1227.767003]  [<c11d0c60>] ? ext4_fill_super+0x0/0x2c70
[ 1227.767003]  [<c11ca17f>] ? ext4_mount+0x1f/0x30
[ 1227.767003]  [<c11d0c60>] ? ext4_fill_super+0x0/0x2c70
[ 1227.767003]  [<c10f9835>] ? vfs_kern_mount+0x75/0x250
[ 1227.767003]  [<c110df03>] ? get_fs_type+0x33/0xb0
[ 1227.767003]  [<c11ca160>] ? ext4_mount+0x0/0x30
[ 1227.767003]  [<c10f9a6e>] ? do_kern_mount+0x3e/0xe0
[ 1227.767003]  [<c111080f>] ? do_mount+0x35f/0x6b0
[ 1227.767003]  [<c10d47c9>] ? strndup_user+0x49/0x70
[ 1227.767003]  [<c1110e0b>] ? sys_mount+0x6b/0xa0
[ 1227.767003]  [<c17b550c>] ? syscall_call+0x7/0xb
[ 1227.767003] Code: fe ff ff 8b 0e 89 4d e4 8b 46 04 83 c6 08 89 f9 89 da =
ff 55 e4 8b 06 85 c0 89 45 e4 75 ea e9 aa fe ff ff 8b 75 ec e9 ee fe ff ff =
<0f> 0b 8b 55 04 89 d8 e8 34 f9 ff ff e9 2a fe ff ff 8b 35 30 b8=20
[ 1227.767003] EIP: [<c104f960>] mod_timer+0x210/0x250 SS:ESP 0068:f54a3c74
[ 1227.770073] ---[ end trace d7b3d7a67954d202 ]---


which happens after:

[ 1137.167043] Aborting journal on device md10-8.
[ 1137.167058] Buffer I/O error on device md10, logical block 139265
[ 1137.167060] lost page write due to I/O error on md10
[ 1137.167065] JBD2: I/O error detected when updating journal superblock fo=
r md10-8.
[ 1137.660922] Buffer I/O error on device md10, logical block 1
[ 1137.660926] lost page write due to I/O error on md10
[ 1137.660932] EXT4-fs error (device md10): ext4_journal_start_sb:260: Dete=
cted aborted journal
[ 1137.661046] EXT4-fs (md10): Remounting filesystem read-only
[ 1137.661103] EXT4-fs (md10): previous I/O error to superblock detected
[ 1137.661313] Buffer I/O error on device md10, logical block 1
[ 1137.661315] lost page write due to I/O error on md10
[ 1219.891363] EXT4-fs (md10): previous I/O error to superblock detected
[ 1220.050654] Buffer I/O error on device md10, logical block 1
[ 1220.050657] lost page write due to I/O error on md10
[ 1220.050663] EXT4-fs error (device md10): ext4_put_super:728: Couldn't cl=
ean up the journal

and some more "Buffer I/O error"s.

So it looks like an ext4 issue.

I have Cc:ed the appropriate list.

Thanks for the report.

NeilBrown


--Sig_/LC/GYUQIkcX4L8_XxxIjeys
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTq0FXDnsnt1WYoG5AQJ8zQ/+Ns0JgQFisiajluyyA1qtbQKvtuMbjq6S
t8d0GjlCEJEwaVdnM6J0M0r8x+utcvMSYW2ApuWjEWBf/jpd81MYNlc+Vf8G5wDB
kduULS+iBQyr3ZHSu6w1ZBz5RNT365BgfO8+OLlsMer/4dKt0q6NVh6xNa+0Esfh
QUds8ckhVxuJdChF8ANfPOzx9RBjbR20CrsCdsqRUnTS1c4t5ghb9u0lzPneYvj+
WOWVwSIOAdY2nLaltplEcNBEjXjeH8hJusdNYKoPzAGGw/g2PNzms2gPwHZ1PheE
EZieXARlAVD0/TEEl1r3coI3p33a/8ixh0ISTDKy6CW4WePjlhldq6Hq+Rkcdglu
vDM6g9W+F/b45FYZ8a+M0ghIu3tzpT+BBTEZPsrdVVf2Yq2Tn7jsxws14qWe/+OC
6t+13puAwbN+zgBOVUmKZ3cDaVoaCAoA1RqWHl4cj7W24bf9Radusxav1Hq9BcWt
dPBeygEF1i/a0vhdjFDsd7y3Wq5avoy+I3zWGGKhiVLZXSZQXEJtHxBLhbRJD2ps
IkSVAW4l05+T4Ay1n2SNrexGCSVehT2I9eSvTBkuTHDGQ38ySjE0kBsyUa3sV8Dj
6v9CCdjAOmrm5JMSLe20NhQzadiCBEAwP4KLYGoEpM/pwJ4UtsyWK/KdxOV8iv1E
atPc0C3mpIQ=
=ZrL2
-----END PGP SIGNATURE-----

--Sig_/LC/GYUQIkcX4L8_XxxIjeys--
