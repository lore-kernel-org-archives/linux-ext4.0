From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [Bug 25352] New: resizing ext4 will corrupt filesystem
Date: Mon, 20 Dec 2010 22:32:09 -0500
Message-ID: <20101221033209.GA6924@thunk.org>
References: <bug-25352-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="45Z9DzgjV8m4Oswq"
Cc: linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44202 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933461Ab0LUDcN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Dec 2010 22:32:13 -0500
Content-Disposition: inline
In-Reply-To: <bug-25352-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 20, 2010 at 08:56:46PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> Using resize2fs on an ext4 will result in a corrupted filesystem. This is a
> regression (obviously).

Yes, this is a regression new to 2.6.37-rc1, which was introduced by
commit a31437b85: ext4: use sb_issue_zeroout in setup_new_group_blocks.

When we replaced the loop zero'ing the inode table blocks with
sb_issue_zeroout, we accidentally also removed this little tidbit:

-               ext4_set_bit(bit, bh->b_data);

... which was responsible for setting the block allocation bitmap to
reserve the block descriptor blocks and inode table blocks.  Oops...

I believe this patch should fix things.

						- Ted



--45Z9DzgjV8m4Oswq
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-fix-on-line-resizing-regression.patch"

>From 2bd0b6de26c463f15ad6b72a6679ca60ce45a827 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Mon, 20 Dec 2010 22:30:36 -0500
Subject: [PATCH] ext4: fix on-line resizing regression

https://bugzilla.kernel.org/show_bug.cgi?id=25352

This regression was caused by commit a31437b85: "ext4: use
sb_issue_zeroout in setup_new_group_blocks", by accidentally dropping
the code which reserved the block group descriptor and inode table
blocks.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/resize.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index dc96392..981c847 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -232,6 +232,8 @@ static int setup_new_group_blocks(struct super_block *sb,
 			       GFP_NOFS);
 	if (err)
 		goto exit_bh;
+	for (i = 0, bit = gdblocks + 1; i < reserved_gdb; i++, bit++)
+		ext4_set_bit(bit, bh->b_data);
 
 	ext4_debug("mark block bitmap %#04llx (+%llu)\n", input->block_bitmap,
 		   input->block_bitmap - start);
@@ -247,6 +249,9 @@ static int setup_new_group_blocks(struct super_block *sb,
 	err = sb_issue_zeroout(sb, block, sbi->s_itb_per_group, GFP_NOFS);
 	if (err)
 		goto exit_bh;
+	for (i = 0, bit = input->inode_table - start;
+	     i < sbi->s_itb_per_group; i++, bit++)
+		ext4_set_bit(bit, bh->b_data);
 
 	if ((err = extend_or_restart_transaction(handle, 2, bh)))
 		goto exit_bh;
-- 
1.7.3.1


--45Z9DzgjV8m4Oswq--
