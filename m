From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 48/54] e2fsck: Check descriptor block checksum when recovering
 journal
Date: Tue, 06 Mar 2012 16:03:03 -0800
Message-ID: <20120307000303.11945.26133.stgit@elm3b70.beaverton.ibm.com>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:43162 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031610Ab2CGAEN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Mar 2012 19:04:13 -0500
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 6 Mar 2012 17:04:12 -0700
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 420F3C9005C
	for <linux-ext4@vger.kernel.org>; Tue,  6 Mar 2012 19:03:11 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2703Bc3224256
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 19:03:11 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q27038tF011749
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 19:03:11 -0500
In-Reply-To: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Verify the descriptor block checksum when recovering a journal.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/recovery.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 38 insertions(+), 1 deletions(-)


diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index 60c8ceb..f76e7d8 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -174,6 +174,27 @@ static int jread(struct buffer_head **bhp, journal_t *journal,
 	return 0;
 }
 
+static int jbd2_descr_block_csum_verify(journal_t *j,
+					void *buf)
+{
+	struct journal_block_tail *tail;
+	__u32 provided, calculated;
+
+	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
+		return 1;
+
+	tail = (struct journal_block_tail *)(buf + j->j_blocksize -
+			sizeof(struct journal_block_tail));
+	provided = tail->t_checksum;
+	tail->t_checksum = 0;
+	calculated = ext2fs_crc32c_le(~0, j->j_superblock->s_uuid,
+				      sizeof(j->j_superblock->s_uuid));
+	calculated = ext2fs_crc32c_le(calculated, buf, j->j_blocksize);
+	tail->t_checksum = provided;
+
+	provided = ext2fs_be32_to_cpu(provided);
+	return provided == calculated;
+}
 
 /*
  * Count the number of in-use tags in a journal descriptor block.
@@ -186,6 +207,9 @@ static int count_tags(journal_t *journal, struct buffer_head *bh)
 	int			nr = 0, size = journal->j_blocksize;
 	int			tag_bytes = journal_tag_bytes(journal);
 
+	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_CSUM_V2))
+		size -= sizeof(struct journal_block_tail);
+
 	tagp = &bh->b_data[sizeof(journal_header_t)];
 
 	while ((tagp - bh->b_data + tag_bytes) <= size) {
@@ -364,6 +388,7 @@ static int do_one_pass(journal_t *journal,
 	int			blocktype;
 	int			tag_bytes = journal_tag_bytes(journal);
 	__u32			crc32_sum = ~0; /* Transactional Checksums */
+	int			descr_csum_size = 0;
 
 	/* Precompute the maximum metadata descriptors in a descriptor block */
 	int			MAX_BLOCKS_PER_DESC;
@@ -454,6 +479,18 @@ static int do_one_pass(journal_t *journal,
 
 		switch(blocktype) {
 		case JFS_DESCRIPTOR_BLOCK:
+			/* Verify checksum first */
+			if (JFS_HAS_INCOMPAT_FEATURE(journal,
+					JFS_FEATURE_INCOMPAT_CSUM_V2))
+				descr_csum_size =
+					sizeof(struct journal_block_tail);
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
@@ -484,7 +521,7 @@ static int do_one_pass(journal_t *journal,
 
 			tagp = &bh->b_data[sizeof(journal_header_t)];
 			while ((tagp - bh->b_data + tag_bytes)
-			       <= journal->j_blocksize) {
+			       <= journal->j_blocksize - descr_csum_size) {
 				unsigned long io_block;
 
 				tag = (journal_block_tag_t *) tagp;

