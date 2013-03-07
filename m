From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG][dioread_nolock] blocked for more than 120s when we run
 xfstests #269
Date: Thu, 7 Mar 2013 16:11:40 +0100
Message-ID: <20130307151140.GF6723@quack.suse.cz>
References: <20130307124054.GE2800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40636 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942Ab3CGPLm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Mar 2013 10:11:42 -0500
Content-Disposition: inline
In-Reply-To: <20130307124054.GE2800@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 07-03-13 20:40:54, Zheng Liu wrote:
> Hi all,
> 
> This bug will be triggered when dioread_nolock enables.  In 3.8 kernel,
> the test will be blocked for more than 120s, and we get the following
> messages.  *But* in dev branch the system will hang silently without any
> messages.  I need to run test 7 times to hit it.
> 
> wenqing: run xfstest 269
> kernel: EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts:
> acl,user_xattr,dioread_nolock
> kernel: INFO: task umount:3376 blocked for more than 120 seconds.
> kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> message.
> kernel: umount          D 0000000000000001     0  3376   3003 0x00000000
> kernel: ffff880117417cd8 0000000000000082 ffff880117417bd8 ffff880117416010
> kernel: ffff880112d12110 0000000000012080 ffff880117417fd8 0000000000004000
> kernel: ffff880117417fd8 0000000000012080 ffff88011331d950 ffff880112d12110
> kernel: Call Trace:
> kernel: [<ffffffff820ba03c>] ? pagevec_lookup+0x22/0x2b
> kernel: [<ffffffff820bb526>] ? truncate_inode_pages_range+0x273/0x3a2
> kernel: [<ffffffff8237ef2f>] schedule+0x64/0x66
> kernel: [<ffffffffa0203d7c>] ext4_ioend_wait+0x87/0x9f [ext4]
> kernel: [<ffffffff8204f0be>] ? wake_up_bit+0x2a/0x2a
> kernel: [<ffffffffa0201396>] ext4_evict_inode+0x4a/0x41d [ext4]
> kernel: [<ffffffff82102c8c>] evict+0xa2/0x15b
> kernel: [<ffffffff821ba2b8>] ? __list_del_entry+0x51/0x98
> kernel: [<ffffffff821031b7>] dispose_list+0x3e/0x50
> kernel: [<ffffffff8210365b>] evict_inodes+0xdb/0xe7
> kernel: [<ffffffff820ef954>] generic_shutdown_super+0x4c/0xd3
> kernel: [<ffffffff820efa02>] kill_block_super+0x27/0x69
> kernel: [<ffffffff820efe56>] deactivate_locked_super+0x26/0x52
> kernel: [<ffffffff820f0ad2>] deactivate_super+0x45/0x4a
> kernel: [<ffffffff821074b9>] mntput_no_expire+0x110/0x118
> kernel: [<ffffffff82108331>] sys_umount+0x306/0x331
> kernel: [<ffffffff82041bf6>] ? sigprocmask+0x63/0x67
> kernel: [<ffffffff82386942>] system_call_fastpath+0x16/0x1b
  I think I see the problem
  Hum, either we missed a wakeup or ioend gets stuck for some reason and is
never processed. Can you maybe post sysrq-w output once the kernel gets
stuck? Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
