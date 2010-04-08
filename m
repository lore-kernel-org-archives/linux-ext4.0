From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: don't scan/accumulate more pages than mballoc will
 allocate
Date: Wed, 07 Apr 2010 21:31:11 -0500
Message-ID: <4BBD3FEF.30501@redhat.com>
References: <4BB9F6C3.5000001@redhat.com> <1270692619-16629-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab0DHCbR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Apr 2010 22:31:17 -0400
In-Reply-To: <1270692619-16629-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> From: From: Eric Sandeen <sandeen@redhat.com>
> 
> There was a bug reported on RHEL5 that a 10G dd on a 12G box
> had a very, very slow sync after that.
> 
> At issue was the loop in write_cache_pages scanning all the way
> to the end of the 10G file, even though the subsequent call
> to mpage_da_submit_io would only actually write a smallish amt; then
> we went back to the write_cache_pages loop ... wasting tons of time
> in calling __mpage_da_writepage for thousands of pages we would
> just revisit (many times) later.
> 
> Upstream it's not such a big issue for sys_sync because we get
> to the loop with a much smaller nr_to_write, which limits the loop.
> 
> However, talking with Aneesh he realized that fsync upstream still
> gets here with a very large nr_to_write and we face the same problem.
> 
> This patch makes mpage_add_bh_to_extent stop the loop after we've
> accumulated 2048 pages, by setting mpd->io_done = 1; which ultimately
> causes the write_cache_pages loop to break.
> 
> Repeating the test with a dirty_ratio of 80 (to leave something for
> fsync to do), I don't see huge IO performance gains, but the reduction
> in cpu usage is striking: 80% usage with stock, and 2% with the
> below patch.  Instrumenting the loop in write_cache_pages clearly
> shows that we are wasting time here.
> 
> Eventually we need to change mpage_da_map_pages() also submit its I/O
> to the block layer, subsuming mpage_da_submit_io(), and then change it
> call ext4_get_blocks() multiple times.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> 
> This is the slightly revised version of Eric's patch that I've added to
> the ext4 patch queue. -- Ted

Seems fine, thanks.

-Eric

>  fs/ext4/inode.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5c6ca10..2c12926 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2349,6 +2349,15 @@ static void mpage_add_bh_to_extent(struct mpage_da_data *mpd,
>  	sector_t next;
>  	int nrblocks = mpd->b_size >> mpd->inode->i_blkbits;
>  
> +	/* 
> +	 * XXX Don't go larger than mballoc is willing to allocate
> +	 * This is a stopgap solution.  We eventually need to fold
> +	 * mpage_da_submit_io() into this function and then call
> +	 * ext4_get_blocks() multiple times in a loop
> +	 */
> +	if (nrblocks >= 8*1024*1024/mpd->inode->i_sb->s_blocksize)
> +		goto flush_it;
> +
>  	/* check if thereserved journal credits might overflow */
>  	if (!(EXT4_I(mpd->inode)->i_flags & EXT4_EXTENTS_FL)) {
>  		if (nrblocks >= EXT4_MAX_TRANS_DATA) {

