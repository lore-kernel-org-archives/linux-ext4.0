From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] ext4: ratelimit the file system mounted message
Date: Tue, 18 Aug 2015 11:55:05 +0800
Message-ID: <20150818035505.GZ17933@dhcp-13-216.nay.redhat.com>
References: <1439665197-10766-1-git-send-email-tytso@mit.edu>
 <20150817011215.GA714@dastard>
 <20150817145056.GC27202@thunk.org>
 <20150817230752.GB3902@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	fstests@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150817230752.GB3902@dastard>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Aug 18, 2015 at 09:07:52AM +1000, Dave Chinner wrote:
> [cc fstests@vger.kernel.org as we are talking about the test rather
> than the kernel behaviour. ]
> 
[snip]
> > In all cases, ext3/305 reliably reproduced the failure within 30
> > mount/unmount cycles, and in most cases, under a dozen cycles.  (i.e.,
> > under two seconds, and usually in a fraction of a second).  So I'm not
> > entirely sure why the test was written to run the loop for 3 minutes
> > and thousands of mount/unmount cycles.
> 
> There were lots of tests being written at the time that used a 3
> minute timeout. It's another of those red flags that I tend to
> push back on these days, and this is an example of why - usually the
> problem can be hit very quickly, or the test is extremely unreliable
> and long runtime is the only way to trigger the race. Hence
> running for X minutes doesn't really prove anything....

IIRC, 3 minutes time limit was based on my testing before I submitted
the patch, but I could be wrong, it was two years ago..

I think I have better understanding of xfstests and regression tests
now than two years ago, after years education on the list (mainly by
Dave :-))

> 
> > Eryu, you wrote the test; any thoughts?  At the very least I'd suggest
> > cutting the test down so that it runs for at most 2 seconds, if for no
> > other reason than to speed up regression test runs.
> 
> Rather than time limiting, how about bounding the number of
> mount/unmount cycles?

Agreed, 30 cycles seem a reasonable number, I can prepare a patch if no
objection.

Thanks Ted and Dave for looking into this!

Eryu
