From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: Do not convert to indirect with bigalloc enabled
Date: Thu,  4 Apr 2013 12:18:05 +0200
Message-ID: <1365070685-5088-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757032Ab3DDKSL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Apr 2013 06:18:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With bigalloc feature enabled we do not support indirect addressing at all
so we have to prevent extent addressing to indirect addressing
conversion in this case. The problem has been introduced with the commit
"ext4: support simple conversion of extent-mapped inodes to use i_blocks"

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6c5a70a..ddb6628 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4735,6 +4735,10 @@ int ext4_ind_migrate(struct inode *inode)
 	    (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
 		return -EINVAL;
 
+	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+				       EXT4_FEATURE_RO_COMPAT_BIGALLOC))
+		return -EOPNOTSUPP;
+
 	down_write(&EXT4_I(inode)->i_data_sem);
 	ret = ext4_ext_check_inode(inode);
 	if (ret)
-- 
1.7.7.6

