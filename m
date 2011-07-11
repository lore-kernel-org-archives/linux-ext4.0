From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: avoid finding next leaf if newext->ee_block
 smaller than fex->ee_block
Date: Mon, 11 Jul 2011 15:52:11 -0400
Message-ID: <20110711195211.GQ28763@thunk.org>
References: <1309421014-6148-1-git-send-email-sanbai@taobao.com>
 <1309421014-6148-2-git-send-email-sanbai@taobao.com>
 <BANLkTikeMA72P2-6eSv=2cqOtvEaHRbsZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Robin Dong <hao.bigrat@gmail.com>, linux-ext4@vger.kernel.org,
	Robin Dong <sanbai@taobao.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45194 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757419Ab1GKTwP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jul 2011 15:52:15 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTikeMA72P2-6eSv=2cqOtvEaHRbsZA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 30, 2011 at 04:42:31PM +0800, Yongqiang Yang wrote:
> How about:
>            next = EXT_MAX_BLOCKS;
>            if (le32_to_cpu(newext->ee_block) > le32_to_cpu(fex->ee_block)
>                    next = ext4_ext_next_leaf_block(inode, path);
>            if (next != EXT_MAX_BLOCKS) {

Agreed, that's a better way of doing things.  Also, Robin, please
compare and contrast your description with mine.  The commit
description shouldn't just be a textual description of the change.  It
should give the larger context of the change and why it's important.

              	    	       	       - Ted

commit 2a3f7e0e0e55f8817fbe92d111ef2a06e6b8ef18
Author: Robin Dong <sanbai@taobao.com>
Date:   Mon Jul 11 15:43:38 2011 -0400

    ext4: avoid unneeded ext4_ext_next_leaf_block() while inserting extents
    
    Optimize ext4_exT_insert_extent() by avoiding
    ext4_ext_next_leaf_block() when the result is not used/needed.
    
    Signed-off-by: Robin Dong <sanbai@taobao.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9cbdcb2..f1c538e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1730,9 +1730,10 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 
 	/* probably next leaf has space for us? */
 	fex = EXT_LAST_EXTENT(eh);
-	next = ext4_ext_next_leaf_block(inode, path);
-	if (le32_to_cpu(newext->ee_block) > le32_to_cpu(fex->ee_block)
-	    && next != EXT_MAX_BLOCKS) {
+	next = EXT_MAX_BLOCKS;
+	if (le32_to_cpu(newext->ee_block) > le32_to_cpu(fex->ee_block))
+		next = ext4_ext_next_leaf_block(inode, path);
+	if (next != EXT_MAX_BLOCKS) {
 		ext_debug("next leaf block - %d\n", next);
 		BUG_ON(npath != NULL);
 		npath = ext4_ext_find_extent(inode, next, NULL);
