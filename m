From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: BLKZEROOUT + pread should return zeroes, right?
Date: Tue, 14 Oct 2014 21:02:12 -0400
Message-ID: <yq14mv687sb.fsf@sermon.lab.mkp.net>
References: <20141014030132.GA12013@birch.djwong.org>
	<20141014042711.GJ5267@dastard> <20141014092128.GA23656@infradead.org>
	<20141014185753.GA6838@lenny.home.zabbo.net>
	<20141014202147.GI17506@dastard>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Zach Brown <zab@zabbo.net>, Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20141014202147.GI17506@dastard> (Dave Chinner's message of "Wed,
	15 Oct 2014 07:21:47 +1100")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> "Dave" == Dave Chinner <david@fromorbit.com> writes:

Dave> I don't care what happens to the block layer ioctls w.r.t. cache
Dave> coherency. If people want to make them fully cache coherent for
Dave> buffered IO, go right ahead.

Dave> But that doesn't change the fact that if you want your application
Dave> to work sanely on existing kernels, then using direct IO is the
Dave> only option...

Yep!

-- 
Martin K. Petersen	Oracle Linux Engineering
