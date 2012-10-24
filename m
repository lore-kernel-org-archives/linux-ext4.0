From: Tao Ma <tm@tao.ma>
Subject: [PATCH V7 23/23] ext4: Enable ext4 inline support.
Date: Wed, 24 Oct 2012 10:55:38 +0800
Message-ID: <1351047338-4963-23-git-send-email-tm@tao.ma>
References: <1351047002-4723-1-git-send-email-tm@tao.ma>
 <1351047338-4963-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:49738 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934056Ab2JXDEI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Oct 2012 23:04:08 -0400
Received: from [182.92.247.2] (port=23186 helo=tma-laptop1.taobao.ali.com)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1TQr8f-0006KI-Cy
	for linux-ext4@vger.kernel.org; Tue, 23 Oct 2012 20:56:13 -0600
In-Reply-To: <1351047338-4963-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/ext4.h   |    3 ++-
 fs/ext4/ialloc.c |    4 ++++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 5863136..f0a5ea7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1512,7 +1512,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 					 EXT4_FEATURE_INCOMPAT_EXTENTS| \
 					 EXT4_FEATURE_INCOMPAT_64BIT| \
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG| \
-					 EXT4_FEATURE_INCOMPAT_MMP)
+					 EXT4_FEATURE_INCOMPAT_MMP |	\
+					 EXT4_FEATURE_INCOMPAT_INLINE_DATA)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 4facdd2..dfe7679 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -903,6 +903,10 @@ got:
 
 	ei->i_extra_isize = EXT4_SB(sb)->s_want_extra_isize;
 
+	ei->i_inline_off = 0;
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_INLINE_DATA))
+		ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+
 	ret = inode;
 	dquot_initialize(inode);
 	err = dquot_alloc_inode(inode);
-- 
1.7.1

