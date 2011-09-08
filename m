From: Marcin M <gmane@mejor.pl>
Subject: Re: kernel thread "flush-254:12" eats 100% CPU
Date: Thu, 08 Sep 2011 11:45:55 +0200
Message-ID: <j4a2sj$f4v$1@dough.gmane.org>
References: <j483kt$en1$1@dough.gmane.org> <4E684F8C.3050308@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:51209 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758163Ab1IHJqJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Sep 2011 05:46:09 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1R1bBQ-0005pB-4d
	for linux-ext4@vger.kernel.org; Thu, 08 Sep 2011 11:46:08 +0200
Received: from cadera.waw.pl ([62.121.127.119])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 08 Sep 2011 11:46:08 +0200
Received: from gmane by cadera.waw.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 08 Sep 2011 11:46:08 +0200
In-Reply-To: <4E684F8C.3050308@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

W dniu 08.09.2011 07:15, Tao Ma pisze:
> So do you have the backstrace for it? Just wonder what it is doing.
> echo t>  /proc/sysrq-trigger should tell us what the flusher is doing at
> that time.

I don't have backstrace, if you tellme how to get it then i'll do it:)
I did echo t>.... when flush was too active, here it is:

[70946.742426] flush-254:12    R  running task        0 27198      2 
0x00000000
[70946.742426]  ffff88001ea5bde0 0000000000000046 0000000000000265 
ffff88001ead56a0
[70946.742426]  000000000000fe00 ffff88000f515fd8 0000000000004000 
ffff88000f514000
[70946.742426]  ffff88000f515fd8 000000000000fe00 ffff88001ea5bde0 
000000000000fe00
[70946.742426] Call Trace:
[70946.742426]  [<ffffffff8119d2c3>] ? 
radix_tree_gang_lookup_tag_slot+0x83/0xe0
[70946.742426]  [<ffffffff81083a43>] ? find_get_pages_tag+0x33/0x130
[70946.742426]  [<ffffffff8102ed7d>] ? __cond_resched+0x1d/0x30
[70946.742426]  [<ffffffff812fb50f>] ? _cond_resched+0x2f/0x40
[70946.742426]  [<ffffffff811353ef>] ? write_cache_pages_da+0x32f/0x380
[70946.742426]  [<ffffffff8115d7f5>] ? jbd2__journal_start+0xd5/0x120
[70946.742426]  [<ffffffff8113f358>] ? ext4_journal_start_sb+0x68/0x170
[70946.742426]  [<ffffffff8113567e>] ? ext4_da_writepages+0x23e/0x440
[70946.742426]  [<ffffffff810ee72e>] ? writeback_single_inode+0x11e/0x2c0
[70946.742426]  [<ffffffff810eecb0>] ? writeback_sb_inodes+0x1c0/0x280
[70946.742426]  [<ffffffff810ef17e>] ? __writeback_inodes_wb+0x8e/0xc0
[70946.742426]  [<ffffffff810ef383>] ? wb_writeback+0x1d3/0x1e0
[70946.742426]  [<ffffffff810e4791>] ? get_nr_dirty_inodes+0x51/0x80
[70946.742426]  [<ffffffff810efbfe>] ? wb_do_writeback+0x1ce/0x1e0
[70946.742426]  [<ffffffff810efc92>] ? bdi_writeback_thread+0x82/0x150
[70946.742426]  [<ffffffff810efc10>] ? wb_do_writeback+0x1e0/0x1e0
[70946.742426]  [<ffffffff810efc10>] ? wb_do_writeback+0x1e0/0x1e0
[70946.742426]  [<ffffffff81050a46>] ? kthread+0x96/0xa0
[70946.742426]  [<ffffffff812fe974>] ? kernel_thread_helper+0x4/0x10
[70946.742426]  [<ffffffff810509b0>] ? kthread_worker_fn+0x120/0x120
[70946.742426]  [<ffffffff812fe970>] ? gs_change+0xb/0xb


Thanks.

