From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/5] ext4: Implement project ID support for ext4
 filesystem
Date: Thu, 28 Jun 2012 12:16:55 +0200
Message-ID: <20120628101655.GA17515@quack.suse.cz>
References: <1340269733-25922-1-git-send-email-dmonakhov@openvz.org>
 <1340269733-25922-4-git-send-email-dmonakhov@openvz.org>
 <20120622030753.GU19223@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979Ab2F1KQ7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Jun 2012 06:16:59 -0400
Content-Disposition: inline
In-Reply-To: <20120622030753.GU19223@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 22-06-12 13:07:53, Dave Chinner wrote:
> On Thu, Jun 21, 2012 at 01:08:51PM +0400, Dmitry Monakhov wrote:
> > * Abstract
> >   A subtree of a directory tree T is a tree consisting of a directory
> >   (the subtree root) in T and all of its descendants in T.
> > 
> >   *NOTE*: User is allowed to break pure subtree hierarchy via manual
> >           id manipulation.
> > 
> >   Project subtrees assumptions:
> >   (1) Each inode has an id. This id is persistently stored inside
> >       inode (xattr, usually inside ibody)
> >   (2) Project id is inherent from parent directory
> 
> You are mashing two different concepts into one, and naming it in a
> manner guaranteed to create confusion with all the people already
> using project quotas on XFS. You're implementing subtree quotas, not
> project quotas.
> 
> >   This feature is similar to project-id in XFS.  One may assign
> >   some id to a subtree. Each entry from the subtree may be
> >   accounted in directory project quota. Will appear in later
> >   patches.
> 
> As implied above, project quotas ID in XFS are not subtree quotas.
> They are used to implement project quotas, not subtree quotas.
> subtree quotas are a userspace management construction using a
> subset of project quota infrastructure. i.e. the inheritance of
> project IDs in XFS and the restriction of operations to within
> subtrees is not a function of project quotas - it's a separately
> managed feature that was added to support the functioanlity needed
> for subtree quotas.
> 
> ISTR raising this objection last time you posted this patch set -
> either you implement project quotas as they exist in XFS and handle
> subtree quotas as a constrainted set of project quota functionality
> or you need to drop all references to "project quotas" and call this
> something like sub-tree quotas that uses subtree IDs.
  Frankly, I fail to see the difference between XFS project quotas and how
Dmitry implemented his variant of quotas. He associated additional ID with
each inode and that ID can have quota limits. This seems pretty much like
what XFS project quotas do but maybe I'm missing something.

I agree that his changelogs somewhat suggest that he had only subtrees in
mind but the code does not really depend on that AFAICS. The only
difference I can see is that in XFS project ID is inherited only if
XFS_DIFLAG_PROJINHERIT is set and that is inherited by default but can be
manipulated from userspace. But that looks like a minor thing.

> > * Disk layout
> >   Project id is stored on disk inside xattr usually inside ibody.
> >   Xattr is used only as a data storage, It has not user visible xattr
> >   interface.
> 
> If you've got enough xattrs on the inode, then it will end up out of
> line and performance is going to suck - every time you write to a
> cold file you now need two IOs - one to read the extent list, and
> one to read the xattrs to get the project ID....
> 
> > * User interface
> >   Project id is accessible via generic xattr interface "system.project_id"
> 
> Which means it is an incompatible with XFS. What purpose does this
> serve except to confuse people? Why not a generic set/get project ID
> quotactl/ioctl? That's much easier for applications to use compared
> to xattrs, and far easier to support different implementations
> across filesystems. The way the project ID is stored in ext4 should
> not define the API.
> 
> Indeed, an ioctl/quotactl style interface matches the existing quota
> interface, so it's much more natural to use a similar API to one
> already used for quota manipulation...
  I'm kind of undecided here - xattrs have the disadvantages you wrote
above but also some advantages like that backup tools know about them, you
can manipulate them with setxattr, getxattr, etc.

>From kernel POV I agree that for XFS it's a bit ugly to fake the project
quota xattr though...

> > * Notes
> >   ext4_setattr interface to prjid: Semantically prjid must being changed
> >   similar to uid/gid, but project_id is stored inside xattr so on-disk
> >   structures updates is not that trivial, so I've move prjid change
> >   logic to separate function.
> 
> I suspect that there are corner cases you haven't thought about
> yet. What happens when you hard link a file into two separate
> subtrees? how do you account for that? What happens when you remove
> the hard link from the subtree the inode is accounted to?  What
> happens when a rename occurs, moving a file from one subtree to
> another?
  Yeah, handling of these things is missing from an ext4 patch. Good that
you've spotted that. I forgot about it.

> .....
> 
> > +static int
> > +ext4_xattr_prj_set(struct dentry *dentry, const char *name,
> > +		const void *value, size_t size, int flags, int type)
> > +{
> > +	unsigned int new_prjid;
> > +	if (strcmp(name, "") != 0)
> > +		return -EINVAL;
> > +	new_prjid = simple_strtoul(value, (char **)&value, 0);
> > +	return ext4_prj_change(dentry->d_inode, new_prjid);
> 
> Because you are using strings rather than integers for the ID, you
> need to do a lot better verification here - what will happen when
> someone tries to set an ID of "frobnozzle"? Using integers via
> ioctls for the user API make this problem....
  Well, simple_strtoul() returns something for arbitary string - that's the
project ID ;). But I agree forcing project ID 0 if there's parse error is
more user friendly given the simple_strtoul() return value for unparseable
strings can change.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
