From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFCv3 00/12] xfstests: test the btrfs/xfs reflink/dedupe ioctls
Date: Thu, 12 Nov 2015 11:41:14 +1100
Message-ID: <20151112004114.GO19199@dastard>
References: <20151007051257.3260.73072.stgit@birch.djwong.org>
 <20151109075926.GB17974@infradead.org>
 <20151109184913.GB3255@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151109184913.GB3255@birch.djwong.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 09, 2015 at 10:49:13AM -0800, Darrick J. Wong wrote:
> On Sun, Nov 08, 2015 at 11:59:26PM -0800, Christoph Hellwig wrote:
> > On Tue, Oct 06, 2015 at 10:12:57PM -0700, Darrick J. Wong wrote:
> > >  * I don't have any interesting NFS/CIFS setups for test. :(
> > 
> > I have a banrch with client and server support for NFSv4.2 CLONE
> > support:
> > 
> > http://git.infradead.org/users/hch/pnfs.git/shortlog/refs/heads/reflink+clone
> > 
> > For now you want to use btrfs on the server, as using reflinks on XFS
> > seems to be a little unstable over NFS.
> 
> I found a few more bugs in the kernel-side implementation, which might explain
> that.  I'm about to start working on making CoW less crappy, but I'll push all
> the patches out to github.  (I wasn't planning on patchbombing again until
> December.)
> 
> > > If you're going to start using this mess, you probably ought to just
> > > pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
> > > They should just work with the btrfs that's in 4.3.
> > > 
> > > Comments and questions are, as always, welcome.
> > 
> > Any reason the groups are called clone?  I don't really have an opinion
> > on clone vs reflink but given that the xfs_io command is reflink I'd
> > rather be consistent.
> 
> The existing btrfs reflink tests were tagged in the 'clone' group prior to my
> patchset.
> 
> > Otherwise I'd say get it merged ASAP, we can still fix up various
> > details later.
> 
> I'll merge your patch and repost the whole pile of tests.  I'm almost ready to
> send a pile of updates for the XFS on-disk structure document which add stuff
> about the v5 format, rmapbt, and reflink.

Darrick, can you renumber the xfstests against what is currently at
the head of the repo? If both you an Christoph need them working,
you may as well both patch against the main xfstests repo...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
