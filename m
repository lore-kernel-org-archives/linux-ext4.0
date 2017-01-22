From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] ext4: fix deadlock between inline_data and
 ext4_expand_extra_isize_ea()
Date: Sun, 22 Jan 2017 17:25:27 -0500
Message-ID: <20170122222527.ylc26specpuvydcx@thunk.org>
References: <20170112034938.5934-1-tytso@mit.edu>
 <20170112034938.5934-4-tytso@mit.edu>
 <20170120135317.GC10446@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux@sciencehorizons.net, stable@vger.kernel.org, #@thunk.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41926 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750703AbdAVWZg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 22 Jan 2017 17:25:36 -0500
Content-Disposition: inline
In-Reply-To: <20170120135317.GC10446@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 20, 2017 at 02:53:17PM +0100, Jan Kara wrote:
> > @@ -1264,7 +1262,7 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
> >  		ext4_xattr_update_super_block(handle, inode->i_sb);
> >  		inode->i_ctime = current_time(inode);
> >  		if (!value)
> > -			ext4_clear_inode_state(inode, EXT4_STATE_NO_EXPAND);
> > +			no_expand = 0;
> 
> OK. I suppose you can use ext4_mark_inode_dirty() instead of
> ext4_mark_iloc_dirty() because the deadlock on xattr_sem is now taken care
> of by your changes, right?

Correct.

> > @@ -1497,12 +1493,11 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
> >  	int error = 0, tried_min_extra_isize = 0;
> >  	int s_min_extra_isize = le16_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_min_extra_isize);
> >  	int isize_diff;	/* How much do we need to grow i_extra_isize */
> > +	int no_expand;
> > +
> > +	if (ext4_write_trylock_xattr(inode, &no_expand) == 0)
> > +		return 0;
> 
> Why do you play tricks with trylock here? ext4_mark_inode_dirty() checks
> EXT4_STATE_NO_EXPAND and thus we should not ever get here if we already
> hold xattr_sem...

The problem is still a lock inversion in the truncate code path.  The
simplest way of dealing with it to simply avoiding doing the
expand_isize operation on truncates.  In the case where this is
happening on the deletion of an inode, doing the expansion is
pointless anyway.

						- Ted

inline run xfstest ext4/307
[  248.556548] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: acl,user_xattr,block_validity
[  248.602530] 
[  248.604177] ======================================================
[  248.610565] [ INFO: possible circular locking dependency detected ]
[  248.617163] 4.10.0-rc3-ext4-00017-ge2a392e80d24-dirty #210 Not tainted
[  248.623999] -------------------------------------------------------
[  248.630404] fsstress/26316 is trying to acquire lock:
[  248.635577]  (&ei->i_data_sem){++++..}, at: [<ffffffff812a1b6f>] ext4_map_blocks+0xf7/0x4f5
[  248.644066] 
[  248.644066] but task is already holding lock:
[  248.650023]  (&ei->xattr_sem){++++..}, at: [<ffffffff812e357c>] ext4_try_add_inline_entry+0x4c/0x1db
[  248.659291] 
[  248.659291] which lock already depends on the new lock.
[  248.659291] 
[  248.668022] 
[  248.668022] the existing dependency chain (in reverse order) is:
[  248.675720] 
[  248.675720] -> #1 (&ei->xattr_sem){++++..}:
[  248.681604]        
[  248.681614] [<ffffffff8111f550>] __lock_acquire+0x5e0/0x68a
[  248.689524]        
[  248.689531] [<ffffffff81120364>] lock_acquire+0x122/0x1bd
[  248.697263]        
[  248.697272] [<ffffffff818464d4>] down_write+0x39/0x99
[  248.704680]        
[  248.704689] [<ffffffff812e1279>] ext4_expand_extra_isize_ea+0x50/0x42a
[  248.713637]        
[  248.713645] [<ffffffff812a4d92>] ext4_mark_inode_dirty+0x170/0x27b
[  248.722156]        
[  248.722166] [<ffffffff812cd6c9>] ext4_ext_truncate+0x27/0x8c
[  248.730165]        
[  248.730173] [<ffffffff812a65f9>] ext4_truncate+0x26e/0x47d
[  248.737989]        
[  248.737996] [<ffffffff812a91d8>] ext4_setattr+0x70b/0x85d
[  248.745732]        
[  248.745739] [<ffffffff8121af50>] notify_change+0x236/0x37b
[  248.753562]        
[  248.753569] [<ffffffff811fc72a>] do_truncate+0x6f/0x8e
[  248.761066]        
[  248.761070] [<ffffffff8120c8e5>] do_last+0x58f/0x608
[  248.768365]        
[  248.768369] [<ffffffff8120cbe3>] path_openat+0x285/0x30c
[  248.777907]        
[  248.777911] [<ffffffff8120ccb7>] do_filp_open+0x4d/0xa3
[  248.785541]        
[  248.785548] [<ffffffff811fd97e>] do_sys_open+0x13c/0x1cb
[  248.793178]        
[  248.793183] [<ffffffff811fda2b>] SyS_open+0x1e/0x20
[  248.800494]        
[  248.800502] [<ffffffff81848a01>] entry_SYSCALL_64_fastpath+0x1f/0xc2
[  248.809230] 
[  248.809230] -> #0 (&ei->i_data_sem){++++..}:
[  248.815091]        
[  248.815098] [<ffffffff8111ca13>] validate_chain.isra.20+0xaf7/0x1109
[  248.823951]        
[  248.823956] [<ffffffff8111f550>] __lock_acquire+0x5e0/0x68a
[  248.831880]        
[  248.831885] [<ffffffff81120364>] lock_acquire+0x122/0x1bd
[  248.843958]        
[  248.843964] [<ffffffff81846444>] down_read+0x30/0x87
[  248.851379]        
[  248.851390] [<ffffffff812a1b6f>] ext4_map_blocks+0xf7/0x4f5
[  248.859409]        
[  248.859416] [<ffffffff812e21dc>] ext4_convert_inline_data_nolock+0xf0/0x33d
[  248.868712]        
[  248.868720] [<ffffffff812e36b7>] ext4_try_add_inline_entry+0x187/0x1db
[  248.877775]        
[  248.877780] [<ffffffff812af8bc>] ext4_add_entry+0xccc/0xd55
[  248.886237]        
[  248.886240] [<ffffffff812af963>] ext4_add_nondir+0x1e/0x6b
[  248.894163]        
[  248.894168] [<ffffffff812b1be1>] ext4_symlink+0x37b/0x41c
[  248.902228]        
[  248.902233] [<ffffffff8120db52>] vfs_symlink+0xd9/0x134
[  248.909877]        
[  248.909880] [<ffffffff8120dc2b>] SyS_symlinkat+0x7e/0xc3
[  248.917592]        
[  248.917600] [<ffffffff8120dc86>] SyS_symlink+0x16/0x18
[  248.925587]        
[  248.925599] [<ffffffff81848a01>] entry_SYSCALL_64_fastpath+0x1f/0xc2
[  248.934482] 
[  248.934482] other info that might help us debug this:
[  248.934482] 
[  248.942591]  Possible unsafe locking scenario:
[  248.942591] 
[  248.948629]        CPU0                    CPU1
[  248.953271]        ----                    ----
[  248.957906]   lock(&ei->xattr_sem);
[  248.961507]                                lock(&ei->i_data_sem);
[  248.967719]                                lock(&ei->xattr_sem);
[  248.973835]   lock(&ei->i_data_sem);
[  248.977578] 
[  248.977578]  *** DEADLOCK ***
[  248.977578] 
[  248.983621] 4 locks held by fsstress/26316:
[  248.987911]  #0:  (sb_writers#3){.+.+.+}, at: [<ffffffff8121e549>] mnt_want_write+0x21/0x45
[  248.996377]  #1:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff8120ac5a>] filename_create+0x72/0x11c
[  249.006145]  #2:  (jbd2_handle){++++..}, at: [<ffffffff812f02ec>] start_this_handle+0x33d/0x3bf
[  249.014958]  #3:  (&ei->xattr_sem){++++..}, at: [<ffffffff812e357c>] ext4_try_add_inline_entry+0x4c/0x1db
[  249.024650] 
[  249.024650] stack backtrace:
[  249.029143] CPU: 1 PID: 26316 Comm: fsstress Not tainted 4.10.0-rc3-ext4-00017-ge2a392e80d24-dirty #210
[  249.038654] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
[  249.048007] Call Trace:
[  249.050573]  dump_stack+0x85/0xbe
[  249.054016]  print_circular_bug+0x290/0x29e
[  249.058315]  validate_chain.isra.20+0xaf7/0x1109
[  249.063057]  __lock_acquire+0x5e0/0x68a
[  249.067002]  ? __lock_acquire+0x5e0/0x68a
[  249.071126]  lock_acquire+0x122/0x1bd
[  249.074899]  ? ext4_map_blocks+0xf7/0x4f5
[  249.079022]  down_read+0x30/0x87
[  249.082367]  ? ext4_map_blocks+0xf7/0x4f5
[  249.086483]  ext4_map_blocks+0xf7/0x4f5
[  249.090428]  ext4_convert_inline_data_nolock+0xf0/0x33d
[  249.095763]  ext4_try_add_inline_entry+0x187/0x1db
[  249.100666]  ext4_add_entry+0xccc/0xd55
[  249.104616]  ? __ext4_handle_dirty_metadata+0xca/0x1af
[  249.109868]  ? ext4_mark_iloc_dirty+0x660/0x6a9
[  249.114509]  ext4_add_nondir+0x1e/0x6b
[  249.118366]  ext4_symlink+0x37b/0x41c
[  249.122151]  ? __inode_permission+0x81/0x88
[  249.126457]  vfs_symlink+0xd9/0x134
[  249.130056]  SyS_symlinkat+0x7e/0xc3
[  249.133751]  ? trace_hardirqs_on_thunk+0x1a/0x1c
[  249.138488]  SyS_symlink+0x16/0x18
[  249.142002]  entry_SYSCALL_64_fastpath+0x1f/0xc2
[  249.146737] RIP: 0033:0x7f02be12f237
[  249.150425] RSP: 002b:00007ffca0afdca8 EFLAGS: 00000206 ORIG_RAX: 0000000000000058
[  249.158119] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f02be12f237
[  249.165492] RDX: 000000000000006c RSI: 00007f02b80008c0 RDI: 00007f02b8000d80
[  249.173094] RBP: 0000000000000032 R08: 0000000000000003 R09: 00007f02b8000070
[  249.180339] R10: 00007f02be3f6760 R11: 0000000000000206 R12: 0000000051eb851f
[  249.187581] R13: 0000000000405020 R14: 0000000000000000 R15: 0000000000000000
