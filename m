From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 47/54] e2fsck: Check revoke block checksum during recovery
Date: Tue, 06 Mar 2012 16:02:55 -0800
Message-ID: <20120307000255.11945.37023.stgit@elm3b70.beaverton.ibm.com>
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
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39584 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031633Ab2CGAEA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Mar 2012 19:04:00 -0500
Received: from /spool/local
	by e3.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 6 Mar 2012 19:03:58 -0500
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 0B20338C8052
	for <linux-ext4@vger.kernel.org>; Tue,  6 Mar 2012 19:03:03 -0500 (EST)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q27032X0312388
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 19:03:02 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q275XrYD021497
	for <linux-ext4@vger.kernel.org>; Wed, 7 Mar 2012 00:33:55 -0500
In-Reply-To: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Verify the revoke block checksum when recovering the journal.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/recovery.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)


diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index b669941..60c8ceb 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -715,6 +715,27 @@ static int do_one_pass(journal_t *journal,
 	return err;
 }
 
+static int jbd2_revoke_block_csum_verify(journal_t *j,
+					 void *buf)
+{
+	struct journal_revoke_tail *tail;
+	__u32 provided, calculated;
+
+	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
+		return 1;
+
+	tail = (struct journal_revoke_tail *)(buf + j->j_blocksize -
+			sizeof(struct journal_revoke_tail));
+	provided = tail->r_checksum;
+	tail->r_checksum = 0;
+	calculated = ext2fs_crc32c_le(~0, j->j_superblock->s_uuid,
+				      sizeof(j->j_superblock->s_uuid));
+	calculated = ext2fs_crc32c_le(calculated, buf, j->j_blocksize);
+	tail->r_checksum = provided;
+
+	provided = ext2fs_be32_to_cpu(provided);
+	return provided == calculated;
+}
 
 /* Scan a revoke record, marking all blocks mentioned as revoked. */
 
@@ -729,6 +750,9 @@ static int scan_revoke_records(journal_t *journal, struct buffer_head *bh,
 	offset = sizeof(journal_revoke_header_t);
 	max = be32_to_cpu(header->r_count);
 
+	if (!jbd2_revoke_block_csum_verify(journal, header))
+		return -EINVAL;
+
 	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_64BIT))
 		record_len = 8;
 

