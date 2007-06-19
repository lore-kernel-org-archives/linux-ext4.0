From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: delayed allocatiou result in Oops
Date: Mon, 18 Jun 2007 18:01:17 -0700
Message-ID: <1182214878.3711.21.camel@dyn9047017103.beaverton.ibm.com>
References: <20070614072352.GA6517@localhost.sw.ru>
	 <4672202C.4080304@clusterfs.com>
	 <1181949368.3808.7.camel@dyn9047017103.beaverton.ibm.com>
	 <20070616081426.GB14349@localhost.sw.ru>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org
To: Dmitriy Monakhov <dmonakhov@sw.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:59627 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761980AbXFSBB3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jun 2007 21:01:29 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l5J0uhDN018466
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jun 2007 20:56:43 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5J11Q15052680
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jun 2007 19:01:26 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5J11Pgd027429
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jun 2007 19:01:26 -0600
In-Reply-To: <20070616081426.GB14349@localhost.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 2007-06-16 at 12:14 +0400, Dmitriy Monakhov wrote:
> On 16:16 =D0=9F=D1=82=D0=BD 15 =D0=98=D1=8E=D0=BD     , Mingming Cao =
wrote:
> > I hit almost the same issue today also, but with different error #,=
 and
> > one more kernel oops, when run fsstress on x86_64.=20
> >=20
> > EXT4-fs: writeback error =3D -2
> > EXT4-fs: writeback error =3D -2
> This error never happens in writeback in my case, only ENOSPC.
I see why, error -2 is ENOENT, your kernel already patched with your
previus patch to fix the return error from ext4_reserve_global() from
ENOENT to ENOSPC.

> > > > I've digged this a litle bit with folowig results:
> > > >=20
> > > > int block_read_full_page(struct page *page, get_block_t *get_bl=
ock)
> > > > {
> > > > ...
> > > > 1914:	if (!page_has_buffers(page)) <<< page_has_buffers(page) =3D=
=3D true=20
> > > > 		create_empty_buffers(page, blocksize, 0);
> > > > 	head =3D page_buffers(page); <<<<  page_buffers(page) =3D=3D N=
ULL =20
> > > > <<<i've add debug info here:
> > > > <<< page->flags =3D=3D 100000000000821
> > > > <<< PagePrivate(page) =3D=3D 1, (page)->private =3D=3D NULL
> > > > <<< So we have private page without buffers, it is WRONG.
> > > >=20

Right, I think the problem is the PagePrivate() is being set without a
valid page->private pointer.

The PagePrivate flag is being set by delayed allocation in the
ext4_wb_commit_write().

Looking at ext4-delayed-allocation.patch

+int ext4_wb_commit_write(struct file *file, struct page *page,
+                            unsigned from, unsigned to)
+{
+       loff_t pos =3D ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+       struct inode *inode =3D page->mapping->host;
+       int err =3D 0;
+
+       wb_debug("commit page %lu (%u-%u) for inode %lu\n",
+                       page->index, from, to, inode->i_ino);
+
+       /* mark page private so that we get
+        * called to invalidate/release page */
+       SetPagePrivate(page);
+
+       if (!PageBooked(page) && !PageMappedToDisk(page)) {
+               /* ->prepare_write() observed that block for this
+                * page hasn't been allocated yet. there fore it
+                * asked to reserve block for later allocation */
+               BUG_ON(page->private =3D=3D 0);
+               page->private =3D 0;
+               err =3D ext4_wb_reserve_space_page(page, 1);
+               if (err)
+                       return err;
+       }


It sets the PagePrivate flag at the commit_write() time.  And the page-
>private is cleared to 0. page->private is being set to 1 at
ext4_wb_prepare_write():

+int ext4_wb_prepare_write(struct file *file, struct page *page,
+                             unsigned from, unsigned to)
+{
+       struct inode *inode =3D page->mapping->host;
+       struct buffer_head bh, *bhw =3D &bh;
+       int err =3D 0;
+
+       wb_debug("prepare page %lu (%u-%u) for inode %lu\n",
+                       page->index, from, to, page->mapping->host->i_i=
no);
+
+       /* if page is uptodate this means that ->prepare_write() has
+        * been called on page before and page is mapped to disk or
+        * we did reservation. page is protected and nobody can
+        * access it. hence, it safe to use page->private to pass
+        * flag that ->commit_write() has to reserve blocks. because
+        * an error may occur after ->prepare_write() we should not
+        * reserve block here. it's better to do in ->commit_write()
+        * when we're sure page is to be written */
+       page->private =3D 0;
+       if (!PageUptodate(page)) {
+               /* first write to this page */
+               bh.b_state =3D 0;
+               err =3D ext4_get_block(inode, page->index, bhw, 0);
+               if (err)
+                       return err;
+               if (!buffer_mapped(bhw)) {
+                       /* this block isn't allocated yet, reserve spac=
e */
+                       wb_debug("reserve space for new block\n");
+                       page->private =3D 1;
+                       ext4_wb_clear_page(page, from, to);
+                       ClearPageMappedToDisk(page);



>From the comments it says the page->private is set to 1 to letting
commit_write know that it needs block reservation, but I don't see the
page->private value being checked in ext4_wb_commit_write(). Instead,
the PageMappedToDisk(page) flag is being checked.

Alex, can you clarify the use of page->private and PagePrivate flag
here? Do we still need the page->private for delayed allocation, with
PageBooked flag and PageMappedToDisk page flag?

Thanks,

Mingming
