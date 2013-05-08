From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] e2fsck: Fix journal block tag checksum verification
Date: Wed, 8 May 2013 15:02:49 -0700
Message-ID: <20130508220249.GA8371@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42503 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab3EHWCx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 May 2013 18:02:53 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Al Viro complained of a ton of bogosity with regards to the jbd2 block tag
header checksum.  This one checksum is 16 bits, so cut off the upper 16 bits
and treat it as a 16-bit value and don't mess around with be32* conversions.
Fortunately metadata checksumming is still "experimental" and not in a shipping
e2fsprogs, so there should be few users affected by this.

This is the e2fsprogs version of the kernel patch.

Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/recovery.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index 69ed68a..5af3e7b 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -395,7 +395,8 @@ static int jbd2_commit_block_csum_verify(journal_t *j, void *buf)
 static int jbd2_block_tag_csum_verify(journal_t *j, journal_block_tag_t *tag,
 				      void *buf, __u32 sequence)
 {
-	__u32 provided, calculated;
+	__u32 calculated;
+	__u16 provided, crc;
 
 	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
 		return 1;
@@ -406,9 +407,10 @@ static int jbd2_block_tag_csum_verify(journal_t *j, journal_block_tag_t *tag,
 	calculated = ext2fs_crc32c_le(calculated, (__u8 *)&sequence,
 				      sizeof(sequence));
 	calculated = ext2fs_crc32c_le(calculated, buf, j->j_blocksize) & 0xffff;
+	crc = calculated & 0xFFFF;
 	provided = ext2fs_be16_to_cpu(tag->t_checksum);
 
-	return provided == ext2fs_cpu_to_be32(calculated);
+	return provided == crc;
 }
 
 static int do_one_pass(journal_t *journal,
