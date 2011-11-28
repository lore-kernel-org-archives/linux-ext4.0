From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 20/22] jbd2: Checksum descriptor blocks
Date: Mon, 28 Nov 2011 15:28:36 -0800
Message-ID: <20111128232836.19194.9307.stgit@elm3c44.beaverton.ibm.com>
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

Calculate and verify a checksum of each descriptor block.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/jbd2/commit.c     |   26 ++++++++++++++++++++++++--
 fs/jbd2/recovery.c   |   37 ++++++++++++++++++++++++++++++++++++-
 include/linux/jbd2.h |    5 +++++
 3 files changed, 65 insertions(+), 3 deletions(-)


diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 68d704d..229d5dc 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -302,6 +302,24 @@ static void write_tag_block(int tag_bytes, journal_block_tag_t *tag,
 		tag->t_blocknr_high = cpu_to_be32((block >> 31) >> 1);
 }
 
+static void jbd2_descr_block_csum_set(journal_t *j,
+				      struct journal_head *descriptor)
+{
+	struct jbd2_journal_block_tail *tail;
+	__u32 csum;
+
+	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
+		return;
+
+	tail = (struct jbd2_journal_block_tail *)
+			(jh2bh(descriptor)->b_data + j->j_blocksize -
+			sizeof(struct jbd2_journal_block_tail));
+	tail->t_checksum = 0;
+	csum = jbd2_chksum(j, j->j_uuid_csum, jh2bh(descriptor)->b_data,
+			   j->j_blocksize);
+	tail->t_checksum = cpu_to_be32(csum);
+}
+
 /*
  * jbd2_journal_commit_transaction
  *
@@ -331,6 +349,10 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	struct buffer_head *cbh = NULL; /* For transactional checksums */
 	__u32 crc32_sum = ~0;
 	struct blk_plug plug;
+	int csum_size = 0;
+
+	if (JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
+		csum_size = sizeof(struct jbd2_journal_block_tail);
 
 	/*
 	 * First job: lock down the current transaction and wait for
@@ -623,7 +645,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 
 		if (bufs == journal->j_wbufsize ||
 		    commit_transaction->t_buffers == NULL ||
-		    space_left < tag_bytes + 16) {
+		    space_left < tag_bytes + 16 + csum_size) {
 
 			jbd_debug(4, "JBD2: Submit %d IOs\n", bufs);
 
@@ -632,7 +654,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
                            the last tag we set up. */
 
 			tag->t_flags |= cpu_to_be32(JBD2_FLAG_LAST_TAG);
-
+			jbd2_descr_block_csum_set(journal, descriptor);
 start_journal_io:
 			for (i = 0; i < bufs; i++) {
 				struct buffer_head *bh = wbuf[i];
diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 63885e0..7bf250a 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -173,6 +173,25 @@ static int jread(struct buffer_head **bhp, journal_t *journal,
 	return 0;
 }
 
+static int jbd2_descr_block_csum_verify(journal_t *j,
+					void *buf)
+{
+	struct jbd2_journal_block_tail *tail;
+	__u32 provided, calculated;
+
+	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
+		return 1;
+
+	tail = (struct jbd2_journal_block_tail *)(buf + j->j_blocksize -
+			sizeof(struct jbd2_journal_block_tail));
+	provided = tail->t_checksum;
+	tail->t_checksum = 0;
+	calculated = jbd2_chksum(j, j->j_uuid_csum, buf, j->j_blocksize);
+	tail->t_checksum = provided;
+
+	provided = be32_to_cpu(provided);
+	return provided == calculated;
+}
 
 /*
  * Count the number of in-use tags in a journal descriptor block.
@@ -185,6 +204,9 @@ static int count_tags(journal_t *journal, struct buffer_head *bh)
 	int			nr = 0, size = journal->j_blocksize;
 	int			tag_bytes = journal_tag_bytes(journal);
 
+	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_CSUM_V2))
+		size -= sizeof(struct jbd2_journal_block_tail);
+
 	tagp = &bh->b_data[sizeof(journal_header_t)];
 
 	while ((tagp - bh->b_data + tag_bytes) <= size) {
@@ -363,6 +385,7 @@ static int do_one_pass(journal_t *journal,
 	int			blocktype;
 	int			tag_bytes = journal_tag_bytes(journal);
 	__u32			crc32_sum = ~0; /* Transactional Checksums */
+	int			descr_csum_size = 0;
 
 	/*
 	 * First thing is to establish what we expect to find in the log
@@ -448,6 +471,18 @@ static int do_one_pass(journal_t *journal,
 
 		switch(blocktype) {
 		case JBD2_DESCRIPTOR_BLOCK:
+			/* Verify checksum first */
+			if (JBD2_HAS_INCOMPAT_FEATURE(journal,
+					JBD2_FEATURE_INCOMPAT_CSUM_V2))
+				descr_csum_size =
+					sizeof(struct jbd2_journal_block_tail);
+			if (descr_csum_size > 0 &&
+			    !jbd2_descr_block_csum_verify(journal,
+							  bh->b_data)) {
+				err = -EIO;
+				goto failed;
+			}
+
 			/* If it is a valid descriptor block, replay it
 			 * in pass REPLAY; if journal_checksums enabled, then
 			 * calculate checksums in PASS_SCAN, otherwise,
@@ -478,7 +513,7 @@ static int do_one_pass(journal_t *journal,
 
 			tagp = &bh->b_data[sizeof(journal_header_t)];
 			while ((tagp - bh->b_data + tag_bytes)
-			       <= journal->j_blocksize) {
+			       <= journal->j_blocksize - descr_csum_size) {
 				unsigned long io_block;
 
 				tag = (journal_block_tag_t *) tagp;
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index c8e1abe..9d28938 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -184,6 +184,11 @@ typedef struct journal_block_tag_s
 #define JBD2_TAG_SIZE32 (offsetof(journal_block_tag_t, t_blocknr_high))
 #define JBD2_TAG_SIZE64 (sizeof(journal_block_tag_t))
 
+/* Tail of descriptor block, for checksumming */
+struct jbd2_journal_block_tail {
+	__be32		t_checksum;	/* crc32c(uuid+descr_block) */
+};
+
 /*
  * The revoke descriptor: used on disk to describe a series of blocks to
  * be revoked from the log

