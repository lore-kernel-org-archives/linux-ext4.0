From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: retry failed direct IO allocations
Date: Wed, 14 Oct 2009 14:53:16 +0200
Message-ID: <20091014125316.GF12701@duck.suse.cz>
References: <4AD3E733.4080903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38993 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760393AbZJNMx4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Oct 2009 08:53:56 -0400
Content-Disposition: inline
In-Reply-To: <4AD3E733.4080903@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 12-10-09 21:34:27, Eric Sandeen wrote:
> On a 256M 4k block filesystem, doing this in a loop:
>
>    dd if=/dev/zero of=test oflag=direct bs=1M count=64
>    rm -f test
>
> eventually leads to spurious ENOSPC:
>
>    dd: writing `test': No space left on device
>
> As with other block allocation callers, it looks like we need to
> potentially retry the allocations on the initial ENOSPC.
>
> A similar patch went into ext4 (commit
> fbbf69456619de5d251cb9f1df609069178c62d5)
  Thanks for the patch Eric. Committed to my tree.

								Honza

> ---
>
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index acf1b14..069a163 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -1735,6 +1735,7 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
> 	ssize_t ret;
> 	int orphan = 0;
> 	size_t count = iov_length(iov, nr_segs);
> +	int retries = 0;
>
> 	if (rw == WRITE) {
> 		loff_t final_size = offset + count;
> @@ -1757,9 +1758,12 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
> 		}
> 	}
>
> +retry:
> 	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
> 				 offset, nr_segs,
> 				 ext3_get_block, NULL);
> +	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
> +		goto retry;
>
> 	if (orphan) {
> 		int err;
>
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
