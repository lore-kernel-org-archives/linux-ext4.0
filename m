From: Michal Hocko <mhocko@suse.cz>
Subject: Re: Lockup in wait_transaction_locked under memory pressure
Date: Mon, 29 Jun 2015 11:36:40 +0200
Message-ID: <20150629093640.GD28471@dhcp22.suse.cz>
References: <558BD447.1010503@kyup.com>
 <558BD507.9070002@kyup.com>
 <20150625112116.GC17237@dhcp22.suse.cz>
 <558BE96E.7080101@kyup.com>
 <20150625115025.GD17237@dhcp22.suse.cz>
 <20150625133138.GH14324@thunk.org>
 <5591097D.6010602@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Marian Marinov <mm@1h.com>
To: Nikolay Borisov <kernel@kyup.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbbF2Jgm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Jun 2015 05:36:42 -0400
Content-Disposition: inline
In-Reply-To: <5591097D.6010602@kyup.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 29-06-15 12:01:49, Nikolay Borisov wrote:
> Today I observed the issue again, this time on a different server. What
> is particularly strange is the fact that the OOM wasn't triggered for
> the cgroup, whose tasks have entered D state. There were a couple of
> SSHD processes and an RSYNC performing some backup tasks. Here is what
> the stacktrace for the rsync looks like:
> 
> crash> set 18308
>     PID: 18308
> COMMAND: "rsync"
>    TASK: ffff883d7c9b0a30  [THREAD_INFO: ffff881773748000]
>     CPU: 1
>   STATE: TASK_UNINTERRUPTIBLE
> crash> bt
> PID: 18308  TASK: ffff883d7c9b0a30  CPU: 1   COMMAND: "rsync"
>  #0 [ffff88177374ac60] __schedule at ffffffff815ab152
>  #1 [ffff88177374acb0] schedule at ffffffff815ab76e
>  #2 [ffff88177374acd0] schedule_timeout at ffffffff815ae5e5
>  #3 [ffff88177374ad70] io_schedule_timeout at ffffffff815aad6a
>  #4 [ffff88177374ada0] bit_wait_io at ffffffff815abfc6
>  #5 [ffff88177374adb0] __wait_on_bit at ffffffff815abda5
>  #6 [ffff88177374ae00] wait_on_page_bit at ffffffff8111fd4f
>  #7 [ffff88177374ae50] shrink_page_list at ffffffff81135445

This is most probably wait_on_page_writeback because the reclaim has
encountered a dirty page which is under writeback currently. This is
a memcg specific throttling on dirty memory because there is nothing
like that integrated into balance_dirty_pages. This also suggests that
dirtiers in this memcg are able to fill up the LRU by dirty memory
before the global writeback thread can make them clean a sufficient
pace.

I would try to tune dirty limits and the writeback timeout.

>  #8 [ffff88177374af50] shrink_inactive_list at ffffffff81135845
>  #9 [ffff88177374b060] shrink_lruvec at ffffffff81135ead
> #10 [ffff88177374b150] shrink_zone at ffffffff811360c3
> #11 [ffff88177374b220] shrink_zones at ffffffff81136eff
> #12 [ffff88177374b2a0] do_try_to_free_pages at ffffffff8113712f
> #13 [ffff88177374b300] try_to_free_mem_cgroup_pages at ffffffff811372be
> #14 [ffff88177374b380] try_charge at ffffffff81189423
> #15 [ffff88177374b430] mem_cgroup_try_charge at ffffffff8118c6f5
> #16 [ffff88177374b470] __add_to_page_cache_locked at ffffffff8112137d
> #17 [ffff88177374b4e0] add_to_page_cache_lru at ffffffff81121618
> #18 [ffff88177374b510] pagecache_get_page at ffffffff8112170b
> #19 [ffff88177374b560] grow_dev_page at ffffffff811c8297
> #20 [ffff88177374b5c0] __getblk_slow at ffffffff811c91d6
> #21 [ffff88177374b600] __getblk_gfp at ffffffff811c92c1
> #22 [ffff88177374b630] ext4_ext_grow_indepth at ffffffff8124565c
> #23 [ffff88177374b690] ext4_ext_create_new_leaf at ffffffff81246ca8
> #24 [ffff88177374b6e0] ext4_ext_insert_extent at ffffffff81246f09
> #25 [ffff88177374b750] ext4_ext_map_blocks at ffffffff8124a848
> #26 [ffff88177374b870] ext4_map_blocks at ffffffff8121a5b7
> #27 [ffff88177374b910] mpage_map_one_extent at ffffffff8121b1fa
> #28 [ffff88177374b950] mpage_map_and_submit_extent at ffffffff8121f07b
> #29 [ffff88177374b9b0] ext4_writepages at ffffffff8121f6d5
> #30 [ffff88177374bb20] do_writepages at ffffffff8112c490
> #31 [ffff88177374bb30] __filemap_fdatawrite_range at ffffffff81120199
> #32 [ffff88177374bb80] filemap_flush at ffffffff8112041c
> #33 [ffff88177374bb90] ext4_alloc_da_blocks at ffffffff81219da1
> #34 [ffff88177374bbb0] ext4_rename at ffffffff81229b91
> #35 [ffff88177374bcd0] ext4_rename2 at ffffffff81229e32
> #36 [ffff88177374bce0] vfs_rename at ffffffff811a08a5
> #37 [ffff88177374bd60] SYSC_renameat2 at ffffffff811a3ffc
> #38 [ffff88177374bf60] sys_renameat2 at ffffffff811a408e
> #39 [ffff88177374bf70] sys_rename at ffffffff8119e51e
> #40 [ffff88177374bf80] system_call_fastpath at ffffffff815afa89
>     RIP: 00002ba0169b61d7  RSP: 00007ffde830f428  RFLAGS: 00000206
>     RAX: ffffffffffffffda  RBX: ffffffff815afa89  RCX: 00002ba016a2e007
>     RDX: 0000000000000000  RSI: 00007ffde83126f0  RDI: 00007ffde83106f0
>     RBP: 00007ffde83106f0   R8: 0000000000000000   R9: 0000000000000000
>     R10: 0000000000000000  R11: 0000000000000202  R12: ffffffff8119e51e
>     R13: ffff88177374bf78  R14: ffffffff811a408e  R15: ffff88177374bf68
>     ORIG_RAX: 0000000000000052  CS: 0033  SS: 002b
> 
> 
> All the other processes in the container have locked up when trying to
> access file system resources. The SSHD processes for example have
> blocked on tryng to access /var/log/btmp:
> 
> PID: 11919  TASK: ffff8815613c1460  CPU: 2   COMMAND: "sshd"
>  #0 [ffff880158d03c70] __schedule at ffffffff815ab152
>  #1 [ffff880158d03cc0] schedule at ffffffff815ab76e
>  #2 [ffff880158d03ce0] schedule_preempt_disabled at ffffffff815ab9de
>  #3 [ffff880158d03cf0] __mutex_lock_slowpath at ffffffff815ad505
>  #4 [ffff880158d03d50] mutex_lock at ffffffff815ad59b
>  #5 [ffff880158d03d70] ext4_file_write_iter at ffffffff8121477b
>  #6 [ffff880158d03e30] new_sync_write at ffffffff81194047
>  #7 [ffff880158d03f00] vfs_write at ffffffff8119445e
>  #8 [ffff880158d03f30] sys_write at ffffffff81194bda
>  #9 [ffff880158d03f80] system_call_fastpath at ffffffff815afa89
>     RIP: 00002adf56857790  RSP: 00007fffaf514788  RFLAGS: 00000206
>     RAX: ffffffffffffffda  RBX: ffffffff815afa89  RCX: 00002adf568657f7
>     RDX: 0000000000000180  RSI: 00007fffaf5147a0  RDI: 0000000000000005
>     RBP: 0000000000000005   R8: 00002adf53ebf7a0   R9: 0000000080000000
>     R10: 0000000000000001  R11: 0000000000000246  R12: 00007fffaf514740
>     R13: 0000000000000180  R14: 0000000000000000  R15: 00007fffaf5147a0
>     ORIG_RAX: 0000000000000001  CS: 0033  SS: 002b
> 
> Except for one which has blocked with the following stack:
> PID: 7833   TASK: ffff88175b3ba8c0  CPU: 3   COMMAND: "sshd"
>  #0 [ffff88001d983960] __schedule at ffffffff815ab152
>  #1 [ffff88001d9839b0] schedule at ffffffff815ab76e
>  #2 [ffff88001d9839d0] wait_transaction_locked at ffffffff81264265
>  #3 [ffff88001d983a30] add_transaction_credits at ffffffff81264540
>  #4 [ffff88001d983ab0] start_this_handle at ffffffff81264824
>  #5 [ffff88001d983b60] jbd2__journal_start at ffffffff81265220
>  #6 [ffff88001d983bc0] __ext4_journal_start_sb at ffffffff8124bb49
>  #7 [ffff88001d983c10] ext4_dirty_inode at ffffffff8121da5c
>  #8 [ffff88001d983c30] __mark_inode_dirty at ffffffff811be5c3
>  #9 [ffff88001d983c70] generic_update_time at ffffffff811ae9c5
> #10 [ffff88001d983cb0] file_update_time at ffffffff811ae632
> #11 [ffff88001d983d10] __generic_file_write_iter at ffffffff811226c2
> #12 [ffff88001d983d70] ext4_file_write_iter at ffffffff81214814
> #13 [ffff88001d983e30] new_sync_write at ffffffff81194047
> #14 [ffff88001d983f00] vfs_write at ffffffff8119445e
> #15 [ffff88001d983f30] sys_write at ffffffff81194bda
> #16 [ffff88001d983f80] system_call_fastpath at ffffffff815afa89
>     RIP: 00002adf56857790  RSP: 00007fffaf514788  RFLAGS: 00000206
>     RAX: ffffffffffffffda  RBX: ffffffff815afa89  RCX: 00002adf568657f7
>     RDX: 0000000000000180  RSI: 00007fffaf5147a0  RDI: 0000000000000005
>     RBP: 0000000000000005   R8: 00002adf53ebf7a0   R9: 0000000080000000
>     R10: 0000000000000001  R11: 0000000000000246  R12: 00007fffaf514740
>     R13: 0000000000000180  R14: 0000000000000000  R15: 00007fffaf5147a0
>     ORIG_RAX: 0000000000000001  CS: 0033  SS: 002b

This is something for ext4 people to look at but it seems this waiting
for the transaction is causing others to block on i_mutex. I would check
who is performing the trasnaction and why it is blocked or why it is
making a slow progress.
 
> So basically what I have managed to determine so far is that "something"
> (this is the bit which I've yet to uncover, hopefully with your help)
> starves the file system of resources. Which causes processes to block in
> the jbd2_journal_start path. The other SSHD processes essentially block
> on the i_mutex of the /var/log/btmp (nothing unusual).
> 
> So I guess the most interesting bit here is the stack of the rsync
> process, so it is blocking on trying to free some pages, yet the OOM
> hasn't triggered.

This one is most probably holding an i_mutex but it should be blocking
the transaction. It sees a page under writeback so it is waiting for it.
The assumption is that the writeback will finish in a reasonable time.
And maybe that is what happens but you just have too many pages under
writeback on the LRU of that memcg.

-- 
Michal Hocko
SUSE Labs
