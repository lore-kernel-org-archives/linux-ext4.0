From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Prevent panic for destroyed devices
Date: Sun, 13 Mar 2016 18:26:51 -0400
Message-ID: <20160313222651.GJ29218@thunk.org>
References: <1455618965-26699-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39038 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbcCMW0y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Mar 2016 18:26:54 -0400
Content-Disposition: inline
In-Reply-To: <1455618965-26699-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 16, 2016 at 02:36:04PM +0400, Dmitry Monakhov wrote:
> Some devices(nbd) can becomes unoperatable via kill_bdev
> so its pagecache will be invalidated and all buffers becomes unmapped.
> In that situation we will trigger BUGON on submit_bh.
> 
> #Testcase
> mkdir  -p a/mnt
> cd a
> truncate -s 1G img
> mkfs.ext4 -F img
> qemu-nbd -c /dev/nbd0 img
> mount /dev/nbd0 /mnt
> cp -r /bin/ /mnt&
> # Disconnect nbd while cp is active
> qemu-nbd -d /dev/nbd0
> sync
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/super.c | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3ed01ec..617d8b4a 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4320,7 +4320,7 @@ static int ext4_commit_super(struct super_block *sb, int sync)
>  	struct buffer_head *sbh = EXT4_SB(sb)->s_sbh;
>  	int error = 0;
>  
> -	if (!sbh || block_device_ejected(sb))
> +	if (!sbh || !buffer_mapped(sbh) || block_device_ejected(sb))
>  		return error;
>  	if (buffer_write_io_error(sbh)) {
>  		/*

Hmm... error is zero here, so probably need change "return error" to "return EIO".

> @@ -4368,8 +4368,26 @@ static int ext4_commit_super(struct super_block *sb, int sync)
>  	ext4_superblock_csum_set(sb);
>  	mark_buffer_dirty(sbh);
>  	if (sync) {
> -		error = __sync_dirty_buffer(sbh,
> -			test_opt(sb, BARRIER) ? WRITE_FUA : WRITE_SYNC);
> +		lock_buffer(sbh);
> +		/* superblock bh may be invalidated due to drive failure */
> +		if (!buffer_mapped(sbh)) {
> +			unlock_buffer(sbh);
> +			ext4_msg(sb, KERN_ERR, "Can not write superblock "
> +				 "because disk cache was invalidated");
> +			return -EIO;
> +		}
> +		if (test_clear_buffer_dirty(sbh)) {
> +			get_bh(sbh);
> +			sbh->b_end_io = end_buffer_write_sync;
> +			error = submit_bh(test_opt(sb, BARRIER) ?
> +					  WRITE_FUA : WRITE_SYNC, sbh);
> +			wait_on_buffer(sbh);
> +			if (!error && !buffer_uptodate(sbh))
> +				error = -EIO;
> +		} else {
> +			unlock_buffer(sbh);
> +		}
> +

Instead of replicating all of __sync_dirty_buffer() here, we should
just add a check to __sync_dirty_buffer() and have it return EIO if
bh->bdev is NULL.  (Which I think is a better check than checking
buffer_mapped).

						- Ted
