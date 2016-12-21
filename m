From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 08/30] orangefs: remove initialization of i_version
Date: Wed, 21 Dec 2016 12:03:25 -0500
Message-ID: <1482339827-7882-9-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-xfs@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

...as it's completely unused.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/orangefs/super.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/orangefs/super.c b/fs/orangefs/super.c
index c48859f16e7b..58ad9875eafc 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -85,8 +85,6 @@ static void orangefs_inode_cache_ctor(void *req)
 
 	inode_init_once(&orangefs_inode->vfs_inode);
 	init_rwsem(&orangefs_inode->xattr_sem);
-
-	orangefs_inode->vfs_inode.i_version = 1;
 }
 
 static struct inode *orangefs_alloc_inode(struct super_block *sb)
-- 
2.7.4
