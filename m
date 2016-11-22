From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4/001: Fixup file layout with DAX
Date: Tue, 22 Nov 2016 11:16:35 +0100
Message-ID: <1479809795-4787-1-git-send-email-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Since commit 9538d1b69399 (ext4: avoid split extents for DAX writes),
currently sitting in ext4 tree, the block layout of files has changed
when the filesystem is mounted with -o dax and now matches 'nodelalloc'
variant instead of 'nozero'. Fixup the test configuration.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 tests/ext4/001.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/ext4/001.cfg b/tests/ext4/001.cfg
index 5f7e26213e85..7c928811212f 100644
--- a/tests/ext4/001.cfg
+++ b/tests/ext4/001.cfg
@@ -1,4 +1,4 @@
-dax: nozero
+dax: nodelalloc
 dioread_nolock: nozero
 nodelalloc: nodelalloc
 data=journal: nodelalloc
-- 
2.6.6
