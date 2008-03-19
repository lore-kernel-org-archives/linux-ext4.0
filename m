From: Andreas Dilger <adilger@Sun.COM>
Subject: Re: [2.6.25-rc5-ext4-36c86] attempt to access beyond end of device
Date: Wed, 19 Mar 2008 19:35:00 +0800
Message-ID: <20080319113500.GI2971@webber.adilger.int>
References: <18399.36935.640758.796880@frecb006361.adech.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Solofo.Ramangalahy@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:53414 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982AbYCSTdr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Mar 2008 15:33:47 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2JBZ7VI021786
	for <linux-ext4@vger.kernel.org>; Wed, 19 Mar 2008 04:35:07 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JXZ00D016RZZR00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 19 Mar 2008 04:35:07 -0700 (PDT)
In-reply-to: <18399.36935.640758.796880@frecb006361.adech.frec.bull.fr>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 18, 2008  10:49 +0100, Solofo.Ramangalahy@bull.net wrote:
> During stress testing (workload: racer from ltp + fio/iometer), here
> is an error I am encountering:
> 8<------------------------------------------------------------------------------
> kernel: WARNING: at fs/buffer.c:1680 __block_write_full_page+0xd4/0x2af()
> kernel: Modules linked in:
> kernel: Pid: 13113, comm: dd Not tainted 2.6.25-rc5-ext4-36c86 #2

You should print out the page->mapping->host->i_ino in this message
and then you can possibly examine the filesystem to see if it is
a corrupt block allocation, or possibly random garbage in the block.

> kernel:  [<ffffffff8025da55>] balance_dirty_pages_ratelimited_nr+0x186/0x2f8
> kernel:  [<ffffffff80258119>] generic_file_buffered_write+0x1f5/0x622
> kernel:  [<ffffffff802f6091>] ext4_mark_iloc_dirty+0x459/0x4cc
> kernel:  [<ffffffff80317b48>] jbd2_journal_stop+0x24b/0x257
> kernel:  [<ffffffff80258889>] __generic_file_aio_write_nolock+0x343/0x377
> kernel:  [<ffffffff80258921>] generic_file_aio_write+0x64/0xc4
> kernel:  [<ffffffff802f42c3>] ext4_file_write+0xa0/0x125
> kernel:  [<ffffffff8027e4e0>] do_sync_write+0xd1/0x118
> kernel:  [<ffffffff8023f2c5>] autoremove_wake_function+0x0/0x2e
> kernel:  [<ffffffff8027ec31>] vfs_write+0xad/0x136
> kernel:  [<ffffffff8027f166>] sys_write+0x45/0x6e
> kernel:  [<ffffffff8020b04b>] system_call_after_swapgs+0x7b/0x80
> kernel:
> kernel: ---[ end trace 05e1c77d40267d33 ]---
> kernel: attempt to access beyond end of device
> kernel: sdc: rw=1, want=355304755152, limit=16064512
> kernel: lost page write due to I/O error on sdc

Hmm, is this filesystem formatted with 64BIT?  We shouldn't be getting
64-bit block numbers otherwise.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

