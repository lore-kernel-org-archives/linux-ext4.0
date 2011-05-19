From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/4 v2] ext4: Use schedule_timeout_interruptible() for
 waiting in lazyinit thread
Date: Thu, 19 May 2011 14:30:17 -0500
Message-ID: <4DD56FC9.5050001@redhat.com>
References: <1304956630-20384-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934363Ab1ESTaV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 May 2011 15:30:21 -0400
In-Reply-To: <1304956630-20384-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/9/11 10:57 AM, Lukas Czerner wrote:
> In order to make lazyinit eat approx. 10% of io bandwidth at max, we are
> sleeping between zeroing each single inode table. For that purpose we
> are using timer which wakes up thread when it expires. It is set via
> add_timer() and this may cause troubles in the case that thread has been
> woken up earlier and in next iteration we call add_timer() on still
> running timer hence hitting BUG_ON in add_timer(). We could fix that by
> using mod_timer() instead however we can use
> schedule_timeout_interruptible() for waiting and hence simplifying
> things a lot.
> 
> This commit exchange the old "waiting mechanism" with simple
> schedule_timeout_interruptible(), setting the time to sleep. Hence we do
> not longer need li_wait_daemon waiting queue and others, so get rid of
> it.
> 
> This solves Red Hat bug 699708.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks Lukas - this looks good to me and takes care of the concern
about jiffies wrapping.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> [v2]: prevent sleepeng for a loong time when jiffies wraps
>       (Thanks to Eric Sandeen)
>  fs/ext4/ext4.h  |    4 ----
>  fs/ext4/super.c |   31 ++++++-------------------------
>  2 files changed, 6 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 4daaf2b..1e37c09 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1590,12 +1590,8 @@ void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
>   */
>  struct ext4_lazy_init {
>  	unsigned long		li_state;
> -
> -	wait_queue_head_t	li_wait_daemon;
>  	wait_queue_head_t	li_wait_task;
> -	struct timer_list	li_timer;
>  	struct task_struct	*li_task;
> -
>  	struct list_head	li_request_list;
>  	struct mutex		li_list_mtx;
>  };
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 8553dfb..f0e4c3a 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2659,12 +2659,6 @@ static void print_daily_error_info(unsigned long arg)
>  	mod_timer(&sbi->s_err_report, jiffies + 24*60*60*HZ);  /* Once a day */
>  }
>  
> -static void ext4_lazyinode_timeout(unsigned long data)
> -{
> -	struct task_struct *p = (struct task_struct *)data;
> -	wake_up_process(p);
> -}
> -
>  /* Find next suitable group and run ext4_init_inode_table */
>  static int ext4_run_li_request(struct ext4_li_request *elr)
>  {
> @@ -2712,7 +2706,7 @@ static int ext4_run_li_request(struct ext4_li_request *elr)
>  
>  /*
>   * Remove lr_request from the list_request and free the
> - * request tructure. Should be called with li_list_mtx held
> + * request structure. Should be called with li_list_mtx held
>   */
>  static void ext4_remove_li_request(struct ext4_li_request *elr)
>  {
> @@ -2756,14 +2750,10 @@ static int ext4_lazyinit_thread(void *arg)
>  	struct ext4_lazy_init *eli = (struct ext4_lazy_init *)arg;
>  	struct list_head *pos, *n;
>  	struct ext4_li_request *elr;
> -	unsigned long next_wakeup;
> -	DEFINE_WAIT(wait);
> +	unsigned long next_wakeup, cur;
>  
>  	BUG_ON(NULL == eli);
>  
> -	eli->li_timer.data = (unsigned long)current;
> -	eli->li_timer.function = ext4_lazyinode_timeout;
> -
>  	eli->li_task = current;
>  	wake_up(&eli->li_wait_task);
>  
> @@ -2797,19 +2787,15 @@ cont_thread:
>  		if (freezing(current))
>  			refrigerator();
>  
> -		if ((time_after_eq(jiffies, next_wakeup)) ||
> +		cur = jiffies;
> +		if ((time_after_eq(cur, next_wakeup)) ||
>  		    (MAX_JIFFY_OFFSET == next_wakeup)) {
>  			cond_resched();
>  			continue;
>  		}
>  
> -		eli->li_timer.expires = next_wakeup;
> -		add_timer(&eli->li_timer);
> -		prepare_to_wait(&eli->li_wait_daemon, &wait,
> -				TASK_INTERRUPTIBLE);
> -		if (time_before(jiffies, next_wakeup))
> -			schedule();
> -		finish_wait(&eli->li_wait_daemon, &wait);
> +		schedule_timeout_interruptible(next_wakeup - cur);
> +
>  		if (kthread_should_stop()) {
>  			ext4_clear_request_list();
>  			goto exit_thread;
> @@ -2833,12 +2819,10 @@ exit_thread:
>  		goto cont_thread;
>  	}
>  	mutex_unlock(&eli->li_list_mtx);
> -	del_timer_sync(&ext4_li_info->li_timer);
>  	eli->li_task = NULL;
>  	wake_up(&eli->li_wait_task);
>  
>  	kfree(ext4_li_info);
> -	ext4_lazyinit_task = NULL;
>  	ext4_li_info = NULL;
>  	mutex_unlock(&ext4_li_mtx);
>  
> @@ -2866,7 +2850,6 @@ static int ext4_run_lazyinit_thread(void)
>  	if (IS_ERR(ext4_lazyinit_task)) {
>  		int err = PTR_ERR(ext4_lazyinit_task);
>  		ext4_clear_request_list();
> -		del_timer_sync(&ext4_li_info->li_timer);
>  		kfree(ext4_li_info);
>  		ext4_li_info = NULL;
>  		printk(KERN_CRIT "EXT4: error %d creating inode table "
> @@ -2915,9 +2898,7 @@ static int ext4_li_info_new(void)
>  	INIT_LIST_HEAD(&eli->li_request_list);
>  	mutex_init(&eli->li_list_mtx);
>  
> -	init_waitqueue_head(&eli->li_wait_daemon);
>  	init_waitqueue_head(&eli->li_wait_task);
> -	init_timer(&eli->li_timer);
>  	eli->li_state |= EXT4_LAZYINIT_QUIT;
>  
>  	ext4_li_info = eli;

