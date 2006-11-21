From: Hugh Dickins <hugh@veritas.com>
Subject: Re: Boot failure with ext2 and initrds
Date: Tue, 21 Nov 2006 05:39:06 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0611210508270.22957@blonde.wat.veritas.com>
References: <20061114014125.dd315fff.akpm@osdl.org>  <20061114184919.GA16020@skynet.ie>
  <Pine.LNX.4.64.0611141858210.11956@blonde.wat.veritas.com>
 <20061114113120.d4c22b02.akpm@osdl.org>  <Pine.LNX.4.64.0611142111380.19259@blonde.wat.veritas.com>
  <Pine.LNX.4.64.0611151404260.11929@blonde.wat.veritas.com>
 <20061115214534.72e6f2e8.akpm@osdl.org> <455C0B6F.7000201@us.ibm.com>
 <20061115232228.afaf42f2.akpm@osdl.org>  <1163666960.4310.40.camel@localhost.localdomain>
  <20061116011351.1401a00f.akpm@osdl.org>  <1163708116.3737.12.camel@dyn9047017103.beaverton.ibm.com>
  <20061116132724.1882b122.akpm@osdl.org>  <Pine.LNX.4.64.0611201544510.16530@blonde.wat.veritas.com>
 <1164073652.20900.34.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andrew Morton <akpm@osdl.org>, Mel Gorman <mel@skynet.ie>,
	"Martin J. Bligh" <mbligh@mbligh.org>,
	linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:12446 "EHLO
	extu-mxob-1.symantec.com") by vger.kernel.org with ESMTP
	id S1030727AbWKUFix (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Nov 2006 00:38:53 -0500
Received: from [172.21.56.42]([172.21.56.42]) (3173 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1GmOLL-0000upC@megami.veritas.com>
	for <linux-ext4@vger.kernel.org>; Mon, 20 Nov 2006 21:38:51 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
To: Mingming Cao <cmm@us.ibm.com>
In-Reply-To: <1164073652.20900.34.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 20 Nov 2006, Mingming Cao wrote:
> 
> So there is only one writer at the moment the hang was happening? 

I expect there were multiple writers when the task which hangs
first entered its ext2_prepare_write (it's a make -j20 build on
that ext2 filesystem); but by the time I come to look at the hang,
there's only that one writer active - everything else would be waiting
on that part of the build to complete (well, your question makes me
realize that I didn't look down the whole "ps" listing to see what
was waiting; but the hanging task is the only one I see running on
on any cpu, each time I break in).

> 
> hmm, is the filesystem relatively all being used or reserved, i.e, the
> free bits are all being reserved?  There is one extreme case that may
> cause starvation. If filesystem free blocks are all being reserved, when
> a  new writer need a free block, it has to go through the entire
> filesystems, try to reserve a space, which will repeatly calling
> rsv_window_add and rsv_window_remove, since. Finally give up and fall
> back to allocation without reservation. But this is all theory, not sure
> fits your case here.

I can understand that there may be a worst case like that: but I hope
it wouldn't take 20 hours to find a free block on a default 340MB ext2
filesystem!  And unless something else has gone wrong, this build would
not be filling the filesystem to that extent: it's probably around 80%
full at this stage, and shouldn't get fuller than 98% in the end.

Any suggestions for what I might check, next time it happens?

Hugh
