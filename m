From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] clear extents flag on inodes created in ext4_mknod
Date: Mon, 18 Feb 2008 21:22:42 -0800
Message-ID: <1203398562.3612.3.camel@localhost.localdomain>
References: <47B9F1F1.30604@redhat.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56815 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbYBSFWr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Feb 2008 00:22:47 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1J5Mjv8031840
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 00:22:45 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1J5Mj2q311188
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 00:22:45 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1J5Mijf021167
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 00:22:44 -0500
In-Reply-To: <47B9F1F1.30604@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Acked and added to the patch queue.
On Mon, 2008-02-18 at 15:00 -0600, Eric Sandeen wrote:
> e2fsck doesn't expect to find char, block, fifo, or socket
> files with the extent flag set, so clear that in ext4_mknod.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Index: linux-2.6.24/fs/ext4/namei.c
> ===================================================================
> --- linux-2.6.24.orig/fs/ext4/namei.c
> +++ linux-2.6.24/fs/ext4/namei.c
> @@ -1766,6 +1766,7 @@ retry:
>  #ifdef CONFIG_EXT4DEV_FS_XATTR
>  		inode->i_op = &ext4_special_inode_operations;
>  #endif
> +		EXT4_I(inode)->i_flags &= ~EXT4_EXTENTS_FL;
>  		err = ext4_add_nondir(handle, dentry, inode);
>  	}
>  	ext4_journal_stop(handle);
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
