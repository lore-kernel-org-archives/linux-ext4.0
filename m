From: Djalal Harouni <tixxdz@opendz.org>
Subject: Re: [PATCH] fs/ext{3,4}: fix potential race when setversion ioctl
 updates inode
Date: Fri, 6 Jan 2012 02:00:11 +0100
Message-ID: <20120106010011.GA9028@dztty>
References: <20120103013152.GA26455@dztty>
 <20120104174609.GD28907@quack.suse.cz>
 <6C16105A-D0EE-413E-B993-F223CFC75307@dilger.ca>
 <20120104233254.GH28907@quack.suse.cz>
 <20120105003751.GA4010@dztty>
 <20120105114205.GB14947@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from numidia.opendz.org ([98.142.220.152]:40301 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758394Ab2AFA5I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jan 2012 19:57:08 -0500
Content-Disposition: inline
In-Reply-To: <20120105114205.GB14947@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 05, 2012 at 12:42:05PM +0100, Jan Kara wrote:
> On Thu 05-01-12 01:40:09, Djalal Harouni wrote:
> > Only the reiserfs and ext{2,3,4} filesystems support this ioctl. The reiserfs
> > do not use mutexes at all, even in the REISERFS_IOC_SETFLAGS ioctl which will
> > test and set _all_ the possible values of the i_flags field.
> > Perhaps I should also send a patch for this ?
>   Yes, possibly reiserfs should use i_mutex for that ioctl.
For the reiserfs I've missed some locks.

It seems that reiserfs uses its own 'reiserfs_sb_info->lock' (reiserfs
super block data) to serialize writers in all the ioctl, even the GET
(readers) ioctl operations. But I also know that the VFS layer uses i_mutex
to protect inode changes, so ? I'm not sure, If I can test it I'll send a
patch.

> > And perhaps ext2 should also be updated.
>   Sure. Send a patch my way when you have it.
Here's the tested ext2 patch, thanks.

--------

From: Djalal Harouni <tixxdz@opendz.org>

ext2: protect inode changes in the SETVERSION and SETFLAGS ioctls

Unlock mutex after i_flags and i_ctime updates in the EXT2_IOC_SETFLAGS
ioctl.

Use i_mutex in the EXT2_IOC_SETVERSION ioctl to protect i_ctime and
i_generation updates and make the ioctl consistent since i_mutex is
also used in other places to protect timestamps and inode changes.

Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/ext2/ioctl.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/ext2/ioctl.c b/fs/ext2/ioctl.c
index f81e250..b7f931f 100644
--- a/fs/ext2/ioctl.c
+++ b/fs/ext2/ioctl.c
@@ -77,10 +77,11 @@ long ext2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		flags = flags & EXT2_FL_USER_MODIFIABLE;
 		flags |= oldflags & ~EXT2_FL_USER_MODIFIABLE;
 		ei->i_flags = flags;
-		mutex_unlock(&inode->i_mutex);
 
 		ext2_set_inode_flags(inode);
 		inode->i_ctime = CURRENT_TIME_SEC;
+		mutex_unlock(&inode->i_mutex);
+
 		mark_inode_dirty(inode);
 setflags_out:
 		mnt_drop_write(filp->f_path.mnt);
@@ -88,20 +89,29 @@ setflags_out:
 	}
 	case EXT2_IOC_GETVERSION:
 		return put_user(inode->i_generation, (int __user *) arg);
-	case EXT2_IOC_SETVERSION:
+	case EXT2_IOC_SETVERSION: {
+		__u32 generation;
+
 		if (!inode_owner_or_capable(inode))
 			return -EPERM;
 		ret = mnt_want_write(filp->f_path.mnt);
 		if (ret)
 			return ret;
-		if (get_user(inode->i_generation, (int __user *) arg)) {
+		if (get_user(generation, (int __user *) arg)) {
 			ret = -EFAULT;
-		} else {
-			inode->i_ctime = CURRENT_TIME_SEC;
-			mark_inode_dirty(inode);
+			goto setversion_out;
 		}
+
+		mutex_lock(&inode->i_mutex);
+		inode->i_ctime = CURRENT_TIME_SEC;
+		inode->i_generation = generation;
+		mutex_unlock(&inode->i_mutex);
+
+		mark_inode_dirty(inode);
+setversion_out:
 		mnt_drop_write(filp->f_path.mnt);
 		return ret;
+	}
 	case EXT2_IOC_GETRSVSZ:
 		if (test_opt(inode->i_sb, RESERVATION)
 			&& S_ISREG(inode->i_mode)
-- 
1.7.1
