From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 22/54] debugfs: Print htree internal node checksums
Date: Tue, 06 Mar 2012 15:59:44 -0800
Message-ID: <20120306235944.11945.81798.stgit@elm3b70.beaverton.ibm.com>
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
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50495 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031282Ab2CGAAf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Mar 2012 19:00:35 -0500
Received: from /spool/local
	by e1.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 6 Mar 2012 19:00:33 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 7611338C805A
	for <linux-ext4@vger.kernel.org>; Tue,  6 Mar 2012 18:59:58 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q26NxnZn404918
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 18:59:50 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q26NxmCr015584
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 20:59:49 -0300
In-Reply-To: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Print htree node checksums when dumping a directory index.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 debugfs/htree.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)


diff --git a/debugfs/htree.c b/debugfs/htree.c
index 05745eb..2fb804e 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -120,8 +120,9 @@ static void htree_dump_int_node(ext2_filsys fs, ext2_ino_t ino,
 {
 	struct ext2_dx_countlimit	limit;
 	struct ext2_dx_entry		e;
+	struct ext2_dx_tail		*tail;
 	int				hash, i;
-
+	int				remainder;
 
 	limit = *((struct ext2_dx_countlimit *) ent);
 	limit.count = ext2fs_le16_to_cpu(limit.count);
@@ -130,6 +131,20 @@ static void htree_dump_int_node(ext2_filsys fs, ext2_ino_t ino,
 	fprintf(pager, "Number of entries (count): %d\n", limit.count);
 	fprintf(pager, "Number of entries (limit): %d\n", limit.limit);
 
+	remainder = fs->blocksize - (limit.limit *
+				     sizeof(struct ext2_dx_entry));
+	if (ent == (struct ext2_dx_entry *)(rootnode + 1))
+		remainder -= sizeof(struct ext2_dx_root_info) + 24;
+	else
+		remainder -= 8;
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	    remainder == sizeof(struct ext2_dx_tail)) {
+		tail = (struct ext2_dx_tail *)(ent + limit.limit);
+		fprintf(pager, "Checksum: 0x%08x\n",
+			ext2fs_le32_to_cpu(tail->dt_checksum));
+	}
+
 	for (i=0; i < limit.count; i++) {
 		hash = i ? ext2fs_le32_to_cpu(ent[i].hash) : 0;
 		fprintf(pager, "Entry #%d: Hash 0x%08x%s, block %u\n", i,

