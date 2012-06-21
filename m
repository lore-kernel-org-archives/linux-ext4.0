From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/5] ext4: add project quota support
Date: Fri, 22 Jun 2012 01:56:45 +0200
Message-ID: <20120621235645.GD11645@quack.suse.cz>
References: <1340269733-25922-1-git-send-email-dmonakhov@openvz.org>
 <1340269733-25922-5-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760644Ab2FUX4r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jun 2012 19:56:47 -0400
Content-Disposition: inline
In-Reply-To: <1340269733-25922-5-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 21-06-12 13:08:52, Dmitry Monakhov wrote:
> Both regular and journaled quota are supported.
  Looks good, just one whitespace damage caught below. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/ext4.h  |    1 +
>  fs/ext4/super.c |   48 ++++++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 41 insertions(+), 8 deletions(-)
> 
...
> @@ -1516,10 +1525,21 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
>  		return set_qf_name(sb, USRQUOTA, &args[0]);
>  	else if (token == Opt_grpjquota)
>  		return set_qf_name(sb, GRPQUOTA, &args[0]);
> -	else if (token == Opt_offusrjquota)
> +        else if (token == Opt_offusrjquota)
  Spaces instead of TAB here... Checkpatch would catch this BTW.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
