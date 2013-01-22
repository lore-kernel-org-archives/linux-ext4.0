From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 03/12] ext4: Remove bogus wait for unwritten extents in ext4_ind_direct_IO
Date: Tue, 22 Jan 2013 15:11:24 +0400
Message-ID: <87k3r5qxpf.fsf@openvz.org>
References: <1358510446-19174-1-git-send-email-jack@suse.cz> <1358510446-19174-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:49001 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab3AVLL3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jan 2013 06:11:29 -0500
Received: by mail-la0-f47.google.com with SMTP id fh20so7166180lab.20
        for <linux-ext4@vger.kernel.org>; Tue, 22 Jan 2013 03:11:28 -0800 (PST)
In-Reply-To: <1358510446-19174-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 18 Jan 2013 13:00:37 +0100, Jan Kara <jack@suse.cz> wrote:
> When using indirect blocks there is no possibility to have any unwritten
> extents. So wait for them in ext4_ind_direct_IO() is just bogus.
But as soon as i remember indirect implementation may also be used by
extents based inodes 3074: ext4_ext_direct_IO
    /* Use the old path for reads and writes beyond i_size. */
    if (rw != WRITE || final_size > inode->i_size)
       return ext4_ind_direct_IO(rw, iocb, iov, offset, nr_segs);

Am I missing ?
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/indirect.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 20862f9..993247c 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -807,11 +807,6 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
>  
>  retry:
>  	if (rw == READ && ext4_should_dioread_nolock(inode)) {
> -		if (unlikely(atomic_read(&EXT4_I(inode)->i_unwritten))) {
> -			mutex_lock(&inode->i_mutex);
> -			ext4_flush_unwritten_io(inode);
> -			mutex_unlock(&inode->i_mutex);
> -		}
>  		/*
>  		 * Nolock dioread optimization may be dynamically disabled
>  		 * via ext4_inode_block_unlocked_dio(). Check inode's state
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
