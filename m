From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Take 2] ext2/3/4 block bitmap validation patches
Date: Mon, 19 Nov 2007 21:15:24 +0530
Message-ID: <4741AF94.8010704@linux.vnet.ibm.com>
References: <1195484161-14472-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:54712 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753992AbXKSPp0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2007 10:45:26 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id lAJFjNqY027768
	for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2007 21:15:23 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.6) with ESMTP id lAJFjNYp2572294
	for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2007 21:15:23 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id lAJFjMmw031591
	for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2007 15:45:23 GMT
In-Reply-To: <1195484161-14472-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Aneesh Kumar K.V wrote:
> This is the updated ext2/3/4 block bitmap validation patches
> 
> Changes from the last post
> 
> a) moved the bh_uptodate_or_lock and bh_submit_read to
>   fs/buffer.c and added EXPORT_SYMBOL
> 
> b) Updated bh_submit_read not to release buffer on
>    failure. This handles one reference handling bug in the
>    error patch.
> 
>

I forgot to pass --numbered to git format-patch
The order is 


[PATCH 1/4] Add buffer head related helper functions
[PATCH 2/4] ext2: add block bitmap validation
[PATCH 3/4] ext3: add block bitmap validation
[PATCH 4/4] ext4: add block bitmap validation


it is against patch queue and applies as the last set of
patches in the stable series

....

buffer_head_helper.patch
ext2_bitmap_validation.patch
ext3_bitmap_validation.patch
ext4_bitmap_validation.patch
stable-boundary


-aneesh
