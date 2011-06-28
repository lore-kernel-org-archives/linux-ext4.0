From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: ext4_orphan_add() remove unnecessary comments
Date: Tue, 28 Jun 2011 16:50:17 +0200
Message-ID: <1309272617-30943-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758405Ab1F1OuW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Jun 2011 10:50:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The comment from Al Viro about possible race in the ext4_orphan_add() is
not justified. There is no race possible as we always have either i_mutex
locked, or the inode can not be referenced from outside hence the
J_ASSERS should not be hit from the reason described in comment.

This commit replaces it with notion that we are holding i_mutex so it
should not be possible for i_nlink to be changed while waiting for
s_orphan_lock.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/namei.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index b754b77..8dde5ab 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1989,18 +1989,11 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	if (!list_empty(&EXT4_I(inode)->i_orphan))
 		goto out_unlock;
 
-	/* Orphan handling is only valid for files with data blocks
-	 * being truncated, or files being unlinked. */
