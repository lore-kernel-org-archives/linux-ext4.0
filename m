From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: BLKZEROOUT + pread should return zeroes, right?
Date: Thu, 16 Oct 2014 13:04:15 -0700
Message-ID: <20141016200415.GA16637@birch.djwong.org>
References: <20141014030132.GA12013@birch.djwong.org>
 <20141014042711.GJ5267@dastard>
 <20141014060242.GA22878@birch.djwong.org>
 <20141014063210.GK9738@thunk.org>
 <20141015012534.GB12013@birch.djwong.org>
 <yq1iojm6rti.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>,
	Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1iojm6rti.fsf@sermon.lab.mkp.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 14, 2014 at 09:32:25PM -0400, Martin K. Petersen wrote:
> >>>>> "Darrick" == Darrick J Wong <darrick.wong@oracle.com> writes:
> 
> Darrick> Well then let's change BLKZEROOUT to require O_DIRECT instead
> Darrick> of hiding the coherency problem, 
> 
> That would break existing users, though.

<shrug> If they're using the existing BLKZEROOUT without O_DIRECT they're
already broken.

But I might as well just fix them quietly.

--D

> Darrick> A further optimization to mke2fs would be to detect that we've
> Darrick> run discard-with-zeroes and therefore can skip issuing
> Darrick> subsequent zeroouts on the same ranges, but I'm wary that
> Darrick> discard-zeroes-data does what it purports to do.
> 
> It's dubious. I'm working on making sure we only set discard_zeroes_data
> when the device guarantees it for 3.19.
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
