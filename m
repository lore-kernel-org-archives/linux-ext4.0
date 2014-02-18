From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RFC] block: use discard if possible in blkdev_issue_discard()
Date: Mon, 17 Feb 2014 22:44:47 -0500
Message-ID: <yq1ob25nky8.fsf@sermon.lab.mkp.net>
References: <20140214043256.GA5145@thunk.org>
	<yq1ioshobul.fsf@sermon.lab.mkp.net>
	<20140215012901.GA28307@thunk.org>
	<yq161odofis.fsf@sermon.lab.mkp.net>
	<20140217191901.GC16660@thunk.org>
	<yq11tz1p5o9.fsf@sermon.lab.mkp.net>
	<20140218021747.GG26580@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140218021747.GG26580@thunk.org> (Theodore Ts'o's message of
	"Mon, 17 Feb 2014 21:17:47 -0500")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> "Ted" == Theodore Ts'o <tytso@mit.edu> writes:

Ted> Ultimately the storage device (or host OS) can always decide to
Ted> deprovision the space if it is given a write of all zeroes; there's
Ted> nothing in the specs that say anything at all about performance
Ted> considerations, or what the back-end storage decides to do in order
Ted> to handle a particular write command, so long as a subsequent read
Ted> returns the correct data.

Well, that has changed a bit with the logical block provisioning bits in
SCSI. That's why I brought up the allocation/deallocation assumptions in
the existing two blkdev_issue_foo() calls.

Ted> Does that make sense?

Yeah. So deprovision with guaranteed zero on read is what you're
after. I'll chew on that a bit tomorrow.

Ted> What does "anchored" mean?  Does is it the equivalent of using
Ted> fallocate() to allocate the block, but it's marked uninitialized so
Ted> any attempt to read it returns zeroes?

It means that any allocations internal to the storage device which are
required to subsequently perform a write to that block have been
made. So it's a way to reserve space without actually writing the
blocks. Whether reading an anchored block returns zeroes or something
else depends on the usual twisted maze of conflicting and confusing
flags.

-- 
Martin K. Petersen	Oracle Linux Engineering
