From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] jbd jbd2: fix dio write returning
  EIOwhentry_to_release_page fails
Date: Wed, 06 Aug 2008 15:55:47 +0900
Message-ID: <6.0.0.20.2.20080806153517.04146a50@172.19.0.2>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
 <20080804145047.04794bf3.akpm@linux-foundation.org>
 <1217907353.7611.39.camel@think.oraclecorp.com>
 <6.0.0.20.2.20080805134429.044569a0@172.19.0.2>
 <1217953055.7899.11.camel@think.oraclecorp.com>
 <1217971027.7516.20.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1217971027.7516.20.camel@mingming-laptop>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
 <20080804145047.04794bf3.akpm@linux-foundation.org>
 <1217907353.7611.39.camel@think.oraclecorp.com>
 <6.0.0.20.2.20080805134429.044569a0@172.19.0.2>
 <1217953055.7899.11.camel@think.oraclecorp.com>
 <1217971027.7516.20.camel@mingming-laptop>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


>> > >> > diff -Nrup linux-2.6.27-rc1.org/fs/jbd/transaction.c 
>> > >linux-2.6.27-rc1/fs/jbd/transaction.c
>> > >> > --- linux-2.6.27-rc1.org/fs/jbd/transaction.c	2008-07-29 
>> > >19:28:47.000000000 +0900
>> > >> > +++ linux-2.6.27-rc1/fs/jbd/transaction.c	2008-07-29 
>20:40:12.000000000 +0900
>> > >> > @@ -1764,6 +1764,12 @@ int journal_try_to_free_buffers(journal_
>> > >> >  	*/
>> > >> >  	if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) {
>> > >> >  		journal_wait_for_transaction_sync_data(journal);
>> > >> > +
>> > >> > +		bh = head;
>> > >> > +		do {
>> > >> > +			while (atomic_read(&bh->b_count))
>> > >> > +				schedule();
>> > >> > +		} while ((bh = bh->b_this_page) != head);
>> > >> >  		ret = try_to_free_buffers(page);
>> > >> >  	}
>> > >> 
>> > >> The loop is problematic.  If the scheduler decides to keep running this
>> > >> task then we have a busy loop.  If this task has realtime policy then
>> > >> it might even lock up the kernel.
>> > >> 
>> > >
>> > >ocfs2 calls journal_try_to_free_buffers too, looping on b_count might
>> > >not be the best idea there either.
>> > >
>> > >This code gets called from releasepage, which is used other places than
>> > >the O_DIRECT invalidation paths, I'd be worried about performance
>> > >problems here.
>> > >
>> > 
>> > try_to_release_page has gfp_mask parameter. So when try_to_releasepage
>> > is called from performance sensitive part, gfp_mask should not be set.
>> > b_count check loop is inside of (gfp_mask & __GFP_WAIT) && (gfp_mask & 
>__GFP_FS) check.
>> 
>> Looks like try_to_free_pages will go into releasepage with wait & fs
>> both set.  This kind of change would make me very nervous.
>> 
>
>Hi Chris,
>
>The gfp_mask try_to_free_pages() takes from it's caller will past it
>down to try_to_release_page().  Based on the meaning of __GFP_WAIT and
>GFP_FS, if the upper level caller set these two flags,  I assume the
>upper level caller expect delay and wait for fs to finish?
>
>
>But I agree that using a loop in journal_try_to_free_buffers() to wait
>for the busy bh release the counter is expensive...

I modified my patch.
I do not change Checking b_count in a loop, but introduce 
set_current_state(TASK_UNINTERRUPTIBLE) to mitigate the loop. I think this can 
lead to avoid busy loop.
I used the same approach of do_sync_read()->wait_on_retry_sync_kiocb or some drivers(qla2xxx).

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.27-rc1.org/fs/jbd/transaction.c linux-2.6.27-rc1.jbdfix/fs/jbd/transaction.c
--- linux-2.6.27-rc1.org/fs/jbd/transaction.c	2008-07-29 19:28:47.000000000 +0900
+++ linux-2.6.27-rc1.jbdfix/fs/jbd/transaction.c	2008-08-06 13:35:37.000000000 +0900
@@ -1764,6 +1764,15 @@ int journal_try_to_free_buffers(journal_
 	 */
 	if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) {
 		journal_wait_for_transaction_sync_data(journal);
+
+		bh = head;
+		do {
+			while (atomic_read(&bh->b_count)) {
+				set_current_state(TASK_UNINTERRUPTIBLE);
+				schedule();
+				__set_current_state(TASK_RUNNING);
+			}
+		} while ((bh = bh->b_this_page) != head);
 		ret = try_to_free_buffers(page);
 	}
 

