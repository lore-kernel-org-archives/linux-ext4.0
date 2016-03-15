From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/12] block: test fallocate for block devices
Date: Tue, 15 Mar 2016 14:41:48 +1100
Message-ID: <20160315034148.GF30721@dastard>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
 <20160305003837.28738.49794.stgit@birch.djwong.org>
 <20160305182508.GA25528@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org, xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160305182508.GA25528@infradead.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Mar 05, 2016 at 10:25:08AM -0800, Christoph Hellwig wrote:
> I'm not sure xfstests is the right fit, as it does not test a file
> system, but rather block devices.
> 
> If people think it should go into xfstests we should at least not
> add it to the default group, but just to a new bdev group.

I think it's the right place to test it - we have all the
infrastructure available to do it (i.e. xfs_io and various block
devices) and we really need to make sure this stuff works,
especially if we start to write filesystem code that depends on
correct behaviour...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
