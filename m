From: Josh Hunt <johunt@akamai.com>
Subject: [RFC][PATCH] ext2: Resolve i_nlink race in ext2_rename
Date: Tue, 22 Feb 2011 15:42:18 -0800
Message-ID: <1298418138-28797-1-git-send-email-johunt@akamai.com>
Cc: sandeen@redhat.com, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We have a multi-threaded workload which is currently "losing" files in the form
of unattached inodes. The workload is link, rename, unlink intensive. This is
happening on an ext2 filesystem and have reproduced the issue in kernel
2.6.37.  Here's a sample strace:

    open("/a/tmp/tmpfile.1296184058", O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE, 0666) = 9
    link("/a/tmp/tmpfile.1296184058", "/a/tmp/tmpfile.28117.1296184059") = 0
    rename("/a/tmp/tmpfile.28117.1296184059", "/a/tmp/tmpfile") = 0
    stat64("/a/tmp/tmpfile", {st_mode=S_IFREG|0644, st_size=24248267, ...}) = 0
    link("/a/tmp/tmpfile", "/a/tmp/submit/tmpfile")        = 0
    open("/a/tmp/tmpfile.1296184058", O_RDONLY) = 13
    open("/a/tmp/submit/tmpfile.send.q9SNoL", O_RDWR|O_CREAT|O_EXCL, 0600) = 824
    rename("/a/tmp/submit/tmpfile", "/a/tmp/submit/tmpfile.send.q9SNoL")                = 0
    unlink("/a/tmp/tmpfile.1296184058") = 0
    open("/a/tmp/submit/tmpfile.send.q9SNoL", O_RDONLY) = 827
    open("/a/tmp/submit/tmpfile.send.q9SNoL", O_RDONLY) = 828
    open("/a/tmp/submit/tmpfile.send.q9SNoL", O_RDONLY) = 829
    unlink("/a/tmp/submit/tmpfile.send.q9SNoL") = 0

The application behavior shown above repeats indefinitely with most filenames
changing during each iteration except for 'tmpfile'. Looking into this issue I
see that vfs_rename_other() only takes i_mutex for the new inode and the new
inode's directory as well as the old directory's mutex. This works for
modifying the dir entry and appears to be fine for most filesystems, but
ext2 and a few others (exofs, minix, nilfs2, omfs, sysv, ufs) modify i_nlink
inside of their respective rename functions without grabbing the i_mutex. The
modifications are done through calls to inode_inc_link_count(old_inode) and
inode_dec_link_count(old_inode), etc.

Taking the mutex for the old inode appears to resolve the issue of the
lost files/unattached inodes that I am seeing with this workload. I've attached
a patch below doing what I've described above. If this is an accepted solution
I believe other filesystems may also be affected by this and I could provide
a patch for those as well.

Thanks
Josh

ext2_rename modifies old_inode's nlink values through inode_inc_link_count(old_inode) and inode_dec_link_count(old_inode) without holding old_inode's mutex. vfs_rename_other() only takes the mutex of the new inode and directory and old inode's directory. This causes old inode's nlink values to become incorrect and results in an unattached inode.

CC: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 fs/ext2/namei.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 2e1d834..827839a 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -321,6 +321,8 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 	dquot_initialize(old_dir);
 	dquot_initialize(new_dir);
 
+	mutex_lock(&old_inode->i_mutex);
+
 	old_de = ext2_find_entry (old_dir, &old_dentry->d_name, &old_page);
 	if (!old_de)
 		goto out;
@@ -375,6 +377,7 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 
 	ext2_delete_entry (old_de, old_page);
 	inode_dec_link_count(old_inode);
+	mutex_unlock(&old_inode->i_mutex);
 
 	if (dir_de) {
 		if (old_dir != new_dir)
@@ -397,6 +400,7 @@ out_old:
 	kunmap(old_page);
 	page_cache_release(old_page);
 out:
+	mutex_unlock(&old_inode->i_mutex);
 	return err;
 }
 
-- 
1.7.0.4
