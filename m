From: akpm@linux-foundation.org
Subject: + ext3-fix-chain-verification-in-ext3_get_blocks.patch added to -mm tree
Date: Thu, 09 Apr 2009 13:32:52 -0700
Message-ID: <200904092032.n39KWqYF011512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: fix chain verification in ext3_get_blocks()
has been added to the -mm tree.  Its filename is
     ext3-fix-chain-verification-in-ext3_get_blocks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
linux-next.patch
ext2-add-blk_issue_flush-to-syncing-paths.patch
ext2-fix-data-corruption-for-racing-writes.patch
ext3-fix-chain-verification-in-ext3_get_blocks.patch
reiser4-update-names-of-quota-methods.patch

