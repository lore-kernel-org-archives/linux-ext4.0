From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 2/2] e2fsprogs: Add support for toggling, verifying, and
	fixing inode checksums
Date: Wed, 6 Apr 2011 15:47:33 -0700
Message-ID: <20110406224733.GU32706@tux1.beaverton.ibm.com>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48557 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756298Ab1DFWrd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Apr 2011 18:47:33 -0400
Content-Disposition: inline
In-Reply-To: <20110406224410.GB24354@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds to tune2fs the ability to toggle the inode checksum rocompat
feature flag, to e2fsck the ability to verify and correct inode checksums, and
to debugfs the ability to dump inode checksums.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 debugfs/debugfs.c         |    6 +++++
 e2fsck/pass1.c            |    9 ++++++-
 e2fsck/problem.c          |    5 ++++
 e2fsck/problem.h          |    3 ++
 lib/blkid/probe.h         |    1 +
 lib/e2p/feature.c         |    2 ++
 lib/ext2fs/csum.c         |   59 +++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_err.et.in |    3 ++
 lib/ext2fs/ext2_fs.h      |    3 ++
 lib/ext2fs/ext2fs.h       |    9 ++++++-
 lib/ext2fs/inode.c        |   17 +++++++++++++
 lib/ext2fs/swapfs.c       |    2 ++
 misc/tune2fs.c            |   18 ++++++++++++--
 13 files changed, 132 insertions(+), 5 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index e441bc5..182ac6a 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -509,6 +509,12 @@ static void internal_dump_inode_extra(FILE *out,
 				inode->i_extra_isize);
 		return;
 	}
+
+	if (current_fs->super->s_feature_ro_compat &
+		EXT4_FEATURE_RO_COMPAT_INODE_CSUM &&
+	    inode->i_extra_isize > 4)
+		fprintf(out, "Inode checksum: %x\n", inode->i_checksum);
+
 	storage_size = EXT2_INODE_SIZE(current_fs->super) -
 			EXT2_GOOD_OLD_INODE_SIZE -
 			inode->i_extra_isize;
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 67dd986..58f24bb 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -365,7 +365,7 @@ static void check_inode_extra_space(e2fsck_t ctx, struct problem_context *pctx)
 			inode->i_extra_isize);
 #endif
 	/* i_extra_isize must cover i_extra_isize + i_pad1 at least */
-	min = sizeof(inode->i_extra_isize) + sizeof(inode->i_pad1);
+	min = sizeof(inode->i_extra_isize) + sizeof(inode->i_checksum);
 	max = EXT2_INODE_SIZE(sb) - EXT2_GOOD_OLD_INODE_SIZE;
 	/*
 	 * For now we will allow i_extra_isize to be 0, but really
@@ -729,6 +729,13 @@ void e2fsck_pass1(e2fsck_t ctx)
 			}
 		}
 
+		/* Check for invalid inode checksum */
+		if (!ext2fs_inode_csum_verify(fs, ino,
+			(struct ext2_inode_large *)inode) &&
+		    fix_problem(ctx, PR_1_INODE_CSUM_INVALID, &pctx))
+			e2fsck_write_inode_full(ctx, ino, inode,
+				sizeof(struct ext2_inode_large), "pass1");
+
 		/*
 		 * Test for incorrect extent flag settings.
 		 *
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 8f0b211..6785fa3 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -890,6 +890,11 @@ static struct e2fsck_problem problem_table[] = {
 	     "(size %Is, lblk %r)\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
+	/* Fast symlink has EXTENTS_FL set */
+	{ PR_1_INODE_CSUM_INVALID,
+	  N_("inode %i checksum invalid.  "),
+	  PROMPT_FIX, PR_PREEN_OK },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 7c4c156..388d153 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -520,6 +520,9 @@ struct problem_context {
 /* EOFBLOCKS flag set when not necessary */
 #define PR_1_EOFBLOCKS_FL_SET		0x010060
 
+/* inode checksum invalid */
+#define PR_1_INODE_CSUM_INVALID		0x010061
+
 /*
  * Pass 1b errors
  */
diff --git a/lib/blkid/probe.h b/lib/blkid/probe.h
index 37e80ef..e01a689 100644
--- a/lib/blkid/probe.h
+++ b/lib/blkid/probe.h
@@ -110,6 +110,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
 #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
 #define EXT4_FEATURE_RO_COMPAT_QUOTA		0x0100
+#define EXT4_FEATURE_RO_COMPAT_INODE_CSUM	0x0400
 
 /* for s_feature_incompat */
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 16fba53..876f0e1 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -59,6 +59,8 @@ static struct feature feature_list[] = {
 			"quota" },
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_BIGALLOC,
 			"bigalloc"},
+	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_INODE_CSUM,
+			"inode_csum"},
 
 	{	E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_COMPRESSION,
 			"compression" },
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 58e2971..3621bd7 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -29,6 +29,65 @@
 #define STATIC static
 #endif
 
+__u16 ext2fs_inode_csum(ext2_filsys fs, ext2_ino_t inum,
+			struct ext2_inode_large *inode)
+{
+	int offset = offsetof(struct ext2_inode_large, i_checksum);
+	int extra_size = inode->i_extra_isize;
+	size_t size = fs->super->s_inode_size;
+	__u16 crc = 0;
+
+	if (fs->super->s_feature_ro_compat &
+	    EXT4_FEATURE_RO_COMPAT_INODE_CSUM &&
+	    extra_size >= 4) {
+#ifdef WORDS_BIGENDIAN
+		struct ext4_inode_large swabinode;
+
+		/* Have to swab back to little-endian to do the checksum */
+		memcpy(&swabinode, inode, size);
+		ext2fs_swap_inode_full(fs, inode, inode, 0, size);
+		desc = &swabinode;
+
+		inum = ext2fs_swab32(inum);
+#endif
+		crc = ext2fs_crc16(~0, fs->super->s_uuid,
+				   sizeof(fs->super->s_uuid));
+		crc = ext2fs_crc16(crc, &inum, sizeof(inum));
+		crc = ext2fs_crc16(crc, inode, offset);
+		offset += sizeof(inode->i_checksum); /* skip checksum */
+		/* for checksum of struct ext4_group_desc do the rest...*/
+		if (extra_size > 4) {
+			crc = ext2fs_crc16(crc, (char *)inode + offset,
+					   extra_size - 4);
+		}
+	}
+
+	return crc;
+}
+
+int ext2fs_inode_csum_verify(ext2_filsys fs, ext2_ino_t inum,
+			     struct ext2_inode_large *inode)
+{
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_INODE_CSUM) &&
+	    (inode->i_checksum != ext2fs_inode_csum(fs, inum, inode)))
+		return 0;
+
+	return 1;
+}
+
+void ext2fs_inode_csum_set(ext2_filsys fs, ext2_ino_t inum,
+			   struct ext2_inode_large *inode)
+{
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_INODE_CSUM))
+		return;
+
+	/* ext2fs_bg_checksum_set() sets the actual checksum field but
+	 * does not calculate the checksum itself. */
+	inode->i_checksum = ext2fs_inode_csum(fs, inum, inode);
+}
+
 STATIC __u16 ext2fs_group_desc_csum(ext2_filsys fs, dgrp_t group)
 {
 	__u16 crc = 0;
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index 995ddc3..cc9ac3d 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -422,4 +422,7 @@ ec	EXT2_NO_MTAB_FILE,
 ec	EXT2_ET_CANT_USE_LEGACY_BITMAPS,
 	"Filesystem too large to use legacy bitmaps"
 
+ec	EXT2_ET_INODE_CSUM_INVALID,
+	"Inode checksum is invalid"
+
 	end
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index a89e33b..dfedd4e 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -416,7 +416,7 @@ struct ext2_inode_large {
 		} hurd2;
 	} osd2;				/* OS dependent 2 */
 	__u16	i_extra_isize;
-	__u16	i_pad1;
+	__u16	i_checksum;
 	__u32	i_ctime_extra;	/* extra Change time (nsec << 2 | epoch) */
 	__u32	i_mtime_extra;	/* extra Modification time (nsec << 2 | epoch) */
 	__u32	i_atime_extra;	/* extra Access time (nsec << 2 | epoch) */
@@ -677,6 +677,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT	0x0080
 #define EXT4_FEATURE_RO_COMPAT_QUOTA		0x0100
 #define EXT4_FEATURE_RO_COMPAT_BIGALLOC		0x0200
+#define EXT4_FEATURE_RO_COMPAT_INODE_CSUM	0x0400
 
 #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index d3eb31d..cbfa5a1 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -553,7 +553,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE|\
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK|\
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|\
-					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM)
+					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM |\
+					 EXT4_FEATURE_RO_COMPAT_INODE_CSUM)
 
 /*
  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
@@ -858,6 +859,12 @@ extern int ext2fs_super_and_bgd_loc(ext2_filsys fs,
 extern void ext2fs_update_dynamic_rev(ext2_filsys fs);
 
 /* csum.c */
+extern __u16 ext2fs_inode_csum(ext2_filsys fs, ext2_ino_t inum,
+			      struct ext2_inode_large *inode);
+extern void ext2fs_inode_csum_set(ext2_filsys fs, ext2_ino_t inum,
+				  struct ext2_inode_large *inode);
+extern int ext2fs_inode_csum_verify(ext2_filsys fs, ext2_ino_t inum,
+				    struct ext2_inode_large *inode);
 extern void ext2fs_group_desc_csum_set(ext2_filsys fs, dgrp_t group);
 extern int ext2fs_group_desc_csum_verify(ext2_filsys fs, dgrp_t group);
 extern errcode_t ext2fs_set_gdt_csum(ext2_filsys fs);
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index a762dbc..5c377b5 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -608,6 +608,10 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
 			       (struct ext2_inode_large *) inode,
 			       0, bufsize);
 #endif
+	if (bufsize >= offsetof(struct ext2_inode_large, i_ctime_extra) &&
+	    !ext2fs_inode_csum_verify(fs, ino,
+			(struct ext2_inode_large *)inode))
+		return EXT2_ET_INODE_CSUM_INVALID;
 
 	/* Update the inode cache */
 	fs->icache->cache_last = (fs->icache->cache_last + 1) %
@@ -675,6 +679,19 @@ errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
 		w_inode = &temp_inode;
 	memset(w_inode, 0, length);
 
+	if (fs->super->s_feature_ro_compat &
+		EXT4_FEATURE_RO_COMPAT_INODE_CSUM &&
+	    ((struct ext2_inode_large *)inode)->i_extra_isize > 4) {
+		if (bufsize < offsetof(struct ext2_inode_large,
+				       i_ctime_extra)) {
+			fprintf(stderr, "Underflow, inode %lu bufsize %u\n",
+				ino, bufsize);
+			abort();
+		}
+		ext2fs_inode_csum_set(fs, ino,
+			(struct ext2_inode_large *)inode);
+	}
+
 #ifdef WORDS_BIGENDIAN
 	ext2fs_swap_inode_full(fs, w_inode,
 			       (struct ext2_inode_large *) inode,
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 3a43c6c..c601d8f 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -279,6 +279,8 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 		return;
 	}
 
+	t->i_checksum = ext2fs_swab16(f->i_checksum);
+
 	i = sizeof(struct ext2_inode) + extra_isize + sizeof(__u32);
 	if (bufsize < (int) i)
 		return; /* no space for EA magic */
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index bcada11..957a19c 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -130,7 +130,8 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_RO_COMPAT_DIR_NLINK|
 		EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
 		EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
-		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER
+		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER |
+		EXT4_FEATURE_RO_COMPAT_INODE_CSUM
 };
 
 static __u32 clear_ok_features[3] = {
@@ -146,7 +147,8 @@ static __u32 clear_ok_features[3] = {
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
 		EXT4_FEATURE_RO_COMPAT_DIR_NLINK|
 		EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
-		EXT4_FEATURE_RO_COMPAT_GDT_CSUM
+		EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
+		EXT4_FEATURE_RO_COMPAT_INODE_CSUM
 };
 
 /*
@@ -448,6 +450,18 @@ static void update_feature_set(ext2_filsys fs, char *features)
 	}
 
 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
+		       EXT4_FEATURE_RO_COMPAT_INODE_CSUM)) {
+		if (sb->s_inode_size < ext4_offsetof(struct ext2_inode_large,
+						     i_ctime_extra)) {
+			fputs(_("Inode checksums are only supported when "
+				"inodes are larger than 128 bytes.\n"),
+			      stderr);
+			exit(1);
+		}
+		request_fsck_afterwards(fs);
+	}
+
+	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
 		       EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
 		for (i = 0; i < fs->group_desc_count; i++) {
 			gd = ext2fs_group_desc(fs, fs->group_desc, i);
