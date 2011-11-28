From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 16/22] jbd2: Update structure definitions and flags to support
	extended checksumming
Date: Mon, 28 Nov 2011 15:28:08 -0800
Message-ID: <20111128232808.19194.46151.stgit@elm3c44.beaverton.ibm.com>
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add structure definitions, flags, and constants to extend checksum protection
to all journal blocks.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/super.c      |   55 ++++++++++++++++++++++++++++++++++++++------------
 fs/jbd2/journal.c    |   50 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/jbd2.h |    8 ++++++-
 3 files changed, 99 insertions(+), 14 deletions(-)


diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8f6dd82..1de68c6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3173,6 +3173,44 @@ static void ext4_destroy_lazyinit_thread(void)
 	kthread_stop(ext4_lazyinit_task);
 }
 
+static int set_journal_csum_feature_set(struct super_block *sb)
+{
+	int ret = 1;
+	int compat, incompat;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+		/* journal checksum v2 */
+		compat = 0;
+		incompat = JBD2_FEATURE_INCOMPAT_CSUM_V2;
+	} else {
+		/* journal checksum v1 */
+		compat = JBD2_FEATURE_COMPAT_CHECKSUM;
+		incompat = 0;
+	}
+
+	if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
+		ret = jbd2_journal_set_features(sbi->s_journal,
+				compat, 0,
+				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT |
+				incompat);
+	} else if (test_opt(sb, JOURNAL_CHECKSUM)) {
+		ret = jbd2_journal_set_features(sbi->s_journal,
+				compat, 0,
+				incompat);
+		jbd2_journal_clear_features(sbi->s_journal, 0, 0,
+				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
+	} else {
+		jbd2_journal_clear_features(sbi->s_journal,
+				JBD2_FEATURE_COMPAT_CHECKSUM, 0,
+				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT |
+				JBD2_FEATURE_INCOMPAT_CSUM_V2);
+	}
+
+	return ret;
+}
+
 static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 {
 	char *orig_data = kstrdup(data, GFP_KERNEL);
@@ -3761,19 +3799,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount_wq;
 	}
 
-	if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
-		jbd2_journal_set_features(sbi->s_journal,
-				JBD2_FEATURE_COMPAT_CHECKSUM, 0,
-				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
-	} else if (test_opt(sb, JOURNAL_CHECKSUM)) {
-		jbd2_journal_set_features(sbi->s_journal,
-				JBD2_FEATURE_COMPAT_CHECKSUM, 0, 0);
-		jbd2_journal_clear_features(sbi->s_journal, 0, 0,
-				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
-	} else {
-		jbd2_journal_clear_features(sbi->s_journal,
-				JBD2_FEATURE_COMPAT_CHECKSUM, 0,
-				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
+	if (!set_journal_csum_feature_set(sb)) {
+		ext4_msg(sb, KERN_ERR, "Failed to set journal checksum "
+			 "feature set");
+		goto failed_mount_wq;
 	}
 
 	/* We have now updated the journal if required, so we can
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 0fa0123..300b46f 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -100,6 +100,15 @@ static int journal_convert_superblock_v1(journal_t *, journal_superblock_t *);
 static void __journal_abort_soft (journal_t *journal, int errno);
 static int jbd2_journal_create_slab(size_t slab_size);
 
+/* Checksumming functions */
+int jbd2_verify_csum_type(journal_t *j, journal_superblock_t *sb)
+{
+	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
+		return 1;
+
+	return sb->s_checksum_type == JBD2_CRC32C_CHKSUM;
+}
+
 /*
  * Helper function used to manage commit timeouts
  */
@@ -1222,6 +1231,9 @@ static int journal_get_superblock(journal_t *journal)
 		}
 	}
 
+	if (buffer_verified(bh))
+		return 0;
+
 	sb = journal->j_superblock;
 
 	err = -EINVAL;
@@ -1259,6 +1271,21 @@ static int journal_get_superblock(journal_t *journal)
 		goto out;
 	}
 
+	if (JBD2_HAS_COMPAT_FEATURE(journal, JBD2_FEATURE_COMPAT_CHECKSUM) &&
+	    JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_CSUM_V2)) {
+		/* Can't have checksum v1 and v2 on at the same time! */
+		printk(KERN_ERR "JBD: Can't enable checksumming v1 and v2 "
+		       "at the same time!\n");
+		goto out;
+	}
+
+	if (!jbd2_verify_csum_type(journal, sb)) {
+		printk(KERN_ERR "JBD: Unknown checksum type\n");
+		goto out;
+	}
+
+	set_buffer_verified(bh);
+
 	return 0;
 
 out:
@@ -1502,6 +1529,10 @@ int jbd2_journal_check_available_features (journal_t *journal, unsigned long com
 int jbd2_journal_set_features (journal_t *journal, unsigned long compat,
 			  unsigned long ro, unsigned long incompat)
 {
+#define INCOMPAT_FEATURE_ON(f) \
+		((incompat & (f)) && !(sb->s_feature_incompat & cpu_to_be32(f)))
+#define COMPAT_FEATURE_ON(f) \
+		((compat & (f)) && !(sb->s_feature_compat & cpu_to_be32(f)))
 	journal_superblock_t *sb;
 
 	if (jbd2_journal_check_used_features(journal, compat, ro, incompat))
@@ -1510,16 +1541,35 @@ int jbd2_journal_set_features (journal_t *journal, unsigned long compat,
 	if (!jbd2_journal_check_available_features(journal, compat, ro, incompat))
 		return 0;
 
+	/* Asking for checksumming v2 and v1?  Only give them v2. */
+	if (incompat & JBD2_FEATURE_INCOMPAT_CSUM_V2 &&
+	    compat & JBD2_FEATURE_COMPAT_CHECKSUM)
+		compat &= ~JBD2_FEATURE_COMPAT_CHECKSUM;
+
 	jbd_debug(1, "Setting new features 0x%lx/0x%lx/0x%lx\n",
 		  compat, ro, incompat);
 
 	sb = journal->j_superblock;
 
+	/* If enabling v2 checksums, update superblock */
+	if (INCOMPAT_FEATURE_ON(JBD2_FEATURE_INCOMPAT_CSUM_V2)) {
+		sb->s_checksum_type = JBD2_CRC32C_CHKSUM;
+		sb->s_feature_compat &=
+			~cpu_to_be32(JBD2_FEATURE_COMPAT_CHECKSUM);
+	}
+
+	/* If enabling v1 checksums, downgrade superblock */
+	if (COMPAT_FEATURE_ON(JBD2_FEATURE_COMPAT_CHECKSUM))
+		sb->s_feature_incompat &=
+			~cpu_to_be32(JBD2_FEATURE_INCOMPAT_CSUM_V2);
+
 	sb->s_feature_compat    |= cpu_to_be32(compat);
 	sb->s_feature_ro_compat |= cpu_to_be32(ro);
 	sb->s_feature_incompat  |= cpu_to_be32(incompat);
 
 	return 1;
+#undef COMPAT_FEATURE_ON
+#undef INCOMPAT_FEATURE_ON
 }
 
 /*
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 2092ea2..4ead3d5 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -147,6 +147,7 @@ typedef struct journal_header_s
 #define JBD2_CRC32_CHKSUM   1
 #define JBD2_MD5_CHKSUM     2
 #define JBD2_SHA1_CHKSUM    3
+#define JBD2_CRC32C_CHKSUM  4
 
 #define JBD2_CRC32_CHKSUM_SIZE 4
 
@@ -263,13 +264,15 @@ typedef struct journal_superblock_s
 #define JBD2_FEATURE_INCOMPAT_REVOKE		0x00000001
 #define JBD2_FEATURE_INCOMPAT_64BIT		0x00000002
 #define JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT	0x00000004
+#define JBD2_FEATURE_INCOMPAT_CSUM_V2		0x00000008
 
 /* Features known to this kernel version: */
 #define JBD2_KNOWN_COMPAT_FEATURES	JBD2_FEATURE_COMPAT_CHECKSUM
 #define JBD2_KNOWN_ROCOMPAT_FEATURES	0
 #define JBD2_KNOWN_INCOMPAT_FEATURES	(JBD2_FEATURE_INCOMPAT_REVOKE | \
 					JBD2_FEATURE_INCOMPAT_64BIT | \
-					JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)
+					JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT | \
+					JBD2_FEATURE_INCOMPAT_CSUM_V2)
 
 #ifdef __KERNEL__
 
@@ -939,6 +942,9 @@ struct journal_s
 	 * superblock pointer here
 	 */
 	void *j_private;
+
+	/* Precomputed UUID checksum */
+	__u32 j_uuid_csum;
 };
 
 /*
