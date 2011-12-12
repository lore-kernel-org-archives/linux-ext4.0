From: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Subject: Re: [PATCH] xfstests: 277 new test to check freeze/unfreeze works well or not under heavy load.
Date: Mon, 12 Dec 2011 18:31:55 +0900
Message-ID: <20111212183153.DF3F.61FB500B@jp.fujitsu.com>
References: <20111209145231.5A5F.61FB500B@jp.fujitsu.com> <20111209071700.GD14273@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111209071700.GD14273@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


(2011/12/09 16:17), Dave Chinner wrote:

> On Fri, Dec 09, 2011 at 02:52:31PM +0900, Masayoshi MIZUMA wrote:
> > Hi,
> > 
> > unfreeze function, thaw_super(), sometimes hangs up if flush kernel
> > thread does writeback to the same filesystem concurrently.
> > (the problem is reported at
> >  http://marc.info/?l=linux-ext4&m=132339590004560&w=2)
> > 
> > This test runs freeze/unfreeze under heavy load. If the problem is
> > reproduced, this test will hang up...
> 
> This is effectively a duplicate of test 068, which is currently
> described as an XFS only test. It is actually generic now that
> xfs_freeze works on other filesytsems, so please update 068
> appropriately rather that introducing a new test.

OK, I will try to update 068 to reproduce the problem, thanks!

Masayoshi Mizuma

> 
> Cheers,
> 
> Dave
> 
> -- 
> Dave Chinner
> david@fromorbit.com



