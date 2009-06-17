From: akpm@linux-foundation.org
Subject: [patch 029/133] ext3: fix chain verification in ext3_get_blocks()
Date: Wed, 17 Jun 2009 16:26:23 -0700
Message-ID: <200906172326.n5HNQNTI011090@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, jack@suse.cz, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754128AbZFQXhF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jun 2009 19:37:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

Chain verification in ext3_get_blocks() has been hosed since it called
verify_chain(chain, NULL) which always returns success.  As a result
readers could in theory race with truncate.  On the other hand the race
probably cannot happen with the current locking scheme, since by the time
ext3_truncate() is called all the pages are already removed and hence
get_block() shouldn't be called on such pages...

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext3/inode.c~ext3-fix-chain-verification-in-ext3_get_blocks fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-fix-chain-verification-in-ext3_get_blocks
+++ a/fs/ext3/inode.c
@@ -820,7 +820,7 @@ int ext3_get_blocks_handle(handle_t *han
 		while (count < maxblocks && count <= blocks_to_boundary) {
 			ext3_fsblk_t blk;
 
-			if (!verify_chain(chain, partial)) {
+			if (!verify_chain(chain, chain + depth - 1)) {
 				/*
 				 * Indirect block might be removed by
 				 * truncate while we were reading it.
_
