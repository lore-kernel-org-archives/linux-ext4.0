From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/6] ext4: Move LRU list handling into extent status code
Date: Sun, 23 Nov 2014 00:48:02 -0500
Message-ID: <20141123054802.GB4102@thunk.org>
References: <1415961957-21621-1-git-send-email-jack@suse.cz>
 <1415961957-21621-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45756 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbaKWFsD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Nov 2014 00:48:03 -0500
Content-Disposition: inline
In-Reply-To: <1415961957-21621-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 14, 2014 at 11:45:53AM +0100, Jan Kara wrote:
> Currently callers adding extents to extent status tree were responsible
> for adding the inode to LRU list. This is error prone and puts LRU list
> handling in unnecessarily many places.
> 
> Just add inode to LRU automatically when the first non-delay extent is
> added to the tree and remove inode from LRU when the last non-delay
> extent is removed.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

While trying to bisect the ext4/003 regression, I found that patches
one and two applied to gether causes the following deadlock (very
early in the boot sequence; before xfstests is started):

[   24.680699] 
[   24.681110] =============================================
[   24.682755] [ INFO: possible recursive locking detected ]
[   24.683344] 3.18.0-rc3-00538-gc12044b #2369 Not tainted
[   24.683344] ---------------------------------------------
[   24.683344] runtests.sh/2772 is trying to acquire lock:
[   24.683344]  (&(&sbi->s_es_lru_lock)->rlock){+.+...}, at: [<c02e870b>] ext4_es_free_extent+0x6f/0xc5
[   24.683344] 
[   24.683344] but task is already holding lock:
[   24.683344]  (&(&sbi->s_es_lru_lock)->rlock){+.+...}, at: [<c02e8857>] __ext4_es_shrink+0x3a/0x346
[   24.683344] 
[   24.683344] other info that might help us debug this:
[   24.683344]  Possible unsafe locking scenario:
[   24.683344] 
[   24.683344]        CPU0
[   24.683344]        ----
[   24.683344]   lock(&(&sbi->s_es_lru_lock)->rlock);
[   24.683344]   lock(&(&sbi->s_es_lru_lock)->rlock);
[   24.683344] 
[   24.683344]  *** DEADLOCK ***
[   24.683344] 
[   24.683344]  May be due to missing lock nesting notation
[   24.683344] 
[   24.683344] 4 locks held by runtests.sh/2772:
[   24.683344]  #0:  (sb_writers#5){.+.+.+}, at: [<c024a69d>] file_start_write+0x24/0x26
[   24.683344]  #1:  (shrinker_rwsem){++++..}, at: [<c021cca2>] shrink_slab+0x29/0xcd
[   24.683344]  #2:  (&(&sbi->s_es_lru_lock)->rlock){+.+...}, at: [<c02e8857>] __ext4_es_shrink+0x3a/0x346
[   24.683344]  #3:  (&ei->i_es_lock){++++..}, at: [<c02e8900>] __ext4_es_shrink+0xe3/0x346
[   24.683344] 
[   24.683344] stack backtrace:
[   24.683344] CPU: 1 PID: 2772 Comm: runtests.sh Not tainted 3.18.0-rc3-00538-gc12044b #2369
[   24.683344] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   24.683344]  00000000 00000000 f3f55d4c c091b746 f343e0d0 f3f55dc0 c019fa14 c0c0cc77
[   24.683344]  c0c0d6ea c0c0cb76 00000002 f343e694 c149d110 00003900 00000000 24b02008
[   24.683344]  4c422213 f343e694 00000000 00012581 00000004 f343e0d0 f343e6b8 f343e6bc
[   24.683344] Call Trace:
[   24.683344]  [<c091b746>] dump_stack+0x48/0x60
[   24.683344]  [<c019fa14>] __lock_acquire+0xb7d/0xcd9
[   24.683344]  [<c019f1f6>] ? __lock_acquire+0x35f/0xcd9
[   24.683344]  [<c019feb8>] lock_acquire+0xe7/0x15e
[   24.683344]  [<c02e870b>] ? ext4_es_free_extent+0x6f/0xc5
[   24.683344]  [<c0923cd1>] _raw_spin_lock+0x2a/0x5a
[   24.683344]  [<c02e870b>] ? ext4_es_free_extent+0x6f/0xc5
[   24.683344]  [<c02e870b>] ext4_es_free_extent+0x6f/0xc5
[   24.683344]  [<c02e87ff>] __es_try_to_reclaim_extents+0x9e/0xbc
[   24.683344]  [<c02e890e>] __ext4_es_shrink+0xf1/0x346
[   24.683344]  [<c02e8c38>] ext4_es_scan+0xd5/0x1fc
[   24.683344]  [<c021c8c5>] shrink_slab_node+0x196/0x321
[   24.683344]  [<c021ccd8>] shrink_slab+0x5f/0xcd
[   24.683344]  [<c0287306>] ? drop_pagecache_sb+0xbf/0xbf
[   24.683344]  [<c0287382>] drop_caches_sysctl_handler+0x7c/0xd2
[   24.683344]  [<c0296647>] proc_sys_call_handler+0x7b/0x9c
[   24.683344]  [<c0296668>] ? proc_sys_call_handler+0x9c/0x9c
[   24.683344]  [<c029667a>] proc_sys_write+0x12/0x14
[   24.683344]  [<c024ae85>] vfs_write+0x8c/0xf7
[   24.683344]  [<c024b21c>] SyS_write+0x4f/0x7c
[   24.683344]  [<c0924a2a>] syscall_call+0x7/0x7

We end up removing all of the LRU code in the next patch in the patch
series, so this is not a major problem, but it can trip people up when
they are doing bisects.  It may be simplest just to combine patches 2
and 3 in this series.

						- Ted
