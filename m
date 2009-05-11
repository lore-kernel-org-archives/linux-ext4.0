From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 09:00:40 -0600
Message-ID: <20090511150040.GF8112@parisc-linux.org>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org> <20090510165259.GA31850@logfs.org> <20090511083754.GA29082@mit.edu> <20090511100624.GB6585@logfs.org> <20090511112729.GD29082@mit.edu> <20090511120936.GB6277@mit.edu> <87f94c370905110610j2f5ea7fcua4e596b2b5e82a5f@mail.gmail.com> <20090511142740.GC6277@mit.edu> <4A08365F.5040805@redhat.com> <20090511145059.GD6277@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	J?rn Engel <joern@logfs.org>,
	Matthew Wilcox <willy@linux.intel.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Linux RAID <linux-raid@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36261 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630AbZEKPAk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 May 2009 11:00:40 -0400
Content-Disposition: inline
In-Reply-To: <20090511145059.GD6277@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 11, 2009 at 10:50:59AM -0400, Theodore Tso wrote:
> On Mon, May 11, 2009 at 10:29:51AM -0400, Ric Wheeler wrote:
> > The key is not at the FS layer - this is an issue for people who RAID 
> > these beasts together and want to actually check that the bits are what 
> > they should be (say doing a checksum validity check for a stripe).
> 
> Good point, yes I can see why they need that.  In that case, the
> storage device can't just silently truncate a TRIM request; it would
> have to expose to the OS its alignment requirements.  The risk though
> is that more they try push this compleixity into the OS, the higher
> the risk that the OS will simply decide not to take advantage of the
> functionality.  Of course, there is the question why anyone would want
> to build a software-raid device on top of a thin-provisioned hardware
> storage unit.  :-)

It's not a problem for people who use Thin Provisioning, it's a problem
for people who want to run RAID-5 on top of SSDs.  If you have a sector
whose reads are indeterminate, your parity for that stripe will always
be wrong.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
