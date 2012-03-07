From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 49/54] e2fsck: Check commit block checksum during recovery
Date: Tue, 06 Mar 2012 16:03:10 -0800
Message-ID: <20120307000310.11945.1092.stgit@elm3b70.beaverton.ibm.com>
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
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48759 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031610Ab2CGADf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Mar 2012 19:03:35 -0500
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 6 Mar 2012 19:03:33 -0500
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 2A57E38C805A
	for <linux-ext4@vger.kernel.org>; Tue,  6 Mar 2012 19:03:16 -0500 (EST)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2703FGF298094
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 19:03:15 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2703EY4009318
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 21:03:15 -0300
In-Reply-To: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When recovering a journal with checksum v2, verify the commit block checksum.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/recovery.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)


diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index f76e7d8..8f55411 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -375,6 +375,26 @@ static int calc_chksums(journal_t *journal, struct buffer_head *bh,
 	return 0;
 }
 
+static int jbd2_commit_block_csum_verify(journal_t *j, void *buf)
+{
+	struct commit_header *h;
+	__u32 provided, calculated;
+
+	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
+		return 1;
+
+	h = buf;
+	provided = h->h_chksum[0];
+	h->h_chksum[0] = 0;
+	calculated = ext2fs_crc32c_le(~0, j->j_superblock->s_uuid,
+				      sizeof(j->j_superblock->s_uuid));
+	calculated = ext2fs_crc32c_le(calculated, buf, j->j_blocksize);
+	h->h_chksum[0] = provided;
+
+	provided = ext2fs_be32_to_cpu(provided);
+	return provided == calculated;
+}
+
 static int do_one_pass(journal_t *journal,
 			struct recovery_info *info, enum passtype pass)
 {
@@ -696,6 +716,19 @@ static int do_one_pass(journal_t *journal,
 				}
 				crc32_sum = ~0;
 			}
+			if (pass == PASS_SCAN &&
+			    !jbd2_commit_block_csum_verify(journal,
+							   bh->b_data)) {
+				info->end_transaction = next_commit_ID;
+
+				if (!JFS_HAS_INCOMPAT_FEATURE(journal,
+				     JFS_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
+					journal->j_failed_commit =
+						next_commit_ID;
+					brelse(bh);
+					break;
+				}
+			}
 			brelse(bh);
 			next_commit_ID++;
 			continue;

