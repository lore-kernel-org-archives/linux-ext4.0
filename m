From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] Fix oops in mballoc caused by a variable overflow
Date: Wed, 16 Jan 2008 10:48:27 -0800
Message-ID: <1200509307.3985.8.camel@localhost.localdomain>
References: <1200510717.4561.11.camel@ext1.frec.bull.fr>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47446 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbYAPSsW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Jan 2008 13:48:22 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0GImL2f002537
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jan 2008 13:48:21 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0GImLPL290454
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jan 2008 13:48:21 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0GImLJL017460
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jan 2008 13:48:21 -0500
In-Reply-To: <1200510717.4561.11.camel@ext1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-01-16 at 20:11 +0100, Valerie Clement wrote:
> A simple dd oopses the kernel (2.6.24-rc7 with the latest patch queue):
>   dd if=/dev/zero of=/mnt/test/foo bs=1M count=8096
> 
> EXT4-fs: mballoc enabled
> ------------[ cut here ]------------
> kernel BUG at fs/ext4/mballoc.c:3148!
> 
> The BUG_ON is:
> 	BUG_ON(size <= 0 || size >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
> 
> where the value of "size" is 4293920768.
> 
> This is due to the overflow of the variable "start" in the 
> ext4_mb_normalize_request() function.
> The patch below fixes it.
> 
Thanks!

> Signed-off-by: Valerie Clement <valerie.clement@bull.net>
> ---
> 
>  mballoc.c |   23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> 
> Index: linux-2.6.24-rc7/fs/ext4/mballoc.c
> ===================================================================
> --- linux-2.6.24-rc7.orig/fs/ext4/mballoc.c	2008-01-16 19:22:45.000000000 +0100
> +++ linux-2.6.24-rc7/fs/ext4/mballoc.c	2008-01-16 19:25:04.000000000 +0100
> @@ -2990,6 +2990,7 @@ static void ext4_mb_normalize_request(st
>  	struct list_head *cur;
>  	loff_t size, orig_size;
>  	ext4_lblk_t start, orig_start;
> +	ext4_fsblk_t pstart;

ext4_fsblk_t is used for fs physical block number, here I think pstart
is pointing to some logical block location..

>  	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
> 
>  	/* do normalize only data requests, metadata requests
> @@ -3029,7 +3030,7 @@ static void ext4_mb_normalize_request(st
> 
>  	/* first, try to predict filesize */
>  	/* XXX: should this table be tunable? */
> -	start = 0;
> +	pstart = 0;
>  	if (size <= 16 * 1024) {
>  		size = 16 * 1024;
>  	} else if (size <= 32 * 1024) {
> @@ -3045,25 +3046,25 @@ static void ext4_mb_normalize_request(st
>  	} else if (size <= 1024 * 1024) {
>  		size = 1024 * 1024;
>  	} else if (NRL_CHECK_SIZE(size, 4 * 1024 * 1024, max, bsbits)) {
> -		start = ac->ac_o_ex.fe_logical << bsbits;
> -		start = (start / (1024 * 1024)) * (1024 * 1024);
> +		pstart = ac->ac_o_ex.fe_logical << bsbits;
> +		pstart = (pstart / (1024 * 1024)) * (1024 * 1024);

How about using shift...

-		start = ac->ac_o_ex.fe_logical << bsbits;
-		start = (start / (1024 * 1024)) * (1024 * 1024);
+		start = (ac->ac_o_ex.fe_logical >> (20-bsbits)) << 20;

That would be more efficient and should fix the overflow issue

>  		size = 1024 * 1024;
>  	} else if (NRL_CHECK_SIZE(size, 8 * 1024 * 1024, max, bsbits)) {
> -		start = ac->ac_o_ex.fe_logical << bsbits;
> -		start = (start / (4 * (1024 * 1024))) * 4 * (1024 * 1024);
> +		pstart = ac->ac_o_ex.fe_logical << bsbits;
> +		pstart = (pstart / (4 * (1024 * 1024))) * 4 * (1024 * 1024);

+		start = (ac->ac_o_ex.fe_logical >> (22-bsbits)) << 22;

>  		size = 4 * 1024 * 1024;
>  	} else if(NRL_CHECK_SIZE(ac->ac_o_ex.fe_len,(8<<20)>>bsbits,max,bsbits)){
> -		start = ac->ac_o_ex.fe_logical;
> -		start = start << bsbits;
> -		start = (start / (8 * (1024 * 1024))) * 8 * (1024 * 1024);
> +		pstart = ac->ac_o_ex.fe_logical;
> +		pstart = pstart << bsbits;
> +		pstart = (pstart / (8 * (1024 * 1024))) * 8 * (1024 * 1024);

+		start = (ac->ac_o_ex.fe_logical >> (23-bsbits)) << 23;

>  		size = 8 * 1024 * 1024;
>  	} else {
> -		start = ac->ac_o_ex.fe_logical;
> -		start = start << bsbits;
> +		pstart = ac->ac_o_ex.fe_logical;
> +		pstart = pstart << bsbits;
>  		size = ac->ac_o_ex.fe_len << bsbits;
>  	}
>  	orig_size = size = size >> bsbits;
> -	orig_start = start = start >> bsbits;
> +	orig_start = start = pstart >> bsbits;
> 
>  	/* don't cover already allocated blocks in selected range */
>  	if (ar->pleft && start <= ar->lleft) {
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
