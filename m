From: David Gstir <david@sigma-star.at>
Subject: Re: [PATCH] ext4: remove redundant check for encrypted file on dio
 write path
Date: Tue, 23 May 2017 08:03:22 +0200
Message-ID: <07EDDE1E-335F-418A-8058-C12734CC6EF6@sigma-star.at>
References: <20170523005316.18996-1-ebiggers3@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        linux-fscrypt@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.sigma-star.at ([95.130.255.111]:45996 "EHLO
        mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752602AbdEWGD0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 May 2017 02:03:26 -0400
In-Reply-To: <20170523005316.18996-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,

> On 23 May 2017, at 02:53, Eric Biggers <ebiggers3@gmail.com> wrote:
> 
> From: Eric Biggers <ebiggers@google.com>
> 
> Currently we don't allow direct I/O on encrypted regular files, so in
> such cases we return 0 early in ext4_direct_IO().  There was also an
> additional BUG_ON() check in ext4_direct_IO_write(), but it can never be
> hit because of the earlier check for the exact same condition in
> ext4_direct_IO().  There was also no matching check on the read path,
> which made the write path specific check seem very ad-hoc.
> 
> Just remove the unnecessary BUG_ON().
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> fs/ext4/inode.c | 3 ---
> 1 file changed, 3 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 1bd0bfa547f6..7c6e715b4d2e 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3629,9 +3629,6 @@ static ssize_t ext4_direct_IO_write(struct kiocb *iocb, struct iov_iter *iter)
> 		get_block_func = ext4_dio_get_block_unwritten_async;
> 		dio_flags = DIO_LOCKING;
> 	}
> -#ifdef CONFIG_EXT4_FS_ENCRYPTION
> -	BUG_ON(ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode));
> -#endif
> 	ret = __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, iter,
> 				   get_block_func, ext4_end_io_dio, NULL,
> 				   dio_flags);
> -- 
> 2.13.0.303.g4ebf302169-goog

LGTM.
Reviewed-by: David Gstir <david@sigma-star.at> 

David
