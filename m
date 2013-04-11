From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: Fix data corruption with direct IO read in
 dioread_nolock mode
Date: Thu, 11 Apr 2013 21:20:36 +0800
Message-ID: <20130411132036.GA3448@gmail.com>
References: <1365438463-23025-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35428 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3DKNDj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Apr 2013 09:03:39 -0400
Received: by mail-pa0-f44.google.com with SMTP id bi5so893566pad.31
        for <linux-ext4@vger.kernel.org>; Thu, 11 Apr 2013 06:03:38 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1365438463-23025-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 08, 2013 at 06:27:43PM +0200, Jan Kara wrote:
> When ext4 is mounted in dioread_nolock mode, it calls
> __blockdev_direct_IO() without DIO_LOCKING flag which also means mapping
> is not synced before direct IO starts. As a result consistency between
> buffered writes and following direct IO reads is broken. More
> importantly, if the file is truncated, and extented back, zeroing of the
> tail page is not visible to the following direct IO read which will return
> stale data.
> 
> Fix the problem by flushing dirty pages before issuing direct IO read.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/indirect.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index b505a14..c18bf1c 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -809,6 +809,10 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
>  
>  retry:
>  	if (rw == READ && ext4_should_dioread_nolock(inode)) {
> +		ret = filemap_write_and_wait_range(inode->i_mapping, offset,
> +						   offset + count - 1);
> +		if (ret)
> +			goto out;
>  		if (unlikely(atomic_read(&EXT4_I(inode)->i_unwritten))) {
>  			mutex_lock(&inode->i_mutex);
>  			ext4_flush_unwritten_io(inode);

Hi Jan,

Sorry for the late reply.  I have a question about this patch.  In your
patch, we flush dirty pages befoer issuing a dio read.  But we have
flushed dirty pages in generic_file_aio_read().  So is it really
necessary to flush dirty pages again?

Regards,
                                                - Zheng
