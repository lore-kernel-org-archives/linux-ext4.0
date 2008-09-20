From: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Sat, 20 Sep 2008 12:47:59 -0400
Message-ID: <20080920164759.GY27404@josefsipek.net>
References: <E1Kea9F-0004L5-Ds@closure.thunk.org> <1221331767-16870-1-git-send-email-tytso@mit.edu> <2EC8176B-0AFA-4B36-A2F5-E51753A576A5@cam.ac.uk> <20080913212903.GF26128@mit.edu> <20080914134859.GB21746@infradead.org> <20080914175810.GB13074@mit.edu> <20080915144948.GB16491@infradead.org> <20080915175305.GS4563@wotan.suse.de> <20080916213106.GA10562@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mark Fasheh <mfasheh@suse.com>,
	Christoph Hellwig <hch@infradead.org>,
	Anton Altaparmakov <aia21@cam.ac.uk>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080916213106.GA10562@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 16, 2008 at 05:31:07PM -0400, Theodore Tso wrote:
> On Mon, Sep 15, 2008 at 10:53:05AM -0700, Mark Fasheh wrote:
> > On Mon, Sep 15, 2008 at 10:49:48AM -0400, Christoph Hellwig wrote:
> > > I agree to you (or someone elses - don't remember anymore) suggestion
> > > to put in more padding so we can add fields later.  I strongly disagree
> > > putting in features now that we neither have a user, nor a usecase or
> > > testcase for.
> > 
> > So, how about another 64 bits of padding in struct fiemap_extent? That could
> > help cover future uses like compression, which might require another 64 bit
> > offset field - we only have 32 bits of reserved space there right now.
> 
> What I'd recommend is a 56 byte structure:

Why not just make it 64 bytes? Sure, that's 8 extra bytes, but I find the
power-of-2 size (and the extra space) comforting. (AFAIK, slab allocators
will give you 64 bytes anyway; and I expect something similar on the
user-space side of things.)

...
> Yeah, it's a little extra memory per extent, but filesystems seem to
> always invent new things, and it seem spretty clear that we have at
> least two extensions on deck (compression, multiple storage devices)
> both of which have at least one implementation that are either in the
> kernel or will likely enter the kernel.  So it's likely that there is
> something that we may have missed, and leaving a little extra space
> doesn't actually cost us that much.

Right.

Josef 'Jeff' Sipek.

-- 
Once you have their hardware. Never give it back.
(The First Rule of Hardware Acquisition)
