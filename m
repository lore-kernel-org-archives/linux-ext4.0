From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 3/3] ext4: Use direct_IO_no_locking in ext4 dio read.
Date: Sun, 17 Jan 2010 19:49:12 +0530
Message-ID: <871vho3jbz.fsf@linux.vnet.ibm.com>
References: <1263583812-21355-1-git-send-email-tytso@mit.edu>
	<1263583812-21355-4-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Jiaying Zhang <jiayingz@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57267 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab0AQOTV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Jan 2010 09:19:21 -0500
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [202.81.31.246])
	by e23smtp02.au.ibm.com (8.14.3/8.13.1) with ESMTP id o0HEGNbo016332
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jan 2010 01:16:23 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o0HEEhKZ1196100
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jan 2010 01:14:43 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o0HEJI49020194
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jan 2010 01:19:19 +1100
In-Reply-To: <1263583812-21355-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 15 Jan 2010 14:30:12 -0500, "Theodore Ts'o" <tytso@mit.edu> wrote:
> Signed-off-by: Jiaying Zhang <jiayingz@google.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/inode.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)



This need a commit message explaining why we can use
direct_IO_no_locking now. 



> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 1f56484..ec0bbdd 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3419,7 +3419,14 @@ static ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
>  	}
> 
>  retry:
> -	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
> +	if (rw == READ && ext4_should_dioread_nolock(inode))
> +		ret = blockdev_direct_IO_no_locking(rw, iocb, inode,
> +				 inode->i_sb->s_bdev, iov,
> +				 offset, nr_segs,
> +				 ext4_get_block, NULL);
> +	else
> +		ret = blockdev_direct_IO(rw, iocb, inode,
> +				 inode->i_sb->s_bdev, iov,
>  				 offset, nr_segs,
>  				 ext4_get_block, NULL);
>  	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> -- 
> 1.6.5.216.g5288a.dirty


-aneesh
