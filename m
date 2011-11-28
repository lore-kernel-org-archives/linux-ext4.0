From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 21/22] jbd2: Checksum commit blocks
Date: Mon, 28 Nov 2011 15:28:43 -0800
Message-ID: <20111128232843.19194.12270.stgit@elm3c44.beaverton.ibm.com>
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
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Calculate and verify the checksum of commit blocks.  In checksum v2, deprecate
most of the checksum v1 commit block checksum fields, since each block has its
own checksum.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/jbd2/commit.c     |   21 ++++++++++++++++++++-
 fs/jbd2/recovery.c   |   31 +++++++++++++++++++++++++++++++
 include/linux/jbd2.h |   11 +++++++++++
 3 files changed, 62 insertions(+), 1 deletions(-)


diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 229d5dc..e083e55 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -86,6 +86,24 @@ nope:
 	__brelse(bh);
 }
 
+static void jbd2_commit_block_csum_set(journal_t *j,
+				       struct journal_head *descriptor)
+{
+	struct commit_header *h;
+	__u32 csum;
+
+	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
+		return;
+
+	h = (struct commit_header *)(jh2bh(descriptor)->b_data);
+	h->h_chksum_type = 0;
+	h->h_chksum_size = 0;
+	h->h_chksum[0] = 0;
+	csum = jbd2_chksum(j, j->j_uuid_csum, jh2bh(descriptor)->b_data,
+			   j->j_blocksize);
+	h->h_chksum[0] = cpu_to_be32(csum);
+}
+
 /*
  * Done it all: now submit the commit record.  We should have
  * cleaned up our previous buffers by now, so if we are in abort
@@ -129,6 +147,7 @@ static int journal_submit_commit_record(journal_t *journal,
 		tmp->h_chksum_size 	= JBD2_CRC32_CHKSUM_SIZE;
 		tmp->h_chksum[0] 	= cpu_to_be32(crc32_sum);
 	}
+	jbd2_commit_block_csum_set(journal, descriptor);
 
 	JBUFFER_TRACE(descriptor, "submit commit block");
 	lock_buffer(bh);
@@ -351,7 +370,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	struct blk_plug plug;
 	int csum_size = 0;
 
-	if (JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
+	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_CSUM_V2))
 		csum_size = sizeof(struct jbd2_journal_block_tail);
 
 	/*
diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 7bf250a..173e543 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -372,6 +372,24 @@ static int calc_chksums(journal_t *journal, struct buffer_head *bh,
 	return 0;
 }
 
+static int jbd2_commit_block_csum_verify(journal_t *j, void *buf)
+{
+	struct commit_header *h;
+	__u32 provided, calculated;
+
+	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
+		return 1;
+
+	h = buf;
+	provided = h->h_chksum[0];
+	h->h_chksum[0] = 0;
+	calculated = jbd2_chksum(j, j->j_uuid_csum, buf, j->j_blocksize);
+	h->h_chksum[0] = provided;
+
+	provided = be32_to_cpu(provided);
+	return provided == calculated;
+}
+
 static int do_one_pass(journal_t *journal,
 			struct recovery_info *info, enum passtype pass)
 {
@@ -682,6 +700,19 @@ static int do_one_pass(journal_t *journal,
 				}
 				crc32_sum = ~0;
 			}
+			if (pass == PASS_SCAN &&
+			    !jbd2_commit_block_csum_verify(journal,
+							   bh->b_data)) {
+				info->end_transaction = next_commit_ID;
+
+				if (!JBD2_HAS_INCOMPAT_FEATURE(journal,
+				     JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
+					journal->j_failed_commit =
+						next_commit_ID;
+					brelse(bh);
+					break;
+				}
+			}
 			brelse(bh);
 			next_commit_ID++;
 			continue;
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 9d28938..d948ddf 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -155,6 +155,17 @@ typedef struct journal_header_s
 #define JBD2_CHECKSUM_BYTES (32 / sizeof(u32))
 /*
  * Commit block header for storing transactional checksums:
+ *
+ * NOTE: If FEATURE_COMPAT_CHECKSUM (checksum v1) is set, the h_chksum*
+ * fields are used to store a checksum of the descriptor and data blocks.
+ *
+ * If FEATURE_INCOMPAT_CSUM_V2 (checksum v2) is set, then the h_chksum
+ * field is used to store crc32c(uuid+commit_block).  Each journal metadata
+ * block gets its own checksum, and data block checksums are stored in
+ * journal_block_tag (in the descriptor).  The other h_chksum* fields are
+ * not used.
+ *
+ * Checksum v1 and v2 are mutually exclusive features.
  */
 struct commit_header {
 	__be32		h_magic;

