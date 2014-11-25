From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] debugfs: fix typo in message
Date: Tue, 25 Nov 2014 13:36:37 -0800
Message-ID: <20141125213637.GA12111@birch.djwong.org>
References: <1416737044-26285-1-git-send-email-bwiedemann@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Bernhard M. Wiedemann" <bwiedemann@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30616 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaKYVgn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Nov 2014 16:36:43 -0500
Content-Disposition: inline
In-Reply-To: <1416737044-26285-1-git-send-email-bwiedemann@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[add list to cc]

Looks ok, but please send patches to linux-ext4 for broader review.

--D

On Sun, Nov 23, 2014 at 11:04:04AM +0100, Bernhard M. Wiedemann wrote:
> From: "Bernhard M. Wiedemann" <bwiedemann@suse.de>
> 
> Signed-off-by: Bernhard M. Wiedemann <bwiedemann@suse.de>
> ---
>  debugfs/quota.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/debugfs/quota.c b/debugfs/quota.c
> index 5589c1a..9612f64 100644
> --- a/debugfs/quota.c
> +++ b/debugfs/quota.c
> @@ -36,7 +36,7 @@ static int load_quota_ctx(char *progname)
>  
>  	if (!EXT2_HAS_RO_COMPAT_FEATURE(current_fs->super,
>  					EXT4_FEATURE_RO_COMPAT_QUOTA)) {
> -		com_err(progname, 0, "quota feature not eanbled");
> +		com_err(progname, 0, "quota feature not enabled");
>  		return 1;
>  	}
>  
> -- 
> 1.8.1.4
> 
