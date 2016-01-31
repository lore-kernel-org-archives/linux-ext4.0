From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH] ext4: drop unneeded BUFFER_TRACE in ext4_delete_inline_entry()
Date: Sun, 31 Jan 2016 23:51:54 +0800
Message-ID: <cf471e3cb545a084fc3f05ee6166b96f523153c3.1454255445.git.geliangtang@163.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

BUFFER_TRACE info "call ext4_handle_dirty_metadata" doesn't match the
code, so drop it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 fs/ext4/inline.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index dfe3b9b..cbcb907 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1696,7 +1696,6 @@ int ext4_delete_inline_entry(handle_t *handle,
 	if (err)
 		goto out;
 
-	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
 	err = ext4_mark_inode_dirty(handle, dir);
 	if (unlikely(err))
 		goto out;
-- 
2.5.0
