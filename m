From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 2/3] ext4: let us fully support punching hole feature in fallocate
Date: Thu, 23 Aug 2012 12:25:40 +0800
Message-ID: <1345695941-15053-3-git-send-email-wenqing.lz@taobao.com>
References: <1345695941-15053-1-git-send-email-wenqing.lz@taobao.com>
Cc: Lukas Czerner <lczerner@redhat.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1345695941-15053-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zheng Liu <wenqing.lz@taobao.com>

After supporing punching hole feature in block-based file, we should enable it
in fallocate.  So some check statements need to adjust.  Now we check
FALLOC_FL_PUNCH_HOLE flag firstly in ext4_fallocate.

CC: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/extents.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ad9e7e3..c592921 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4358,20 +4358,21 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	struct ext4_map_blocks map;
 	unsigned int credits, blkbits = inode->i_blkbits;
 
-	/*
-	 * currently supporting (pre)allocate mode for extent-based
-	 * files _only_
-	 */
-	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
-		return -EOPNOTSUPP;
-
 	/* Return error if mode is not supported */
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
 		return -EOPNOTSUPP;
 
+	/* We fully support punch hole */
 	if (mode & FALLOC_FL_PUNCH_HOLE)
 		return ext4_punch_hole(file, offset, len);
 
+	/*
+	 * currently supporting (pre)allocate mode for extent-based
+	 * files _only_
+	 */
+	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
+		return -EOPNOTSUPP;
+
 	trace_ext4_fallocate_enter(inode, offset, len, mode);
 	map.m_lblk = offset >> blkbits;
 	/*
-- 
1.7.4.1

