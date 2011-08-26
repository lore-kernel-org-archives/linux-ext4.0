From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [URGENT PATCH] ext4: fix potential deadlock in
 ext4_evict_inode()
Date: Fri, 26 Aug 2011 11:52:34 -0400
Message-ID: <20110826155234.GC5176@thunk.org>
References: <E1QwnAu-00087H-8X@tytso-glaptop.cam.corp.google.com>
 <20110826073507.GZ3162@dastard>
 <20110826084403.GA3162@dastard>
 <4E576152.9060405@tao.ma>
 <20110826092426.GB3162@dastard>
 <4E57670B.6070205@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	Jiaying Zhang <jiayingz@google.com>, linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54685 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679Ab1HZPwl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Aug 2011 11:52:41 -0400
Content-Disposition: inline
In-Reply-To: <4E57670B.6070205@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 26, 2011 at 05:27:39PM +0800, Tao Ma wrote:
> No, it doesn't mean the ext4_truncate. But another race pasted below.
> 
> Flush inode's i_completed_io_list before calling ext4_io_wait to
> prevent the following deadlock scenario: A page fault happens while
> some process is writing inode A. During page fault,
> shrink_icache_memory is called that in turn evicts another inode
> B. Inode B has some pending io_end work so it calls ext4_ioend_wait()
> that waits for inode B's i_ioend_count to become zero. However, inode
> B's ioend work was queued behind some of inode A's ioend work on the
> same cpu's ext4-dio-unwritten workqueue. As the ext4-dio-unwritten
> thread on that cpu is processing inode A's ioend work, it tries to
> grab inode A's i_mutex lock. Since the i_mutex lock of inode A is
> still hold before the page fault happened, we enter a deadlock.

... but that shouldn't be a problem since we're not holding A's
i_mutex at this point, right?  Or am I missing something?

	   	       	       	       - Ted
