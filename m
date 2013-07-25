From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Remove extent tree purging from
 ext4_da_page_release_reservation()
Date: Thu, 25 Jul 2013 16:05:28 +0200
Message-ID: <20130725140528.GD9388@quack.suse.cz>
References: <1374099015-6829-1-git-send-email-jack@suse.cz>
 <20130719004439.GA21615@gmail.com>
 <20130724200536.GC27307@quack.suse.cz>
 <20130725115234.GA26044@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450Ab3GYOFc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Jul 2013 10:05:32 -0400
Content-Disposition: inline
In-Reply-To: <20130725115234.GA26044@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 25-07-13 19:52:34, Zheng Liu wrote:
> On Wed, Jul 24, 2013 at 10:05:36PM +0200, Jan Kara wrote:
> >   Hi Zheng,
> > 
> > On Fri 19-07-13 08:44:39, Zheng Liu wrote:
> > > On Thu, Jul 18, 2013 at 12:10:15AM +0200, Jan Kara wrote:
> > > > ext4_da_page_release_reservation() gets called from
> > > > ext4_da_invalidatepage(). This function is used when we are truncating
> > > > page cache for punch hole or truncate operations. In either case these
> > > > operations take care of removing extents from the extent tree. This is
> > > > more efficient and the code in ext4_da_page_release_reservation() is
> > > > actually buggy anyway. So just remove it.
> > > 
> > > I remember that I try to remove the entry from extent status tree here
> > > because at the end of this function it tries to relase the reserved
> > > space for delalloc.  For 4k block we can simply release it because
> > > ->s_cluster_ratio == 1.  But when bigalloc is enabled, we need to
> > > determine whether we can release the reserved space according to the
> > > result of ext4_find_delalloc_cluster() as the comment described.  If we
> > > don't remove the entry from extent status tree here, we could lost some
> > > spaces that could be reused by other files.  If I remember correctly, I
> > > have hitted a warning message when I run xfstests to test it.  These
> > > days I try to trigger it using xfstests but I failed.  Have you seen a
> > > prblem that is caused by this code?  Maybe we need to refactor out the
> > > code and release the reserved space outside this function.
> >   Ah, I see. No, I didn't observe any problem due to this code, I just
> > didn't understand why is it there. Also when blocksize < pagesize, the code
> > is wrong because delayed buffers to release need not be contiguous so
> > ext4_es_remove_extent(inode, lblk, to_release) may not free all the buffers
> > we want. But subsequent extent tree truncation in ext4_ext_truncate() hides
> > this problem.
> > 
> > So I think we might just change the condition:
> > 
> > if (to_release) {
> > 
> > to
> > 
> > if (to_release && sbi->s_cluster_ratio > 1) {
> > 
> > and add explanatory comment why cluster_ratio > 1 needs the truncation and
> > other cases don't. It will also save some needlessly burned CPU cycles
> > spent when manipulating extent tree.
> 
> Yes, thanks for pointing it out.  I attach a patch below.  Could you
> please review it?
  Thanks for writing the patch! It looks good. BTW, feel free to take
authorship of it.  I've just pointed out the problem. One typo correction
below:


> Subject: [PATCH 1/2] ext4: remove the entry from es tree when bigalloc is enabled
> 
> From: Jan Kara <jack@suse.cz>
> 
> Now in ext4_da_page_release_reservation() we remove the entry from es
> tree if to_release != 0.  But there are two issues.  One is that it is
> wrong when blocksize != pagesize, another is that we don't need to do
> this if ->s_cluster_ratio == 1 because we will remove the entry in
> ext4_truncate/ext4_punch_hole.  Here we need to do this just because
> when ->s_cluster_ratio > 1 we will determine whether we can release
> the reserved space according to ext4_find_delalloc_cluster().
> 
> This commit tries to fix these problems.  Now we remove the entry from
> es tree only if ->s_cluster_ratio > 1.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  fs/ext4/inode.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ba33c67..e0c8623 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1387,7 +1387,15 @@ static void ext4_da_page_release_reservation(struct page *page,
>  		curr_off = next_off;
>  	} while ((bh = bh->b_this_page) != head);
>  
> -	if (to_release) {
> +	/*
> +	 * Here we need to remove the entry from es tree because when bigalloc
> +	 * is enabled we need to determine whether we can release the reserved
> +	 * space according to the result of ext4_find_delalloc_cluster().
> +	 *
> +	 * If bigalloc is disabled, we don't need to do this here because these
> +	 * extries in es tree will be removed in ext4_truncate/ext4_punch_hole.
           ^^^ entries

> +	 */
> +	if (sbi->s_cluster_ratio > 1 && to_release) {
>  		lblk = page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
>  		ext4_es_remove_extent(inode, lblk, to_release);
>  	}

							Honza
--
Jan Kara <jack@suse.cz>
SUSE Labs, CR
