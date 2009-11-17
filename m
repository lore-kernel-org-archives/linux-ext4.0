From: Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] ext2: clear uptodate flag on super block I/O error
Date: Tue, 17 Nov 2009 03:08:21 +0100
Message-ID: <20091117020821.GF5818@wotan.suse.de>
References: <20091111123340.703f5c86@nehalam> <200911112234.24180.elendil@planet.nl> <20091113144727.575cf038@nehalam> <20091113150719.9d31dde2.akpm@linux-foundation.org> <20091116160449.3fc5e958@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
	jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453AbZKQCIT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Nov 2009 21:08:19 -0500
Content-Disposition: inline
In-Reply-To: <20091116160449.3fc5e958@nehalam>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 16, 2009 at 04:04:49PM -0800, Stephen Hemminger wrote:
> This fixes a WARN backtrace in mark_buffer_dirty() that occurs during
> unmount when a USB or floppy device is removed. I reported this a kernel
> regression, but looks like it might have been there for longer
> than that.
> 
> The super block update from a previous operation has marked the buffer
> as in error, and the flag has to be cleared before doing the update.
> (Similar code already exists in ext4).
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> --- a/fs/ext2/super.c	2009-11-16 15:55:36.399078475 -0800
> +++ b/fs/ext2/super.c	2009-11-16 15:59:49.814765923 -0800
> @@ -1121,8 +1121,20 @@ static void ext2_sync_super(struct super
>  static int ext2_sync_fs(struct super_block *sb, int wait)
>  {
>  	struct ext2_super_block *es = EXT2_SB(sb)->s_es;
> +	struct buffer_head *sbh = EXT2_SB(sb)->s_sbh;
>  
>  	lock_kernel();
> +	if (buffer_write_io_error(sbh)) {
> +		/*
> +		 * This happens if USB or floppy device is yanked out.
> +		 * Maybe user put device back in so warn and update again.
> +		 */
> +		printk(KERN_ERR
> +		       "EXT2-fs: previous I/O error to superblock detected\n");
> +		clear_buffer_write_io_error(sbh);
> +		set_buffer_uptodate(sbh);
> +	}
> +
>  	if (es->s_state & cpu_to_le16(EXT2_VALID_FS)) {
>  		ext2_debug("setting valid to 0\n");
>  		es->s_state &= cpu_to_le16(~EXT2_VALID_FS);

I think the real fix is to avoid clearing uptodate in case of io errors.
For read io errors, the buffer/page should not have been uptodate to
start with, and for write io errors, an error writing back the buffer
does not mean it is somehow no longer the most uptodate copy of the data.

Higher level policy about IO errors (whether to retry, ignore, throw
out the data, etc) would be nice to implement properly too, but that is
not really the job of the low level cache and IO routines.

I proposed some patches a while back but didn't get much interest.
Maybe I should just ask someone to merge them.

