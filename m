From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: e2fsprogs and fast symlink
Date: Mon, 24 Mar 2008 17:07:47 +0530
Message-ID: <20080324113747.GA18042@skywalker>
References: <20080321114234.GB6542@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:52470 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757693AbYCXLiE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Mar 2008 07:38:04 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2OBbWUn026474
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 22:37:32 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2OBfkrM264444
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 22:41:46 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2OBbxuM021353
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 22:37:59 +1100
Content-Disposition: inline
In-Reply-To: <20080321114234.GB6542@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 21, 2008 at 05:12:34PM +0530, Aneesh Kumar K.V wrote:
> Hi Ted,
> 
> The below test case fails x86
> #ln -s sfdajsfsdsdfskjdgfkshdfkshdfkgdsjdsjdhsdfdafdsgakfasdgfsjksdsdsdfsd p 
> #sync
> #rm p
> root@elm3b165:~# /usr/local/e2fsprogs/sbin/e2fsck  -f  /dev/sda5
> e2fsck 1.40.8 (13-Mar-2008)
> Pass 1: Checking inodes, blocks, and sizes
> Fast symlink 12 has EXTENT_FL set.  Clear<y>? 
> 
> ie because after deleting the file we have
> debugfs:  stat <12>
> Inode: 12   Type: symlink    Mode:  0777   Flags: 0x80000   Generation:
> 25346603
> User:     0   Group:     0   Size: 0
> File ACL: 0    Directory ACL: 0
> Links: 0   Blockcount: 0
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x47e39ea3 -- Fri Mar 21 11:40:19 2008
> atime: 0x47e39e9e -- Fri Mar 21 11:40:14 2008
> mtime: 0x47e39e9a -- Fri Mar 21 11:40:10 2008
> dtime: 0x47e39ea3 -- Fri Mar 21 11:40:19 2008
> Size of extra inode fields: 28
> Fast_link_dest: 
> 
> 
> shouldn't e2fsprogs also look at whether the inode is in use ?

Or something like this in kernel ?

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 50d700f..cc124b1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -204,6 +204,14 @@ void ext4_delete_inode (struct inode * inode)
 	inode->i_size = 0;
 	if (inode->i_blocks)
 		ext4_truncate(inode);
+
+	/*
+	 * In case of link clear the extent flag. Fast symlinks are not
+	 * stored in extent format we use i_blocks count to determine
+	 * whether it is fast link or not.
+	 */
+	if (S_ISLNK(inode->i_mode))
+		 EXT4_I(inode)->i_flags &= ~EXT4_EXTENTS_FL;
 	/*
 	 * Kill off the orphan record which ext4_truncate created.
 	 * AKPM: I think this can be inside the above `if'.
