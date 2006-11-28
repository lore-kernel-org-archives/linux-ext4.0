From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Boot failure with ext2 and initrds
Date: Tue, 28 Nov 2006 13:04:53 -0800
Message-ID: <1164747894.3769.77.camel@dyn9047017103.beaverton.ibm.com>
References: <20061114014125.dd315fff.akpm@osdl.org>
	 <20061114184919.GA16020@skynet.ie>
	 <Pine.LNX.4.64.0611141858210.11956@blonde.wat.veritas.com>
	 <20061114113120.d4c22b02.akpm@osdl.org>
	 <Pine.LNX.4.64.0611142111380.19259@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0611151404260.11929@blonde.wat.veritas.com>
	 <20061115214534.72e6f2e8.akpm@osdl.org> <455C0B6F.7000201@us.ibm.com>
	 <20061115232228.afaf42f2.akpm@osdl.org>
	 <1163666960.4310.40.camel@localhost.localdomain>
	 <20061116011351.1401a00f.akpm@osdl.org>
	 <1163708116.3737.12.camel@dyn9047017103.beaverton.ibm.com>
	 <20061116132724.1882b122.akpm@osdl.org>
	 <Pine.LNX.4.64.0611201544510.16530@blonde.wat.veritas.com>
	 <1164073652.20900.34.camel@dyn9047017103.beaverton.ibm.com>
	 <Pine.LNX.4.64.0611210508270.22957@blonde.wat.veritas.com>
	 <1164156193.3804.48.camel@dyn9047017103.beaverton.ibm.com>
	 <Pine.LNX.4.64.0611281659190.29701@blonde.wat.veritas.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@osdl.org>, Mel Gorman <mel@skynet.ie>,
	"Martin J. Bligh" <mbligh@mbligh.org>,
	linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:49795 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S1755627AbWK1VE7
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Nov 2006 16:04:59 -0500
To: Hugh Dickins <hugh@veritas.com>
In-Reply-To: <Pine.LNX.4.64.0611281659190.29701@blonde.wat.veritas.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2006-11-28 at 17:38 +0000, Hugh Dickins wrote:

> >
> > And could you check the start and end block for every rsv_window_add and
> > rsv_window_remove, to see if it was keep creating and removing the same
> > window in the same block group?
> 
> The same every time it settled on a usable reservation, but a lot of
> wasted adds and removes as it works across a fully allocated area of
> the bitmap.  Not very efficient, all those rb_tree insertions and
> removals until it gets to a free area; but I can't judge from this
> example how common that would be, may not be worth bothering about.
> 

Yeah, it's not so efficient to add a window before knowing it has a free
block, as rb tree insertion is quit expensive. Actually it used to be
this way: only insert a window to the rb tree when there is a free bit
inside of it. However we need to hold the per-fs reservation lock while
scanning the bitmap:( This badly hurt the performance in some case and
the real time folks complained about it. 

So we changed the code to the current way. I think it was not that
inefficient in the case it works across a fully allocated/reserved area,
since bitmap_search_next_usable_block() will skip the fully allocated
area fairly quickly, as it searchs from the beginning of the window till
the last block of the block group (not just the end of the window)


> >
> > And it might be useful to dump the whole filesystem block reservation
> > tree as well.
> 
> Not necessary, I've put just the relevant numbers in the patch comment,
> it helped me a lot to see the actual numbers and work it out from there.
> 
> >
> > Not sure if it worth the effort to test it on ext3.  The ext2 block
> > reservation code in 2.6.19-rc5-mm2 looks pretty much the same as ext3/4,
> > except the missing truncate_mutex. I understand this might take a few
> > days to reproduce, so this might not needed now.
> 
> Turns out vanilla-ext2 and ext3 and ext4 are safe:
> ext3 and ext4 slightly wrong in the same way, but safe.
> 

Good to know.

> I'll continue this thread with the bugfix patch 1/6; and five more
> (roughly descending order of importance, the latter just cosmetic)
> little fs/ext2/balloc.c patches to things I noticed on the way.
> Nothing very worrying.  Easier to send patches than ask questions:
> please check, perhaps my "off-by-one" accusations are wrong, for
> example.  If you're satisfied they're right, please apply the
> same to ext3 and ext4.
> 

Thanks, I have acked most of them, and will port them to ext3/4 soon.
