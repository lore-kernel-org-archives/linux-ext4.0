From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] jbd jbd2: fix dio write returning EIO
  whentry_to_release_page fails
Date: Tue, 05 Aug 2008 13:51:41 +0900
Message-ID: <6.0.0.20.2.20080805134429.044569a0@172.19.0.2>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
 <20080804145047.04794bf3.akpm@linux-foundation.org>
 <1217907353.7611.39.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, jack@suse.cz, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1217907353.7611.39.camel@think.oraclecorp.com>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
 <20080804145047.04794bf3.akpm@linux-foundation.org>
 <1217907353.7611.39.camel@think.oraclecorp.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


>> > 
>> > diff -Nrup linux-2.6.27-rc1.org/fs/jbd/transaction.c 
>linux-2.6.27-rc1/fs/jbd/transaction.c
>> > --- linux-2.6.27-rc1.org/fs/jbd/transaction.c	2008-07-29 
>19:28:47.000000000 +0900
>> > +++ linux-2.6.27-rc1/fs/jbd/transaction.c	2008-07-29 20:40:12.000000000 +0900
>> > @@ -1764,6 +1764,12 @@ int journal_try_to_free_buffers(journal_
>> >  	*/
>> >  	if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) {
>> >  		journal_wait_for_transaction_sync_data(journal);
>> > +
>> > +		bh = head;
>> > +		do {
>> > +			while (atomic_read(&bh->b_count))
>> > +				schedule();
>> > +		} while ((bh = bh->b_this_page) != head);
>> >  		ret = try_to_free_buffers(page);
>> >  	}
>> 
>> The loop is problematic.  If the scheduler decides to keep running this
>> task then we have a busy loop.  If this task has realtime policy then
>> it might even lock up the kernel.
>> 
>
>ocfs2 calls journal_try_to_free_buffers too, looping on b_count might
>not be the best idea there either.
>
>This code gets called from releasepage, which is used other places than
>the O_DIRECT invalidation paths, I'd be worried about performance
>problems here.
>

try_to_release_page has gfp_mask parameter. So when try_to_releasepage
is called from performance sensitive part, gfp_mask should not be set.
b_count check loop is inside of (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS) check.

