From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 21/47] debugfs: Print htree internal node checksums
Date: Sat, 08 Oct 2011 00:35:29 -0700
Message-ID: <20111008073529.17888.67813.stgit@elm3c44.beaverton.ibm.com>
References: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e35.co.us.ibm.com ([32.97.110.153]:36788 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab1JHHiK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Oct 2011 03:38:10 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 8 Oct 2011 01:38:10 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987ZWLg143116
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:35:32 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987ZUhW007522
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:35:31 -0600
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Print htree node checksums when dumping a directory index.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 debugfs/htree.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)


diff --git a/debugfs/htree.c b/debugfs/htree.c
index 06e7737..cfdfdd6 100644
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

