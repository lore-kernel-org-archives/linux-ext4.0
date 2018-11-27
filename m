Return-Path: <SRS0=F3Rs=OG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41296 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726287AbeK0Wk3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 27 Nov 2018 17:40:29 -0500
Date: Tue, 27 Nov 2018 12:42:49 +0100
From: Jan Kara <jack@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC] Ext4: fix deadlock on dirty pages between fault and
 writeback
Message-ID: <20181127114249.GH16301@quack2.suse.cz>
References: <1540858969-75803-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540858969-75803-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

CCed fsdevel since this may be interesting to other filesystem developers
as well.

On Tue 30-10-18 08:22:49, Liu Bo wrote:
> mpage_prepare_extent_to_map() tries to build up a large bio to stuff down
> the pipe.  But if it needs to wait for a page lock, it needs to make sure
> and send down any pending writes so we don't deadlock with anyone who has
> the page lock and is waiting for writeback of things inside the bio.

Thanks for report! I agree the current code has a deadlock possibility you
describe. But I think the problem reaches a bit further than what your
patch fixes.  The problem is with pages that are unlocked but have
PageWriteback set.  Page reclaim may end up waiting for these pages and
thus any memory allocation with __GFP_FS set can block on these. So in our
current setting page writeback must not block on anything that can be held
while doing memory allocation with __GFP_FS set. Page lock is just one of
these possibilities, wait_on_page_writeback() in
mpage_prepare_extent_to_map() is another suspect and there mat be more. Or
to say it differently, if there's lock A and GFP_KERNEL allocation can
happen under lock A, then A cannot be taken by the writeback path. This is
actually pretty subtle deadlock possibility and our current lockdep
instrumentation isn't going to catch this.

So I see two ways how to fix this properly:

1) Change ext4 code to always submit the bio once we have a full page
prepared for writing. This may be relatively simple but has a higher CPU
overhead for bio allocation & freeing (actual IO won't really differ since
the plugging code should take care of merging the submitted bios). XFS
seems to be doing this.

2) Change the code to unlock the page only when we submit the bio.

								Honza
> The related lock stack is shown as follows,
> 
> task1:
> [<ffffffff811aaa52>] wait_on_page_bit+0x82/0xa0
> [<ffffffff811c5777>] shrink_page_list+0x907/0x960
> [<ffffffff811c6027>] shrink_inactive_list+0x2c7/0x680
> [<ffffffff811c6ba4>] shrink_node_memcg+0x404/0x830
> [<ffffffff811c70a8>] shrink_node+0xd8/0x300
> [<ffffffff811c73dd>] do_try_to_free_pages+0x10d/0x330
> [<ffffffff811c7865>] try_to_free_mem_cgroup_pages+0xd5/0x1b0
> [<ffffffff8122df2d>] try_charge+0x14d/0x720
> [<ffffffff812320cc>] memcg_kmem_charge_memcg+0x3c/0xa0
> [<ffffffff812321ae>] memcg_kmem_charge+0x7e/0xd0
> [<ffffffff811b68a8>] __alloc_pages_nodemask+0x178/0x260
> [<ffffffff8120bff5>] alloc_pages_current+0x95/0x140
> [<ffffffff81074247>] pte_alloc_one+0x17/0x40
> [<ffffffff811e34de>] __pte_alloc+0x1e/0x110
> [<ffffffffa06739de>] alloc_set_pte+0x5fe/0xc20
> [<ffffffff811e5d93>] do_fault+0x103/0x970
> [<ffffffff811e6e5e>] handle_mm_fault+0x61e/0xd10
> [<ffffffff8106ea02>] __do_page_fault+0x252/0x4d0
> [<ffffffff8106ecb0>] do_page_fault+0x30/0x80
> [<ffffffff8171bce8>] page_fault+0x28/0x30
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> task2:
> [<ffffffff811aadc6>] __lock_page+0x86/0xa0
> [<ffffffffa02f1e47>] mpage_prepare_extent_to_map+0x2e7/0x310 [ext4]
> [<ffffffffa08a2689>] ext4_writepages+0x479/0xd60
> [<ffffffff811bbede>] do_writepages+0x1e/0x30
> [<ffffffff812725e5>] __writeback_single_inode+0x45/0x320
> [<ffffffff81272de2>] writeback_sb_inodes+0x272/0x600
> [<ffffffff81273202>] __writeback_inodes_wb+0x92/0xc0
> [<ffffffff81273568>] wb_writeback+0x268/0x300
> [<ffffffff81273d24>] wb_workfn+0xb4/0x390
> [<ffffffff810a2f19>] process_one_work+0x189/0x420
> [<ffffffff810a31fe>] worker_thread+0x4e/0x4b0
> [<ffffffff810a9786>] kthread+0xe6/0x100
> [<ffffffff8171a9a1>] ret_from_fork+0x41/0x50
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> task1 is waiting for the PageWriteback bit of the page that task2 has
> collected in mpd->io_submit->io_bio, and tasks2 is waiting for the LOCKED
> bit the page which tasks1 has locked.
> 
> It seems that this deadlock only happens when those pages are mapped pages
> so that mpage_prepare_extent_to_map() can have pages queued in io_bio and
> when waiting to lock the subsequent page.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---
> 
> Only did build test.
> 
>  fs/ext4/inode.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c3d9a42c561e..becbfb292bf0 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2681,7 +2681,26 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
>  			if (mpd->map.m_len > 0 && mpd->next_page != page->index)
>  				goto out;
>  
> -			lock_page(page);
> +			if (!trylock_page(page)) {
> +				/*
> +				 * A rare race may happen between fault and
> +				 * writeback,
> +				 *
> +				 * 1. fault may have raced in and locked this
> +				 * page ahead of us, and if fault needs to
> +				 * reclaim memory via shrink_page_list(), it may
> +				 * also wait on the writeback pages we've
> +				 * collected in our mpd->io_submit.
> +				 *
> +				 * 2. We have to submit mpd->io_submit->io_bio
> +				 * to let memory reclaim make progress in order
> +				 * to avoid the deadlock between fault and
> +				 * ourselves(writeback).
> +				 */
> +				ext4_io_submit(&mpd->io_submit);
> +				lock_page(page);
> +			}
> +
>  			/*
>  			 * If the page is no longer dirty, or its mapping no
>  			 * longer corresponds to inode we are writing (which
> -- 
> 1.8.3.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
