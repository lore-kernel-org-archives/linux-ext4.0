From: Christoph Hellwig <hch@infradead.org>
Subject: Re: BLKZEROOUT + pread should return zeroes, right?
Date: Tue, 14 Oct 2014 02:21:28 -0700
Message-ID: <20141014092128.GA23656@infradead.org>
References: <20141014030132.GA12013@birch.djwong.org>
 <20141014042711.GJ5267@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46498 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbaJNJVg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Oct 2014 05:21:36 -0400
Content-Disposition: inline
In-Reply-To: <20141014042711.GJ5267@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 14, 2014 at 03:27:11PM +1100, Dave Chinner wrote:
> Broken usage, IMO. If you are going to use the block layer ioctls to
> manipulate data int eh block device, you should be using direct Io
> for all your data IO to the block device. Otherwise, coherency
> problems occur....

I'd say BLKZEROOUT semantics are broken.  Having an ioctl exposed
that maniulates on-disk data without cache coherence is a nightmare
that people trip over easily.  Even experienced people like Darrick.
