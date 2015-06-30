From: Michal Hocko <mhocko@suse.cz>
Subject: Re: Lockup in wait_transaction_locked under memory pressure
Date: Tue, 30 Jun 2015 16:31:58 +0200
Message-ID: <20150630143158.GD4578@dhcp22.suse.cz>
References: <558BD447.1010503@kyup.com>
 <558BD507.9070002@kyup.com>
 <20150625112116.GC17237@dhcp22.suse.cz>
 <558BE96E.7080101@kyup.com>
 <20150625115025.GD17237@dhcp22.suse.cz>
 <20150625133138.GH14324@thunk.org>
 <5591097D.6010602@kyup.com>
 <20150629093640.GD28471@dhcp22.suse.cz>
 <20150630015206.GL22807@dastard>
 <20150630123033.GB4578@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nikolay Borisov <kernel@kyup.com>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Marian Marinov <mm@1h.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbbF3OcA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Jun 2015 10:32:00 -0400
Content-Disposition: inline
In-Reply-To: <20150630123033.GB4578@dhcp22.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 30-06-15 14:30:33, Michal Hocko wrote:
> On Tue 30-06-15 11:52:06, Dave Chinner wrote:
> > On Mon, Jun 29, 2015 at 11:36:40AM +0200, Michal Hocko wrote:
> > > On Mon 29-06-15 12:01:49, Nikolay Borisov wrote:
> > > > Today I observed the issue again, this time on a different server. What
> > > > is particularly strange is the fact that the OOM wasn't triggered for
> > > > the cgroup, whose tasks have entered D state. There were a couple of
> > > > SSHD processes and an RSYNC performing some backup tasks. Here is what
> > > > the stacktrace for the rsync looks like:
> > > > 
> > > > crash> set 18308
> > > >     PID: 18308
> > > > COMMAND: "rsync"
> > > >    TASK: ffff883d7c9b0a30  [THREAD_INFO: ffff881773748000]
> > > >     CPU: 1
> > > >   STATE: TASK_UNINTERRUPTIBLE
> > > > crash> bt
> > > > PID: 18308  TASK: ffff883d7c9b0a30  CPU: 1   COMMAND: "rsync"
> > > >  #0 [ffff88177374ac60] __schedule at ffffffff815ab152
> > > >  #1 [ffff88177374acb0] schedule at ffffffff815ab76e
> > > >  #2 [ffff88177374acd0] schedule_timeout at ffffffff815ae5e5
> > > >  #3 [ffff88177374ad70] io_schedule_timeout at ffffffff815aad6a
> > > >  #4 [ffff88177374ada0] bit_wait_io at ffffffff815abfc6
> > > >  #5 [ffff88177374adb0] __wait_on_bit at ffffffff815abda5
> > > >  #6 [ffff88177374ae00] wait_on_page_bit at ffffffff8111fd4f
> > > >  #7 [ffff88177374ae50] shrink_page_list at ffffffff81135445
> > > 
> > > This is most probably wait_on_page_writeback because the reclaim has
> > > encountered a dirty page which is under writeback currently.
> > 
> > Yes, and looks at the caller path....
> > 
> > > >  #8 [ffff88177374af50] shrink_inactive_list at ffffffff81135845
> > > >  #9 [ffff88177374b060] shrink_lruvec at ffffffff81135ead
> > > > #10 [ffff88177374b150] shrink_zone at ffffffff811360c3
> > > > #11 [ffff88177374b220] shrink_zones at ffffffff81136eff
> > > > #12 [ffff88177374b2a0] do_try_to_free_pages at ffffffff8113712f
> > > > #13 [ffff88177374b300] try_to_free_mem_cgroup_pages at ffffffff811372be
> > > > #14 [ffff88177374b380] try_charge at ffffffff81189423
> > > > #15 [ffff88177374b430] mem_cgroup_try_charge at ffffffff8118c6f5
> > > > #16 [ffff88177374b470] __add_to_page_cache_locked at ffffffff8112137d
> > > > #17 [ffff88177374b4e0] add_to_page_cache_lru at ffffffff81121618
> > > > #18 [ffff88177374b510] pagecache_get_page at ffffffff8112170b
> > > > #19 [ffff88177374b560] grow_dev_page at ffffffff811c8297
> > > > #20 [ffff88177374b5c0] __getblk_slow at ffffffff811c91d6
> > > > #21 [ffff88177374b600] __getblk_gfp at ffffffff811c92c1
> > > > #22 [ffff88177374b630] ext4_ext_grow_indepth at ffffffff8124565c
> > > > #23 [ffff88177374b690] ext4_ext_create_new_leaf at ffffffff81246ca8
> > > > #24 [ffff88177374b6e0] ext4_ext_insert_extent at ffffffff81246f09
> > > > #25 [ffff88177374b750] ext4_ext_map_blocks at ffffffff8124a848
> > > > #26 [ffff88177374b870] ext4_map_blocks at ffffffff8121a5b7
> > > > #27 [ffff88177374b910] mpage_map_one_extent at ffffffff8121b1fa
> > > > #28 [ffff88177374b950] mpage_map_and_submit_extent at ffffffff8121f07b
> > > > #29 [ffff88177374b9b0] ext4_writepages at ffffffff8121f6d5
> > > > #30 [ffff88177374bb20] do_writepages at ffffffff8112c490
> > > > #31 [ffff88177374bb30] __filemap_fdatawrite_range at ffffffff81120199
> > > > #32 [ffff88177374bb80] filemap_flush at ffffffff8112041c
> > 
> > That's a potential self deadlocking path, isn't it? i.e. the
> > writeback path has been entered, may hold pages locked in the
> > current bio being built (waiting for submission), then memory
> > reclaim has been entered while trying to map more contiguous blocks
> > to submit, and that waits on page IO to complete on a page in a bio
> > that ext4 hasn't yet submitted?
> 
> I am not sure I understand. Pages are marked writeback in
> ext4_bio_write_page after all of this has been done already and then
> the IO is submitted and the reclaim shouldn't block it. Or am I missing
> something?

Thanks to Jan Kara for the off list clarification. I misunderstood the
code. You are right ext4 is really deadlock prone. The heuristic in the
reclaim code assumes that waiting on page_writeback is guaranteed to
make a progress (from memcg POV) and that is not true for ext4 as it
really charge after set_page_writeback (called from ext4_bio_write_page)
and before the page is really submitted (when the bio is full or
explicitly via ext4_io_submit). I thought that io_submit_add_bh submits
the page but it doesn't do that necessarily.

Now the question is how to handle that. We cannot simply remove the
heuristic because that would reintroduce premature OOM issues. I guess
we can make it depend on __GFP_FS. This could lead to premature charge
failure but that should be toleratable. I will cook up a patch.

Thanks!
-- 
Michal Hocko
SUSE Labs
