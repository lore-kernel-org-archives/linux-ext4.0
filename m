From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] teach libblkid about ext4(dev)
Date: Sat, 26 Jan 2008 22:27:21 -0500
Message-ID: <20080127032721.GA24842@mit.edu>
References: <4796780F.1000603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:54318 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755347AbYA0D1o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jan 2008 22:27:44 -0500
Content-Disposition: inline
In-Reply-To: <4796780F.1000603@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 22, 2008 at 05:11:11PM -0600, Eric Sandeen wrote:
> Returns ext4dev for now; will need to change to ext4 at the appropriate
> time I guess.

This is what I ultimately ended up committing.

						- Ted

commit 2921332fd88b843ffb828d9c18f05bfd171ace76
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Jan 26 22:25:50 2008 -0500

    Teach the blkid library about ext4/ext4dev
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index 32d9f3f..f7bb491 100644
--- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -131,7 +131,8 @@ static void set_uuid(blkid_dev dev, uuid_t uuid, char *tag)
 	}
 }
 
-static void get_ext2_info(blkid_dev dev, unsigned char *buf)
+static void get_ext2_info(blkid_dev dev, struct blkid_magic *id,
+			  unsigned char *buf)
 {
 	struct ext2_super_block *es = (struct ext2_super_block *) buf;
 	const char *label = 0;
@@ -146,61 +147,123 @@ static void get_ext2_info(blkid_dev dev, unsigned char *buf)
 	blkid_set_tag(dev, "LABEL", label, sizeof(es->s_volume_name));
 
 	set_uuid(dev, es->s_uuid, 0);
+
+	if ((es->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&
+	    !uuid_is_null(es->s_journal_uuid))
+		set_uuid(dev, es->s_journal_uuid, "EXT_JOURNAL");
+
+	if (strcmp(id->bim_type, "ext2") &&
+	    ((blkid_le32(es->s_feature_incompat) &
+	      EXT2_FEATURE_INCOMPAT_UNSUPPORTED) == 0))
+		blkid_set_tag(dev, "SEC_TYPE", "ext2", sizeof("ext2"));
 }
 
-static int probe_ext3(struct blkid_probe *probe, 
-		      struct blkid_magic *id __BLKID_ATTR((unused)), 
+static int probe_ext4dev(struct blkid_probe *probe,
+			 struct blkid_magic *id,
+			 unsigned char *buf)
+{
+	struct ext2_super_block *es;
+	es = (struct ext2_super_block *)buf;
+
+	/* Distinguish between ext4dev and other filesystems */
+	if ((blkid_le32(es->s_flags) & EXT2_FLAGS_TEST_FILESYS) == 0)
+		return -BLKID_ERR_PARAM;
+
+	/* Distinguish from jbd */
+	if (blkid_le32(es->s_feature_incompat) &
+	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)
+		return -BLKID_ERR_PARAM;
+
+	/* ext4dev requires a journal */
+	if (!(blkid_le32(es->s_feature_compat) &
+	      EXT3_FEATURE_COMPAT_HAS_JOURNAL))
+		return -BLKID_ERR_PARAM;
+
+    	get_ext2_info(probe->dev, id, buf);
+	return 0;
+}
+
+static int probe_ext4(struct blkid_probe *probe, struct blkid_magic *id,
 		      unsigned char *buf)
 {
 	struct ext2_super_block *es;
 	es = (struct ext2_super_block *)buf;
 
-	/* Distinguish between jbd and ext2/3 fs */
+	/* Distinguish from ext4dev */
+	if (blkid_le32(es->s_flags) & EXT2_FLAGS_TEST_FILESYS)
+		return -BLKID_ERR_PARAM;
+
+	/* Distinguish from jbd */
 	if (blkid_le32(es->s_feature_incompat) & 
 	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)
 		return -BLKID_ERR_PARAM;
 
-	/* Distinguish between ext3 and ext2 */
+	/* ext4 requires journal */
 	if (!(blkid_le32(es->s_feature_compat) &
 	      EXT3_FEATURE_COMPAT_HAS_JOURNAL))
 		return -BLKID_ERR_PARAM;
 
-	get_ext2_info(probe->dev, buf);
+	/* Ext4 has at least one feature which ext3 doesn't understand */
+	if (!(blkid_le32(es->s_feature_ro_compat) &
+	      EXT3_FEATURE_RO_COMPAT_UNSUPPORTED) &&
+	    !(blkid_le32(es->s_feature_incompat) &
+	      EXT3_FEATURE_INCOMPAT_UNSUPPORTED))
+		return -BLKID_ERR_PARAM;
 
-	if ((es->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&
-	    !uuid_is_null(es->s_journal_uuid))
-		set_uuid(probe->dev, es->s_journal_uuid, "EXT_JOURNAL");
+    	get_ext2_info(probe->dev, id, buf);
+	return 0;
+}
+
+static int probe_ext3(struct blkid_probe *probe, struct blkid_magic *id,
+		      unsigned char *buf)
+{
+	struct ext2_super_block *es;
+	es = (struct ext2_super_block *)buf;
+
+	/* Distinguish from ext4dev */
+	if (blkid_le32(es->s_flags) & EXT2_FLAGS_TEST_FILESYS)
+		return -BLKID_ERR_PARAM;
 
-	blkid_set_tag(probe->dev, "SEC_TYPE", "ext2", sizeof("ext2"));
+	/* ext3 requires journal */
+	if (!(blkid_le32(es->s_feature_compat) &
+	      EXT3_FEATURE_COMPAT_HAS_JOURNAL))
+		return -BLKID_ERR_PARAM;
 
+	/* Any features which ext3 doesn't understand */
+	if ((blkid_le32(es->s_feature_ro_compat) &
+	     EXT3_FEATURE_RO_COMPAT_UNSUPPORTED) ||
+	    (blkid_le32(es->s_feature_incompat) &
+	     EXT3_FEATURE_INCOMPAT_UNSUPPORTED))
+		return -BLKID_ERR_PARAM;
+
+    	get_ext2_info(probe->dev, id, buf);
 	return 0;
 }
 
-static int probe_ext2(struct blkid_probe *probe,
-		      struct blkid_magic *id __BLKID_ATTR((unused)), 
+static int probe_ext2(struct blkid_probe *probe, struct blkid_magic *id,
 		      unsigned char *buf)
 {
 	struct ext2_super_block *es;
 
 	es = (struct ext2_super_block *)buf;
 
-	/* Distinguish between jbd and ext2/3 fs */
-	if (blkid_le32(es->s_feature_incompat) & 
-	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)
-		return -BLKID_ERR_PARAM;
-	
 	/* Distinguish between ext3 and ext2 */
 	if ((blkid_le32(es->s_feature_compat) &
 	      EXT3_FEATURE_COMPAT_HAS_JOURNAL))
 		return -BLKID_ERR_PARAM;
 
-	get_ext2_info(probe->dev, buf);
+	/* Any features which ext2 doesn't understand */
+	if ((blkid_le32(es->s_feature_ro_compat) &
+	     EXT2_FEATURE_RO_COMPAT_UNSUPPORTED) ||
+	    (blkid_le32(es->s_feature_incompat) &
+	     EXT2_FEATURE_INCOMPAT_UNSUPPORTED))
+		return -BLKID_ERR_PARAM;
 
+	get_ext2_info(probe->dev, id, buf);
 	return 0;
 }
 
-static int probe_jbd(struct blkid_probe *probe,
-		     struct blkid_magic *id __BLKID_ATTR((unused)), 
+static int probe_jbd(struct blkid_probe *probe, struct blkid_magic *id,
 		     unsigned char *buf)
 {
 	struct ext2_super_block *es = (struct ext2_super_block *) buf;
@@ -209,7 +272,7 @@ static int probe_jbd(struct blkid_probe *probe,
 	      EXT3_FEATURE_INCOMPAT_JOURNAL_DEV))
 		return -BLKID_ERR_PARAM;
 
-	get_ext2_info(probe->dev, buf);
+	get_ext2_info(probe->dev, id, buf);
 
 	return 0;
 }
@@ -833,6 +896,8 @@ static struct blkid_magic type_array[] = {
   { "oracleasm", 0,	32,  8, "ORCLDISK",		probe_oracleasm },
   { "ntfs",	 0,	 3,  8, "NTFS    ",		probe_ntfs },
   { "jbd",	 1,   0x38,  2, "\123\357",		probe_jbd },
+  { "ext4dev",	 1,   0x38,  2, "\123\357",		probe_ext4dev },
+  { "ext4",	 1,   0x38,  2, "\123\357",		probe_ext4 },
   { "ext3",	 1,   0x38,  2, "\123\357",		probe_ext3 },
   { "ext2",	 1,   0x38,  2, "\123\357",		probe_ext2 },
   { "reiserfs",	 8,   0x34,  8, "ReIsErFs",		probe_reiserfs },
diff --git a/lib/blkid/probe.h b/lib/blkid/probe.h
index f22fb2e..2cbd617 100644
--- a/lib/blkid/probe.h
+++ b/lib/blkid/probe.h
@@ -82,11 +82,61 @@ struct ext2_super_block {
 	__u32	s_first_meta_bg;
 	__u32	s_mkfs_time;
 	__u32	s_jnl_blocks[17];
-	__u32	s_reserved[172];
+	__u32	s_blocks_count_hi;
+	__u32	s_r_blocks_count_hi;
+	__u32	s_free_blocks_hi;
+	__u16	s_min_extra_isize;
+	__u16	s_want_extra_isize;
+	__u32	s_flags;
+	__u16   s_raid_stride;
+	__u16   s_mmp_interval;
+	__u64   s_mmp_block;
+	__u32   s_raid_stripe_width;
+	__u32   s_reserved[163];
 };
-#define EXT3_FEATURE_COMPAT_HAS_JOURNAL		0x00000004
-#define EXT3_FEATURE_INCOMPAT_RECOVER		0x00000004
-#define EXT3_FEATURE_INCOMPAT_JOURNAL_DEV	0x00000008
+
+/* for s_flags */
+#define EXT2_FLAGS_TEST_FILESYS		0x0004
+
+/* for s_feature_compat */
+#define EXT3_FEATURE_COMPAT_HAS_JOURNAL		0x0004
+
+/* for s_feature_ro_compat */
+#define EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
+#define EXT2_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
+#define EXT2_FEATURE_RO_COMPAT_BTREE_DIR	0x0004
+#define EXT4_FEATURE_RO_COMPAT_HUGE_FILE	0x0008
+#define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0010
+#define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
+#define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
+
+/* for s_feature_incompat */
+#define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
+#define EXT3_FEATURE_INCOMPAT_RECOVER		0x0004
+#define EXT3_FEATURE_INCOMPAT_JOURNAL_DEV	0x0008
+#define EXT2_FEATURE_INCOMPAT_META_BG		0x0010
+#define EXT4_FEATURE_INCOMPAT_EXTENTS		0x0040 /* extents support */
+#define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
+#define EXT4_FEATURE_INCOMPAT_MMP		0x0100
+#define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
+
+#define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
+					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
+					 EXT2_FEATURE_RO_COMPAT_BTREE_DIR)
+#define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE| \
+					 EXT2_FEATURE_INCOMPAT_META_BG)
+#define EXT2_FEATURE_INCOMPAT_UNSUPPORTED	~EXT2_FEATURE_INCOMPAT_SUPP
+#define EXT2_FEATURE_RO_COMPAT_UNSUPPORTED	~EXT2_FEATURE_RO_COMPAT_SUPP
+
+#define EXT3_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
+					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
+					 EXT2_FEATURE_RO_COMPAT_BTREE_DIR)
+#define EXT3_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE| \
+					 EXT3_FEATURE_INCOMPAT_RECOVER| \
+					 EXT2_FEATURE_INCOMPAT_META_BG)
+#define EXT3_FEATURE_INCOMPAT_UNSUPPORTED	~EXT3_FEATURE_INCOMPAT_SUPP
+#define EXT3_FEATURE_RO_COMPAT_UNSUPPORTED	~EXT3_FEATURE_RO_COMPAT_SUPP
+
 
 struct xfs_super_block {
 	unsigned char	xs_magic[4];
