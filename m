From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Bail early when clearing inode journal flag fails
Date: Thu, 23 Oct 2014 15:05:43 +0200
Message-ID: <1414069543-29853-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482AbaJWNFt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Oct 2014 09:05:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When clearing inode journal flag, we call jbd2_journal_flush() to force
all the journalled data to their final locations. Currently we ignore
when this fails and continue clearing inode journal flag. This isn't a
big problem because when jbd2_journal_flush() fails, journal is likely
aborted anyway. But it can still lead to somewhat confusing results so
rather bail out early.

Coverity-id: 989044
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e9777f93cf05..3356ab5395f4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4959,7 +4959,12 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	if (val)
 		ext4_set_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
 	else {
-		jbd2_journal_flush(journal);
+		err = jbd2_journal_flush(journal);
+		if (err < 0) {
+			jbd2_journal_unlock_updates(journal);
+			ext4_inode_resume_unlocked_dio(inode);
+			return err;
+		}
 		ext4_clear_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
 	}
 	ext4_set_aops(inode);
-- 
1.8.1.4

