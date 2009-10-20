From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/4] ext4: Wait for proper transaction commit on fsync
Date: Tue, 20 Oct 2009 18:01:31 +0530
Message-ID: <20091020123131.GA30182@skywalker.linux.vnet.ibm.com>
References: <1256023478-746-1-git-send-email-jack@suse.cz>
 <1256023478-746-5-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:45391 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbZJTMbg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Oct 2009 08:31:36 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.31.245])
	by e23smtp01.au.ibm.com (8.14.3/8.13.1) with ESMTP id n9KCUDlM002382
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2009 23:30:13 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9KCVdfA671840
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2009 23:31:39 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n9KCVcob006223
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2009 23:31:39 +1100
Content-Disposition: inline
In-Reply-To: <1256023478-746-5-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 20, 2009 at 09:24:38AM +0200, Jan Kara wrote:
> We cannot rely on buffer dirty bits during fsync because pdflush can come
> before fsync is called and clear dirty bits without forcing a transaction
> commit. What we do is that we track which transaction has last changed
> the inode and which transaction last changed allocation and force it to
> disk on fsync.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/ext4.h    |    7 +++++++
>  fs/ext4/extents.c |    5 +++++
>  fs/ext4/fsync.c   |   40 +++++++++++++++++-----------------------
>  fs/ext4/inode.c   |   34 ++++++++++++++++++++++++++++++++++
>  4 files changed, 63 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 984ca0c..5639f30 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -702,6 +702,13 @@ struct ext4_inode_info {
>  	struct list_head i_aio_dio_complete_list;
>  	/* current io_end structure for async DIO write*/
>  	ext4_io_end_t *cur_aio_dio;
> +
> +	/*
> +	 * Transactions that contain inode's metadata needed to complete
> +	 * fsync and fdatasync, respectively.
> +	 */
> +	atomic_t i_sync_tid;
> +	atomic_t i_datasync_tid;
>  };
> 
>  /*
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 10539e3..3e167f6 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3315,6 +3315,11 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
>  	newblock = ext_pblock(&newex);
>  	allocated = ext4_ext_get_actual_len(&newex);
>  	set_buffer_new(bh_result);
> +	
> +	atomic_set(&EXT4_I(inode)->i_sync_tid, handle->h_transaction->t_tid);
> +	atomic_set(&EXT4_I(inode)->i_datasync_tid,
> +		   handle->h_transaction->t_tid);
> +	printk("Datasync tid %u\n", handle->h_transaction->t_tid);

The printk need to be removed ?

Also i am wondering wether we need to update i_datasync_tid only if we
allocate new blocks ? How about writing to an fallocate area. I guess
we need to track the transaction in which we are marking an extent
initialized.

-aneesh
