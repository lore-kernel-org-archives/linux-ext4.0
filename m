From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3 v2] ext4: let us fully support punching hole feature
 in fallocate
Date: Tue, 20 Nov 2012 14:35:05 +0800
Message-ID: <20121120063505.GA11117@yanx>
References: <1353329718-2075-1-git-send-email-wenqing.lz@taobao.com>
 <1353329718-2075-3-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:49119 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab2KTGfW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Nov 2012 01:35:22 -0500
Received: from /spool/local
	by e28smtp05.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <yan@linux.vnet.ibm.com>;
	Tue, 20 Nov 2012 12:05:20 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id qAK6ZHkG55771332
	for <linux-ext4@vger.kernel.org>; Tue, 20 Nov 2012 12:05:18 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id qAK6ZHt5005596
	for <linux-ext4@vger.kernel.org>; Tue, 20 Nov 2012 17:35:17 +1100
Content-Disposition: inline
In-Reply-To: <1353329718-2075-3-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, Zheng:

On Mon, Nov 19, 2012 at 08:55:17PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> After adding indirect punching hole feature, we need to enable it in fallocate.
> For this purpose, some sanity checks need to be adjusted.  Currently we need to
> check FALLOC_FL_PUNCH_HOLE flag before other sanity checks.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  fs/ext4/extents.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 7011ac9..b43b3e9 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4420,13 +4420,6 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  	struct ext4_map_blocks map;
>  	unsigned int credits, blkbits = inode->i_blkbits;
> 
> -	/*
> -	 * currently supporting (pre)allocate mode for extent-based
> -	 * files _only_
> -	 */
> -	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
> -		return -EOPNOTSUPP;
> -
>  	/* Return error if mode is not supported */
>  	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
>  		return -EOPNOTSUPP;

Checking these mode flags seems redundant here, VFS already checked them.
Maybe you can remove it by the way.

Regards,
Guo Chao

