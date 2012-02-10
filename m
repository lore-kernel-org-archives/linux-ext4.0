From: Rudolf Zran <rudolfzran@yahoo.com>
Subject: Re: Restoring filenames from partly damaged ext4-filesystem
Date: Fri, 10 Feb 2012 18:36:52 +0000 (GMT)
Message-ID: <1328899012.92220.YahooMailNeo@web132404.mail.ird.yahoo.com>
References: <1328804993.34330.YahooMailNeo@web132403.mail.ird.yahoo.com> <B43723CA-78A5-416D-B44F-3018CE981211@mit.edu>
Reply-To: Rudolf Zran <rudolfzran@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"debian-user@lists.debian.org" <debian-user@lists.debian.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nm25.bullet.mail.ird.yahoo.com ([212.82.109.132]:47278 "HELO
	nm25.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759830Ab2BJSg4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Feb 2012 13:36:56 -0500
In-Reply-To: <B43723CA-78A5-416D-B44F-3018CE981211@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Ted!

>>  I recently damaged an ext4 partition by accident
[...]
>>  Maybe somebody knows a good method to just "repair" the
>> ext4-structure from the remaining part of the partition?
>=20
> Have you tried just simply running e2fsck, specifying an alternate su=
perblock?

Yes of course I tried, as I wrote in my original post ($SBOK is one
of the intact superblocks at 11239424, 20480000, 23887872, 71663616,
78675968 and 214990848).

With "all answers: no":

>> * "fsck.ext4 -b $SBOK -B 4096 -v -n /dev/loop0" shows a lot of error=
s.
>> =C2=A0 Filesystem isn't mountable afterwards

# fsck.ext4 -b 214990848 -B 4096 -v -n /dev/loop0
e2fsck 1.41.12 (17-May-2010)
One or more block group descriptor checksums are invalid.=C2=A0 Fix? no
Group descriptor 0 checksum is invalid.=C2=A0 IGNORED.
Group descriptor 1 checksum is invalid.=C2=A0 IGNORED.
=2E..
Group descriptor 7451 checksum is invalid.=C2=A0 IGNORED.
Group descriptor 7452 checksum is invalid.=C2=A0 IGNORED.
/dev/loop0 contains a file system with errors, check forced.
Resize inode not valid.=C2=A0 Recreate? no
Pass 1: Checking inodes, blocks, and sizes
Root inode is not a directory.=C2=A0 Clear? no
Inode 5 should not have EOFBLOCKS_FL set (size 2642074971391648798, lbl=
k -1)
Clear? no
=2E..

# mount -o ro /dev/loop0 /mnt
mount: /dev/loop0: can't read superblock

# dmesg=20
[504508.215515] EXT4-fs error (device loop0): ext4_iget: bad extended a=
ttribute block 1920620055 in inode #2
[504508.215530] EXT4-fs (loop0): get root inode failed
[504508.215534] EXT4-fs (loop0): mount failed

With "all answers: yes":

>> * "fsck.ext4 -b $SBOK -B 4096 -v -y /dev/loop0" recoveres after a lo=
ng time.
>> =C2=A0 Filesystem is mountable. Root is empty besides lost+found fol=
der, which
>> =C2=A0 contains about 300GB mostly useless data: Millions of files w=
ith wrong
>> =C2=A0 permissions, useless names and some random content.

> I'd do this by making a copy of the file system first, of course=E2=80=
=A6.

=46or sure! :) I solely work on copies.

Thanks, Rudolf.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
