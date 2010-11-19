From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Thu, 18 Nov 2010 19:34:30 -0500
Message-ID: <4CE5C616.7070706@teksavvy.com>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>	<20101118130630.GJ6178@parisc-linux.org>	<20101118134804.GN5618@dhcp231-156.rdu.redhat.com>	<20101118141957.GK6178@parisc-linux.org>	<20101118142918.GA18510@infradead.org>	<1290100750.3041.72.camel@mulgrave.site>	<x494obe4kd5.fsf@segfault.boston.devel.redhat.com>	<1290102098.3041.77.camel@mulgrave.site>	<AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com>	<4CE59E57.2090009@teksavvy.com> <yq1r5eiw5os.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Jeff Moyer <jmoyer@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:16786 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753841Ab0KSAee (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Nov 2010 19:34:34 -0500
In-Reply-To: <yq1r5eiw5os.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10-11-18 06:52 PM, Martin K. Petersen wrote:
>>>>>> "Mark" == Mark Lord<kernel@teksavvy.com>  writes:
> Mark>  If FITRIM is still issuing single-range-at-a-time TRIMs, then I'd
> Mark>  call that a BUG that needs fixing.  Doing TRIM like that causes
> Mark>  tons of unnecessary ERASE cycles, shortening the SSD lifetime.  It
> Mark>  really needs to batch them into groups of (up to) 64 ranges at a
> Mark>  time (64 ranges fits into a single 512-byte parameter block).
>
> We don't support coalescing discontiguous requests into one command. But
> we will issue contiguous TRIM requests as big as the payload can
> handle. That's just short of two gigs per command given a 512-byte
> block.
>
> I spent quite a bit of time trying to make coalescing work in the
> spring. It got very big and unwieldy. When we discussed it at the
> filesystem summit the consensus was that it was too intrusive to the I/O
> stack, elevators, etc.

Surely if a userspace tool and shell-script can accomplish this,
totally lacking real filesystem knowledge, then we should be able
to approximate it in kernel space?

This is FITRIM we're talking about, not the on-the-fly automatic TRIM.

FITRIM could perhaps use a similar approach to what wiper.sh does:
reserve a large number of free blocks, and issue coalesced TRIM(s) on them.

The difference being, it could walk through the filesystem,
trimming in sections, rather than trying to reserve/trim the entire
freespace all in one go.

Over-thinking it???
