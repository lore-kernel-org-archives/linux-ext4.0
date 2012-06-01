From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Save and restore state flags in
 EXT4_IOC_SETFLAGS.
Date: Thu, 31 May 2012 23:48:20 -0400
Message-ID: <20120601034820.GC7897@thunk.org>
References: <1336145869-4120-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, stable <stable@vger.kernel.org>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46883 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758873Ab2FADsZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 May 2012 23:48:25 -0400
Content-Disposition: inline
In-Reply-To: <1336145869-4120-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 04, 2012 at 11:37:49PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In commit 353eb83c we removes i_state_flags with 64-bit longs,
> But in case we call EXT4_IOC_SETFLAGS, we fail to save the
> high 32-bit state flags and only stores the low 32-bit back
> to ei->i_flags. So the state flags are missing now in 64-bit
> long architecture.

The problem with this approach is that we are still editing i_flags
and then replacing it with the new value.  So we're vulnerable to
races where some other process is modifies the i_state_flags between
when we sample it using ext4_save_state_flags() and when we restore
them.

This is a better way to fix the problem, and what I plan to commit
into the ext4 tree:

commit 79906964a187c405db72a3abc60eb9b50d804fbc
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu May 31 23:46:01 2012 -0400

    ext4: don't trash state flags in EXT4_IOC_SETFLAGS
    
    In commit 353eb83c we removed i_state_flags with 64-bit longs, But
    when handling the EXT4_IOC_SETFLAGS ioctl, we replace i_flags
    directly, which trashes the state flags which are stored in the high
    32-bits of i_flags on 64-bit platforms.  So use the the
    ext4_{set,clear}_inode_flags() functions which use atomic bit
    manipulation functions instead.
    
    Reported-by: Tao Ma <boyu.mt@taobao.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Cc: stable@kernel.org

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index feba55a..8ad112a 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -38,7 +38,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		handle_t *handle = NULL;
 		int err, migrate = 0;
 		struct ext4_iloc iloc;
-		unsigned int oldflags;
+		unsigned int oldflags, mask, i;
 		unsigned int jflag;
 
 		if (!inode_owner_or_capable(inode))
@@ -115,8 +115,14 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (err)
 			goto flags_err;
 
-		flags = flags & EXT4_FL_USER_MODIFIABLE;
-		flags |= oldflags & ~EXT4_FL_USER_MODIFIABLE;
+		for (i = 0, mask = 1; i < 32; i++, mask <<= 1) {
+			if (!(mask & EXT4_FL_USER_MODIFIABLE))
+				continue;
+			if (mask & flags)
+				ext4_set_inode_flag(inode, i);
+			else
+				ext4_clear_inode_flag(inode, i);
+		}
 		ei->i_flags = flags;
 
 		ext4_set_inode_flags(inode);


