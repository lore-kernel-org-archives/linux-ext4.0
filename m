From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Delayed allocation and journal locking order inversion.
Date: Thu, 29 May 2008 13:20:56 +0530
Message-ID: <20080529075056.GA24919@skywalker>
References: <20080528091648.GA15851@skywalker> <20080528100833.GC8289@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:33142 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbYE2HvT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 May 2008 03:51:19 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m4T7owLV013780
	for <linux-ext4@vger.kernel.org>; Thu, 29 May 2008 13:20:58 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4T7oitq524480
	for <linux-ext4@vger.kernel.org>; Thu, 29 May 2008 13:20:44 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m4T7ovDS016888
	for <linux-ext4@vger.kernel.org>; Thu, 29 May 2008 13:20:57 +0530
Content-Disposition: inline
In-Reply-To: <20080528100833.GC8289@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 28, 2008 at 12:08:33PM +0200, Jan Kara wrote:
>   Hi Aneesh,
>   The question here is, who is holding the lock from the page we wait
> for here. The two processes you show below don't seem to hold it. I'll
> check the full log ... searching ... I see!
>   The problem is in generic_write_end()! It calls mark_inode_dirty() under
> page lock. That can possibly start a new transaction (which happened in
> your case) and that violates lock ordering (mark_inode_dirty() got stuck
> waiting for journal commit which is stuck waiting for other user to do
> journal_stop which waits for the page lock). Actually, there is no real
> need to call mark_inode_dirty() from under page lock - we just need to
> update i_size there. Something like the patch attached (untested)?
> 

The patch works.   Peter Zijlstra have patches to add lockdep annotation
to lock_page. I guess we will have to test the lock inversion patch with
the lockdep annotation to catch the deadlock scenarios like above.

http://programming.kicks-ass.net/kernel-patches/lockdep-page_lock/

Regarding delalloc I still have issues. The writepage can get called
with buffer_head marked delay and dirty as show below. This will result
in block allocation under lock_page.

RIP: 0010:[<ffffffff8030cc64>]  [<ffffffff8030cc64>] ext4_da_writepage+0x26/0xad

Call Trace:
 [<ffffffff8026999f>] shrink_page_list+0x31e/0x588
 [<ffffffff80269d35>] shrink_inactive_list+0x12c/0x40d
 [<ffffffff805ce6a2>] ? _spin_unlock_irqrestore+0x3f/0x68
 [<ffffffff8024e83a>] ? trace_hardirqs_on+0xf1/0x115
 [<ffffffff805ce6af>] ? _spin_unlock_irqrestore+0x4c/0x68
 [<ffffffff803975b7>] ? __up_read+0x8c/0x94
 [<ffffffff8026a0f3>] shrink_zone+0xdd/0x103
 [<ffffffff8026ad69>] kswapd+0x34b/0x53e
 [<ffffffff80268e4d>] ? isolate_pages_global+0x0/0x34
 [<ffffffff80243ff4>] ? autoremove_wake_function+0x0/0x36
 [<ffffffff805ce6af>] ? _spin_unlock_irqrestore+0x4c/0x68
 [<ffffffff8026aa1e>] ? kswapd+0x0/0x53e
 [<ffffffff80243d1b>] kthread+0x44/0x6b
 [<ffffffff8020c1f8>] child_rip+0xa/0x12
 [<ffffffff8020b8e3>] ? restore_args+0x0/0x30
 [<ffffffff80243fcf>] ? kthreadd+0x16b/0x190
 [<ffffffff80243cd7>] ? kthread+0x0/0x6b
 [<ffffffff8020c1ee>] ? child_rip+0x0/0x12


-aneesh
