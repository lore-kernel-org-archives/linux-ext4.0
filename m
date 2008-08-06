From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] jbd jbd2: fix dio write returning
  EIOwhentry_to_release_page fails
Date: Wed, 06 Aug 2008 11:04:38 +0900
Message-ID: <6.0.0.20.2.20080806103946.042f31e0@172.19.0.2>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
 <20080804145047.04794bf3.akpm@linux-foundation.org>
 <6.0.0.20.2.20080805104519.03c9b3d8@172.19.0.2>
 <1217972154.7516.25.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:47495 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbYHFCGk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Aug 2008 22:06:40 -0400
In-Reply-To: <1217972154.7516.25.camel@mingming-laptop>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
 <20080804145047.04794bf3.akpm@linux-foundation.org>
 <6.0.0.20.2.20080805104519.03c9b3d8@172.19.0.2>
 <1217972154.7516.25.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


At 06:35 08/08/06, Mingming Cao wrote:
>
>$Bi|%#(B 2008-08-05$Bh<8iSd(B 11:36 +0900$B~>7)(Bisashi Hifumi$BifRk!s~>S(B
>> >> 
>> >> diff -Nrup linux-2.6.27-rc1.org/fs/jbd/transaction.c 
>> >linux-2.6.27-rc1/fs/jbd/transaction.c
>> >> --- linux-2.6.27-rc1.org/fs/jbd/transaction.c	2008-07-29 
>> >19:28:47.000000000 +0900
>> >> +++ linux-2.6.27-rc1/fs/jbd/transaction.c	2008-07-29 
>20:40:12.000000000 +0900
>> >> @@ -1764,6 +1764,12 @@ int journal_try_to_free_buffers(journal_
>> >>  	*/
>> >>  	if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) {
>> >>  		journal_wait_for_transaction_sync_data(journal);
>> >> +
>> >> +		bh = head;
>> >> +		do {
>> >> +			while (atomic_read(&bh->b_count))
>> >> +				schedule();
>> >> +		} while ((bh = bh->b_this_page) != head);
>> >>  		ret = try_to_free_buffers(page);
>> >>  	}
>> >
>> >The loop is problematic.  If the scheduler decides to keep running this
>> >task then we have a busy loop.  If this task has realtime policy then
>> >it might even lock up the kernel.
>> > 
>> >Perhaps we can use wait_on_page_writeback()?
>> >
>> 
>> We cannot use wait_on_page_writeback() to wait for releasing bh ref because
>> in ext3_ordered_writepage() bh ref is grabbed and released through 
>walk_page_buffers
>> so between both walk_page_buffers, it remains taking a bh ref even if 
>end_page_writeback
>> is performed.
>>       ->ext3_ordered_writepage()
>>      	   walk_page_buffers() <- take a bh ref
>>  	   block_write_full_page() <- unlock_page
>> 		: <- end_page_writeback
>>                 : <- race! (dio write->try_to_release_page fails): ---> 
>remains taking a bh ref
>>       	   walk_page_buffers() <-release a bh ref
>> 
>
>Okay, I see the race window, DIO could come in before
>walk_page_buffers() release the bh reference. So far I don't see a nicer
>way to sync between background  writeout with DIO path yet...
>

I know that b_count check on loop is not good, but I do not have better 
idea to fix this yet too.
The race window is very short and rare, so I think the impact of introducing
the loop is small even if this loop can be busy loop due to scheduler circumstances.

