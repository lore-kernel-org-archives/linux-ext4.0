From: Eric Gouriou <egouriou@google.com>
Subject: [PATCH] ext4: fix unbalanced up_write() in ext4_ext_truncate() error path
Date: Tue, 10 May 2011 11:12:57 -0700
Message-ID: <1305051177-18452-1-git-send-email-egouriou@google.com>
Cc: linux-ext4@vger.kernel.org, Eric Gouriou <egouriou@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:52112 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab1EJSNI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 May 2011 14:13:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_ext_truncate() should not invoke up_write(&EXT4_I(inode)->i_data_sem)
when ext4_orphan_add() returns an error, as it hasn't performed a
down_write() yet. This trivial patch fixes this by moving the up_write()
invocation above the out_stop label.

Signed-off-by: Eric Gouriou <egouriou@google.com>
---
 fs/ext4/extents.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e363f21..ae3c9e6 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3443,8 +3443,9 @@ void ext4_ext_truncate(struct inode *inode)
 	if (IS_SYNC(inode))
 		ext4_handle_sync(handle);
 
-out_stop:
 	up_write(&EXT4_I(inode)->i_data_sem);
+
+out_stop:
 	/*
 	 * If this was a simple ftruncate() and the file will remain alive,
 	 * then we need to clear up the orphan record which we created above.
-- 
1.7.3.1

