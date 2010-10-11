From: Jan Kara <jack@suse.cz>
Subject: Re: ext4: do not get s_umount sem on ext4_quota_off
Date: Mon, 11 Oct 2010 15:37:29 +0200
Message-ID: <20101011133723.GB3830@quack.suse.cz>
References: <87k4lro060.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, tytso@mit.edu
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53567 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485Ab0JKNib (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Oct 2010 09:38:31 -0400
Content-Disposition: inline
In-Reply-To: <87k4lro060.fsf@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 09-10-10 19:28:39, Dmitry Monakhov wrote:
> It must be already acquired by caller. Fix lock_dep complain.
  The patch is OK, but Ted usually merges ext4 patches (even quota related,
unless they are dependent on other generic quota stuff).

								Honza
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@gmail.com>
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index e59eb37..062d1bc 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4107,12 +4107,10 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
>  
>  static int ext4_quota_off(struct super_block *sb, int type)
>  {
> -	/* Force all delayed allocation blocks to be allocated */
> -	if (test_opt(sb, DELALLOC)) {
> -		down_read(&sb->s_umount);
> +	/* Force all delayed allocation blocks to be allocated.
> +	 * Caller already holds s_umount sem */
> +	if (test_opt(sb, DELALLOC))
>  		sync_filesystem(sb);
> -		up_read(&sb->s_umount);
> -	}
>  
>  	return dquot_quota_off(sb, type);
>  }
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
