From: Andreas Dilger <adilger@sun.com>
Subject: Re: strange ext{3,4}_settattr logic
Date: Sun, 16 Mar 2008 07:05:44 +0800
Message-ID: <20080315230544.GV3542@webber.adilger.int>
References: <20080315160731.GA4186@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Dmitri Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:35800 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbYCOXGQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Mar 2008 19:06:16 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2FN6FwV008975
	for <linux-ext4@vger.kernel.org>; Sat, 15 Mar 2008 16:06:15 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JXS00001O54S700@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 15 Mar 2008 16:06:15 -0700 (PDT)
In-reply-to: <20080315160731.GA4186@dmon-lap.sw.ru>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 15, 2008  19:07 +0300, Dmitri Monakhov wrote:
> I've found what ext3_setattr() code has some strange logic. I'm talking
> about truncate path. 
> 
> int ext3_setattr(struct dentry *dentry, struct iattr *attr)
> {
> ...
> 	if (S_ISREG(inode->i_mode) &&
>             attr->ia_valid & ATTR_SIZE && attr->ia_size < inode->i_size) {
>                 handle_t *handle;
> <<< This is shrinking case, and according to function comments:
> <<< "In particular, we want to make sure that when the VFS
> <<< * shrinks i_size, we put the inode on the orphan list and modify
> <<< * i_disksize immediately"
> <<< we about to write i_disksize. But WHY do we have to do it explicitly?
> <<< Later inode_setattr() will call ext3_truncate() which will do it
> <<< this work for us.

The reason that i_disksize is written to disk here immediately is that the
journal is stopped.  Once that is done then in case of a crash the orphan
recovery code will detect the unfinished truncate and complete it before
mounting the filesystem.

Without this it is possible to get a partial truncate after a crash because
the truncate may span several transactions due to the potentially large
number of blocks that need to be modified.  What is important with ext3
is that because e2fsck is not run on each boot whatever is on disk needs
to be consistent after a crash.

If there is a file being truncated or unlinked that needs to be completed
after a crash or the blocks will be leaked.  To ensure this happens, there
is a singly-linked list of inodes on the disk called the "orphan list"
that keeps track of all inodes currently undergoing truncate or unlink.
After a crash the kernel or e2fsck will walk this list and finish the
truncate or unlink of the inode, freeing the blocks.

>         rc = inode_setattr(inode, attr);
> <<< Now the most interesting question. What we have to do now in 
> <<< case of error? We are in tricky situation. Truncate not happened,
> <<< and blocks visible to the user, but i_disksize was already written,
> <<< so later memory reclaiming/ read_inode will result in unexpected
> <<< updating i_size.

The only ways inode_setattr() can fail are:
- expanding vmtruncate hits EFBIG, but we checked that above
- shrinking vmtruncate on a swapfile returns ETXTBUSY.  This was added
  after the ext3_setattr() code was written.

If the ext3_truncate() or mark_inode_dirty() call fails, it does not
return an error code.  For ext3 the only way this can fail is if the
journal is aborted, which means the filesystem is already in read-only
mode and nothing can be done to clean up the truncate until the next
mount, at which point the orphan recovery code discussed above will
finish the operation.

>         /* If inode_setattr's call to ext3_truncate failed to get a
>          * transaction handle at all, we need to clean up the in-core
>          * orphan list manually. */
> <<< Following code will remove inode only from in memory(because handle = NULL)
> <<< orphan list. Please someone explain me what this lines suppose to do
> <<< actually.
>         if (inode->i_nlink)
>                 ext3_orphan_del(NULL, inode);

This will only be important in the case of a failed operation above.
The ext3_truncate() code will normally have already removed the inode
from the orphan list when it is finished, but we aren't sure whether
that code was called so we need to do it again here (it is safe to call
even if the inode is not on the list) to ensure we don't hit a J_ASSERT()
that the orphan list is empty in the unmount code (ext3_put_super()).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

