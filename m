From: Tao Ma <tm@tao.ma>
Subject: [PATCH V4 22/22] ext4: Enable ext4 inline support.
Date: Mon, 20 Feb 2012 15:01:56 +0800
Message-ID: <1329721316-4955-22-git-send-email-tm@tao.ma>
References: <4F41EF95.2000909@tao.ma>
 <1329721316-4955-1-git-send-email-tm@tao.ma>
Cc: linux-fsdevel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1329721316-4955-1-git-send-email-tm@tao.ma>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/ext4.h   |    3 ++-
 fs/ext4/ialloc.c |    4 ++++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 26024a3..9486cce 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1452,7 +1452,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 					 EXT4_FEATURE_INCOMPAT_EXTENTS| \
 					 EXT4_FEATURE_INCOMPAT_64BIT| \
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG| \
-					 EXT4_FEATURE_INCOMPAT_MMP)
+					 EXT4_FEATURE_INCOMPAT_MMP |	\
+					 EXT4_FEATURE_INCOMPAT_INLINEDATA)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 25d8c97..2401934 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -901,6 +901,10 @@ got:
 
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

