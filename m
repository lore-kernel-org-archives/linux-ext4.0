From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH 1/3] ext4: Use correct locking for ext4_end_io_nolock()
Date: Mon, 31 Oct 2011 23:28:06 +0800
Message-ID: <4EAEBE86.1010303@tao.ma>
References: <20111031150206.GC16825@thunk.org> <1320073367-28916-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Tao Ma <boyu.mt@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:49371 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933175Ab1JaP2M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Oct 2011 11:28:12 -0400
In-Reply-To: <1320073367-28916-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/31/2011 11:02 PM, Theodore Ts'o wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> We must hold i_completed_io_lock when manipulating anything on the
> i_completed_io_list linked list.  This includes io->lock, which we
> were checking in ext4_end_io_nolock().
> 
> So move this check to ext4_end_io_work().  This also has the bonus of
> avoiding extra work if it is already done without needing to take the
> mutex.
> 
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
I am fine with it.

Thanks
Tao
> ---
>  fs/ext4/fsync.c   |    3 ---
>  fs/ext4/page-io.c |   14 +++++++++++---
>  2 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index c942924..851ac5b 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -83,9 +83,6 @@ int ext4_flush_completed_IO(struct inode *inode)
>  	int ret = 0;
>  	int ret2 = 0;
>  
> -	if (list_empty(&ei->i_completed_io_list))
> -		return ret;
> -
>  	dump_completed_IO(inode);
>  	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
>  	while (!list_empty(&ei->i_completed_io_list)){
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 92f38ee..aed4096 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -87,6 +87,9 @@ void ext4_free_io_end(ext4_io_end_t *io)
>  
>  /*
>   * check a range of space and convert unwritten extents to written.
> + *
> + * Called with inode->i_mutex; we depend on this when we manipulate
> + * io->flag, since we could otherwise race with ext4_flush_completed_IO()
>   */
>  int ext4_end_io_nolock(ext4_io_end_t *io)
>  {
> @@ -100,9 +103,6 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
>  		   "list->prev 0x%p\n",
>  		   io, inode->i_ino, io->list.next, io->list.prev);
>  
> -	if (list_empty(&io->list))
> -		return ret;
> -
>  	if (!(io->flag & EXT4_IO_END_UNWRITTEN))
>  		return ret;
>  
> @@ -142,6 +142,13 @@ static void ext4_end_io_work(struct work_struct *work)
>  	unsigned long		flags;
>  	int			ret;
>  
> +	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> +	if (list_empty(&io->list)) {
> +		spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> +		goto free;
> +	}
> +	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> +
>  	if (!mutex_trylock(&inode->i_mutex)) {
>  		/*
>  		 * Requeue the work instead of waiting so that the work
> @@ -170,6 +177,7 @@ static void ext4_end_io_work(struct work_struct *work)
>  		list_del_init(&io->list);
>  	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
>  	mutex_unlock(&inode->i_mutex);
> +free:
>  	ext4_free_io_end(io);
>  }
>  

