From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: BLKZEROOUT + pread should return zeroes, right?
Date: Tue, 14 Oct 2014 21:32:25 -0400
Message-ID: <yq1iojm6rti.fsf@sermon.lab.mkp.net>
References: <20141014030132.GA12013@birch.djwong.org>
	<20141014042711.GJ5267@dastard>
	<20141014060242.GA22878@birch.djwong.org>
	<20141014063210.GK9738@thunk.org>
	<20141015012534.GB12013@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20141015012534.GB12013@birch.djwong.org> (Darrick J. Wong's
	message of "Tue, 14 Oct 2014 18:25:34 -0700")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> "Darrick" == Darrick J Wong <darrick.wong@oracle.com> writes:

Darrick> Well then let's change BLKZEROOUT to require O_DIRECT instead
Darrick> of hiding the coherency problem, 

That would break existing users, though.

Darrick> A further optimization to mke2fs would be to detect that we've
Darrick> run discard-with-zeroes and therefore can skip issuing
Darrick> subsequent zeroouts on the same ranges, but I'm wary that
Darrick> discard-zeroes-data does what it purports to do.

It's dubious. I'm working on making sure we only set discard_zeroes_data
when the device guarantees it for 3.19.

-- 
Martin K. Petersen	Oracle Linux Engineering
