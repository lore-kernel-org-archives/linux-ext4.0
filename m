From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: [PATCH] Fix oops in mballoc caused by a variable overflow
Date: Thu, 17 Jan 2008 10:43:40 +0100
Message-ID: <478F234C.90807@bull.net>
References: <1200510717.4561.11.camel@ext1.frec.bull.fr> <1200509307.3985.8.camel@localhost.localdomain> <20080117064736.GA6749@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:60913 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbYAQJmT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jan 2008 04:42:19 -0500
In-Reply-To: <20080117064736.GA6749@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> What about this  ? I guess we will overflow 
> start = start << bsbits;
> 

Hi Aneesh,
your patch below doesn't fix the issue, because as start_off is also 
loff_t, start_off = ac->ac_o_ex.fe_logical << bsbits  also overflows.

> I guess start should be of type loff_t. Patch below
> 
> -aneesh
> 
> ext4: Fix overflow in ext4_mb_normalize_request
> 
> From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> kernel BUG at fs/ext4/mballoc.c:3148!
> 
> The BUG_ON is:
> BUG_ON(size <= 0 || size >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
> 
> where the value of "size" is 4293920768.
> 
> This is due to the overflow of the variable "start" in the
> ext4_mb_normalize_request() function.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
> 
>  fs/ext4/mballoc.c |   21 ++++++++-------------
>  1 files changed, 8 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index d8cd81e..d8a2db8 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2998,7 +2998,7 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
>  	int bsbits, max;
>  	ext4_lblk_t end;
>  	struct list_head *cur;
> -	loff_t size, orig_size;
> +	loff_t size, orig_size, start_off;
>  	ext4_lblk_t start, orig_start;
>  	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
>  
> @@ -3039,7 +3039,7 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
>  
>  	/* first, try to predict filesize */
>  	/* XXX: should this table be tunable? */
> -	start = 0;
> +	start_off = 0;
>  	if (size <= 16 * 1024) {
>  		size = 16 * 1024;
>  	} else if (size <= 32 * 1024) {
> @@ -3055,26 +3055,21 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
>  	} else if (size <= 1024 * 1024) {
>  		size = 1024 * 1024;
>  	} else if (NRL_CHECK_SIZE(size, 4 * 1024 * 1024, max, bsbits)) {
> -		start = ac->ac_o_ex.fe_logical << bsbits;
> -		start = (start / (1024 * 1024)) * (1024 * 1024);
> +		start_off = (ac->ac_o_ex.fe_logical >> (20 - bsbits)) << 20;
>  		size = 1024 * 1024;
>  	} else if (NRL_CHECK_SIZE(size, 8 * 1024 * 1024, max, bsbits)) {
> -		start = ac->ac_o_ex.fe_logical << bsbits;
> -		start = (start / (4 * (1024 * 1024))) * 4 * (1024 * 1024);
> +		start_off = (ac->ac_o_ex.fe_logical >> (22 - bsbits)) << 22;
>  		size = 4 * 1024 * 1024;
>  	} else if (NRL_CHECK_SIZE(ac->ac_o_ex.fe_len,
>  					(8<<20)>>bsbits, max, bsbits)) {
> -		start = ac->ac_o_ex.fe_logical;
> -		start = start << bsbits;
> -		start = (start / (8 * (1024 * 1024))) * 8 * (1024 * 1024);
> +		start_off = (ac->ac_o_ex.fe_logical >> (23 - bsbits)) << 23;
>  		size = 8 * 1024 * 1024;
>  	} else {
> -		start = ac->ac_o_ex.fe_logical;
> -		start = start << bsbits;
> -		size = ac->ac_o_ex.fe_len << bsbits;
> +		start_off = ac->ac_o_ex.fe_logical << bsbits;
> +		size	  = ac->ac_o_ex.fe_len << bsbits;
>  	}
>  	orig_size = size = size >> bsbits;
> -	orig_start = start = start >> bsbits;
> +	orig_start = start = start_off >> bsbits;
>  
>  	/* don't cover already allocated blocks in selected range */
>  	if (ar->pleft && start <= ar->lleft) {
> 
