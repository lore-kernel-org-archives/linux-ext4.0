Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE003563FB;
	Wed, 25 Mar 2026 22:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774476745; cv=none; b=I59T7zM/NG0N8bsOzgy9bwjd57lEQiAhp5q6fF+rDaL4IbH1p0BQNX3t+0V9SFN1Uu+8tPJAxJx2o3DFYrv0qABjmuXIKGP6IEc9J+e/sbQLWNRtK+nx5dIOnUbXlAyYuCuyOX0qxTIio819KEbOoll3iUjqHce0QMLjjwC2P7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774476745; c=relaxed/simple;
	bh=rbAlc8Rhl8PMQBnjFbZ/hlsd4nHOhW9/up6gimmrhW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oih82Oy+EPzoCJLO63ZwXQ1c+K/Z4S9tYIR+8RupiXulahGfosocPrgHmU30AFDcwh/l8Y0HZtm/c1s7q1jgaVb01/p494iHYdmty3MUEbzHR4yEY0oGplKQxf7Fh5/xmkUA9914yUcldFO7drV2+0JlrngqCMzlmlW5/1XVOo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pg3trNfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pg3trNfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83BC8C4CEF7;
	Wed, 25 Mar 2026 22:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774476745;
	bh=rbAlc8Rhl8PMQBnjFbZ/hlsd4nHOhW9/up6gimmrhW8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pg3trNfPcDaaiMq/Ilhqs4aWxsEtkNXLtZGtHjFSlqyILNyWc9vkKKddSEUqZNY6U
	 MYudpCZq+ePEggiMRwfksz8pWLz5NVoDVdSvtS6x0xCl8u/Ybx4/4bSvjis/5k/K5J
	 Wr7V4znLHk3ou5Dds3kKfRapyEj3a9yAlpj/HUSmxzbVpqWCCIJQNEdCNQ0sjwHXOp
	 LW0k3uJ/T5jch/5IItdYnV/sIcXsh7GjAJyJ58rYjqYivJojr3ZZRBQ51IyXl4djvJ
	 LDPp5oDty9bZc9Y1f1lurpaZtBDnNEr81XdQlY0KeXEm6znhVNl75CV2JsnSVXGkAd
	 LxQ2W8a6cyfxQ==
Date: Wed, 25 Mar 2026 15:12:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, bpf@vger.kernel.org, bernd@bsbernd.com,
	neal@gompa.dev, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH 3/5] fuse: implement file attributes mask for statx
Message-ID: <20260325221225.GG6202@frogsfrogsfrogs>
References: <177188733084.3935219.10400570136529869673.stgit@frogsfrogsfrogs>
 <177188733175.3935219.14499232455997407711.stgit@frogsfrogsfrogs>
 <CAJnrk1ZZV=nf2ZvsFz2gCEdFanK2c=_4X8hH5PyZ4ys-b5T8kQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1ZZV=nf2ZvsFz2gCEdFanK2c=_4X8hH5PyZ4ys-b5T8kQ@mail.gmail.com>

On Wed, Mar 25, 2026 at 11:35:47AM -0700, Joanne Koong wrote:
> On Mon, Feb 23, 2026 at 3:07 PM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > Actually copy the attributes/attributes_mask from userspace.  Ignore
> > file attributes bits that the VFS sets (or doesn't set) on its own.
> >
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  fs/fuse/fuse_i.h |   37 +++++++++++++++++++++++++++++++++++++
> >  fs/fuse/dir.c    |    4 ++++
> >  fs/fuse/inode.c  |    4 ++++
> >  3 files changed, 45 insertions(+)
> >
> >
> > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > index 1d4beca5c7018d..79793db3e9a743 100644
> > --- a/fs/fuse/fuse_i.h
> > +++ b/fs/fuse/fuse_i.h
> > @@ -147,6 +147,10 @@ struct fuse_inode {
> >         /** Version of last attribute change */
> >         u64 attr_version;
> >
> > +       /** statx file attributes */
> > +       u64 statx_attributes;
> > +       u64 statx_attributes_mask;
> > +
> >         union {
> >                 /* read/write io cache (regular file only) */
> >                 struct {
> > @@ -1236,6 +1240,39 @@ void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
> >                                    u64 attr_valid, u32 cache_mask,
> >                                    u64 evict_ctr);
> >
> > +/*
> > + * These statx attribute flags are set by the VFS so mask them out of replies
> > + * from the fuse server for local filesystems.  Nonlocal filesystems are
> > + * responsible for enforcing and advertising these flags themselves.
> > + */
> > +#define FUSE_STATX_LOCAL_VFS_ATTRIBUTES (STATX_ATTR_IMMUTABLE | \
> > +                                        STATX_ATTR_APPEND)
> > +
> > +/*
> > + * These statx attribute flags are set by the VFS so mask them out of replies
> > + * from the fuse server.
> > + */
> > +#define FUSE_STATX_VFS_ATTRIBUTES (STATX_ATTR_AUTOMOUNT | STATX_ATTR_DAX | \
> > +                                  STATX_ATTR_MOUNT_ROOT)
> > +
> > +static inline u64 fuse_statx_attributes_mask(const struct inode *inode,
> > +                                            const struct fuse_statx *sx)
> > +{
> > +       if (fuse_inode_is_exclusive(inode))
> > +               return sx->attributes_mask & ~(FUSE_STATX_VFS_ATTRIBUTES |
> > +                                              FUSE_STATX_LOCAL_VFS_ATTRIBUTES);
> > +       return sx->attributes_mask & ~FUSE_STATX_VFS_ATTRIBUTES;
> > +}
> > +
> > +static inline u64 fuse_statx_attributes(const struct inode *inode,
> > +                                       const struct fuse_statx *sx)
> > +{
> > +       if (fuse_inode_is_exclusive(inode))
> > +               return sx->attributes & ~(FUSE_STATX_VFS_ATTRIBUTES |
> > +                                         FUSE_STATX_LOCAL_VFS_ATTRIBUTES);
> > +       return sx->attributes & ~FUSE_STATX_VFS_ATTRIBUTES;
> > +}
> > +
> >  u32 fuse_get_cache_mask(struct inode *inode);
> >
> >  /**
> > diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> > index 7ac6b232ef1232..10fa47e969292f 100644
> > --- a/fs/fuse/dir.c
> > +++ b/fs/fuse/dir.c
> > @@ -1464,6 +1464,8 @@ static int fuse_do_statx(struct mnt_idmap *idmap, struct inode *inode,
> >                 stat->result_mask = sx->mask & (STATX_BASIC_STATS | STATX_BTIME);
> >                 stat->btime.tv_sec = sx->btime.tv_sec;
> >                 stat->btime.tv_nsec = min_t(u32, sx->btime.tv_nsec, NSEC_PER_SEC - 1);
> > +               stat->attributes |= fuse_statx_attributes(inode, sx);
> > +               stat->attributes_mask |= fuse_statx_attributes_mask(inode, sx);
> >                 fuse_fillattr(idmap, inode, &attr, stat);
> >                 stat->result_mask |= STATX_TYPE;
> >         }
> > @@ -1568,6 +1570,8 @@ static int fuse_update_get_attr(struct mnt_idmap *idmap, struct inode *inode,
> >                         stat->btime = fi->i_btime;
> >                         stat->result_mask |= STATX_BTIME;
> >                 }
> > +               stat->attributes = fi->statx_attributes;
> > +               stat->attributes_mask = fi->statx_attributes_mask;
> 
> Do these need to be |= so we don't overwrite any vfs attributes stored
> in stat already?

Ackpth yes.  Good catch!

--D

> Thanks,
> Joanne
> 
> >         }
> >
> >         return err;
> > diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> > index 58c3351b467221..ff8b94cb02e63c 100644
> > --- a/fs/fuse/inode.c
> > +++ b/fs/fuse/inode.c
> > @@ -286,6 +286,10 @@ void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
> >                         fi->i_btime.tv_sec = sx->btime.tv_sec;
> >                         fi->i_btime.tv_nsec = sx->btime.tv_nsec;
> >                 }
> > +
> > +               fi->statx_attributes = fuse_statx_attributes(inode, sx);
> > +               fi->statx_attributes_mask = fuse_statx_attributes_mask(inode,
> > +                                                                      sx);
> >         }
> >
> >         if (attr->blksize)
> >
> 
