From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 08/32] ext4: fix ref counting for ea_inode
Date: Wed, 21 Jun 2017 14:21:18 -0700
Message-ID: <20170621212142.16581-8-tahsin@google.com>
References: <20170621212142.16581-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:36592 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752563AbdFUVWB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jun 2017 17:22:01 -0400
Received: by mail-pf0-f174.google.com with SMTP id q86so6617641pfl.3
        for <linux-ext4@vger.kernel.org>; Wed, 21 Jun 2017 14:22:00 -0700 (PDT)
In-Reply-To: <20170621212142.16581-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ref count on ea_inode is incremented by
ext4_xattr_inode_orphan_add() which is supposed to be decremented by
ext4_xattr_inode_array_free(). The decrement is conditioned on whether
the ea_inode is currently on the orphan list. However, the orphan list
addition only happens when journaling is enabled. In non-journaled case,r
we fail to release the ref count causing an error message like below.

"VFS: Busy inodes after unmount of sdb. Self-destruct in 5 seconds.
Have a nice day..."

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/xattr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 32ad2f2870e9..13daf634244b 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2098,8 +2098,7 @@ ext4_xattr_inode_array_free(struct inode *inode,
 		if (err)
 			continue;
 		/* for inode's i_count get from ext4_xattr_delete_inode */
-		if (!list_empty(&EXT4_I(ea_inode)->i_orphan))
-			iput(ea_inode);
+		iput(ea_inode);
 		clear_nlink(ea_inode);
 		iput(ea_inode);
 	}
-- 
2.13.1.611.g7e3b11ae1-goog
