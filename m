From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] ext3: fix message in ext3_remount for rw-remount
 case
Date: Tue, 2 Aug 2011 13:40:43 +0200
Message-ID: <20110802114043.GB18545@quack.suse.cz>
References: <20110802181657.d758bd44.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42311 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab1HBLkq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Aug 2011 07:40:46 -0400
Content-Disposition: inline
In-Reply-To: <20110802181657.d758bd44.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 02-08-11 18:16:57, Toshiyuki Okajima wrote:
> If there are some inodes in orphan list while a filesystem is being 
> read-only mounted, we should recommend that pepole umount and then
> mount it when they try to remount with read-write. But the current
> message and comment recommend that they umount and then remount it.
> 
> ext3_remount:
> 	/*
> 	 * If we have an unprocessed orphan list hanging
> 	 * around from a previously readonly bdev mount,
> 	 * require a full umount/remount for now.
>                           ^^^^^^^^^^^^^^
> 	 */
> 	if (es->s_last_orphan) {
> 		printk(KERN_WARNING "EXT3-fs: %s: couldn't "
> 			"remount RDWR because of unprocessed "
> 			"orphan inode list.  Please "
> 			"umount/remount instead.\n",
>                          ^^^^^^^^^^^^^^
> 			sb->s_id);
> 
  Thanks. I've merged the patch. I only made the log shorther (no need to
repeat where the message is fixed in the changelog when it's obvious from
the diff).

								Honza

> Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> ---
>  fs/ext3/super.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 7beb69a..2043bcc 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -2669,13 +2669,13 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
>  			/*
>  			 * If we have an unprocessed orphan list hanging
>  			 * around from a previously readonly bdev mount,
> -			 * require a full umount/remount for now.
> +			 * require a full umount & mount for now.
>  			 */
>  			if (es->s_last_orphan) {
>  				ext3_msg(sb, KERN_WARNING, "warning: couldn't "
>  				       "remount RDWR because of unprocessed "
>  				       "orphan inode list.  Please "
> -				       "umount/remount instead.");
> +				       "umount & mount instead.");
>  				err = -EINVAL;
>  				goto restore_opts;
>  			}
> -- 
> 1.5.5.6
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
