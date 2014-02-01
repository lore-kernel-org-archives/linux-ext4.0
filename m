From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1] ext3: Add __init macro to init_inodecache
Date: Sat, 1 Feb 2014 19:13:00 +0800
Message-ID: <20140201191300.bf1332562e81082e8d7cfa53@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

init_inodecache is only called by __init init_ext3_fs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext3/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 37fd31e..94608d4 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -527,7 +527,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	ext3_inode_cachep = kmem_cache_create("ext3_inode_cache",
 					     sizeof(struct ext3_inode_info),
-- 
1.8.1.4
