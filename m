From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: ext4 deadlocks
Date: Tue, 07 Oct 2008 15:29:45 -0500
Message-ID: <48EBC6B9.7000608@sandeen.net>
References: <48EBB9E9.4030105@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([209.173.210.139]:19774 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbYJGU3u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Oct 2008 16:29:50 -0400
In-Reply-To: <48EBB9E9.4030105@goop.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jeremy Fitzhardinge wrote:
> I tried giving ext4 a spin on my rawhide system, and it appears to 
> deadlock pretty quickly: lots of processed blocked in either ext4 or jbd2.
> 
>  From the look of the sysrq-t dumps I captured, I think beagled is 
> what's triggering it by doing something with EAs. I haven't had any 
> lockups since I killed it off.
> 
> beagled       D 0000000000000000     0  3477      1
>  ffff880125809778 0000000000000082 0000000000000000 ffff88013b078150
>  ffffffff8187a780 ffffffff8187a780 ffff88010f8445c0 ffff88013badc5c0
>  ffff88010f844970 0000000100000001 0000000000000000 ffff88010f844970
> Call Trace:
>  [<ffffffff812170d8>] ? scsi_sg_alloc+0x48/0x4a
>  [<ffffffff8136d4ae>] __down_write_nested+0xa3/0xbd
>  [<ffffffff8136d4d3>] __down_write+0xb/0xd
>  [<ffffffff8136c813>] down_write+0x2f/0x33
>  [<ffffffffa04b30a8>] ext4_expand_extra_isize_ea+0x67/0x6f2 [ext4dev]

At first glance it seems that we're trying a down_write on the xattr_sem
here...

>  [<ffffffffa04762ed>] ? jbd2_journal_add_journal_head+0x113/0x1b0 [jbd2]
>  [<ffffffffa0476173>] ? jbd2_journal_put_journal_head+0x1a/0x56 [jbd2]
>  [<ffffffffa0471669>] ? jbd2_journal_get_write_access+0x31/0x38 [jbd2]
>  [<ffffffffa0471a6c>] ? jbd2_journal_extend+0x1af/0x1ca [jbd2]
>  [<ffffffffa0497f5c>] ext4_mark_inode_dirty+0x119/0x18b [ext4dev]
>  [<ffffffffa0498156>] ext4_dirty_inode+0xab/0xc3 [ext4dev]
>  [<ffffffff810e7310>] __mark_inode_dirty+0x38/0x194
>  [<ffffffffa04b0574>] ext4_mb_new_blocks+0x700/0x70f [ext4dev]
>  [<ffffffff8109f395>] ? mark_page_accessed+0x5f/0x6b
>  [<ffffffff810eb5ba>] ? __find_get_block+0x1af/0x1c1
>  [<ffffffff8136c3af>] ? __wait_on_bit+0x6f/0x7e
>  [<ffffffff810ec154>] ? sync_buffer+0x0/0x44
>  [<ffffffffa0493e50>] do_blk_alloc+0x9d/0xb3 [ext4dev]
>  [<ffffffffa0493eb5>] ext4_new_meta_blocks+0x34/0x76 [ext4dev]
>  [<ffffffffa0493f1b>] ext4_new_meta_block+0x24/0x26 [ext4dev]
>  [<ffffffffa04b2e79>] ext4_xattr_block_set+0x50e/0x6d6 [ext4dev]
>  [<ffffffffa04b39b4>] ext4_xattr_set_handle+0x281/0x3f0 [ext4dev]

Having already downed it here?

I'll look into it, not 100% sure what path gets us here (between
in-inode EAs and external block EAs) but I'll see.

-Eric

>  [<ffffffffa0475a30>] ? __jbd2_log_space_left+0x1e/0x3d [jbd2]
>  [<ffffffffa0471f29>] ? start_this_handle+0x4a2/0x4ca [jbd2]
>  [<ffffffffa047210b>] ? jbd2_journal_start+0xa8/0xe0 [jbd2]
>  [<ffffffffa04b3bc4>] ext4_xattr_set+0xa1/0xec [ext4dev]
>  [<ffffffff8114c813>] ? selinux_inode_permission+0xc1/0xca
>  [<ffffffffa04b409d>] ext4_xattr_user_set+0x45/0x4b [ext4dev]
>  [<ffffffff810e4739>] generic_setxattr+0x7a/0x7c
>  [<ffffffff810e5206>] vfs_setxattr+0x9b/0x11e
>  [<ffffffff810e535c>] setxattr+0xd3/0xf2
>  [<ffffffff810d3178>] ? putname+0x35/0x3e
>  [<ffffffff810d3d08>] ? user_path_at+0x62/0x91
>  [<ffffffff8136d74b>] ? _spin_lock+0xe/0x11
>  [<ffffffff810e546e>] sys_lsetxattr+0x60/0x89
>  [<ffffffff810113aa>] system_call_fastpath+0x16/0x1b
> 
> 
> 
> The kernel is kernel-2.6.27-0.398.rc9.fc10.x86_64.  ext4 is the /home 
> filesystem, mounted with noatime.  I'm running a normal Fedora gnome 
> desktop environment.
> 
> The sysrq-t dumps are attached.
> 
>     J
> 

