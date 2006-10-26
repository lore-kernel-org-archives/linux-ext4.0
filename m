From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext3: bogus i_mode errors with 2.6.18.1
Date: Thu, 26 Oct 2006 12:01:33 -0600
Message-ID: <20061026180133.GN3509@schatzie.adilger.int>
References: <20061023144556.GY22487@skl-net.de> <20061023164416.GM3509@schatzie.adilger.int> <20061023200242.GA5015@schatzie.adilger.int> <20061024091449.GZ22487@skl-net.de> <20061024202716.GX3509@schatzie.adilger.int> <20061025094418.GA22487@skl-net.de> <20061026093613.GM3509@schatzie.adilger.int> <20061026160241.GB12843@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1423651AbWJZSBh@vger.kernel.org>
To: Andre Noll <maan@systemlinux.org>
Content-Disposition: inline
In-Reply-To: <20061026160241.GB12843@skl-net.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 26, 2006  18:02 +0200, Andre Noll wrote:
> On 03:36, Andreas Dilger wrote:
> > The other issue is that you need to potentially set "num" bits in the
> > bitmap here, if those all overlap metadata.  In fact, it might just
> > make more sense at this stage to walk all of the bits in the bitmaps,
> > the inode table and the backup superblock and group descriptor to see
> > if they need fixing also.
> 
> I tried to implement this, but I could not find out how to check at this
> point whether a given bit (in the block bitmap, say) needs fixing.

Well, since we know at least one bit needs fixing and results in the block
being written to disk then setting the bits for all of the other metadata
blocks in this group has no extra IO cost (only a tiny amount of CPU).
Re-setting the bits if they are already set is not harmful.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
