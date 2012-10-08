From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: fix error handling in ext4_fill_super()
Date: Mon, 8 Oct 2012 14:25:38 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1210081424290.25096@localhost>
References: <1349694582-16958-1-git-send-email-eugene.shatokhin@rosalab.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab2JHMZp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Oct 2012 08:25:45 -0400
In-Reply-To: <1349694582-16958-1-git-send-email-eugene.shatokhin@rosalab.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 8 Oct 2012, Eugene Shatokhin wrote:

> Date: Mon,  8 Oct 2012 15:09:42 +0400
> From: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
> To: linux-ext4@vger.kernel.org
> Cc: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
> Subject: [PATCH] ext4: fix error handling in ext4_fill_super()
> 
> If ext4_mb_init() returns error (e.g. if there is not enough memory),
> ext4_fill_super() returns 0 rather than the error code.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=48431
> 
> The patch fixes that problem.

Unfortunately there are other places with this problem as well.
I'll send you a different patch to address this problem, let me know
what do you think.

Thanks!
-Lukas

> 
> Signed-off-by: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
> ---
>  fs/ext4/super.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 982f6fc..7292532 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3982,6 +3982,7 @@ no_journal:
>  	if (err) {
>  		ext4_msg(sb, KERN_ERR, "failed to initialize mballoc (%d)",
>  			 err);
> +		ret = err;
>  		goto failed_mount5;
>  	}
>  
> 
