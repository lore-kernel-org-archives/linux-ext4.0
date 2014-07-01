From: David Jander <david@protonic.nl>
Subject: Re: ext4: journal has aborted
Date: Tue, 1 Jul 2014 15:50:04 +0200
Message-ID: <20140701155004.194b7ee8@archvile>
References: <CAFnufp3TepsxxX8=WCJ0V=3TELP0rWR-NxFukSL8X=qS1q6Eew@mail.gmail.com>
	<20140701082619.1ac77f1d@archvile>
	<20140701084206.GG9743@birch.djwong.org>
	<53B2A47F.90903@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Matteo Croce <technoboy85@gmail.com>,
	linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Jaehoon Chung <jh80.chung@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from protonic.xs4all.nl ([83.163.252.89]:28624 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbaGANuA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jul 2014 09:50:00 -0400
In-Reply-To: <53B2A47F.90903@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi Jaehoon,

On Tue, 01 Jul 2014 21:07:27 +0900
Jaehoon Chung <jh80.chung@samsung.com> wrote:

> Hi,
> 
> i have interesting for this problem..Because i also found the same problem..
> Is it Journal problem?
> 
> I used the Linux version 3.16.0-rc3.
> 
> [    3.866449] EXT4-fs error (device mmcblk0p13): ext4_mb_generate_buddy:756: group 0, 20490 clusters in bitmap, 20488 in gd; block bitmap corrupt.
> [    3.877937] Aborting journal on device mmcblk0p13-8.
> [    3.885025] Kernel panic - not syncing: EXT4-fs (device mmcblk0p13): panic forced after error
> [    3.885025]
> [    3.891751] CPU: 1 PID: 1488 Comm: mv Not tainted 3.16.0-rc3-00206-gc0f4eea0-dirty #2
> [    3.899594] [<c0016258>] (unwind_backtrace) from [<c00127d4>] (show_stack+0x10/0x14)
> [    3.907294] [<c00127d4>] (show_stack) from [<c051f458>] (dump_stack+0x78/0xc8)
> [    3.914495] [<c051f458>] (dump_stack) from [<c051cd28>] (panic+0x8c/0x1f0)
> [    3.921354] [<c051cd28>] (panic) from [<c018eb38>] (ext4_handle_error+0x68/0xa8)
> [    3.928730] [<c018eb38>] (ext4_handle_error) from [<c018f584>] (__ext4_grp_locked_error+0x88/0x1c0)
> [    3.937759] [<c018f584>] (__ext4_grp_locked_error) from [<c01a1e04>] (ext4_mb_generate_buddy+0x260/0x398)
> [    3.947306] [<c01a1e04>] (ext4_mb_generate_buddy) from [<c01a3d20>] (ext4_mb_init_cache+0x2fc/0x7fc)
> [    3.956433] [<c01a3d20>] (ext4_mb_init_cache) from [<c01a43d8>] (ext4_mb_init_group+0x1b8/0x234)
> [    3.965186] [<c01a43d8>] (ext4_mb_init_group) from [<c01a4950>] (ext4_mb_load_buddy+0x34c/0x380)
> [    3.973952] [<c01a4950>] (ext4_mb_load_buddy) from [<c01a9918>] (ext4_free_blocks+0x47c/0xd30)
> [    3.982545] [<c01a9918>] (ext4_free_blocks) from [<c019b440>] (ext4_ext_remove_space+0xae0/0x1474)
> [    3.991486] [<c019b440>] (ext4_ext_remove_space) from [<c019df68>] (ext4_ext_truncate+0xb4/0xd4)
> [    4.000251] [<c019df68>] (ext4_ext_truncate) from [<c0178ac4>] (ext4_truncate+0x37c/0x43c)
> [    4.008497] [<c0178ac4>] (ext4_truncate) from [<c017ba90>] (ext4_evict_inode+0x334/0x4f4)
> [    4.016660] [<c017ba90>] (ext4_evict_inode) from [<c01229b0>] (evict+0x94/0x158)
> [    4.024036] [<c01229b0>] (evict) from [<c011f1fc>] (__dentry_kill+0x1dc/0x22c)
> [    4.031238] [<c011f1fc>] (__dentry_kill) from [<c011f924>] (dput+0xa8/0x1ac)
> [    4.038282] [<c011f924>] (dput) from [<c0119a1c>] (SyS_renameat2+0x250/0x36c)
> [    4.045396] [<c0119a1c>] (SyS_renameat2) from [<c0119b7c>] (SyS_rename+0x28/0x30)
> [    4.052859] [<c0119b7c>] (SyS_rename) from [<c000eea0>] (ret_fast_syscall+0x0/0x3c)
> 
> I used with the eMMC card. I want to know the debugging point for this problem.
> If anybody have solution, let me know, plz.

You can try to disable the mount option "errors=panic", I suspect the actual
error is harmless....
OTOH, then you cannot see the stack-trace anymore.

AFAICS, it seems to originate in ext4_ext_remove_space() in all cases I have
seen, and happens quicker if the filesystem was not unmounted properly, so
maybe the bug is related to the journal code's accounting of free space.
Let's wait and see what the experts say about this...

Regards,

-- 
David Jander
Protonic Holland.
