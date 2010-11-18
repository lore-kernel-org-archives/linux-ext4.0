From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Thu, 18 Nov 2010 15:50:09 -0600
Message-ID: <1290117009.11007.42.camel@mulgrave.site>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
	 <20101118130630.GJ6178@parisc-linux.org>
	 <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
	 <20101118141957.GK6178@parisc-linux.org>
	 <20101118142918.GA18510@infradead.org>
	 <1290100750.3041.72.camel@mulgrave.site>
	 <x494obe4kd5.fsf@segfault.boston.devel.redhat.com>
	 <1290102098.3041.77.camel@mulgrave.site>
	 <AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com>
	 <4CE59E57.2090009@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Mark Lord <kernel@teksavvy.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34573 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760707Ab0KRVuS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Nov 2010 16:50:18 -0500
In-Reply-To: <4CE59E57.2090009@teksavvy.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2010-11-18 at 16:44 -0500, Mark Lord wrote:
> On 10-11-18 03:04 PM, Greg Freemyer wrote:
> >
> > 2) FITRIM doesn't leverage the fact the a TRIM command can handle
> > multiple ranges per TRIM command payload.  I haven't seen any FITRIM
> > vs. wiper.sh benchmarks, so I don't know what impact that has in
> > practice.  Mark Lord thought that this lacking feature would cause
> > FITRIM to take minutes or hours with some hardware.  Especially early
> > generation SSDs.
> 
> If FITRIM is still issuing single-range-at-a-time TRIMs,
> then I'd call that a BUG that needs fixing.  Doing TRIM like that
> causes tons of unnecessary ERASE cycles, shortening the SSD lifetime.
> It really needs to batch them into groups of (up to) 64 ranges at a time
> (64 ranges fits into a single 512-byte parameter block).

Before we go gung ho on this, there's no evidence that N discontiguous
ranges in one command are any better than the ranges sent N times ...
the same amount of erase overhead gets sent on SSDs.  However, we also
have to remember Thin Provisioning.  Right at the moment WRITE SAME
seems to be preferred to UNMAP ... and WRITE SAME only has a single
effective range.

Now if you're thinking of multiple contiguous ranges because of the LBA
limits to TRIM, then yes, I'm fine with that because WRITE SAME doesn't
have that problem and we can do the translation in the SATL.

James


