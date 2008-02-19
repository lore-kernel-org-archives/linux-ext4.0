From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] clear extents flag on inodes created in ext4_mknod
Date: Tue, 19 Feb 2008 10:39:52 -0600
Message-ID: <47BB0658.90204@redhat.com>
References: <47B9F1F1.30604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbYBSQjy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Feb 2008 11:39:54 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m1JGdrqQ028346
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 11:39:53 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1JGdrYp021118
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 11:39:53 -0500
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1JGdq57017759
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 11:39:53 -0500
In-Reply-To: <47B9F1F1.30604@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
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

now that I think about it; perhaps it would be better to put this logic
into ext4_new_inode, rather than setting it by default and clearing it
here... that way new_inode() has all the logic about whether or not a
particular type of file is in extents format.

Think it's worth changing?

-Eric
