From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Patches for the patchqueue
Date: Thu, 05 Jun 2008 11:02:40 -0700
Message-ID: <1212688960.3613.10.camel@localhost.localdomain>
References: <20080605095032.GE8942@skywalker>
	 <20080605095158.GF8942@skywalker> <20080605095350.GG8942@skywalker>
	 <20080605095510.GH8942@skywalker>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35122 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbYFESDw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Jun 2008 14:03:52 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m55I3pf6009799
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 14:03:51 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m55I2s4M1368286
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 14:02:55 -0400
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m55I2pv4014164
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 12:02:53 -0600
In-Reply-To: <20080605095510.GH8942@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-06-05 at 15:25 +0530, Aneesh Kumar K.V wrote:
> f) clear the delay bit in ext4_da_get_block_write instead of
> __block_write_full_page
> so that we clear the delay bit for every successfull block allocation.
> We may fail
> while marking inode dirty in ext4_da_get_block_write after allocating
> block. So
> it is better to clear the delay bit in ext4_da_get_block_write rather
> than
> __block_write_full_page
> 

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---

> @@ -1555,7 +1565,15 @@ static int ext4_da_get_block_write(struct inode
> *inode, sector_t iblock,
>                 bh_result->b_size = (ret << inode->i_blkbits);
> 
>                 /* release reserved-but-unused meta blocks */
> -               ext4_da_release_space(inode, ret, 0);
> +               if (buffer_delay(bh_result)) {
> +                       ext4_da_release_space(inode, ret, 0);
> +                       /*
> +                        * clear the delay bit now that we allocated
> +                        * blocks. If it is not a single block request
> +                        * we clear the delay bit in
> mpage_put_bnr_to_bhs
> +                        */
> +                       clear_buffer_delay(bh_result);
> +               }
> 
>                 /*
>                  * Update on-disk size along with block allocation

It seems with this fix, the buffer_delay bit is still cleared before the
ext4_mark_inode_dirty() could return error? Actually the already
allocated blocks are leaked if mark_inode-dirty() returns error, and we
cleared the buffer_delay for the buffer needs block.

Mingming

