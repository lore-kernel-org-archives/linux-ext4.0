From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Thu, 18 Nov 2010 20:33:01 -0500
Message-ID: <20101119013301.GU3290@thunk.org>
References: <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
 <20101118141957.GK6178@parisc-linux.org>
 <20101118142918.GA18510@infradead.org>
 <1290100750.3041.72.camel@mulgrave.site>
 <x494obe4kd5.fsf@segfault.boston.devel.redhat.com>
 <1290102098.3041.77.camel@mulgrave.site>
 <AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com>
 <4CE59E57.2090009@teksavvy.com>
 <1290117009.11007.42.camel@mulgrave.site>
 <4CE5A386.7000105@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: James Bottomley <James.Bottomley@suse.de>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Mark Lord <kernel@teksavvy.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CE5A386.7000105@teksavvy.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> >
> >Before we go gung ho on this, there's no evidence that N discontiguous
> >ranges in one command are any better than the ranges sent N times ...
> >the same amount of erase overhead gets sent on SSDs.
> 
> No, we do have evidence:  execution time of the TRIM commands on the SSD.
> 
> The one-range-at-a-time is incredibly slow compared to multiple
> ranges at a time.  That slowness comes from somewhere, with about
> 99.9% certainty that it is due to the drive performing slow flash
> erase cycles.

Mark, I think you are over-generalizing here.  You have observed with
some number of flash drives --- maybe only one, but I don't know that
for sure --- that TRIM is slow.  Even if we grant that you are correct
in your conclusion that it is because the drive is doing slow flash
erase cycles (and I don't completely accept that; I haven't seen your
your measurements since we know that any kind of command that requires
a queue drain/flush before it can execute is going to be slow, and I
don't know what kind of _slow_ you are observing).

But even if we *do* grant that you've seen one disk, or even a lot of
disks which is doing something stupid, that just means that their
manufacturer has some idiotic engineers.  It does not follow that all
SSD's, or thin-provisioned drives, or other devices implementing the
the ATA TRIM command, will do so in an incompetent way.

If you look a the the T13 definition of TRIM, it is just a hint that
the contents of the block range do not _have_ to be preserved.  It
does not say that they *must* be erased.  This is not a security erase
command.  In fact, it is perfectly reasonable for the TRIM command to
store state in volatile storage, and the information of which blocks
have been TRIM gets discarded on a power failure.

So if SSD's are doing a full flash erase cycle for each TRIM, that may
not necessarily be a good idea.  I accept that there may be some
incompetent implementations out there.  But I don't think this means
we should assume that _all_ implementations are incompetent.  It does
mean, though, that we can't turn any of these features on by default.
But that's something we know already.

					- Ted
