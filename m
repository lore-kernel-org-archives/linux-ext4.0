From: Lachlan McIlroy <lmcilroy@redhat.com>
Subject: Re: [PATCH] ext4: limit group search loop for non-extent files
Date: Sun, 5 May 2013 20:26:35 -0400 (EDT)
Message-ID: <2128465386.19191575.1367799995911.JavaMail.root@redhat.com>
References: <5184230E.6020500@redhat.com>
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:35529 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab3EFA0g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 May 2013 20:26:36 -0400
In-Reply-To: <5184230E.6020500@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

----- Original Message -----
> From: Lachlan McIlroy <lmcilroy@redhat.com>
> 
> In the case where we are allocating for a non-extent file,
> we must limit the groups we allocate from to those below
> 2^32 blocks, and ext4_mb_regular_allocator() attempts to
> do this initially by putting a cap on ngroups for the
> subsequent search loop.
> 
> However, the initial target group comes in from the
> allocation context (ac), and it may already be beyond
> the artificially limited ngroups.  In this case,
> the limit
> 
> 	if (group == ngroups)
> 		group = 0;
> 
> at the top of the loop is never true, and the loop will
> run away.
> 
> Catch this case inside the loop and reset the search to
> start at group 0.
> 
> [sandeen@redhat.com: add commit msg & comments]
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> p.s. I suppose this limit could go after the assignment
> from ac->ac_g_ex.fe_group, depending on your sense
> of style...
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index ee6614b..f54baee 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1994,7 +1994,11 @@ repeat:
>  		group = ac->ac_g_ex.fe_group;
>  
>  		for (i = 0; i < ngroups; group++, i++) {
> -			if (group == ngroups)
> +			/*
> +			 * Artificially restricted ngroups for non-extent
> +			 * files makes group > ngroups possible on first loop.
> +			 */
> +			if (group >= ngroups)
>  				group = 0;
>  
>  			/* This now checks without needing the buddy page */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Thanks for following through with this Eric.  Looks good to me.
