From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: flashing large eMMC partitions with ext4
Date: Mon, 1 Aug 2011 22:44:01 +0300
Message-ID: <CAOQ4uxibcjyELHArqut2PbMShUhqM8d4YxOppZGVkCKk_7BaDg@mail.gmail.com>
References: <CAOQ4uxh6a1qoZZs2SVxxrKfcd5q0vKkpCMDQ-X5eur3Tg07FXg@mail.gmail.com>
	<632658.72291.qm@web4207.mail.ogk.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <aedilger@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Round Robinjp <roundrobinjp@yahoo.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56154 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab1HAToC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Aug 2011 15:44:02 -0400
Received: by wyg8 with SMTP id 8so1842928wyg.19
        for <linux-ext4@vger.kernel.org>; Mon, 01 Aug 2011 12:44:01 -0700 (PDT)
In-Reply-To: <632658.72291.qm@web4207.mail.ogk.yahoo.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 1, 2011 at 8:43 PM, Round Robinjp <roundrobinjp@yahoo.co.jp=
> wrote:
>> I meant using a newer version of resize2fs (which you do not have),
>
> I have now corrected this and other mistakes.
> But when I mount the image after finally extending
> to 4G, the df still shows the size as 1G.
> Am I still doing something wrong?

yes, a few things :-)

>
> Full log below:
>
> -----------------------------------------
> -----------------------------------------
> -----------------------------------------
> $ dd if=3D/dev/zero of=3Da.img bs=3D4K count=3D256K
> 262144+0 records in
> 262144+0 records out
> 1073741824 bytes (1.1 GB) copied, 4.09006 s, 263 MB/s
>

create the initial a.img 4G and specify 1G to mkfs.
so the loop device size is 4G and you can online resize the fs to 4G.

> $ mkfs.ext4 -O ^has_journal,flex_bg -G 32 -E resize=3D4G a.img
> mke2fs 1.42-WIP (02-Jul-2011)
> a.img is not a block special device.
> Proceed anyway? (y,n) y
> Filesystem label=3D
> OS type: Linux
> Block size=3D4096 (log=3D2)
> Fragment size=3D4096 (log=3D2)
> Stride=3D0 blocks, Stripe width=3D0 blocks
> 65536 inodes, 262144 blocks
> 13107 blocks (5.00%) reserved for the super user
> First data block=3D0
> Maximum filesystem blocks=3D268435456
> 8 block groups
> 32768 blocks per group, 32768 fragments per group
> 8192 inodes per group
> Superblock backups stored on blocks:
> =A0 =A0 =A0 =A032768, 98304, 163840, 229376
>
> Allocating group tables: done
> Writing inode tables: done
> Writing superblocks and filesystem accounting information: done
>
> This filesystem will be automatically checked every 0 mounts or
> 0 days, whichever comes first. =A0Use tune2fs -c or -i to override.
>
> $ sudo mount -t ext4 -o loop a.img /mnt/
> $ du -sh /usr/src/
> 92M =A0 =A0 /usr/src/
> $ cp -a /usr/src/* /mnt/
>

you should not run fsck on a mounted fs.
this is not good.
if you run fsck /dev/loop0 you will get an error.
if you want to check the fs, umount it first.

> $ e2fsck -f a.img
> e2fsck 1.42-WIP (02-Jul-2011)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Free blocks count wrong (242859, counted=3D237788).
> Fix<y>? yes
>
> Free inodes count wrong (55821, counted=3D52249).
> Fix<y>? yes
>
>
> a.img: ***** FILE SYSTEM WAS MODIFIED *****
> a.img: 13287/65536 files (0.0% non-contiguous), 24356/262144 blocks
>
> $ resize2fs a.img 4G

resize2fs /dev/loop0

> resize2fs 1.42-WIP (02-Jul-2011)
> Please run 'e2fsck -f a.img' first.
>
> $ e2fsck -f a.img
> e2fsck 1.42-WIP (02-Jul-2011)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> a.img: 20864/65536 files (0.0% non-contiguous), 27067/262144 blocks
>
> $ resize2fs a.img 4G
> resize2fs 1.42-WIP (02-Jul-2011)
> Resizing the filesystem on a.img to 1048576 (4k) blocks.
> The filesystem on a.img is now 1048576 blocks long.
>
> $ sudo tune2fs -O has_journal /dev/loop0
> tune2fs 1.42-WIP (02-Jul-2011)
> Creating journal inode: done
> This filesystem will be automatically checked every 20 mounts or
> 0 days, whichever comes first. =A0Use tune2fs -c or -i to override.
>
> $ sudo umount /mnt
>
> $ dumpe2fs a.img
> dumpe2fs 1.42-WIP (02-Jul-2011)
> Filesystem volume name: =A0 <none>
> Last mounted on: =A0 =A0 =A0 =A0 =A0/mnt
> Filesystem UUID: =A0 =A0 =A0 =A0 =A04f2361c3-2755-4a6a-bf28-dd7e1a4dd=
772
> Filesystem magic number: =A00xEF53
> Filesystem revision #: =A0 =A01 (dynamic)
> Filesystem features: =A0 =A0 =A0has_journal ext_attr resize_inode dir=
_index filetype extent flex_bg sparse_super large_file huge_file uninit=
_bg dir_nlink extra_isize
> Filesystem flags: =A0 =A0 =A0 =A0 signed_directory_hash
> Default mount options: =A0 =A0user_xattr acl
> Filesystem state: =A0 =A0 =A0 =A0 clean
> Errors behavior: =A0 =A0 =A0 =A0 =A0Continue
> Filesystem OS type: =A0 =A0 =A0 Linux
> Inode count: =A0 =A0 =A0 =A0 =A0 =A0 =A065536
> Block count: =A0 =A0 =A0 =A0 =A0 =A0 =A0262144

if you do everything right you should have 1048576 blocks after resize.

> Reserved block count: =A0 =A0 13107
> Free blocks: =A0 =A0 =A0 =A0 =A0 =A0 =A0226191
> Free inodes: =A0 =A0 =A0 =A0 =A0 =A0 =A044671
> First block: =A0 =A0 =A0 =A0 =A0 =A0 =A00
> Block size: =A0 =A0 =A0 =A0 =A0 =A0 =A0 4096
> Fragment size: =A0 =A0 =A0 =A0 =A0 =A04096
> Reserved GDT blocks: =A0 =A0 =A063
> Blocks per group: =A0 =A0 =A0 =A0 32768
> Fragments per group: =A0 =A0 =A032768
> Inodes per group: =A0 =A0 =A0 =A0 8192
> Inode blocks per group: =A0 512
> Flex block group size: =A0 =A032
> Filesystem created: =A0 =A0 =A0 Tue Aug =A02 02:29:45 2011
> Last mount time: =A0 =A0 =A0 =A0 =A0Tue Aug =A02 02:29:50 2011
> Last write time: =A0 =A0 =A0 =A0 =A0Tue Aug =A02 02:31:01 2011
> Mount count: =A0 =A0 =A0 =A0 =A0 =A0 =A01
> Maximum mount count: =A0 =A0 =A020
> Last checked: =A0 =A0 =A0 =A0 =A0 =A0 Tue Aug =A02 02:29:45 2011
> Check interval: =A0 =A0 =A0 =A0 =A0 0 (<none>)
> Lifetime writes: =A0 =A0 =A0 =A0 =A0406 kB
> Reserved blocks uid: =A0 =A0 =A00 (user root)
> Reserved blocks gid: =A0 =A0 =A00 (group root)
> First inode: =A0 =A0 =A0 =A0 =A0 =A0 =A011
> Inode size: =A0 =A0 =A0 =A0 =A0 =A0 =A0 256
> Required extra isize: =A0 =A0 28
> Desired extra isize: =A0 =A0 =A028
> Journal inode: =A0 =A0 =A0 =A0 =A0 =A020500
> Default directory hash: =A0 half_md4
> Directory Hash Seed: =A0 =A0 =A0a42d0c4e-0207-4fd4-94e7-b71bc107ae90
> Journal features: =A0 =A0 =A0 =A0 (none)
> Journal size: =A0 =A0 =A0 =A0 =A0 =A0 32M
> Journal length: =A0 =A0 =A0 =A0 =A0 8192
> Journal sequence: =A0 =A0 =A0 =A0 0x00000001
> Journal start: =A0 =A0 =A0 =A0 =A0 =A00
>
>
> Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
> =A0Checksum 0x3fe2, unused inodes 0
> =A0Primary superblock at 0, Group descriptors at 1-1
> =A0Reserved GDT blocks at 2-64
> =A0Block bitmap at 65 (+65), Inode bitmap at 97 (+97)
> =A0Inode table at 129-640 (+129)
> =A024746 free blocks, 0 free inodes, 3 directories
> =A0Free blocks: 20358-32767
> =A0Free inodes:
> Group 1: (Blocks 32768-65535) [ITABLE_ZEROED]
> =A0Checksum 0x1361, unused inodes 0
> =A0Backup superblock at 32768, Group descriptors at 32769-32769
> =A0Reserved GDT blocks at 32770-32832
> =A0Block bitmap at 66 (bg #0 + 66), Inode bitmap at 98 (bg #0 + 98)
> =A0Inode table at 641-1152 (bg #0 + 641)
> =A09128 free blocks, 0 free inodes, 975 directories
> =A0Free blocks: 49152-57343, 60376-60383, 60512-61439
> =A0Free inodes:
> Group 2: (Blocks 65536-98303) [ITABLE_ZEROED]
> =A0Checksum 0x3bb7, unused inodes 4076
> =A0Block bitmap at 67 (bg #0 + 67), Inode bitmap at 99 (bg #0 + 99)
> =A0Inode table at 1153-1664 (bg #0 + 1153)
> =A028672 free blocks, 4076 free inodes, 2302 directories, 4076 unused=
 inodes
> =A0Free blocks: 69632-98303
> =A0Free inodes: 20501-24576
> Group 3: (Blocks 98304-131071) [ITABLE_ZEROED]
> =A0Checksum 0x372b, unused inodes 7865
> =A0Backup superblock at 98304, Group descriptors at 98305-98305
> =A0Reserved GDT blocks at 98306-98368
> =A0Block bitmap at 68 (bg #0 + 68), Inode bitmap at 100 (bg #0 + 100)
> =A0Inode table at 1665-2176 (bg #0 + 1665)
> =A032703 free blocks, 7865 free inodes, 327 directories, 7865 unused =
inodes
> =A0Free blocks: 98369-131071
> =A0Free inodes: 24904-32768
> Group 4: (Blocks 131072-163839) [ITABLE_ZEROED]
> =A0Checksum 0x4c7a, unused inodes 8154
> =A0Block bitmap at 69 (bg #0 + 69), Inode bitmap at 101 (bg #0 + 101)
> =A0Inode table at 2177-2688 (bg #0 + 2177)
> =A032768 free blocks, 8154 free inodes, 38 directories, 8154 unused i=
nodes
> =A0Free blocks: 131072-163839
> =A0Free inodes: 32807-40960
> Group 5: (Blocks 163840-196607) [INODE_UNINIT, ITABLE_ZEROED]
> =A0Checksum 0xbd51, unused inodes 8192
> =A0Backup superblock at 163840, Group descriptors at 163841-163841
> =A0Reserved GDT blocks at 163842-163904
> =A0Block bitmap at 70 (bg #0 + 70), Inode bitmap at 102 (bg #0 + 102)
> =A0Inode table at 2689-3200 (bg #0 + 2689)
> =A032703 free blocks, 8192 free inodes, 0 directories, 8192 unused in=
odes
> =A0Free blocks: 163905-196607
> =A0Free inodes: 40961-49152
> Group 6: (Blocks 196608-229375) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_Z=
EROED]
> =A0Checksum 0xf453, unused inodes 8192
> =A0Block bitmap at 71 (bg #0 + 71), Inode bitmap at 103 (bg #0 + 103)
> =A0Inode table at 3201-3712 (bg #0 + 3201)
> =A032768 free blocks, 8192 free inodes, 0 directories, 8192 unused in=
odes
> =A0Free blocks: 196608-229375
> =A0Free inodes: 49153-57344
> Group 7: (Blocks 229376-262143) [INODE_UNINIT, ITABLE_ZEROED]
> =A0Checksum 0xfcc2, unused inodes 8192
> =A0Backup superblock at 229376, Group descriptors at 229377-229377
> =A0Reserved GDT blocks at 229378-229440
> =A0Block bitmap at 72 (bg #0 + 72), Inode bitmap at 104 (bg #0 + 104)
> =A0Inode table at 3713-4224 (bg #0 + 3713)
> =A032703 free blocks, 8192 free inodes, 0 directories, 8192 unused in=
odes
> =A0Free blocks: 229441-262143
> =A0Free inodes: 57345-65536
>
> $ truncate -s 1G a.img
>
> $ e2fsck -f a.img

don't try to 'fix' the fs before truncate -s 4G.
you can run fsck -nf if you want to see how the fs looks now.

> e2fsck 1.42-WIP (02-Jul-2011)
> Backing up journal inode block information.
>
> Moving journal from /.journal to hidden inode.
>
> Pass 1: Checking inodes, blocks, and sizes
> Inode 7 has illegal block(s). =A0Clear<y>? yes
>
> Illegal block #2064 (294914) in inode 7. =A0CLEARED.
> Illegal block #2065 (819202) in inode 7. =A0CLEARED.
> Illegal block #2066 (884738) in inode 7. =A0CLEARED.
> Illegal block #3088 (294915) in inode 7. =A0CLEARED.
> Illegal block #3089 (819203) in inode 7. =A0CLEARED.
> Illegal block #3090 (884739) in inode 7. =A0CLEARED.
> Illegal block #4112 (294916) in inode 7. =A0CLEARED.
> Illegal block #4113 (819204) in inode 7. =A0CLEARED.
> Illegal block #4114 (884740) in inode 7. =A0CLEARED.
> Illegal block #5136 (294917) in inode 7. =A0CLEARED.
> Illegal block #5137 (819205) in inode 7. =A0CLEARED.
> Too many illegal blocks in inode 7.
> Clear inode<y>? yes
>
> Restarting e2fsck from the beginning...
> Resize inode not valid. =A0Recreate<y>? yes
>
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Block bitmap differences: =A0-(8022--20357)
> Fix<y>? yes
>
> Free blocks count wrong for group #0 (24745, counted=3D24746).
> Fix<y>? yes
>
> Free blocks count wrong (226190, counted=3D226191).
> Fix<y>? yes
>
>
> a.img: ***** FILE SYSTEM WAS MODIFIED *****
> a.img: 20864/65536 files (0.0% non-contiguous), 35953/262144 blocks
> $
>
> $ dumpe2fs a.img
> dumpe2fs 1.42-WIP (02-Jul-2011)
> Filesystem volume name: =A0 <none>
> Last mounted on: =A0 =A0 =A0 =A0 =A0/mnt
> Filesystem UUID: =A0 =A0 =A0 =A0 =A04f2361c3-2755-4a6a-bf28-dd7e1a4dd=
772
> Filesystem magic number: =A00xEF53
> Filesystem revision #: =A0 =A01 (dynamic)
> Filesystem features: =A0 =A0 =A0has_journal ext_attr resize_inode dir=
_index filetype extent flex_bg sparse_super large_file huge_file uninit=
_bg dir_nlink extra_isize
> Filesystem flags: =A0 =A0 =A0 =A0 signed_directory_hash
> Default mount options: =A0 =A0user_xattr acl
> Filesystem state: =A0 =A0 =A0 =A0 clean
> Errors behavior: =A0 =A0 =A0 =A0 =A0Continue
> Filesystem OS type: =A0 =A0 =A0 Linux
> Inode count: =A0 =A0 =A0 =A0 =A0 =A0 =A065536
> Block count: =A0 =A0 =A0 =A0 =A0 =A0 =A0262144
> Reserved block count: =A0 =A0 13107
> Free blocks: =A0 =A0 =A0 =A0 =A0 =A0 =A0226191
> Free inodes: =A0 =A0 =A0 =A0 =A0 =A0 =A044672
> First block: =A0 =A0 =A0 =A0 =A0 =A0 =A00
> Block size: =A0 =A0 =A0 =A0 =A0 =A0 =A0 4096
> Fragment size: =A0 =A0 =A0 =A0 =A0 =A04096
> Reserved GDT blocks: =A0 =A0 =A063
> Blocks per group: =A0 =A0 =A0 =A0 32768
> Fragments per group: =A0 =A0 =A032768
> Inodes per group: =A0 =A0 =A0 =A0 8192
> Inode blocks per group: =A0 512
> Flex block group size: =A0 =A032
> Filesystem created: =A0 =A0 =A0 Tue Aug =A02 02:29:45 2011
> Last mount time: =A0 =A0 =A0 =A0 =A0Tue Aug =A02 02:29:50 2011
> Last write time: =A0 =A0 =A0 =A0 =A0Tue Aug =A02 02:32:29 2011
> Mount count: =A0 =A0 =A0 =A0 =A0 =A0 =A00
> Maximum mount count: =A0 =A0 =A020
> Last checked: =A0 =A0 =A0 =A0 =A0 =A0 Tue Aug =A02 02:32:29 2011
> Check interval: =A0 =A0 =A0 =A0 =A0 0 (<none>)
> Lifetime writes: =A0 =A0 =A0 =A0 =A0742 kB
> Reserved blocks uid: =A0 =A0 =A00 (user root)
> Reserved blocks gid: =A0 =A0 =A00 (group root)
> First inode: =A0 =A0 =A0 =A0 =A0 =A0 =A011
> Inode size: =A0 =A0 =A0 =A0 =A0 =A0 =A0 256
> Required extra isize: =A0 =A0 28
> Desired extra isize: =A0 =A0 =A028
> Journal inode: =A0 =A0 =A0 =A0 =A0 =A08
> Default directory hash: =A0 half_md4
> Directory Hash Seed: =A0 =A0 =A0a42d0c4e-0207-4fd4-94e7-b71bc107ae90
> Journal backup: =A0 =A0 =A0 =A0 =A0 inode blocks
> Journal features: =A0 =A0 =A0 =A0 (none)
> Journal size: =A0 =A0 =A0 =A0 =A0 =A0 32M
> Journal length: =A0 =A0 =A0 =A0 =A0 8192
> Journal sequence: =A0 =A0 =A0 =A0 0x00000001
> Journal start: =A0 =A0 =A0 =A0 =A0 =A00
>
>
> Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
> =A0Checksum 0x3fe2, unused inodes 0
> =A0Primary superblock at 0, Group descriptors at 1-1
> =A0Reserved GDT blocks at 2-64
> =A0Block bitmap at 65 (+65), Inode bitmap at 97 (+97)
> =A0Inode table at 129-640 (+129)
> =A024746 free blocks, 0 free inodes, 3 directories
> =A0Free blocks: 8022-32767
> =A0Free inodes:
> Group 1: (Blocks 32768-65535) [ITABLE_ZEROED]
> =A0Checksum 0x1361, unused inodes 0
> =A0Backup superblock at 32768, Group descriptors at 32769-32769
> =A0Reserved GDT blocks at 32770-32832
> =A0Block bitmap at 66 (bg #0 + 66), Inode bitmap at 98 (bg #0 + 98)
> =A0Inode table at 641-1152 (bg #0 + 641)
> =A09128 free blocks, 0 free inodes, 975 directories
> =A0Free blocks: 49152-57343, 60376-60383, 60512-61439
> =A0Free inodes:
> Group 2: (Blocks 65536-98303) [ITABLE_ZEROED]
> =A0Checksum 0x3b77, unused inodes 4077
> =A0Block bitmap at 67 (bg #0 + 67), Inode bitmap at 99 (bg #0 + 99)
> =A0Inode table at 1153-1664 (bg #0 + 1153)
> =A028672 free blocks, 4077 free inodes, 2302 directories, 4077 unused=
 inodes
> =A0Free blocks: 69632-98303
> =A0Free inodes: 20500-24576
> Group 3: (Blocks 98304-131071) [ITABLE_ZEROED]
> =A0Checksum 0x372b, unused inodes 7865
> =A0Backup superblock at 98304, Group descriptors at 98305-98305
> =A0Reserved GDT blocks at 98306-98368
> =A0Block bitmap at 68 (bg #0 + 68), Inode bitmap at 100 (bg #0 + 100)
> =A0Inode table at 1665-2176 (bg #0 + 1665)
> =A032703 free blocks, 7865 free inodes, 327 directories, 7865 unused =
inodes
> =A0Free blocks: 98369-131071
> =A0Free inodes: 24904-32768
> Group 4: (Blocks 131072-163839) [ITABLE_ZEROED]
> =A0Checksum 0x4c7a, unused inodes 8154
> =A0Block bitmap at 69 (bg #0 + 69), Inode bitmap at 101 (bg #0 + 101)
> =A0Inode table at 2177-2688 (bg #0 + 2177)
> =A032768 free blocks, 8154 free inodes, 38 directories, 8154 unused i=
nodes
> =A0Free blocks: 131072-163839
> =A0Free inodes: 32807-40960
> Group 5: (Blocks 163840-196607) [INODE_UNINIT, ITABLE_ZEROED]
> =A0Checksum 0xbd51, unused inodes 8192
> =A0Backup superblock at 163840, Group descriptors at 163841-163841
> =A0Reserved GDT blocks at 163842-163904
> =A0Block bitmap at 70 (bg #0 + 70), Inode bitmap at 102 (bg #0 + 102)
> =A0Inode table at 2689-3200 (bg #0 + 2689)
> =A032703 free blocks, 8192 free inodes, 0 directories, 8192 unused in=
odes
> =A0Free blocks: 163905-196607
> =A0Free inodes: 40961-49152
> Group 6: (Blocks 196608-229375) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_Z=
EROED]
> =A0Checksum 0xf453, unused inodes 8192
> =A0Block bitmap at 71 (bg #0 + 71), Inode bitmap at 103 (bg #0 + 103)
> =A0Inode table at 3201-3712 (bg #0 + 3201)
> =A032768 free blocks, 8192 free inodes, 0 directories, 8192 unused in=
odes
> =A0Free blocks: 196608-229375
> =A0Free inodes: 49153-57344
> Group 7: (Blocks 229376-262143) [INODE_UNINIT, ITABLE_ZEROED]
> =A0Checksum 0xfcc2, unused inodes 8192
> =A0Backup superblock at 229376, Group descriptors at 229377-229377
> =A0Reserved GDT blocks at 229378-229440
> =A0Block bitmap at 72 (bg #0 + 72), Inode bitmap at 104 (bg #0 + 104)
> =A0Inode table at 3713-4224 (bg #0 + 3713)
> =A032703 free blocks, 8192 free inodes, 0 directories, 8192 unused in=
odes
> =A0Free blocks: 229441-262143
> =A0Free inodes: 57345-65536
>
> $ truncate -s 4G a.img
>
> $ e2fsck -f a.img
> e2fsck 1.42-WIP (02-Jul-2011)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> a.img: 20864/65536 files (0.0% non-contiguous), 35953/262144 blocks
>
> $ dumpe2fs a.img
> dumpe2fs 1.42-WIP (02-Jul-2011)
> Filesystem volume name: =A0 <none>
> Last mounted on: =A0 =A0 =A0 =A0 =A0/mnt
> Filesystem UUID: =A0 =A0 =A0 =A0 =A04f2361c3-2755-4a6a-bf28-dd7e1a4dd=
772
> Filesystem magic number: =A00xEF53
> Filesystem revision #: =A0 =A01 (dynamic)
> Filesystem features: =A0 =A0 =A0has_journal ext_attr resize_inode dir=
_index filetype extent flex_bg sparse_super large_file huge_file uninit=
_bg dir_nlink extra_isize
> Filesystem flags: =A0 =A0 =A0 =A0 signed_directory_hash
> Default mount options: =A0 =A0user_xattr acl
> Filesystem state: =A0 =A0 =A0 =A0 clean
> Errors behavior: =A0 =A0 =A0 =A0 =A0Continue
> Filesystem OS type: =A0 =A0 =A0 Linux
> Inode count: =A0 =A0 =A0 =A0 =A0 =A0 =A065536
> Block count: =A0 =A0 =A0 =A0 =A0 =A0 =A0262144
> Reserved block count: =A0 =A0 13107
> Free blocks: =A0 =A0 =A0 =A0 =A0 =A0 =A0226191
> Free inodes: =A0 =A0 =A0 =A0 =A0 =A0 =A044672
> First block: =A0 =A0 =A0 =A0 =A0 =A0 =A00
> Block size: =A0 =A0 =A0 =A0 =A0 =A0 =A0 4096
> Fragment size: =A0 =A0 =A0 =A0 =A0 =A04096
> Reserved GDT blocks: =A0 =A0 =A063
> Blocks per group: =A0 =A0 =A0 =A0 32768
> Fragments per group: =A0 =A0 =A032768
> Inodes per group: =A0 =A0 =A0 =A0 8192
> Inode blocks per group: =A0 512
> Flex block group size: =A0 =A032
> Filesystem created: =A0 =A0 =A0 Tue Aug =A02 02:29:45 2011
> Last mount time: =A0 =A0 =A0 =A0 =A0Tue Aug =A02 02:29:50 2011
> Last write time: =A0 =A0 =A0 =A0 =A0Tue Aug =A02 02:33:36 2011
> Mount count: =A0 =A0 =A0 =A0 =A0 =A0 =A00
> Maximum mount count: =A0 =A0 =A020
> Last checked: =A0 =A0 =A0 =A0 =A0 =A0 Tue Aug =A02 02:33:36 2011
> Check interval: =A0 =A0 =A0 =A0 =A0 0 (<none>)
> Lifetime writes: =A0 =A0 =A0 =A0 =A0746 kB
> Reserved blocks uid: =A0 =A0 =A00 (user root)
> Reserved blocks gid: =A0 =A0 =A00 (group root)
> First inode: =A0 =A0 =A0 =A0 =A0 =A0 =A011
> Inode size: =A0 =A0 =A0 =A0 =A0 =A0 =A0 256
> Required extra isize: =A0 =A0 28
> Desired extra isize: =A0 =A0 =A028
> Journal inode: =A0 =A0 =A0 =A0 =A0 =A08
> Default directory hash: =A0 half_md4
> Directory Hash Seed: =A0 =A0 =A0a42d0c4e-0207-4fd4-94e7-b71bc107ae90
> Journal backup: =A0 =A0 =A0 =A0 =A0 inode blocks
> Journal features: =A0 =A0 =A0 =A0 (none)
> Journal size: =A0 =A0 =A0 =A0 =A0 =A0 32M
> Journal length: =A0 =A0 =A0 =A0 =A0 8192
> Journal sequence: =A0 =A0 =A0 =A0 0x00000001
> Journal start: =A0 =A0 =A0 =A0 =A0 =A00
>
>
> Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
> =A0Checksum 0x3fe2, unused inodes 0
> =A0Primary superblock at 0, Group descriptors at 1-1
> =A0Reserved GDT blocks at 2-64
> =A0Block bitmap at 65 (+65), Inode bitmap at 97 (+97)
> =A0Inode table at 129-640 (+129)
> =A024746 free blocks, 0 free inodes, 3 directories
> =A0Free blocks: 8022-32767
> =A0Free inodes:
> Group 1: (Blocks 32768-65535) [ITABLE_ZEROED]
> =A0Checksum 0x1361, unused inodes 0
> =A0Backup superblock at 32768, Group descriptors at 32769-32769
> =A0Reserved GDT blocks at 32770-32832
> =A0Block bitmap at 66 (bg #0 + 66), Inode bitmap at 98 (bg #0 + 98)
> =A0Inode table at 641-1152 (bg #0 + 641)
> =A09128 free blocks, 0 free inodes, 975 directories
> =A0Free blocks: 49152-57343, 60376-60383, 60512-61439
> =A0Free inodes:
> Group 2: (Blocks 65536-98303) [ITABLE_ZEROED]
> =A0Checksum 0x3b77, unused inodes 4077
> =A0Block bitmap at 67 (bg #0 + 67), Inode bitmap at 99 (bg #0 + 99)
> =A0Inode table at 1153-1664 (bg #0 + 1153)
> =A028672 free blocks, 4077 free inodes, 2302 directories, 4077 unused=
 inodes
> =A0Free blocks: 69632-98303
> =A0Free inodes: 20500-24576
> Group 3: (Blocks 98304-131071) [ITABLE_ZEROED]
> =A0Checksum 0x372b, unused inodes 7865
> =A0Backup superblock at 98304, Group descriptors at 98305-98305
> =A0Reserved GDT blocks at 98306-98368
> =A0Block bitmap at 68 (bg #0 + 68), Inode bitmap at 100 (bg #0 + 100)
> =A0Inode table at 1665-2176 (bg #0 + 1665)
> =A032703 free blocks, 7865 free inodes, 327 directories, 7865 unused =
inodes
> =A0Free blocks: 98369-131071
> =A0Free inodes: 24904-32768
> Group 4: (Blocks 131072-163839) [ITABLE_ZEROED]
> =A0Checksum 0x4c7a, unused inodes 8154
> =A0Block bitmap at 69 (bg #0 + 69), Inode bitmap at 101 (bg #0 + 101)
> =A0Inode table at 2177-2688 (bg #0 + 2177)
> =A032768 free blocks, 8154 free inodes, 38 directories, 8154 unused i=
nodes
> =A0Free blocks: 131072-163839
> =A0Free inodes: 32807-40960
> Group 5: (Blocks 163840-196607) [INODE_UNINIT, ITABLE_ZEROED]
> =A0Checksum 0xbd51, unused inodes 8192
> =A0Backup superblock at 163840, Group descriptors at 163841-163841
> =A0Reserved GDT blocks at 163842-163904
> =A0Block bitmap at 70 (bg #0 + 70), Inode bitmap at 102 (bg #0 + 102)
> =A0Inode table at 2689-3200 (bg #0 + 2689)
> =A032703 free blocks, 8192 free inodes, 0 directories, 8192 unused in=
odes
> =A0Free blocks: 163905-196607
> =A0Free inodes: 40961-49152
> Group 6: (Blocks 196608-229375) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_Z=
EROED]
> =A0Checksum 0xf453, unused inodes 8192
> =A0Block bitmap at 71 (bg #0 + 71), Inode bitmap at 103 (bg #0 + 103)
> =A0Inode table at 3201-3712 (bg #0 + 3201)
> =A032768 free blocks, 8192 free inodes, 0 directories, 8192 unused in=
odes
> =A0Free blocks: 196608-229375
> =A0Free inodes: 49153-57344
> Group 7: (Blocks 229376-262143) [INODE_UNINIT, ITABLE_ZEROED]
> =A0Checksum 0xfcc2, unused inodes 8192
> =A0Backup superblock at 229376, Group descriptors at 229377-229377
> =A0Reserved GDT blocks at 229378-229440
> =A0Block bitmap at 72 (bg #0 + 72), Inode bitmap at 104 (bg #0 + 104)
> =A0Inode table at 3713-4224 (bg #0 + 3713)
> =A032703 free blocks, 8192 free inodes, 0 directories, 8192 unused in=
odes
> =A0Free blocks: 229441-262143
> =A0Free inodes: 57345-65536
>
> $ sudo mount -t ext4 -o loop a.img /mnt/
> $ df
> [...]
> /dev/loop0 =A0 =A0 =A0 =A0 =A0 =A0 1032088 =A0 =A0127324 =A0 =A085233=
6 =A013% /mnt
>
> $ sudo umount /mnt
> -----------------------------------------
> -----------------------------------------
> -----------------------------------------
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
