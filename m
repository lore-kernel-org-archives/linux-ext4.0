From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1] ext4: Add __init macro to init_inodecache
Date: Sat, 1 Feb 2014 19:10:07 +0800
Message-ID: <20140201191007.59012c84446860984e6c4a76@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

init_inodecache is only called by __init init_ext4_fs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1f7784d..9a387b8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -940,7 +940,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	ext4_inode_cachep = kmem_cache_create("ext4_inode_cache",
 					     sizeof(struct ext4_inode_info),
-- 
1.8.1.4
