From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH 1/4]ext4: Fix wrong comparisons in	mext_check_arguments()
Date: Wed, 16 Sep 2009 13:56:04 +0900
Message-ID: <4AB06FE4.2010405@rs.jp.nec.com>
References: <4A9DE3DE.2010509@rs.jp.nec.com> <20090906021032.GA3055@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:39844 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbZIPE4V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Sep 2009 00:56:21 -0400
In-Reply-To: <20090906021032.GA3055@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

We found that "fix-wrong-comparisons-in-mext_check_arguments"
in the ext4 patch queue does not fix the objective issue completely.
(The last partial block is not checked in mext_check_arguments().)

Could you replace "fix-wrong-comparisons-in-mext_check_arguments"
in the ext4 patch queue with this patch ?

Regards,
Akira Fujita

Theodore Tso wrote:
> On Wed, Sep 02, 2009 at 12:17:50PM +0900, Akira Fujita wrote:
>> ext4: Fix wrong comparisons in mext_check_arguments()
>>
>> From: Akira Fujita <a-fujita@rs.jp.nec.com>
>>
>> mext_check_arguments() in move_extents.c has wrong comparisons.
>> orig_start which is passed from user-space is block unit,
>> but i_size of inode is byte unit, therefore the checks do not work fine.
>> This mis-check leads to the overflow of 'len' and then hits BUG_ON()
>> in ext4_move_extens().   The patch fixes this issue.
> 
> Thanks, I've added this to the ext4 patch queue to be pushed when the
> 2.6.32 merge window opens.
> 
> 						- Ted

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Reviewed-by: Greg Freemyer <greg.freemyer@gmail.com>
---
 move_extent.c |   46 +++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 429fb6f..0670464 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -898,6 +898,10 @@ mext_check_arguments(struct inode *orig_inode,
 			  struct inode *donor_inode, __u64 orig_start,
 			  __u64 donor_start, __u64 *len, __u64 moved_len)
 {
+	ext4_lblk_t orig_blocks, donor_blocks;
+	unsigned int blkbits = orig_inode->i_blkbits;
+	unsigned int blocksize = 1 << blkbits;
+
 	/* Regular file check */
 	if (!S_ISREG(orig_inode->i_mode) || !S_ISREG(donor_inode->i_mode)) {
 		ext4_debug("ext4 move extent: The argument files should be "
@@ -972,43 +976,47 @@ mext_check_arguments(struct inode *orig_inode,
 	}

 	if (orig_inode->i_size > donor_inode->i_size) {
-		if (orig_start >= donor_inode->i_size) {
+		donor_blocks = (donor_inode->i_size + blocksize - 1) >> blkbits;
+		/* TODO: eliminate this artificial restriction */
+		if (orig_start >= donor_blocks) {
 			ext4_debug("ext4 move extent: orig start offset "
-			"[%llu] should be less than donor file size "
-			"[%lld] [ino:orig %lu, donor_inode %lu]\n",
-			orig_start, donor_inode->i_size,
+			"[%llu] should be less than donor file blocks "
+			"[%u] [ino:orig %lu, donor %lu]\n",
+			orig_start, donor_blocks,
 			orig_inode->i_ino, donor_inode->i_ino);
 			return -EINVAL;
 		}

-		if (orig_start + *len > donor_inode->i_size) {
+		/* TODO: eliminate this artificial restriction */
+		if (orig_start + *len > donor_blocks) {
 			ext4_debug("ext4 move extent: End offset [%llu] should "
-				"be less than donor file size [%lld]."
-				"So adjust length from %llu to %lld "
+				"be less than donor file blocks [%u]."
+				"So adjust length from %llu to %llu "
 				"[ino:orig %lu, donor %lu]\n",
-				orig_start + *len, donor_inode->i_size,
-				*len, donor_inode->i_size - orig_start,
+				orig_start + *len, donor_blocks,
+				*len, donor_blocks - orig_start,
 				orig_inode->i_ino, donor_inode->i_ino);
-			*len = donor_inode->i_size - orig_start;
+			*len = donor_blocks - orig_start;
 		}
 	} else {
-		if (orig_start >= orig_inode->i_size) {
+		orig_blocks = (orig_inode->i_size + blocksize - 1) >> blkbits;
+		if (orig_start >= orig_blocks) {
 			ext4_debug("ext4 move extent: start offset [%llu] "
-				"should be less than original file size "
-				"[%lld] [inode:orig %lu, donor %lu]\n",
-				 orig_start, orig_inode->i_size,
+				"should be less than original file blocks "
+				"[%u] [ino:orig %lu, donor %lu]\n",
+				 orig_start, orig_blocks,
 				orig_inode->i_ino, donor_inode->i_ino);
 			return -EINVAL;
 		}

-		if (orig_start + *len > orig_inode->i_size) {
+		if (orig_start + *len > orig_blocks) {
 			ext4_debug("ext4 move extent: Adjust length "
-				"from %llu to %lld. Because it should be "
-				"less than original file size "
+				"from %llu to %llu. Because it should be "
+				"less than original file blocks "
 				"[ino:orig %lu, donor %lu]\n",
-				*len, orig_inode->i_size - orig_start,
+				*len, orig_blocks - orig_start,
 				orig_inode->i_ino, donor_inode->i_ino);
-			*len = orig_inode->i_size - orig_start;
+			*len = orig_blocks - orig_start;
 		}
 	}
