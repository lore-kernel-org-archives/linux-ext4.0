From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: improve ext4lazyinit scalability V2
Date: Mon, 15 Aug 2016 17:05:20 +0200
Message-ID: <20160815150520.GA22082@quack2.suse.cz>
References: <1471263815-26022-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, tytso@mit.edu
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35557 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbcHOPFW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Aug 2016 11:05:22 -0400
Content-Disposition: inline
In-Reply-To: <1471263815-26022-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Thanks for the patch. Couple of spelling fixes below and one functional
comment...

On Mon 15-08-16 16:23:35, Dmitry Monakhov wrote:
> ext4lazyinit is global thread. This thread performs itable initalization
                 ^^^ a global thread

> under li_list_mtx mutex.
> 
> It basically does following:
                   ^ the

> ext4_lazyinit_thread
>   ->mutex_lock(&eli->li_list_mtx);
>   ->ext4_run_li_request(elr)
>     ->ext4_init_inode_table-> Do a lot of IO if the list is large
> 
> And when new mount/umount arrive they have to block on ->li_list_mtx
> because  lazy_thread holds it during full walk procedure.
> ext4_fill_super
>  ->ext4_register_li_request
>    ->mutex_lock(&ext4_li_info->li_list_mtx);
>    ->list_add(&elr->lr_request, &ext4_li_info >li_request_list);
> In my case mount takes 40minutes on server with 36 * 4Tb HDD.
> Common user may face this in case of very slow dev ( /dev/mmcblkXXX)
> Even more. If one of filesystems was frozen lazyinit_thread will simply
> blocks on sb_start_write() so other mount/umount will be suck forever.
  ^^^ block                                                ^^ stuck

> This patch changes logic like follows:
> - grap ->s_umount read sem before processing new li_request.
    ^^^ grab

>   After that it is safe to drop li_list_mtx because all callers of
>   li_remove_request are holding ->s_umount for write.
> - li_thread skips frozen SB's
> 
> Locking order:
> Order is asserted by umout path like follows: s_umount ->li_list_mtx so
                        ^^^ umount

> the only way to to grab ->s_mount inside li_thread is via down_read_trylock
> 
> xfstests:ext4/023
> #PSBM-49658
> 
> Changes from V1
>  - spell fixes according to jack@ comments
>  - do not use temporal list.
> 
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/super.c | 43 +++++++++++++++++++++++++++++++------------
>  1 file changed, 31 insertions(+), 12 deletions(-)
...
> +			if (!progress) {
> +				elr->lr_next_sched = jiffies +
> +					(prandom_u32()
> +					 % (EXT4_DEF_LI_MAX_START_DELAY * HZ));
>  			}

I think we need to update next_wakeup here based on updated value of
lr_next_sched and also in case ext4_run_li_request() didn't complete the
request but ended up rescheduling it. Otherwise the patch looks fine.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
