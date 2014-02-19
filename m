From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RFC] block: use discard if possible in blkdev_issue_discard()
Date: Tue, 18 Feb 2014 21:20:30 -0500
Message-ID: <yq1lhx7n8r5.fsf@sermon.lab.mkp.net>
References: <20140214043256.GA5145@thunk.org>
	<yq1ioshobul.fsf@sermon.lab.mkp.net>
	<20140215012901.GA28307@thunk.org>
	<yq161odofis.fsf@sermon.lab.mkp.net>
	<20140217191901.GC16660@thunk.org>
	<yq11tz1p5o9.fsf@sermon.lab.mkp.net>
	<20140218021747.GG26580@thunk.org>
	<yq1ob25nky8.fsf@sermon.lab.mkp.net>
	<20140218054707.GI26580@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140218054707.GI26580@thunk.org> (Theodore Ts'o's message of
	"Tue, 18 Feb 2014 00:47:07 -0500")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> "Ted" == Theodore Ts'o <tytso@mit.edu> writes:

Ted,

Ted> Is it a fair assumption that the reason why T10 added these bits is
Ted> mainly so that clients of thin-provisioned storage devices can
Ted> guarantee that a subseq uent write won't fail? 

Yes. It's a way to lock down blocks for future use without having to
actually write them.

Ted> Figuring out when it's better to use fstrim, or doing it at unlink
Ted> time, etc., is something that's better done automatically instead
Ted> of manually, but this is I fear answering questions like this in a
Ted> reliable fashion is going to be a very hard problem

We'll quickly get back to the problem we had with the other I/O hints.
Namely the device vendor having to provide an honest indicator of their
performance characteristics.

Recent SCSI has a way to communicate maximum values for processing
various types of commands. Going forward we can use those values to tune
our request timeouts. But as far as the normal processing time is
concerned it's hard to see a vendor putting anything in there other than
"this one goes to 11".

Over time we may be able to switch to online discards by default. But at
this stage drives with queued trim support are just starting to roll
out. And some thin-provisioned arrays were evidently also designed with
a monthly Norton SpeedDisk run in mind.

However, I'm open to having a prefer_online_discards flag that dedicated
PCIe SSD drivers could set. It's not until we enter SCSI/ATA territory
that things get murky.

On the topic of reliable discards: Apparently there are some amendments
being discussed in T10/T13 right now that may help us. Still
investigating...

-- 
Martin K. Petersen	Oracle Linux Engineering
