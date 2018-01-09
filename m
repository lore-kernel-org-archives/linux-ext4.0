From: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v5 07/19] exofs: switch to new i_version API
Date: Tue,  9 Jan 2018 09:10:47 -0500
Message-ID: <20180109141059.25929-8-jlayton@kernel.org>
References: <20180109141059.25929-1-jlayton@kernel.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
        linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org,
        jack-l3A5Bk7waGM@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org,
        adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org,
        linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, jbacik-b10kYP2dOMg@public.gmane.org,
        dsterba-IBi9RG/b67k@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
        linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        jaltman-hRzEac23uH1Wk0Htik3J/w@public.gmane.org, krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180109141059.25929-1-jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/exofs/dir.c   | 9 +++++----
 fs/exofs/super.c | 3 ++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/exofs/dir.c b/fs/exofs/dir.c
index 98233a97b7b8..c5a53fcc43ea 100644
--- a/fs/exofs/dir.c
+++ b/fs/exofs/dir.c
@@ -31,6 +31,7 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <linux/iversion.h>
 #include "exofs.h"
 
 static inline unsigned exofs_chunk_size(struct inode *inode)
@@ -60,7 +61,7 @@ static int exofs_commit_chunk(struct page *page, loff_t pos, unsigned len)
 	struct inode *dir = mapping->host;
 	int err = 0;
 
-	dir->i_version++;
+	inode_inc_iversion(dir);
 
 	if (!PageUptodate(page))
 		SetPageUptodate(page);
@@ -241,7 +242,7 @@ exofs_readdir(struct file *file, struct dir_context *ctx)
 	unsigned long n = pos >> PAGE_SHIFT;
 	unsigned long npages = dir_pages(inode);
 	unsigned chunk_mask = ~(exofs_chunk_size(inode)-1);
-	int need_revalidate = (file->f_version != inode->i_version);
+	bool need_revalidate = inode_cmp_iversion(inode, file->f_version);
 
 	if (pos > inode->i_size - EXOFS_DIR_REC_LEN(1))
 		return 0;
@@ -264,8 +265,8 @@ exofs_readdir(struct file *file, struct dir_context *ctx)
 								chunk_mask);
 				ctx->pos = (n<<PAGE_SHIFT) + offset;
 			}
-			file->f_version = inode->i_version;
-			need_revalidate = 0;
+			file->f_version = inode_query_iversion(inode);
+			need_revalidate = false;
 		}
 		de = (struct exofs_dir_entry *)(kaddr + offset);
 		limit = kaddr + exofs_last_byte(inode, n) -
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 819624cfc8da..7e244093c0e5 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -38,6 +38,7 @@
 #include <linux/module.h>
 #include <linux/exportfs.h>
 #include <linux/slab.h>
+#include <linux/iversion.h>
 
 #include "exofs.h"
 
@@ -159,7 +160,7 @@ static struct inode *exofs_alloc_inode(struct super_block *sb)
 	if (!oi)
 		return NULL;
 
-	oi->vfs_inode.i_version = 1;
+	inode_set_iversion(&oi->vfs_inode, 1);
 	return &oi->vfs_inode;
 }
 
-- 
2.14.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
