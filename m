From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] jbd2: Fix block tag checksum verification brokenness
Date: Wed, 8 May 2013 15:00:27 -0700
Message-ID: <20130508220027.GB7730@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41592 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab3EHWAc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 May 2013 18:00:32 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Al Viro complained of a ton of bogosity with regards to the jbd2 block tag
header checksum.  This one checksum is 16 bits, so cut off the upper 16 bits
and treat it as a 16-bit value and don't mess around with be32* conversions.
Fortunately metadata checksumming is still "experimental" and not in a shipping
e2fsprogs, so there should be few users affected by this.

Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/jbd2/commit.c   |   14 ++++++++------
 fs/jbd2/recovery.c |   14 ++++++++------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 750c701..e514fcd 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -343,20 +343,22 @@ static void jbd2_block_tag_csum_set(journal_t *j, journal_block_tag_t *tag,
 {
 	struct page *page = bh->b_page;
 	__u8 *addr;
-	__u32 csum;
+	__u32 csum32;
+	__u16 crc;
 
 	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
 		return;
 
 	sequence = cpu_to_be32(sequence);
 	addr = kmap_atomic(page);
-	csum = jbd2_chksum(j, j->j_csum_seed, (__u8 *)&sequence,
-			  sizeof(sequence));
-	csum = jbd2_chksum(j, csum, addr + offset_in_page(bh->b_data),
-			  bh->b_size);
+	csum32 = jbd2_chksum(j, j->j_csum_seed, (__u8 *)&sequence,
+			     sizeof(sequence));
+	csum32 = jbd2_chksum(j, csum32, addr + offset_in_page(bh->b_data),
+			     bh->b_size);
 	kunmap_atomic(addr);
+	crc = csum32 & 0xFFFF;
 
-	tag->t_checksum = cpu_to_be32(csum);
+	tag->t_checksum = cpu_to_be16(crc);
 }
 /*
  * jbd2_journal_commit_transaction
diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 626846b..1fa766c 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -399,18 +399,20 @@ static int jbd2_commit_block_csum_verify(journal_t *j, void *buf)
 static int jbd2_block_tag_csum_verify(journal_t *j, journal_block_tag_t *tag,
 				      void *buf, __u32 sequence)
 {
-	__u32 provided, calculated;
+	__u32 csum32;
+	__u16 provided, crc;
 
 	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
 		return 1;
 
 	sequence = cpu_to_be32(sequence);
-	calculated = jbd2_chksum(j, j->j_csum_seed, (__u8 *)&sequence,
-				 sizeof(sequence));
-	calculated = jbd2_chksum(j, calculated, buf, j->j_blocksize);
-	provided = be32_to_cpu(tag->t_checksum);
+	csum32 = jbd2_chksum(j, j->j_csum_seed, (__u8 *)&sequence,
+			     sizeof(sequence));
+	csum32 = jbd2_chksum(j, csum32, buf, j->j_blocksize);
+	crc = csum32 & 0xFFFF;
+	provided = be16_to_cpu(tag->t_checksum);
 
-	return provided == cpu_to_be32(calculated);
+	return provided == crc;
 }
 
 static int do_one_pass(journal_t *journal,
