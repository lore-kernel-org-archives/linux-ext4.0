From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [BUG][PATCH 1/4] ext3: fix a cause of __schedule_bug via	blkdev_releasepage
Date: Fri, 12 Dec 2008 09:54:18 +0900
Message-ID: <4941B63A.3090302@jp.fujitsu.com>
References: <20081202200647.72cc5807.toshi.okajima@jp.fujitsu.com> <20081208140138.GA17700@mit.edu>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: aneesh.kumar@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35425 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbYLLAyZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Dec 2008 19:54:25 -0500
Received: from m1.gw.fujitsu.co.jp ([10.0.50.71])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id mBC0sNu8016518
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Fri, 12 Dec 2008 09:54:23 +0900
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 113922AEA8F
	for <linux-ext4@vger.kernel.org>; Fri, 12 Dec 2008 09:54:23 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id CF9FE45DD72
	for <linux-ext4@vger.kernel.org>; Fri, 12 Dec 2008 09:54:22 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 5F7DD1DB804A
	for <linux-ext4@vger.kernel.org>; Fri, 12 Dec 2008 09:54:22 +0900 (JST)
Received: from m105.s.css.fujitsu.com (m105.s.css.fujitsu.com [10.249.87.105])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 7C7951DB803C
	for <linux-ext4@vger.kernel.org>; Fri, 12 Dec 2008 09:54:21 +0900 (JST)
In-Reply-To: <20081208140138.GA17700@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted-san,
Thank you for your reviewing.

 > Toshiyuki-san,
 >
 > My apologies for not having a chance to review your patches; things
 > have been rather busy for me.  There were a couple of shortcomings in
 > your patch series, and I think there is a better way of solving the
 > issue at hand.  First of all, patches #1 and #2 use a new function
 > which is not actually defined until patches #3 and #4, respectively.
 > This can make it difficult for people who are trying to use "git
 > bisect" to try to localize the root cause of a problem.
 >
 > Secondly, the introduction of a large number of wrapper functions
 > increases stack utilization, and makes the call depth deeper (and in
 > the long run, each increase in call depth makes the code that much
 > harder to trace through and understand), and so it should be done only
 > as last resort.  Fortunately, there is a simpler way of fixing this
 > problem.  I include the inter-diff below, but I will fold this into
 > the current blkdev_releasepage() patches that are in the ext4 patch
 > queue.
 >
 > Best regards,
 >
 > 					- Ted
 >
 > P.S.  Note that this patch is functionally identical to what you
 > proposed in your patch series, but since the gfp_wait mask already
 > controlls whether or not log_wait_commit() is called, instead of
 > introducing a new functional parameter, we just mask off __GFP_WAIT
 > before calling jbd2_journal_try_to_free_buffers.  I'll make a similar
 > change to the ext3 patch, and attach the two revised patches to this
 > mail thread.

Through the idea as follows,  I agree to your change.

-----------------------------------------------------------------------------
To tell the truth, at first, I imagined the same patch as yours to fix this
problem. But I have made another patch because I thought that ext3(or ext4)
should not know the contents of the processing of journal_try_to_free_buffers
  in detail. (ext3 should not know there is a possibility to call
journal_wait_for_transaction_sync_data from journal_try_to_free_buffers.)
So, I have made a new function, journal_try_to_free_metadata_buffers
to release only metadata buffer_heads.
(I wanted a function which is the almost same as journal_try_to_free_buffers
except calling journal_wait_for_transaction_sync_data from it.)
However, this new function needed big changes, you know.

I reconsidered what was the most suitable patch to fix this problem
after I read your mail (patch).
And then, I thought that it was important to make the most concise patch
to fix only a root cause. Big patch is not easy to understand even if it is
more logical one.

Therefore, there is the fact that ext3_release_metadata must not sleep because
it can get a spinlock, and then, only changing ext3_release_metadata to the
logic to make it not sleep is the simplest fix for this problem.
-----------------------------------------------------------------------------

Best Regards,
Toshiyuki Okajima

