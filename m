From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 09:10:15 -0400
Message-ID: <87f94c370905110610j2f5ea7fcua4e596b2b5e82a5f@mail.gmail.com>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org>
	 <20090510165259.GA31850@logfs.org> <20090511083754.GA29082@mit.edu>
	 <20090511100624.GB6585@logfs.org> <20090511112729.GD29082@mit.edu>
	 <20090511120936.GB6277@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
	Matthew Wilcox <willy@linux.intel.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Linux RAID <linux-raid@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:41672 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbZEKNKP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 May 2009 09:10:15 -0400
In-Reply-To: <20090511120936.GB6277@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 11, 2009 at 8:09 AM, Theodore Tso
> All of the web browsing I've doen confirms that the ATA folks expect
> trim to work on 512-sector granularity.

Ted,

That implies that the SSD folks are not treating erase blocks as a
contiguous group of sectors.  For some reason, I thought their was
only one mapping per erase block and within the erase block the
sectors were contiguous..

If I'm right, then the ata spec may allow you to send sub-erase block
trim commands down, but the spec does not prevent the (blackbox)
hardware from clipping the size of the trim to be on erase block
boundaries and ignoring the sub-erase block portions on each end.  Or
ignoring the whole command if your trim command does not span a whole
erase block.

Also the mdraid people plan to clip at the stripe width boundary for
raid 5, 6, etc.  Their expectation is that discards will be coalesced
into bigger blocks before it gets to the mdraid layer.

I still think reshaping a raid 5 online will be next to impossible
when some of the stripes may contain indeterminate data.

More realistic is to figure out a way to make it deterministic at
least for the short term (by writing data to all the trimmed blocks?),
then reshaping, then having a tool to scan the filesystem and re-issue
all the trim commands.

Obviously, if the ata spec had a signaling mechanism that
differentiated between deterministic data and non-deterministic data
then the above code excess could be simplified greatly.

Greg
-- 
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
