From: Celine Bourde <celine.bourde@bull.net>
Subject: flexbg metadata offset
Date: Wed, 23 Apr 2008 18:38:48 +0200
Message-ID: <20080423163848.GD21318@bourdec>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jrs@us.ibm.com, valerie.clement@bull.net,
	Solofo.Ramangalahy@bull.net, celine.bourde@bull.net
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57772 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbYDWQiw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2008 12:38:52 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


There is a problem on offset metadata. In all flexbg groups the block
between the last block bitmap and the first inode bitmap is not used,
which introduces a hole.

This patch changes this. It corrects the offset of flexbg metadata,
specifically at the end of the disk, if the number of groups isn't
a multiple of the -G option argument.

C=E9line Bourde.

Signed-off-by: Bourde Celine <celine.bourde@bull.net>

diff -r -u a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
--- a/lib/ext2fs/alloc_tables.c	2008-04-23 17:32:39.000000000 -0400
+++ b/lib/ext2fs/alloc_tables.c	2008-04-23 17:31:52.000000000 -0400
@@ -84,7 +84,7 @@
 	errcode_t	retval;
 	blk_t		group_blk, start_blk, last_blk, new_blk, blk;
 	dgrp_t		last_grp;
-	int		j, rem_grps, flexbg_size =3D 0;
+	int		j, rem_grps, flexbg_size =3D 0, last_flexbg_size =3D 0;
=20
 	group_blk =3D ext2fs_group_first_block(fs, group);
 	last_blk =3D ext2fs_group_last_block(fs, group);
@@ -96,10 +96,14 @@
 				      EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
 	    fs->super->s_log_groups_per_flex) {
 		flexbg_size =3D 1 << fs->super->s_log_groups_per_flex;
+		last_flexbg_size =3D fs->group_desc_count -
+				((group / flexbg_size) * flexbg_size);
 		last_grp =3D group | (flexbg_size - 1);
-		rem_grps =3D last_grp - group;
 		if (last_grp > fs->group_desc_count)
 			last_grp =3D fs->group_desc_count;
+		if (last_flexbg_size > flexbg_size)
+			last_flexbg_size =3D flexbg_size;
+		rem_grps =3D last_grp - group;
 	}
 =09
 	/*
@@ -151,7 +155,8 @@
 		if (group && fs->group_desc[group-1].bg_inode_bitmap)
 			prev_block =3D fs->group_desc[group-1].bg_inode_bitmap;
 		start_blk =3D flexbg_offset(fs, group, prev_block, bmap,
-						 flexbg_size, rem_grps);
+						 last_flexbg_size - 1,
+						 rem_grps);
 		last_blk =3D ext2fs_group_last_block(fs, last_grp);
 	}
=20
@@ -182,7 +187,7 @@
 		if (group && fs->group_desc[group-1].bg_inode_table)
 			prev_block =3D fs->group_desc[group-1].bg_inode_table;
 		group_blk =3D flexbg_offset(fs, group, prev_block, bmap,
-						 flexbg_size * 2,
+						 last_flexbg_size * 2 - 1,
 						 fs->inode_blocks_per_group *
 						 rem_grps);
 		last_blk =3D ext2fs_group_last_block(fs, last_grp);

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
