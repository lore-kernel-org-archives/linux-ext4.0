From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v1 3/9] ext4: remove useless s_dirt assignment
Date: Thu, 22 Mar 2012 11:02:06 +0100
Message-ID: <20120322100206.GF14485@quack.suse.cz>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
 <1332254489-2300-4-git-send-email-dedekind1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628Ab2CVKCI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Mar 2012 06:02:08 -0400
Content-Disposition: inline
In-Reply-To: <1332254489-2300-4-git-send-email-dedekind1@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 20-03-12 16:41:23, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> 
> Clean-up ext4 a tiny bit by removing useless s_dirt assignment in
> 'ext4_fill_super()' because a bit later we anyway call 'ext4_setup_super()'
> which writes the superblock to the media unconditionally.
> 
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
  Looks good.
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/ext4/super.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index c1f5111..d280bb6 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3415,7 +3415,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  #else
>  		es->s_flags |= cpu_to_le32(EXT2_FLAGS_SIGNED_HASH);
>  #endif
> -		sb->s_dirt = 1;
>  	}
>  
>  	/* Handle clustersize */
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
