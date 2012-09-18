From: Dave Chinner <david@fromorbit.com>
Subject: Re: Anyone have test cases for SEEK_HOLE/SEEK_DATA?
Date: Tue, 18 Sep 2012 16:40:39 +1000
Message-ID: <20120918064039.GS11511@dastard>
References: <nsxa9wojdcd.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <nsxa9wojdcd.fsf@closure.thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 17, 2012 at 10:04:34PM -0400, Theodore Ts'o wrote:
> 
> Does anyone have test cases for SEEK_HOLE/SEEK_DATA handy?  As near as I
> can tell xfstests doesn't have any tests for SEEK_HOLE/SEEK_DATA
> functionality, and I was hoping someone had some test programs and test
> sets already written.

Perhaps a cc to xfs@oss.sgi.com so the xfstests maintainers see the
question would be a sensible idea?

As it is, there are tests pending check-in that test
seek-data/seek-hole functionality - they were used to verify the
unwritten extent aware XFS implementation that recently went into
the kernel....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
