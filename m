From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Fri, 19 Nov 2010 10:37:48 -0500
Message-ID: <20101119153748.GE10039@thunk.org>
References: <20101118130630.GJ6178@parisc-linux.org>
 <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
 <20101118141957.GK6178@parisc-linux.org>
 <20101118142918.GA18510@infradead.org>
 <1290100750.3041.72.camel@mulgrave.site>
 <alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com>
 <1290168976.2570.45.camel@dolmen>
 <4CE68155.50705@teksavvy.com>
 <20101119140203.GC10039@thunk.org>
 <20101119141007.GB25488@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mark Lord <kernel@teksavvy.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101119141007.GB25488@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 19, 2010 at 09:10:07AM -0500, Christoph Hellwig wrote:
> On Fri, Nov 19, 2010 at 09:02:03AM -0500, Ted Ts'o wrote:
> > Deterministic TRIM is an option.  It doesn't have to be implemented.
> 
> For reasonable use it has to.  That rationale for it is pretty clearly
> outline in ftp://ftp.t10.org/t10/document.08/08-347r1.pdf.
> 

I think the author of that slide deck was being a little hysterical.
In nearly all of these cases, if the file system is comptently
implemented (i.e., you don't do a trim on anything but a deleted file
block, and _only_ when you know the deleted is committed, and only the
filesystem --- not non-privileged users --- are allowed to use the
TRIM command), there's no issue.

One case where I'll admit he may have a point is where you are using
software RAID, where if the TRIM is not determinstic, the only thing
which is safe to do is a TRIM of an entire RAID stripe.  If the file
system doesn't know about the RAID geometry, then yes, in that case
determinstic TRIM is better --- although even then, it implies that
you have to rebuild the raid strip after you do a TRIM, which a
RAID-oblivious file system wouldn't do, and so you would still be
toast.

In the case of incompetently implemented, or buggy file systems, I'll
agree that non-determinstic trim offers a bunch of pitfalls --- but so
does deterministic trim in many of these cases.  For example, one of
their disaster scenarios was where you do a trim on an allocated
block, and then proceed to read from that allocated block.  That could
only happen if the trim happened but the delete didn't commit.  But in
that case, the fact that data blocks would disappear for a non-deleted
file is also a disaster, and means the file system wasn't implemented
correctly.

The other case where non-determinstic trim could get you in trouble is
if (a) you give a user direct read access to a partition of the disk,
without any file system as an intermediary, and (b) you allow that
non-privileged user to issue TRIM commands to that partition.  In that
case, it's possible that non-deterministic trim might allow you access
to non-deleted blocks in other partitions.  But this goes back to my
observation that you're totally safe so long as TRIM is a privileged
operation and/or only allowed to be executed by the file system.

So yeah, deterministic trim is tricker, and you have to be more
careful, especially if you're using RAID, but it's not inherently a
disaster...

						- Ted
