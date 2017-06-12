From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Avoid unnecessary stalls in ext4_evict_inode()
Date: Mon, 12 Jun 2017 17:20:13 +0200
Message-ID: <20170612152013.4045-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60257 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751594AbdFLPV0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 12 Jun 2017 11:21:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

These days inode reclaim calls evict_inode() only when it has no pages
in the mapping. In that case it is not necessary to wait for transaction
commit in ext4_evict_inode() as there can be no pages waiting to be
committed. So avoid unnecessary transaction waiting in that case.

We still have to keep the check for the case where ext4_evict_inode()
gets called from other paths (e.g. umount) where inode still can have
some page cache pages.

Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5834c4d76be8..3aef67ca18ac 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -213,7 +213,8 @@ void ext4_evict_inode(struct inode *inode)
 		 */
 		if (inode->i_ino != EXT4_JOURNAL_INO &&
 		    ext4_should_journal_data(inode) &&
-		    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode))) {
+		    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode)) &&
+		    inode->i_data.nrpages) {
 			journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
 			tid_t commit_tid = EXT4_I(inode)->i_datasync_tid;
 
-- 
2.12.0
