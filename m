From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] resize2fs vs. large inodes, take 2
Date: Mon, 03 Mar 2008 15:05:52 -0700
Message-ID: <20080303220552.GS3616@webber.adilger.int>
References: <47CC622F.8030900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:45067 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbYCCWGH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Mar 2008 17:06:07 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m23M66Uj009731
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2008 14:06:06 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JX600D01D7KB700@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 03 Mar 2008 14:06:06 -0800 (PST)
In-reply-to: <47CC622F.8030900@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 03, 2008  14:40 -0600, Eric Sandeen wrote:
> large inodes with both fast symlinks and in-inode selinux attrs
> were not surviving moves via resize2fs.
> 
> Somehow I missed that there was an ext2fs_get_next_inode_full... 
> I think the below fix is correct, on top of my previous patch
> (and what is in e2fsprogs-1.40.7...)
> 
> ------------------- changelog ----------------------
> 
> Use ext2fs_get_next_inode_full() in resize2fs; previous attempt
> was not properly handling all cases, and was incorrectly setting
> i_extra_isize.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Index: e2fsprogs-1.40.7/resize/resize2fs.c
> ===================================================================
> --- e2fsprogs-1.40.7.orig/resize/resize2fs.c
> +++ e2fsprogs-1.40.7/resize/resize2fs.c
> @@ -1168,11 +1168,12 @@ static errcode_t inode_scan_and_fix(ext2
>  	 * elsewhere in the inode table
>  	 */
>  	while (1) {
> -		retval = ext2fs_get_next_inode(scan, &ino, &inode);
> +		retval = ext2fs_get_next_inode_full(scan, &ino, buf, inode_size);
>  		if (retval) goto errout;
>  		if (!ino)
>  			break;
>  
> +		memcpy(&inode, buf, sizeof(struct ext2_inode));

Should this be using "sizeof(struct ext2_inode)" or should it be using
"sb->s_inode_size" instead (extracted from the right struct of course)?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

