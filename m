From: Tao Ma <tm@tao.ma>
Subject: [PATCH V2 19/19] ext4: Enable ext4 inline support.
Date: Tue, 22 Nov 2011 00:39:57 +0800
Message-ID: <1321893597-11024-19-git-send-email-tm@tao.ma>
References: <4ECA7DB3.9040605@tao.ma>
 <1321893597-11024-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:57376 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752046Ab1KURlE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Nov 2011 12:41:04 -0500
In-Reply-To: <1321893597-11024-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/ext4.h   |    1 +
 fs/ext4/ialloc.c |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index a88bc00..784893a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1414,6 +1414,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
 #define EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400 /* EA in inode */
 #define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000 /* data in dirent */
+#define EXT4_FEATURE_INCOMPAT_INLINEDATA	0x2000 /* data in inode */
 
 #define EXT2_FEATURE_COMPAT_SUPP	EXT4_FEATURE_COMPAT_EXT_ATTR
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 00beb4f..4f7fe21 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -897,6 +897,10 @@ got:
 
 	ei->i_extra_isize = EXT4_SB(sb)->s_want_extra_isize;
 
+	ei->i_inline_off = 0;
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_INLINEDATA))
+		ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+
 	ret = inode;
 	dquot_initialize(inode);
 	err = dquot_alloc_inode(inode);
-- 
1.7.0.4

