From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: More inline data oddities
Date: Mon, 1 May 2017 16:00:02 -0600
Message-ID: <04BDD82D-B764-49A8-9F5B-71303BE96857@dilger.ca>
References: <20170501174001.3541.qmail@ns.sciencehorizons.net>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_A45CE96C-463F-4EAB-92C5-6EAD092B411F";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: George Spelvin <linux@sciencehorizons.net>,
        Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33074 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752327AbdEAWAI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 1 May 2017 18:00:08 -0400
Received: by mail-io0-f196.google.com with SMTP id o22so422836iod.0
        for <linux-ext4@vger.kernel.org>; Mon, 01 May 2017 15:00:07 -0700 (PDT)
In-Reply-To: <20170501174001.3541.qmail@ns.sciencehorizons.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_A45CE96C-463F-4EAB-92C5-6EAD092B411F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Add the original inline data author Zheng Liu <wenqing.lz@taobao.com>.

On May 1, 2017, at 11:40 AM, George Spelvin <linux@sciencehorizons.net> =
wrote:
>=20
> The new e2fsck 1.43.4 (31-Jan-2017) has definitely helped, but I'm
> still seeing some flakiness with inline_data directories.  There's =
still
> a kernel problem, which is creating file systems that confuse e2fsck.
>=20
> But I have more data on the e2fsck problem which is mis-correcting =
that
> problem so it takes a second run to get a clean file system.
>=20
> Specifically, e2fsck is creating the missing system.date problem on =
one
> run and then zeroing out the directory on another.
>=20
> The problem is occurring when I rsync to a small directory.  Consider
> the following directories:
>=20
> 1461410  (12) .    1421827  (12) ..    1461583  (20) potd-800.jpg
> 1472133  (36) .xvpics    1461401  (72) .potd-800.jpg.4176
>=20
> 1461314  (12) .    1421827  (12) ..    1461426  (20) potd-800.jpg
> 1463943  (36) .xvpics    1461400  (72) .potd-800.jpg.4176
>=20
> During the rsync run, I got syslog complaints:
>=20
> [255031.626936] EXT4-fs warning (device md3): =
ext4_dirent_csum_verify:352: inode #1461410: comm find: No space for =
directory leaf checksum. Please run e2fsck -D.
> [255031.626940] EXT4-fs error (device md3): ext4_readdir:198: inode =
#1461410: comm find: path $PATH1: directory fails checksum at offset 0
> [255035.720542] EXT4-fs warning (device md3): =
ext4_dirent_csum_verify:352: inode #1461314: comm find: No space for =
directory leaf checksum. Please run e2fsck -D.
> [255035.720547] EXT4-fs error (device md3): ext4_readdir:198: inode =
#1461314: comm find: path $PATH2: directory fails checksum at offset 0
>=20
>=20
> The inline data consists of two parts: 60 bytes in the block pointers =
which
> hold the first four entries, and 72 bytes in an ea, which holds the =
fifth and
> last entry.
>=20
> debugfs on the directories reveals the following:
> Inode: 1461410   Type: directory    Mode:  0755   Flags: 0x10000000
> Generation: 927521379    Version: 0x00000000:00000007
> User:  1000   Group:    11   Project:     0   Size: 132
> File ACL: 1496481792    Directory ACL: 0
> Links: 3   Blockcount: 8
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
> atime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
> mtime: 0x55016b84:e7729ec8 -- Thu Mar 12 06:33:40 2015
> crtime: 0x56c1c093:0d01b4b4 -- Mon Feb 15 07:12:03 2016
> Size of extra inode fields: 32
> Extended attributes:
>  system.data (72)
> Inode checksum: 0x456bd90c
> Size of inline data: 132
>=20
> Inode: 1461314   Type: directory    Mode:  0755   Flags: 0x10000000
> Generation: 927521364    Version: 0x00000000:00000004
> User:  1000   Group:    11   Project:     0   Size: 132
> File ACL: 1496383488    Directory ACL: 0
> Links: 3   Blockcount: 8
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
> atime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
> mtime: 0x55016b84:1670325c -- Thu Mar 12 06:33:40 2015
> crtime: 0x56c1c093:01161e74 -- Mon Feb 15 07:12:03 2016
> Size of extra inode fields: 32
> Extended attributes:
>  system.data (72)
> Inode checksum: 0x008d7abf
> Size of inline data: 132
>=20
>=20
> If I run e2fsck on that stat, it complains about two things:
>=20
> Inode 1461314, i_blocks is 8, should be 0.  Fix<y>? yes
> Inode 1461410, i_blocks is 8, should be 0.  Fix<y>? yes
> i_file_acl for inode 1461314 ($PATH2) is 1496383488, should be zero.
> Clear<y>? yes
> i_file_acl for inode 1461410 ($PATH1) is 1496481792, should be zero.
> Clear<y>? yes
>=20
> I don't really understand how those two errors were created in the
> first place.
>=20
> However, after saying yes to those, the system.data ea is missing and =
the
> final entries in each directory get dropped, leading to being dumped
> in loat+found.
>=20
> Here's the state after the first e2fsck run completes:
>=20
> Inode: 1461410   Type: directory    Mode:  0755   Flags: 0x10000000
> Generation: 927521379    Version: 0x00000000:00000007
> User:  1000   Group:    11   Project:     0   Size: 132
> File ACL: 0    Directory ACL: 0
> Links: 3   Blockcount: 0
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
> atime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
> mtime: 0x55016b84:e7729ec8 -- Thu Mar 12 06:33:40 2015
> crtime: 0x56c1c093:0d01b4b4 -- Mon Feb 15 07:12:03 2016
> Size of extra inode fields: 32
> Inode checksum: 0xcd34b98c
> Size of inline data: 60
>=20
> Inode: 1461314   Type: directory    Mode:  0755   Flags: 0x10000000
> Generation: 927521364    Version: 0x00000000:00000004
> User:  1000   Group:    11   Project:     0   Size: 132
> File ACL: 0    Directory ACL: 0
> Links: 3   Blockcount: 0
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
> atime: 0x5902fa22:07728174 -- Fri Apr 28 04:15:30 2017
> mtime: 0x55016b84:1670325c -- Thu Mar 12 06:33:40 2015
> crtime: 0x56c1c093:01161e74 -- Mon Feb 15 07:12:03 2016
> Size of extra inode fields: 32
> Inode checksum: 0x042ed119
> Size of inline data: 60
>=20
>=20
> This then leads to a second run complaining about
>=20
> Inode 1461314 has INLINE_DATA_FL flag but extended attribute not =
found.  Truncate<y>?
>=20
> If I instead fix it by "ea_set -f /dev/null <1461314> system.data", I =
get the
> directory back in a relatively unbroken state.  But why is system.data
> being deleted in the first place?


Cheers, Andreas






--Apple-Mail=_A45CE96C-463F-4EAB-92C5-6EAD092B411F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZB6/jpIg59Q01vtYRAtr+AKDIvcD2/EYBJQIJyqTNEZaKArS8EgCgg5Kt
E+ohLjicVGjxoLR7PBQ10MM=
=It5n
-----END PGP SIGNATURE-----

--Apple-Mail=_A45CE96C-463F-4EAB-92C5-6EAD092B411F--
