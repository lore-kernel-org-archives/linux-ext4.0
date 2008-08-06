From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] jbd jbd2: fix dio write
  returningEIOwhentry_to_release_page fails
Date: Wed, 06 Aug 2008 17:39:28 +0900
Message-ID: <6.0.0.20.2.20080806173503.042e63e0@172.19.0.2>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
 <20080804145047.04794bf3.akpm@linux-foundation.org>
 <1217907353.7611.39.camel@think.oraclecorp.com>
 <6.0.0.20.2.20080805134429.044569a0@172.19.0.2>
 <1217953055.7899.11.camel@think.oraclecorp.com>
 <1217971027.7516.20.camel@mingming-laptop>
 <6.0.0.20.2.20080806153517.04146a50@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:60263 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763405AbYHFIl3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Aug 2008 04:41:29 -0400
In-Reply-To: <6.0.0.20.2.20080806153517.04146a50@172.19.0.2>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
 <20080804145047.04794bf3.akpm@linux-foundation.org>
 <1217907353.7611.39.camel@think.oraclecorp.com>
 <6.0.0.20.2.20080805134429.044569a0@172.19.0.2>
 <1217953055.7899.11.camel@think.oraclecorp.com>
 <1217971027.7516.20.camel@mingming-laptop>
 <6.0.0.20.2.20080806153517.04146a50@172.19.0.2>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


>I modified my patch.
>I do not change Checking b_count in a loop, but introduce 
>set_current_state(TASK_UNINTERRUPTIBLE) to mitigate the loop. I think this can 
>lead to avoid busy loop.
>I used the same approach of do_sync_read()->wait_on_retry_sync_kiocb or 
>some drivers(qla2xxx).
>
>Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
>
>diff -Nrup linux-2.6.27-rc1.org/fs/jbd/transaction.c 
>linux-2.6.27-rc1.jbdfix/fs/jbd/transaction.c
>--- linux-2.6.27-rc1.org/fs/jbd/transaction.c	2008-07-29 19:28:47.000000000 +0900
>+++ linux-2.6.27-rc1.jbdfix/fs/jbd/transaction.c	2008-08-06 
>13:35:37.000000000 +0900
>@@ -1764,6 +1764,15 @@ int journal_try_to_free_buffers(journal_
> 	*/
> 	if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) {
> 		journal_wait_for_transaction_sync_data(journal);
>+
>+		bh = head;
>+		do {
>+			while (atomic_read(&bh->b_count)) {
>+				set_current_state(TASK_UNINTERRUPTIBLE);
>+				schedule();
>+				__set_current_state(TASK_RUNNING);
>+			}
>+		} while ((bh = bh->b_this_page) != head);
> 		ret = try_to_free_buffers(page);
> 	}

Sorry, the thread entering this loop sleeps infinitely.
We should add some wait queue and implement wait/wakeup code.

