From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v2] ext4: Remove redundant check for first_not_zeroed in
 ext4_register_li_request.
Date: Mon, 28 Mar 2011 16:13:05 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1103281611530.3158@dhcp-27-109.brq.redhat.com>
References: <1301321153-3171-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445Ab1C1ONK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Mar 2011 10:13:10 -0400
In-Reply-To: <1301321153-3171-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 28 Mar 2011, Tao Ma wrote:

> From: Tao Ma <boyu.mt@taobao.com>
> 
> We have checked first_not_zeroed == ngroups already above,
> so remove this redundant check.
> 
> sbi->s_li_request = NULL above is also removed since
> it is NULL already.
> 
> Cc: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  fs/ext4/super.c |    9 +--------
>  1 files changed, 1 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 2d1378f..c5a48dc 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2948,15 +2948,8 @@ static int ext4_register_li_request(struct super_block *sb,
>  
>  	if (first_not_zeroed == ngroups ||
>  	    (sb->s_flags & MS_RDONLY) ||
> -	    !test_opt(sb, INIT_INODE_TABLE)) {
> -		sbi->s_li_request = NULL;
> +	    !test_opt(sb, INIT_INODE_TABLE))
>  		return 0;
> -	}
> -
> -	if (first_not_zeroed == ngroups) {
> -		sbi->s_li_request = NULL;
> -		return 0;
> -	}
>  
>  	elr = ext4_li_request_new(sb, first_not_zeroed);
>  	if (!elr)
> 

The patch look good, thanks for cleaning that up.

-Lukas
