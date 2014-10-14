From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: BLKZEROOUT + pread should return zeroes, right?
Date: Tue, 14 Oct 2014 02:32:10 -0400
Message-ID: <20141014063210.GK9738@thunk.org>
References: <20141014030132.GA12013@birch.djwong.org>
 <20141014042711.GJ5267@dastard>
 <20141014060242.GA22878@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141014060242.GA22878@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The bottom line is for most of the use cases we are talking about,
we're only zero'ing one or two 4k blocks at a time, so I've never been
convinced that it's worth it to use BLKZEROOUT.

We could add page cache coherency features to BLKZEROOUT, but I'm not
entirely sure it's worth the effort.  No user space program would be
able to take advantage of adding coherency for several years, or
adding feature tests, etc., and is it worth the upside of being able
to use WRITE SAME for a few 4k or 8k writes?  (Which the vast majority
of storage devices don't support anyway....)

Cheers,

						- Ted
