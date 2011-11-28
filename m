From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 18/22] jbd2: Update structure definitions and flags to support
	extended checksumming
Date: Mon, 28 Nov 2011 15:28:22 -0800
Message-ID: <20111128232822.19194.23422.stgit@elm3c44.beaverton.ibm.com>
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
 fs/jbd2/journal.c    |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/jbd2.h |    5 ++++-
 2 files changed, 41 insertions(+), 1 deletions(-)


diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index fbf86ee..bea3c6e 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -109,6 +109,34 @@ int jbd2_verify_csum_type(journal_t *j, journal_superblock_t *sb)
 	return sb->s_checksum_type == JBD2_CRC32C_CHKSUM;
 }
 
+static __u32 jbd2_superblock_csum(journal_t *j, journal_superblock_t *sb)
+{
+	__u32 csum, old_csum;
+
+	old_csum = sb->s_checksum;
+	sb->s_checksum = 0;
+	csum = jbd2_chksum(j, ~0, (char *)sb, sizeof(journal_superblock_t));
+	sb->s_checksum = old_csum;
+
+	return cpu_to_be32(csum);
+}
+
+int jbd2_superblock_csum_verify(journal_t *j, journal_superblock_t *sb)
+{
+	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
+		return 1;
+
+	return sb->s_checksum == jbd2_superblock_csum(j, sb);
+}
+
+void jbd2_superblock_csum_set(journal_t *j, journal_superblock_t *sb)
+{
+	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
+		return;
+
+	sb->s_checksum = jbd2_superblock_csum(j, sb);
+}
+
 /*
  * Helper function used to manage commit timeouts
  */
@@ -1178,6 +1206,7 @@ void jbd2_journal_update_superblock(journal_t *journal, int wait)
 	sb->s_sequence = cpu_to_be32(journal->j_tail_sequence);
 	sb->s_start    = cpu_to_be32(journal->j_tail);
 	sb->s_errno    = cpu_to_be32(journal->j_errno);
+	jbd2_superblock_csum_set(journal, sb);
 	read_unlock(&journal->j_state_lock);
 
 	BUFFER_TRACE(bh, "marking dirty");
@@ -1294,6 +1323,11 @@ static int journal_get_superblock(journal_t *journal)
 		}
 	}
 
+	if (!jbd2_superblock_csum_verify(journal, sb)) {
+		printk(KERN_ERR "JBD: journal checksum error\n");
+		goto out;
+	}
+
 	set_buffer_verified(bh);
 
 	return 0;
@@ -1588,6 +1622,7 @@ int jbd2_journal_set_features (journal_t *journal, unsigned long compat,
 	sb->s_feature_compat    |= cpu_to_be32(compat);
 	sb->s_feature_ro_compat |= cpu_to_be32(ro);
 	sb->s_feature_incompat  |= cpu_to_be32(incompat);
+	jbd2_journal_update_superblock(journal, 0);
 
 	return 1;
 #undef COMPAT_FEATURE_ON
@@ -1618,6 +1653,7 @@ void jbd2_journal_clear_features(journal_t *journal, unsigned long compat,
 	sb->s_feature_compat    &= ~cpu_to_be32(compat);
 	sb->s_feature_ro_compat &= ~cpu_to_be32(ro);
 	sb->s_feature_incompat  &= ~cpu_to_be32(incompat);
+	jbd2_journal_update_superblock(journal, 0);
 }
 EXPORT_SYMBOL(jbd2_journal_clear_features);
 
@@ -1666,6 +1702,7 @@ static int journal_convert_superblock_v1(journal_t *journal,
 
 	sb->s_nr_users = cpu_to_be32(1);
 	sb->s_header.h_blocktype = cpu_to_be32(JBD2_SUPERBLOCK_V2);
+	jbd2_superblock_csum_set(journal, sb);
 	journal->j_format_version = 2;
 
 	bh = journal->j_sb_buffer;
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 88af51f..3bf4fe3 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -243,7 +243,10 @@ typedef struct journal_superblock_s
 	__be32	s_max_trans_data;	/* Limit of data blocks per trans. */
 
 /* 0x0050 */
-	__u32	s_padding[44];
+	__u8	s_checksum_type;	/* checksum type */
+	__u8	s_padding2[3];
+	__u32	s_padding[42];
+	__be32	s_checksum;		/* crc32c(superblock) */
 
 /* 0x0100 */
 	__u8	s_users[16*48];		/* ids of all fs'es sharing the log */
