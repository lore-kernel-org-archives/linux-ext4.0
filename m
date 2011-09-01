From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 23/37] debugfs: Print htree internal node checksums
Date: Wed, 31 Aug 2011 17:37:38 -0700
Message-ID: <20110901003738.1176.69774.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48136 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757073Ab1IAAhl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 20:37:41 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p810DVDm027072
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:13:31 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810benb231734
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:37:40 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7VKbQkw010218
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 17:37:27 -0300
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Print htree node checksums when dumping a directory index.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 debugfs/htree.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)


diff --git a/debugfs/htree.c b/debugfs/htree.c
index d72b996..9b4758a 100644
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
+			ext2fs_le32_to_cpu(tail->checksum));
+	}
+
 	for (i=0; i < limit.count; i++) {
 		hash = i ? ext2fs_le32_to_cpu(ent[i].hash) : 0;
 		fprintf(pager, "Entry #%d: Hash 0x%08x%s, block %u\n", i,

