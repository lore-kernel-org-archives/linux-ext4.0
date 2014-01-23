From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] directory quota survey on xfs
Date: Fri, 24 Jan 2014 09:32:05 +1100
Message-ID: <20140123223205.GJ27606@dastard>
References: <20131222095929.GA11444@gmail.com>
 <20131223014222.GC3220@dastard>
 <20140115081201.GA3820@gmail.com>
 <5966C533-EF18-4804-8C83-DFBD607D9BE6@dilger.ca>
 <20140115213207.GJ3431@dastard>
 <20140121070706.GA1819@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com,
	Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:15168 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755028AbaAWWfi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Jan 2014 17:35:38 -0500
Content-Disposition: inline
In-Reply-To: <20140121070706.GA1819@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 21, 2014 at 03:07:06PM +0800, Zheng Liu wrote:
> Hi Dave,
> 
> On Thu, Jan 16, 2014 at 08:32:07AM +1100, Dave Chinner wrote:
> > On Wed, Jan 15, 2014 at 11:03:22AM -0700, Andreas Dilger wrote:
> > > quotas (to keep compatibility for existing XFS deployments), but add
> > > support into quota-tools so that it is usable by all filesystems.
> > 
> > Well, yes. If you are writing a generic quota tool, then it needs to
> > support all filesystems. We already have a fully featured quota API
> > that can provide this support - it's the API that XFS has been using
> > since it was ported to Linux.  We have the opportunity to unify the
> > quota APIs that ext4 and XFS, so we should take the opportunity
> > while it is here.  Don't create a new API for ext4 simply because of
> > NIH syndrome.
> 
> These days I was thinking about your comment that uses quotactl API to
> communicate the userspace tool with the kernel.  But I am still
> confusing about your comment that unifies the quota API between ext4 and
> XFS.
> 
> Now we have two flag sets in quotactl(2).  One (Q_QUOTAON, Q_GETQUOTA,
> etc...) is used by extN file system (I am not sure whether other file
> systems use these flags or not), and another (Q_XQUOTAON, Q_XGETQSTAT,
> etc...) is used by XFS.

I'm talking about making ext4 be able to use Q_XQUOTAON,
Q_XGETQSTAT, etc.

> In xfs_quota it uses an ioctl(2) to get/set/check project id,

Right, because that's a filesystem specific operation that has no
equivalent in any other filesystem at this point in time. Same for
the project inheritence inode flag.

You're going to need to add such an interface to ext4 to do this, so
add a generic ioctl and wire XFS up to it as well. This is kind
of why I want a generic xattr namespace for inode flags/attribute
at the VFS - so we don't have to keep inventing new
ioctl/fcntl interfaces to make this sort of functionality common
between different filesystems - we just define a new attribute
string and values and let individual filesystems handle how they
store them.

> and calls
> quotactl(2) with Q_XSETQLIM/Q_XGETQUOTA to set/get project quota.

Right, that's the quota management interface - it can also be used
to manage user and group quotas, so in userspace you can just use
the one interface for everything

> On
> kernel side, ->set_dqblk()/get_dqblk() is called when we try to set/get
> project quota in XFS.

And user/group quotas, too.

> In ext4 the same callback functions are used to
> set/get user/group quota, although on userspace we use Q_SETQUOTA/
> Q_GETQUOTA to set/get quota.  I am not sure I fully understand your
> meaning that unifies the quota API between ext4 and XFS.  Do you mean
> that we should use Q_XSETQLIM/Q_XGETQUOTA flags to set/get quota on ext4?

What I mean is that you should have quotatool speak the Q_X* quota
protocol defined in include/uapi/linux/dqblk_xfs.h via quotactl(2)
if the underlying filesystem supports it.  Indeed, quotatool already
detects XFS filesystems and switches to using the Q_X* interface
automatically, so there shouldn't be a huge amount of change needed
in it to support project quotas via this interface, nor add ext4
support to use the interface.

Then for project quota support in ext4, you implement the Q_X* quota
ops methods for that protocol similar method to xfs in
fs/xfs/xfs_quotaops.c.  That way ext4 will be able to speak both the
current v0-v2 protocols (so it doesn't break userspace compatibility
with older binaries), and the userspace quotatool will be able to
fully manage project quotas on both XFS and ext4 filesystems in a
common manner.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
