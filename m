From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC] directory quota survey on xfs
Date: Thu, 23 Jan 2014 16:06:29 -0800
Message-ID: <20140124000629.GB8973@birch.djwong.org>
References: <20131222095929.GA11444@gmail.com>
 <20131223014222.GC3220@dastard>
 <20140115081201.GA3820@gmail.com>
 <5966C533-EF18-4804-8C83-DFBD607D9BE6@dilger.ca>
 <20140115213207.GJ3431@dastard>
 <20140121070706.GA1819@gmail.com>
 <20140123223205.GJ27606@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com,
	Li Xi <pkuelelixi@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37569 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaAXAHC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jan 2014 19:07:02 -0500
Content-Disposition: inline
In-Reply-To: <20140123223205.GJ27606@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 24, 2014 at 09:32:05AM +1100, Dave Chinner wrote:
> On Tue, Jan 21, 2014 at 03:07:06PM +0800, Zheng Liu wrote:
> > Hi Dave,
> > 
> > On Thu, Jan 16, 2014 at 08:32:07AM +1100, Dave Chinner wrote:
> > > On Wed, Jan 15, 2014 at 11:03:22AM -0700, Andreas Dilger wrote:
> > > > quotas (to keep compatibility for existing XFS deployments), but add
> > > > support into quota-tools so that it is usable by all filesystems.
> > > 
> > > Well, yes. If you are writing a generic quota tool, then it needs to
> > > support all filesystems. We already have a fully featured quota API
> > > that can provide this support - it's the API that XFS has been using
> > > since it was ported to Linux.  We have the opportunity to unify the
> > > quota APIs that ext4 and XFS, so we should take the opportunity
> > > while it is here.  Don't create a new API for ext4 simply because of
> > > NIH syndrome.
> > 
> > These days I was thinking about your comment that uses quotactl API to
> > communicate the userspace tool with the kernel.  But I am still
> > confusing about your comment that unifies the quota API between ext4 and
> > XFS.
> > 
> > Now we have two flag sets in quotactl(2).  One (Q_QUOTAON, Q_GETQUOTA,
> > etc...) is used by extN file system (I am not sure whether other file
> > systems use these flags or not), and another (Q_XQUOTAON, Q_XGETQSTAT,
> > etc...) is used by XFS.
> 
> I'm talking about making ext4 be able to use Q_XQUOTAON,
> Q_XGETQSTAT, etc.
> 
> > In xfs_quota it uses an ioctl(2) to get/set/check project id,
> 
> Right, because that's a filesystem specific operation that has no
> equivalent in any other filesystem at this point in time. Same for
> the project inheritence inode flag.
> 
> You're going to need to add such an interface to ext4 to do this, so
> add a generic ioctl and wire XFS up to it as well. This is kind
> of why I want a generic xattr namespace for inode flags/attribute
> at the VFS - so we don't have to keep inventing new
> ioctl/fcntl interfaces to make this sort of functionality common
> between different filesystems - we just define a new attribute
> string and values and let individual filesystems handle how they
> store them.

I wonder, do you have an opinion on my patches to do just that?  Since it was
an RFC I only wired up ext4; first with string-based xattrs[1] and again as a
(namespace, flags) integer tuple[2].  Jan disliked juggling strings around
(they don't bring me oodles of happiness either), Christoph doesn't like the
magic xattrs, and Ted seemed lukewarm so I'm inclined to fix up the other FSes
a la [2].

(...and please everybody don't co-opt this thread for inode flags any more than
I have.)

--D

[1] http://lkml.org/lkml/2014/1/6/1059 (fs: xattr-based FS_IOC_[GS]ETFLAGS interface)
[2] http://lkml.org/lkml/2014/1/7/534 (fs: new FS_IOC_[GS]ETFLAGS2 interface)
