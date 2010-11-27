From: Andreas Dilger <andreas.dilger@oracle.com>
Subject: Re: [PATCH] fix debugfs output for flex_bg bitmap offsets
Date: Fri, 26 Nov 2010 17:33:27 -0700
Message-ID: <B5F6E86E-D94A-4ECC-9B55-FCE9E219DFF1@oracle.com>
References: <BFE21949-F817-40EF-8A9C-8B30E0530D4A@dilger.ca> <A5A44A8A-41F5-4A2A-9289-CEA37F7ABC8B@dilger.ca>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: multipart/mixed; boundary=Apple-Mail-3--1021804785
Cc: Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:30400 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab0K0AeV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Nov 2010 19:34:21 -0500
In-Reply-To: <A5A44A8A-41F5-4A2A-9289-CEA37F7ABC8B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail-3--1021804785
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On 2010-11-25, at 12:09, Andreas Dilger wrote:
> ...with patch this time...

Attached is an updated patch that makes the output a bit more verbose =
(to avoid line wraps) and doesn't fail the m_raid_opts test (which =
complains when "(+0)" is printed for each inode table).

> On 2010-11-25, at 02:57, Andreas Dilger wrote:
>> When running debugfs on a filesystem formatted with flex_bg, it =
prints out the relative offsets for the bitmaps and inode table badly on =
64-bit systems, because the offset is computed as a large positive =
number instead of being a negative numer (which will not be printed at =
all):
>>=20
>> Group 1: (Blocks 0x8000-0xffff) [INODE_UNINIT, ITABLE_ZEROED]
>> Block bitmap at 0x0102 (+4294934786), Inode bitmap at 0x0202 =
(+4294935042)
>> Inode table at 0x037e-0x03fa (+4294935422)
>>=20
>> The attached patch prints out the relative offsets for flex_bg groups =
as the offset within the reported group.  This makes it more clear where =
the metadata is located, rather than simply printing some large negative =
number.
>>=20
>> Group 1: (Blocks 0x8000-0xffff) [INODE_UNINIT, ITABLE_ZEROED]
>> Block bitmap at 0x0102 (group 0 +258), Inode bitmap at 0x0202 (group =
0 +514)
>> Inode table at 0x037e-0x03fa (group 0 +894)
>>=20
>> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
>> --
>=20


Cheers, Andreas
--
Andreas Dilger
Lustre Technical Lead
Oracle Corporation Canada Inc.

--Apple-Mail-3--1021804785
Content-Disposition: attachment;
	filename=e2fsprogs-dumpe2fs_flex.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="e2fsprogs-dumpe2fs_flex.patch"
Content-Transfer-Encoding: 7bit

diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index a70cc4e..c39c713 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -126,10 +126,22 @@ static void print_bg_opts(ext2_filsys fs, dgrp_t i)
 	fputc('\n', stdout);
 }
 
+static void print_bg_rel_offset(ext2_filsys fs, blk64_t block, int itable,
+				blk64_t first_block, blk64_t last_block)
+{
+	if (block >= (first_block + !!itable) && block <= last_block) {
+		printf(" (+%u)", (unsigned)(block - first_block));
+	} else if (fs->super->s_feature_incompat &
+		   EXT4_FEATURE_INCOMPAT_FLEX_BG) {
+		dgrp_t flex_grp = ext2fs_group_of_blk(fs, block);
+		printf(" (grp %u+%u)", flex_grp,
+		       (unsigned)(block-ext2fs_group_first_block(fs,flex_grp)));
+	}
+}
+
 static void list_desc (ext2_filsys fs)
 {
 	unsigned long i;
-	long diff;
 	blk_t	first_block, last_block;
 	blk_t	super_blk, old_desc_blk, new_desc_blk;
 	char *block_bitmap=NULL, *inode_bitmap=NULL;
@@ -199,21 +211,21 @@ static void list_desc (ext2_filsys fs)
 			fputc('\n', stdout);
 		fputs(_("  Block bitmap at "), stdout);
 		print_number(fs->group_desc[i].bg_block_bitmap);
-		diff = fs->group_desc[i].bg_block_bitmap - first_block;
-		if (diff >= 0)
-			printf(" (+%ld)", diff);
+		print_bg_rel_offset(fs, fs->group_desc[i].bg_block_bitmap, 0,
+				    first_block, last_block);
+
 		fputs(_(", Inode bitmap at "), stdout);
 		print_number(fs->group_desc[i].bg_inode_bitmap);
-		diff = fs->group_desc[i].bg_inode_bitmap - first_block;
-		if (diff >= 0)
-			printf(" (+%ld)", diff);
+		print_bg_rel_offset(fs, fs->group_desc[i].bg_inode_bitmap, 0,
+				    first_block, last_block);
+
 		fputs(_("\n  Inode table at "), stdout);
 		print_range(fs->group_desc[i].bg_inode_table,
 			    fs->group_desc[i].bg_inode_table +
 			    inode_blocks_per_group - 1);
-		diff = fs->group_desc[i].bg_inode_table - first_block;
-		if (diff > 0)
-			printf(" (+%ld)", diff);
+		print_bg_rel_offset(fs, fs->group_desc[i].bg_inode_table, 1,
+				    first_block, last_block);
+
 		printf (_("\n  %u free blocks, %u free inodes, "
 			  "%u directories%s"),
 			fs->group_desc[i].bg_free_blocks_count,

--Apple-Mail-3--1021804785--
