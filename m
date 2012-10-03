From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] ext4: fix undefined bit shift result in
 ext4_fill_flex_info
Date: Wed, 3 Oct 2012 11:18:54 -0300
Message-ID: <20121003141854.GA5986@andromeda.usersys.redhat.com>
References: <1349248307-31225-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802Ab2JCOS6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Oct 2012 10:18:58 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q93EIwMt018574
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 3 Oct 2012 10:18:58 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-65.phx2.redhat.com [10.3.113.65])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q93EIsGT011329
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 3 Oct 2012 10:18:57 -0400
Content-Disposition: inline
In-Reply-To: <1349248307-31225-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 03, 2012 at 09:11:47AM +0200, Lukas Czerner wrote:
> The result of the bit shift expression in
> '1 << sbi->s_log_groups_per_flex' can be undefined in the case that
> s_log_groups_per_flex is 31 because the result of the shift is bigger
> than INT_MAX. In reality this probably should not cause much problems
> since we'll end up with INT_MIN which will then be converted into
> 'unsigned int' type, but nevertheless according to the ISO C99 the
> result is actually undefined.
> 
> Fix this by changing the left operand to 'unsigned int' type.
> 
> Note that the commit d50f2ab6f050311dbf7b8f5501b25f0bf64a439b already
> tried to fix the undefined behaviour, but this was missed.
> 
> Thanks to Laszlo Ersek for pointing this out and suggesting the fix.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reported-by: Laszlo Ersek <lersek@redhat.com>
> ---
>  fs/ext4/super.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 69c55d4..95b9c8e 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1929,7 +1929,7 @@ static int ext4_fill_flex_info(struct super_block *sb)
>  		sbi->s_log_groups_per_flex = 0;
>  		return 1;
>  	}
> -	groups_per_flex = 1 << sbi->s_log_groups_per_flex;
> +	groups_per_flex = 1U << sbi->s_log_groups_per_flex;
>  
>  	/* We allocate both existing and potentially added groups */
>  	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +

Looks good,

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
-- 
--Carlos
