From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: memory leak: data=journal and {collapse,insert,zero}_range
Date: Wed, 21 Oct 2015 18:44:10 +0900
Message-ID: <011f01d10be5$099d38d0$1cd7aa70$@samsung.com>
References: <20151017160230.GA19968@thunk.org>
 <009301d10b2f$b410e6b0$1c32b410$@samsung.com> <20151020155443.GM2972@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: 'Theodore Ts'o' <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:32792 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbbJUJoM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Oct 2015 05:44:12 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NWK0159RDPMHJ80@mailout4.samsung.com> for
 linux-ext4@vger.kernel.org; Wed, 21 Oct 2015 18:44:10 +0900 (KST)
In-reply-to: <20151020155443.GM2972@thunk.org>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> 
> On Tue, Oct 20, 2015 at 09:06:08PM +0900, Namjae Jeon wrote:
> > Hi Ted,
> >
> > I will check this issue.
> 
> Thanks!
> 
> To be clear, the commit that I bisected this down to was fixing a real
> issue, so I'm not really blaming your commit.  Furthermore, it wasn't
> causing test failures until very recently, and part of this is
> probably caused by a change in the test environment, and also probably
> a change in the most recent kernels about how memory reclaim and how
> we handle low memory situations.  However, once I started seeing test
> failures, I started looking harder for memory leaks, and it was clear
> that we had memory leaks in the data=journal scenario starting with
> 1ce01c4a199.
> 
> Interestingly we're not seeing these memory leaks on the truncate
> path, so I suspect the issue is in how collapse range is clearing
> pages from the page cache, especially pages that were freshly written
> to the journal by the commit but which hadn't yet been writtten to
> disk and then marked as complete so we can allow the relevant
> transaction to be checkpointed.  (Although we're not leaking the
> journal head structures, but only the buffer heads, so the story most
> be a bit more complicated than that.)

Okay, Thanks for sharing your view and points !!

Currently I can reproduce memory leak issue without collase/insert/zero range.
conditions like the following.(collase/insert/zero range are disable with -I -C -z option and add -y option instead of -W)
  1. small size parition(1GB)
  2. run fsx with these options "./fsx -N 30000 -o 128000 -l 500000 -r 4096 -t 512 -w 512 -Z -R -y -I -C -z testfile"
And same result with generic/091 is showing (buffer_head leak)

So I am starting to find root-cause base on your points.
I will share the result or the patch.

Thanks~
> 
> Cheers,
> 
> 					- Ted
> 

