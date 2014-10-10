From: Jan Kara <jack@suse.cz>
Subject: [PATCH] vfs: Allocate anon_inode_inode in
	anon_inode_init()
Date: Fri, 10 Oct 2014 16:23:38 +0200
Message-ID: <1412951028-4085-34-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
        tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>,
        Dave Chinner <david@fromorbit.com>, reiserfs-devel@vger.kernel.org,
        xfs@oss.sgi.com, cluster-devel@redhat.com, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        viro@zeniv.linux.org.uk
To: linux-fsdevel@vger.kernel.org
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

Currently we allocated anon_inode_inode in anon_inodefs_mount. This is
somewhat fragile as if that function ever gets called again, it will
overwrite anon_inode_inode pointer. So move the initialization of
anon_inode_inode to anon_inode_init().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/anon_inodes.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 4b4543b8b894..7f34f7702204 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -41,19 +41,8 @@ static const struct dentry_operations anon_inodefs_dentry_operations = {
 static struct dentry *anon_inodefs_mount(struct file_system_type *fs_type,
 				int flags, const char *dev_name, void *data)
 {
-	struct dentry *root;
-	root = mount_pseudo(fs_type, "anon_inode:", NULL,
+	return mount_pseudo(fs_type, "anon_inode:", NULL,
 			&anon_inodefs_dentry_operations, ANON_INODE_FS_MAGIC);
-	if (!IS_ERR(root)) {
-		struct super_block *s = root->d_sb;
-		anon_inode_inode = alloc_anon_inode(s);
-		if (IS_ERR(anon_inode_inode)) {
-			dput(root);
-			deactivate_locked_super(s);
-			root = ERR_CAST(anon_inode_inode);
-		}
-	}
-	return root;
 }
 
 static struct file_system_type anon_inode_fs_type = {
@@ -180,12 +169,15 @@ static int __init anon_inode_init(void)
 	anon_inode_mnt = kern_mount(&anon_inode_fs_type);
 	if (IS_ERR(anon_inode_mnt)) {
 		error = PTR_ERR(anon_inode_mnt);
-		goto err_unregister_filesystem;
+		goto err_exit;
+	}
+	anon_inode_inode = alloc_anon_inode(anon_inode_mnt->mnt_sb);
+	if (IS_ERR(anon_inode_inode)) {
+		error = PTR_ERR(anon_inode_inode);
+		goto err_exit;
 	}
 	return 0;
 
-err_unregister_filesystem:
-	unregister_filesystem(&anon_inode_fs_type);
 err_exit:
 	panic(KERN_ERR "anon_inode_init() failed (%d)\n", error);
 }
-- 
1.8.1.4
