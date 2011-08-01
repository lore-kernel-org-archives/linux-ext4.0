From: Round Robinjp <roundrobinjp@yahoo.co.jp>
Subject: Re: flashing large eMMC partitions with ext4
Date: Tue, 2 Aug 2011 02:43:20 +0900 (JST)
Message-ID: <632658.72291.qm@web4207.mail.ogk.yahoo.co.jp>
References: <CAOQ4uxh6a1qoZZs2SVxxrKfcd5q0vKkpCMDQ-X5eur3Tg07FXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Andreas Dilger <aedilger@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Goldstein Amir <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web4207.mail.ogk.yahoo.co.jp ([124.83.212.27]:47124 "HELO
	web4207.mail.ogk.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753899Ab1HARnb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Aug 2011 13:43:31 -0400
In-Reply-To: <CAOQ4uxh6a1qoZZs2SVxxrKfcd5q0vKkpCMDQ-X5eur3Tg07FXg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I meant using a newer version of resize2fs (which you do not have),

I have now corrected this and other mistakes.
But when I mount the image after finally extending
to 4G, the df still shows the size as 1G.
Am I still doing something wrong?

Full log below:

-----------------------------------------
-----------------------------------------
-----------------------------------------
$ dd if=/dev/zero of=a.img bs=4K count=256K
262144+0 records in
262144+0 records out
1073741824 bytes (1.1 GB) copied, 4.09006 s, 263 MB/s

$ mkfs.ext4 -O ^has_journal,flex_bg -G 32 -E resize=4G a.img
mke2fs 1.42-WIP (02-Jul-2011)
a.img is not a block special device.
Proceed anyway? (y,n) y
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
65536 inodes, 262144 blocks
13107 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=268435456
8 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376

Allocating group tables: done
Writing inode tables: done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 0 mounts or
0 days, whichever comes first.  Use tune2fs -c or -i to override.

$ sudo mount -t ext4 -o loop a.img /mnt/
$ du -sh /usr/src/
92M     /usr/src/
$ cp -a /usr/src/* /mnt/

$ e2fsck -f a.img
e2fsck 1.42-WIP (02-Jul-2011)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (242859, counted=237788).
Fix<y>? yes

Free inodes count wrong (55821, counted=52249).
Fix<y>? yes


a.img: ***** FILE SYSTEM WAS MODIFIED *****
a.img: 13287/65536 files (0.0% non-contiguous), 24356/262144 blocks

$ resize2fs a.img 4G
resize2fs 1.42-WIP (02-Jul-2011)
Please run 'e2fsck -f a.img' first.

$ e2fsck -f a.img
e2fsck 1.42-WIP (02-Jul-2011)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
a.img: 20864/65536 files (0.0% non-contiguous), 27067/262144 blocks

$ resize2fs a.img 4G
resize2fs 1.42-WIP (02-Jul-2011)
Resizing the filesystem on a.img to 1048576 (4k) blocks.
The filesystem on a.img is now 1048576 blocks long.

$ sudo tune2fs -O has_journal /dev/loop0
tune2fs 1.42-WIP (02-Jul-2011)
Creating journal inode: done
This filesystem will be automatically checked every 20 mounts or
0 days, whichever comes first.  Use tune2fs -c or -i to override.

$ sudo umount /mnt

$ dumpe2fs a.img
dumpe2fs 1.42-WIP (02-Jul-2011)
Filesystem volume name:   <none>
Last mounted on:          /mnt
Filesystem UUID:          4f2361c3-2755-4a6a-bf28-dd7e1a4dd772
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              65536
Block count:              262144
Reserved block count:     13107
Free blocks:              226191
Free inodes:              44671
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      63
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    32
Filesystem created:       Tue Aug  2 02:29:45 2011
Last mount time:          Tue Aug  2 02:29:50 2011
Last write time:          Tue Aug  2 02:31:01 2011
Mount count:              1
Maximum mount count:      20
Last checked:             Tue Aug  2 02:29:45 2011
Check interval:           0 (<none>)
Lifetime writes:          406 kB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            20500
Default directory hash:   half_md4
Directory Hash Seed:      a42d0c4e-0207-4fd4-94e7-b71bc107ae90
Journal features:         (none)
Journal size:             32M
Journal length:           8192
Journal sequence:         0x00000001
Journal start:            0


Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
  Checksum 0x3fe2, unused inodes 0
  Primary superblock at 0, Group descriptors at 1-1
  Reserved GDT blocks at 2-64
  Block bitmap at 65 (+65), Inode bitmap at 97 (+97)
  Inode table at 129-640 (+129)
  24746 free blocks, 0 free inodes, 3 directories
  Free blocks: 20358-32767
  Free inodes:
Group 1: (Blocks 32768-65535) [ITABLE_ZEROED]
  Checksum 0x1361, unused inodes 0
  Backup superblock at 32768, Group descriptors at 32769-32769
  Reserved GDT blocks at 32770-32832
  Block bitmap at 66 (bg #0 + 66), Inode bitmap at 98 (bg #0 + 98)
  Inode table at 641-1152 (bg #0 + 641)
  9128 free blocks, 0 free inodes, 975 directories
  Free blocks: 49152-57343, 60376-60383, 60512-61439
  Free inodes:
Group 2: (Blocks 65536-98303) [ITABLE_ZEROED]
  Checksum 0x3bb7, unused inodes 4076
  Block bitmap at 67 (bg #0 + 67), Inode bitmap at 99 (bg #0 + 99)
  Inode table at 1153-1664 (bg #0 + 1153)
  28672 free blocks, 4076 free inodes, 2302 directories, 4076 unused inodes
  Free blocks: 69632-98303
  Free inodes: 20501-24576
Group 3: (Blocks 98304-131071) [ITABLE_ZEROED]
  Checksum 0x372b, unused inodes 7865
  Backup superblock at 98304, Group descriptors at 98305-98305
  Reserved GDT blocks at 98306-98368
  Block bitmap at 68 (bg #0 + 68), Inode bitmap at 100 (bg #0 + 100)
  Inode table at 1665-2176 (bg #0 + 1665)
  32703 free blocks, 7865 free inodes, 327 directories, 7865 unused inodes
  Free blocks: 98369-131071
  Free inodes: 24904-32768
Group 4: (Blocks 131072-163839) [ITABLE_ZEROED]
  Checksum 0x4c7a, unused inodes 8154
  Block bitmap at 69 (bg #0 + 69), Inode bitmap at 101 (bg #0 + 101)
  Inode table at 2177-2688 (bg #0 + 2177)
  32768 free blocks, 8154 free inodes, 38 directories, 8154 unused inodes
  Free blocks: 131072-163839
  Free inodes: 32807-40960
Group 5: (Blocks 163840-196607) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xbd51, unused inodes 8192
  Backup superblock at 163840, Group descriptors at 163841-163841
  Reserved GDT blocks at 163842-163904
  Block bitmap at 70 (bg #0 + 70), Inode bitmap at 102 (bg #0 + 102)
  Inode table at 2689-3200 (bg #0 + 2689)
  32703 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 163905-196607
  Free inodes: 40961-49152
Group 6: (Blocks 196608-229375) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Checksum 0xf453, unused inodes 8192
  Block bitmap at 71 (bg #0 + 71), Inode bitmap at 103 (bg #0 + 103)
  Inode table at 3201-3712 (bg #0 + 3201)
  32768 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 196608-229375
  Free inodes: 49153-57344
Group 7: (Blocks 229376-262143) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xfcc2, unused inodes 8192
  Backup superblock at 229376, Group descriptors at 229377-229377
  Reserved GDT blocks at 229378-229440
  Block bitmap at 72 (bg #0 + 72), Inode bitmap at 104 (bg #0 + 104)
  Inode table at 3713-4224 (bg #0 + 3713)
  32703 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 229441-262143
  Free inodes: 57345-65536

$ truncate -s 1G a.img

$ e2fsck -f a.img
e2fsck 1.42-WIP (02-Jul-2011)
Backing up journal inode block information.

Moving journal from /.journal to hidden inode.

Pass 1: Checking inodes, blocks, and sizes
Inode 7 has illegal block(s).  Clear<y>? yes

Illegal block #2064 (294914) in inode 7.  CLEARED.
Illegal block #2065 (819202) in inode 7.  CLEARED.
Illegal block #2066 (884738) in inode 7.  CLEARED.
Illegal block #3088 (294915) in inode 7.  CLEARED.
Illegal block #3089 (819203) in inode 7.  CLEARED.
Illegal block #3090 (884739) in inode 7.  CLEARED.
Illegal block #4112 (294916) in inode 7.  CLEARED.
Illegal block #4113 (819204) in inode 7.  CLEARED.
Illegal block #4114 (884740) in inode 7.  CLEARED.
Illegal block #5136 (294917) in inode 7.  CLEARED.
Illegal block #5137 (819205) in inode 7.  CLEARED.
Too many illegal blocks in inode 7.
Clear inode<y>? yes

Restarting e2fsck from the beginning...
Resize inode not valid.  Recreate<y>? yes

Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -(8022--20357)
Fix<y>? yes

Free blocks count wrong for group #0 (24745, counted=24746).
Fix<y>? yes

Free blocks count wrong (226190, counted=226191).
Fix<y>? yes


a.img: ***** FILE SYSTEM WAS MODIFIED *****
a.img: 20864/65536 files (0.0% non-contiguous), 35953/262144 blocks
$

$ dumpe2fs a.img
dumpe2fs 1.42-WIP (02-Jul-2011)
Filesystem volume name:   <none>
Last mounted on:          /mnt
Filesystem UUID:          4f2361c3-2755-4a6a-bf28-dd7e1a4dd772
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              65536
Block count:              262144
Reserved block count:     13107
Free blocks:              226191
Free inodes:              44672
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      63
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    32
Filesystem created:       Tue Aug  2 02:29:45 2011
Last mount time:          Tue Aug  2 02:29:50 2011
Last write time:          Tue Aug  2 02:32:29 2011
Mount count:              0
Maximum mount count:      20
Last checked:             Tue Aug  2 02:32:29 2011
Check interval:           0 (<none>)
Lifetime writes:          742 kB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      a42d0c4e-0207-4fd4-94e7-b71bc107ae90
Journal backup:           inode blocks
Journal features:         (none)
Journal size:             32M
Journal length:           8192
Journal sequence:         0x00000001
Journal start:            0


Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
  Checksum 0x3fe2, unused inodes 0
  Primary superblock at 0, Group descriptors at 1-1
  Reserved GDT blocks at 2-64
  Block bitmap at 65 (+65), Inode bitmap at 97 (+97)
  Inode table at 129-640 (+129)
  24746 free blocks, 0 free inodes, 3 directories
  Free blocks: 8022-32767
  Free inodes:
Group 1: (Blocks 32768-65535) [ITABLE_ZEROED]
  Checksum 0x1361, unused inodes 0
  Backup superblock at 32768, Group descriptors at 32769-32769
  Reserved GDT blocks at 32770-32832
  Block bitmap at 66 (bg #0 + 66), Inode bitmap at 98 (bg #0 + 98)
  Inode table at 641-1152 (bg #0 + 641)
  9128 free blocks, 0 free inodes, 975 directories
  Free blocks: 49152-57343, 60376-60383, 60512-61439
  Free inodes:
Group 2: (Blocks 65536-98303) [ITABLE_ZEROED]
  Checksum 0x3b77, unused inodes 4077
  Block bitmap at 67 (bg #0 + 67), Inode bitmap at 99 (bg #0 + 99)
  Inode table at 1153-1664 (bg #0 + 1153)
  28672 free blocks, 4077 free inodes, 2302 directories, 4077 unused inodes
  Free blocks: 69632-98303
  Free inodes: 20500-24576
Group 3: (Blocks 98304-131071) [ITABLE_ZEROED]
  Checksum 0x372b, unused inodes 7865
  Backup superblock at 98304, Group descriptors at 98305-98305
  Reserved GDT blocks at 98306-98368
  Block bitmap at 68 (bg #0 + 68), Inode bitmap at 100 (bg #0 + 100)
  Inode table at 1665-2176 (bg #0 + 1665)
  32703 free blocks, 7865 free inodes, 327 directories, 7865 unused inodes
  Free blocks: 98369-131071
  Free inodes: 24904-32768
Group 4: (Blocks 131072-163839) [ITABLE_ZEROED]
  Checksum 0x4c7a, unused inodes 8154
  Block bitmap at 69 (bg #0 + 69), Inode bitmap at 101 (bg #0 + 101)
  Inode table at 2177-2688 (bg #0 + 2177)
  32768 free blocks, 8154 free inodes, 38 directories, 8154 unused inodes
  Free blocks: 131072-163839
  Free inodes: 32807-40960
Group 5: (Blocks 163840-196607) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xbd51, unused inodes 8192
  Backup superblock at 163840, Group descriptors at 163841-163841
  Reserved GDT blocks at 163842-163904
  Block bitmap at 70 (bg #0 + 70), Inode bitmap at 102 (bg #0 + 102)
  Inode table at 2689-3200 (bg #0 + 2689)
  32703 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 163905-196607
  Free inodes: 40961-49152
Group 6: (Blocks 196608-229375) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Checksum 0xf453, unused inodes 8192
  Block bitmap at 71 (bg #0 + 71), Inode bitmap at 103 (bg #0 + 103)
  Inode table at 3201-3712 (bg #0 + 3201)
  32768 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 196608-229375
  Free inodes: 49153-57344
Group 7: (Blocks 229376-262143) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xfcc2, unused inodes 8192
  Backup superblock at 229376, Group descriptors at 229377-229377
  Reserved GDT blocks at 229378-229440
  Block bitmap at 72 (bg #0 + 72), Inode bitmap at 104 (bg #0 + 104)
  Inode table at 3713-4224 (bg #0 + 3713)
  32703 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 229441-262143
  Free inodes: 57345-65536

$ truncate -s 4G a.img

$ e2fsck -f a.img
e2fsck 1.42-WIP (02-Jul-2011)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
a.img: 20864/65536 files (0.0% non-contiguous), 35953/262144 blocks

$ dumpe2fs a.img
dumpe2fs 1.42-WIP (02-Jul-2011)
Filesystem volume name:   <none>
Last mounted on:          /mnt
Filesystem UUID:          4f2361c3-2755-4a6a-bf28-dd7e1a4dd772
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              65536
Block count:              262144
Reserved block count:     13107
Free blocks:              226191
Free inodes:              44672
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      63
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    32
Filesystem created:       Tue Aug  2 02:29:45 2011
Last mount time:          Tue Aug  2 02:29:50 2011
Last write time:          Tue Aug  2 02:33:36 2011
Mount count:              0
Maximum mount count:      20
Last checked:             Tue Aug  2 02:33:36 2011
Check interval:           0 (<none>)
Lifetime writes:          746 kB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      a42d0c4e-0207-4fd4-94e7-b71bc107ae90
Journal backup:           inode blocks
Journal features:         (none)
Journal size:             32M
Journal length:           8192
Journal sequence:         0x00000001
Journal start:            0


Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
  Checksum 0x3fe2, unused inodes 0
  Primary superblock at 0, Group descriptors at 1-1
  Reserved GDT blocks at 2-64
  Block bitmap at 65 (+65), Inode bitmap at 97 (+97)
  Inode table at 129-640 (+129)
  24746 free blocks, 0 free inodes, 3 directories
  Free blocks: 8022-32767
  Free inodes:
Group 1: (Blocks 32768-65535) [ITABLE_ZEROED]
  Checksum 0x1361, unused inodes 0
  Backup superblock at 32768, Group descriptors at 32769-32769
  Reserved GDT blocks at 32770-32832
  Block bitmap at 66 (bg #0 + 66), Inode bitmap at 98 (bg #0 + 98)
  Inode table at 641-1152 (bg #0 + 641)
  9128 free blocks, 0 free inodes, 975 directories
  Free blocks: 49152-57343, 60376-60383, 60512-61439
  Free inodes:
Group 2: (Blocks 65536-98303) [ITABLE_ZEROED]
  Checksum 0x3b77, unused inodes 4077
  Block bitmap at 67 (bg #0 + 67), Inode bitmap at 99 (bg #0 + 99)
  Inode table at 1153-1664 (bg #0 + 1153)
  28672 free blocks, 4077 free inodes, 2302 directories, 4077 unused inodes
  Free blocks: 69632-98303
  Free inodes: 20500-24576
Group 3: (Blocks 98304-131071) [ITABLE_ZEROED]
  Checksum 0x372b, unused inodes 7865
  Backup superblock at 98304, Group descriptors at 98305-98305
  Reserved GDT blocks at 98306-98368
  Block bitmap at 68 (bg #0 + 68), Inode bitmap at 100 (bg #0 + 100)
  Inode table at 1665-2176 (bg #0 + 1665)
  32703 free blocks, 7865 free inodes, 327 directories, 7865 unused inodes
  Free blocks: 98369-131071
  Free inodes: 24904-32768
Group 4: (Blocks 131072-163839) [ITABLE_ZEROED]
  Checksum 0x4c7a, unused inodes 8154
  Block bitmap at 69 (bg #0 + 69), Inode bitmap at 101 (bg #0 + 101)
  Inode table at 2177-2688 (bg #0 + 2177)
  32768 free blocks, 8154 free inodes, 38 directories, 8154 unused inodes
  Free blocks: 131072-163839
  Free inodes: 32807-40960
Group 5: (Blocks 163840-196607) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xbd51, unused inodes 8192
  Backup superblock at 163840, Group descriptors at 163841-163841
  Reserved GDT blocks at 163842-163904
  Block bitmap at 70 (bg #0 + 70), Inode bitmap at 102 (bg #0 + 102)
  Inode table at 2689-3200 (bg #0 + 2689)
  32703 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 163905-196607
  Free inodes: 40961-49152
Group 6: (Blocks 196608-229375) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Checksum 0xf453, unused inodes 8192
  Block bitmap at 71 (bg #0 + 71), Inode bitmap at 103 (bg #0 + 103)
  Inode table at 3201-3712 (bg #0 + 3201)
  32768 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 196608-229375
  Free inodes: 49153-57344
Group 7: (Blocks 229376-262143) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xfcc2, unused inodes 8192
  Backup superblock at 229376, Group descriptors at 229377-229377
  Reserved GDT blocks at 229378-229440
  Block bitmap at 72 (bg #0 + 72), Inode bitmap at 104 (bg #0 + 104)
  Inode table at 3713-4224 (bg #0 + 3713)
  32703 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 229441-262143
  Free inodes: 57345-65536

$ sudo mount -t ext4 -o loop a.img /mnt/
$ df
[...]
/dev/loop0             1032088    127324    852336  13% /mnt

$ sudo umount /mnt
-----------------------------------------
-----------------------------------------
-----------------------------------------
