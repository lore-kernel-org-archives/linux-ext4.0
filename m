From: "George Spelvin" <linux@horizon.com>
Subject: Re: 64bit + resize2fs... this is Not Good.
Date: 14 Nov 2012 01:27:10 -0500
Message-ID: <20121114062710.24957.qmail@science.horizon.com>
References: <20121114035101.15686.qmail@science.horizon.com>
To: linux-ext4@vger.kernel.org, linux@horizon.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:34134 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751054Ab2KNG1M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Nov 2012 01:27:12 -0500
In-Reply-To: <20121114035101.15686.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm studying the file system to see what I can salvage from the
wreckage that resize2fs left me with, and thought I'd keep a diary of
my discoveries here so someone can correct my errors.

I'm leaning heavily on
https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout

debugfs stats tells me the following:

Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super large_file dir_nlink extra_isize metadata_csum
Inode count:              20983680
Block count:              5371804064
First block:              0
Block size:               4096
Blocks per group:         32768
Inodes per group:         128		// 128 * 256 = 32 Kbytes
Inode blocks per group:   8		// 8 * 4096  = 32 kbytes check!
Flex block group size:    16

So, I have 5371804064 = 32768 * 163934 + 14752 blocks, meaning I have 163935
block groups (the last one partial).

Since they're 64 bytes each, that's 4096 * 2561 + 1984 bytes, or 2562 pages
per block descriptor backup.

Since sparse_super is set, backup copies of the superblock and block group descriptors
are present only in groups 0, 1, 3, 5, 7, 9, 25, 27, 49, 81, 125, ...

Since flex_bg is set, block groups are basically "ganged" into groups
of 512Ki blocks.  So only groups 0, 16, 32, ... actually have bitmaps &
inode tables in them.  Thus, except for group 0, it's an either/or thing.

Checking a backup copy with
dumpe2fs -o superblock=$((9*32768)) /dev/md1
gives consistent results.  The differences are:

--- /tmp/0      2012-11-14 00:35:21.061916443 -0500
+++ /tmp/9      2012-11-14 00:35:23.985270766 -0500
@@ -9 +9 @@
-Filesystem state:         not clean with errors
+Filesystem state:         not clean
@@ -15 +15 @@
-Free blocks:              4643122829
+Free blocks:              348155533
@@ -29 +29 @@
-Last write time:          Tue Nov 13 22:35:53 2012
+Last write time:          Tue Nov 13 22:34:31 2012
@@ -45,11 +44,0 @@
-FS Error count:           779
-First error time:         Tue Nov 13 22:56:42 2012
-First error function:     ext4_iget
-First error line #:       3832
-First error inode #:      771
-First error block #:      0
-Last error time:          Tue Nov 13 23:10:01 2012
-Last error function:      ext4_iget
-Last error line #:        3832
-Last error inode #:       771
-Last error block #:       0
@@ -57 +46 @@
-Checksum:                 0x1a66baa3
+Checksum:                 0x921b7125

(Interesting that resize2fs updates the block count, but leaves the old free blocks
value alone.)


Anyway, looking at the output of dumpe2fs, I notice the first real oddity:

(Note that I'm not quite sure what ITABLE_ZEROED means, and the
nomenclature makes me VERY nervous.  Does it mean ITABLE_INITIALIZED?)

Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
  Checksum 0xbf1d, unused inodes 0
  Primary superblock at 0, Group descriptors at 1-2562
  Block bitmap at 2571 (+2571), csum 0xba8922d8, Inode bitmap at 2572 (+2572), csum 0x7d86a677
  Inode table at 2563-2570 (+2563)
  17993 free blocks, 0 free inodes, 4 directories
Group 1: (Blocks 32768-65535) [ITABLE_ZEROED]
  Checksum 0xca14, unused inodes 0
  Backup superblock at 32768, Group descriptors at 32769-35330
  Block bitmap at 1958 (bg #0 + 1958), csum 0xef1e59c7, Inode bitmap at 1974 (bg #0 + 1974), csum 0x7d86a677
  Inode table at 1997-2004 (bg #0 + 1997)
  30205 free blocks, 0 free inodes, 2 directories
Group 2: (Blocks 65536-98303) [ITABLE_ZEROED]
  Checksum 0x8abe, unused inodes 0
  Block bitmap at 1959 (bg #0 + 1959), csum 0x17817d16, Inode bitmap at 1975 (bg #0 + 1975), csum 0x7d86a677
  Inode table at 2005-2012 (bg #0 + 2005)
  32768 free blocks, 0 free inodes, 2 directories
Group 3: (Blocks 98304-131071) [ITABLE_ZEROED]
  Checksum 0x478d, unused inodes 0
  Backup superblock at 98304, Group descriptors at 98305-100866
  Block bitmap at 1960 (bg #0 + 1960), csum 0xef1e59c7, Inode bitmap at 1976 (bg #0 + 1976), csum 0x7d86a677
  Inode table at 2013-2020 (bg #0 + 2013)
  30205 free blocks, 0 free inodes, 0 directories
Group 4: (Blocks 131072-163839) [ITABLE_ZEROED]
  Checksum 0xfbc4, unused inodes 0
  Block bitmap at 1961 (bg #0 + 1961), csum 0x17817d16, Inode bitmap at 1977 (bg #0 + 1977), csum 0x7d86a677
  Inode table at 2021-2028 (bg #0 + 2021)
  32768 free blocks, 0 free inodes, 3 directories
Group 5: (Blocks 163840-196607) [ITABLE_ZEROED]
  Checksum 0x5c5f, unused inodes 0
  Backup superblock at 163840, Group descriptors at 163841-166402
  Block bitmap at 1962 (bg #0 + 1962), csum 0xef1e59c7, Inode bitmap at 1978 (bg #0 + 1978), csum 0x7d86a677
  Inode table at 2029-2036 (bg #0 + 2029)
  30205 free blocks, 0 free inodes, 0 directories
Group 6: (Blocks 196608-229375) [ITABLE_ZEROED]
  Checksum 0x80c5, unused inodes 0
  Block bitmap at 1963 (bg #0 + 1963), csum 0x17817d16, Inode bitmap at 1979 (bg #0 + 1979), csum 0x7d86a677
  Inode table at 2037-2044 (bg #0 + 2037)
  32768 free blocks, 0 free inodes, 12 directories
Group 7: (Blocks 229376-262143) [ITABLE_ZEROED]
  Checksum 0xe21a, unused inodes 0
  Backup superblock at 229376, Group descriptors at 229377-231938
  Block bitmap at 1964 (bg #0 + 1964), csum 0xef1e59c7, Inode bitmap at 1980 (bg #0 + 1980), csum 0x7d86a677
  Inode table at 2045-2052 (bg #0 + 2045)
  30205 free blocks, 0 free inodes, 7 directories
Group 8: (Blocks 262144-294911) [ITABLE_ZEROED]
  Checksum 0xb69a, unused inodes 0
  Block bitmap at 1965 (bg #0 + 1965), csum 0x17817d16, Inode bitmap at 1981 (bg #0 + 1981), csum 0x7d86a677
  Inode table at 2053-2060 (bg #0 + 2053)
  32768 free blocks, 0 free inodes, 10 directories
Group 9: (Blocks 294912-327679) [ITABLE_ZEROED]
  Checksum 0x360d, unused inodes 0
  Backup superblock at 294912, Group descriptors at 294913-297474
  Block bitmap at 1966 (bg #0 + 1966), csum 0xef1e59c7, Inode bitmap at 1982 (bg #0 + 1982), csum 0x7d86a677
  Inode table at 2061-2068 (bg #0 + 2061)
  30205 free blocks, 0 free inodes, 10 directories
Group 10: (Blocks 327680-360447) [ITABLE_ZEROED]
  Checksum 0x6ba3, unused inodes 0
  Block bitmap at 1967 (bg #0 + 1967), csum 0x17817d16, Inode bitmap at 1983 (bg #0 + 1983), csum 0x7d86a677
  Inode table at 2069-2076 (bg #0 + 2069)
  32768 free blocks, 0 free inodes, 11 directories
Group 11: (Blocks 360448-393215) [ITABLE_ZEROED]
  Checksum 0xabd0, unused inodes 0
  Block bitmap at 1968 (bg #0 + 1968), csum 0x17817d16, Inode bitmap at 1984 (bg #0 + 1984), csum 0x7d86a677
  Inode table at 2077-2084 (bg #0 + 2077)
  32768 free blocks, 0 free inodes, 5 directories
Group 12: (Blocks 393216-425983) [ITABLE_ZEROED]
  Checksum 0x47de, unused inodes 0
  Block bitmap at 1969 (bg #0 + 1969), csum 0x17817d16, Inode bitmap at 1985 (bg #0 + 1985), csum 0x7d86a677
  Inode table at 2085-2092 (bg #0 + 2085)
  32768 free blocks, 0 free inodes, 7 directories
Group 13: (Blocks 425984-458751) [ITABLE_ZEROED]
  Checksum 0x5822, unused inodes 0
  Block bitmap at 1970 (bg #0 + 1970), csum 0x17817d16, Inode bitmap at 1986 (bg #0 + 1986), csum 0x7d86a677
  Inode table at 2093-2100 (bg #0 + 2093)
  32768 free blocks, 0 free inodes, 13 directories
Group 14: (Blocks 458752-491519) [ITABLE_ZEROED]
  Checksum 0x21db, unused inodes 0
  Block bitmap at 1971 (bg #0 + 1971), csum 0x17817d16, Inode bitmap at 1987 (bg #0 + 1987), csum 0x7d86a677
  Inode table at 2101-2108 (bg #0 + 2101)
  32768 free blocks, 0 free inodes, 9 directories
Group 15: (Blocks 491520-524287) [ITABLE_ZEROED]
  Checksum 0xdd66, unused inodes 0
  Block bitmap at 1972 (bg #0 + 1972), csum 0x17817d16, Inode bitmap at 1988 (bg #0 + 1988), csum 0x7561ee79
  Inode table at 2109-2116 (bg #0 + 2109)
  32768 free blocks, 92 free inodes, 12 directories
Group 16: (Blocks 524288-557055) [ITABLE_ZEROED]
  Checksum 0x5ee8, unused inodes 0
  Block bitmap at 524288 (+0), csum 0x316efbb2, Inode bitmap at 524304 (+16), csum 0x7d86a677
  Inode table at 524320-524327 (+32)
  30816 free blocks, 0 free inodes, 2 directories
Group 17: (Blocks 557056-589823) [ITABLE_ZEROED]
  Checksum 0x0f0a, unused inodes 0
  Block bitmap at 524289 (bg #16 + 1), csum 0x17817d16, Inode bitmap at 524305 (bg #16 + 17), csum 0x7d86a677
  Inode table at 524328-524335 (bg #16 + 40)
  32768 free blocks, 0 free inodes, 1 directories

Notice that Group 0's inode table starts at block 2563, immediately after the 1+2562 blocks of
superblock + block descriptors.

But groups 1..15 have their inode tables in the middle of the block descriptor array!  WTF?
Also, they're all in different orders.

Group 0 is inode table, block bitmap, inode bitmap.

Groups 1..15 have all their block bitmaps consecutive (blocks 1957-1972,
if we extrapolate where group 0's bitmaps would go), followed by inode
bitmaps and then inode tables.

Are they just unchanged from the pre-resize version?  The old file system
size was 1953383296 blocks, requiring 59613 block groups, and 932 blocks
to hold their descriptors.  So that doesn't quite make sense...

Oh!  Is that the "reserved GDT block" space?  Not quite sure how
it was computed, but maybe...


Is there a (forlorn hope!) chance that resize2fs actually relocated the
inodes properly, and just failed to update the block group descriptors
to point to them?  So all the data is actually safe, just misplaced?

Or perhaps only the first 16*128 = 2048 inodes are trashed?
Or perhaps even inodes 128-2047?

I notice that I can read inode 2 (the root directory) and inode 11
(lost+found), I cannot read inodes 513-775, inodes 2047 and 2048
look corrupted, but inode 2049 looks fine.

Oh, that's right, inode 0 is invalid, so inodes are 1-based.
So inodes 128 and 2049 might be right, but inodes 129-2048
are toast.


I'm going to fire this off into the ether now and start the somewhat
time-consuming process of seeing if I can find the lost inodes somewhere
in block group 0.
