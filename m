From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/4] quota: add project quota support
Date: Mon, 4 Aug 2014 16:08:18 +0200
Message-ID: <20140804140818.GB25770@quack.suse.cz>
References: <CAPTn0cD3eZgL1FaJLrgN-c_vhsvSoifmyLah=y60ejcAEOz-Mg@mail.gmail.com>
 <20140801201756.GD7525@quack.suse.cz>
 <CAPTn0cDkN_aBZwOVCZjPcJD+8ArKvPmZcE7XHwkDRSjoXhVY+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbaHDOIV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Aug 2014 10:08:21 -0400
Content-Disposition: inline
In-Reply-To: <CAPTn0cDkN_aBZwOVCZjPcJD+8ArKvPmZcE7XHwkDRSjoXhVY+A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 02-08-14 09:35:58, Li Xi wrote:
> 2014-08-02 4:17 GMT+08:00 Jan Kara <jack@suse.cz>:
> > On Fri 01-08-14 23:48:31, Li Xi wrote:
> >> 2014-08-01 23:28 GMT+08:00 Li Xi <pkuelelixi@gmail.com>:
> >> > 2014-08-01 20:40 GMT+08:00 Jan Kara <jack@suse.cz>:
> >> >>
> >> >> 1) It should have been also posted to linux-fsdevel@vger.kernel.org, Al Viro
> >> >> <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org> because
> >> >> you are changing core VFS inode and infrastructure as well. For quota
> >> >> changes you should have also CCed me as a quota maintainer.
> >> > Sure. Thanks for reminding me. I will add these addresses next time.
> >> >>
> >> >> 2) I'm not convinced we actually want project ID in the core inode - so far
> >> >> only XFS has this. For everyone else it's just extra bloat so we could just
> >> >> put it in ext4_inode_info. Granted we'd need to somewhat change quota
> >> >> interface so that it sees all the ids (uid, gid, projid) but they are
> >> >> really needed in two places - dquot_initalize() and dquot_transfer() and
> >> >> creating variants of these functions that just take an array of ids and use
> >> >> them in ext4 is simple enough.
> >> > OK, agreed.
> >> After searching dquot_initalize() and dquot_transfer(), I found changing these
> >> two functions envolves too many file systems. Is there any good reason not to
> >> add kprojid_t field in inode structure?
> >   Yes. It grows struct inode which is used by *all* filesystems and only
> > ext4 (and possibly xfs) would use it. That's why I suggested you create
> > something like:
> >
> > struct inode_ids {
> >         kuid_t uid;
> >         kgid_t gid;
> >         kprojid_t projid;
> > };
> >
> > void dquot_initialize_ids(struct inode *inode, struct inode_ids *ids)
> > {
> > ...
> > }
> >
> > and
> >
> > static inline void dquot_initialize(struct inode *inode)
> > {
> >         struct inode_ids ids = {
> >                                 .uid = inode->i_uid,
> >                                 .gid = inode->i_gid,
> >                                 .projid = INVALID_PROJID,
> >                         };
> >         dquot_initialize_ids(inode, &ids);
> > }
> >
> > Then filesystems not using project ids remain untouched and filesystems
> > with project ids (i.e. ext4) can use dquot_initialize_ids() - probably you
> > should create something like:
> >
> > static inline void ext4_dquot_initialize(struct inode *inode)
> > {
> >         struct inode_ids ids = {
> >                                 .uid = inode->i_uid,
> >                                 .gid = inode->i_gid,
> >                                 .projid = EXT4_I(inode)->i_projid,
> >                         };
> >         dquot_initialize_ids(inode, &ids);
> > }
> >
> > and use ext4_dquot_initialize() throughout ext4.
> >
> I tried to change it in this way, but there ia another problem. add_dquot_ref()
> calls __dquot_initialize() for each inode in the list of super block. That means
> there is no way to pass projid as an argument of __dquot_initialize(). The
> solution is to add a get_projid() method (and maybe set_projid too) in the
> inode_operations structure.
  Hum, you are right. add_dquot_ref() is an issue. So probably we'll have
add get_projid() method to struct dquot_operations (similar to
get_reserved_space() we have there).

> Personally, I perfer to add projid in the inode
> stucture, since projid looks like uid and gid of an inode.
> get_projid()/setprojid()
> looks duplicated with getattr()/setattr() or getxattr()/setxattr(). Is there any
> performance impact of increasing size of inode structure, e.g. cache
> line problem?  I will add get_projid() method if so.
  I agree projid looks like uid or gid. But uid & gid are in POSIX so
everyone needs them. projid isn't so we'll just waste space for lots of
inodes (not too much but still some and this way struct inode gets slowly
bloated and we can have lots of inodes around). And it's not too hard to
live without project ID in core inode... Once significant portion of
filesystems start to support project ID, situation is different and we'll
move project ID into core inode.

Regarding getting & setting project ID from userspace I suppose you'll have
to resort to fs-specific ioctl like XFS does and then setting project ID in
fs-specific part of the inode is trivial.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
