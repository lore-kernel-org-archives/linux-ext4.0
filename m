From: Tao Ma <tm@tao.ma>
Subject: [PATCH V5 01/23] ext4: Move extra inode read to a new function.
Date: Sat, 30 Jun 2012 23:45:02 +0800
Message-ID: <1341071124-4976-1-git-send-email-tm@tao.ma>
References: <1341070917-4889-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:58806 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751155Ab2F3Prn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jun 2012 11:47:43 -0400
Received: from [221.217.40.18] (port=40170 helo=localhost.localdomain)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1Skztd-0006eg-Ac
	for linux-ext4@vger.kernel.org; Sat, 30 Jun 2012 09:47:42 -0600
In-Reply-To: <1341070917-4889-1-git-send-email-tm@tao.ma>
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
index 02bc8cb..21793ea 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3687,6 +3687,16 @@ static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
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
@@ -3829,11 +3839,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
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
1.7.0.4

