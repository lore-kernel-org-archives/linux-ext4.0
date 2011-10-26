From: Tao Ma <tm@tao.ma>
Subject: [PATCH V1 17/17] ext4: Enable ext4 inline support.
Date: Wed, 26 Oct 2011 15:34:28 +0800
Message-ID: <1319614468-11227-17-git-send-email-tm@tao.ma>
References: <4EA7B788.3040503@tao.ma>
 <1319614468-11227-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1319614468-11227-1-git-send-email-tm@tao.ma>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/ext4.h   |    1 +
 fs/ext4/ialloc.c |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 4319c95..3e5644b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1377,6 +1377,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
 #define EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400 /* EA in inode */
 #define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000 /* data in dirent */
+#define EXT4_FEATURE_INCOMPAT_INLINEDATA	0x2000 /* data in inode */
 
 #define EXT2_FEATURE_COMPAT_SUPP	EXT4_FEATURE_COMPAT_EXT_ATTR
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 9c63f27..4e9cd2f 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1033,6 +1033,10 @@ got:
 
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
