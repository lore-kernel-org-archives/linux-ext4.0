From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: Replace 0 with NULL for pointer in super.c file
Date: Tue, 4 Sep 2012 12:00:23 +0200
Message-ID: <20120904100023.GB5673@quack.suse.cz>
References: <1346746320-32582-1-git-send-email-sachin.kamat@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz,
	akpm@linux-foundation.org, patches@linaro.org
To: Sachin Kamat <sachin.kamat@linaro.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab2IDKAZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Sep 2012 06:00:25 -0400
Content-Disposition: inline
In-Reply-To: <1346746320-32582-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 04-09-12 13:42:00, Sachin Kamat wrote:
> Fixes the following sparse warning:
> fs/ext3/super.c:983:45: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
  Thanks. I've added the patch to my tree.

								Honza

> ---
>  fs/ext3/super.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index cf1fb17..0e17142 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -980,7 +980,7 @@ static int parse_options (char *options, struct super_block *sb,
>  		 * Initialize args struct so we know whether arg was
>  		 * found; some options take optional arguments.
>  		 */
> -		args[0].to = args[0].from = 0;
> +		args[0].to = args[0].from = NULL;
>  		token = match_token(p, tokens, args);
>  		switch (token) {
>  		case Opt_bsd_df:
> -- 
> 1.7.4.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
