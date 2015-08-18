From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: ratelimit the file system mounted message
Date: Mon, 17 Aug 2015 21:18:07 -0400
Message-ID: <20150818011807.GC7535@thunk.org>
References: <1439665197-10766-1-git-send-email-tytso@mit.edu>
 <20150817011215.GA714@dastard>
 <20150817145056.GC27202@thunk.org>
 <20150817230752.GB3902@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150817230752.GB3902@dastard>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Aug 18, 2015 at 09:07:52AM +1000, Dave Chinner wrote:
> Yup. A lot of regression tests get written to tick a process box
> (i.e. did we fix regression X?), not because they provide on-going
> value to prevent future regressions. I try to push back against
> tests that won't provide us with useful protection against future
> regressions....

Yeah, that wasn't the case here.  The bug was fixed by Salman Qazi at
Google in May 2012.  The test was created by Eryu nearly a year later
in April 2013.

> Rather than time limiting, how about bounding the number of
> mount/unmount cycles?

Sure, that makes sense.

						- Ted
