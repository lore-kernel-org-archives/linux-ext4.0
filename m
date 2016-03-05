From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/12] block: test fallocate for block devices
Date: Sat, 5 Mar 2016 10:25:08 -0800
Message-ID: <20160305182508.GA25528@infradead.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
 <20160305003837.28738.49794.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: david@fromorbit.com, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
	xfs@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160305003837.28738.49794.stgit@birch.djwong.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I'm not sure xfstests is the right fit, as it does not test a file
system, but rather block devices.

If people think it should go into xfstests we should at least not
add it to the default group, but just to a new bdev group.
