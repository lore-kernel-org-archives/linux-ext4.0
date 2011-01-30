From: tm@tao.ma
Subject: Re: [PATCH] ext4: fix panic on module unload when stopping lazyinit
 thread
Date: Sat, 29 Jan 2011 19:32:34 -0700
Message-ID: <a8910fcd961d27c68186681aa37bb22b.squirrel@mail.tao.ma>
References: <4D43402D.2000004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "ext4 development" <linux-ext4@vger.kernel.org>,
	=?iso-8859-1?Q?=22Luk=E1=9A_Czerner=22?= <lczerner@redhat.com>
To: "Eric Sandeen" <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:56070 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751772Ab1A3Ccf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Jan 2011 21:32:35 -0500
In-Reply-To: <4D43402D.2000004@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> This is for the latest reported module unload oops in
> kernel.org bugzilla #27652
>
> If the lazyinit thread is running, the teardown
> function ext4_destroy_lazyinit_thread() has problems:
>
>         ext4_clear_request_list();
>         while (ext4_li_info->li_task) {
>                 wake_up(&ext4_li_info->li_wait_daemon);
>                 wait_event(ext4_li_info->li_wait_task,
>                            ext4_li_info->li_task == NULL);
>         }
>
> clearing the request list will cause the thread to exit
> and free ext4_li_info, so then we're waiting on something
> which is getting freed.
>
> Fix this up by making the thread respond to kthread_stop,
> and exit, without the need to wait for that exit in some
> other homegrown way.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
It works now. Thanks.
Reported-and-Tested-by: Tao Ma <boyu.mt@taobao.com>
> ---
>
> Index: linux-2.6/fs/ext4/super.c
> ===================================================================
> --- linux-2.6.orig/fs/ext4/super.c
> +++ linux-2.6/fs/ext4/super.c
> @@ -77,6 +77,7 @@ static struct dentry *ext4_mount(struct
>  		       const char *dev_name, void *data);
>  static void ext4_destroy_lazyinit_thread(void);
>  static void ext4_unregister_li_request(struct super_block *sb);
> +static void ext4_clear_request_list(void);
>
>  #if !defined(CONFIG_EXT3_FS) && !defined(CONFIG_EXT3_FS_MODULE) &&
> defined(CONFIG_EXT4_USE_FOR_EXT23)
>  static struct file_system_type ext3_fs_type = {
> @@ -2704,6 +2705,8 @@ static void ext4_unregister_li_request(s
>  	mutex_unlock(&ext4_li_info->li_list_mtx);
>  }
>
> +static struct task_struct *ext4_lazyinit_task;
> +
>  /*
>   * This is the function where ext4lazyinit thread lives. It walks
>   * through the request list searching for next scheduled filesystem.
> @@ -2772,6 +2775,10 @@ cont_thread:
>  		if (time_before(jiffies, next_wakeup))
>  			schedule();
>  		finish_wait(&eli->li_wait_daemon, &wait);
> +		if (kthread_should_stop()) {
> +			ext4_clear_request_list();
> +			goto exit_thread;
> +		}
>  	}
>
>  exit_thread:
> @@ -2796,6 +2803,7 @@ exit_thread:
>  	wake_up(&eli->li_wait_task);
>
>  	kfree(ext4_li_info);
> +	ext4_lazyinit_task = NULL;
>  	ext4_li_info = NULL;
>  	mutex_unlock(&ext4_li_mtx);
>
> @@ -2818,11 +2826,10 @@ static void ext4_clear_request_list(void
>
>  static int ext4_run_lazyinit_thread(void)
>  {
> -	struct task_struct *t;
> -
> -	t = kthread_run(ext4_lazyinit_thread, ext4_li_info, "ext4lazyinit");
> -	if (IS_ERR(t)) {
> -		int err = PTR_ERR(t);
> +	ext4_lazyinit_task = kthread_run(ext4_lazyinit_thread,
> +					 ext4_li_info, "ext4lazyinit");
> +	if (IS_ERR(ext4_lazyinit_task)) {
> +		int err = PTR_ERR(ext4_lazyinit_task);
>  		ext4_clear_request_list();
>  		del_timer_sync(&ext4_li_info->li_timer);
>  		kfree(ext4_li_info);
> @@ -2973,16 +2980,10 @@ static void ext4_destroy_lazyinit_thread
>  	 * If thread exited earlier
>  	 * there's nothing to be done.
>  	 */
> -	if (!ext4_li_info)
> +	if (!ext4_li_info || !ext4_lazyinit_task)
>  		return;
>
> -	ext4_clear_request_list();
> -
> -	while (ext4_li_info->li_task) {
> -		wake_up(&ext4_li_info->li_wait_daemon);
> -		wait_event(ext4_li_info->li_wait_task,
> -			   ext4_li_info->li_task == NULL);
> -	}
> +	kthread_stop(ext4_lazyinit_task);
>  }
>
>  static int ext4_fill_super(struct super_block *sb, void *data, int
> silent)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


