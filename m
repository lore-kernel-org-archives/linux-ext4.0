From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] mark buffer_head mapping preallocate area as new
	during write_begin with delayed allocation
Date: Tue, 28 Apr 2009 09:50:49 +0530
Message-ID: <20090428042049.GA6520@skywalker>
References: <1240859143-31122-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1240873494.6775.8.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:35004 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbZD1EVN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 00:21:13 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp07.au.ibm.com (8.13.1/8.13.1) with ESMTP id n3S4L8FF006726
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 14:21:08 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3S4L6tV426252
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 14:21:08 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3S4L5kY024730
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 14:21:05 +1000
Content-Disposition: inline
In-Reply-To: <1240873494.6775.8.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 27, 2009 at 04:04:54PM -0700, Mingming Cao wrote:
.....

> 
> Index: linux-2.6.28-rc6/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.28-rc6.orig/fs/ext4/inode.c	2009-03-12 10:21:05.000000000 -0700
> +++ linux-2.6.28-rc6/fs/ext4/inode.c	2009-04-27 14:35:21.000000000 -0700
> @@ -2177,7 +2177,10 @@ static int ext4_da_get_block_prep(struct
>  		set_buffer_new(bh_result);
>  		set_buffer_delay(bh_result);
>  	} else if (ret > 0) {
> +		if (buffer_unwritten(bh_result))
> +			set_buffer_new(bh_result);
>  		bh_result->b_size = (ret << inode->i_blkbits);
> +		bh_result->b_bdev = inode->i_sb->s_bdev;


Updated patch to set bh_result->b_dev. I also added comments in the
source to explain whey we need to mark buffer_head new. Also updated
single line patch summary. I will send the update (-v2) patch.

-aneesh
