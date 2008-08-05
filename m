From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] jbd jbd2: fix dio write returning EIO
  whentry_to_release_page fails
Date: Tue, 05 Aug 2008 11:36:15 +0900
Message-ID: <6.0.0.20.2.20080805104519.03c9b3d8@172.19.0.2>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
 <20080804145047.04794bf3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, jack@suse.cz, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:60491 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbYHECiP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2008 22:38:15 -0400
In-Reply-To: <20080804145047.04794bf3.akpm@linux-foundation.org>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
 <20080804145047.04794bf3.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


>> 
>> diff -Nrup linux-2.6.27-rc1.org/fs/jbd/transaction.c 
>linux-2.6.27-rc1/fs/jbd/transaction.c
>> --- linux-2.6.27-rc1.org/fs/jbd/transaction.c	2008-07-29 
>19:28:47.000000000 +0900
>> +++ linux-2.6.27-rc1/fs/jbd/transaction.c	2008-07-29 20:40:12.000000000 +0900
>> @@ -1764,6 +1764,12 @@ int journal_try_to_free_buffers(journal_
>>  	*/
>>  	if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) {
>>  		journal_wait_for_transaction_sync_data(journal);
>> +
>> +		bh = head;
>> +		do {
>> +			while (atomic_read(&bh->b_count))
>> +				schedule();
>> +		} while ((bh = bh->b_this_page) != head);
>>  		ret = try_to_free_buffers(page);
>>  	}
>
>The loop is problematic.  If the scheduler decides to keep running this
>task then we have a busy loop.  If this task has realtime policy then
>it might even lock up the kernel.
> 
>Perhaps we can use wait_on_page_writeback()?
>

We cannot use wait_on_page_writeback() to wait for releasing bh ref because
in ext3_ordered_writepage() bh ref is grabbed and released through walk_page_buffers
so between both walk_page_buffers, it remains taking a bh ref even if end_page_writeback
is performed.
      ->ext3_ordered_writepage()
     	   walk_page_buffers() <- take a bh ref
 	   block_write_full_page() <- unlock_page
		: <- end_page_writeback
                : <- race! (dio write->try_to_release_page fails): ---> remains taking a bh ref
      	   walk_page_buffers() <-release a bh ref

