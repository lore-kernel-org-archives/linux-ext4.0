From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] libext2fs: place metadata blocks in the last flex_bg so they are contiguous
Date: Sun,  3 Aug 2014 14:13:25 -0400
Message-ID: <1407089605-575-2-git-send-email-tytso@mit.edu>
References: <1407089605-575-1-git-send-email-tytso@mit.edu>
Cc: adilger@dilger.ca, a-fujita@rs.jp.nec.com,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42381 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbaHCSNe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Aug 2014 14:13:34 -0400
In-Reply-To: <1407089605-575-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Place the allocation bitmaps and inode table blocks so they are
adjacent, even in the last flexbg.

Previously, after running "mke2fs -t ext4 DEV 286720", the layout of
the last few block groups would look like this:

Group 32: (Blocks 262145-270336) [INODE_UNINIT, ITABLE_ZEROED]
  Block bitmap at 262145 (+0), Inode bitmap at 262161 (+16)
  Inode table at 262177-262432 (+32)
Group 33: (Blocks 270337-278528) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Block bitmap at 262146 (bg #32 + 1), Inode bitmap at 262162 (bg #32 + 17)
  Inode table at 262433-262688 (bg #32 + 288)
Group 34: (Blocks 278529-286719) [INODE_UNINIT, ITABLE_ZEROED]
  Block bitmap at 262147 (bg #32 + 2), Inode bitmap at 262163 (bg #32 + 18)
  Inode table at 262689-262944 (bg #32 + 544)

Now, they look like this:

Group 32: (Blocks 262145-270336) [INODE_UNINIT, ITABLE_ZEROED]
  Block bitmap at 262145 (+0), Inode bitmap at 262148 (+3)
  Inode table at 262151-262406 (+6)
Group 33: (Blocks 270337-278528) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Block bitmap at 262146 (bg #32 + 1), Inode bitmap at 262149 (bg #32 + 4)
  Inode table at 262407-262662 (bg #32 + 262)
Group 34: (Blocks 278529-286719) [INODE_UNINIT, ITABLE_ZEROED]
  Block bitmap at 262147 (bg #32 + 2), Inode bitmap at 262150 (bg #32 + 5)
  Inode table at 262663-262918 (bg #32 + 518)

This reduces the free space fragmentation in a freshly created file
system.  It also allows the following mke2fs command to succeed:

mke2fs -t ext4 -b 4096 -O ^resize_inode -G $((2**20)) DEV 2130483

(Note that while this allows people to run mke2fs with insanely large
flexbg sizes, this is not a recommended practice, as the kernel may
refuse to resize such a file system while mounted, since it currently
tries to allocate an in-memory data structure based on the size of the
flexbg, and so a file system with a very large flexbg size will cause
the memory allocation to fail.  This will hopefully be fixed in a
future kernel release, but if the goal is to force all of the metadata
blocks to be at the beginning of the file system, it's better to use
the packed_meta_blocks configuration parameter in mke2fs.conf.)

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 lib/ext2fs/alloc_tables.c   |  18 ++-
 tests/m_bigjournal/expect.1 | 338 ++++++++++++++++++++++----------------------
 2 files changed, 184 insertions(+), 172 deletions(-)

diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 85d4932..3760d61 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -87,7 +87,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 	errcode_t	retval;
 	blk64_t		group_blk, start_blk, last_blk, new_blk;
 	dgrp_t		last_grp = 0;
-	int		rem_grps = 0, flexbg_size = 0;
+	int		rem_grps = 0, flexbg_size = 0, table_offset = 0;
 
 	group_blk = ext2fs_group_first_block2(fs, group);
 	last_blk = ext2fs_group_last_block2(fs, group);
@@ -124,8 +124,20 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 	if (flexbg_size) {
 		blk64_t prev_block = 0;
 
+		table_offset = flexbg_size;
 		if (group % flexbg_size)
 			prev_block = ext2fs_block_bitmap_loc(fs, group - 1) + 1;
+		else if (last_grp == fs->group_desc_count-1) {
+			/*
+			 * If we are allocating for the last flex_bg
+			 * keep the metadata tables contiguous
+			 */
+			table_offset = last_grp & (flexbg_size - 1);
+			if (table_offset == 0)
+				table_offset = flexbg_size;
+			else
+				table_offset++;
+		}
 		/* FIXME: Take backup group descriptor blocks into account
 		 * if the flexbg allocations will grow to overlap them... */
 		start_blk = flexbg_offset(fs, group, prev_block, bmap,
@@ -158,7 +170,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 			prev_block = ext2fs_inode_bitmap_loc(fs, group - 1) + 1;
 		else
 			prev_block = ext2fs_block_bitmap_loc(fs, group) +
-				flexbg_size;
+				table_offset;
 		/* FIXME: Take backup group descriptor blocks into account
 		 * if the flexbg allocations will grow to overlap them... */
 		start_blk = flexbg_offset(fs, group, prev_block, bmap,
@@ -196,7 +208,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 				fs->inode_blocks_per_group;
 		else
 			prev_block = ext2fs_inode_bitmap_loc(fs, group) +
-				flexbg_size;
+				table_offset;
 
 		/* FIXME: Take backup group descriptor blocks into account
 		 * if the flexbg allocations will grow to overlap them... */
diff --git a/tests/m_bigjournal/expect.1 b/tests/m_bigjournal/expect.1
index b45d02c..7246739 100644
--- a/tests/m_bigjournal/expect.1
+++ b/tests/m_bigjournal/expect.1
@@ -50,524 +50,524 @@ Journal start:            0
 Group 0: (Blocks 0-32767)
   Primary superblock at 0, Group descriptors at 1-1
   Reserved GDT blocks at 2-672
-  Block bitmap at 673 (+673), Inode bitmap at 1185 (+1185)
-  Inode table at 1697-1697 (+1697)
+  Block bitmap at 673 (+673), Inode bitmap at 757 (+757)
+  Inode table at 841-841 (+841)
   31836 free blocks, 5 free inodes, 2 directories, 5 unused inodes
-  Free blocks: 764-1184, 1269-1696, 1781-32767
+  Free blocks: 932-32767
   Free inodes: 12-16
 Group 1: (Blocks 32768-65535) [INODE_UNINIT, BLOCK_UNINIT]
   Backup superblock at 32768, Group descriptors at 32769-32769
   Reserved GDT blocks at 32770-33440
-  Block bitmap at 674 (bg #0 + 674), Inode bitmap at 1186 (bg #0 + 1186)
-  Inode table at 1698-1698 (bg #0 + 1698)
+  Block bitmap at 674 (bg #0 + 674), Inode bitmap at 758 (bg #0 + 758)
+  Inode table at 842-842 (bg #0 + 842)
   32095 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 33441-65535
   Free inodes: 17-32
 Group 2: (Blocks 65536-98303) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 675 (bg #0 + 675), Inode bitmap at 1187 (bg #0 + 1187)
-  Inode table at 1699-1699 (bg #0 + 1699)
+  Block bitmap at 675 (bg #0 + 675), Inode bitmap at 759 (bg #0 + 759)
+  Inode table at 843-843 (bg #0 + 843)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 65536-98303
   Free inodes: 33-48
 Group 3: (Blocks 98304-131071) [INODE_UNINIT, BLOCK_UNINIT]
   Backup superblock at 98304, Group descriptors at 98305-98305
   Reserved GDT blocks at 98306-98976
-  Block bitmap at 676 (bg #0 + 676), Inode bitmap at 1188 (bg #0 + 1188)
-  Inode table at 1700-1700 (bg #0 + 1700)
+  Block bitmap at 676 (bg #0 + 676), Inode bitmap at 760 (bg #0 + 760)
+  Inode table at 844-844 (bg #0 + 844)
   32095 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 98977-131071
   Free inodes: 49-64
 Group 4: (Blocks 131072-163839) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 677 (bg #0 + 677), Inode bitmap at 1189 (bg #0 + 1189)
-  Inode table at 1701-1701 (bg #0 + 1701)
+  Block bitmap at 677 (bg #0 + 677), Inode bitmap at 761 (bg #0 + 761)
+  Inode table at 845-845 (bg #0 + 845)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 131072-163839
   Free inodes: 65-80
 Group 5: (Blocks 163840-196607) [INODE_UNINIT, BLOCK_UNINIT]
   Backup superblock at 163840, Group descriptors at 163841-163841
   Reserved GDT blocks at 163842-164512
-  Block bitmap at 678 (bg #0 + 678), Inode bitmap at 1190 (bg #0 + 1190)
-  Inode table at 1702-1702 (bg #0 + 1702)
+  Block bitmap at 678 (bg #0 + 678), Inode bitmap at 762 (bg #0 + 762)
+  Inode table at 846-846 (bg #0 + 846)
   32095 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 164513-196607
   Free inodes: 81-96
 Group 6: (Blocks 196608-229375) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 679 (bg #0 + 679), Inode bitmap at 1191 (bg #0 + 1191)
-  Inode table at 1703-1703 (bg #0 + 1703)
+  Block bitmap at 679 (bg #0 + 679), Inode bitmap at 763 (bg #0 + 763)
+  Inode table at 847-847 (bg #0 + 847)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 196608-229375
   Free inodes: 97-112
 Group 7: (Blocks 229376-262143) [INODE_UNINIT, BLOCK_UNINIT]
   Backup superblock at 229376, Group descriptors at 229377-229377
   Reserved GDT blocks at 229378-230048
-  Block bitmap at 680 (bg #0 + 680), Inode bitmap at 1192 (bg #0 + 1192)
-  Inode table at 1704-1704 (bg #0 + 1704)
+  Block bitmap at 680 (bg #0 + 680), Inode bitmap at 764 (bg #0 + 764)
+  Inode table at 848-848 (bg #0 + 848)
   32095 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 230049-262143
   Free inodes: 113-128
 Group 8: (Blocks 262144-294911) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 681 (bg #0 + 681), Inode bitmap at 1193 (bg #0 + 1193)
-  Inode table at 1705-1705 (bg #0 + 1705)
+  Block bitmap at 681 (bg #0 + 681), Inode bitmap at 765 (bg #0 + 765)
+  Inode table at 849-849 (bg #0 + 849)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 262144-294911
   Free inodes: 129-144
 Group 9: (Blocks 294912-327679) [INODE_UNINIT, BLOCK_UNINIT]
   Backup superblock at 294912, Group descriptors at 294913-294913
   Reserved GDT blocks at 294914-295584
-  Block bitmap at 682 (bg #0 + 682), Inode bitmap at 1194 (bg #0 + 1194)
-  Inode table at 1706-1706 (bg #0 + 1706)
+  Block bitmap at 682 (bg #0 + 682), Inode bitmap at 766 (bg #0 + 766)
+  Inode table at 850-850 (bg #0 + 850)
   32095 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 295585-327679
   Free inodes: 145-160
 Group 10: (Blocks 327680-360447) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 683 (bg #0 + 683), Inode bitmap at 1195 (bg #0 + 1195)
-  Inode table at 1707-1707 (bg #0 + 1707)
+  Block bitmap at 683 (bg #0 + 683), Inode bitmap at 767 (bg #0 + 767)
+  Inode table at 851-851 (bg #0 + 851)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 327680-360447
   Free inodes: 161-176
 Group 11: (Blocks 360448-393215) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 684 (bg #0 + 684), Inode bitmap at 1196 (bg #0 + 1196)
-  Inode table at 1708-1708 (bg #0 + 1708)
+  Block bitmap at 684 (bg #0 + 684), Inode bitmap at 768 (bg #0 + 768)
+  Inode table at 852-852 (bg #0 + 852)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 360448-393215
   Free inodes: 177-192
 Group 12: (Blocks 393216-425983) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 685 (bg #0 + 685), Inode bitmap at 1197 (bg #0 + 1197)
-  Inode table at 1709-1709 (bg #0 + 1709)
+  Block bitmap at 685 (bg #0 + 685), Inode bitmap at 769 (bg #0 + 769)
+  Inode table at 853-853 (bg #0 + 853)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 393216-425983
   Free inodes: 193-208
 Group 13: (Blocks 425984-458751) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 686 (bg #0 + 686), Inode bitmap at 1198 (bg #0 + 1198)
-  Inode table at 1710-1710 (bg #0 + 1710)
+  Block bitmap at 686 (bg #0 + 686), Inode bitmap at 770 (bg #0 + 770)
+  Inode table at 854-854 (bg #0 + 854)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 425984-458751
   Free inodes: 209-224
 Group 14: (Blocks 458752-491519) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 687 (bg #0 + 687), Inode bitmap at 1199 (bg #0 + 1199)
-  Inode table at 1711-1711 (bg #0 + 1711)
+  Block bitmap at 687 (bg #0 + 687), Inode bitmap at 771 (bg #0 + 771)
+  Inode table at 855-855 (bg #0 + 855)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 458752-491519
   Free inodes: 225-240
 Group 15: (Blocks 491520-524287) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 688 (bg #0 + 688), Inode bitmap at 1200 (bg #0 + 1200)
-  Inode table at 1712-1712 (bg #0 + 1712)
+  Block bitmap at 688 (bg #0 + 688), Inode bitmap at 772 (bg #0 + 772)
+  Inode table at 856-856 (bg #0 + 856)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 491520-524287
   Free inodes: 241-256
 Group 16: (Blocks 524288-557055) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 689 (bg #0 + 689), Inode bitmap at 1201 (bg #0 + 1201)
-  Inode table at 1713-1713 (bg #0 + 1713)
+  Block bitmap at 689 (bg #0 + 689), Inode bitmap at 773 (bg #0 + 773)
+  Inode table at 857-857 (bg #0 + 857)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 524288-557055
   Free inodes: 257-272
 Group 17: (Blocks 557056-589823) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 690 (bg #0 + 690), Inode bitmap at 1202 (bg #0 + 1202)
-  Inode table at 1714-1714 (bg #0 + 1714)
+  Block bitmap at 690 (bg #0 + 690), Inode bitmap at 774 (bg #0 + 774)
+  Inode table at 858-858 (bg #0 + 858)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 557056-589823
   Free inodes: 273-288
 Group 18: (Blocks 589824-622591) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 691 (bg #0 + 691), Inode bitmap at 1203 (bg #0 + 1203)
-  Inode table at 1715-1715 (bg #0 + 1715)
+  Block bitmap at 691 (bg #0 + 691), Inode bitmap at 775 (bg #0 + 775)
+  Inode table at 859-859 (bg #0 + 859)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 589824-622591
   Free inodes: 289-304
 Group 19: (Blocks 622592-655359) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 692 (bg #0 + 692), Inode bitmap at 1204 (bg #0 + 1204)
-  Inode table at 1716-1716 (bg #0 + 1716)
+  Block bitmap at 692 (bg #0 + 692), Inode bitmap at 776 (bg #0 + 776)
+  Inode table at 860-860 (bg #0 + 860)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 622592-655359
   Free inodes: 305-320
 Group 20: (Blocks 655360-688127) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 693 (bg #0 + 693), Inode bitmap at 1205 (bg #0 + 1205)
-  Inode table at 1717-1717 (bg #0 + 1717)
+  Block bitmap at 693 (bg #0 + 693), Inode bitmap at 777 (bg #0 + 777)
+  Inode table at 861-861 (bg #0 + 861)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 655360-688127
   Free inodes: 321-336
 Group 21: (Blocks 688128-720895) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 694 (bg #0 + 694), Inode bitmap at 1206 (bg #0 + 1206)
-  Inode table at 1718-1718 (bg #0 + 1718)
+  Block bitmap at 694 (bg #0 + 694), Inode bitmap at 778 (bg #0 + 778)
+  Inode table at 862-862 (bg #0 + 862)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 688128-720895
   Free inodes: 337-352
 Group 22: (Blocks 720896-753663) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 695 (bg #0 + 695), Inode bitmap at 1207 (bg #0 + 1207)
-  Inode table at 1719-1719 (bg #0 + 1719)
+  Block bitmap at 695 (bg #0 + 695), Inode bitmap at 779 (bg #0 + 779)
+  Inode table at 863-863 (bg #0 + 863)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 720896-753663
   Free inodes: 353-368
 Group 23: (Blocks 753664-786431) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 696 (bg #0 + 696), Inode bitmap at 1208 (bg #0 + 1208)
-  Inode table at 1720-1720 (bg #0 + 1720)
+  Block bitmap at 696 (bg #0 + 696), Inode bitmap at 780 (bg #0 + 780)
+  Inode table at 864-864 (bg #0 + 864)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 753664-786431
   Free inodes: 369-384
 Group 24: (Blocks 786432-819199) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 697 (bg #0 + 697), Inode bitmap at 1209 (bg #0 + 1209)
-  Inode table at 1721-1721 (bg #0 + 1721)
+  Block bitmap at 697 (bg #0 + 697), Inode bitmap at 781 (bg #0 + 781)
+  Inode table at 865-865 (bg #0 + 865)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 786432-819199
   Free inodes: 385-400
 Group 25: (Blocks 819200-851967) [INODE_UNINIT, BLOCK_UNINIT]
   Backup superblock at 819200, Group descriptors at 819201-819201
   Reserved GDT blocks at 819202-819872
-  Block bitmap at 698 (bg #0 + 698), Inode bitmap at 1210 (bg #0 + 1210)
-  Inode table at 1722-1722 (bg #0 + 1722)
+  Block bitmap at 698 (bg #0 + 698), Inode bitmap at 782 (bg #0 + 782)
+  Inode table at 866-866 (bg #0 + 866)
   32095 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 819873-851967
   Free inodes: 401-416
 Group 26: (Blocks 851968-884735) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 699 (bg #0 + 699), Inode bitmap at 1211 (bg #0 + 1211)
-  Inode table at 1723-1723 (bg #0 + 1723)
+  Block bitmap at 699 (bg #0 + 699), Inode bitmap at 783 (bg #0 + 783)
+  Inode table at 867-867 (bg #0 + 867)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 851968-884735
   Free inodes: 417-432
 Group 27: (Blocks 884736-917503) [INODE_UNINIT, BLOCK_UNINIT]
   Backup superblock at 884736, Group descriptors at 884737-884737
   Reserved GDT blocks at 884738-885408
-  Block bitmap at 700 (bg #0 + 700), Inode bitmap at 1212 (bg #0 + 1212)
-  Inode table at 1724-1724 (bg #0 + 1724)
+  Block bitmap at 700 (bg #0 + 700), Inode bitmap at 784 (bg #0 + 784)
+  Inode table at 868-868 (bg #0 + 868)
   32095 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 885409-917503
   Free inodes: 433-448
 Group 28: (Blocks 917504-950271) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 701 (bg #0 + 701), Inode bitmap at 1213 (bg #0 + 1213)
-  Inode table at 1725-1725 (bg #0 + 1725)
+  Block bitmap at 701 (bg #0 + 701), Inode bitmap at 785 (bg #0 + 785)
+  Inode table at 869-869 (bg #0 + 869)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 917504-950271
   Free inodes: 449-464
 Group 29: (Blocks 950272-983039) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 702 (bg #0 + 702), Inode bitmap at 1214 (bg #0 + 1214)
-  Inode table at 1726-1726 (bg #0 + 1726)
+  Block bitmap at 702 (bg #0 + 702), Inode bitmap at 786 (bg #0 + 786)
+  Inode table at 870-870 (bg #0 + 870)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 950272-983039
   Free inodes: 465-480
 Group 30: (Blocks 983040-1015807) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 703 (bg #0 + 703), Inode bitmap at 1215 (bg #0 + 1215)
-  Inode table at 1727-1727 (bg #0 + 1727)
+  Block bitmap at 703 (bg #0 + 703), Inode bitmap at 787 (bg #0 + 787)
+  Inode table at 871-871 (bg #0 + 871)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 983040-1015807
   Free inodes: 481-496
 Group 31: (Blocks 1015808-1048575) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 704 (bg #0 + 704), Inode bitmap at 1216 (bg #0 + 1216)
-  Inode table at 1728-1728 (bg #0 + 1728)
+  Block bitmap at 704 (bg #0 + 704), Inode bitmap at 788 (bg #0 + 788)
+  Inode table at 872-872 (bg #0 + 872)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 1015808-1048575
   Free inodes: 497-512
 Group 32: (Blocks 1048576-1081343) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 705 (bg #0 + 705), Inode bitmap at 1217 (bg #0 + 1217)
-  Inode table at 1729-1729 (bg #0 + 1729)
+  Block bitmap at 705 (bg #0 + 705), Inode bitmap at 789 (bg #0 + 789)
+  Inode table at 873-873 (bg #0 + 873)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 1048576-1081343
   Free inodes: 513-528
 Group 33: (Blocks 1081344-1114111) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 706 (bg #0 + 706), Inode bitmap at 1218 (bg #0 + 1218)
-  Inode table at 1730-1730 (bg #0 + 1730)
+  Block bitmap at 706 (bg #0 + 706), Inode bitmap at 790 (bg #0 + 790)
+  Inode table at 874-874 (bg #0 + 874)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 1081344-1114111
   Free inodes: 529-544
 Group 34: (Blocks 1114112-1146879) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 707 (bg #0 + 707), Inode bitmap at 1219 (bg #0 + 1219)
-  Inode table at 1731-1731 (bg #0 + 1731)
+  Block bitmap at 707 (bg #0 + 707), Inode bitmap at 791 (bg #0 + 791)
+  Inode table at 875-875 (bg #0 + 875)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 1114112-1146879
   Free inodes: 545-560
 Group 35: (Blocks 1146880-1179647) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 708 (bg #0 + 708), Inode bitmap at 1220 (bg #0 + 1220)
-  Inode table at 1732-1732 (bg #0 + 1732)
+  Block bitmap at 708 (bg #0 + 708), Inode bitmap at 792 (bg #0 + 792)
+  Inode table at 876-876 (bg #0 + 876)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 1146880-1179647
   Free inodes: 561-576
 Group 36: (Blocks 1179648-1212415) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 709 (bg #0 + 709), Inode bitmap at 1221 (bg #0 + 1221)
-  Inode table at 1733-1733 (bg #0 + 1733)
+  Block bitmap at 709 (bg #0 + 709), Inode bitmap at 793 (bg #0 + 793)
+  Inode table at 877-877 (bg #0 + 877)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 1179648-1212415
   Free inodes: 577-592
 Group 37: (Blocks 1212416-1245183) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 710 (bg #0 + 710), Inode bitmap at 1222 (bg #0 + 1222)
-  Inode table at 1734-1734 (bg #0 + 1734)
+  Block bitmap at 710 (bg #0 + 710), Inode bitmap at 794 (bg #0 + 794)
+  Inode table at 878-878 (bg #0 + 878)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 1212416-1245183
   Free inodes: 593-608
 Group 38: (Blocks 1245184-1277951) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 711 (bg #0 + 711), Inode bitmap at 1223 (bg #0 + 1223)
-  Inode table at 1735-1735 (bg #0 + 1735)
+  Block bitmap at 711 (bg #0 + 711), Inode bitmap at 795 (bg #0 + 795)
+  Inode table at 879-879 (bg #0 + 879)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 1245184-1277951
   Free inodes: 609-624
 Group 39: (Blocks 1277952-1310719) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 712 (bg #0 + 712), Inode bitmap at 1224 (bg #0 + 1224)
-  Inode table at 1736-1736 (bg #0 + 1736)
+  Block bitmap at 712 (bg #0 + 712), Inode bitmap at 796 (bg #0 + 796)
+  Inode table at 880-880 (bg #0 + 880)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 1277952-1310719
   Free inodes: 625-640
 Group 40: (Blocks 1310720-1343487) [INODE_UNINIT]
-  Block bitmap at 713 (bg #0 + 713), Inode bitmap at 1225 (bg #0 + 1225)
-  Inode table at 1737-1737 (bg #0 + 1737)
+  Block bitmap at 713 (bg #0 + 713), Inode bitmap at 797 (bg #0 + 797)
+  Inode table at 881-881 (bg #0 + 881)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 641-656
 Group 41: (Blocks 1343488-1376255) [INODE_UNINIT]
-  Block bitmap at 714 (bg #0 + 714), Inode bitmap at 1226 (bg #0 + 1226)
-  Inode table at 1738-1738 (bg #0 + 1738)
+  Block bitmap at 714 (bg #0 + 714), Inode bitmap at 798 (bg #0 + 798)
+  Inode table at 882-882 (bg #0 + 882)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 657-672
 Group 42: (Blocks 1376256-1409023) [INODE_UNINIT]
-  Block bitmap at 715 (bg #0 + 715), Inode bitmap at 1227 (bg #0 + 1227)
-  Inode table at 1739-1739 (bg #0 + 1739)
+  Block bitmap at 715 (bg #0 + 715), Inode bitmap at 799 (bg #0 + 799)
+  Inode table at 883-883 (bg #0 + 883)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 673-688
 Group 43: (Blocks 1409024-1441791) [INODE_UNINIT]
-  Block bitmap at 716 (bg #0 + 716), Inode bitmap at 1228 (bg #0 + 1228)
-  Inode table at 1740-1740 (bg #0 + 1740)
+  Block bitmap at 716 (bg #0 + 716), Inode bitmap at 800 (bg #0 + 800)
+  Inode table at 884-884 (bg #0 + 884)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 689-704
 Group 44: (Blocks 1441792-1474559) [INODE_UNINIT]
-  Block bitmap at 717 (bg #0 + 717), Inode bitmap at 1229 (bg #0 + 1229)
-  Inode table at 1741-1741 (bg #0 + 1741)
+  Block bitmap at 717 (bg #0 + 717), Inode bitmap at 801 (bg #0 + 801)
+  Inode table at 885-885 (bg #0 + 885)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 705-720
 Group 45: (Blocks 1474560-1507327) [INODE_UNINIT]
-  Block bitmap at 718 (bg #0 + 718), Inode bitmap at 1230 (bg #0 + 1230)
-  Inode table at 1742-1742 (bg #0 + 1742)
+  Block bitmap at 718 (bg #0 + 718), Inode bitmap at 802 (bg #0 + 802)
+  Inode table at 886-886 (bg #0 + 886)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 721-736
 Group 46: (Blocks 1507328-1540095) [INODE_UNINIT]
-  Block bitmap at 719 (bg #0 + 719), Inode bitmap at 1231 (bg #0 + 1231)
-  Inode table at 1743-1743 (bg #0 + 1743)
+  Block bitmap at 719 (bg #0 + 719), Inode bitmap at 803 (bg #0 + 803)
+  Inode table at 887-887 (bg #0 + 887)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 737-752
 Group 47: (Blocks 1540096-1572863) [INODE_UNINIT]
-  Block bitmap at 720 (bg #0 + 720), Inode bitmap at 1232 (bg #0 + 1232)
-  Inode table at 1744-1744 (bg #0 + 1744)
+  Block bitmap at 720 (bg #0 + 720), Inode bitmap at 804 (bg #0 + 804)
+  Inode table at 888-888 (bg #0 + 888)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 753-768
 Group 48: (Blocks 1572864-1605631) [INODE_UNINIT]
-  Block bitmap at 721 (bg #0 + 721), Inode bitmap at 1233 (bg #0 + 1233)
-  Inode table at 1745-1745 (bg #0 + 1745)
+  Block bitmap at 721 (bg #0 + 721), Inode bitmap at 805 (bg #0 + 805)
+  Inode table at 889-889 (bg #0 + 889)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 769-784
 Group 49: (Blocks 1605632-1638399) [INODE_UNINIT]
   Backup superblock at 1605632, Group descriptors at 1605633-1605633
   Reserved GDT blocks at 1605634-1606304
-  Block bitmap at 722 (bg #0 + 722), Inode bitmap at 1234 (bg #0 + 1234)
-  Inode table at 1746-1746 (bg #0 + 1746)
+  Block bitmap at 722 (bg #0 + 722), Inode bitmap at 806 (bg #0 + 806)
+  Inode table at 890-890 (bg #0 + 890)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 785-800
 Group 50: (Blocks 1638400-1671167) [INODE_UNINIT]
-  Block bitmap at 723 (bg #0 + 723), Inode bitmap at 1235 (bg #0 + 1235)
-  Inode table at 1747-1747 (bg #0 + 1747)
+  Block bitmap at 723 (bg #0 + 723), Inode bitmap at 807 (bg #0 + 807)
+  Inode table at 891-891 (bg #0 + 891)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 801-816
 Group 51: (Blocks 1671168-1703935) [INODE_UNINIT]
-  Block bitmap at 724 (bg #0 + 724), Inode bitmap at 1236 (bg #0 + 1236)
-  Inode table at 1748-1748 (bg #0 + 1748)
+  Block bitmap at 724 (bg #0 + 724), Inode bitmap at 808 (bg #0 + 808)
+  Inode table at 892-892 (bg #0 + 892)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 817-832
 Group 52: (Blocks 1703936-1736703) [INODE_UNINIT]
-  Block bitmap at 725 (bg #0 + 725), Inode bitmap at 1237 (bg #0 + 1237)
-  Inode table at 1749-1749 (bg #0 + 1749)
+  Block bitmap at 725 (bg #0 + 725), Inode bitmap at 809 (bg #0 + 809)
+  Inode table at 893-893 (bg #0 + 893)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 833-848
 Group 53: (Blocks 1736704-1769471) [INODE_UNINIT]
-  Block bitmap at 726 (bg #0 + 726), Inode bitmap at 1238 (bg #0 + 1238)
-  Inode table at 1750-1750 (bg #0 + 1750)
+  Block bitmap at 726 (bg #0 + 726), Inode bitmap at 810 (bg #0 + 810)
+  Inode table at 894-894 (bg #0 + 894)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 849-864
 Group 54: (Blocks 1769472-1802239) [INODE_UNINIT]
-  Block bitmap at 727 (bg #0 + 727), Inode bitmap at 1239 (bg #0 + 1239)
-  Inode table at 1751-1751 (bg #0 + 1751)
+  Block bitmap at 727 (bg #0 + 727), Inode bitmap at 811 (bg #0 + 811)
+  Inode table at 895-895 (bg #0 + 895)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 865-880
 Group 55: (Blocks 1802240-1835007) [INODE_UNINIT]
-  Block bitmap at 728 (bg #0 + 728), Inode bitmap at 1240 (bg #0 + 1240)
-  Inode table at 1752-1752 (bg #0 + 1752)
+  Block bitmap at 728 (bg #0 + 728), Inode bitmap at 812 (bg #0 + 812)
+  Inode table at 896-896 (bg #0 + 896)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 881-896
 Group 56: (Blocks 1835008-1867775) [INODE_UNINIT]
-  Block bitmap at 729 (bg #0 + 729), Inode bitmap at 1241 (bg #0 + 1241)
-  Inode table at 1753-1753 (bg #0 + 1753)
+  Block bitmap at 729 (bg #0 + 729), Inode bitmap at 813 (bg #0 + 813)
+  Inode table at 897-897 (bg #0 + 897)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 897-912
 Group 57: (Blocks 1867776-1900543) [INODE_UNINIT]
-  Block bitmap at 730 (bg #0 + 730), Inode bitmap at 1242 (bg #0 + 1242)
-  Inode table at 1754-1754 (bg #0 + 1754)
+  Block bitmap at 730 (bg #0 + 730), Inode bitmap at 814 (bg #0 + 814)
+  Inode table at 898-898 (bg #0 + 898)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 913-928
 Group 58: (Blocks 1900544-1933311) [INODE_UNINIT]
-  Block bitmap at 731 (bg #0 + 731), Inode bitmap at 1243 (bg #0 + 1243)
-  Inode table at 1755-1755 (bg #0 + 1755)
+  Block bitmap at 731 (bg #0 + 731), Inode bitmap at 815 (bg #0 + 815)
+  Inode table at 899-899 (bg #0 + 899)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 929-944
 Group 59: (Blocks 1933312-1966079) [INODE_UNINIT]
-  Block bitmap at 732 (bg #0 + 732), Inode bitmap at 1244 (bg #0 + 1244)
-  Inode table at 1756-1756 (bg #0 + 1756)
+  Block bitmap at 732 (bg #0 + 732), Inode bitmap at 816 (bg #0 + 816)
+  Inode table at 900-900 (bg #0 + 900)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 945-960
 Group 60: (Blocks 1966080-1998847) [INODE_UNINIT]
-  Block bitmap at 733 (bg #0 + 733), Inode bitmap at 1245 (bg #0 + 1245)
-  Inode table at 1757-1757 (bg #0 + 1757)
+  Block bitmap at 733 (bg #0 + 733), Inode bitmap at 817 (bg #0 + 817)
+  Inode table at 901-901 (bg #0 + 901)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 961-976
 Group 61: (Blocks 1998848-2031615) [INODE_UNINIT]
-  Block bitmap at 734 (bg #0 + 734), Inode bitmap at 1246 (bg #0 + 1246)
-  Inode table at 1758-1758 (bg #0 + 1758)
+  Block bitmap at 734 (bg #0 + 734), Inode bitmap at 818 (bg #0 + 818)
+  Inode table at 902-902 (bg #0 + 902)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 977-992
 Group 62: (Blocks 2031616-2064383) [INODE_UNINIT]
-  Block bitmap at 735 (bg #0 + 735), Inode bitmap at 1247 (bg #0 + 1247)
-  Inode table at 1759-1759 (bg #0 + 1759)
+  Block bitmap at 735 (bg #0 + 735), Inode bitmap at 819 (bg #0 + 819)
+  Inode table at 903-903 (bg #0 + 903)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 993-1008
 Group 63: (Blocks 2064384-2097151) [INODE_UNINIT]
-  Block bitmap at 736 (bg #0 + 736), Inode bitmap at 1248 (bg #0 + 1248)
-  Inode table at 1760-1760 (bg #0 + 1760)
+  Block bitmap at 736 (bg #0 + 736), Inode bitmap at 820 (bg #0 + 820)
+  Inode table at 904-904 (bg #0 + 904)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 1009-1024
 Group 64: (Blocks 2097152-2129919) [INODE_UNINIT]
-  Block bitmap at 737 (bg #0 + 737), Inode bitmap at 1249 (bg #0 + 1249)
-  Inode table at 1761-1761 (bg #0 + 1761)
+  Block bitmap at 737 (bg #0 + 737), Inode bitmap at 821 (bg #0 + 821)
+  Inode table at 905-905 (bg #0 + 905)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 1025-1040
 Group 65: (Blocks 2129920-2162687) [INODE_UNINIT]
-  Block bitmap at 738 (bg #0 + 738), Inode bitmap at 1250 (bg #0 + 1250)
-  Inode table at 1762-1762 (bg #0 + 1762)
+  Block bitmap at 738 (bg #0 + 738), Inode bitmap at 822 (bg #0 + 822)
+  Inode table at 906-906 (bg #0 + 906)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 1041-1056
 Group 66: (Blocks 2162688-2195455) [INODE_UNINIT]
-  Block bitmap at 739 (bg #0 + 739), Inode bitmap at 1251 (bg #0 + 1251)
-  Inode table at 1763-1763 (bg #0 + 1763)
+  Block bitmap at 739 (bg #0 + 739), Inode bitmap at 823 (bg #0 + 823)
+  Inode table at 907-907 (bg #0 + 907)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 1057-1072
 Group 67: (Blocks 2195456-2228223) [INODE_UNINIT]
-  Block bitmap at 740 (bg #0 + 740), Inode bitmap at 1252 (bg #0 + 1252)
-  Inode table at 1764-1764 (bg #0 + 1764)
+  Block bitmap at 740 (bg #0 + 740), Inode bitmap at 824 (bg #0 + 824)
+  Inode table at 908-908 (bg #0 + 908)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 1073-1088
 Group 68: (Blocks 2228224-2260991) [INODE_UNINIT]
-  Block bitmap at 741 (bg #0 + 741), Inode bitmap at 1253 (bg #0 + 1253)
-  Inode table at 1765-1765 (bg #0 + 1765)
+  Block bitmap at 741 (bg #0 + 741), Inode bitmap at 825 (bg #0 + 825)
+  Inode table at 909-909 (bg #0 + 909)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 1089-1104
 Group 69: (Blocks 2260992-2293759) [INODE_UNINIT]
-  Block bitmap at 742 (bg #0 + 742), Inode bitmap at 1254 (bg #0 + 1254)
-  Inode table at 1766-1766 (bg #0 + 1766)
+  Block bitmap at 742 (bg #0 + 742), Inode bitmap at 826 (bg #0 + 826)
+  Inode table at 910-910 (bg #0 + 910)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 1105-1120
 Group 70: (Blocks 2293760-2326527) [INODE_UNINIT]
-  Block bitmap at 743 (bg #0 + 743), Inode bitmap at 1255 (bg #0 + 1255)
-  Inode table at 1767-1767 (bg #0 + 1767)
+  Block bitmap at 743 (bg #0 + 743), Inode bitmap at 827 (bg #0 + 827)
+  Inode table at 911-911 (bg #0 + 911)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 1121-1136
 Group 71: (Blocks 2326528-2359295) [INODE_UNINIT]
-  Block bitmap at 744 (bg #0 + 744), Inode bitmap at 1256 (bg #0 + 1256)
-  Inode table at 1768-1768 (bg #0 + 1768)
+  Block bitmap at 744 (bg #0 + 744), Inode bitmap at 828 (bg #0 + 828)
+  Inode table at 912-912 (bg #0 + 912)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 1137-1152
 Group 72: (Blocks 2359296-2392063) [INODE_UNINIT]
-  Block bitmap at 745 (bg #0 + 745), Inode bitmap at 1257 (bg #0 + 1257)
-  Inode table at 1769-1769 (bg #0 + 1769)
+  Block bitmap at 745 (bg #0 + 745), Inode bitmap at 829 (bg #0 + 829)
+  Inode table at 913-913 (bg #0 + 913)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 1153-1168
 Group 73: (Blocks 2392064-2424831) [INODE_UNINIT]
-  Block bitmap at 746 (bg #0 + 746), Inode bitmap at 1258 (bg #0 + 1258)
-  Inode table at 1770-1770 (bg #0 + 1770)
+  Block bitmap at 746 (bg #0 + 746), Inode bitmap at 830 (bg #0 + 830)
+  Inode table at 914-914 (bg #0 + 914)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 1169-1184
 Group 74: (Blocks 2424832-2457599) [INODE_UNINIT]
-  Block bitmap at 747 (bg #0 + 747), Inode bitmap at 1259 (bg #0 + 1259)
-  Inode table at 1771-1771 (bg #0 + 1771)
+  Block bitmap at 747 (bg #0 + 747), Inode bitmap at 831 (bg #0 + 831)
+  Inode table at 915-915 (bg #0 + 915)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 1185-1200
 Group 75: (Blocks 2457600-2490367) [INODE_UNINIT]
-  Block bitmap at 748 (bg #0 + 748), Inode bitmap at 1260 (bg #0 + 1260)
-  Inode table at 1772-1772 (bg #0 + 1772)
+  Block bitmap at 748 (bg #0 + 748), Inode bitmap at 832 (bg #0 + 832)
+  Inode table at 916-916 (bg #0 + 916)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 1201-1216
 Group 76: (Blocks 2490368-2523135) [INODE_UNINIT]
-  Block bitmap at 749 (bg #0 + 749), Inode bitmap at 1261 (bg #0 + 1261)
-  Inode table at 1773-1773 (bg #0 + 1773)
+  Block bitmap at 749 (bg #0 + 749), Inode bitmap at 833 (bg #0 + 833)
+  Inode table at 917-917 (bg #0 + 917)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 1217-1232
 Group 77: (Blocks 2523136-2555903) [INODE_UNINIT]
-  Block bitmap at 750 (bg #0 + 750), Inode bitmap at 1262 (bg #0 + 1262)
-  Inode table at 1774-1774 (bg #0 + 1774)
+  Block bitmap at 750 (bg #0 + 750), Inode bitmap at 834 (bg #0 + 834)
+  Inode table at 918-918 (bg #0 + 918)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 1233-1248
 Group 78: (Blocks 2555904-2588671) [INODE_UNINIT]
-  Block bitmap at 751 (bg #0 + 751), Inode bitmap at 1263 (bg #0 + 1263)
-  Inode table at 1775-1775 (bg #0 + 1775)
+  Block bitmap at 751 (bg #0 + 751), Inode bitmap at 835 (bg #0 + 835)
+  Inode table at 919-919 (bg #0 + 919)
   0 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 
   Free inodes: 1249-1264
 Group 79: (Blocks 2588672-2621439) [INODE_UNINIT]
-  Block bitmap at 752 (bg #0 + 752), Inode bitmap at 1264 (bg #0 + 1264)
-  Inode table at 1776-1776 (bg #0 + 1776)
+  Block bitmap at 752 (bg #0 + 752), Inode bitmap at 836 (bg #0 + 836)
+  Inode table at 920-920 (bg #0 + 920)
   30047 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 2591393-2621439
   Free inodes: 1265-1280
 Group 80: (Blocks 2621440-2654207) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 753 (bg #0 + 753), Inode bitmap at 1265 (bg #0 + 1265)
-  Inode table at 1777-1777 (bg #0 + 1777)
+  Block bitmap at 753 (bg #0 + 753), Inode bitmap at 837 (bg #0 + 837)
+  Inode table at 921-921 (bg #0 + 921)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 2621440-2654207
   Free inodes: 1281-1296
 Group 81: (Blocks 2654208-2686975) [INODE_UNINIT, BLOCK_UNINIT]
   Backup superblock at 2654208, Group descriptors at 2654209-2654209
   Reserved GDT blocks at 2654210-2654880
-  Block bitmap at 754 (bg #0 + 754), Inode bitmap at 1266 (bg #0 + 1266)
-  Inode table at 1778-1778 (bg #0 + 1778)
+  Block bitmap at 754 (bg #0 + 754), Inode bitmap at 838 (bg #0 + 838)
+  Inode table at 922-922 (bg #0 + 922)
   32095 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 2654881-2686975
   Free inodes: 1297-1312
 Group 82: (Blocks 2686976-2719743) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 755 (bg #0 + 755), Inode bitmap at 1267 (bg #0 + 1267)
-  Inode table at 1779-1779 (bg #0 + 1779)
+  Block bitmap at 755 (bg #0 + 755), Inode bitmap at 839 (bg #0 + 839)
+  Inode table at 923-923 (bg #0 + 923)
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 2686976-2719743
   Free inodes: 1313-1328
 Group 83: (Blocks 2719744-2749999) [INODE_UNINIT]
-  Block bitmap at 756 (bg #0 + 756), Inode bitmap at 1268 (bg #0 + 1268)
-  Inode table at 1780-1780 (bg #0 + 1780)
+  Block bitmap at 756 (bg #0 + 756), Inode bitmap at 840 (bg #0 + 840)
+  Inode table at 924-924 (bg #0 + 924)
   30256 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 2719744-2749999
   Free inodes: 1329-1344
-- 
2.0.0

