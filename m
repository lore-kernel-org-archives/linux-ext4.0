From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext3: make ext3 mount default to barrier=1
Date: Mon, 11 Jul 2011 21:17:35 +0200
Message-ID: <20110711191735.GG5482@quack.suse.cz>
References: <20110711182532.GA12099@infradead.org>
 <20110711182558.GB12099@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro@zeniv.linux.org.uk, jeffm@suse.com, chris.mason@oracle.com,
	jack@suse.cz, reiserfs-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab1GKTRh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jul 2011 15:17:37 -0400
Content-Disposition: inline
In-Reply-To: <20110711182558.GB12099@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 11-07-11 14:25:59, Christoph Hellwig wrote:
> From: Chris Mason <mason@suse.com>
> 
> This patch turns on barriers by default for ext3.  mount -o barrier=0
> will turn them off.
> 
> Acked-by: Jeff Mahoney <jeffm@suse.com>
  This patch misses signed-off-by. Feel free to add
Acked-by: Jan Kara <jack@suse.cz>

								Honza
 
> Index: linux-2.6/fs/ext3/super.c
> ===================================================================
> --- linux-2.6.orig/fs/ext3/super.c	2011-06-30 21:19:37.389544975 +0200
> +++ linux-2.6/fs/ext3/super.c	2011-07-02 13:56:51.877784292 +0200
> @@ -1718,6 +1718,8 @@ static int ext3_fill_super (struct super
>  	sbi->s_resuid = le16_to_cpu(es->s_def_resuid);
>  	sbi->s_resgid = le16_to_cpu(es->s_def_resgid);
>  
> +	/* enable barriers by default */
> +	set_opt(sbi->s_mount_opt, BARRIER);
>  	set_opt(sbi->s_mount_opt, RESERVATION);
>  
>  	if (!parse_options ((char *) data, sb, &journal_inum, &journal_devnum,
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
