From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/5] ext4: Remove bogus wait for unwritten extents in ext4_ind_direct_IO
Date: Wed,  2 Jan 2013 18:45:42 +0100
Message-ID: <1357148744-4895-4-git-send-email-jack@suse.cz>
References: <1357148744-4895-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59209 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab3ABRpy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Jan 2013 12:45:54 -0500
In-Reply-To: <1357148744-4895-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When using indirect blocks there is no possibility to have any unwritten
extents. So wait for them in ext4_ind_direct_IO() is just bogus.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/indirect.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 20862f9..993247c 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -807,11 +807,6 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
 
 retry:
 	if (rw == READ && ext4_should_dioread_nolock(inode)) {
-		if (unlikely(atomic_read(&EXT4_I(inode)->i_unwritten))) {
-			mutex_lock(&inode->i_mutex);
-			ext4_flush_unwritten_io(inode);
-			mutex_unlock(&inode->i_mutex);
-		}
 		/*
 		 * Nolock dioread optimization may be dynamically disabled
 		 * via ext4_inode_block_unlocked_dio(). Check inode's state
-- 
1.7.1

