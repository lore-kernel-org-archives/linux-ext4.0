From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: no need flush workqueue before destroying it
Date: Tue, 9 Jan 2018 16:07:12 +0100
Message-ID: <20180109150712.i5tm3nywi3w4w4rk@quack2.suse.cz>
References: <5A54B7A2.8050101@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, adilger.kernel@dilger.ca, arnd@arndb.de,
        linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
To: piaojun <piaojun@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34350 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751263AbeAIPHR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 9 Jan 2018 10:07:17 -0500
Content-Disposition: inline
In-Reply-To: <5A54B7A2.8050101@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 09-01-18 20:37:54, piaojun wrote:
> destroy_workqueue() will do flushing work for us.
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

Adding Ted to CC as a maintainer...

								Honza

> ---
>  fs/ext4/super.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 0556cd0..2f46b0b 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -870,7 +870,6 @@ static void ext4_put_super(struct super_block *sb)
>  	ext4_unregister_li_request(sb);
>  	ext4_quota_off_umount(sb);
> 
> -	flush_workqueue(sbi->rsv_conversion_wq);
>  	destroy_workqueue(sbi->rsv_conversion_wq);
> 
>  	if (sbi->s_journal) {
> -- 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
