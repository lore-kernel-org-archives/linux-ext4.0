From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/2] sync up block & inode bitmap reading functions
Date: Sun, 20 Jul 2008 23:12:09 -0600
Message-ID: <20080721051209.GL3370@webber.adilger.int>
References: <4880F495.5050808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57827 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404AbYGUFMN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jul 2008 01:12:13 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m6L5CDgh026099
	for <linux-ext4@vger.kernel.org>; Sun, 20 Jul 2008 22:12:13 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K4C00F01BRE0L00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sun, 20 Jul 2008 22:12:13 -0700 (PDT)
In-reply-to: <4880F495.5050808@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 18, 2008  14:52 -0500, Eric Sandeen wrote:
> @@ -97,34 +97,41 @@ unsigned ext4_init_inode_bitmap(struct s
>  static struct buffer_head *
> -read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
> +ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
>  {
>  	struct ext4_group_desc *desc;
>  	struct buffer_head *bh = NULL;
> +	ext4_fsblk_t bitmap_blk;
>  
>  	desc = ext4_get_group_desc(sb, block_group, NULL);
>  	if (!desc)
> +		return NULL;

If you were feeling generous, you could change this function to take
gdp as a parameter (or post it as a kernel janitor task?), because
it is already available in most of the functions that call
read_{block,inode}_bitmap(), with the exception of ext4_orphan_get().

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

