From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 05/14] e2fsck: fix buffer overrun in revoke block scanning
Date: Thu, 14 May 2015 12:37:43 -0700
Message-ID: <20150514193743.GH30577@birch.djwong.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
 <20150514002140.10785.5088.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17383 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964826AbbENTht (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 May 2015 15:37:49 -0400
Content-Disposition: inline
In-Reply-To: <20150514002140.10785.5088.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Check the value of r_count to ensure that we never try to read revoke
records past the end of the revoke block.  It turns out that the
journal writing code in debugfs was also playing fast and loose with
the r_count, so fix that as well.

The Coverity bug was 1297508.

v2: Allow the revoke block to use all slots, including the last
one.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/do_journal.c                   |   19 +++++++++++--------
 e2fsck/recovery.c                      |   10 +++++++++-
 e2fsck/revoke.c                        |   26 ++++++++++++++------------
 tests/j_corrupt_revoke_rcount/expect.1 |    8 ++++++++
 tests/j_corrupt_revoke_rcount/expect.2 |    8 ++++++++
 tests/j_corrupt_revoke_rcount/image.gz |  Bin
 tests/j_corrupt_revoke_rcount/name     |    1 +
 7 files changed, 51 insertions(+), 21 deletions(-)
 create mode 100644 tests/j_corrupt_revoke_rcount/expect.1
 create mode 100644 tests/j_corrupt_revoke_rcount/expect.2
 create mode 100644 tests/j_corrupt_revoke_rcount/image.gz
 create mode 100644 tests/j_corrupt_revoke_rcount/name

diff --git a/debugfs/do_journal.c b/debugfs/do_journal.c
index 46d1793..22322e5 100644
--- a/debugfs/do_journal.c
+++ b/debugfs/do_journal.c
@@ -175,7 +175,7 @@ static errcode_t journal_add_revoke_to_trans(journal_transaction_t *trans,
 	void *buf;
 	size_t i, offset;
 	blk64_t curr_blk;
-	int csum_size = 0;
+	int sz, csum_size = 0;
 	struct buffer_head *bh;
 	errcode_t err;
 
@@ -204,9 +204,15 @@ static errcode_t journal_add_revoke_to_trans(journal_transaction_t *trans,
 	jrb->r_header.h_sequence = ext2fs_cpu_to_be32(trans->tid);
 	offset = sizeof(*jrb);
 
+	if (JFS_HAS_INCOMPAT_FEATURE(trans->journal,
+				     JFS_FEATURE_INCOMPAT_64BIT))
+		sz = 8;
+	else
+		sz = 4;
+
 	for (i = 0; i < revoke_len; i++) {
 		/* Block full, write to journal */
-		if (offset > trans->journal->j_blocksize - csum_size) {
+		if (offset + sz > trans->journal->j_blocksize - csum_size) {
 			jrb->r_count = ext2fs_cpu_to_be32(offset);
 			jbd2_revoke_csum_set(trans->journal, bh);
 
@@ -233,16 +239,13 @@ static errcode_t journal_add_revoke_to_trans(journal_transaction_t *trans,
 		}
 
 		if (JFS_HAS_INCOMPAT_FEATURE(trans->journal,
-					     JFS_FEATURE_INCOMPAT_64BIT)) {
+					     JFS_FEATURE_INCOMPAT_64BIT))
 			*((__u64 *)(&((char *)buf)[offset])) =
 				ext2fs_cpu_to_be64(revoke_list[i]);
-			offset += 8;
-
-		} else {
+		else
 			*((__u32 *)(&((char *)buf)[offset])) =
 				ext2fs_cpu_to_be32(revoke_list[i]);
-			offset += 4;
-		}
+		offset += sz;
 	}
 
 	if (offset > 0) {
diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index b5ce3b3..d5244be 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -839,15 +839,23 @@ static int scan_revoke_records(journal_t *journal, struct buffer_head *bh,
 {
 	journal_revoke_header_t *header;
 	int offset, max;
+	int csum_size = 0;
+	__u32 rcount;
 	int record_len = 4;
 
 	header = (journal_revoke_header_t *) bh->b_data;
 	offset = sizeof(journal_revoke_header_t);
-	max = ext2fs_be32_to_cpu(header->r_count);
+	rcount = ext2fs_be32_to_cpu(header->r_count);
 
 	if (!jbd2_revoke_block_csum_verify(journal, header))
 		return -EINVAL;
 
+	if (journal_has_csum_v2or3(journal))
+		csum_size = sizeof(struct journal_revoke_tail);
+	if (rcount > journal->j_blocksize - csum_size)
+		return -EINVAL;
+	max = rcount;
+
 	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_64BIT))
 		record_len = 8;
 
diff --git a/e2fsck/revoke.c b/e2fsck/revoke.c
index b4c3f5f..0543099 100644
--- a/e2fsck/revoke.c
+++ b/e2fsck/revoke.c
@@ -583,7 +583,7 @@ static void write_one_revoke_record(journal_t *journal,
 {
 	int csum_size = 0;
 	struct buffer_head *descriptor;
-	int offset;
+	int sz, offset;
 	journal_header_t *header;
 
 	/* If we are already aborting, this all becomes a noop.  We
@@ -600,9 +600,14 @@ static void write_one_revoke_record(journal_t *journal,
 	if (journal_has_csum_v2or3(journal))
 		csum_size = sizeof(struct journal_revoke_tail);
 
+	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_64BIT))
+		sz = 8;
+	else
+		sz = 4;
+
 	/* Make sure we have a descriptor with space left for the record */
 	if (descriptor) {
-		if (offset >= journal->j_blocksize - csum_size) {
+		if (offset + sz > journal->j_blocksize - csum_size) {
 			flush_descriptor(journal, descriptor, offset, write_op);
 			descriptor = NULL;
 		}
@@ -625,16 +630,13 @@ static void write_one_revoke_record(journal_t *journal,
 		*descriptorp = descriptor;
 	}
 
-	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_64BIT)) {
-		* ((__u64 *)(&descriptor->b_data[offset])) =
-			ext2fs_cpu_to_be64(record->blocknr);
-		offset += 8;
-
-	} else {
-		* ((__u32 *)(&descriptor->b_data[offset])) =
-			ext2fs_cpu_to_be32(record->blocknr);
-		offset += 4;
-	}
+	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_64BIT)) {
+		* ((__be64 *)(&descriptor->b_data[offset])) =
+			cpu_to_be64(record->blocknr);
+	else
+		* ((__be32 *)(&descriptor->b_data[offset])) =
+			cpu_to_be32(record->blocknr);
+	offset += sz;
 
 	*offsetp = offset;
 }
diff --git a/tests/j_corrupt_revoke_rcount/expect.1 b/tests/j_corrupt_revoke_rcount/expect.1
new file mode 100644
index 0000000..97324f3
--- /dev/null
+++ b/tests/j_corrupt_revoke_rcount/expect.1
@@ -0,0 +1,8 @@
+test_filesys: recovering journal
+../e2fsck/e2fsck: Invalid argument while recovering ext3 journal of test_filesys
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+
+test_filesys: ********** WARNING: Filesystem still has errors **********
+
+Exit status is 12
diff --git a/tests/j_corrupt_revoke_rcount/expect.2 b/tests/j_corrupt_revoke_rcount/expect.2
new file mode 100644
index 0000000..c569901
--- /dev/null
+++ b/tests/j_corrupt_revoke_rcount/expect.2
@@ -0,0 +1,8 @@
+test_filesys: recovering journal
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/512 files (9.1% non-contiguous), 1066/2048 blocks
+Exit status is 0
diff --git a/tests/j_corrupt_revoke_rcount/image.gz b/tests/j_corrupt_revoke_rcount/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..c8b19e8c4ebe28f9e368635fa3962d4f0685d762
GIT binary patch
literal 8648
zcmb2|=3v+~Hz<^e`ORJ1Y!OEZh6gkEb{tnNI+!5H;gZYzQpaVY_a%+8i8nG-Cpk51
z{>jKmO4PiOIZ^3am{^&Z=VN_=i}DJBE;>oCioccd>nF0BO1z)+-16Ss+k0iF&6IwY
zRyO^%K!dZkcOZYFq3Zi=#hl~wXMg6<PE9%bO@H-gZpAIP!}lGX@P60DNc}01hYNNV
z*{S9S?`zkbTlMGHwX5Hb3hS?n-T!gp&&<sIUE%L5|9?63HaPpe-rh>Hn^mQiMc-0;
z)*1v&)7E!SUM<#E^(}wO&(B+CCg~il=sFwXUp&=4`)$N*kM$87!|QsIqvRME{%8KE
zw>kRq+>d(eG+X5dZ!4a4N-;4oG#tGCj(w|hTpa@g!;j;iUjJ8COuM{rhj@ZY%FQn&
zh5YZIrzuBA?W@kuD*X9x?(B0@f$9z{kh*93|NlLmXa7MwM&ngnAo`CykTm$u4kUlw
z{IzrQdFK~)U-Gy7Hv8rh{yhGd_PockSCxR0JV*Zg_b}|w-`>4;<FYiMz=H#4|8M><
z`}#-mXW{0bOIH1R(0q#-D2@j_SdbxqHyPyU1@A4Hf&L&D9GHJ2Vs8A4V~JYdug}~f
zu~w^I_lkAq#+;m^23IEQmwmgjyR+-PV>ZjT!>1N+iO3KAQor%d&wuyctowSS{crs8
zKMQyLd6<&_KmPW`|K_LsKf$8l%VLA&|I;1ToG+PG@A~_E*R%iKAI}F!9<wLcoum3j
zLtr!nMnhmU1V%$(Gz3ONU^E0qLtr!nMnhmU1V%$(Gz3ONU^E0qLtr!nMnhmU1V%$(
zGz3ONU^E0qLtr!nMnhmU1V%$(XorCPt!8KN1i$0|_}Mj#V9#)OmhZI$E?!^&01SK{
AN&o-=

literal 0
HcmV?d00001

diff --git a/tests/j_corrupt_revoke_rcount/name b/tests/j_corrupt_revoke_rcount/name
new file mode 100644
index 0000000..92b523e
--- /dev/null
+++ b/tests/j_corrupt_revoke_rcount/name
@@ -0,0 +1 @@
+corrupt revoke r_count buffer overflow
