From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: don't load the block bitmap for block groups which
 have no space
Date: Mon, 13 Aug 2012 11:02:08 -0500
Message-ID: <50292500.1070807@redhat.com>
References: <20120809181059.A5BAA11FC69@bugzilla.kernel.org> <1344622885-14982-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab2HMQCL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Aug 2012 12:02:11 -0400
In-Reply-To: <1344622885-14982-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/10/12 1:21 PM, Theodore Ts'o wrote:
> Add a short circuit check to ext4_mb_group_group() so that we don't
> bother to load the block bitmap for a block group which does not have
> any space available.  (Or which does not have enough space until we
> are in desperation mode, i.e., when cr == 3.)
> 
> Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=45741
> Reported-by: mirek@me.com
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Looks ok to me; I think this just further optimizes what was done
in

8a57d9d61a6e361c7bb159dda797672c1df1a691
ext4: check for a good block group before loading buddy pages

correct?

-Eric

> ---
>  fs/ext4/mballoc.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 8eae947..3a57975 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1862,6 +1862,12 @@ static int ext4_mb_good_group(struct ext4_allocation_context *ac,
>  
>  	BUG_ON(cr < 0 || cr >= 4);
>  
> +	free = grp->bb_free;
> +	if (free == 0)
> +		return 0;
> +	if (cr <= 2 && free < ac->ac_g_ex.fe_len)
> +		return 0;
> +
>  	/* We only do this if the grp has never been initialized */
>  	if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
>  		int ret = ext4_mb_init_group(ac->ac_sb, group);
> @@ -1869,10 +1875,7 @@ static int ext4_mb_good_group(struct ext4_allocation_context *ac,
>  			return 0;
>  	}
>  
> -	free = grp->bb_free;
>  	fragments = grp->bb_fragments;
> -	if (free == 0)
> -		return 0;
>  	if (fragments == 0)
>  		return 0;
>  
> 

