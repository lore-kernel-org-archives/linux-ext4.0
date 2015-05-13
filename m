From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] jbd2: fix r_count overflows leading to buffer overflow in
 journal recovery
Date: Wed, 13 May 2015 11:56:46 -0700
Message-ID: <20150513185646.GE30577@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20542 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933757AbbEMS4v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 May 2015 14:56:51 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The journal revoke block recovery code does not check r_count for
sanity, which means that an evil value of r_count could result in
the kernel reading off the end of the revoke table and into whatever
garbage lies beyond.  This could crash the kernel, so fix that.

However, in testing this fix, I discovered that the code to write
out the revoke tables also was not correctly checking to see if the
block was full -- the current offset check is fine so long as the
revoke table space size is a multiple of the record size, but this
is not true when either journal_csum_v[23] are set.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/jbd2/recovery.c |   10 +++++++++-
 fs/jbd2/revoke.c   |   18 ++++++++++--------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index b5128c6..a9079d0 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -842,15 +842,23 @@ static int scan_revoke_records(journal_t *journal, struct buffer_head *bh,
 {
 	jbd2_journal_revoke_header_t *header;
 	int offset, max;
+	int csum_size = 0;
+	__u32 rcount;
 	int record_len = 4;
 
 	header = (jbd2_journal_revoke_header_t *) bh->b_data;
 	offset = sizeof(jbd2_journal_revoke_header_t);
-	max = be32_to_cpu(header->r_count);
+	rcount = be32_to_cpu(header->r_count);
 
 	if (!jbd2_revoke_block_csum_verify(journal, header))
 		return -EINVAL;
 
+	if (jbd2_journal_has_csum_v2or3(journal))
+		csum_size = sizeof(struct jbd2_journal_revoke_tail);
+	if (rcount > journal->j_blocksize - csum_size)
+		return -EINVAL;
+	max = rcount;
+
 	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_64BIT))
 		record_len = 8;
 
diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index c6cbaef..fd9969d 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -577,7 +577,7 @@ static void write_one_revoke_record(journal_t *journal,
 {
 	int csum_size = 0;
 	struct buffer_head *descriptor;
-	int offset;
+	int sz, offset;
 	journal_header_t *header;
 
 	/* If we are already aborting, this all becomes a noop.  We
@@ -594,9 +594,14 @@ static void write_one_revoke_record(journal_t *journal,
 	if (jbd2_journal_has_csum_v2or3(journal))
 		csum_size = sizeof(struct jbd2_journal_revoke_tail);
 
+	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_64BIT))
+		sz = 8;
+	else
+		sz = 4;
+
 	/* Make sure we have a descriptor with space left for the record */
 	if (descriptor) {
-		if (offset >= journal->j_blocksize - csum_size) {
+		if (offset + sz >= journal->j_blocksize - csum_size) {
 			flush_descriptor(journal, descriptor, offset, write_op);
 			descriptor = NULL;
 		}
@@ -619,16 +624,13 @@ static void write_one_revoke_record(journal_t *journal,
 		*descriptorp = descriptor;
 	}
 
-	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_64BIT)) {
+	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_64BIT))
 		* ((__be64 *)(&descriptor->b_data[offset])) =
 			cpu_to_be64(record->blocknr);
-		offset += 8;
