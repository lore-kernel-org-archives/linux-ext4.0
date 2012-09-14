From: Tao Ma <tm@tao.ma>
Subject: [PATCH V6 01/23] ext4: Move extra inode read to a new function.
Date: Fri, 14 Sep 2012 19:24:49 +0800
Message-ID: <1347621911-4104-1-git-send-email-tm@tao.ma>
References: <1347621512-3660-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:49809 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753034Ab2INLZV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Sep 2012 07:25:21 -0400
Received: from [182.92.247.2] (port=60014 helo=tma-laptop1.taobao.ali.com)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1TCU1P-0001sO-0J
	for linux-ext4@vger.kernel.org; Fri, 14 Sep 2012 05:25:19 -0600
In-Reply-To: <1347621512-3660-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Currently, in ext4_iget we do a simple check to see whether
there does exist some information starting from the end
of i_extra_size. With inline data added, this procedure
is more complicated. So move it to a new function named
ext4_iget_extra_inode.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/inode.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dff171c..bfaac61 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3773,6 +3773,16 @@ static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
 	}
 }
 
+static inline void ext4_iget_extra_inode(struct inode *inode,
+					 struct ext4_inode *raw_inode,
+					 struct ext4_inode_info *ei)
+{
+	__le32 *magic = (void *)raw_inode +
+			EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize;
+	if (*magic == cpu_to_le32(EXT4_XATTR_MAGIC))
+		ext4_set_inode_state(inode, EXT4_STATE_XATTR);
+}
+
 struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 {
 	struct ext4_iloc iloc;
@@ -3915,11 +3925,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 			ei->i_extra_isize = sizeof(struct ext4_inode) -
 					    EXT4_GOOD_OLD_INODE_SIZE;
 		} else {
-			__le32 *magic = (void *)raw_inode +
-					EXT4_GOOD_OLD_INODE_SIZE +
-					ei->i_extra_isize;
-			if (*magic == cpu_to_le32(EXT4_XATTR_MAGIC))
-				ext4_set_inode_state(inode, EXT4_STATE_XATTR);
+			ext4_iget_extra_inode(inode, raw_inode, ei);
 		}
 	}
 
-- 
1.7.1

