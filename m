From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext3: issue warning when bad inode found via ext3_lookup
Date: Fri, 14 Dec 2007 11:41:37 -0600
Message-ID: <4762C051.1070609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbXLNRlm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Dec 2007 12:41:42 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have a hand-crafted bad filesystem image which has corruption:

[root@inode ~]# ls mnt/dir
file1  file2  file3  file4  file5
[root@inode ~]# ls mnt/dir/file4 
ls: cannot access mnt/dir/file4: No such file or directory
[root@inode ~]# ls -l mnt/dir
ls: cannot access mnt/dir/file4: No such file or directory
total 8
drwxr-xr-x 2 root root 1024 2007-09-04 13:36 file1
drwxr-xr-x 2 root root 1024 2007-09-04 13:36 file2
drwxr-xr-x 2 root root 1024 2007-09-04 13:36 file3
d????????? ? ?    ?       ?                ? file4
drwxr-xr-x 2 root root 1024 2007-09-04 13:36 file5

e2fsck also knows it's corrupted:
Pass 2: Checking directory structure
Entry 'file4' in /dir (2049) has deleted/unused inode 13.  Clear? no

Entry 'file4' in /dir (2049) has an incorrect filetype (was 2, should be 1).
Fix? no

Pass 3: Checking directory connectivity
Unconnected directory inode 2053 (/dir/???)

BUT there are no kernel messages logged anywhere because ext3_read_inode
silently makes a bad_inode in this case, so that stale NFS filehandles
aren't noisy.  However, when we encounter such a problem after a by-name
lookup, I think a warning is appropriate, as it indicates filesystem
corruption.

Signed-off-by: Eric Sandeen <sandeen@redhat.com
---

Index: linux-2.6.24-rc3/fs/ext3/namei.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/ext3/namei.c
+++ linux-2.6.24-rc3/fs/ext3/namei.c
@@ -1049,6 +1049,9 @@ static struct dentry *ext3_lookup(struct
 			return ERR_PTR(-EACCES);
 
 		if (is_bad_inode(inode)) {
+			ext3_warning(inode->i_sb, __FUNCTION__,
+				     "bad inode %lu in dir #%lu",
+				      inode->i_ino, dir->i_ino);
 			iput(inode);
 			return ERR_PTR(-ENOENT);
