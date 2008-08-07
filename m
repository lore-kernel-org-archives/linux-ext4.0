From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] jbd jbd2: fix dio write returning
  EIOwhentry_to_release_page fails
Date: Thu, 07 Aug 2008 12:15:14 +0900
Message-ID: <6.0.0.20.2.20080807115853.03f95b78@172.19.0.2>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
 <20080804145047.04794bf3.akpm@linux-foundation.org>
 <1217907353.7611.39.camel@think.oraclecorp.com>
 <6.0.0.20.2.20080805134429.044569a0@172.19.0.2>
 <1217953055.7899.11.camel@think.oraclecorp.com>
 <1217971027.7516.20.camel@mingming-laptop>
 <1218029114.15342.58.camel@think.oraclecorp.com>
 <20080806135337.GA3615@duck.suse.cz>
 <1218063477.6383.41.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Cc: Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:36475 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYHGDRR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Aug 2008 23:17:17 -0400
In-Reply-To: <1218063477.6383.41.camel@mingming-laptop>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
 <20080804145047.04794bf3.akpm@linux-foundation.org>
 <1217907353.7611.39.camel@think.oraclecorp.com>
 <6.0.0.20.2.20080805134429.044569a0@172.19.0.2>
 <1217953055.7899.11.camel@think.oraclecorp.com>
 <1217971027.7516.20.camel@mingming-laptop>
 <1218029114.15342.58.camel@think.oraclecorp.com>
 <20080806135337.GA3615@duck.suse.cz>
 <1218063477.6383.41.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


At 07:57 08/08/07, Mingming Cao wrote:
>
>$Bi|%#(B 2008-08-06$Bh:2iSd(B 15:53 +0200$B~>7+(Ban Kara$BifRk!s~>S(B
>> On Wed 06-08-08 
>09:25:13, Chris Mason wrote:
>> > On Tue, 2008-08-05 at 14:17 -0700, Mingming Cao wrote:
>> > > $Bi|%#(B 2008-08-05$Bh<8iSd(B 12:17 -0400$B~>7$(Bhris Mason$BifRk!s~>S(B
>> > > > On 
>Tue, 2008-08-05 at 13:51 +0900, Hisashi Hifumi wrote:
>> > > > > >> > 
>> > > > > >> > diff -Nrup linux-2.6.27-rc1.org/fs/jbd/transaction.c 
>> > > > > >linux-2.6.27-rc1/fs/jbd/transaction.c
>> > > > > >> > --- linux-2.6.27-rc1.org/fs/jbd/transaction.c	2008-07-29 
>> > > > > >19:28:47.000000000 +0900
>> > > > > >> > +++ linux-2.6.27-rc1/fs/jbd/transaction.c	2008-07-29 
>20:40:12.000000000 +0900
>> > > > > >> > @@ -1764,6 +1764,12 @@ int journal_try_to_free_buffers(journal_
>> > > > > >> >  	*/
>> > > > > >> >  	if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & 
>__GFP_FS)) {
>> > > > > >> >  		journal_wait_for_transaction_sync_data(journal);
>> > > > > >> > +
>> > > > > >> > +		bh = head;
>> > > > > >> > +		do {
>> > > > > >> > +			while (atomic_read(&bh->b_count))
>> > > > > >> > +				schedule();
>> > > > > >> > +		} while ((bh = bh->b_this_page) != head);
>> > > > > >> >  		ret = try_to_free_buffers(page);
>> > > > > >> >  	}
>> > > > > >> 
>> > > > > >> The loop is problematic.  If the scheduler decides to keep 
>running this
>> > > > > >> task then we have a busy loop.  If this task has realtime 
>policy then
>> > > > > >> it might even lock up the kernel.
>> > > > > >> 
>> > > > > >
>> > > > > >ocfs2 calls journal_try_to_free_buffers too, looping on b_count might
>> > > > > >not be the best idea there either.
>> > > > > >
>> > > > > >This code gets called from releasepage, which is used other 
>places than
>> > > > > >the O_DIRECT invalidation paths, I'd be worried about performance
>> > > > > >problems here.
>> > > > > >
>> > > > > 
>> > > > > try_to_release_page has gfp_mask parameter. So when try_to_releasepage
>> > > > > is called from performance sensitive part, gfp_mask should not be set.
>> > > > > b_count check loop is inside of (gfp_mask & __GFP_WAIT) && 
>(gfp_mask & __GFP_FS) check.
>> > > > 
>> > > > Looks like try_to_free_pages will go into releasepage with wait & fs
>> > > > both set.  This kind of change would make me very nervous.
>> > > > 
>> > > 
>> > > Hi Chris,
>> > > 
>> > > The gfp_mask try_to_free_pages() takes from it's caller will past it
>> > > down to try_to_release_page().  Based on the meaning of __GFP_WAIT and
>> > > GFP_FS, if the upper level caller set these two flags,  I assume the
>> > > upper level caller expect delay and wait for fs to finish?
>> > > 
>> > > 
>> > > But I agree that using a loop in journal_try_to_free_buffers() to wait
>> > > for the busy bh release the counter is expensive...
>> > 
>> > I rediscovered your old thread about trying to do this in a launder_page
>> > call ;)
>>   Yes, we thought about using launder_page() before :).
>> 
>> > Does it make more sense to fix do_launder_page to call into the FS on
>> > every page, and let the FS check for PageDirty on its own?  That way
>> > invalidate_inode_pages2_range basically gets its own private call into
>> > the FS that says wait around until this page is really free.
>>   That would certainly work as well. But IMHO waiting for ->writepage()
>> call to finish isn't really a big deal even in try_to_release_page() if
>> __GFP_FS (and __GFP_WAIT) is set. The only problem is that there is no
>> effective way to do so and so Hisashi used that "wait for b_count to drop"
>> which looks really scary and I don't like it as well.
>> 
>
>I was  looking at the comment in invalidate_complete_page2(), which is
>now only called from DIO path, it saids
>
>/*
> * This is like invalidate_complete_page(), except it ignores the page's
> * refcount.  We do this because invalidate_inode_pages2() needs
>stronger
> * invalidation guarantees, and cannot afford to leave pages behind
>because
> * shrink_page_list() has a temp ref on them, or because they're
>transiently
> * sitting in the lru_cache_add() pagevecs.
> */
>
>
>I am wondering why we need stronger invalidate hurantees for DIO->
>invalidate_inode_pages_range(),which force the page being removed from
>page cache? In case of bh is busy due to ext3 writeout,
>journal_try_to_free_buffers() could return different error number(EBUSY)
>to try_to_releasepage() (instead of EIO).  In that case,  could we just
>leave the page in the cache, clean pageuptodate() (to force later buffer
>read to read from disk) and then invalidate_complete_page2() return
>successfully? Any issue with this way?

My idea is that journal_try_to_free_buffers returns EBUSY if it fails due to
bh busy, and dio write falls back to buffered write. This is easy to fix.


