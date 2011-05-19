From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/4 v2] ext4: Remove unnecessary wait_event ext4_run_lazyinit_thread()
Date: Thu, 19 May 2011 14:37:27 -0500
Message-ID: <4DD57177.5040101@redhat.com>
References: <1304956630-20384-1-git-send-email-lczerner@redhat.com> <1304956630-20384-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933830Ab1ESTha (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 May 2011 15:37:30 -0400
In-Reply-To: <1304956630-20384-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/9/11 10:57 AM, Lukas Czerner wrote:
> For some reason we have been waiting for lazyinit thread to start in the
> ext4_run_lazyinit_thread() but it is not needed anymore so get rid of
> it. We can also remove li_task and li_wait_task since it is not used
> anymore.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Can you add to the changelog why this is "not needed anymore?"
What changed?  Was there any reason that it was waiting before,
or was that just unnecessary complexity?  I don't think
there is a need to wait for the thread to ping us back
after calling kthread_run() but I just wonder why it was
there in the first place...

Other than that, seems fine, so:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/ext4/ext4.h  |    2 --
>  fs/ext4/super.c |   10 ----------
>  2 files changed, 0 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 1e37c09..8689f97 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1590,8 +1590,6 @@ void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
>   */
>  struct ext4_lazy_init {
>  	unsigned long		li_state;
> -	wait_queue_head_t	li_wait_task;
> -	struct task_struct	*li_task;
>  	struct list_head	li_request_list;
>  	struct mutex		li_list_mtx;
>  };
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index f0e4c3a..6ccf0e2 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2754,9 +2754,6 @@ static int ext4_lazyinit_thread(void *arg)
>  
>  	BUG_ON(NULL == eli);
>  
> -	eli->li_task = current;
> -	wake_up(&eli->li_wait_task);
> -
>  cont_thread:
>  	while (true) {
>  		next_wakeup = MAX_JIFFY_OFFSET;
> @@ -2819,9 +2816,6 @@ exit_thread:
>  		goto cont_thread;
>  	}
>  	mutex_unlock(&eli->li_list_mtx);
> -	eli->li_task = NULL;
> -	wake_up(&eli->li_wait_task);
> -
>  	kfree(ext4_li_info);
>  	ext4_li_info = NULL;
>  	mutex_unlock(&ext4_li_mtx);
> @@ -2858,8 +2852,6 @@ static int ext4_run_lazyinit_thread(void)
>  		return err;
>  	}
>  	ext4_li_info->li_state |= EXT4_LAZYINIT_RUNNING;
> -
> -	wait_event(ext4_li_info->li_wait_task, ext4_li_info->li_task != NULL);
>  	return 0;
>  }
>  
> @@ -2894,11 +2886,9 @@ static int ext4_li_info_new(void)
>  	if (!eli)
>  		return -ENOMEM;
>  
> -	eli->li_task = NULL;
>  	INIT_LIST_HEAD(&eli->li_request_list);
>  	mutex_init(&eli->li_list_mtx);
>  
> -	init_waitqueue_head(&eli->li_wait_task);
>  	eli->li_state |= EXT4_LAZYINIT_QUIT;
>  
>  	ext4_li_info = eli;

