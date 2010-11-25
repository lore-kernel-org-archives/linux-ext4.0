From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Wed, 24 Nov 2010 23:23:34 -0500
Message-ID: <yq18w0ini9l.fsf@sermon.lab.mkp.net>
References: <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
	<20101118141957.GK6178@parisc-linux.org>
	<20101118142918.GA18510@infradead.org>
	<1290100750.3041.72.camel@mulgrave.site>
	<alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com>
	<1290168976.2570.45.camel@dolmen> <4CE68155.50705@teksavvy.com>
	<20101119140203.GC10039@thunk.org> <4CE69940.6040908@teksavvy.com>
	<alpine.LFD.2.00.1011191640320.3238@dhcp-lab-213.englab.brq.redhat.com>
	<20101119163013.GJ10039@thunk.org> <4CEDCE60.9050109@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Ted Ts'o" <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: Mark Lord <kernel@teksavvy.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4CEDCE60.9050109@teksavvy.com> (Mark Lord's message of "Wed, 24
	Nov 2010 21:48:00 -0500")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> "Mark" == Mark Lord <kernel@teksavvy.com> writes:

Mark> But mke2fs probably is NOT doing a "single big discard", because
Mark> for SATA the TRIM command is limited to 64K sectors per
Mark> range.. and the in-kernel TRIM code only ever does single ranges..

How many times must I reiterate that this is not true?

Due to various limitations in the way the block layer works we can not
clear LBA 10 to 20 and LBA 40 to 50 in one command. We don't have an
infrastructure in place that allows us to operate on several discrete
areas in one request.

But for contiguous areas we will cram as many ranges entries in as we
can fit in the TRIM payload. This means we'll issue one TRIM command for
every 2 GiB minus change (65535*64*512 / 1048576 = 2047 MiB).

In your example above blkdev_issue_discard() will loop over the 100 GiB
range requested by the caller (filesystem or BLKDISCARD ioctl) and issue
about fifty TRIM commands to the drive.

Large discards are a best-case scenario (short of SECURE ERASE). So if
your drive takes forever to perform this operation then all bets are
off in the TRIM department.


Mark> So doing a discard over an entire drive-encompassing partition,
Mark> say.. 100GB, will require 3000+ individual TRIM commands. 

No.

-- 
Martin K. Petersen	Oracle Linux Engineering
