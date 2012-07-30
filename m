From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 0/8] Set bi_rw when alloc bio before call bio_add_page.
Date: Mon, 30 Jul 2012 11:39:35 -0400
Message-ID: <20120730153935.GE4547@phenom.dumpdata.com>
References: <201207301514247032532@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe <axboe@kernel.dk>, "chris.mason" <chris.mason@fusionio.com>,
	viro <viro@ZenIV.linux.org.uk>, tytso <tytso@mit.edu>,
	"adilger.kernel" <adilger.kernel@dilger.ca>,
	shaggy <shaggy@kernel.org>, mfasheh <mfasheh@suse.com>,
	jlbec <jlbec@evilplan.org>, bpm <bpm@sgi.com>,
	elder <elder@kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	jfs-discussion <jfs-discussion@lists.sourceforge.net>,
	ocfs2-devel <ocfs2-devel@oss.oracle.com>, xfs <xfs@oss.sgi.com>
To: majianpeng <majianpeng@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:39401 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab2G3PtO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jul 2012 11:49:14 -0400
Content-Disposition: inline
In-Reply-To: <201207301514247032532@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 30, 2012 at 03:14:28PM +0800, majianpeng wrote:
> When exec bio_alloc, the bi_rw is zero.But after calling bio_add_page,

What about submit_bio? That sets the bi_rw as well?
> it will use bi_rw.
> Fox example, in functiion __bio_add_page,it will call merge_bvec_fn().

function.
> The merge_bvec_fn of raid456 will use the bi_rw to judge the merge.
> >> if ((bvm->bi_rw & 1) == WRITE)
> >> return biovec->bv_len; /* always allow writes to be mergeable */

So what does that mean? Without this patch what happens?

> 
> 
> Jianpeng Ma (8):

Can you collapse all of this in just one patch?

>   Evalue bio->bi_rw after calling bio_alloc() and before calling

It is 'evaluate'
>     bio_add_page().
>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>     bio_add_page().
>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>     bio_add_page().
>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>     bio_add_page().
>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>     bio_add_page().
>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>     bio_add_page().
>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>     bio_add_page().
>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>     bio_add_page().
> 
>  block/blk-lib.c                     |    1 +
>  drivers/block/xen-blkback/blkback.c |    1 +

I am not really sure if that is correct. Does 'submit_bio' not do the
job properly?

>  fs/btrfs/check-integrity.c          |    1 +
>  fs/direct-io.c                      |    1 +
>  fs/ext4/page-io.c                   |    1 +
>  fs/jfs/jfs_metapage.c               |    1 +
>  fs/ocfs2/cluster/heartbeat.c        |    8 +++++---
>  fs/xfs/xfs_aops.c                   |    2 ++
>  fs/xfs/xfs_buf.c                    |    1 +
>  9 files changed, 14 insertions(+), 3 deletions(-)
> 
> -- 
> 1.7.9.5
