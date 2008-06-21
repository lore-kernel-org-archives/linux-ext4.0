From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] delalloc: Add block reservation estimate for
	non-extent files
Date: Sat, 21 Jun 2008 15:55:20 +0530
Message-ID: <20080621102520.GA9584@skywalker>
References: <1214010691.27507.223.camel@BVR-FS.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:56943 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753017AbYFUKZw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Jun 2008 06:25:52 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id m5LAPnws027554
	for <linux-ext4@vger.kernel.org>; Sat, 21 Jun 2008 15:55:49 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5LAOquk421976
	for <linux-ext4@vger.kernel.org>; Sat, 21 Jun 2008 15:54:52 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m5LAPmVH000617
	for <linux-ext4@vger.kernel.org>; Sat, 21 Jun 2008 15:55:49 +0530
Content-Disposition: inline
In-Reply-To: <1214010691.27507.223.camel@BVR-FS.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 20, 2008 at 06:11:31PM -0700, Mingming wrote:
> Add support for full delayed allocation over ext3 format file.
> 
> This patch added a function to estimate the number of indirect blocks need
> to reserve for non-extent based (ext3) file, in order to properly
> reserve the need amount of indirect blocks for delayed allocation.
> 
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> ---
>  fs/ext4/inode.c |   34 ++++++++++++++++++++++++++++++++--
>  1 file changed, 32 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.26-rc6/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.26-rc6.orig/fs/ext4/inode.c	2008-06-20 16:50:09.000000000 -0700
> +++ linux-2.6.26-rc6/fs/ext4/inode.c	2008-06-20 17:36:08.000000000 -0700
> @@ -1426,6 +1426,36 @@ static int ext4_journalled_write_end(str
> 
>  	return ret ? ret : copied;
>  }
> +/*
> + * Calculate the number of metadata blocks need to reserve
> + * to allocate @blocks for non extent file based file
> + */
> +static int ext4_indirect_calc_metadata_amount(struct inode *inode, int blocks)
> +{
> +	int icap = EXT4_ADDR_PER_BLOCK(inode->i_sb);
> +	int ind_blks, dind_blks, tind_blks;
> +
> +	/* number of new indirect blocks needed */
> +	ind_blks = (blocks + icap - 1) / icap;
> +
> +	dind_blks = (ind_blks + icap - 1) / icap;
> +
> +	tind_blks = 1;
> +
> +	return ind_blks + dind_blks + tind_blks;
> +}
> +

With block mapped files using logical block number we should be able to
find out the exact number of meta-data blocks we would need. I am not sure
whether we need to be that complex is calculating the same.

-aneesh
