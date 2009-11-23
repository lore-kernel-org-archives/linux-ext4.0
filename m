From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/4] ext4: fix incorrect block reservation on quota transfer.
Date: Mon, 23 Nov 2009 21:34:37 +0300
Message-ID: <87tywlxf7m.fsf@openvz.org>
References: <87my2d5ctb.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:48505 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbZKWSec (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Nov 2009 13:34:32 -0500
Received: from dmon-lp ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru (Sun Java(tm) System Messaging Server 7u2-7.02 64bit
 (built Apr 16 2009)) with ESMTPA id <0KTK00DYIRT84B10@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Mon, 23 Nov 2009 21:39:11 +0300 (MSK)
In-reply-to: <87my2d5ctb.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Inside ->setattr() call both ATTR_UID and ATTR_GID may be valid
This means that we may end-up with transferring all quotas. Add
we have to reserve QUOTA_DEL_BLOCKS for all quotas, as we do in
case of QUOTA_INIT_BLOCKS.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b166e90..428336a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5440,7 +5440,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 		/* (user+group)*(old+new) structure, inode write (sb,
 		 * inode block, ? - but truncate inode update has it) */
 		handle = ext4_journal_start(inode, (EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
-					EXT4_QUOTA_DEL_BLOCKS(inode->i_sb))+3);
+					EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3);
 		if (IS_ERR(handle)) {
 			error = PTR_ERR(handle);
 			goto err_out;
-- 
1.6.0.4

