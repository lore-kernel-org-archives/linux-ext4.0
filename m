From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Test generic/299 stalling forever
Date: Mon, 24 Oct 2016 22:54:56 -0400
Message-ID: <20161025025456.bbruxu4lg25773sl@thunk.org>
References: <7856791a-0795-9183-6057-6ce8fd0e3d58@fb.com>
 <30fef8cd-67cc-da49-77d9-9d1a833f8a48@fb.com>
 <20161019203233.mbbmskpn5ekgl7og@thunk.org>
 <1fb60e7c-a558-80df-09da-d3c36863a461@fb.com>
 <20161021221551.sdv4hgw33zjxnkvu@thunk.org>
 <53fe5a98-6ff9-4fa1-e84c-8a3e16cc0f50@fb.com>
 <20161023193320.rlzlaxdi4vbyu7of@thunk.org>
 <20161023212408.cjqmnzw3547ujzil@thunk.org>
 <20161024033852.quinlee4a24mb2e2@thunk.org>
 <773e0780-6641-ec85-5e78-d04e5a82d6b1@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
        fstests@vger.kernel.org, tarasov@vasily.name
To: Jens Axboe <axboe@fb.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <773e0780-6641-ec85-5e78-d04e5a82d6b1@fb.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 24, 2016 at 10:28:14AM -0600, Jens Axboe wrote:

> How about the below? Bump the timeout to 5 min, 1 min is a little on the
> short side, we want normal error handling to be out of the way before
> that happens. And additionally, break out if we have been marked as
> reaped/exited, so we avoid grabbing the stat mutex again.

Yep, that works.  I tried a test with just the second change:

> +		/*
> +		 * If we took too long to shut down, the main thread could
> +		 * already consider us reaped/exited. If that happens, break
> +		 * out and clean up.
> +		 */
> +		if (td->runstate >= TD_EXITED)
> +			break;
> +

And that's sufficient to solve the problem.

Increasing the timeout to 5 minute also would be a good idea, so we
can let the worker threads exit cleanly so the reported stats will be
completely accurate.

Thanks for your help in figuring out this long-standing problem!

       	   	     		     	  		- Ted
