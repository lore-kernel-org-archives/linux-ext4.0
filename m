From: Round Robinjp <roundrobinjp@yahoo.co.jp>
Subject: Re: flashing large eMMC partitions with ext4
Date: Tue, 2 Aug 2011 15:53:34 +0900 (JST)
Message-ID: <20110802065341.68045.qmail@web4211.mail.ogk.yahoo.co.jp>
References: <CAOQ4uxibcjyELHArqut2PbMShUhqM8d4YxOppZGVkCKk_7BaDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Dilger Andreas <aedilger@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Goldstein Amir <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web4211.mail.ogk.yahoo.co.jp ([124.83.212.31]:27965 "HELO
	web4211.mail.ogk.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751011Ab1HBGxo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Aug 2011 02:53:44 -0400
In-Reply-To: <CAOQ4uxibcjyELHArqut2PbMShUhqM8d4YxOppZGVkCKk_7BaDg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Amir

> create the initial a.img 4G and specify 1G to mkfs.
> so the loop device size is 4G and you can online resize the fs to 4G.

I think this time I have been able to achieve what I was
trying to.

After resize, there are 1048576 blocks, as expected.
After truncating to 1G, dumpe2fs gives error, but I guess
this is also expected behaviour.

But after extending to 4G, e2fsck makes some complain.
I guess this is not expected behaviour, is it?

However, now df shows 4G as the fs size, which is as expected.

Log:
--------------------------------
--------------------------------
--------------------------------
$ dd if=/dev/zero of=a.img bs=4K count=1024K
1048576+0 records in
1048576+0 records out
4294967296 bytes (4.3 GB) copied, 14.2708 s, 301 MB/s

$ mkfs.ext4 -O ^has_journal,flex_bg -G 32 -E resize=4G -b 4096 a.img 262144
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

$ cp -a /usr/src/* /mnt/

$ sudo resize2fs /dev/loop0
resize2fs 1.42-WIP (02-Jul-2011)
Filesystem at /dev/loop0 is mounted on /mnt; on-line resizing required
old desc_blocks = 1, new_desc_blocks = 1
Performing an on-line resize of /dev/loop0 to 1048576 (4k) blocks.
The filesystem on /dev/loop0 is now 1048576 blocks long.

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
Filesystem UUID:          f5a32b70-423d-448a-9550-90d67ff8b247
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              262144
Block count:              1048576
Reserved block count:     52419
Free blocks:              975516
Free inodes:              241279
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      63
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    32
Filesystem created:       Tue Aug  2 14:55:16 2011
Last mount time:          Tue Aug  2 14:55:24 2011
Last write time:          Tue Aug  2 15:33:06 2011
Mount count:              1
Maximum mount count:      20
Last checked:             Tue Aug  2 14:55:16 2011
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
Directory Hash Seed:      6aa182f8-2ce9-4b90-9138-51b2fcf09ff0
Journal features:         (none)
Journal size:             128M
Journal length:           32768
Journal sequence:         0x00000001
Journal start:            0


Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
  Checksum 0x6170, unused inodes 0
  Primary superblock at 0, Group descriptors at 1-1
  Reserved GDT blocks at 2-64
  Block bitmap at 65 (+65), Inode bitmap at 97 (+97)
  Inode table at 129-640 (+129)
  24746 free blocks, 0 free inodes, 3 directories
  Free blocks: 8022-32767
  Free inodes:
Group 1: (Blocks 32768-65535) [ITABLE_ZEROED]
  Checksum 0x4df3, unused inodes 0
  Backup superblock at 32768, Group descriptors at 32769-32769
  Reserved GDT blocks at 32770-32832
  Block bitmap at 66 (bg #0 + 66), Inode bitmap at 98 (bg #0 + 98)
  Inode table at 641-1152 (bg #0 + 641)
  9128 free blocks, 0 free inodes, 975 directories
  Free blocks: 49152-57343, 60376-60383, 60512-61439
  Free inodes:
Group 2: (Blocks 65536-98303) [ITABLE_ZEROED]
  Checksum 0x7b0d, unused inodes 4076
  Block bitmap at 67 (bg #0 + 67), Inode bitmap at 99 (bg #0 + 99)
  Inode table at 1153-1664 (bg #0 + 1153)
  4096 free blocks, 4076 free inodes, 2302 directories, 4076 unused inodes
  Free blocks: 94208-98303
  Free inodes: 20501-24576
Group 3: (Blocks 98304-131071) [ITABLE_ZEROED]
  Checksum 0x69b9, unused inodes 7865
  Backup superblock at 98304, Group descriptors at 98305-98305
  Reserved GDT blocks at 98306-98368
  Block bitmap at 68 (bg #0 + 68), Inode bitmap at 100 (bg #0 + 100)
  Inode table at 1665-2176 (bg #0 + 1665)
  32703 free blocks, 7865 free inodes, 327 directories, 7865 unused inodes
  Free blocks: 98369-131071
  Free inodes: 24904-32768
Group 4: (Blocks 131072-163839) [ITABLE_ZEROED]
  Checksum 0x12e8, unused inodes 8154
  Block bitmap at 69 (bg #0 + 69), Inode bitmap at 101 (bg #0 + 101)
  Inode table at 2177-2688 (bg #0 + 2177)
  32768 free blocks, 8154 free inodes, 38 directories, 8154 unused inodes
  Free blocks: 131072-163839
  Free inodes: 32807-40960
Group 5: (Blocks 163840-196607) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xe3c3, unused inodes 8192
  Backup superblock at 163840, Group descriptors at 163841-163841
  Reserved GDT blocks at 163842-163904
  Block bitmap at 70 (bg #0 + 70), Inode bitmap at 102 (bg #0 + 102)
  Inode table at 2689-3200 (bg #0 + 2689)
  32703 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 163905-196607
  Free inodes: 40961-49152
Group 6: (Blocks 196608-229375) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Checksum 0xaac1, unused inodes 8192
  Block bitmap at 71 (bg #0 + 71), Inode bitmap at 103 (bg #0 + 103)
  Inode table at 3201-3712 (bg #0 + 3201)
  32768 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 196608-229375
  Free inodes: 49153-57344
Group 7: (Blocks 229376-262143) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xa250, unused inodes 8192
  Backup superblock at 229376, Group descriptors at 229377-229377
  Reserved GDT blocks at 229378-229440
  Block bitmap at 72 (bg #0 + 72), Inode bitmap at 104 (bg #0 + 104)
  Inode table at 3713-4224 (bg #0 + 3713)
  32703 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 229441-262143
  Free inodes: 57345-65536
Group 8: (Blocks 262144-294911) [ITABLE_ZEROED]
  Checksum 0x99e5, unused inodes 0
  Block bitmap at 262144 (+0), Inode bitmap at 262145 (+1)
  Inode table at 262146-262657 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
  Free blocks: 262658-294911
  Free inodes: 65537-73728
Group 9: (Blocks 294912-327679) [ITABLE_ZEROED]
  Checksum 0xf08a, unused inodes 0
  Backup superblock at 294912, Group descriptors at 294913-294913
  Reserved GDT blocks at 294914-294976
  Block bitmap at 294977 (+65), Inode bitmap at 294978 (+66)
  Inode table at 294979-295490 (+67)
  32189 free blocks, 8192 free inodes, 0 directories
  Free blocks: 295491-327679
  Free inodes: 73729-81920
Group 10: (Blocks 327680-360447) [ITABLE_ZEROED]
  Checksum 0xc787, unused inodes 0
  Block bitmap at 327680 (+0), Inode bitmap at 327681 (+1)
  Inode table at 327682-328193 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
  Free blocks: 328194-360447
  Free inodes: 81921-90112
Group 11: (Blocks 360448-393215) [ITABLE_ZEROED]
  Checksum 0xe8b6, unused inodes 0
  Block bitmap at 360448 (+0), Inode bitmap at 360449 (+1)
  Inode table at 360450-360961 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
  Free blocks: 360962-393215
  Free inodes: 90113-98304
Group 12: (Blocks 393216-425983) [ITABLE_ZEROED]
  Checksum 0x2521, unused inodes 0
  Block bitmap at 393216 (+0), Inode bitmap at 393217 (+1)
  Inode table at 393218-393729 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
  Free blocks: 393730-425983
  Free inodes: 98305-106496
Group 13: (Blocks 425984-458751) [ITABLE_ZEROED]
  Checksum 0x0a10, unused inodes 0
  Block bitmap at 425984 (+0), Inode bitmap at 425985 (+1)
  Inode table at 425986-426497 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
  Free blocks: 426498-458751
  Free inodes: 106497-114688
Group 14: (Blocks 458752-491519) [ITABLE_ZEROED]
  Checksum 0x7b43, unused inodes 0
  Block bitmap at 458752 (+0), Inode bitmap at 458753 (+1)
  Inode table at 458754-459265 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
  Free blocks: 459266-491519
  Free inodes: 114689-122880
Group 15: (Blocks 491520-524287) [ITABLE_ZEROED]
  Checksum 0x5472, unused inodes 0
  Block bitmap at 491520 (+0), Inode bitmap at 491521 (+1)
  Inode table at 491522-492033 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
  Free blocks: 492034-524287
  Free inodes: 122881-131072
Group 16: (Blocks 524288-557055) [ITABLE_ZEROED]
  Checksum 0xd378, unused inodes 0
  Block bitmap at 524288 (+0), Inode bitmap at 524289 (+1)
  Inode table at 524290-524801 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
  Free blocks: 524802-557055
  Free inodes: 131073-139264
Group 17: (Blocks 557056-589823) [ITABLE_ZEROED]
  Checksum 0xfc49, unused inodes 0
  Block bitmap at 557056 (+0), Inode bitmap at 557057 (+1)
  Inode table at 557058-557569 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
  Free blocks: 557570-589823
  Free inodes: 139265-147456
Group 18: (Blocks 589824-622591) [ITABLE_ZEROED]
  Checksum 0x8d1a, unused inodes 0
  Block bitmap at 589824 (+0), Inode bitmap at 589825 (+1)
  Inode table at 589826-590337 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
  Free blocks: 590338-622591
  Free inodes: 147457-155648
Group 19: (Blocks 622592-655359) [ITABLE_ZEROED]
  Checksum 0xa22b, unused inodes 0
  Block bitmap at 622592 (+0), Inode bitmap at 622593 (+1)
  Inode table at 622594-623105 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
  Free blocks: 623106-655359
  Free inodes: 155649-163840
Group 20: (Blocks 655360-688127) [ITABLE_ZEROED]
  Checksum 0x6fbc, unused inodes 0
  Block bitmap at 655360 (+0), Inode bitmap at 655361 (+1)
  Inode table at 655362-655873 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
  Free blocks: 655874-688127
  Free inodes: 163841-172032
Group 21: (Blocks 688128-720895) [ITABLE_ZEROED]
  Checksum 0x408d, unused inodes 0
  Block bitmap at 688128 (+0), Inode bitmap at 688129 (+1)
  Inode table at 688130-688641 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
  Free blocks: 688642-720895
  Free inodes: 172033-180224
Group 22: (Blocks 720896-753663) [ITABLE_ZEROED]
  Checksum 0x31de, unused inodes 0
  Block bitmap at 720896 (+0), Inode bitmap at 720897 (+1)
  Inode table at 720898-721409 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
  Free blocks: 721410-753663
  Free inodes: 180225-188416
Group 23: (Blocks 753664-786431) [ITABLE_ZEROED]
  Checksum 0x1eef, unused inodes 0
  Block bitmap at 753664 (+0), Inode bitmap at 753665 (+1)
  Inode table at 753666-754177 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
  Free blocks: 754178-786431
  Free inodes: 188417-196608
Group 24: (Blocks 786432-819199) [ITABLE_ZEROED]
  Checksum 0xeaf3, unused inodes 0
  Block bitmap at 786432 (+0), Inode bitmap at 786433 (+1)
  Inode table at 786434-786945 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
  Free blocks: 786946-819199
  Free inodes: 196609-204800
Group 25: (Blocks 819200-851967) [ITABLE_ZEROED]
  Checksum 0x839c, unused inodes 0
  Backup superblock at 819200, Group descriptors at 819201-819201
  Reserved GDT blocks at 819202-819264
  Block bitmap at 819265 (+65), Inode bitmap at 819266 (+66)
  Inode table at 819267-819778 (+67)
  32189 free blocks, 8192 free inodes, 0 directories
  Free blocks: 819779-851967
  Free inodes: 204801-212992
Group 26: (Blocks 851968-884735) [ITABLE_ZEROED]
  Checksum 0xb491, unused inodes 0
  Block bitmap at 851968 (+0), Inode bitmap at 851969 (+1)
  Inode table at 851970-852481 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
  Free blocks: 852482-884735
  Free inodes: 212993-221184
Group 27: (Blocks 884736-917503) [ITABLE_ZEROED]
  Checksum 0xddfe, unused inodes 0
  Backup superblock at 884736, Group descriptors at 884737-884737
  Reserved GDT blocks at 884738-884800
  Block bitmap at 884801 (+65), Inode bitmap at 884802 (+66)
  Inode table at 884803-885314 (+67)
  32189 free blocks, 8192 free inodes, 0 directories
  Free blocks: 885315-917503
  Free inodes: 221185-229376
Group 28: (Blocks 917504-950271) [ITABLE_ZEROED]
  Checksum 0x5637, unused inodes 0
  Block bitmap at 917504 (+0), Inode bitmap at 917505 (+1)
  Inode table at 917506-918017 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
  Free blocks: 918018-950271
  Free inodes: 229377-237568
Group 29: (Blocks 950272-983039) [ITABLE_ZEROED]
  Checksum 0x7906, unused inodes 0
  Block bitmap at 950272 (+0), Inode bitmap at 950273 (+1)
  Inode table at 950274-950785 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
  Free blocks: 950786-983039
  Free inodes: 237569-245760
Group 30: (Blocks 983040-1015807) [ITABLE_ZEROED]
  Checksum 0x0855, unused inodes 0
  Block bitmap at 983040 (+0), Inode bitmap at 983041 (+1)
  Inode table at 983042-983553 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
  Free blocks: 983554-1015807
  Free inodes: 245761-253952
Group 31: (Blocks 1015808-1048575) [ITABLE_ZEROED]
  Checksum 0x2764, unused inodes 0
  Block bitmap at 1015808 (+0), Inode bitmap at 1015809 (+1)
  Inode table at 1015810-1016321 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
  Free blocks: 1016322-1048575
  Free inodes: 253953-262144

$ truncate -s 1G a.img

$ dumpe2fs a.img
dumpe2fs 1.42-WIP (02-Jul-2011)
Filesystem volume name:   <none>
Last mounted on:          /mnt
Filesystem UUID:          f5a32b70-423d-448a-9550-90d67ff8b247
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              262144
Block count:              1048576
Reserved block count:     52419
Free blocks:              975516
Free inodes:              241279
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      63
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    32
Filesystem created:       Tue Aug  2 14:55:16 2011
Last mount time:          Tue Aug  2 14:55:24 2011
Last write time:          Tue Aug  2 15:33:06 2011
Mount count:              1
Maximum mount count:      20
Last checked:             Tue Aug  2 14:55:16 2011
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
Directory Hash Seed:      6aa182f8-2ce9-4b90-9138-51b2fcf09ff0
Journal features:         (none)
Journal size:             128M
Journal length:           32768
Journal sequence:         0x00000001
Journal start:            0


Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
  Checksum 0x6170, unused inodes 0
  Primary superblock at 0, Group descriptors at 1-1
  Reserved GDT blocks at 2-64
  Block bitmap at 65 (+65), Inode bitmap at 97 (+97)
  Inode table at 129-640 (+129)
  24746 free blocks, 0 free inodes, 3 directories
Group 1: (Blocks 32768-65535) [ITABLE_ZEROED]
  Checksum 0x4df3, unused inodes 0
  Backup superblock at 32768, Group descriptors at 32769-32769
  Reserved GDT blocks at 32770-32832
  Block bitmap at 66 (bg #0 + 66), Inode bitmap at 98 (bg #0 + 98)
  Inode table at 641-1152 (bg #0 + 641)
  9128 free blocks, 0 free inodes, 975 directories
Group 2: (Blocks 65536-98303) [ITABLE_ZEROED]
  Checksum 0x7b0d, unused inodes 4076
  Block bitmap at 67 (bg #0 + 67), Inode bitmap at 99 (bg #0 + 99)
  Inode table at 1153-1664 (bg #0 + 1153)
  4096 free blocks, 4076 free inodes, 2302 directories, 4076 unused inodes
Group 3: (Blocks 98304-131071) [ITABLE_ZEROED]
  Checksum 0x69b9, unused inodes 7865
  Backup superblock at 98304, Group descriptors at 98305-98305
  Reserved GDT blocks at 98306-98368
  Block bitmap at 68 (bg #0 + 68), Inode bitmap at 100 (bg #0 + 100)
  Inode table at 1665-2176 (bg #0 + 1665)
  32703 free blocks, 7865 free inodes, 327 directories, 7865 unused inodes
Group 4: (Blocks 131072-163839) [ITABLE_ZEROED]
  Checksum 0x12e8, unused inodes 8154
  Block bitmap at 69 (bg #0 + 69), Inode bitmap at 101 (bg #0 + 101)
  Inode table at 2177-2688 (bg #0 + 2177)
  32768 free blocks, 8154 free inodes, 38 directories, 8154 unused inodes
Group 5: (Blocks 163840-196607) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xe3c3, unused inodes 8192
  Backup superblock at 163840, Group descriptors at 163841-163841
  Reserved GDT blocks at 163842-163904
  Block bitmap at 70 (bg #0 + 70), Inode bitmap at 102 (bg #0 + 102)
  Inode table at 2689-3200 (bg #0 + 2689)
  32703 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
Group 6: (Blocks 196608-229375) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Checksum 0xaac1, unused inodes 8192
  Block bitmap at 71 (bg #0 + 71), Inode bitmap at 103 (bg #0 + 103)
  Inode table at 3201-3712 (bg #0 + 3201)
  32768 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
Group 7: (Blocks 229376-262143) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xa250, unused inodes 8192
  Backup superblock at 229376, Group descriptors at 229377-229377
  Reserved GDT blocks at 229378-229440
  Block bitmap at 72 (bg #0 + 72), Inode bitmap at 104 (bg #0 + 104)
  Inode table at 3713-4224 (bg #0 + 3713)
  32703 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
Group 8: (Blocks 262144-294911) [ITABLE_ZEROED]
  Checksum 0x99e5, unused inodes 0
  Block bitmap at 262144 (+0), Inode bitmap at 262145 (+1)
  Inode table at 262146-262657 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
Group 9: (Blocks 294912-327679) [ITABLE_ZEROED]
  Checksum 0xf08a, unused inodes 0
  Backup superblock at 294912, Group descriptors at 294913-294913
  Reserved GDT blocks at 294914-294976
  Block bitmap at 294977 (+65), Inode bitmap at 294978 (+66)
  Inode table at 294979-295490 (+67)
  32189 free blocks, 8192 free inodes, 0 directories
Group 10: (Blocks 327680-360447) [ITABLE_ZEROED]
  Checksum 0xc787, unused inodes 0
  Block bitmap at 327680 (+0), Inode bitmap at 327681 (+1)
  Inode table at 327682-328193 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
Group 11: (Blocks 360448-393215) [ITABLE_ZEROED]
  Checksum 0xe8b6, unused inodes 0
  Block bitmap at 360448 (+0), Inode bitmap at 360449 (+1)
  Inode table at 360450-360961 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
Group 12: (Blocks 393216-425983) [ITABLE_ZEROED]
  Checksum 0x2521, unused inodes 0
  Block bitmap at 393216 (+0), Inode bitmap at 393217 (+1)
  Inode table at 393218-393729 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
Group 13: (Blocks 425984-458751) [ITABLE_ZEROED]
  Checksum 0x0a10, unused inodes 0
  Block bitmap at 425984 (+0), Inode bitmap at 425985 (+1)
  Inode table at 425986-426497 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
Group 14: (Blocks 458752-491519) [ITABLE_ZEROED]
  Checksum 0x7b43, unused inodes 0
  Block bitmap at 458752 (+0), Inode bitmap at 458753 (+1)
  Inode table at 458754-459265 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
Group 15: (Blocks 491520-524287) [ITABLE_ZEROED]
  Checksum 0x5472, unused inodes 0
  Block bitmap at 491520 (+0), Inode bitmap at 491521 (+1)
  Inode table at 491522-492033 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
Group 16: (Blocks 524288-557055) [ITABLE_ZEROED]
  Checksum 0xd378, unused inodes 0
  Block bitmap at 524288 (+0), Inode bitmap at 524289 (+1)
  Inode table at 524290-524801 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
Group 17: (Blocks 557056-589823) [ITABLE_ZEROED]
  Checksum 0xfc49, unused inodes 0
  Block bitmap at 557056 (+0), Inode bitmap at 557057 (+1)
  Inode table at 557058-557569 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
Group 18: (Blocks 589824-622591) [ITABLE_ZEROED]
  Checksum 0x8d1a, unused inodes 0
  Block bitmap at 589824 (+0), Inode bitmap at 589825 (+1)
  Inode table at 589826-590337 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
Group 19: (Blocks 622592-655359) [ITABLE_ZEROED]
  Checksum 0xa22b, unused inodes 0
  Block bitmap at 622592 (+0), Inode bitmap at 622593 (+1)
  Inode table at 622594-623105 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
Group 20: (Blocks 655360-688127) [ITABLE_ZEROED]
  Checksum 0x6fbc, unused inodes 0
  Block bitmap at 655360 (+0), Inode bitmap at 655361 (+1)
  Inode table at 655362-655873 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
Group 21: (Blocks 688128-720895) [ITABLE_ZEROED]
  Checksum 0x408d, unused inodes 0
  Block bitmap at 688128 (+0), Inode bitmap at 688129 (+1)
  Inode table at 688130-688641 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
Group 22: (Blocks 720896-753663) [ITABLE_ZEROED]
  Checksum 0x31de, unused inodes 0
  Block bitmap at 720896 (+0), Inode bitmap at 720897 (+1)
  Inode table at 720898-721409 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
Group 23: (Blocks 753664-786431) [ITABLE_ZEROED]
  Checksum 0x1eef, unused inodes 0
  Block bitmap at 753664 (+0), Inode bitmap at 753665 (+1)
  Inode table at 753666-754177 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
Group 24: (Blocks 786432-819199) [ITABLE_ZEROED]
  Checksum 0xeaf3, unused inodes 0
  Block bitmap at 786432 (+0), Inode bitmap at 786433 (+1)
  Inode table at 786434-786945 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
Group 25: (Blocks 819200-851967) [ITABLE_ZEROED]
  Checksum 0x839c, unused inodes 0
  Backup superblock at 819200, Group descriptors at 819201-819201
  Reserved GDT blocks at 819202-819264
  Block bitmap at 819265 (+65), Inode bitmap at 819266 (+66)
  Inode table at 819267-819778 (+67)
  32189 free blocks, 8192 free inodes, 0 directories
Group 26: (Blocks 851968-884735) [ITABLE_ZEROED]
  Checksum 0xb491, unused inodes 0
  Block bitmap at 851968 (+0), Inode bitmap at 851969 (+1)
  Inode table at 851970-852481 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
Group 27: (Blocks 884736-917503) [ITABLE_ZEROED]
  Checksum 0xddfe, unused inodes 0
  Backup superblock at 884736, Group descriptors at 884737-884737
  Reserved GDT blocks at 884738-884800
  Block bitmap at 884801 (+65), Inode bitmap at 884802 (+66)
  Inode table at 884803-885314 (+67)
  32189 free blocks, 8192 free inodes, 0 directories
Group 28: (Blocks 917504-950271) [ITABLE_ZEROED]
  Checksum 0x5637, unused inodes 0
  Block bitmap at 917504 (+0), Inode bitmap at 917505 (+1)
  Inode table at 917506-918017 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
Group 29: (Blocks 950272-983039) [ITABLE_ZEROED]
  Checksum 0x7906, unused inodes 0
  Block bitmap at 950272 (+0), Inode bitmap at 950273 (+1)
  Inode table at 950274-950785 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
Group 30: (Blocks 983040-1015807) [ITABLE_ZEROED]
  Checksum 0x0855, unused inodes 0
  Block bitmap at 983040 (+0), Inode bitmap at 983041 (+1)
  Inode table at 983042-983553 (+2)
  32254 free blocks, 8192 free inodes, 0 directories
Group 31: (Blocks 1015808-1048575) [ITABLE_ZEROED]
  Checksum 0x2764, unused inodes 0
  Block bitmap at 1015808 (+0), Inode bitmap at 1015809 (+1)
  Inode table at 1015810-1016321 (+2)
  32254 free blocks, 8192 free inodes, 0 directories

dumpe2fs: a.img: error reading bitmaps: Can't read an block bitmap

$ truncate -s 4G a.img

$ e2fsck -f a.img
e2fsck 1.42-WIP (02-Jul-2011)
Backing up journal inode block information.

Moving journal from /.journal to hidden inode.

Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  +(262144--262657) +(294912--295490) +(327680--328193) +(360448--360961) +(393216--393729) +(425984--426497) +(458752--459265) +(491520--492033) +(524288--524801) +(557056--557569) +(589824--590337) +(622592--623105) +(655360--655873) +(688128--688641) +(720896--721409) +(753664--754177) +(786432--786945) +(819200--819778) +(851968--852481) +(884736--885314) +(917504--918017) +(950272--950785) +(983040--983553) +(1015808--1016321)
Fix<y>? yes


a.img: ***** FILE SYSTEM WAS MODIFIED *****
a.img: 20864/262144 files (0.0% non-contiguous), 73060/1048576 blocks

$ dumpe2fs a.img
dumpe2fs 1.42-WIP (02-Jul-2011)
Filesystem volume name:   <none>
Last mounted on:          /mnt
Filesystem UUID:          f5a32b70-423d-448a-9550-90d67ff8b247
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              262144
Block count:              1048576
Reserved block count:     52419
Free blocks:              975516
Free inodes:              241280
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      63
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    32
Filesystem created:       Tue Aug  2 14:55:16 2011
Last mount time:          Tue Aug  2 14:55:24 2011
Last write time:          Tue Aug  2 15:33:44 2011
Mount count:              0
Maximum mount count:      20
Last checked:             Tue Aug  2 15:33:44 2011
Check interval:           0 (<none>)
Lifetime writes:          566 kB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      6aa182f8-2ce9-4b90-9138-51b2fcf09ff0
Journal backup:           inode blocks
Journal features:         (none)
Journal size:             128M
Journal length:           32768
Journal sequence:         0x00000001
Journal start:            0


Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
  Checksum 0x6170, unused inodes 0
  Primary superblock at 0, Group descriptors at 1-1
  Reserved GDT blocks at 2-64
  Block bitmap at 65 (+65), Inode bitmap at 97 (+97)
  Inode table at 129-640 (+129)
  24746 free blocks, 0 free inodes, 3 directories
  Free blocks: 8022-32767
  Free inodes:
Group 1: (Blocks 32768-65535) [ITABLE_ZEROED]
  Checksum 0x4df3, unused inodes 0
  Backup superblock at 32768, Group descriptors at 32769-32769
  Reserved GDT blocks at 32770-32832
  Block bitmap at 66 (bg #0 + 66), Inode bitmap at 98 (bg #0 + 98)
  Inode table at 641-1152 (bg #0 + 641)
  9128 free blocks, 0 free inodes, 975 directories
  Free blocks: 49152-57343, 60376-60383, 60512-61439
  Free inodes:
Group 2: (Blocks 65536-98303) [ITABLE_ZEROED]
  Checksum 0x7bcd, unused inodes 4077
  Block bitmap at 67 (bg #0 + 67), Inode bitmap at 99 (bg #0 + 99)
  Inode table at 1153-1664 (bg #0 + 1153)
  4096 free blocks, 4077 free inodes, 2302 directories, 4077 unused inodes
  Free blocks: 94208-98303
  Free inodes: 20500-24576
Group 3: (Blocks 98304-131071) [ITABLE_ZEROED]
  Checksum 0x69b9, unused inodes 7865
  Backup superblock at 98304, Group descriptors at 98305-98305
  Reserved GDT blocks at 98306-98368
  Block bitmap at 68 (bg #0 + 68), Inode bitmap at 100 (bg #0 + 100)
  Inode table at 1665-2176 (bg #0 + 1665)
  32703 free blocks, 7865 free inodes, 327 directories, 7865 unused inodes
  Free blocks: 98369-131071
  Free inodes: 24904-32768
Group 4: (Blocks 131072-163839) [ITABLE_ZEROED]
  Checksum 0x12e8, unused inodes 8154
  Block bitmap at 69 (bg #0 + 69), Inode bitmap at 101 (bg #0 + 101)
  Inode table at 2177-2688 (bg #0 + 2177)
  32768 free blocks, 8154 free inodes, 38 directories, 8154 unused inodes
  Free blocks: 131072-163839
  Free inodes: 32807-40960
Group 5: (Blocks 163840-196607) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xe3c3, unused inodes 8192
  Backup superblock at 163840, Group descriptors at 163841-163841
  Reserved GDT blocks at 163842-163904
  Block bitmap at 70 (bg #0 + 70), Inode bitmap at 102 (bg #0 + 102)
  Inode table at 2689-3200 (bg #0 + 2689)
  32703 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 163905-196607
  Free inodes: 40961-49152
Group 6: (Blocks 196608-229375) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Checksum 0xaac1, unused inodes 8192
  Block bitmap at 71 (bg #0 + 71), Inode bitmap at 103 (bg #0 + 103)
  Inode table at 3201-3712 (bg #0 + 3201)
  32768 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 196608-229375
  Free inodes: 49153-57344
Group 7: (Blocks 229376-262143) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xa250, unused inodes 8192
  Backup superblock at 229376, Group descriptors at 229377-229377
  Reserved GDT blocks at 229378-229440
  Block bitmap at 72 (bg #0 + 72), Inode bitmap at 104 (bg #0 + 104)
  Inode table at 3713-4224 (bg #0 + 3713)
  32703 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 229441-262143
  Free inodes: 57345-65536
Group 8: (Blocks 262144-294911) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x8219, unused inodes 8192
  Block bitmap at 262144 (+0), Inode bitmap at 262145 (+1)
  Inode table at 262146-262657 (+2)
  32254 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 262658-294911
  Free inodes: 65537-73728
Group 9: (Blocks 294912-327679) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xeb76, unused inodes 8192
  Backup superblock at 294912, Group descriptors at 294913-294913
  Reserved GDT blocks at 294914-294976
  Block bitmap at 294977 (+65), Inode bitmap at 294978 (+66)
  Inode table at 294979-295490 (+67)
  32189 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 295491-327679
  Free inodes: 73729-81920
Group 10: (Blocks 327680-360447) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xdc7b, unused inodes 8192
  Block bitmap at 327680 (+0), Inode bitmap at 327681 (+1)
  Inode table at 327682-328193 (+2)
  32254 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 328194-360447
  Free inodes: 81921-90112
Group 11: (Blocks 360448-393215) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xf34a, unused inodes 8192
  Block bitmap at 360448 (+0), Inode bitmap at 360449 (+1)
  Inode table at 360450-360961 (+2)
  32254 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 360962-393215
  Free inodes: 90113-98304
Group 12: (Blocks 393216-425983) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x3edd, unused inodes 8192
  Block bitmap at 393216 (+0), Inode bitmap at 393217 (+1)
  Inode table at 393218-393729 (+2)
  32254 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 393730-425983
  Free inodes: 98305-106496
Group 13: (Blocks 425984-458751) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x11ec, unused inodes 8192
  Block bitmap at 425984 (+0), Inode bitmap at 425985 (+1)
  Inode table at 425986-426497 (+2)
  32254 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 426498-458751
  Free inodes: 106497-114688
Group 14: (Blocks 458752-491519) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x60bf, unused inodes 8192
  Block bitmap at 458752 (+0), Inode bitmap at 458753 (+1)
  Inode table at 458754-459265 (+2)
  32254 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 459266-491519
  Free inodes: 114689-122880
Group 15: (Blocks 491520-524287) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x4f8e, unused inodes 8192
  Block bitmap at 491520 (+0), Inode bitmap at 491521 (+1)
  Inode table at 491522-492033 (+2)
  32254 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 492034-524287
  Free inodes: 122881-131072
Group 16: (Blocks 524288-557055) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xc884, unused inodes 8192
  Block bitmap at 524288 (+0), Inode bitmap at 524289 (+1)
  Inode table at 524290-524801 (+2)
  32254 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 524802-557055
  Free inodes: 131073-139264
Group 17: (Blocks 557056-589823) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xe7b5, unused inodes 8192
  Block bitmap at 557056 (+0), Inode bitmap at 557057 (+1)
  Inode table at 557058-557569 (+2)
  32254 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 557570-589823
  Free inodes: 139265-147456
Group 18: (Blocks 589824-622591) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x96e6, unused inodes 8192
  Block bitmap at 589824 (+0), Inode bitmap at 589825 (+1)
  Inode table at 589826-590337 (+2)
  32254 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 590338-622591
  Free inodes: 147457-155648
Group 19: (Blocks 622592-655359) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xb9d7, unused inodes 8192
  Block bitmap at 622592 (+0), Inode bitmap at 622593 (+1)
  Inode table at 622594-623105 (+2)
  32254 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 623106-655359
  Free inodes: 155649-163840
Group 20: (Blocks 655360-688127) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x7440, unused inodes 8192
  Block bitmap at 655360 (+0), Inode bitmap at 655361 (+1)
  Inode table at 655362-655873 (+2)
  32254 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 655874-688127
  Free inodes: 163841-172032
Group 21: (Blocks 688128-720895) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x5b71, unused inodes 8192
  Block bitmap at 688128 (+0), Inode bitmap at 688129 (+1)
  Inode table at 688130-688641 (+2)
  32254 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 688642-720895
  Free inodes: 172033-180224
Group 22: (Blocks 720896-753663) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x2a22, unused inodes 8192
  Block bitmap at 720896 (+0), Inode bitmap at 720897 (+1)
  Inode table at 720898-721409 (+2)
  32254 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 721410-753663
  Free inodes: 180225-188416
Group 23: (Blocks 753664-786431) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x0513, unused inodes 8192
  Block bitmap at 753664 (+0), Inode bitmap at 753665 (+1)
  Inode table at 753666-754177 (+2)
  32254 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 754178-786431
  Free inodes: 188417-196608
Group 24: (Blocks 786432-819199) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xf10f, unused inodes 8192
  Block bitmap at 786432 (+0), Inode bitmap at 786433 (+1)
  Inode table at 786434-786945 (+2)
  32254 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 786946-819199
  Free inodes: 196609-204800
Group 25: (Blocks 819200-851967) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x9860, unused inodes 8192
  Backup superblock at 819200, Group descriptors at 819201-819201
  Reserved GDT blocks at 819202-819264
  Block bitmap at 819265 (+65), Inode bitmap at 819266 (+66)
  Inode table at 819267-819778 (+67)
  32189 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 819779-851967
  Free inodes: 204801-212992
Group 26: (Blocks 851968-884735) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xaf6d, unused inodes 8192
  Block bitmap at 851968 (+0), Inode bitmap at 851969 (+1)
  Inode table at 851970-852481 (+2)
  32254 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 852482-884735
  Free inodes: 212993-221184
Group 27: (Blocks 884736-917503) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xc602, unused inodes 8192
  Backup superblock at 884736, Group descriptors at 884737-884737
  Reserved GDT blocks at 884738-884800
  Block bitmap at 884801 (+65), Inode bitmap at 884802 (+66)
  Inode table at 884803-885314 (+67)
  32189 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 885315-917503
  Free inodes: 221185-229376
Group 28: (Blocks 917504-950271) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x4dcb, unused inodes 8192
  Block bitmap at 917504 (+0), Inode bitmap at 917505 (+1)
  Inode table at 917506-918017 (+2)
  32254 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 918018-950271
  Free inodes: 229377-237568
Group 29: (Blocks 950272-983039) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x62fa, unused inodes 8192
  Block bitmap at 950272 (+0), Inode bitmap at 950273 (+1)
  Inode table at 950274-950785 (+2)
  32254 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 950786-983039
  Free inodes: 237569-245760
Group 30: (Blocks 983040-1015807) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x13a9, unused inodes 8192
  Block bitmap at 983040 (+0), Inode bitmap at 983041 (+1)
  Inode table at 983042-983553 (+2)
  32254 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 983554-1015807
  Free inodes: 245761-253952
Group 31: (Blocks 1015808-1048575) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x3c98, unused inodes 8192
  Block bitmap at 1015808 (+0), Inode bitmap at 1015809 (+1)
  Inode table at 1015810-1016321 (+2)
  32254 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 1016322-1048575
  Free inodes: 253953-262144

$ sudo mount -t ext4 -o loop a.img /mnt/

$ df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/loop0             4128448    226384   3692388   6% /mnt

$ sudo umount /mnt
--------------------------------
--------------------------------
--------------------------------
