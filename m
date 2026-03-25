Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66567DA66;
	Wed, 25 Mar 2026 22:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774477389; cv=none; b=s9rIGzz3Ylqr8hzdGT8pjminFbcksyZ1aLEcwg/Yw5Oe0FMVCFX4ykL1335GSVSpTAmZGrXSlkJMMwi4NQFQZ7qfPmfAaNuZhEiUnY/tAFgoiyqNZHK0DMEByEwiiDwuz+CIWrpQ4zFRiBoddh6R0gy5wTj7IT9EIwIL75mL9pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774477389; c=relaxed/simple;
	bh=z49CW4WZ4B5BXleSQAlxQqIheEUir9AXycNw+QiKGMo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Geylb439fR3eypLYkfq4MpOGd0kYIMIKKvL3OkXllPPwJPqLLBMa6i8nk+GK+iN/gnAW3BoInB/tP5hsv6ckAqiqi0+gc7DiUobzhStFOmT0QZIfvpSpLyeVmuUGR4777YOVlZpjcX0OaJ/1pVf3TxCbSN+zBPNzyg1BRGGMOtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ChS+nSn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ChS+nSn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62366C4CEF7;
	Wed, 25 Mar 2026 22:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774477389;
	bh=z49CW4WZ4B5BXleSQAlxQqIheEUir9AXycNw+QiKGMo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ChS+nSn/mIwYAQYg5oRJT2R3e1IF5i73fa7GAax4JC5lqXjYvbsulB5+mm/NsSABx
	 16SQEOCSMcnbjtGSURgmK0JAdkmmYpIewZzvwL3kO/cY2GDik4Qd/UElLJZKGIwmWQ
	 iROJfb8Ut+9Zwf4FlGpxWHkk0gG/AAE09Hr26USCbzrny24KGlizMN4KRdEhJuf7+O
	 3AteONOU2bwc/jGIeBi2Au26u7K57JOdBNXN48sRmCQ+h+y3Njufl4c8Xw3owLKFfR
	 Ml2CabgEwU+joQvqBM5hqqb+yb0rvTnQj/rmfOcYNSiU9NuAaVXO+pJluzWiUK/Ye9
	 qwv2SZEBqe3cQ==
Date: Wed, 25 Mar 2026 15:23:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, bpf@vger.kernel.org, bernd@bsbernd.com,
	neal@gompa.dev, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH 4/5] fuse: update file mode when updating acls
Message-ID: <20260325222308.GH6202@frogsfrogsfrogs>
References: <177188733084.3935219.10400570136529869673.stgit@frogsfrogsfrogs>
 <177188733196.3935219.3172887920210313838.stgit@frogsfrogsfrogs>
 <CAJnrk1YL3KnON-WtNjNi+2GZ+6rYvnVUnYwCk5efv0o41XkxcA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1YL3KnON-WtNjNi+2GZ+6rYvnVUnYwCk5efv0o41XkxcA@mail.gmail.com>

On Wed, Mar 25, 2026 at 12:39:57PM -0700, Joanne Koong wrote:
> On Mon, Feb 23, 2026 at 3:07 PM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > If someone sets ACLs on a file that can be expressed fully as Unix DAC
> > mode bits, most local filesystems will then update the mode bits and
> > drop the ACL xattr to reduce inefficiency in the file access paths.
> > Let's do that too.  Note that means that we can setacl and end up with
> > no ACL xattrs, so we also need to tolerate ENODATA returns from
> > fuse_removexattr.
> >
> > Note that here we define a "local" fuse filesystem as one that uses
> > fuseblk mode; we'll shortly add fuse servers that use iomap for the file
> > IO path to that list.
> >
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  fs/fuse/fuse_i.h |    2 +-
> >  fs/fuse/acl.c    |   43 ++++++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 43 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/fuse/acl.c b/fs/fuse/acl.c
> > index cbde6ac1add35a..f2b959efd67490 100644
> > --- a/fs/fuse/acl.c
> > +++ b/fs/fuse/acl.c
> > @@ -11,6 +11,18 @@
> >  #include <linux/posix_acl.h>
> >  #include <linux/posix_acl_xattr.h>
> >
> > +/*
> > + * If this fuse server behaves like a local filesystem, we can implement the
> > + * kernel's optimizations for ACLs for local filesystems instead of passing
> > + * the ACL requests straight through to another server.
> > + */
> > +static inline bool fuse_inode_has_local_acls(const struct inode *inode)
> > +{
> > +       const struct fuse_conn *fc = get_fuse_conn(inode);
> > +
> > +       return fc->posix_acl && fuse_inode_is_exclusive(inode);
> > +}
> > +
> >  static struct posix_acl *__fuse_get_acl(struct fuse_conn *fc,
> >                                         struct inode *inode, int type, bool rcu)
> >  {
> > @@ -98,6 +110,7 @@ int fuse_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
> >         struct inode *inode = d_inode(dentry);
> >         struct fuse_conn *fc = get_fuse_conn(inode);
> >         const char *name;
> > +       umode_t mode = inode->i_mode;
> >         int ret;
> >
> >         if (fuse_is_bad(inode))
> > @@ -113,6 +126,18 @@ int fuse_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
> >         else
> >                 return -EINVAL;
> >
> > +       /*
> > +        * If the ACL can be represented entirely with changes to the mode
> > +        * bits, then most filesystems will update the mode bits and delete
> > +        * the ACL xattr.
> > +        */
> > +       if (acl && type == ACL_TYPE_ACCESS &&
> > +           fuse_inode_has_local_acls(inode)) {
> > +               ret = posix_acl_update_mode(idmap, inode, &mode, &acl);
> > +               if (ret)
> > +                       return ret;
> > +       }
> > +
> >         if (acl) {
> >                 unsigned int extra_flags = 0;
> >                 /*
> 
> I think this sentence in this comment block "Fuse userspace is
> responsible for updating access permissions in the inode, if needed"
> needs some updating now, since this is only now true for non-local
> fuse servers

Done.

	/*
	 * For non-local filesystems, fuse userspace is responsible for
	 * updating access permissions in the inode, if needed.
	 * fuse_setxattr invalidates the inode attributes, which will
	 * force them to be refreshed the next time they are used, and
	 * it also updates i_ctime.
	 */

> 
> > @@ -139,7 +164,7 @@ int fuse_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
> >                  * through POSIX ACLs. Such daemons don't expect setgid bits to
> >                  * be stripped.
> >                  */
> > -               if (fc->posix_acl &&
> > +               if (fc->posix_acl && mode == inode->i_mode &&
> 
> Maybe a bit verbose but imo it'd be clearer if we had a separate
> boolean tracking the case where the kernel updated the mode bits,
> instead of using "mode == inode->i_mode" here and below for the
> fuse_do_setattr() logic block. That makes it more clear here to reason
> about (eg it'd at least make it more obvious here that we don't need
> to strip sgid since the kernel already did that when it updated the
> mode bits earlier)

Yeah, this could be keyed off fuse_inode_has_local_acls().

> 
> >                     !in_group_or_capable(idmap, inode,
> >                                          i_gid_into_vfsgid(idmap, inode)))
> >                         extra_flags |= FUSE_SETXATTR_ACL_KILL_SGID;
> > @@ -148,6 +173,22 @@ int fuse_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
> >                 kfree(value);
> >         } else {
> >                 ret = fuse_removexattr(inode, name);
> > +               /* If the acl didn't exist to start with that's fine. */
> > +               if (ret == -ENODATA)
> > +                       ret = 0;
> > +       }
> > +
> > +       /* If we scheduled a mode update above, push that to userspace now. */
> > +       if (!ret) {
> > +               struct iattr attr = { };
> > +
> > +               if (mode != inode->i_mode) {
> > +                       attr.ia_valid |= ATTR_MODE;
> > +                       attr.ia_mode = mode;
> > +               }
> > +
> > +               if (attr.ia_valid)
> > +                       ret = fuse_do_setattr(idmap, dentry, &attr, NULL);
> >         }
> 
> I think this logic reads clearer if it's restructured to
> 
> if (!ret && mode != inode->i_mode) {
>     struct iattr attr = {
>             .ia_valid = ATTR_MODE,
>             .ia_mode = mode,
>      };
> 
>     ret = fuse_do_setattr(idmap, dentry, &attr, NULL);
> }
> 
> >
> >         if (fc->posix_acl) {
> >
> 
> For local / exclusive servers, the kernel already has / sets the
> refreshed attributes, so we could probably skip the invalidation logic
> here for that case since the cache is already uptodate?

I could, but down in the iomap patchset I add more logic to update the
ctime:

	struct iattr attr = { };

	/*
	 * When we're running in iomap mode, we need to update mode and
	 * ctime ourselves instead of letting the fuse server figure
	 * that out.
	 */
	if (is_iomap) {
		attr.ia_valid |= ATTR_CTIME;
		inode_set_ctime_current(inode);
		attr.ia_ctime = inode_get_ctime(inode);
	}

	/*
	 * If we scheduled a mode update above, push that to userspace
	 * now.
	 */
	if (mode != inode->i_mode) {
		attr.ia_valid |= ATTR_MODE;
		attr.ia_mode = mode;
	}

	if (attr.ia_valid)
		ret = fuse_do_setattr(idmap, dentry, &attr, NULL);

In non-iomap "local acls" mode the server's still expected to update
ctime in set/removexattr.  OTOH I guess that is ... 65-16=49 patches
from now so maybe it's worth the churn?

Either way thanks for getting back to this. :)

--D

> Thanks,
> Joanne
> 
