From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 07/15] ext4: Take i_mutex before punching hole
Date: Fri, 27 Jul 2012 20:08:28 +0800
Message-ID: <20120727120828.GA24550@gmail.com>
References: <1343376074-28034-1-git-send-email-lczerner@redhat.com>
 <1343376074-28034-8-git-send-email-lczerner@redhat.com>
 <alpine.LFD.2.00.1207271103190.4079@vpn-10-43.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47176 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2G0L7p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Jul 2012 07:59:45 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1207271103190.4079@vpn-10-43.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 27, 2012 at 11:04:02AM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> Add Zheng Liu to the CC

Hi Lukas,

It looks good to me. :-)

Regards,
Zheng

>=20
> On Fri, 27 Jul 2012, Lukas Czerner wrote:
>=20
> > Date: Fri, 27 Jul 2012 10:01:06 +0200
> > From: Lukas Czerner <lczerner@redhat.com>
> > To: linux-fsdevel@vger.kernel.org
> > Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, hughd@google.com,
> >     linux-mmc@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
> > Subject: [PATCH 07/15] ext4: Take i_mutex before punching hole
> >=20
> > Currently the allocation might happen in the punched range after th=
e
> > truncation and before the releasing the space of the range. This wo=
uld
> > lead to blocks being unallocated under the mapped buffer heads resu=
lting
> > in nasty bugs.
> >=20
> > With this commit we take i_mutex before going to do anything in the
> > ext4_ext_punch_hole() preventing any write to happen while the hole
> > punching is in progress. This will also allow us to ditch the write=
out
> > of dirty pages withing the range.
> >=20
> > This commit was based on code provided by Zheng Liu, thanks!
> >=20
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  fs/ext4/extents.c |   26 ++++++++++----------------
> >  1 files changed, 10 insertions(+), 16 deletions(-)
> >=20
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 91341ec..2d6a216 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -4755,9 +4755,11 @@ int ext4_ext_punch_hole(struct file *file, l=
off_t offset, loff_t length)
> >  	loff_t first_page_offset, last_page_offset;
> >  	int credits, err =3D 0;
> > =20
> > +	mutex_lock(&inode->i_mutex);
> > +
> >  	/* No need to punch hole beyond i_size */
> >  	if (offset >=3D inode->i_size)
> > -		return 0;
> > +		goto out1;
> > =20
> >  	/*
> >  	 * If the hole extends beyond i_size, set the hole
> > @@ -4775,18 +4777,6 @@ int ext4_ext_punch_hole(struct file *file, l=
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
> > @@ -4798,12 +4788,14 @@ int ext4_ext_punch_hole(struct file *file, =
loff_t offset, loff_t length)
> > =20
> >  	credits =3D ext4_writepage_trans_blocks(inode);
> >  	handle =3D ext4_journal_start(inode, credits);
> > -	if (IS_ERR(handle))
> > -		return PTR_ERR(handle);
> > +	if (IS_ERR(handle)) {
> > +		err =3D PTR_ERR(handle);
> > +		goto out1;
> > +	}
> > =20
> >  	err =3D ext4_orphan_add(handle, inode);
> >  	if (err)
> > -		goto out;
> > +		goto out1;
> > =20
> >  	/*
> >  	 * Now we need to zero out the non-page-aligned data in the
> > @@ -4893,6 +4885,8 @@ out:
> >  	inode->i_mtime =3D inode->i_ctime =3D ext4_current_time(inode);
> >  	ext4_mark_inode_dirty(handle, inode);
> >  	ext4_journal_stop(handle);
> > +out1:
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
