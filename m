From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/5] ext4: Implement project ID support for ext4
 filesystem
Date: Fri, 22 Jun 2012 13:07:53 +1000
Message-ID: <20120622030753.GU19223@dastard>
References: <1340269733-25922-1-git-send-email-dmonakhov@openvz.org>
 <1340269733-25922-4-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:60456 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755707Ab2FVDH5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jun 2012 23:07:57 -0400
Content-Disposition: inline
In-Reply-To: <1340269733-25922-4-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 21, 2012 at 01:08:51PM +0400, Dmitry Monakhov wrote:
> * Abstract
>   A subtree of a directory tree T is a tree consisting of a directory
>   (the subtree root) in T and all of its descendants in T.
> 
>   *NOTE*: User is allowed to break pure subtree hierarchy via manual
>           id manipulation.
> 
>   Project subtrees assumptions:
>   (1) Each inode has an id. This id is persistently stored inside
>       inode (xattr, usually inside ibody)
>   (2) Project id is inherent from parent directory

You are mashing two different concepts into one, and naming it in a
manner guaranteed to create confusion with all the people already
using project quotas on XFS. You're implementing subtree quotas, not
project quotas.

>   This feature is similar to project-id in XFS.  One may assign
>   some id to a subtree. Each entry from the subtree may be
>   accounted in directory project quota. Will appear in later
>   patches.

As implied above, project quotas ID in XFS are not subtree quotas.
They are used to implement project quotas, not subtree quotas.
subtree quotas are a userspace management construction using a
subset of project quota infrastructure. i.e. the inheritance of
project IDs in XFS and the restriction of operations to within
subtrees is not a function of project quotas - it's a separately
managed feature that was added to support the functioanlity needed
for subtree quotas.

ISTR raising this objection last time you posted this patch set -
either you implement project quotas as they exist in XFS and handle
subtree quotas as a constrainted set of project quota functionality
or you need to drop all references to "project quotas" and call this
something like sub-tree quotas that uses subtree IDs.

> * Disk layout
>   Project id is stored on disk inside xattr usually inside ibody.
>   Xattr is used only as a data storage, It has not user visible xattr
>   interface.

If you've got enough xattrs on the inode, then it will end up out of
line and performance is going to suck - every time you write to a
cold file you now need two IOs - one to read the extent list, and
one to read the xattrs to get the project ID....

> * User interface
>   Project id is accessible via generic xattr interface "system.project_id"

Which means it is an incompatible with XFS. What purpose does this
serve except to confuse people? Why not a generic set/get project ID
quotactl/ioctl? That's much easier for applications to use compared
to xattrs, and far easier to support different implementations
across filesystems. The way the project ID is stored in ext4 should
not define the API.

Indeed, an ioctl/quotactl style interface matches the existing quota
interface, so it's much more natural to use a similar API to one
already used for quota manipulation...

> * Notes
>   ext4_setattr interface to prjid: Semantically prjid must being changed
>   similar to uid/gid, but project_id is stored inside xattr so on-disk
>   structures updates is not that trivial, so I've move prjid change
>   logic to separate function.

I suspect that there are corner cases you haven't thought about
yet. What happens when you hard link a file into two separate
subtrees? how do you account for that? What happens when you remove
the hard link from the subtree the inode is accounted to?  What
happens when a rename occurs, moving a file from one subtree to
another? 

.....

> +static int
> +ext4_xattr_prj_set(struct dentry *dentry, const char *name,
> +		const void *value, size_t size, int flags, int type)
> +{
> +	unsigned int new_prjid;
> +	if (strcmp(name, "") != 0)
> +		return -EINVAL;
> +	new_prjid = simple_strtoul(value, (char **)&value, 0);
> +	return ext4_prj_change(dentry->d_inode, new_prjid);

Because you are using strings rather than integers for the ID, you
need to do a lot better verification here - what will happen when
someone tries to set an ID of "frobnozzle"? Using integers via
ioctls for the user API make this problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
