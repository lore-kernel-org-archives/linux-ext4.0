From: Gui Xiaohua <guixh@cn.fujitsu.com>
Subject: Re: [PATCH: e2fsprogs: resize2fs failed when "mkfs.ext4 -O flex_bg"]
Date: Tue, 10 Feb 2009 11:32:22 +0800
Message-ID: <4990F546.3050906@cn.fujitsu.com>
References: <4990CB6A.1020403@cn.fujitsu.com> <20090210010917.GA30689@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59445 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbZBJDeo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Feb 2009 22:34:44 -0500
In-Reply-To: <20090210010917.GA30689@mini-me.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso =E5=86=99=E9=81=93:
> On Tue, Feb 10, 2009 at 08:33:46AM +0800, Gui Xiaohua wrote:
>> When mkfs.ext4 with flex_bg option, resize2fs with -M option will fa=
il.
>>
>> Steps to reproduce:
>>
>> # mkfs.ext4 -O flex_bg /dev/sda6
>> # resize2fs /dev/sda6 -M
>>
>> resize2fs: No space left on device while trying to resize /dev/sda6
>=20
> These problems were fixed in e2fsprogs 1.41.4.  See especially commit
> id's 793a04a0 and 9227c5bb.  (There were a number of other resize2fs
> bugs fixed in 1.41.4, but these two relate to the problems you were
> trying to solve.)
>=20
> I'm not convinced your attempt at trying to guesstimate how the numbe=
r
> of extra blocks needed by counting fragments works for anything other
> than an empty filesystem.  If the filesystem is filled with contents,
> and then it is shrunk, the resulting number of new extent blocks whic=
h
> are needed is very much dependent on how the blocks end up getting
> moved, and trying to determine the exact number up front is extremely
> difficult.
>=20
> Regards,
>=20
> 					- Ted


Hi Ted
I have tested your patch,but occurs some messages like below:
resize2fs: Illegal triply indirect block found while trying to resize /=
dev/sda7

Steps to reproduce:
# mkfs.ext4 -O flex_bg /dev/sda7
# mount -t ext4 /dev/sda7 /mnt
# dumpe2fs /dev/sda7
dumpe2fs 1.41.4 (27-Jan-2009)
=46ilesystem volume name:   <none>
Last mounted on:          <not available>
=46ilesystem UUID:          56f80bde-6a27-4564-87cf-a7186d05e86b
=46ilesystem magic number:  0xEF53
=46ilesystem revision #:    1 (dynamic)
=46ilesystem features:      has_journal ext_attr resize_inode dir_index=
 filetype extent flex_bg sparse_super huge_file uninit_bg dir_nlink ext=
ra_isize
=46ilesystem flags:         signed_directory_hash
Default mount options:    (none)
=46ilesystem state:         clean
Errors behavior:          Continue
=46ilesystem OS type:       Linux
Inode count:              4016
Block count:              16032
Reserved block count:     801
=46ree blocks:              14359
=46ree inodes:              4005
=46irst block:              1
Block size:               1024
=46ragment size:            1024
Reserved GDT blocks:      62
Blocks per group:         8192
=46ragments per group:      8192
Inodes per group:         2008
Inode blocks per group:   251
=46lex block group size:    16
=46ilesystem created:       Tue Feb  3 22:06:30 2009
Last mount time:          n/a
Last write time:          Tue Feb  3 22:06:30 2009
Mount count:              0
Maximum mount count:      27
Last checked:             Tue Feb  3 22:06:30 2009
Check interval:           15552000 (6 months)
Next check after:         Sun Aug  2 22:06:30 2009
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
=46irst inode:              11
Inode size:               128
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      397bda27-6808-47a9-9dc1-e736908e4a05
Journal backup:           inode blocks
Journal size:             1024k


Group 0: (Blocks 1-8192) [ITABLE_ZEROED]
  Checksum 0x3698, unused inodes 1997
  Primary superblock at 1, Group descriptors at 2-2
  Reserved GDT blocks at 3-64
  Block bitmap at 65 (+64), Inode bitmap at 81 (+80)
  Inode table at 97-347 (+96)
  7608 free blocks, 1997 free inodes, 2 directories, 1997 unused inodes
  Free blocks: 80, 83-96, 600-8192
  Free inodes: 12-2008
Group 1: (Blocks 8193-16031) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x88a4, unused inodes 2008
  Backup superblock at 8193, Group descriptors at 8194-8194
  Reserved GDT blocks at 8195-8256
  Block bitmap at 66, Inode bitmap at 82
  Inode table at 348-598
  6751 free blocks, 2008 free inodes, 0 directories, 2008 unused inodes
  Free blocks: 9281-16031
  Free inodes:

# created many files with size 1k	<----the sum of files is greater than=
 inode per group,
								such as 2500
# rm -f files				<----the sum is 2000=EF=BC=8Cso the second group will =
be cut while
						resize
# umount /dev/sda7
# e2fsck -f /dev/sda7
[root@localhost /]# resize2fs /dev/sda7 -M
resize2fs 1.41.4 (27-Jan-2009)
Resizing the filesystem on /dev/sda7 to 1940 (1k) blocks.
resize2fs: Illegal triply indirect block found while trying to resize /=
dev/sda7



=20




> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
