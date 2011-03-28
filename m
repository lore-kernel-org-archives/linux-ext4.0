From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Fix a double free in ext4_register_li_request.
Date: Mon, 28 Mar 2011 12:08:04 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1103281207100.4923@dhcp-27-109.brq.redhat.com>
References: <1301297857-3839-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, stable@kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab1C1KIR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Mar 2011 06:08:17 -0400
In-Reply-To: <1301297857-3839-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 28 Mar 2011, Tao Ma wrote:

> From: Tao Ma <boyu.mt@taobao.com>
> 
> In ext4_register_li_request, we malloc a ext4_li_request and
> inserts it into ext4_li_info->li_request_list. In case of any
> error later, we free it in the end. But if we have some error
> in ext4_run_lazyinit_thread, the whole li_request_list will be
> dropped and freed in it. So we will double free this ext4_li_request.
> 
> This patch just sets elr to NULL after it is inserted to the list
> so that the latter kfree won't double free it.
> 
> Cc: stable@kernel.org
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  fs/ext4/super.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 22546ad..2d1378f 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2975,6 +2975,12 @@ static int ext4_register_li_request(struct super_block *sb,
>  	mutex_unlock(&ext4_li_info->li_list_mtx);
>  
>  	sbi->s_li_request = elr;
> +	/*
> +	 * set elr to NULL here since it has been inserted to
> +	 * the request_list and the removal and free of it is
> +	 * handled by ext4_clear_request_list from now on.
> +	 */
> +	elr = NULL;
>  
>  	if (!(ext4_li_info->li_state & EXT4_LAZYINIT_RUNNING)) {
>  		ret = ext4_run_lazyinit_thread();
> 

Good catch. Thanks, the patch looks good.

-Lukas
