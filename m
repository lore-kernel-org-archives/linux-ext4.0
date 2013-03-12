From: "George Spelvin" <linux@horizon.com>
Subject: Sign, more experimentation and broken features...
Date: 11 Mar 2013 23:28:43 -0400
Message-ID: <20130312032843.29393.qmail@science.horizon.com>
Cc: linux@horizon.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:54135 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754718Ab3CLD2p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Mar 2013 23:28:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

You'd think I'd have learned my lesson playin with brand new ext4 features.

I created a file system with bigalloc, tried to resize it, and...
un, things don't look so hot.

It's a large (RAID across 2 TB drives) fuile system, but not so large that
it needs 64 bits.  However, it doesn't appear to have resized properly.

It started as 2x 2 TB data space, but I just grew the raid and I now
have 4x 2TB.

	Here's the initial state:
# dumpe2fs -h /dev/md3
dumpe2fs 1.43-WIP (22-Sep-2012)
Filesystem volume name:   data
Last mounted on:          /data
Filesystem UUID:          33b7c2fe-903c-46f6-9c7b-c99224428310
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file dir_nlink extra_isize bigalloc metadata_csum
Filesystem flags:         signed_directory_hash 
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              3815936
Block count:              976757248
Reserved block count:     48837862
Free blocks:              110148612
Free inodes:              3771487
First block:              0
Block size:               4096
Cluster size:             16384
Reserved GDT blocks:      197
Blocks per group:         131072
Clusters per group:       32768
Inodes per group:         512
Inode blocks per group:   32
RAID stride:              32
RAID stripe width:        128
Flex block group size:    64
Filesystem created:       Sun Mar 10 21:09:55 2013
Last mount time:          Sun Mar 10 21:11:02 2013
Last write time:          Mon Mar 11 22:45:56 2013
Mount count:              1
Maximum mount count:      -1
Last checked:             Sun Mar 10 21:09:55 2013
Check interval:           0 (<none>)
Lifetime writes:          3306 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      cb16677d-9707-4e03-8663-23baea7da9ce
Journal backup:           inode blocks
Checksum type:            crc32c
Checksum:                 0x3a91b97b
Journal features:         (none)
Journal size:             128M
Journal length:           32768
Journal sequence:         0x00001b10
Journal start:            0

	Then, I proceeded to try resizing it:
# resize2fs -P /dev/md3
resize2fs 1.43-WIP (22-Sep-2012)
Estimated minimum size of the filesystem: 866803174
# resize2fs -p /dev/md3
resize2fs 1.43-WIP (22-Sep-2012)
Please run 'e2fsck -f /dev/md3' first.

	Okay, I'll do ask you ask.  First odd thing: errors!
	Minor ones, but all I've done is mke2fs and copy some files
	to it:
# e2fsck -f -v -C0 -D /dev/md3
e2fsck 1.43-WIP (22-Sep-2012)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure                                           
Pass 3: Checking directory connectivity                                        
Pass 3A: Optimizing directories                                                
Pass 4: Checking reference counts                                              
Pass 5: Checking group summary information                                     
Free blocks count wrong for group #5440 (32195, counted=32194).                
Fix<y>? yes
Free blocks count wrong for group #6336 (32172, counted=32171).
Fix<y>? yes
Free blocks count wrong for group #6912 (32168, counted=32167).
Fix<y>? yes
Free blocks count wrong (110148528, counted=110148516).
Fix<y>? yes
                                                                               
data: ***** FILE SYSTEM WAS MODIFIED *****

       44449 inodes used (1.16%, out of 3815936)
        5186 non-contiguous files (11.7%)
           3 non-contiguous directories (0.0%)
             # of inodes with ind/dind/tind blocks: 0/0/0
             Extent depth histogram: 43796/645
   866608732 blocks used (88.72%, out of 976757248)
           0 bad blocks
         223 large files

       41850 regular files
        2590 directories
           0 character device files
           0 block device files
           0 fifos
       39188 links
           0 symbolic links (0 fast symbolic links)
           0 sockets
------------
       83628 files
# e2fsck -f -v -C0 /dev/md3
e2fsck 1.43-WIP (22-Sep-2012)
Pass 1: Checking inodes, blocks, and sizes
Inode 2785556, i_blocks is 64, should be 128.  Fix<y>? yes                     

Inode 3244192, i_blocks is 128, should be 192.  Fix<y>? yes                    
Inode 3342371, i_blocks is 32, should be 64.  Fix<y>? yes                      
Inode 3539882, i_blocks is 128, should be 192.  Fix<y>? yes                    
Pass 2: Checking directory structure                                           
Pass 3: Checking directory connectivity                                        
Pass 4: Checking reference counts
Pass 5: Checking group summary information                                     
Block bitmap differences:  +713033976 +830474432 +855640276 +905972064         
Fix<y>? yes
Free blocks count wrong for group #5440 (32194, counted=32193).                
Fix<y>? yes
Free blocks count wrong for group #6336 (32171, counted=32170).
Fix<y>? yes
Free blocks count wrong for group #6528 (32174, counted=32173).
Fix<y>? yes
Free blocks count wrong for group #6912 (32167, counted=32166).
Fix<y>? yes
Free blocks count wrong (110148516, counted=110148500).
Fix<y>? yes
                                                                               
data: ***** FILE SYSTEM WAS MODIFIED *****

       44449 inodes used (1.16%, out of 3815936)
        5186 non-contiguous files (11.7%)
          36 non-contiguous directories (0.1%)
             # of inodes with ind/dind/tind blocks: 0/0/0
             Extent depth histogram: 43796/645
   866608748 blocks used (88.72%, out of 976757248)
           0 bad blocks
         223 large files

       41850 regular files
        2590 directories
           0 character device files
           0 block device files
           0 fifos
       39188 links
           0 symbolic links (0 fast symbolic links)
           0 sockets
------------
       83628 files
# e2fsck -f -v -C0 /dev/md3
e2fsck 1.43-WIP (22-Sep-2012)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure                                           
Pass 3: Checking directory connectivity                                        
Pass 4: Checking reference counts
Pass 5: Checking group summary information                                     
                                                                               
       44449 inodes used (1.16%, out of 3815936)
        5186 non-contiguous files (11.7%)
          36 non-contiguous directories (0.1%)
             # of inodes with ind/dind/tind blocks: 0/0/0
             Extent depth histogram: 43796/645
   866608748 blocks used (88.72%, out of 976757248)
           0 bad blocks
         223 large files

       41850 regular files
        2590 directories
           0 character device files
           0 block device files
           0 fifos
       39188 links
           0 symbolic links (0 fast symbolic links)
           0 sockets
------------
       83628 files

	Okay, it's finally clean, now let's try resizing:
# resize2fs -p /dev/md3
resize2fs 1.43-WIP (22-Sep-2012)
Resizing the filesystem on /dev/md3 to 1953514496 (4k) blocks.
Begin pass 1 (max = 7452)
Extending the inode table     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
The filesystem on /dev/md3 is now 1953514496 blocks long.

	And an fsck...
[514]# e2fsck -f -v -C0 /dev/md3
e2fsck 1.43-WIP (22-Sep-2012)
ext2fs_check_desc: Corrupt group descriptor: bad block for inode table
e2fsck: Group descriptors look bad... trying backup blocks...
Pass 1: Checking inodes, blocks, and sizes
Group 7461's block bitmap at 973079840 conflicts with some other fs block.
Relocate<y>? 
data: e2fsck canceled.


Er... Not Good.  I'm reporting it now before I mess with things any more.
Oh, here's the final state:
# dumpe2fs /dev/md3 | less
dumpe2fs 1.43-WIP (22-Sep-2012)
Filesystem volume name:   data
Last mounted on:          /data
Filesystem UUID:          33b7c2fe-903c-46f6-9c7b-c99224428310
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file dir_nlink extra_isize bigalloc metadata_csum
Filesystem flags:         signed_directory_hash 
Default mount options:    user_xattr acl
Filesystem state:         not clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              7631360
Block count:              1953514496
Reserved block count:     97675724
Free blocks:              1086652372
Free inodes:              7586911
First block:              0
Block size:               4096
Cluster size:             16384
Reserved GDT blocks:      139
Blocks per group:         131072
Clusters per group:       32768
Inodes per group:         512
Inode blocks per group:   32
RAID stride:              32
RAID stripe width:        128
Flex block group size:    64
Filesystem created:       Sun Mar 10 21:09:55 2013
Last mount time:          Sun Mar 10 21:11:02 2013
Last write time:          Mon Mar 11 23:16:46 2013
Mount count:              0
Maximum mount count:      -1
Last checked:             Mon Mar 11 22:53:23 2013
Check interval:           0 (<none>)
Lifetime writes:          3307 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      cb16677d-9707-4e03-8663-23baea7da9ce
Journal backup:           inode blocks
Checksum type:            crc32c
Checksum:                 0x2e698960
Journal features:         (none)
Journal size:             128M
Journal length:           32768
Journal sequence:         0x00001b10
Journal start:            0


Group 0: (Blocks 0-131071) [ITABLE_ZEROED]
  Checksum 0xcfde, unused inodes 0
  Primary superblock at 0, Group descriptors at 1-117
  Reserved GDT blocks at 118-256
  Block bitmap at 257 (+257), csum 0x00000ace, Inode bitmap at 321 (+321), csum 0x000067c2
  Inode table at 385-416 (+385)
  62348 free clusters, 0 free inodes, 2 directories
Group 1: (Blocks 131072-262143) [ITABLE_ZEROED]
  Checksum 0x77cf, unused inodes 0
  Backup superblock at 131072, Group descriptors at 131073-131189
  Reserved GDT blocks at 131190-131328
  Block bitmap at 258 (bg #0 + 258), csum 0x00003562, Inode bitmap at 322 (bg #0 + 322), csum 0x000067c2
  Inode table at 417-448 (bg #0 + 417)
  0 free clusters, 0 free inodes, 2 directories
Group 2: (Blocks 262144-393215) [ITABLE_ZEROED]
  Checksum 0x62fd, unused inodes 0
  Block bitmap at 259 (bg #0 + 259), csum 0x00003562, Inode bitmap at 323 (bg #0 + 323), csum 0x000067c2
  Inode table at 449-480 (bg #0 + 449)
  0 free clusters, 0 free inodes, 2 directories
Group 3: (Blocks 393216-524287) [ITABLE_ZEROED]
  Checksum 0x362b, unused inodes 0
  Backup superblock at 393216, Group descriptors at 393217-393333
  Reserved GDT blocks at 393334-393472
  Block bitmap at 260 (bg #0 + 260), csum 0x0000f998, Inode bitmap at 324 (bg #0 + 324), csum 0x000067c2
  Inode table at 481-512 (bg #0 + 481)
  880 free clusters, 0 free inodes, 2 directories
Group 4: (Blocks 524288-655359) [ITABLE_ZEROED]
  Checksum 0xac3e, unused inodes 0
  Block bitmap at 261 (bg #0 + 261), csum 0x00003562, Inode bitmap at 325 (bg #0
 + 325), csum 0x000067c2
  Inode table at 513-544 (bg #0 + 513)
  0 free clusters, 0 free inodes, 2 directories
Group 5: (Blocks 655360-786431) [ITABLE_ZEROED]
  Checksum 0x7a79, unused inodes 0
  Backup superblock at 655360, Group descriptors at 655361-655477
  Reserved GDT blocks at 655478-655616
  Block bitmap at 262 (bg #0 + 262), csum 0x00009ffb, Inode bitmap at 326 (bg #0 + 326), csum 0x000067c2
  Inode table at 545-576 (bg #0 + 545)
  372 free clusters, 0 free inodes, 2 directories
Group 6: (Blocks 786432-917503) [ITABLE_ZEROED]
  Checksum 0xe647, unused inodes 0
  Block bitmap at 263 (bg #0 + 263), csum 0x00003562, Inode bitmap at 327 (bg #0 + 327), csum 0x000067c2
  Inode table at 577-608 (bg #0 + 577)
  0 free clusters, 0 free inodes, 2 directories
Group 7: (Blocks 917504-1048575) [ITABLE_ZEROED]
  Checksum 0x9f6c, unused inodes 0
  Backup superblock at 917504, Group descriptors at 917505-917621
  Reserved GDT blocks at 917622-917760
  Block bitmap at 264 (bg #0 + 264), csum 0x00003562, Inode bitmap at 328 (bg #0 + 328), csum 0x0000bdda
  Inode table at 609-640 (bg #0 + 609)
  0 free clusters, 387 free inodes, 3 directories
Group 8: (Blocks 1048576-1179647) [ITABLE_ZEROED]
  Checksum 0x2c1b, unused inodes 0
  Block bitmap at 265 (bg #0 + 265), csum 0x00003562, Inode bitmap at 329 (bg #0 + 329), csum 0x0000393c
  Inode table at 641-672 (bg #0 + 641)
  0 free clusters, 509 free inodes, 3 directories
Group 9: (Blocks 1179648-1310719) [ITABLE_ZEROED]
  Checksum 0x7350, unused inodes 0
  Backup superblock at 1179648, Group descriptors at 1179649-1179765
  Reserved GDT blocks at 1179766-1179904
  Block bitmap at 266 (bg #0 + 266), csum 0x00003562, Inode bitmap at 330 (bg #0 + 330), csum 0x0000393c
  Inode table at 673-704 (bg #0 + 673)
  0 free clusters, 509 free inodes, 3 directories
Group 10: (Blocks 1310720-1441791) [ITABLE_ZEROED]
  Checksum 0x6662, unused inodes 0
  Block bitmap at 267 (bg #0 + 267), csum 0x00003562, Inode bitmap at 331 (bg #0 + 331), csum 0x0000393c
  Inode table at 705-736 (bg #0 + 705)
  0 free clusters, 509 free inodes, 3 directories
Group 11: (Blocks 1441792-1572863) [ITABLE_ZEROED]
  Checksum 0xbb37, unused inodes 0
  Block bitmap at 268 (bg #0 + 268), csum 0x00003562, Inode bitmap at 332 (bg #0 + 332), csum 0x0000393c
  Inode table at 737-768 (bg #0 + 737)
  0 free clusters, 509 free inodes, 3 directories

[snip...]

Group 7423: (Blocks 972947456-973078527) [ITABLE_ZEROED]
  Checksum 0xc975, unused inodes 0
  Block bitmap at 964689983 (bg #7360 + 63), csum 0x00000000, Inode bitmap at 96
4690047 (bg #7360 + 127), csum 0x00000000
  Inode table at 964692064-964692095 (bg #7360 + 2144)
  0 free clusters, 512 free inodes, 0 directories
Group 7424: (Blocks 973078528-973209599) [ITABLE_ZEROED]
  Checksum 0x895b, unused inodes 0
  Block bitmap at 973078528 (+0), csum 0x0000f375, Inode bitmap at 973078592 (+6
4), csum 0x00000000
  Inode table at 973078656-973078687 (+128)
  63360 free clusters, 512 free inodes, 0 directories
Group 7425: (Blocks 973209600-973340671) [ITABLE_ZEROED]
  Checksum 0x27c5, unused inodes 0
  Block bitmap at 973078529 (bg #7424 + 1), csum 0x00000000, Inode bitmap at 973
078593 (bg #7424 + 65), csum 0x00000000
  Inode table at 973078688-973078719 (bg #7424 + 160)
  0 free clusters, 512 free inodes, 0 directories

[snip...]

Group 7457: (Blocks 977403904-977534975)
  Checksum 0x272a, unused inodes 0
  Block bitmap at 973078624 (bg #7424 + 96), csum 0x00000000, Inode bitmap at 97
3078628 (bg #7424 + 100), csum 0x00000000
  Inode table at 973079712-973079743 (bg #7424 + 1184)
  0 free clusters, 512 free inodes, 0 directories
Group 7458: (Blocks 977534976-977666047)
  Checksum 0x6ddb, unused inodes 0
  Block bitmap at 973078632 (bg #7424 + 104), csum 0x00000000, Inode bitmap at 9
73078636 (bg #7424 + 108), csum 0x00000000
  Inode table at 973079744-973079775 (bg #7424 + 1216)
  0 free clusters, 512 free inodes, 0 directories
Group 7459: (Blocks 977666048-977797119)
  Checksum 0xd2d5, unused inodes 0
  Block bitmap at 973078640 (bg #7424 + 112), csum 0x00000000, Inode bitmap at 9
73078644 (bg #7424 + 116), csum 0x00000000
  Inode table at 973079776-973079807 (bg #7424 + 1248)
  0 free clusters, 512 free inodes, 0 directories
Group 7460: (Blocks 977797120-977928191)
  Checksum 0x7ef0, unused inodes 0
  Block bitmap at 973078648 (bg #7424 + 120), csum 0x00000000, Inode bitmap at 9
73078652 (bg #7424 + 124), csum 0x00000000
  Inode table at 973079808-973079839 (bg #7424 + 1280)
  0 free clusters, 512 free inodes, 0 directories
Group 7461: (Blocks 977928192-978059263)
  Checksum 0x9a50, unused inodes 0
  Block bitmap at 973079840 (bg #7424 + 1312), csum 0x00000000, Inode bitmap at 973079844 (bg #7424 + 1316), csum 0x00000000
  Inode table at 973079840-973079871 (bg #7424 + 1312)
  0 free clusters, 512 free inodes, 0 directories
Group 7462: (Blocks 978059264-978190335)
  Checksum 0x3e49, unused inodes 0
  Block bitmap at 973079872 (bg #7424 + 1344), csum 0x00000000, Inode bitmap at 973079876 (bg #7424 + 1348), csum 0x00000000
  Inode table at 973079872-973079903 (bg #7424 + 1344)
  0 free clusters, 512 free inodes, 0 directories
Group 7463: (Blocks 978190336-978321407)
  Checksum 0x7011, unused inodes 0
  Block bitmap at 973079904 (bg #7424 + 1376), csum 0x00000000, Inode bitmap at 973079908 (bg #7424 + 1380), csum 0x00000000
  Inode table at 973079904-973079935 (bg #7424 + 1376)
  0 free clusters, 512 free inodes, 0 directories

