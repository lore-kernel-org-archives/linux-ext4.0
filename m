From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/5] ext4_zero_range: fix incorect journal credits
 reservation
Date: Wed, 27 Aug 2014 17:31:03 -0400
Message-ID: <20140827213103.GV11317@thunk.org>
References: <1408707147-22482-1-git-send-email-dmonakhov@openvz.org>
 <1408707147-22482-4-git-send-email-dmonakhov@openvz.org>
 <20140823190835.GB6236@thunk.org>
 <87k35x9gtw.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52731 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965100AbaH0VbK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Aug 2014 17:31:10 -0400
Content-Disposition: inline
In-Reply-To: <87k35x9gtw.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 25, 2014 at 11:19:39AM +0400, Dmitry Monakhov wrote:
> Yes, but ext4_index_trans_blocks is statically defined in inode.c,
> but since zero_range works only for extent based
> ext4_ext_index_trans_blocks is sufficient. Also we must reserve 2 block
> for data. So final calculation looks like follows:
> credits =  ext4_ext_index_trans_blocks(inode, 2) + 2

It turns out this wasn't enough.  This was causing test failures in
the data=journal case for tests generic/008, generic/091, generic/127,
and generic/263, due to not reserving enough credits.  After taking a
closer look at the code, and the requirements of ext4_zero_range, I
believe this is the correct fix.

       	       	   	   	   	   - Ted

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0d531d1..0e9de23 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4831,8 +4831,13 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 		if (ret)
 			goto out_dio;
 	}
-	/* In worst case we have to writeout two nonadjacent unwritten blocks */
-	credits = ext4_ext_index_trans_blocks(inode, 2) + 2;
+	/*
+	 * In worst case we have to writeout two nonadjacent unwritten
+	 * blocks and update the inode
+	 */
+	credits = (2 * ext4_ext_index_trans_blocks(inode, 2)) + 1;
+	if (ext4_should_journal_data(inode))
+		credits += 2;
 	handle = ext4_journal_start(inode, EXT4_HT_MISC, credits);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
