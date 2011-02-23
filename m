From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29752] New: Possible i_nlink race in ext2_rename
Date: Wed, 23 Feb 2011 17:10:38 GMT
Message-ID: <bug-29752-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:52525 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab1BWRKj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Feb 2011 12:10:39 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p1NHAcOM007846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 23 Feb 2011 17:10:38 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29752

           Summary: Possible i_nlink race in ext2_rename
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.37
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext2
        AssignedTo: fs_ext2@kernel-bugs.osdl.org
        ReportedBy: joshhunt00@gmail.com
        Regression: No


I believe I have identified a possible race condition in ext2_rename when
modifying i_nlink. I sent the following mail to linux-ext4 and linux-fsdevel on
Feb 22, 2011.

<email>
We have a multi-threaded workload which is currently "losing" files in the form
of unattached inodes. The workload is link, rename, unlink intensive. This is
happening on an ext2 filesystem and have reproduced the issue in kernel
2.6.37.  Here's a sample strace:

   open("/a/tmp/tmpfile.1296184058", O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE,
0666) = 9
   link("/a/tmp/tmpfile.1296184058", "/a/tmp/tmpfile.28117.1296184059") = 0
   rename("/a/tmp/tmpfile.28117.1296184059", "/a/tmp/tmpfile") = 0
   stat64("/a/tmp/tmpfile", {st_mode=S_IFREG|0644, st_size=24248267, ...}) = 0
   link("/a/tmp/tmpfile", "/a/tmp/submit/tmpfile")        = 0
   open("/a/tmp/tmpfile.1296184058", O_RDONLY) = 13
   open("/a/tmp/submit/tmpfile.send.q9SNoL", O_RDWR|O_CREAT|O_EXCL, 0600) = 824
   rename("/a/tmp/submit/tmpfile", "/a/tmp/submit/tmpfile.send.q9SNoL")        
       = 0
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

ext2_rename modifies old_inode's nlink values through
inode_inc_link_count(old_inode) and inode_dec_link_count(old_inode) without
holding old_inode's mutex. vfs_rename_other() only takes the mutex of the new
inode and directory and old inode's directory. This causes old inode's nlink
values to become incorrect and results in an unattached inode.

CC: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 fs/ext2/namei.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 2e1d834..827839a 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -321,6 +321,8 @@ static int ext2_rename (struct inode * old_dir, struct
dentry * old_dentry,
       dquot_initialize(old_dir);
       dquot_initialize(new_dir);

+       mutex_lock(&old_inode->i_mutex);
+
       old_de = ext2_find_entry (old_dir, &old_dentry->d_name, &old_page);
       if (!old_de)
               goto out;
@@ -375,6 +377,7 @@ static int ext2_rename (struct inode * old_dir, struct
dentry * old_dentry,

       ext2_delete_entry (old_de, old_page);
       inode_dec_link_count(old_inode);
+       mutex_unlock(&old_inode->i_mutex);

       if (dir_de) {
               if (old_dir != new_dir)
@@ -397,6 +400,7 @@ out_old:
       kunmap(old_page);
       page_cache_release(old_page);
 out:
+       mutex_unlock(&old_inode->i_mutex);
       return err;
 }

--
1.7.0.4
</email>

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
