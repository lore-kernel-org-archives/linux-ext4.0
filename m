From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v3 00/13] vfs: hot data tracking
Date: Tue, 16 Oct 2012 11:11:41 +1100
Message-ID: <20121016001140.GB2864@dastard>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	dave@jikos.cz, tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: zwu.kernel@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:64016 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558Ab2JPALo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Oct 2012 20:11:44 -0400
Content-Disposition: inline
In-Reply-To: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 10, 2012 at 06:07:22PM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> NOTE:
> 
>   The patchset is currently post out mainly to make sure
> it is going in the correct direction and hope to get some
> helpful comments from other guys.
>   For more infomation, please check hot_tracking.txt in Documentation
> 

# mount -o hot_track /dev/vdc /mnt/scratch
# umount /mnt/scratch

hangs here on XFS:

#  echo w > /proc/sysrq-trigger 
[   44.229252] SysRq : Show Blocked State
[   44.230044]   task                        PC stack   pid father
[   44.231187] umount          D ffff88021fd52dc0  3632  4107   4106 0x00000000
[   44.231946]  ffff880212a91bd8 0000000000000086 ffff8802153da300 ffff880212a91fd8
[   44.231946]  ffff880212a91fd8 ffff880212a91fd8 ffff880216cf6340 ffff8802153da300
[   44.231946]  00000000ffffffff 7fffffffffffffff ffff880212a91d78 ffff880212a91d80
[   44.231946] Call Trace:
[   44.231946]  [<ffffffff81b6c1b9>] schedule+0x29/0x70
[   44.231946]  [<ffffffff81b6a079>] schedule_timeout+0x159/0x220
[   44.231946]  [<ffffffff8171a2f4>] ? do_raw_spin_lock+0x54/0x120
[   44.231946]  [<ffffffff8171a45d>] ? do_raw_spin_unlock+0x5d/0xb0
[   44.231946]  [<ffffffff81b6bfee>] wait_for_common+0xee/0x190
[   44.231946]  [<ffffffff810b6a10>] ? try_to_wake_up+0x2f0/0x2f0
[   44.231946]  [<ffffffff81b6c18d>] wait_for_completion+0x1d/0x20
[   44.231946]  [<ffffffff8109efec>] flush_workqueue+0x14c/0x3f0
[   44.231946]  [<ffffffff811aad89>] hot_track_exit+0x39/0x180
[   44.231946]  [<ffffffff81454e83>] xfs_fs_put_super+0x23/0x70
[   44.231946]  [<ffffffff8117a991>] generic_shutdown_super+0x61/0xf0
[   44.231946]  [<ffffffff8117aa50>] kill_block_super+0x30/0x80
[   44.231946]  [<ffffffff8117ae45>] deactivate_locked_super+0x45/0x70
[   44.231946]  [<ffffffff8117ba0e>] deactivate_super+0x4e/0x70
[   44.231946]  [<ffffffff81197541>] mntput_no_expire+0x101/0x160
[   44.231946]  [<ffffffff811985b6>] sys_umount+0x76/0x3a0
[   44.231946]  [<ffffffff81b755a9>] system_call_fastpath+0x16/0x1b

because this is stuck:

[  200.064574] kworker/u:2     S ffff88021fc12dc0  5208   669      2 0x00000000
[  200.064574]  ffff88021532fc60 0000000000000046 ffff88021532c7c0 ffff88021532ffd8
[  200.064574]  ffff88021532ffd8 ffff88021532ffd8 ffffffff81fc3420 ffff88021532c7c0
[  200.064574]  ffff88021532fc50 ffff88021532fc98 ffffffff8221e700 ffffffff8221e700
[  200.064574] Call Trace:
[  200.064574]  [<ffffffff81b6c1b9>] schedule+0x29/0x70
[  200.064574]  [<ffffffff81b6a03b>] schedule_timeout+0x11b/0x220
[  200.064574]  [<ffffffff810908d0>] ? usleep_range+0x50/0x50
[  200.064574]  [<ffffffff811aa78a>] hot_temperature_update_work+0x16a/0x1c0
[  200.064574]  [<ffffffff8171a2f4>] ? do_raw_spin_lock+0x54/0x120
[  200.064574]  [<ffffffff81b6d3ce>] ? _raw_spin_unlock_irq+0xe/0x30
[  200.064574]  [<ffffffff810b0b3c>] ? finish_task_switch+0x5c/0x100
[  200.064574]  [<ffffffff8109d959>] process_one_work+0x139/0x500
[  200.064574]  [<ffffffff811aa620>] ? hot_range_update+0x1f0/0x1f0
[  200.064574]  [<ffffffff8109e63e>] worker_thread+0x15e/0x460
[  200.064574]  [<ffffffff8109e4e0>] ? manage_workers+0x2f0/0x2f0
[  200.064574]  [<ffffffff810a4b33>] kthread+0x93/0xa0
[  200.064574]  [<ffffffff81b765c4>] kernel_thread_helper+0x4/0x10
[  200.064574]  [<ffffffff810a4aa0>] ? __init_kthread_worker+0x40/0x40
[  200.064574]  [<ffffffff81b765c0>] ? gs_change+0x13/0x13

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
