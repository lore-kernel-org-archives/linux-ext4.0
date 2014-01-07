From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] fs: xattr-based FS_IOC_[GS]ETFLAGS interface
Date: Tue, 7 Jan 2014 14:02:13 -0800
Message-ID: <20140107220213.GD9229@birch.djwong.org>
References: <20140107025855.GA9229@birch.djwong.org>
 <20140107124831.GD16640@quack.suse.cz>
 <20140107154935.GA17609@infradead.org>
 <20140107170430.GA2822@thunk.org>
 <20140107194356.GC9229@birch.djwong.org>
 <1389124784.23310.15.camel@ret.masoncoding.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"hch@infradead.org" <hch@infradead.org>,
	"miklos@szeredi.hu" <miklos@szeredi.hu>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"rlb@defaultvalue.org" <rlb@defaultvalue.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"aurelien@aurel32.net" <aurelien@aurel32.net>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"jack@suse.cz" <jack@suse.cz>
To: Chris Mason <clm@fb.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36832 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbaAGWDK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jan 2014 17:03:10 -0500
Content-Disposition: inline
In-Reply-To: <1389124784.23310.15.camel@ret.masoncoding.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 07, 2014 at 07:59:15PM +0000, Chris Mason wrote:
> On Tue, 2014-01-07 at 11:43 -0800, Darrick J. Wong wrote:
> > On Tue, Jan 07, 2014 at 12:04:30PM -0500, Theodore Ts'o wrote:
> > > On Tue, Jan 07, 2014 at 07:49:35AM -0800, Christoph Hellwig wrote:
> > > > On Tue, Jan 07, 2014 at 01:48:31PM +0100, Jan Kara wrote:
> > > > >   I have to say I'm not thrilled by the idea of juggling strings in
> > > > > userspace and in kernel to set a flag for an inode...
> > > > 
> > > > Nevermind the massive amounts of code that sit in the filesystem.
> > > 
> > > The reason for this patch was to address what Dave Chinner has called
> > > "a shitty interface"[1].  Using bitfields that need to be coordinated
> > > across file systems, when sometimes a bit assignment is validly a fs
> > > specific thing, and then later becomes something that gets shared
> > > across file systems.
> > > 
> > > [1] http://thread.gmane.org/gmane.linux.file-systems/80164/focus=80396
> > > 
> > > If we don't go about it this way, there are alternatives: we could
> > > create new ioctls (or a new syscall) as we start running out of bits
> > > used by FS_IOC_[GS]ETFLAGS.  We can create new ioctls for bits which
> > > are intended for fs-specific flags, which then later get promoted to
> > > the new syscall when some functionality starts to get shared accross
> > > other file systems (probably with a different bit assignment).  This
> > > is certainly less code, but it does mean more complexity outside of
> > > the code when we try to coordinate new functionality across file
> > > systems.
> > 
> > I had thought of indexed inode flags as an alternative to the xattr/string
> > parsing thing.  Feature flags make their first appearance as part of a per-FS
> > flag-space and are migrated to the common flag-space when there is demand.
> > It would also avoid the need for each fs to create its own flag ioctl.
> > 
> > On the other hand, someone suggested I try remaking IOC_[GS]ETFLAG as an xattr,
> > so off I went. :)
> > 
> 
> At least in btrfs xattrs are more expensive than something right in the
> inode.  We can cache it when we load the inode (it'll be right next to
> the inode most of the time) but for performance critical things I do
> like the good old fashioned flags.

Just to clarify -- I wasn't proposing any on-disk changes for any filesystems,
merely creating virtual xattrs that wrap the inode flags.

> It's also possible to turn xattrs off, so we have to deal with
> filesystems that are mounted with them off and then back on again.  I
> can't think of huge problems from that right now, just something to be
> aware of.

Just to satisfy my curiosity: are xattrs always separate objects in btrfs?

--D
> 
> -chris
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
