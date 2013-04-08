From: Jan Kara <jack@suse.cz>
Subject: [PATCH 27/29] ext4: Remove wait for unwritten extents in ext4_ind_direct_IO()
Date: Mon,  8 Apr 2013 23:32:32 +0200
Message-ID: <1365456754-29373-28-git-send-email-jack@suse.cz>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936385Ab3DHVdJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Apr 2013 17:33:09 -0400
In-Reply-To: <1365456754-29373-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We don't have to wait for unwritten extent conversion in
ext4_ind_direct_IO() as all writes that happened before DIO are flushed
by the generic code and extent conversion has happened before we cleared
PageWriteback bit.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/indirect.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 197b202..d1c6be4 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -809,11 +809,6 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
 
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

