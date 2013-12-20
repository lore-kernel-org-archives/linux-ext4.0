From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Fri, 20 Dec 2013 11:17:31 -0700
Message-ID: <20131220181731.GG19166@parisc-linux.org>
References: <20131218023143.GA24491@parisc-linux.org> <20131218050127.GA15289@thunk.org> <20131218142749.GA9207@parisc-linux.org> <20131219020759.GA27469@thunk.org> <20131219041240.GA19166@parisc-linux.org> <20131219054303.GA4391@thunk.org> <20131219152049.GB19166@parisc-linux.org> <20131219161728.GA9130@thunk.org> <20131219171201.GD19166@parisc-linux.org> <20131219171848.GC9130@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56204 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3LTSRd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Dec 2013 13:17:33 -0500
Content-Disposition: inline
In-Reply-To: <20131219171848.GC9130@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 19, 2013 at 12:18:48PM -0500, Theodore Ts'o wrote:
> On Thu, Dec 19, 2013 at 10:12:02AM -0700, Matthew Wilcox wrote:
> > 
> > ... I think it'll actually be ext4_get_block_fault, not _write, and it
> > will include code to zero the returned blocks if they're uninitialised.
> 
> I assume what you mean here is if we see that the blocks are
> uninitialized, we don't need to read from the persistent memory at
> all; we can just map in a zeroed page, hopefully one from our stock of
> pre-zeroed pages.  Yes?

Maybe.  We have a tension here between wanting to avoid unnecessary
writes to the media (as you say, wear is going to be important for some
media, if not all) and wanting to not fragment files (both for extent
tree compactness and so that we can use PMD or even PGD mappings if the
stars align).  It'll be up to the filesystem whether it chooses to satisfy
the get_block request with something prezeroed, or something that aligns
nicely.  Ideally, it'll be able to find a block of storage that does both!

Actually, I now see a second way to read what you wrote.  If you meant
"we can map in ZERO_PAGE or one of its analogs", then no.  The amount
of cruft that optimisation added to the filemap_xip code is horrendous.
I don't think it's a particularly common workload (mmap a holey file,
read lots of zeroes out of it without ever writing to it), so I think
it's far better to allocate a page of storage and zero it.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
