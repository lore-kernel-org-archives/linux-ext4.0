From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [EXT4 set 5][PATCH 1/1] expand inode i_extra_isize to support
	features in larger inode
Date: Sun, 15 Jul 2007 21:21:03 +0200
Message-ID: <1184527263.5284.110.camel@lappy>
References: <1183275482.4010.133.camel@localhost.localdomain>
	 <20070710163247.5c8bfa3f.akpm@linux-foundation.org>
	 <20070713020529.1486491f.akpm@linux-foundation.org>
	 <1184333621.20032.85.camel@twins>
	 <20070713121259.20066d5b.akpm@linux-foundation.org>
	 <20070713214746.GH23255@mami.zabbo.net> <1184504543.5284.96.camel@lappy>
	 <20070715111109.a2775ae4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Zach Brown <zach.brown@oracle.com>, cmm@us.ibm.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
	Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070715111109.a2775ae4.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 2007-07-15 at 11:11 -0700, Andrew Morton wrote:
> On Sun, 15 Jul 2007 15:02:23 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Fri, 2007-07-13 at 14:47 -0700, Zach Brown wrote:
> > 
> > > Peter, do you have any interest in seeing how far we can get
> > > at tracking lock_page()?  I'm not holding my breath, but any little bit
> > > would probably help.
> > 
> > Would this be a valid report? 
> > 
> > ( /me goes hunt a x86_64 unwinder patch that will apply to this tree.
> >   These stacktraces are pain )
> 
> They are.  lockdep reports are a pain too.  It's still a struggle to
> understand wtf they're trying to tell you.  Mabe it's just me.

It got you confused alright,..

> > =======================================================
> > [ INFO: possible circular locking dependency detected ]
> > [ 2.6.22-rt3-dirty #34
> > -------------------------------------------------------
> > mount/1296 is trying to acquire lock:
> >  (&ei->truncate_mutex){--..}, at: [<ffffffff802f75e5>] ext3_get_blocks_handle+0x1a4/0x8f7
> > 
> > but task is already holding lock:
> >  (lock_page_0){--..}, at: [<ffffffff80267107>] generic_file_buffered_write+0x1ee/0x646
> >
> > which lock already depends on the new lock.
> >

So, the offence is trying to acquire &ei->truncate_mutex while already
holding lock_page_0.

These traces show how the previous (reverse) dependancy came into being

> > 
> > the existing dependency chain (in reverse order) is:
> > 
> > -> #1 (lock_page_0){--..}:
> >        [<ffffffff80251b26>] __lock_acquire+0xa72/0xc35
> >        [<ffffffff802520c9>] lock_acquire+0x48/0x61
> >        [<ffffffff80265e22>] add_to_page_cache_lru+0xe/0x23
> >        [<ffffffff80265d31>] add_to_page_cache+0x1de/0x2c1
> >        [<ffffffff80265e22>] add_to_page_cache_lru+0xe/0x23
> >        [<ffffffff80266985>] find_or_create_page+0x4c/0x73
> >        [<ffffffff802ae716>] __getblk+0x118/0x23c
> >        [<ffffffff802afa91>] __bread+0x6/0x9c
> >        [<ffffffff802f382d>] read_block_bitmap+0x34/0x65
> >        [<ffffffff802f3e1b>] ext3_free_blocks_sb+0xec/0x3d4
> >        [<ffffffff802f4131>] ext3_free_blocks+0x2e/0x61
> >        [<ffffffff802f82bc>] ext3_free_data+0xaa/0xda
> >        [<ffffffff802f8976>] ext3_truncate+0x4d2/0x84e
> >        [<ffffffff8026df5a>] pagevec_lookup+0x17/0x1e
> >        [<ffffffff8026e7b1>] truncate_inode_pages_range+0x1f4/0x323
> >        [<ffffffff802614b4>] add_preempt_count+0x14/0xe4
> >        [<ffffffff80304d13>] journal_stop+0x1fe/0x21d
> >        [<ffffffff8027661a>] vmtruncate+0xa2/0xc0
> >        [<ffffffff802a292b>] inode_setattr+0x22/0x10a
> >        [<ffffffff802f9b51>] ext3_setattr+0x136/0x18f
> >        [<ffffffff802a2b1d>] notify_change+0x10a/0x241
> >        [<ffffffff802a2b3b>] notify_change+0x128/0x241
> >        [<ffffffff8028e35e>] do_truncate+0x56/0x7f
> >        [<ffffffff8028e369>] do_truncate+0x61/0x7f
> >        [<ffffffff80296278>] get_write_access+0x3f/0x45
> >        [<ffffffff802973c7>] may_open+0x193/0x1af
> >        [<ffffffff80299869>] open_namei+0x2cb/0x63e
> >        [<ffffffff8025718b>] rt_up_read+0x53/0x5c
> >        [<ffffffff8056da59>] do_page_fault+0x479/0x7cc
> >        [<ffffffff8028dce1>] do_filp_open+0x1c/0x38
> >        [<ffffffff8056a4f9>] rt_spin_unlock+0x17/0x47
> >        [<ffffffff8028da05>] get_unused_fd+0xf9/0x107
> >        [<ffffffff8028dd45>] do_sys_open+0x48/0xd5
> >        [<ffffffff8020950e>] system_call+0x7e/0x83
> >        [<ffffffffffffffff>] 0xffffffffffffffff
> 
> I guess we're doing lock_page() against a blockdev pagecache page here
> while holding truncate_mutex against some S_ISREG file.

So this trace ( -> #1 ) shows how lock_page_0 became to depend on
&ei->truncate_mutex ( -> #0 ).

> > -> #0 (&ei->truncate_mutex){--..}:
> >        [<ffffffff802503b9>] print_circular_bug_header+0xcc/0xd3
> >        [<ffffffff80251a22>] __lock_acquire+0x96e/0xc35
> >        [<ffffffff802520c9>] lock_acquire+0x48/0x61
> >        [<ffffffff802f75e5>] ext3_get_blocks_handle+0x1a4/0x8f7
> >        [<ffffffff8056a6d4>] _mutex_lock+0x26/0x52
> >        [<ffffffff802f75e5>] ext3_get_blocks_handle+0x1a4/0x8f7
> >        [<ffffffff802504b2>] find_usage_backwards+0xb0/0xd9
> >        [<ffffffff802504b2>] find_usage_backwards+0xb0/0xd9
> >        [<ffffffff80250d7c>] debug_check_no_locks_freed+0x11d/0x129
> >        [<ffffffff80250c33>] trace_hardirqs_on_caller+0x115/0x138
> >        [<ffffffff8024efdc>] lockdep_init_map+0xac/0x41f
> >        [<ffffffff802614b4>] add_preempt_count+0x14/0xe4
> >        [<ffffffff802f8035>] ext3_get_block+0xc2/0xe4
> >        [<ffffffff802aeed3>] __block_prepare_write+0x195/0x442
> >        [<ffffffff802f7f73>] ext3_get_block+0x0/0xe4
> >        [<ffffffff802af19a>] block_prepare_write+0x1a/0x25
> >        [<ffffffff802f93e9>] ext3_prepare_write+0xb2/0x17b
> >        [<ffffffff802671b1>] generic_file_buffered_write+0x298/0x646
> >        [<ffffffff8023944e>] current_fs_time+0x3b/0x40
> >        [<ffffffff802614b4>] add_preempt_count+0x14/0xe4
> >        [<ffffffff802678ae>] __generic_file_aio_write_nolock+0x34f/0x3b9
> >        [<ffffffff8024ed3d>] put_lock_stats+0xe/0x2a
> >        [<ffffffff80267964>] generic_file_aio_write+0x4c/0xc4
> >        [<ffffffff80267979>] generic_file_aio_write+0x61/0xc4
> >        [<ffffffff802fcf18>] ext3_orphan_del+0x53/0x19f
> >        [<ffffffff802f5768>] ext3_file_write+0x1c/0x9d
> >        [<ffffffff8028ef31>] do_sync_write+0xcc/0x10f
> >        [<ffffffff80246f9c>] autoremove_wake_function+0x0/0x2e
> >        [<ffffffff8024ecfe>] get_lock_stats+0xe/0x3f
> >        [<ffffffff8024ed9a>] lock_release_holdtime+0x41/0x4f
> >        [<ffffffff8024ed3d>] put_lock_stats+0xe/0x2a
> >        [<ffffffff8028dfb1>] sys_fchmod+0xa3/0xbd
> >        [<ffffffff8056a717>] _mutex_unlock+0x17/0x20
> >        [<ffffffff8028f6cd>] vfs_write+0xb6/0x148
> >        [<ffffffff8028fc61>] sys_write+0x48/0x74
> >        [<ffffffff8020950e>] system_call+0x7e/0x83
> >        [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Here we're taking a file's truncate_mutex while holding lock_page() against
> one of its pages.  This is the correct lock ranking, I suppose.
> 
> This is one of those fairly common cross-inode notabugs, I suspect.

So #0 and #1 are compatible, and build the dependancy:

  &ei->truncate_mutex
     lock_page_0

Then the part you cut out:

> > stack backtrace:
> > 
> > Call Trace:
> >  [<ffffffff8024ffbd>] print_circular_bug_tail+0x69/0x72
> >  [<ffffffff802503b9>] print_circular_bug_header+0xcc/0xd3
> >  [<ffffffff80251a22>] __lock_acquire+0x96e/0xc35
> >  [<ffffffff802520c9>] lock_acquire+0x48/0x61
> >  [<ffffffff802f75e5>] ext3_get_blocks_handle+0x1a4/0x8f7
> >  [<ffffffff8056a6d4>] _mutex_lock+0x26/0x52

Here we take: &ei->truncate_mutex

> >  [<ffffffff802f75e5>] ext3_get_blocks_handle+0x1a4/0x8f7
> >  [<ffffffff802504b2>] find_usage_backwards+0xb0/0xd9
> >  [<ffffffff802504b2>] find_usage_backwards+0xb0/0xd9
> >  [<ffffffff80250d7c>] debug_check_no_locks_freed+0x11d/0x129
> >  [<ffffffff80250c33>] trace_hardirqs_on_caller+0x115/0x138
> >  [<ffffffff8024efdc>] lockdep_init_map+0xac/0x41f
> >  [<ffffffff802614b4>] add_preempt_count+0x14/0xe4
> >  [<ffffffff802f8035>] ext3_get_block+0xc2/0xe4
> >  [<ffffffff802aeed3>] __block_prepare_write+0x195/0x442
> >  [<ffffffff802f7f73>] ext3_get_block+0x0/0xe4
> >  [<ffffffff802af19a>] block_prepare_write+0x1a/0x25
> >  [<ffffffff802f93e9>] ext3_prepare_write+0xb2/0x17b
> >  [<ffffffff802671b1>] generic_file_buffered_write+0x298/0x646

while some path from generic_file_buffered_write() took: lock_page_0
probably __grab_cache_page()
> > 
> >  [<ffffffff8023944e>] current_fs_time+0x3b/0x40
> >  [<ffffffff802614b4>] add_preempt_count+0x14/0xe4
> >  [<ffffffff802678ae>] __generic_file_aio_write_nolock+0x34f/0x3b9
> >  [<ffffffff8024ed3d>] put_lock_stats+0xe/0x2a
> >  [<ffffffff80267964>] generic_file_aio_write+0x4c/0xc4
> >  [<ffffffff80267979>] generic_file_aio_write+0x61/0xc4
> >  [<ffffffff802fcf18>] ext3_orphan_del+0x53/0x19f
> >  [<ffffffff802f5768>] ext3_file_write+0x1c/0x9d
> >  [<ffffffff8028ef31>] do_sync_write+0xcc/0x10f
> >  [<ffffffff80246f9c>] autoremove_wake_function+0x0/0x2e
> >  [<ffffffff8024ecfe>] get_lock_stats+0xe/0x3f
> >  [<ffffffff8024ed9a>] lock_release_holdtime+0x41/0x4f
> >  [<ffffffff8024ed3d>] put_lock_stats+0xe/0x2a
> >  [<ffffffff8028dfb1>] sys_fchmod+0xa3/0xbd
> >  [<ffffffff8056a717>] _mutex_unlock+0x17/0x20
> >  [<ffffffff8028f6cd>] vfs_write+0xb6/0x148
> >  [<ffffffff8028fc61>] sys_write+0x48/0x74
> >  [<ffffffff8020950e>] system_call+0x7e/0x83
> > 
Shows the current stacktrace where we violate the previously established
locking order.

