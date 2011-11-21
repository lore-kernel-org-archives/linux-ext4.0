From: Tao Ma <tm@tao.ma>
Subject: [PATCH V2 01/19] ext4: Move extra inode read to a new function.
Date: Tue, 22 Nov 2011 00:39:39 +0800
Message-ID: <1321893597-11024-1-git-send-email-tm@tao.ma>
References: <4ECA7DB3.9040605@tao.ma>
Cc: tytso@mit.edu, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:33527 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752007Ab1KUQmQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Nov 2011 11:42:16 -0500
In-Reply-To: <4ECA7DB3.9040605@tao.ma>
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
 fs/ext4/inode.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 240f6e2..15d0460 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3761,6 +3761,16 @@ static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
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
@@ -3871,13 +3881,8 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 			/* The extra space is currently unused. Use it. */
 			ei->i_extra_isize = sizeof(struct ext4_inode) -
 					    EXT4_GOOD_OLD_INODE_SIZE;
-		} else {
-			__le32 *magic = (void *)raw_inode +
-					EXT4_GOOD_OLD_INODE_SIZE +
-					ei->i_extra_isize;
-			if (*magic == cpu_to_le32(EXT4_XATTR_MAGIC))
-				ext4_set_inode_state(inode, EXT4_STATE_XATTR);
-		}
+		} else
+			ext4_iget_extra_inode(inode, raw_inode, ei);
 	} else
 		ei->i_extra_isize = 0;
 
-- 
1.7.0.4

