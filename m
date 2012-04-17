From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC][PATCH 3/3] ext4: add FALLOC_FL_NO_HIDE_STALE support
Date: Wed, 18 Apr 2012 00:53:38 +0800
Message-ID: <1334681618-9452-4-git-send-email-wenqing.lz@taobao.com>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zheng Liu <wenqing.lz@taobao.com>

When FALLOC_FL_NO_HIDE_STALE flag is marked, we create an initialized
extent directly.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/extents.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 1421938..efb5150 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4291,7 +4291,7 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -EOPNOTSUPP;
 
 	/* Return error if mode is not supported */
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+	if (mode & ~FALLOC_FL_SUPPORTED_FLAGS)
 		return -EOPNOTSUPP;
 
 	if (mode & FALLOC_FL_PUNCH_HOLE)
@@ -4316,7 +4316,10 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		trace_ext4_fallocate_exit(inode, offset, max_blocks, ret);
 		return ret;
 	}
-	flags = EXT4_GET_BLOCKS_CREATE_UNINIT_EXT;
+	if (mode & FALLOC_FL_NO_HIDE_STALE)
+		flags = EXT4_GET_BLOCKS_CREATE;
+	else
+		flags = EXT4_GET_BLOCKS_CREATE_UNINIT_EXT;
 	if (mode & FALLOC_FL_KEEP_SIZE)
 		flags |= EXT4_GET_BLOCKS_KEEP_SIZE;
 	/*
-- 
1.7.4.1
