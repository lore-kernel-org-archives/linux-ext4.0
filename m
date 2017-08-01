From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: release discard bio after sending discard commands
Date: Tue, 1 Aug 2017 11:09:09 +0200
Message-ID: <20170801090909.GB4215@quack2.suse.cz>
References: <CGME20170801022917epcas2p49ee3e7d5ac5cba8746253429888b6d1c@epcas2p4.samsung.com>
 <1501554568-13815-1-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52472 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751368AbdHAJJL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 1 Aug 2017 05:09:11 -0400
Content-Disposition: inline
In-Reply-To: <1501554568-13815-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 01-08-17 11:29:28, Daeho Jeong wrote:
> We've changed the discard command handling into parallel manner.
> But, in this change, I forgot decreasing the usage count of the bio
> which was used to send discard request. I'm sorry about that.
> 
> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
> Fixes: a015434480dc ("ext4: send parallel discards on commit
> completions")

Why do you think this is needed? submit_bio_wait() consumes the reference
that you've got from __blkdev_issue_discard()...

								Honza
> ---
>  fs/ext4/mballoc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index ab70b69e644c..88317b0cf7b8 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2892,8 +2892,10 @@ void ext4_process_freed_data(struct super_block *sb, tid_t commit_tid)
>  				break;
>  		}
>  
> -		if (discard_bio)
> +		if (discard_bio) {
>  			submit_bio_wait(discard_bio);
> +			bio_put(discard_bio);
> +		}
>  	}
>  
>  	list_for_each_entry_safe(entry, tmp, &freed_data_list, efd_list)
> -- 
> 2.13.0
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
