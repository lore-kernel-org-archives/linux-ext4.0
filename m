From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] vfs: Avoid creation of directory loops for corrupted filesystems
Date: Tue, 29 May 2012 22:07:44 +0200
Message-ID: <1338322067-17566-2-git-send-email-jack@suse.cz>
References: <1338322067-17566-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42497 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab2E2UH4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 May 2012 16:07:56 -0400
In-Reply-To: <1338322067-17566-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When a directory hierarchy is corrupted (e. g. due to a bit flip on the media),
it can happen that it contains loops of directories. That creates possibilities
for deadlock when locking directories.

Fix the problem by checking in d_splice_alias() that when we splice a
directory, it does not have any other connected alias.

Reported-by: Sami Liedes <sami.liedes@iki.fi>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dcache.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 4435d8b..ca31a1e 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1658,6 +1658,10 @@ struct dentry *d_splice_alias(struct inode *inode, struct dentry *dentry)
 			d_move(new, dentry);
 			iput(inode);
 		} else {
+			if (unlikely(!list_empty(&inode->i_dentry))) {
+				spin_unlock(&inode->i_lock);
+				return ERR_PTR(-EIO);
+			}
 			/* already taking inode->i_lock, so d_add() by hand */
 			__d_instantiate(dentry, inode);
 			spin_unlock(&inode->i_lock);
-- 
1.7.1

