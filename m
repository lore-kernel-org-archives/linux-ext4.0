From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch] fs: fix deadlocks in writeback_if_idle
Date: Thu, 25 Nov 2010 15:07:12 +1100
Message-ID: <20101125040712.GD3359@amd>
References: <20101123100239.GA4232@amd>
 <1290515274-sup-3895@think>
 <20101123125223.GA4946@amd>
 <1290538347-sup-7669@think>
 <20101124010343.GD3168@amd>
 <20101124145157.c999b1e8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nick Piggin <npiggin@kernel.dk>,
	Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101124145157.c999b1e8.akpm@linux-foundation.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 24, 2010 at 02:51:57PM -0800, Andrew Morton wrote:
> On Wed, 24 Nov 2010 12:03:43 +1100
> Nick Piggin <npiggin@kernel.dk> wrote:
> 
> > On Tue, Nov 23, 2010 at 01:58:24PM -0500, Chris Mason wrote:
> > > > > My original btrfs patch just exported the bdi_ funcs so that btrfs could
> > > > > do the above internally.  But Christoph objected, and I think he's
> > > > > right.  We should either give everyone a bdi or make sure the writeback
> > > > > func kicks only one filesystem.
> > > > 
> > > > Well it's just kicking the writeback thread, and it will writeback
> > > > from that particular sb.
> > > 
> > > Hmmm?  It will writeback for all the SBs on that bdi.  In the current
> > > form that ext4 uses, that gets pretty expensive if you have a bunch of
> > > large partitions and you're only running out of space on one of them.
> > 
> > Right. But if the bdi has writeback in progress (which would be most
> > of the time, on a busy filesystem), writeback_if_idle doesn't do
> > anything, and it is happy just for the background writeback to
> > eventually get around to writing out for us.
> 
> That doesn't work if you're running btfs (apparently short for
> "busticated filesystem") because the bdi-per-sb thing carefully hid the
> information which you're looking for.
> 
> 
> We still don't have a fix for this bug yet, it appears, btw.

My last patch is a fix. It makes the writeback slightly less directed at
the sb (but there were no guarantees of that anyway). But this could be
improved with subsequent patches. We actually don't need to refcount the
sb in the work item submission, so long as we only compare sb pointers
and DTRT in the writeback thread if they match. So it can easily be
fixed, but for now both users (ext4 and btrfs) won't care about that
detail.

