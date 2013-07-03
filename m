From: Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH stable 3.3 thru 3.8] ext3: fix data=journal fast mount/umount hang
Date: Wed, 3 Jul 2013 17:34:36 -0400
Message-ID: <20130703213436.GA16960@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:47177 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932417Ab3GCVeh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Jul 2013 17:34:37 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch appears to have been missed for ext3, while the ext4 version was 
merged back in March -- see 1363783057-3874-1-git-send-email-tytso@mit.edu.  
A customer of mine has been running into this bug on their production 
servers on 3.4-stable.  It applies cleanly to the 3.3 through 3.8 trees.

		-ben

commit e643692138cfa33528f054b071ba2583509bb217
Author: Jan Kara <jack@suse.cz>
Date:   Wed Mar 20 14:39:05 2013 +0100

ext3: fix data=journal fast mount/umount hang
    
In data=journal mode, if we unmount the file system before a
transaction has a chance to complete, when the journal inode is being
evicted, we can end up calling into log_wait_commit() for the
last transaction, after the journalling machinery has been shut down.
That triggers the WARN_ONCE in __log_start_commit().
    
Arguably we should adjust ext3_should_journal_data() to return FALSE
for the journal inode, but the only place it matters is
ext3_evict_inode(), and so it's to save a bit of CPU time, and to make
the patch much more obviously correct by inspection(tm), we'll fix it
by explicitly not trying to waiting for a journal commit when we are
evicting the journal inode, since it's guaranteed to never succeed in
this case.
    
This can be easily replicated via:
    
         mount -t ext3 -o data=journal /dev/vdb /vdb ; umount /vdb
    
This is a port of ext4 fix from Ted Ts'o.
    
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index d512c4b..d706dbf 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -218,7 +218,8 @@ void ext3_evict_inode (struct inode *inode)
 	 */
 	if (inode->i_nlink && ext3_should_journal_data(inode) &&
 	    EXT3_SB(inode->i_sb)->s_journal &&
-	    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode))) {
+	    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode)) &&
+	    inode->i_ino != EXT3_JOURNAL_INO) {
 		tid_t commit_tid = atomic_read(&ei->i_datasync_tid);
 		journal_t *journal = EXT3_SB(inode->i_sb)->s_journal;
 
