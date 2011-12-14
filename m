From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 19/23] jbd2: Checksum revocation blocks
Date: Tue, 13 Dec 2011 16:48:25 -0800
Message-ID: <20111214004825.28243.37737.stgit@elm3c44.beaverton.ibm.com>
References: <20111214004613.28243.54122.stgit@elm3c44.beaverton.ibm.com>
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
In-Reply-To: <20111214004613.28243.54122.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Compute and verify revoke blocks inside the journal.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/jbd2/recovery.c |   22 ++++++++++++++++++++++
 fs/jbd2/revoke.c   |   27 ++++++++++++++++++++++++++-
 2 files changed, 48 insertions(+), 1 deletions(-)


diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index da6d7ba..bfc52cd 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -703,6 +703,25 @@ static int do_one_pass(journal_t *journal,
 	return err;
 }
 
+static int jbd2_revoke_block_csum_verify(journal_t *j,
+					 void *buf)
+{
+	struct jbd2_journal_revoke_tail *tail;
+	__u32 provided, calculated;
+
+	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
+		return 1;
+
+	tail = (struct jbd2_journal_revoke_tail *)(buf + j->j_blocksize -
+			sizeof(struct jbd2_journal_revoke_tail));
+	provided = tail->r_checksum;
+	tail->r_checksum = 0;
+	calculated = jbd2_chksum(j, j->j_csum_seed, buf, j->j_blocksize);
+	tail->r_checksum = provided;
+
+	provided = be32_to_cpu(provided);
+	return provided == calculated;
+}
 
 /* Scan a revoke record, marking all blocks mentioned as revoked. */
 
@@ -717,6 +736,9 @@ static int scan_revoke_records(journal_t *journal, struct buffer_head *bh,
 	offset = sizeof(jbd2_journal_revoke_header_t);
 	max = be32_to_cpu(header->r_count);
 
+	if (!jbd2_revoke_block_csum_verify(journal, header))
+		return -EINVAL;
+
 	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_64BIT))
 		record_len = 8;
 
diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index 69fd935..a197ba5 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -548,6 +548,7 @@ static void write_one_revoke_record(journal_t *journal,
 				    struct jbd2_revoke_record_s *record,
 				    int write_op)
 {
+	int csum_size = 0;
 	struct journal_head *descriptor;
 	int offset;
 	journal_header_t *header;
@@ -562,9 +563,13 @@ static void write_one_revoke_record(journal_t *journal,
 	descriptor = *descriptorp;
 	offset = *offsetp;
 
+	/* Do we need to leave space at the end for a checksum? */
+	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_CSUM_V2))
+		csum_size = sizeof(struct jbd2_journal_revoke_tail);
+
 	/* Make sure we have a descriptor with space left for the record */
 	if (descriptor) {
-		if (offset == journal->j_blocksize) {
+		if (offset >= journal->j_blocksize - csum_size) {
 			flush_descriptor(journal, descriptor, offset, write_op);
 			descriptor = NULL;
 		}
@@ -601,6 +606,24 @@ static void write_one_revoke_record(journal_t *journal,
 	*offsetp = offset;
 }
 
+static void jbd2_revoke_csum_set(journal_t *j,
+				 struct journal_head *descriptor)
+{
+	struct jbd2_journal_revoke_tail *tail;
+	__u32 csum;
+
+	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
+		return;
+
+	tail = (struct jbd2_journal_revoke_tail *)
+			(jh2bh(descriptor)->b_data + j->j_blocksize -
+			sizeof(struct jbd2_journal_revoke_tail));
+	tail->r_checksum = 0;
+	csum = jbd2_chksum(j, j->j_csum_seed, jh2bh(descriptor)->b_data,
+			   j->j_blocksize);
+	tail->r_checksum = cpu_to_be32(csum);
+}
+
 /*
  * Flush a revoke descriptor out to the journal.  If we are aborting,
  * this is a noop; otherwise we are generating a buffer which needs to
@@ -622,6 +645,8 @@ static void flush_descriptor(journal_t *journal,
 
 	header = (jbd2_journal_revoke_header_t *) jh2bh(descriptor)->b_data;
 	header->r_count = cpu_to_be32(offset);
+	jbd2_revoke_csum_set(journal, descriptor);
+
 	set_buffer_jwrite(bh);
 	BUFFER_TRACE(bh, "write");
 	set_buffer_dirty(bh);
