From: Jakob Haufe <sur5r@sur5r.net>
Subject: Kernel keeps device locked after umount / jbd2 does not go away
 (Debian 3.16.0-4-amd64 / 3.16.7-ckt4-3)
Date: Wed, 18 Feb 2015 23:37:31 +0100
Message-ID: <20150218233731.4eba8686@samsa.sur5r.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512; protocol="application/pgp-signature"; boundary="=_libri-2396-1424299059-0001-2"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from libri.sur5r.net ([217.8.49.41]:41434 "EHLO libri.sur5r.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbbBRWmn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Feb 2015 17:42:43 -0500
Received: from samsa.sur5r.net (localhost [127.0.0.1])
	by samsa (Postfix) with ESMTP id DB13810556B9
	for <linux-ext4@vger.kernel.org>; Wed, 18 Feb 2015 23:37:38 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_libri-2396-1424299059-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

I've got an issue with filesystems that don't get unmounted completely. Aft=
er
umount, the mountpoint appears empty. However, it's impossible to

* rmdir the mountpoint
* fsck/resize the device

The corresponding [jbd2] kernel process is still there. It's possible to mo=
unt
the filesystem again on the same mountpoint as well as on a different one.

The following information has been collected as suggested by Eric Sandeen o=
n IRC:

Call trace after "echo t > /proc/sysrq-trigger":

Feb 18 21:57:23 ifzy kernel: [ 7692.537500] jbd2/dm-24-8    S ffff88042bbe2=
5e8     0  1587      2 0x00000000
Feb 18 21:57:23 ifzy kernel: [ 7692.537504]  ffff88042bbe2190 0000000000000=
046 0000000000013280 ffff88042c973fd8
Feb 18 21:57:23 ifzy kernel: [ 7692.537507]  0000000000013280 ffff88042bbe2=
190 ffff88042c6ac024 ffff88042c6ac3e0
Feb 18 21:57:23 ifzy kernel: [ 7692.537511]  ffff88042c6ac0a0 ffff88042c973=
e98 ffff88042c6ac088 ffff88042c6ac000
Feb 18 21:57:23 ifzy kernel: [ 7692.537514] Call Trace:
Feb 18 21:57:23 ifzy kernel: [ 7692.537525]  [<ffffffffa01e7cec>] ? kjourna=
ld2+0x1dc/0x240 [jbd2]
Feb 18 21:57:23 ifzy kernel: [ 7692.537529]  [<ffffffff810a7840>] ? prepare=
_to_wait_event+0xf0/0xf0
Feb 18 21:57:23 ifzy kernel: [ 7692.537539]  [<ffffffffa01e7b10>] ? commit_=
timeout+0x10/0x10 [jbd2]
Feb 18 21:57:23 ifzy kernel: [ 7692.537543]  [<ffffffff81087ddd>] ? kthread=
+0xbd/0xe0
Feb 18 21:57:23 ifzy kernel: [ 7692.537548]  [<ffffffff81087d20>] ? kthread=
_create_on_node+0x180/0x180
Feb 18 21:57:23 ifzy kernel: [ 7692.537551]  [<ffffffff8150f6bc>] ? ret_fro=
m_fork+0x7c/0xb0
Feb 18 21:57:23 ifzy kernel: [ 7692.537555]  [<ffffffff81087d20>] ? kthread=
_create_on_node+0x180/0x180

dm-24 is an LVM LV.

Output of "dumpe2fs -h":

dumpe2fs 1.42.12 (29-Aug-2014)
Filesystem volume name:   <none>
Last mounted on:          /mnt/backhetz
Filesystem UUID:          5f95c683-f4f1-4b22-9319-85d9b3a58f9f
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filet=
ype needs_recovery extent flex_bg sparse_super large_file huge_file uninit_=
bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash=20
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              21626880
Block count:              86507520
Reserved block count:     3858713
Free blocks:              21371388
Free inodes:              21617034
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1003
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Fri Jan 30 00:16:55 2015
Last mount time:          Wed Feb 18 19:49:39 2015
Last write time:          Wed Feb 18 20:51:18 2015
Mount count:              3
Maximum mount count:      -1
Last checked:             Wed Jan  1 00:00:00 2014
Check interval:           31536000 (12 months, 5 days)
Next check after:         Thu Jan  1 00:00:00 2015
Lifetime writes:          307 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      cead16f8-297a-4bcf-b65e-d6354d9fd4a4
Journal backup:           inode blocks
Journal features:         (none)
Journal size:             128M
Journal length:           32768
Journal sequence:         0x00003c27
Journal start:            1

Note that while "Last mount time" updates just fine, "Last mounted on"
doesn't get updated as I've mounted this filesystem elsewhere in the meanti=
me.
Also, this information was collected while the filesystem was "unmounted".

rmdir("/mnt/backhetz") fails with -EBUSY, stat /mnt/backhetz shows
Device: fd04h/64772d which is not dm-24.=20

Additional information:

Some days ago, I had the same issue with a different device. As I needed to
shrink the filesystem, I put noauto into fstab and rebooted. After the
necessary forced fsck (in preparation of the resize) and the resize itself,
the filesystem behaves as expected and can be unmounted properly.

Newly created filesystems on this machine also behave well.

The fact that is filesystem can not be unmounted properly is currently not a
problem for me, so I can leave it in that state for some time. So in case
it's necessary to collect any additional information, that's no problem.

On a different host, I encountered a similar issue with a 3.14 based kernel
(can't remember the exact version anymore, one of Debian's 3.14s). I don't
know whether [jbd2] was running after umount there as well.

Please CC me on replies as I'm not subscribed to the list.

Thanks in advance,
Jakob Haufe

--=20
ceterum censeo microsoftem esse delendam.

--=_libri-2396-1424299059-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCgAGBQJU5RQuAAoJEEzyshj1Ta49WqgP/AqzSkyzJZjqSaGSPZBzHHEj
OAEKhe/ermn9iANTMk82ZoW9Isk1fkUlmFTl98dnU5Da3cF7/0EeAvVk7/vJ36lc
HhdkPS0qgMtG+V9p/5ui4cgnyfSpt3Nj9n6lr8XbOhDtZoczRnRKiaGpGMc5pHA1
p6iCnyVMlZE166Xe4ybbz6wpU8gJqRptmWc/RztMuGZZ3jE9cCR00WigDDrexOq1
p89thgUZuIJqF6pIxnTanjjioqACQodKdDSGKeHxr5zkK+j1BRadrOdLvychxGvo
2RomXKJoRgCetqKz0Fbh5K06sFV2n1T/GsAtOXPFAeXnYhTPn3HgfKejzbPaRzR7
e+0ScNExOlv37DZY9Gpx1zTsIxdskUrHRrnTv0yDvUhU3sO+/eiZ8HfGwRceIwSv
odmB2qn7t4A4fxM5eEE5bX9CGhcTVZCx0qFvmrpWc9OnvWGbaRF0fzVles4PSWJs
0U23bSkHbBAEV786H5EZW3Qo9Xcm7JK8GoMsQlSmQvkTSyGwMCLzDnYHLgmYBE/S
myt2Hi18HnxKbodRWOjBfZREdAkFxvCW+OzE3HdxM7jkPJkigCWnidjC/enBYeBK
2TA5Jw9aCNRfVzrXLVsSsMCDbLXfvJEVIwxOA47WOD+bWuXRB42hdJOLII7op+kH
+8/DvW4y3YnKHHeXo/04
=7nOq
-----END PGP SIGNATURE-----

--=_libri-2396-1424299059-0001-2--
