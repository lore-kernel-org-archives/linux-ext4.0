From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4:fix invariant checking in
	ext4_rebalance_reservation
Date: Mon, 18 Jun 2007 14:09:39 -0700
Message-ID: <1182200979.3711.6.camel@dyn9047017103.beaverton.ibm.com>
References: <20070614072352.GA6517@localhost.sw.ru>
	 <4672202C.4080304@clusterfs.com>
	 <1181949368.3808.7.camel@dyn9047017103.beaverton.ibm.com>
	 <20070616080200.GA14349@localhost.sw.ru>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org
To: Dmitriy Monakhov <dmonakhov@sw.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:42397 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759098AbXFRVJn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jun 2007 17:09:43 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5IL9fHi004025
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jun 2007 17:09:42 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5IL9fvE199172
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jun 2007 15:09:41 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5IL9f3e007795
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jun 2007 15:09:41 -0600
In-Reply-To: <20070616080200.GA14349@localhost.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 2007-06-16 at 12:02 +0400, Dmitriy Monakhov wrote:
> Variable "free" was declarated as __u64 so conidition (free < 0) always
> false, even if free was overflowed during substraction.

Agreed. 

Can you add your Signed-off to this patch? I can add mine after yours.

Thanks,
Mingming
> ---
>  fs/ext4/balloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 43ae8f8..a9655f1 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -1909,8 +1909,8 @@ void ext4_rebalance_reservation(struct ext4_reservation_slot *rs, __u64 free)
>  			chunk = free;
>  		if (rs[i].rs_reserved || i == smp_processor_id()) {
>  			rs[i].rs_reserved = chunk;
> +			BUG_ON(free < chunk);
>  			free -= chunk;
> -			BUG_ON(free < 0);
>  		}
>  	}
>  	BUG_ON(free);
