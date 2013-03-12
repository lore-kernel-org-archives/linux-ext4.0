From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] Ext2: do not mark_inode_dirty to avoid BUG_ON
Date: Tue, 12 Mar 2013 11:13:33 +0100
Message-ID: <20130312101333.GB13152@quack.suse.cz>
References: <513EB7DD.3020103@cn.fujitsu.com>
 <alpine.LFD.2.00.1303120904030.7128@dhcp-1-104.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: fanchaoting <fanchaoting@cn.fujitsu.com>, jack@suse.cz,
	tyhicks@canonical.com, linux-ext4@vger.kernel.org,
	wangshilong1991@gmail.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34199 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932166Ab3CLKNf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Mar 2013 06:13:35 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1303120904030.7128@dhcp-1-104.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 12-03-13 09:14:21, Luk=C3=A1=C5=A1 Czerner wrote:
> On Tue, 12 Mar 2013, fanchaoting wrote:
>=20
> > Date: Tue, 12 Mar 2013 13:06:37 +0800
> > From: fanchaoting <fanchaoting@cn.fujitsu.com>
> > To: jack@suse.cz
> > Cc: tyhicks@canonical.com, linux-ext4@vger.kernel.org,
> >     wangshilong1991@gmail.com
> > Subject: [PATCH] Ext2: do not mark_inode_dirty to avoid BUG_ON
> >=20
> > From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> >=20
> > commit 8e3dffc651cb668e1ff4d8b89cc1c3dde7540d3b leads into
> > a regression that casue BUG_ON when unlinking inode.
>=20
> Hi,
>=20
> it seems to be that we do need to mark the inode dirty, because
> we're changing inode->i_blocks from within
> dquot_free_block_nodirty().
>=20
> However looking at the code we usually call mark_inode_dirty(inode)
> after we call ext2_free_blocks() except when we're about to remove
> the inode so it seems that having that call within ext2_free_blocks()
> is not necessary.
  Yeah. Actually the problem is specifically with ext2_xattr_delete_ino=
de()
marking inode dirty because that is called after clear_inode(). Everyth=
ing
before clear_inode() call is free to dirty the inode because clear_inod=
e()
clears the dirty flag. I wonder if we shouldn't move that call into
ext2_evict_inode() before clear_inode() and be done with it. Because th=
e
fact that ext2_free_blocks() cannot dirty the inode looks more surprisi=
ng
than the fact that ext2_free_inode() doesn't automatically free extende=
d
attributes.

> However I am not sure about the error path in ext2_alloc_branch()
> which does not dirty the inode after calling ext2_free_blocks().
> However presumably since we're just undoing the changes we might
> have done and not actually allocating, or freeing any space for
> real, dirtying the inode might not be necessary. Can you confirm
> that ?
  I think that needs to dirty the inode. It may be written out in some
intermediate state...

								Honza

> > Reported-by: tyhicks@canonical.com
> > Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> > ---
> >  fs/ext2/balloc.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> >=20
> > diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> > index 9f9992b..06d82fc 100644
> > --- a/fs/ext2/balloc.c
> > +++ b/fs/ext2/balloc.c
> > @@ -562,7 +562,6 @@ error_return:
> >  	if (freed) {
> >  		percpu_counter_add(&sbi->s_freeblocks_counter, freed);
> >  		dquot_free_block_nodirty(inode, freed);
> > -		mark_inode_dirty(inode);
> >  	}
> >  }
> > =20
> > -- 1.7.7.6=20
> >=20
> >=20
> >=20
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
