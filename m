From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 3/5] ext4: Implement project ID support for ext4 filesystem
Date: Tue, 03 Jul 2012 23:11:59 +0400
Message-ID: <87d34cy800.fsf@dmbot.sw.ru>
References: <1340269733-25922-1-git-send-email-dmonakhov@openvz.org> <1340269733-25922-4-git-send-email-dmonakhov@openvz.org> <20120622030753.GU19223@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62178 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab2GCTMG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jul 2012 15:12:06 -0400
In-Reply-To: <20120622030753.GU19223@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 22 Jun 2012 13:07:53 +1000, Dave Chinner <david@fromorbit.com> wrote:
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
Very very sorry for a long replay,
> You are mashing two different concepts into one, and naming it in a
> manner guaranteed to create confusion with all the people already
> using project quotas on XFS. You're implementing subtree quotas, not
> project quotas.
Actually this was already discussed, Initially i've called it as
subtree-id will strict tree behavior similar to XFS
1) Subtrees are true ADG
2) Id inherited from a parent
1) No hadrlink allowed across two subtries with different id
2) No cross-tree renames are allowed
But it some people, especially AlViro was not happy about this.
So i've simplify id ideology to simple rule
1) Inherent id from parent
This this is just an third ID similar to UID and GID without any
restrictions, but in case of project-id (or subtree-id) it can not be
inherent from current task because currently there is no way to
understand which container or sub-process group this task belongs to
That's why i've chose simplest and most obvious rule just inherent id
from parent. 
As far as i know nor project-id nor subtree-id are not ideal, but you
probably right most people already know that project-id affect
rename/link so i have to change the name to 'subtree-id', or may be 'bundle-id'
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
> 
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
> 
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
As i already noted my implementation does not affect rename/link at all.
But as far as i know most obvious use-case is when will restrict access
to some subtree via bindmout and pass it as a root to some set of tasks (container,cgroup)
Such set of task should not have privileges to change project-id
explicitly (only inheritance are allowed), in that case we will have
pure sub-trees hierarchy.
> 
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
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
