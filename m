From: Lars Wijtemans <lars@wijtemans.nl>
Subject: PROBLEM: incorrect data block bitmap after running resize2fs and
 e2fsck
Date: Fri, 17 Jun 2016 16:55:03 +0200
Message-ID: <1466175303.22666.10.camel@wijtemans.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vs2.de.wijtemans.nl ([78.47.216.174]:49449 "EHLO
	vs2.de.wijtemans.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412AbcFQPAX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jun 2016 11:00:23 -0400
Received: from ant.fritz.box (unknown [IPv6:2001:981:8da8:1::26:0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: lars@wijtemans.nl)
	by vs2.de.wijtemans.nl (Postfix) with ESMTPSA id 4782FD1C
	for <linux-ext4@vger.kernel.org>; Fri, 17 Jun 2016 16:55:04 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After shrinking an ext4 filesystem with resize2fs and running e2fsck
afterwards, total free blocks count is wrong. Blocks which are "not in
use" according to debugfs are in fact found to be used by the icheck
command of debugfs. Subsequent runs of e2fsck report no problems with
this filesystem.


=3D=3D System information
Linux 4.5.6-200.fc23.x86_64
e2fsprogs 1.42.13 (17-May-2015)


=3D=3D What led to the problem
I wanted to shrink an ext4 filesystem. The filesystem was created a
while ago (probably with the -E resize=3Dxyz option) and has been resiz=
ed
before.
It is layered like this: GPT partition | RAID | LUKS | LVM | ext4

(21694432 MiB total size at this point)

# e2fsck -f /dev/mapper/foo
No filesystem problems were found.

# resize2fs -P /dev/mapper/foo
(20248275 MiB)

# resize2fs /dev/mapper/foo 21693408M
# e2fsck -nf /dev/mapper/foo
(No filesystem problems were found)

# resize2fs -p /dev/mapper/foo 21170144M
# resize2fs -p /dev/mapper/foo 20645856M
# e2fsck -nf /dev/mapper/foo
There were a lot of "Free blocks count wrong" wrong messages. Some
searching on the internet let me to believe this was to be expected, so
I re-ran with the "preen" option.

# e2fsck -fp /dev/mapper/foo
(This completed without any meaningful output)

The filesystem contained about 19 TiB of data. After mounting, df
showed only 13 TiB in use. I immediately re-mounted in read-only mode.
Walking the filesystem still shows a total 19.2 TiB of data that seems
to be uncorrupted (check ongoing).
Subsequent runs of e2fsck do not find any problems.


=3D=3D Going from here...
I am concerned that writing to this filesystem will result in data
loss, since a lot of blocks are (incorrectly) marked as free. It also
seems like something e2fsck should be able to fix, since the files are
accessible without problems in read-only mode. I can even imagine
fixing this through debugfs, by checking whether a block is used by a
file and, if so, mark it as such.

What I would like to do is
1) figure out why e2fsck is not able to detect/fix this by itself,
hopefully resulting in an improvement in e2fsck and
2) (manually) restore the filesystem to a usable state (within about
two weeks).

I'm not familiar with ext4 internals, so any help here is appreciated.


# df --block-size=3D4096 /data
=46ilesystem=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A04K-bl=
ocks=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Used=C2=A0=C2=A0Available=
 Use%
/dev/mapper/vg_datagroup-bulk 5282123045 3385286984 1666833796=C2=A0=C2=
=A068%

# du --block-size=3D4096 --summarize --one-file-system /data


# debugfs /dev/mapper/foo -R "testb 1 5285339135" > /tmp/testb.txt
Block 1 marked in use
[...]
Block 32768 not in use
[...]

# grep " not in use" /tmp/testb.txt | wc -l
1896836061

# grep " marked in use" /tmp/testb.txt | wc -l
3388503074

# grep " not in use" /tmp/testb.txt | shuf -n 100 | \
=C2=A0 awk '{print $2}' | tr '\n' " "
265503904 1397137951 924616805 [...]

These blocks should not have any files associated with them.

# debugfs /dev/mapper/foo -R "icheck 265503904 1397137951 [...]"
debugfs 1.42.13 (17-May-2015)
Block	Inode number
265503904	9569537
1397137951	8697
924616805	4764587
920525308	11513483
4032323069	<block not found>
814305093	1539116
246137426	26227968
456159649	21
277352417	2861448
[...]


# dumpe2fs -h /dev/mapper/foo
dumpe2fs 1.42.13 (17-May-2015)
=46ilesystem volume name:=C2=A0=C2=A0=C2=A0bulk
Last mounted on:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0/data
=46ilesystem UUID:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0dc0f67cf-85a4-421f-8387-0fb2de7f03ff
=46ilesystem magic number:=C2=A0=C2=A00xEF53
=46ilesystem revision #:=C2=A0=C2=A0=C2=A0=C2=A01 (dynamic)
=46ilesystem features:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0has_journal e=
xt_attr dir_index filetype
meta_bg extent 64bit flex_bg sparse_super large_file huge_file
uninit_bg dir_nlink extra_isize
=46ilesystem flags:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
signed_directory_hash=C2=A0
Default mount options:=C2=A0=C2=A0=C2=A0=C2=A0user_xattr acl
=46ilesystem state:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
clean
Errors behavior:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0Remount read-only
=46ilesystem OS type:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Linux
Inode count:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A041291776
Block count:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A05285339136
Reserved block count:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0229998169
=46ree blocks:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A01896836061
=46ree inodes:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A09341404
=46irst block:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A00
Block size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A04096
=46ragment size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A04096
Group descriptor size:=C2=A0=C2=A0=C2=A0=C2=A064
Blocks per group:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
32768
=46ragments per group:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A032768
Inodes per group:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
256
Inode blocks per group:=C2=A0=C2=A0=C2=A016
RAID stride:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0128
RAID stripe width:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0768
=46irst meta block group:=C2=A0=C2=A0=C2=A01956
=46lex block group size:=C2=A0=C2=A0=C2=A0=C2=A04096
=46ilesystem created:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Sun Sep=C2=
=A0=C2=A07 13:05:00 2014
Last mount time:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0Thu Jun 16 10:38:57 2016
Last write time:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0Thu Jun 16 10:39:41 2016
Mount count:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A01
Maximum mount count:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A020
Last checked:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0Thu Jun 16 09:55:23 2016
Check interval:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A01382400 (2 weeks, 2 days)
Next check after:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
Sat Jul=C2=A0=C2=A02 09:55:23 2016
Lifetime writes:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A044 TB
Reserved blocks uid:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00 (user root)
Reserved blocks gid:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00 (group root)
=46irst inode:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A011
Inode size:	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
256
Required extra isize:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A028
Desired extra isize:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A028
Journal inode:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A08
Default directory hash:=C2=A0=C2=A0=C2=A0half_md4
Directory Hash Seed:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0656e1be4-f041-4=
1c8-a3e8-63827db144bd
Journal backup:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0inode blocks
Journal features:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
journal_incompat_revoke journal_64bit
Journal size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A01024M
Journal length:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0262144
Journal sequence:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
0x00192c59
Journal start:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A00
Bad blocks: 2639100416, 2639100417, [...]
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
