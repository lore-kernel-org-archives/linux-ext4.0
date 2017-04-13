From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] e2fsck: add support for large xattrs in external inodes
Date: Thu, 13 Apr 2017 14:10:32 -0600
Message-ID: <015F68EE-7A9F-4111-A5DD-0F3FFE42F726@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_255390A4-4227-430E-8A02-FE9935BE81CD";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Ts'o Theodore <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:35361 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755452AbdDMUKg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Apr 2017 16:10:36 -0400
Received: by mail-io0-f194.google.com with SMTP id d203so13038287iof.2
        for <linux-ext4@vger.kernel.org>; Thu, 13 Apr 2017 13:10:36 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_255390A4-4227-430E-8A02-FE9935BE81CD
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Add support for the INCOMPAT_EA_INODE feature, which stores large
extended attributes into an external inode instead of data blocks.
The inode is referenced by the e_value_inum field (formerly the
unused e_value_block field) from the extent header, and stores the
xattr data starting at byte offset 0 in the inode data block.

The xattr inode stores the referring inode number in its i_mtime,
and the parent i_generation in its own i_generation, so that there
is a solid linkage between the two that e2fsck can verify.  The
xattr inode is itself marked with EXT4_EA_INODE_FL as well.

Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---

This patch is still based on the old "maint" branch, and is in the
middle of a patch series, so will not apply to master e2fsprogs at
this point, but is mostly for review with the matching ext4 patch.

 debugfs/debugfs.c          |  16 +++-
 e2fsck/e2fsck.h            |   1 +
 e2fsck/pass1.c             | 194 =
+++++++++++++++++++++++++++++++++++++--------
 e2fsck/pass4.c             |  17 ++++
 e2fsck/problem.c           |  21 +++++
 e2fsck/problem.h           |  13 +++
 lib/e2p/feature.c          |   2 +
 lib/ext2fs/ext2_ext_attr.h |   5 +-
 lib/ext2fs/ext2_fs.h       |   3 +-
 lib/ext2fs/ext2fs.h        |   2 +
 lib/ext2fs/ext_attr.c      |  27 +++++--
 lib/ext2fs/swapfs.c        |   2 +-
 misc/mke2fs.c              |   1 +
 misc/tune2fs.c             |   5 ++
 14 files changed, 263 insertions(+), 46 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 5423634..5baa93c 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -550,22 +550,32 @@ static void internal_dump_inode_extra(FILE *out,
 		end =3D (char *) inode + =
EXT2_INODE_SIZE(current_fs->super);
 		start =3D (char *) magic + sizeof(__u32);
 		entry =3D (struct ext2_ext_attr_entry *) start;
+
 		while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
 			struct ext2_ext_attr_entry *next =3D
 				EXT2_EXT_ATTR_NEXT(entry);
 			char *name =3D EXT2_EXT_ATTR_NAME(entry);
 			char *value =3D start + entry->e_value_offs;
+			char ea_inode =3D
+				=
EXT2_HAS_INCOMPAT_FEATURE(current_fs->super,
+					EXT4_FEATURE_INCOMPAT_EA_INODE) =
&&
+					entry->e_value_offs =3D=3D 0 &&
+					entry->e_value_inum !=3D 0;

 			if (name + entry->e_name_len >=3D end ||
-			    value + entry->e_value_size >=3D end ||
-			    (char *) next >=3D end) {
+			    (!ea_inode && value + entry->e_value_size >=3D=
 end) ||
+			    (char *)next >=3D end) {
 				fprintf(out, "invalid EA entry in =
inode\n");
 				return;
 			}
 			fprintf(out, "  ");
 			dump_xattr_string(out, name, entry->e_name_len);
 			fprintf(out, " =3D \"");
-			dump_xattr_string(out, value, =
entry->e_value_size);
+			if (ea_inode)
+				fprintf(out, "inode <%u>", =
entry->e_value_inum);
+			else
+				dump_xattr_string(out, value,
+						  entry->e_value_size);
 			fprintf(out, "\" (%u)\n", entry->e_value_size);
 			entry =3D next;
 		}
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index fca41a1..a3e6c63 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -279,6 +279,7 @@ struct e2fsck_struct {
 	ext2fs_inode_bitmap inode_bb_map; /* Inodes which are in bad =
blocks */
 	ext2fs_inode_bitmap inode_imagic_map; /* AFS inodes */
 	ext2fs_inode_bitmap inode_reg_map; /* Inodes which are regular =
files*/
+	ext2fs_inode_bitmap inode_ea_map; /* EA inodes which are =
non-orphan */

 	ext2fs_block_bitmap block_found_map; /* Blocks which are in use =
*/
 	ext2fs_block_bitmap block_dup_map; /* Blks referenced more than =
once */
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index e171df4..e1d5c02 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -28,6 +28,7 @@
  * 	- A bitmap of which blocks are in use.		=
(block_found_map)
  * 	- A bitmap of which blocks are in use by two inodes	=
(block_dup_map)
  * 	- The data blocks of the directory inodes.	(dir_map)
+ *	- A bitmap of EA inodes.			(inode_ea_map)
  *
  * Pass 1 is designed to stash away enough information so that the
  * other passes should not need to read in the inode information
@@ -272,6 +273,120 @@ static void check_size(e2fsck_t ctx, struct =
problem_context *pctx)
 	e2fsck_write_inode(ctx, pctx->ino, pctx->inode, "pass1");
 }

+static void e2fsck_block_alloc_stats(ext2_filsys fs, blk64_t blk, int =
inuse)
+{
+	e2fsck_t ctx =3D (e2fsck_t) fs->priv_data;
+
+	if (ctx->block_found_map) {
+		if (inuse > 0)
+			ext2fs_mark_block_bitmap2(ctx->block_found_map, =
blk);
+		else
+			=
ext2fs_unmark_block_bitmap2(ctx->block_found_map, blk);
+	}
+}
+
+static void mark_inode_ea_map(e2fsck_t ctx, struct problem_context =
*pctx,
+			      ext2_ino_t ino)
+{
+	if (!ctx->inode_ea_map) {
+		pctx->errcode =3D ext2fs_allocate_inode_bitmap(ctx->fs,
+					 _("EA inode map"),
+					 &ctx->inode_ea_map);
+		if (pctx->errcode) {
+			fix_problem(ctx, PR_1_ALLOCATE_IBITMAP_ERROR,
+				    pctx);
+			exit(1);
+		}
+	}
+
+	ext2fs_mark_inode_bitmap2(ctx->inode_ea_map, ino);
+}
+
+/*
+ * Delete an EA entry. If this is the last entry to be deleted, then =
i_file_acl
+ * must have been freed, so we must update e2fsck block statistics and =
set
+ * i_file_acl_deleted.
+ * When we delete the entry successfully, this function returns 0, else
+ * non-zero value.
+ */
+
+static int e2fsck_ea_entry_delete(e2fsck_t ctx,
+				  struct ext2_ext_attr_entry *entry,
+				  struct problem_context *pctx,
+				  int *i_file_acl_deleted, problem_t =
prob)
+{
+	blk_t i_file_acl =3D pctx->inode->i_file_acl;
+	int err =3D 1;
+
+	pctx->num =3D entry->e_value_inum;
+
+	if (fix_problem(ctx, prob, pctx)) {
+		/* Delete corrupt EA entry */
+		err =3D ext2fs_attr_set(ctx->fs, pctx->ino, pctx->inode,
+				      entry->e_name_index, =
entry->e_name,
+				      0, 0, 0);
+		if (err =3D=3D 0) {
+			if (i_file_acl && pctx->inode->i_file_acl =3D=3D =
0) {
+				e2fsck_block_alloc_stats(ctx->fs, =
i_file_acl,
+							 -1);
+				*i_file_acl_deleted =3D 1;
+			}
+			return 0;
+		}
+	}
+
+	return err;
+}
+
+/*
+ * Check validity of EA inode. Return 0 if EA inode is valid, nonzero =
otherwise.
+ */
+static int check_large_ea_inode(e2fsck_t ctx, struct =
ext2_ext_attr_entry *entry,
+				struct problem_context *pctx,
+				int *i_file_acl_deleted)
+{
+	struct ext2_inode inode;
+	int ret =3D 0;
+
+	/* Check if inode is within valid range */
+	if ((entry->e_value_inum < EXT2_FIRST_INODE(ctx->fs->super)) ||
+	    (entry->e_value_inum > ctx->fs->super->s_inodes_count)) {
+		ret =3D e2fsck_ea_entry_delete(ctx, entry, pctx,
+					     i_file_acl_deleted,
+					     PR_1_ATTR_VALUE_EA_INODE);
+		/* If user refuses to delete this entry, caller may try =
to set
+		 * the bit for this out-of-bound inode in inode_ea_map, =
so
+		 * always return failure */
+		return 1;
+	}
+
+	e2fsck_read_inode(ctx, entry->e_value_inum, &inode, "pass1");
+	if (!(inode.i_flags & EXT4_EA_INODE_FL)) {
+		/* If EXT4_EA_INODE_FL flag is not present but =
back-pointer
+		 * matches then we should set this flag */
+		if (inode.i_mtime =3D=3D pctx->ino &&
+		    inode.i_generation =3D=3D pctx->inode->i_generation =
&&
+		    fix_problem(ctx, PR_1_ATTR_SET_EA_INODE_FL, pctx)) {
+			inode.i_flags |=3D EXT4_EA_INODE_FL;
+			ext2fs_write_inode(ctx->fs, =
entry->e_value_inum,&inode);
+		} else {
+			ret =3D e2fsck_ea_entry_delete(ctx, entry, pctx,
+						     i_file_acl_deleted,
+						     =
PR_1_ATTR_NO_EA_INODE_FL);
+			goto out;
+		}
+	} else if (inode.i_mtime !=3D pctx->ino ||
+		   inode.i_generation !=3D pctx->inode->i_generation) {
+		ret =3D e2fsck_ea_entry_delete(ctx, entry, pctx,
+					     i_file_acl_deleted,
+					     PR_1_ATTR_INVAL_EA_INODE);
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
 static void check_ea_in_inode(e2fsck_t ctx, struct problem_context =
*pctx)
 {
 	struct ext2_super_block *sb =3D ctx->fs->super;
@@ -315,16 +430,26 @@ static void check_ea_in_inode(e2fsck_t ctx, struct =
problem_context *pctx)
 			goto fix;
 		}

-		/* e_value_block must be 0 in inode's ea */
-		if (entry->e_value_block !=3D 0) {
-			pctx->num =3D entry->e_value_block;
-			problem =3D PR_1_ATTR_VALUE_BLOCK;
-			goto fix;
+		if (entry->e_value_inum =3D=3D 0) {
+			/* check value size */
+			if (entry->e_value_size > remain) {
+				pctx->num =3D entry->e_value_size;
+				problem =3D PR_1_ATTR_VALUE_SIZE;
+				goto fix;
+			}
+		} else {
+			int ret, tmp;
+
+			ret =3D check_large_ea_inode(ctx, entry, pctx, =
&tmp);
+			if (ret =3D=3D 0)
+				mark_inode_ea_map(ctx, pctx,
+						  entry->e_value_inum);
 		}

 		/* Value size cannot be larger than EA space in inode */
 		if (entry->e_value_offs > storage_size ||
-		    entry->e_value_offs + entry->e_value_size > =
storage_size) {
+		    (entry->e_value_inum =3D=3D 0 &&
+		    entry->e_value_offs + entry->e_value_size > =
storage_size)) {
 			problem =3D PR_1_INODE_EA_BAD_VALUE;
 			goto fix;
 		}
@@ -339,7 +464,10 @@ static void check_ea_in_inode(e2fsck_t ctx, struct =
problem_context *pctx)
 			goto fix;
 		}

-		remain -=3D entry->e_value_size;
+		/* If EA value is stored in external inode then it does =
not
+		 * consume space here */
+		if (entry->e_value_inum =3D=3D 0)
+			remain -=3D entry->e_value_size;

 		entry =3D EXT2_EXT_ATTR_NEXT(entry);
 	}
@@ -628,7 +756,7 @@ int e2fsck_pass1_delete_attr(e2fsck_t ctx, struct =
ext2_inode_large *inode,
 		if (EXT2_EXT_IS_LAST_ENTRY(entry)) {
 			if (in_inode) {
 				entry =3D entry_blk;
-			        len =3D sizeof(entry->e_name);
+				len =3D sizeof(entry->e_name);
 				entry_size =3D =
ext2fs_attr_get_next_attr(entry,
 							index, name, =
len, 1);
 				in_inode =3D 0;
@@ -1774,6 +1902,7 @@ static int check_ext_attr(e2fsck_t ctx, struct =
problem_context *pctx,
 	struct ext2_ext_attr_entry *entry;
 	int		count;
 	region_t	region =3D 0;
+	int ret;

 	blk =3D ext2fs_file_acl_block(fs, inode);
 	if (blk =3D=3D 0)
@@ -1896,19 +2025,30 @@ static int check_ext_attr(e2fsck_t ctx, struct =
problem_context *pctx,
 				goto clear_extattr;
 			break;
 		}
-		if (entry->e_value_block !=3D 0) {
-			if (fix_problem(ctx, PR_1_EA_BAD_VALUE, pctx))
-				goto clear_extattr;
-		}
-		if (entry->e_value_offs + entry->e_value_size > =
fs->blocksize) {
-			if (fix_problem(ctx, PR_1_EA_BAD_VALUE, pctx))
-				goto clear_extattr;
-			break;
-		}
-		if (entry->e_value_size &&
-		    region_allocate(region, entry->e_value_offs,
-				    =
EXT2_EXT_ATTR_SIZE(entry->e_value_size))) {
-			if (fix_problem(ctx, PR_1_EA_ALLOC_COLLISION, =
pctx))
+		if (entry->e_value_inum =3D=3D 0) {
+			if (entry->e_value_offs + entry->e_value_size >
+			    fs->blocksize) {
+				if (fix_problem(ctx, PR_1_EA_BAD_VALUE, =
pctx))
+					goto clear_extattr;
+				break;
+			}
+			if (entry->e_value_size &&
+			    region_allocate(region, entry->e_value_offs,
+					    =
EXT2_EXT_ATTR_SIZE(entry->e_value_size))) {
+				if (fix_problem(ctx, =
PR_1_EA_ALLOC_COLLISION,
+						pctx))
+					goto clear_extattr;
+			}
+		} else {
+			int i_file_acl_deleted =3D 0;
+
+			ret =3D check_large_ea_inode(ctx, entry, pctx,
+						   &i_file_acl_deleted);
+			if (ret =3D=3D 0)
+				mark_inode_ea_map(ctx, pctx,
+						  entry->e_value_inum);
+
+			if (i_file_acl_deleted)
 				goto clear_extattr;
 		}

@@ -3338,18 +3478,6 @@ static errcode_t =
e2fsck_get_alloc_block(ext2_filsys fs, blk64_t goal,
 	return (0);
 }

-static void e2fsck_block_alloc_stats(ext2_filsys fs, blk64_t blk, int =
inuse)
-{
-	e2fsck_t ctx =3D (e2fsck_t) fs->priv_data;
-
-	if (ctx->block_found_map) {
-		if (inuse > 0)
-			ext2fs_mark_block_bitmap2(ctx->block_found_map, =
blk);
-		else
-			=
ext2fs_unmark_block_bitmap2(ctx->block_found_map, blk);
-	}
-}
-
 void e2fsck_use_inode_shortcuts(e2fsck_t ctx, int use_shortcuts)
 {
 	ext2_filsys fs =3D ctx->fs;
diff --git a/e2fsck/pass4.c b/e2fsck/pass4.c
index 09714ad..81fd846 100644
--- a/e2fsck/pass4.c
+++ b/e2fsck/pass4.c
@@ -11,6 +11,7 @@
  * Pass 4 frees the following data structures:
  * 	- A bitmap of which inodes are in bad blocks.	(inode_bb_map)
  * 	- A bitmap of which inodes are imagic inodes.	=
(inode_imagic_map)
+ *	- A bitmap of EA inodes.			(inode_ea_map)
  */

 #include "config.h"
@@ -40,6 +41,20 @@ static int disconnect_inode(e2fsck_t ctx, ext2_ino_t =
i,
 	} else {
 		e2fsck_read_inode(ctx, i, inode, "pass4: =
disconnect_inode");
 	}
+
+	if (inode->i_flags & EXT4_EA_INODE_FL) {
+		if (ext2fs_test_inode_bitmap2(ctx->inode_ea_map, i)) {
+			ext2fs_icount_store(ctx->inode_count, i, 1);
+			return 0;
+		} else {
+			/* Zero the link count so that when inode is =
linked to
+			 * lost+found it has correct link count */
+			inode->i_links_count =3D 0;
+			e2fsck_write_inode(ctx, i, inode, =
"disconnect_inode");
+			ext2fs_icount_store(ctx->inode_link_info, i, 0);
+		}
+	}
+
 	clear_problem_context(&pctx);
 	pctx.ino =3D i;
 	pctx.inode =3D inode;
@@ -185,6 +200,8 @@ void e2fsck_pass4(e2fsck_t ctx)
 	ext2fs_free_icount(ctx->inode_link_info); ctx->inode_link_info =3D=
 0;
 	ext2fs_free_icount(ctx->inode_count); ctx->inode_count =3D 0;
 	ext2fs_free_icount(ctx->inode_badness); ctx->inode_badness =3D =
0;
+	ext2fs_free_inode_bitmap(ctx->inode_ea_map);
+	ctx->inode_ea_map =3D 0;
 	ext2fs_free_inode_bitmap(ctx->inode_bb_map);
 	ctx->inode_bb_map =3D 0;
 	ext2fs_free_inode_bitmap(ctx->inode_imagic_map);
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index dd68dfe..812cc18 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1035,6 +1035,27 @@ static struct e2fsck_problem problem_table[] =3D =
{
 	  N_("@i %i creation time (%t) invalid.\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK | PR_NO_OK },

+	/* Inode has illegal extended attribute value inode */
+	{ PR_1_ATTR_VALUE_EA_INODE,
+	  N_("@i %i has @I @a value @i %N.\n"),
+	  PROMPT_FIX, PR_PREEN_OK },
+
+	/* Invalid backpointer from extended attribute inode to parent =
inode */
+	{ PR_1_ATTR_INVAL_EA_INODE,
+	  N_("@n backpointer from @a @i %N to parent @i %i.\n"),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
+	/* Inode has invalid extended attribute. EA inode missing
+	 * EA_INODE flag. */
+	{ PR_1_ATTR_NO_EA_INODE_FL,
+	  N_("@i %i has @n @a. EA @i %N missing EA_INODE flag.\n"),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
+	/* EA inode for parent inode missing EA_INODE flag. */
+	{ PR_1_ATTR_SET_EA_INODE_FL,
+	  N_("EA @i %N for parent @i %i missing EA_INODE flag.\n "),
+	  PROMPT_FIX, PR_PREEN_OK },
+

 	/* Pass 1b errors */

diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 8b57560..5d71557 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -621,6 +621,19 @@ struct problem_context {
 /* invalid inode creation time */
 #define PR_1_CRTIME_BAD			0x010089

+/* Inode has illegal EA value inode */
+#define PR_1_ATTR_VALUE_EA_INODE	0x01008A
+
+/* Invalid backpointer from EA inode to parent inode */
+#define PR_1_ATTR_INVAL_EA_INODE	0x01008B
+
+/* Parent inode has invalid EA entry. EA inode does not have
+ * EXT4_EA_INODE_FL flag. Delete EA entry? */
+#define PR_1_ATTR_NO_EA_INODE_FL	0x01008C
+
+/* EA inode for parent inode does not have EXT4_EA_INODE_FL flag */
+#define PR_1_ATTR_SET_EA_INODE_FL	0x01008D
+

 /*
  * Pass 1b errors
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 1d3e689..2ff95dc 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -91,6 +91,8 @@ static struct feature feature_list[] =3D {
 			"flex_bg"},
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_EA_INODE,
 			"ea_inode"},
+	{	E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_EA_INODE,
+			"large_xattr" },
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_DIRDATA,
 			"dirdata"},
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_LARGEDIR,
diff --git a/lib/ext2fs/ext2_ext_attr.h b/lib/ext2fs/ext2_ext_attr.h
index 755024e..2cd17fc 100644
--- a/lib/ext2fs/ext2_ext_attr.h
+++ b/lib/ext2fs/ext2_ext_attr.h
@@ -30,7 +30,7 @@ struct ext2_ext_attr_entry {
 	__u8	e_name_len;	/* length of name */
 	__u8	e_name_index;	/* attribute name index */
 	__u16	e_value_offs;	/* offset in disk block of value */
-	__u32	e_value_block;	/* disk block attribute is stored on =
(n/i) */
+	__u32	e_value_inum;	/* inode in which the value is stored */
 	__u32	e_value_size;	/* size of attribute value */
 	__u32	e_hash;		/* hash value of name and value */
 #if 1
@@ -48,6 +48,9 @@ struct ext2_xattr_ibody_header {
 		    EXT2_GOOD_OLD_INODE_SIZE + (inode)->i_extra_isize))
 #define ENTRY(ptr) ((struct ext2_ext_attr_entry *)(ptr))

+#define EXT4_XATTR_MIN_LARGE_EA_SIZE(b)	((b) >> 1)
+#define EXT4_XATTR_MAX_LARGE_EA_SIZE	(1024 * 1024)
+
 /* Name indexes */
 #define EXT2_ATTR_INDEX_USER			1
 #define EXT2_ATTR_INDEX_POSIX_ACL_ACCESS	2
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 1d591ec..cbc230f 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -741,7 +741,8 @@ struct ext2_super_block {

 #define EXT2_FEATURE_COMPAT_SUPP	0
 #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| =
\
-				       EXT4_FEATURE_INCOMPAT_MMP)
+				       EXT4_FEATURE_INCOMPAT_MMP| \
+				       EXT4_FEATURE_INCOMPAT_EA_INODE)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	=
(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 =
EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 =
EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 15b4ee5..501b610 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -577,6 +577,7 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
 					 EXT4_FEATURE_INCOMPAT_MMP|\
+					 =
EXT4_FEATURE_INCOMPAT_EA_INODE|\
 					 EXT4_FEATURE_INCOMPAT_64BIT)
 #else
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	=
(EXT2_FEATURE_INCOMPAT_FILETYPE|\
@@ -586,6 +587,7 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
 					 EXT4_FEATURE_INCOMPAT_MMP|\
+					 =
EXT4_FEATURE_INCOMPAT_EA_INODE|\
 					 EXT4_FEATURE_INCOMPAT_64BIT)
 #endif
 #ifdef CONFIG_QUOTA
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index e69c087..a9d0b62 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -46,7 +46,7 @@ __u32 ext2fs_ext_attr_hash_entry(struct =
ext2_ext_attr_entry *entry, void *data)
 	}

 	/* The hash needs to be calculated on the data in little-endian. =
*/
-	if (entry->e_value_block =3D=3D 0 && entry->e_value_size !=3D 0) =
{
+	if (entry->e_value_inum =3D=3D 0 && entry->e_value_size !=3D 0) =
{
 		__u32 *value =3D (__u32 *)data;
 		for (n =3D (entry->e_value_size + EXT2_EXT_ATTR_ROUND) =
>>
 			 EXT2_EXT_ATTR_PAD_BITS; n; n--) {
@@ -209,6 +209,7 @@ struct ext2_attr_ibody_find {
 };

 struct ext2_attr_block_find {
+	ext2_ino_t ino;
 	struct ext2_attr_search s;
 	char *block;
 };
@@ -221,7 +222,7 @@ void ext2fs_attr_shift_entries(struct =
ext2_ext_attr_entry *entry,

 	/* Adjust the value offsets of the entries */
 	for (; !EXT2_EXT_IS_LAST_ENTRY(last); last =3D =
EXT2_EXT_ATTR_NEXT(last)) {
-		if (!last->e_value_block && last->e_value_size) {
+		if (last->e_value_inum =3D=3D 0 && last->e_value_size) {
 			last->e_value_offs =3D last->e_value_offs +
 							=
value_offs_shift;
 		}
@@ -242,7 +243,7 @@ int ext2fs_attr_free_space(struct =
ext2_ext_attr_entry *last,
 {
 	for (; !EXT2_EXT_IS_LAST_ENTRY(last); last =3D =
EXT2_EXT_ATTR_NEXT(last)) {
 		*total +=3D EXT2_EXT_ATTR_LEN(last->e_name_len);
-		if (!last->e_value_block && last->e_value_size) {
+		if (last->e_value_inum =3D=3D 0 && last->e_value_size) {
 			int offs =3D last->e_value_offs;
 			if (offs < *min_offs)
 				*min_offs =3D offs;
@@ -378,7 +379,7 @@ static errcode_t ext2fs_attr_set_entry(ext2_filsys =
fs, struct ext2_attr_info *i,
 	/* Compute min_offs and last. */
 	for (last =3D s->first; !EXT2_EXT_IS_LAST_ENTRY(last);
 	     last =3D EXT2_EXT_ATTR_NEXT(last)) {
-		if (!last->e_value_block && last->e_value_size) {
+		if (last->e_value_inum =3D=3D 0 && last->e_value_size) {
 			int offs =3D last->e_value_offs;

 			if (offs < min_offs)
@@ -388,7 +389,7 @@ static errcode_t ext2fs_attr_set_entry(ext2_filsys =
fs, struct ext2_attr_info *i,
 	free =3D min_offs - ((char *)last - s->base) - sizeof(__u32);

 	if (!s->not_found) {
-		if (!s->here->e_value_block && s->here->e_value_size) {
+		if (s->here->e_value_inum =3D=3D 0 && =
s->here->e_value_size) {
 			int size =3D s->here->e_value_size;
 			free +=3D EXT2_EXT_ATTR_SIZE(size);
 		}
@@ -411,7 +412,7 @@ static errcode_t ext2fs_attr_set_entry(ext2_filsys =
fs, struct ext2_attr_info *i,
 		s->here->e_name_len =3D name_len;
 		memcpy(s->here->e_name, i->name, name_len);
 	} else {
-		if (!s->here->e_value_block && s->here->e_value_size) {
+		if (s->here->e_value_inum =3D=3D 0 && =
s->here->e_value_size) {
 			char *first_val =3D s->base + min_offs;
 			int offs =3D s->here->e_value_offs;
 			char *val =3D s->base + offs;
@@ -440,7 +441,7 @@ static errcode_t ext2fs_attr_set_entry(ext2_filsys =
fs, struct ext2_attr_info *i,
 			while (!EXT2_EXT_IS_LAST_ENTRY(last)) {
 				int o =3D last->e_value_offs;

-				if (!last->e_value_block &&
+				if (last->e_value_inum =3D=3D 0 &&
 				    last->e_value_size && o < offs)
 					last->e_value_offs =3D o + size;
 				last =3D EXT2_EXT_ATTR_NEXT(last);
@@ -558,9 +559,20 @@ static errcode_t ext2fs_attr_block_set(ext2_filsys =
fs, struct ext2_inode *inode,
 	/* Update the i_blocks if we added a new EA block */
 	if (!inode->i_file_acl && new_buf)
 		inode->i_blocks +=3D fs->blocksize / 512;
+
+	/* Drop the previous xattr block. */
+	if (!new_buf) {
+		if (!fs->block_map)
+			ext2fs_read_block_bitmap(fs);
+		ext2fs_block_alloc_stats(fs, inode->i_file_acl, -1);
+		inode->i_blocks -=3D fs->blocksize / 512;
+	}
+
 	/* Update the inode. */
 	inode->i_file_acl =3D new_buf ? blk : 0;

+	ext2fs_write_inode(fs, bs->ino, inode);
+
 cleanup:
 	if (clear_flag)
 		ext2fs_free_mem(&s->base);
@@ -870,6 +882,7 @@ errcode_t ext2fs_expand_extra_isize(ext2_filsys fs, =
ext2_ino_t ino,
 		.s =3D { .not_found =3D EXT2_ET_EA_NO_SPACE, },
 	};
 	struct ext2_attr_block_find bs =3D {
+		.ino =3D ino,
 		.s =3D { .not_found =3D EXT2_ET_EA_NO_SPACE, },
 	};
 	char *start, *end, *block_buf =3D NULL, *buffer =3DNULL, =
*b_entry_name=3DNULL;
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 2a7b768..dfb1cab 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -168,7 +168,7 @@ void ext2fs_swap_ext_attr_entry(struct =
ext2_ext_attr_entry *to_entry,
 				struct ext2_ext_attr_entry *from_entry)
 {
 	to_entry->e_value_offs  =3D =
ext2fs_swab16(from_entry->e_value_offs);
-	to_entry->e_value_block =3D =
ext2fs_swab32(from_entry->e_value_block);
+	to_entry->e_value_inum  =3D =
ext2fs_swab32(from_entry->e_value_inum);
 	to_entry->e_value_size  =3D =
ext2fs_swab32(from_entry->e_value_size);
 	to_entry->e_hash	=3D ext2fs_swab32(from_entry->e_hash);
 }
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index a14e62e..c92ff58 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1032,6 +1032,7 @@ static __u32 ok_features[3] =3D {
 		EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|
 		EXT2_FEATURE_INCOMPAT_META_BG|
 		EXT4_FEATURE_INCOMPAT_FLEX_BG|
+		EXT4_FEATURE_INCOMPAT_EA_INODE|
 		EXT4_FEATURE_INCOMPAT_MMP |
 		EXT4_FEATURE_INCOMPAT_64BIT,
 	/* R/O compat */
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index edf496a..ddc7880 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -142,6 +142,7 @@ static __u32 ok_features[3] =3D {
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT3_FEATURE_INCOMPAT_EXTENTS |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
+		EXT4_FEATURE_INCOMPAT_EA_INODE|
 		EXT4_FEATURE_INCOMPAT_MMP,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
@@ -163,6 +164,7 @@ static __u32 clear_ok_features[3] =3D {
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
+		EXT4_FEATURE_INCOMPAT_EA_INODE|
 		EXT4_FEATURE_INCOMPAT_MMP,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
@@ -565,6 +567,9 @@ mmp_error:
 		sb->s_mmp_update_interval =3D 0;
 	}

+	if (FEATURE_ON(E2P_FEATURE_INCOMPAT, =
EXT4_FEATURE_INCOMPAT_EA_INODE))
+		sb->s_feature_incompat |=3D =
EXT4_FEATURE_INCOMPAT_EA_INODE;
+
 	if (FEATURE_ON(E2P_FEATURE_COMPAT, =
EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
 		/*
 		 * If adding a journal flag, let the create journal
--
1.8.0



Cheers, Andreas






--Apple-Mail=_255390A4-4227-430E-8A02-FE9935BE81CD
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFY79s4pIg59Q01vtYRAtLyAJ9bhbwYiY+6X5JQf5JhydOxxgCItACbBsUy
PtjrRz5iAWE+LQfKMSxmL2s=
=o84e
-----END PGP SIGNATURE-----

--Apple-Mail=_255390A4-4227-430E-8A02-FE9935BE81CD--
