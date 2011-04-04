From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4:Fix credits computing for indirect mapped files.
Date: Mon, 4 Apr 2011 15:39:35 -0400
Message-ID: <20110404193935.GB2832@thunk.org>
References: <1301058605-29978-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47680 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198Ab1DDTji (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Apr 2011 15:39:38 -0400
Content-Disposition: inline
In-Reply-To: <1301058605-29978-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 25, 2011 at 09:10:05PM +0800, Yongqiang Yang wrote:
> Either the first block or the last one could be not aligned with
> block boundary, 1 block is needed to fix it.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks for the patch submission!

I further modified the patch to make the commit description a bit
clearer, and to fix an additional bug that I noticed while reviewing
your patch.

					- Ted

>From fa0dfea6882a833a70f04b3089a751f75c0d03f6 Mon Sep 17 00:00:00 2001
From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Date: Mon, 4 Apr 2011 15:38:38 -0400
Subject: [PATCH] ext4: fix credits computing for indirect mapped files

When writing a contiguous set of blocks, two indirect blocks could be
needed depending on how the blocks are aligned, so we need to increase
the number of credits needed by one.

[ Also fixed a another bug which could further underestimate the
  number of journal credits needed by 1; the code was using integer
  division instead of DIV_ROUND_UP() -- tytso]

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1a86282..7d11e02 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5398,13 +5398,12 @@ static int ext4_indirect_trans_blocks(struct inode *inode, int nrblocks,
 	/* if nrblocks are contiguous */
 	if (chunk) {
 		/*
-		 * With N contiguous data blocks, it need at most
-		 * N/EXT4_ADDR_PER_BLOCK(inode->i_sb) indirect blocks
-		 * 2 dindirect blocks
-		 * 1 tindirect block
+		 * With N contiguous data blocks, we need at most
+		 * N/EXT4_ADDR_PER_BLOCK(inode->i_sb) + 1 indirect blocks,
+		 * 2 dindirect blocks, and 1 tindirect block
 		 */
-		indirects = nrblocks / EXT4_ADDR_PER_BLOCK(inode->i_sb);
-		return indirects + 3;
+		return DIV_ROUND_UP(nrblocks,
+				    EXT4_ADDR_PER_BLOCK(inode->i_sb)) + 4;
 	}
 	/*
 	 * if nrblocks are not contiguous, worse case, each block touch
-- 
1.7.3.1

