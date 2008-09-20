From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Sat, 20 Sep 2008 17:43:12 +1000
Message-ID: <20080920074312.GR5811@disturbed>
References: <20080914180132.GC13074@mit.edu> <20080914180843.GA31649@infradead.org> <20080914195811.GE13074@mit.edu> <20080915144754.GA16491@infradead.org> <20080916064514.GH3241@webber.adilger.int> <20080916220346.GB10562@mit.edu> <20080917141840.GB8750@logfs.org> <20080917150212.GD22613@shareable.org> <20080919140502.GA6985@think.oraclecorp.com> <20080919173802.GB17666@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org, Mark Fasheh <mfasheh@suse.com>,
	mtk.manpages@gmail.com
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:17378 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826AbYITHnR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Sep 2008 03:43:17 -0400
Content-Disposition: inline
In-Reply-To: <20080919173802.GB17666@shareable.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 19, 2008 at 06:38:02PM +0100, Jamie Lokier wrote:
> Chris Mason wrote:
> > On Wed, Sep 17, 2008 at 04:02:12PM +0100, Jamie Lokier wrote:
> > > Assume that even reading after unmounting is not 100% safe, because
> > > the data blocks could be relocated after calling FIEMAP (when the
> > > filesystem must be mounted), and before the unmount.
> > 
> > For the journal case at least, grub can walk through the log of the FS
> > looking for up to date copies of things.  It does this already for
> > reiserfs because the btree can't be trusted at all without a log replay.

OMFG.

> Ok, that's good - grub doesn't need FIEMAP, it reads the filesystem properly.

That's garbage.  The whole point of using an API like FIEMAP is to
avoid the problems with having to parse the raw disk structures to
do stuff.

Grub has extremely hacky implementation of just the stuff it needs
to read stuff directly off disk.  The grub filesystem code is not
reviewed by the various filesystem teams, it doesn't even use the
same code as the filesystems, and last time I looked at it I came
away with bleeding eyes and didn't want to look any further.

Why was I even looking at the grub code? Well, grub doesn't
implement everyhting that is needed to parse XFS metadata
structures. In particular, the problem was out-of-line symlinks
in XFS, or traversing symlinks that point to symlinks was simply
not implemented in the grub XFS code. Of course, this was considered
to be an XFS problem, not a grub problem....

Not to mention that if we change the metadata disk format which is
conditional on a superblock feature bit set at mkfs time, grub knows
*nothing* about that new on disk format, how to parse it and will
break horribly on such a filesystem.

All the APIs are there to prevent such problems that grub has. I
just wish that they would be used rather than using grub's broken
design as justification for not needing or using such APIs.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
