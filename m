From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: improve ext4lazyinit scalability V2
Date: Tue, 6 Sep 2016 10:36:08 +0200
Message-ID: <20160906083608.GB28922@quack2.suse.cz>
References: <1471263815-26022-1-git-send-email-dmonakhov@openvz.org>
 <20160815150520.GA22082@quack2.suse.cz>
 <20160906033954.k22xaasbn26s4wo4@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>,
        linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35024 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755095AbcIFIgL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 6 Sep 2016 04:36:11 -0400
Content-Disposition: inline
In-Reply-To: <20160906033954.k22xaasbn26s4wo4@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 05-09-16 23:39:54, Ted Tso wrote:
> Dmitry, thanks for the patch, and Jan, thanks for the review.
> 
> This is what I've added to the ext4 tree, which should reflect all of
> the comments which Jan made.

Hum, one comment still:

> +			if (down_read_trylock(&elr->lr_super->s_umount)) {
> +				if (sb_start_write_trylock(elr->lr_super)) {
> +					progress = 1;
> +					/*
> +					 * We hold sb->s_umount, sb can not
> +					 * be removed from the list, it is
> +					 * now safe to drop li_list_mtx
> +					 */
> +					mutex_unlock(&eli->li_list_mtx);
> +					err = ext4_run_li_request(elr);
> +					sb_end_write(elr->lr_super);
> +					mutex_lock(&eli->li_list_mtx);
> +					n = pos->next;
>  				}
> +				up_read((&elr->lr_super->s_umount));
> +			}
> +			/* error, remove the lazy_init job */
> +			if (err) {
> +				ext4_remove_li_request(elr);
> +				continue;
> +			}
> +			if (!progress) {
> +				elr->lr_next_sched = jiffies +
> +					(prandom_u32()
> +					 % (EXT4_DEF_LI_MAX_START_DELAY * HZ));
> +				if (time_before(elr->lr_next_sched,
> +						next_wakeup))
> +					next_wakeup = elr->lr_next_sched;
>  			}
> -
> -			if (time_before(elr->lr_next_sched, next_wakeup))
> -				next_wakeup = elr->lr_next_sched;
>  		}

ext4_run_li_request() can also update elr->lr_next_sched. So we need to
update next_wakeup even in progress == 1 case (i.e., I'd leave the update
of next_wakeup as is in the old code...). Otherwise the patch looks good.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
