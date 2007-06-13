From: Dmitriy Monakhov <dmonakhov@sw.ru>
Subject: Re: [patch] new aop loop fix
Date: Wed, 13 Jun 2007 21:29:39 +0400
Message-ID: <20070613172939.GE13815@localhost.sw.ru>
References: <20070613134631.GB13815@localhost.sw.ru> <Pine.LNX.4.64.0706131426070.4539@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de,
	mark.fasheh@oracle.com, linux-ext4@vger.kernel.org
To: Hugh Dickins <hugh@veritas.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:3622 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755446AbXFMO3S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Jun 2007 10:29:18 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706131426070.4539@blonde.wat.veritas.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 14:36 =D0=A1=D1=80=D0=B4 13 =D0=98=D1=8E=D0=BD     , Hugh Dickins wr=
ote:
> On Wed, 13 Jun 2007, Dmitriy Monakhov wrote:
>=20
> > 	loop.c code itself is not perfect. In fact before Nick's patch
> > 	partial write was't possible. Assumption what write chunks are
> > 	always page aligned is realy weird ( see "index++" line).
> >=20
> > Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
>=20
> I'm interested, because I'm trying to chase down an -mm bug which
> occasionally leaves me with 1k of zeroes where it shouldn't (in a
> 1k bsize ext2 looped over tmpfs).  The length of time for this to
> happen varies a lot, so bisection has been misleading: maybe the
> problem lies in Nick's patches, maybe it does not.
>=20
> But I don't understand your fix below at all.  _If_ you need to
> change the handling of index, then you need to change the handling
> of offset too, don't you?
>=20
> But what's wrong with how inded was handled anyway?  Yes, it might
> be being incremented at the bottom of the loop when we haven't
> reached the end of this page, but in that case we're not going
> round the loop again anyway: len will now be 0.  So no problem.
>=20
> One of us is missing something: please enlighten me - thanks.
Yepp. You absolutely right, wrong patch was attached :(
Btw: Nick's patches broke  LO_CRYPT_XOR mode, but it is ok because
this feature was absolete and not used by anyone, am i right here?
>=20
> Hugh
>=20
> >=20
> > diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> > index 4bab9b1..8726da5 100644
> > --- a/drivers/block/loop.c
> > +++ b/drivers/block/loop.c
> > @@ -215,7 +215,6 @@ static int do_lo_send_aops(struct loop_device *=
lo, struct bio_vec *bvec,
> >  	int len, ret;
> > =20
> >  	mutex_lock(&mapping->host->i_mutex);
> > -	index =3D pos >> PAGE_CACHE_SHIFT;
> >  	offset =3D pos & ((pgoff_t)PAGE_CACHE_SIZE - 1);
> >  	bv_offs =3D bvec->bv_offset;
> >  	len =3D bvec->bv_len;
> > @@ -226,6 +225,7 @@ static int do_lo_send_aops(struct loop_device *=
lo, struct bio_vec *bvec,
> >  		struct page *page;
> >  		void *fsdata;
> > =20
> > +		index =3D pos >> PAGE_CACHE_SHIFT;
> >  		IV =3D ((sector_t)index << (PAGE_CACHE_SHIFT - 9))+(offset >> 9)=
;
> >  		size =3D PAGE_CACHE_SIZE - offset;
> >  		if (size > len)
> > @@ -255,7 +255,6 @@ static int do_lo_send_aops(struct loop_device *=
lo, struct bio_vec *bvec,
> >  		bv_offs +=3D copied;
> >  		len -=3D copied;
> >  		offset =3D 0;
> > -		index++;
> >  		pos +=3D copied;
> >  	}
> >  	ret =3D 0;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
