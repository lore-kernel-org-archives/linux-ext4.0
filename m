From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH 09/10 v1][RESEND] ext4: don't need to writeout all
 dirty pages in punch hole
Date: Mon, 23 Jul 2012 19:57:22 +0800
Message-ID: <20120723115722.GA3363@gmail.com>
References: <1342943986-12413-1-git-send-email-wenqing.lz@taobao.com>
 <1342943986-12413-10-git-send-email-wenqing.lz@taobao.com>
 <alpine.LFD.2.00.1207231249020.20857@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xiaoqiangnk@gmail.com, achender@linux.vnet.ibm.com,
	wenqing.lz@taobao.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:45952 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2GWLss (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jul 2012 07:48:48 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1207231249020.20857@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Lukas,

On Mon, Jul 23, 2012 at 01:01:53PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Sun, 22 Jul 2012, Zheng Liu wrote:
>=20
> > Date: Sun, 22 Jul 2012 15:59:45 +0800
> > From: Zheng Liu <gnehzuil.liu@gmail.com>
> > To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
> > Cc: xiaoqiangnk@gmail.com, achender@linux.vnet.ibm.com, wenqing.lz@=
taobao.com
> > Subject: [RFC][PATCH 09/10 v1][RESEND] ext4: don't need to writeout=
 all dirty
> >     pages in punch hole
> >=20
> > From: Zheng Liu <wenqing.lz@taobao.com>
> >=20
> > Now we don't need to writeout all dirty pages when punching a hole.=
  The i_mutex
> > locking is taken to avoid concurrent writes.  In truncate_pagecache=
_range, all
> > pages in this hole is released, and ext4_es_remove_space is called =
to update
> > extent status tree.=20
>=20
> Hi Zheng,
>=20
> I am currently in the middle of reworking punch hole for ext4 so
> there will be some changes in this area. See the patch set
>=20
> http://www.spinics.net/lists/linux-ext4/msg33014.html

Thank you for your reminding.  I have seen your patch set and it is
pretty cool.  IMHO your patch set shall be merged into upstream kernel
before applying io tree because io tree still has a lot of things that
needs to be done.  So I will change it according to your patches. :-)

> Moreover I think that we should avoid taking i_mutex if we can and I
> believe that we can in this case, because we only need to prevent
> allocation. So I just want to let you know that this part is
> probably going to change anyway.

It seems that we need to take i_mutex locking to prevent from buffered
writes after page cache has been truncated by truncate_pagecache_range.
If a buffered write without delalloc occurs after truncating page cache
and before taking i_data_sem, that means that the allocated block for
this buffered write will be removed in ext4_ext_remove_space when the
offset is within the range of the hole.  Am I missing something?

Regards,
Zheng

> >=20
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > ---
> >  fs/ext4/extents.c |   28 ++++++++++++----------------
> >  1 files changed, 12 insertions(+), 16 deletions(-)
> >=20
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index f2c5294..2a526b4 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -4529,9 +4529,11 @@ int ext4_ext_punch_hole(struct file *file, l=
off_t offset, loff_t length)
> >  	loff_t first_page_offset, last_page_offset;
> >  	int credits, err =3D 0;
> > =20
> > +	mutex_lock(&inode->i_mutex);
> > +
> >  	/* No need to punch hole beyond i_size */
> >  	if (offset >=3D inode->i_size)
> > -		return 0;
> > +		goto error;
> > =20
> >  	/*
> >  	 * If the hole extends beyond i_size, set the hole
> > @@ -4549,18 +4551,6 @@ int ext4_ext_punch_hole(struct file *file, l=
off_t offset, loff_t length)
> >  	first_page_offset =3D first_page << PAGE_CACHE_SHIFT;
> >  	last_page_offset =3D last_page << PAGE_CACHE_SHIFT;
> > =20
> > -	/*
> > -	 * Write out all dirty pages to avoid race conditions
> > -	 * Then release them.
> > -	 */
> > -	if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIR=
TY)) {
> > -		err =3D filemap_write_and_wait_range(mapping,
> > -			offset, offset + length - 1);
> > -
> > -		if (err)
> > -			return err;
> > -	}
> > -
> >  	/* Now release the pages */
> >  	if (last_page_offset > first_page_offset) {
> >  		truncate_pagecache_range(inode, first_page_offset,
> > @@ -4572,12 +4562,14 @@ int ext4_ext_punch_hole(struct file *file, =
loff_t offset, loff_t length)
> > =20
> >  	credits =3D ext4_writepage_trans_blocks(inode);
> >  	handle =3D ext4_journal_start(inode, credits);
> > -	if (IS_ERR(handle))
> > -		return PTR_ERR(handle);
> > +	if (IS_ERR(handle)) {
> > +		err =3D PTR_ERR(handle);
> > +		goto error;
> > +	}
> > =20
> >  	err =3D ext4_orphan_add(handle, inode);
> >  	if (err)
> > -		goto out;
> > +		goto error;
> > =20
> >  	/*
> >  	 * Now we need to zero out the non-page-aligned data in the
> > @@ -4652,6 +4644,8 @@ int ext4_ext_punch_hole(struct file *file, lo=
ff_t offset, loff_t length)
> >  	ext4_ext_invalidate_cache(inode);
> >  	ext4_discard_preallocations(inode);
> > =20
> > +	err =3D ext4_es_remove_space(inode, first_block,
> > +				   stop_block - first_block);
> >  	err =3D ext4_ext_remove_space(inode, first_block, stop_block - 1)=
;
> > =20
> >  	ext4_ext_invalidate_cache(inode);
> > @@ -4667,6 +4661,8 @@ out:
> >  	inode->i_mtime =3D inode->i_ctime =3D ext4_current_time(inode);
> >  	ext4_mark_inode_dirty(handle, inode);
> >  	ext4_journal_stop(handle);
> > +error:
> > +	mutex_unlock(&inode->i_mutex);
> >  	return err;
> >  }
> >  int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fi=
einfo,
> >=20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
