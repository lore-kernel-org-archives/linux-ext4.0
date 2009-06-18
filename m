From: akpm@linux-foundation.org
Subject: [merged] ext3-fix-chain-verification-in-ext3_get_blocks.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:44:51 -0700
Message-ID: <200906182244.n5IMiprI003945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: jack@suse.cz, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: fix chain verification in ext3_get_blocks()
has been removed from the -mm tree.  Its filename was
     ext3-fix-chain-verification-in-ext3_get_blocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: fix chain verification in ext3_get_blocks()
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

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch
reiser4-update-names-of-quota-methods.patch

