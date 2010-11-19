From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Thu, 18 Nov 2010 20:49:04 -0500
Message-ID: <yq1eiaiw0a7.fsf@sermon.lab.mkp.net>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
	<20101118130630.GJ6178@parisc-linux.org>
	<20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
	<20101118141957.GK6178@parisc-linux.org>
	<20101118142918.GA18510@infradead.org>
	<1290100750.3041.72.camel@mulgrave.site>
	<x494obe4kd5.fsf@segfault.boston.devel.redhat.com>
	<1290102098.3041.77.camel@mulgrave.site>
	<AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com>
	<4CE59E57.2090009@teksavvy.com> <yq1r5eiw5os.fsf@sermon.lab.mkp.net>
	<4CE5C616.7070706@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Jeff Moyer <jmoyer@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Mark Lord <kernel@teksavvy.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:31301 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab0KSBth (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Nov 2010 20:49:37 -0500
In-Reply-To: <4CE5C616.7070706@teksavvy.com> (Mark Lord's message of "Thu, 18
	Nov 2010 19:34:30 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Mark" == Mark Lord <kernel@teksavvy.com> writes:

Mark> Surely if a userspace tool and shell-script can accomplish this,
Mark> totally lacking real filesystem knowledge, then we should be able
Mark> to approximate it in kernel space?

It's the splitting and merging on stacked devices that's the hard
part. Something wiper.sh does not have to deal with. And thanks to
differences in the protocols the SCSI-ATA translation isn't a perfect
fit.

Every time TRIM comes up the discussion turns into how much we suck at
it because we don't support coalescing of discontiguous ranges.

However, we *do* support discarding contiguous ranges of up to about 2GB
per command on ATA. It's not like we're issuing a TRIM command for every
sector.

For offline/weekly reclaim/FITRIM we have the full picture when the
discard is issued. And thus we have the luxury of being able to send out
relatively big contiguous discards unless the filesystem is insanely
fragmented.

For runtime discard usage we'll inevitably be issuing lots of itty-bitty
512 or 4KB single-command discards. That's going to suck for performance
on your average ATA SSD. Doctor, it hurts when I do this...

So assuming we walk the filesystem to reclaim space on ATA SSDs on a
weekly basis (since that's the only sane approach): 

       What is the performance impact of not coalescing discontiguous
       block ranges when cron scrubs your /home at 4am Sunday morning?

That, to me, is the important question. That obviously depends on the
SSD, filesystem, fragmentation and so on. Is the win really big enough
to justify a bunch of highly intrusive changes to our I/O stack?

Thanks to PCIe SSDs and other upcoming I/O technologies we're working
hard to bring request latency down by simplifying things. Adding
complexity seems like a bad idea at this time. And that was the
rationale behind the consensus at the filesystem workshop.

-- 
Martin K. Petersen	Oracle Linux Engineering
