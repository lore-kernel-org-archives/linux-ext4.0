From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH] Copy i_flags to ext3 inode flags on write (version 2)
Date: Tue, 24 Apr 2007 10:14:37 -0500
Message-ID: <1177427677.15516.21.camel@kleikamp.austin.ibm.com>
References: <20070417103855.GB11815@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: akpm@osdl.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41761 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161806AbXDXPPE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Apr 2007 11:15:04 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3OFF1e1017956
	for <linux-ext4@vger.kernel.org>; Tue, 24 Apr 2007 11:15:01 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3OFF0k3354188
	for <linux-ext4@vger.kernel.org>; Tue, 24 Apr 2007 11:15:00 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3OFEcKF025601
	for <linux-ext4@vger.kernel.org>; Tue, 24 Apr 2007 11:14:38 -0400
In-Reply-To: <20070417103855.GB11815@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-04-17 at 12:38 +0200, Jan Kara wrote:
>   Hi,
> 
>   attached is a second version of a patch that stores inode flags such as
> S_IMMUTABLE, S_APPEND, etc. from i_flags to EXT3_I(inode)->i_flags when
> inode is written to disk. The same thing is done on GETFLAGS ioctl.
>   Quota code changes these flags on quota files (to make it harder for
> sysadmin to screw himself) and these changes were not correctly
> propagated into the filesystem (especially, lsattr did not show them and
> users were wondering...). Andrew, could you please put the patch into your
> queue? Thanks.

I think you need a call to ext3_get_inode_flags in one more place.  In
ext3_ioctl(), EXT3_IOC_SETFLAGS modifies the flags based on what is in
ei->i_flags, so this code should make sure that ei->i_flags is in sync
with inode->i_flags.

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

diff -Nurp linux-orig/fs/ext3/ioctl.c linux/fs/ext3/ioctl.c
--- linux-orig/fs/ext3/ioctl.c	2007-04-24 10:04:50.000000000 -0500
+++ linux/fs/ext3/ioctl.c	2007-04-24 10:05:59.000000000 -0500
@@ -51,6 +51,7 @@ int ext3_ioctl (struct inode * inode, st
 			flags &= ~EXT3_DIRSYNC_FL;
 
 		mutex_lock(&inode->i_mutex);
+		ext3_get_inode_flags(ei);
 		oldflags = ei->i_flags;
 
 		/* The JOURNAL_DATA flag is modifiable only by root */

-- 
David Kleikamp
IBM Linux Technology Center
