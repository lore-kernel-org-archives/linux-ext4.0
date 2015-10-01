From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext2: don't mount filesystems with compat features we
 know only ext4 supports
Date: Thu, 1 Oct 2015 12:00:42 +1000
Message-ID: <20151001020041.GF3902@dastard>
References: <20150928223626.GI10390@birch.djwong.org>
 <20150930084126.GB16909@quack.suse.cz>
 <20150930163635.GK10390@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:16821 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931AbbJACBV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Sep 2015 22:01:21 -0400
Content-Disposition: inline
In-Reply-To: <20150930163635.GK10390@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 30, 2015 at 09:36:35AM -0700, Darrick J. Wong wrote:
> On Wed, Sep 30, 2015 at 10:41:26AM +0200, Jan Kara wrote:
> > On Mon 28-09-15 15:36:26, Darrick J. Wong wrote:
> > > The ext2 mount code never checks the compat features against the ones
> > > it knows about.  This is correct behavior since compat features are
> > > supposed to be rw-compatible with old drivers; however, for certain
> > > configurations (journalled rootfs) we probably want the ext4 driver
> > > to load, not ext2.
> > > 
> > > Reported-by: Dave Chinner <david@fromorbit.com>
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Isn't this a bit too harsh? I agree we should at least warn (and that's
> > probably regardless of EXT4 config option) but just refusing mount looks
> > too much to me...
> 
> I admit that refusing the mount might be a bit much; the goal here was
> merely to make it so that if the FS has a journal and ext4 was turned on,
> hopefully ext2 rejects the mount and ext4 will probe it next.

IMO it's worse to have the ext2 module is *incorrectly*
mounting ext3 filesystems and users silently losing the protection
of journalling.  Perhaps we should simply make ext4 probe before
ext2 probes anything. Anything that is not explicitly an ext4 or
ext3 filesystem can then be left to the ext2 module (if EXT4 is not
configured to also handle ext2).

But, really, I don't care enough about this to spend any more time
on it - my systems are working again so it's up the the EXT
maintainers to decide what to do with the problem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
