From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [patch]ext4: add block plug for .writepages
Date: Sun, 09 Oct 2011 14:09:59 +0800
Message-ID: <1318140599.22361.64.camel@sli10-conroe>
References: <1317004226.29510.172.camel@sli10-conroe>
	 <20110926073025.GB21079@infradead.org>
	 <1317022727.29510.175.camel@sli10-conroe>
	 <20110926094554.GA30827@infradead.org>
	 <1317179380.22361.8.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	lkml <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>, Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:11418 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab1JIGD5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Oct 2011 02:03:57 -0400
In-Reply-To: <1317179380.22361.8.camel@sli10-conroe>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2011-09-28 at 11:09 +0800, Shaohua Li wrote:
> On Mon, 2011-09-26 at 17:45 +0800, Christoph Hellwig wrote:
> > On Mon, Sep 26, 2011 at 03:38:47PM +0800, Shaohua Li wrote:
> > > On Mon, 2011-09-26 at 15:30 +0800, Christoph Hellwig wrote:
> > > > On Mon, Sep 26, 2011 at 10:30:26AM +0800, Shaohua Li wrote:
> > > > > Some filesystems implement .writepages. We don't have blk plug
> > > > > in such filesystems for .writepages.
> > > > 
> > > > Please add the plugging in the actual ->writepages instances.
> > > there are several filesystems have ->writepages. Can you share an hint
> > > why we don't add plugging in the do_writepages?
> > 
> > Because do_writepages is completely generic code with no knowledge of
> > block I/O.  I really don't want to have block plugging be intimately
> > tied into core VM/writeback code all over.  We've been there with
> > ->sync_page, and it was a major pain - nevermind the additional (small)
> > overhead for the not block based filesystems.
> I searched a little bit, looks only ext4 need it. here is the patch.
> 
> 
> Add block plug for ext4 .writepages. Though ext4 .writepages
> already handles request merge very well, block plug is still
> helpful to reduce block lock contention.
> 
ping


> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> ---
>  fs/ext4/inode.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux/fs/ext4/inode.c
> ===================================================================
> --- linux.orig/fs/ext4/inode.c	2011-09-28 10:13:50.000000000 +0800
> +++ linux/fs/ext4/inode.c	2011-09-28 10:23:31.000000000 +0800
> @@ -2046,6 +2046,7 @@ static int ext4_da_writepages(struct add
>  	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
>  	pgoff_t done_index = 0;
>  	pgoff_t end;
> +	struct blk_plug plug;
>  
>  	trace_ext4_da_writepages(inode, wbc);
>  
> @@ -2124,6 +2125,7 @@ retry:
>  	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
>  		tag_pages_for_writeback(mapping, index, end);
>  
> +	blk_start_plug(&plug);
>  	while (!ret && wbc->nr_to_write > 0) {
>  
>  		/*
> @@ -2188,6 +2190,7 @@ retry:
>  			 */
>  			break;
>  	}
> +	blk_finish_plug(&plug);
>  	if (!io_done && !cycled) {
>  		cycled = 1;
>  		index = 0;
> 


