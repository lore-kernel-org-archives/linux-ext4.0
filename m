From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH, RFC] - issue warning when bad inode found via ext3_lookup
Date: Thu, 13 Dec 2007 14:03:19 -0600
Message-ID: <47619007.2070206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbXLMUDV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Dec 2007 15:03:21 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lBDK3KnJ010215
	for <linux-ext4@vger.kernel.org>; Thu, 13 Dec 2007 15:03:20 -0500
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lBDK3Kgt032556
	for <linux-ext4@vger.kernel.org>; Thu, 13 Dec 2007 15:03:20 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id lBDK3KqE015161
	for <linux-ext4@vger.kernel.org>; Thu, 13 Dec 2007 15:03:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have a hand-crafted bad filesystem image which has a corrupted directory
entry:

[root@inode ~]# ls mnt/Picture
LINKS_20  OBEN_20  VORNE_20  VORN_LINKS_20  VORN_RECHTS_20
[root@inode ~]# ls mnt/Picture/VORN_LINKS_20 
ls: cannot access mnt/Picture/VORN_LINKS_20: No such file or directory
[root@inode ~]# stat mnt/Picture/VORN_LINKS_20 
stat: cannot stat `mnt/Picture/VORN_LINKS_20': No such file or directory
[root@inode ~]# ls -l mnt/Picture
ls: cannot access mnt/Picture/VORN_LINKS_20: No such file or directory
total 8
drwxr-xr-x 2 root root 1024 2007-09-04 13:36 LINKS_20
drwxr-xr-x 2 root root 1024 2007-09-04 13:36 OBEN_20
drwxr-xr-x 2 root root 1024 2007-09-04 13:36 VORNE_20
d????????? ? ?    ?       ?                ? VORN_LINKS_20
drwxr-xr-x 2 root root 1024 2007-09-04 13:36 VORN_RECHTS_20

e2fsck also knows it's corrupted:
Pass 2: Checking directory structure
Entry 'VORN_LINKS_20' in /Picture (2049) has deleted/unused inode 13.  Clear? no

Entry 'VORN_LINKS_20' in /Picture (2049) has an incorrect filetype (was 2, should be 1).
Fix? no

Pass 3: Checking directory connectivity
Unconnected directory inode 2053 (/Picture/???)

BUT there are no kernel messages anywhere.

I think the below makes sense; I don't think there are any instances where an
inode found via a filename passed to ext3_lookup should be returning a bad inode
without warning; NFS may pass in a stale filehandle which also makes a bad inode, 
but that shouldn't go through lookup...

Comments?  (if it looks good I'll resubmit for ext*_lookup)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

Index: linux-2.6.24-rc3/fs/ext3/namei.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/ext3/namei.c
+++ linux-2.6.24-rc3/fs/ext3/namei.c
@@ -1049,6 +1049,10 @@ static struct dentry *ext3_lookup(struct
 			return ERR_PTR(-EACCES);
 
 		if (is_bad_inode(inode)) {
+			ext3_warning(inode->i_sb, __FUNCTION__,
+				   "bad inode %lu for file %s in dir #%lu",
+				   inode->i_ino, dentry->d_name.name,
+				   dir->i_ino);
 			iput(inode);
 			return ERR_PTR(-ENOENT);
 		}
