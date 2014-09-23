From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext4: Fix mmap data corruption when blocksize < pagesize
Date: Tue, 23 Sep 2014 17:03:23 +0200
Message-ID: <1411484603-17756-3-git-send-email-jack@suse.cz>
References: <1411484603-17756-1-git-send-email-jack@suse.cz>
Cc: linux-mm@kvack.org,
	Dave Chinner <david@fromorbit.com>,
	linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1411484603-17756-1-git-send-email-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Use block_create_hole() when hole is being created in a file so that
->page_mkwrite() will get called for the partial tail page if it is
mmaped (see the first patch in the series for details).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3aa26e9117c4..fdcb007c2c9e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4536,8 +4536,12 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 				ext4_orphan_del(NULL, inode);
 				goto err_out;
 			}
-		} else
+		} else {
+			loff_t old_size = inode->i_size;
+
 			i_size_write(inode, attr->ia_size);
+			block_create_hole(inode, old_size, inode->i_size);
+		}
 
 		/*
 		 * Blocks are going to be removed from the inode. Wait
-- 
1.8.1.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
