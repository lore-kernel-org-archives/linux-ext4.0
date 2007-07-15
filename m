From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [EXT4 set 5][PATCH 1/1] expand inode i_extra_isize to support
	features in larger inode
Date: Sun, 15 Jul 2007 15:14:02 +0200
Message-ID: <1184505242.5284.98.camel@lappy>
References: <1183275482.4010.133.camel@localhost.localdomain>
	 <20070710163247.5c8bfa3f.akpm@linux-foundation.org>
	 <20070713020529.1486491f.akpm@linux-foundation.org>
	 <1184333621.20032.85.camel@twins>
	 <20070713121259.20066d5b.akpm@linux-foundation.org>
	 <20070713214746.GH23255@mami.zabbo.net>  <1184504543.5284.96.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
	Ingo Molnar <mingo@elte.hu>
To: Zach Brown <zach.brown@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1184504543.5284.96.camel@lappy>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 2007-07-15 at 15:02 +0200, Peter Zijlstra wrote:
> On Fri, 2007-07-13 at 14:47 -0700, Zach Brown wrote:
> 
> > Peter, do you have any interest in seeing how far we can get
> > at tracking lock_page()?  I'm not holding my breath, but any little bit
> > would probably help.
> 
> Would this be a valid report? 

=======================================================
[ INFO: possible circular locking dependency detected ]
[ 2.6.22-rt3-dirty #35
-------------------------------------------------------
mkdir/1662 is trying to acquire lock:
 (lock_page_0){--..}, at: [<ffffffff80265df6>] add_to_page_cache_lru+0xe/0x23

but task is already holding lock:
 (jbd_handle){--..}, at: [<ffffffff80305797>] journal_start+0x108/0x12c

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (jbd_handle){--..}:
       [<ffffffff80251b16>] __lock_acquire+0xa72/0xc35
       [<ffffffff802520b9>] lock_acquire+0x48/0x61
       [<ffffffff80305797>] journal_start+0x108/0x12c
       [<ffffffff803057b3>] journal_start+0x124/0x12c
       [<ffffffff802f92e9>] ext3_prepare_write+0x42/0x17b
       [<ffffffff80267185>] generic_file_buffered_write+0x298/0x646
       [<ffffffff8023943e>] current_fs_time+0x3b/0x40
       [<ffffffff802614a4>] add_preempt_count+0x14/0xe4
       [<ffffffff80267882>] __generic_file_aio_write_nolock+0x34f/0x3b9
       [<ffffffff8024ed2d>] put_lock_stats+0xe/0x2a
       [<ffffffff80267938>] generic_file_aio_write+0x4c/0xc4
       [<ffffffff8026794d>] generic_file_aio_write+0x61/0xc4
       [<ffffffff802fce88>] ext3_orphan_del+0x53/0x19f
       [<ffffffff802f56d8>] ext3_file_write+0x1c/0x9d
       [<ffffffff8028eedd>] do_sync_write+0xcc/0x10f
       [<ffffffff80246f8d>] autoremove_wake_function+0x0/0x2e
       [<ffffffff8024ecee>] get_lock_stats+0xe/0x3f
       [<ffffffff8024ed8a>] lock_release_holdtime+0x41/0x4f
       [<ffffffff8024ed2d>] put_lock_stats+0xe/0x2a
       [<ffffffff8028df5d>] sys_fchmod+0xa3/0xbd
       [<ffffffff8056a6d7>] _mutex_unlock+0x17/0x20
       [<ffffffff8028f679>] vfs_write+0xb6/0x148
       [<ffffffff8028fc0d>] sys_write+0x48/0x74
       [<ffffffff8020950e>] system_call+0x7e/0x83
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (lock_page_0){--..}:
       [<ffffffff802503a9>] print_circular_bug_header+0xcc/0xd3
       [<ffffffff80251a12>] __lock_acquire+0x96e/0xc35
       [<ffffffff802520b9>] lock_acquire+0x48/0x61
       [<ffffffff80265df6>] add_to_page_cache_lru+0xe/0x23
       [<ffffffff80265d05>] add_to_page_cache+0x1de/0x2c1
       [<ffffffff80265df6>] add_to_page_cache_lru+0xe/0x23
       [<ffffffff80266959>] find_or_create_page+0x4c/0x73
       [<ffffffff802ae6c2>] __getblk+0x118/0x23c
       [<ffffffff802f7d9a>] ext3_getblk+0xf2/0x23b
       [<ffffffff80306337>] journal_dirty_metadata+0x1a8/0x1b3
       [<ffffffff80301e3e>] __ext3_journal_dirty_metadata+0x1e/0x46
       [<ffffffff802f6c63>] ext3_mark_iloc_dirty+0x293/0x30a
       [<ffffffff802f70a1>] ext3_mark_inode_dirty+0x3f/0x48
       [<ffffffff802f644e>] ext3_new_inode+0x8ff/0x943
       [<ffffffff802f8c9c>] ext3_bread+0x11/0x84
       [<ffffffff802fccc3>] ext3_mkdir+0xdd/0x24f
       [<ffffffff80296893>] vfs_mkdir+0x6d/0xb5
       [<ffffffff8029902e>] sys_mkdirat+0xa1/0xec
       [<ffffffff80569f4d>] trace_hardirqs_on_thunk+0x3a/0x3c
       [<ffffffff80250c23>] trace_hardirqs_on_caller+0x115/0x138
       [<ffffffff80569f4d>] trace_hardirqs_on_thunk+0x3a/0x3c
       [<ffffffff8020950e>] system_call+0x7e/0x83
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

2 locks held by mkdir/1662:
 #0:  (&inode->i_mutex/1){--..}, at: [<ffffffff80297154>] lookup_create+0x26/0x8b
 #1:  (jbd_handle){--..}, at: [<ffffffff80305797>] journal_start+0x108/0x12c

stack backtrace:

Call Trace:
 [<ffffffff8024ffad>] print_circular_bug_tail+0x69/0x72
 [<ffffffff802503a9>] print_circular_bug_header+0xcc/0xd3
 [<ffffffff80251a12>] __lock_acquire+0x96e/0xc35
 [<ffffffff802520b9>] lock_acquire+0x48/0x61
 [<ffffffff80265df6>] add_to_page_cache_lru+0xe/0x23
 [<ffffffff80265d05>] add_to_page_cache+0x1de/0x2c1
 [<ffffffff80265df6>] add_to_page_cache_lru+0xe/0x23
 [<ffffffff80266959>] find_or_create_page+0x4c/0x73
 [<ffffffff802ae6c2>] __getblk+0x118/0x23c
 [<ffffffff802f7d9a>] ext3_getblk+0xf2/0x23b
 [<ffffffff80306337>] journal_dirty_metadata+0x1a8/0x1b3
 [<ffffffff80301e3e>] __ext3_journal_dirty_metadata+0x1e/0x46
 [<ffffffff802f6c63>] ext3_mark_iloc_dirty+0x293/0x30a
 [<ffffffff802f70a1>] ext3_mark_inode_dirty+0x3f/0x48
 [<ffffffff802f644e>] ext3_new_inode+0x8ff/0x943
 [<ffffffff802f8c9c>] ext3_bread+0x11/0x84
 [<ffffffff802fccc3>] ext3_mkdir+0xdd/0x24f
 [<ffffffff80296893>] vfs_mkdir+0x6d/0xb5
 [<ffffffff8029902e>] sys_mkdirat+0xa1/0xec
 [<ffffffff80569f4d>] trace_hardirqs_on_thunk+0x3a/0x3c
 [<ffffffff80250c23>] trace_hardirqs_on_caller+0x115/0x138
 [<ffffffff80569f4d>] trace_hardirqs_on_thunk+0x3a/0x3c
 [<ffffffff8020950e>] system_call+0x7e/0x83

INFO: lockdep is turned off.
---------------------------
| preempt count: 00000000 ]
| 0-level deep critical section nesting:
----------------------------------------



