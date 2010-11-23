From: Jan Kara <jack@suse.cz>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Tue, 23 Nov 2010 14:32:08 +0100
Message-ID: <20101123133208.GH6113@quack.suse.cz>
References: <4CE362B0.6040607@redhat.com>
 <20101117061057.GA3989@amd>
 <20101118030613.GQ3290@thunk.org>
 <20101117192900.da859ac7.akpm@linux-foundation.org>
 <20101118060000.GA3509@amd>
 <20101117222834.2bb36ee1.akpm@linux-foundation.org>
 <20101119004552.GF5004@quack.suse.cz>
 <20101119051619.GE3284@amd>
 <20101122181655.GF5012@quack.suse.cz>
 <20101123080758.GA3364@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Ted Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101123080758.GA3364@amd>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 23-11-10 19:07:58, Nick Piggin wrote:
> On Mon, Nov 22, 2010 at 07:16:55PM +0100, Jan Kara wrote:
> > On Fri 19-11-10 16:16:19, Nick Piggin wrote:
> > > On Fri, Nov 19, 2010 at 01:45:52AM +0100, Jan Kara wrote:
> > > > On Wed 17-11-10 22:28:34, Andrew Morton wrote:
> > > > > The fact that a call to ->write_begin can randomly return with s_umount
> > > > > held, to be randomly released at some random time in the future is a
> > > > > bit ugly, isn't it?  write_begin is a pretty low-level, per-inode
> > > > > thing.
> > > >   I guess you missed that writeback_inodes_sb_nr() (called from _if_idle
> > > > variants) does:
> > > >         bdi_queue_work(sb->s_bdi, &work);
> > > >         wait_for_completion(&done);
> > > >   So we return only after all the IO has been submitted and unlock s_umount
> > > > in writeback_inodes_sb_if_idle(). And we cannot really submit the IO ourselves
> > > > because we are holding i_mutex and we need to get and put references
> > > > to other inodes while doing writeback (those would be really horrible lock
> > > > dependencies - writeback thread can put the last reference to an unlinked
> > > > inode...).
> > > 
> > > But if we're waiting for it, with the lock held, then surely it can
> > > deadlock just the same as if we submit it ourself?
> >   Yes, that's what I realized as well and what needs fixing. It was an
> > unintentional consequence of locking changes Christoph did to the writeback
> > code to fix other races.
> > 
> > > BTW. are you taking i_mutex inside writeback? I mutex can be held
> > > while entering page reclaim, and thus writepage... so it could be a
> > > bug too.
> >   No, writeback does not need i_mutex.
> 
> I did in fact see i_mutex from writeback, which is how the lock order
> reversal was noticed in the first place. I haven't had much luck in
> reproducing it yet. It did come from end_io_work, I believe.
> 
> There is another deadlock in here, by the looks (although this is not
> the one which triggers lockdep -- the workqueue coupling means it
> defeats lockdep detection).
> 
> Buffered write holds i_lock, and waits for inode writeback submission,
> but the work queue seems to be blocked on i_mutex (ext4_end_io_work),
> and so it deadlocks.
  Ah, I see. That's a new thing introduced by Ted's rewrite of
ext4_writepages() - bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc. And indeed it
introduced a deadlock as you describe...

								Honza

> Note that this is an AA deadlock, different from ABBA one relating to
> s_umount lock (but very similar call chains IIRC).
> 
> 
> [  748.406457] SysRq : Show Blocked State
> [  748.406685]   task                        PC stack   pid father
> [  748.406868] kworker/9:1   D 0000000000000000  6296   118      2
> 0x00000000
> [  748.407173]  ffff88012acb3c90 0000000000000046 0000000000000000
> ffff88012b1cec80
> [  748.407686]  0000000000000002 ffff88012acb2000 ffff88012acb2000
> 000000000000d6c8
> [  748.408200]  ffff88012acb2010 ffff88012acb3fd8 ffff880129c7dd00
> ffff88012b1cec80
> [  748.408711] Call Trace:
> [  748.408866]  [<ffffffff81039431>] ? get_parent_ip+0x11/0x50
> [  748.409033]  [<ffffffff8160145c>] __mutex_lock_common+0x18c/0x480
> [  748.409205]  [<ffffffffa0042147>] ? ext4_end_io_work+0x37/0xb0 [ext4]
> [  748.409379]  [<ffffffffa0042147>] ? ext4_end_io_work+0x37/0xb0 [ext4]
> [  748.409546]  [<ffffffff8160182e>] mutex_lock_nested+0x3e/0x50
> [  748.409717]  [<ffffffffa0042147>] ext4_end_io_work+0x37/0xb0 [ext4]
> [  748.409883]  [<ffffffff81068378>] process_one_work+0x1b8/0x5a0
> [  748.410046]  [<ffffffff8106830e>] ? process_one_work+0x14e/0x5a0
> [  748.410219]  [<ffffffffa0042110>] ? ext4_end_io_work+0x0/0xb0 [ext4]
> [  748.410386]  [<ffffffff81069675>] worker_thread+0x175/0x3a0
> [  748.410549]  [<ffffffff81069500>] ? worker_thread+0x0/0x3a0
> [  748.410712]  [<ffffffff8106e246>] kthread+0x96/0xa0
> [  748.410874]  [<ffffffff81003ed4>] kernel_thread_helper+0x4/0x10
> [  748.411038]  [<ffffffff81039878>] ? finish_task_switch+0x78/0x110
> [  748.411202]  [<ffffffff816036c0>] ? restore_args+0x0/0x30
> [  748.411364]  [<ffffffff8106e1b0>] ? kthread+0x0/0xa0
> [  748.411524]  [<ffffffff81003ed0>] ? kernel_thread_helper+0x0/0x10
> [  748.606853] dbench        D 0000000000000000  2872  2916      1
> 0x00000004
> [  748.607154]  ffff880129ec58b8 0000000000000046 ffff880129ec5838
> ffffffff810806fd
> [  748.607665]  ffff880129ec5898 ffff880129ec4000 ffff880129ec4000
> 000000000000d6c8
> [  748.608176]  ffff880129ec4010 ffff880129ec5fd8 ffff88010a2d0000
> ffff88011ff69f00
> [  748.608686] Call Trace:
> [  748.608837]  [<ffffffff810806fd>] ? trace_hardirqs_off+0xd/0x10
> [  748.609001]  [<ffffffff81600bb5>] schedule_timeout+0x1f5/0x350
> [  748.609164]  [<ffffffff8108380b>] ? mark_held_locks+0x6b/0xa0
> [  748.609328]  [<ffffffff8160314b>] ? _raw_spin_unlock_irq+0x2b/0x60
> [  748.609493]  [<ffffffff81039431>] ? get_parent_ip+0x11/0x50
> [  748.609656]  [<ffffffff81606c3d>] ? sub_preempt_count+0x9d/0xd0
> [  748.609820]  [<ffffffff815ffacd>] wait_for_common+0x10d/0x190
> [  748.609984]  [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
> [  748.610149]  [<ffffffff81602ec9>] ? _raw_spin_unlock_bh+0x39/0x40
> [  748.610314]  [<ffffffff815ffbf8>] wait_for_completion+0x18/0x20
> [  748.610479]  [<ffffffff8113d1e7>] writeback_inodes_sb_nr+0xf7/0x120
> [  748.610646]  [<ffffffff8113d68d>] writeback_inodes_sb+0x4d/0x60
> [  748.610811]  [<ffffffff8113d6d2>] ?
> writeback_inodes_sb_if_idle+0x32/0x60
> [  748.610978]  [<ffffffff8113d6da>]
> writeback_inodes_sb_if_idle+0x3a/0x60
> [  748.611153]  [<ffffffffa003fefd>] ext4_da_write_begin+0x20d/0x310
> [ext4]
> [  748.611321]  [<ffffffff810cbbf4>]
> generic_file_buffered_write+0x114/0x2a0
> 
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
