From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 15/31] e2fsck: Teach EA refcounting code to handle 48bit
 block addresses
Date: Mon, 7 Oct 2013 11:37:43 -0700
Message-ID: <20131007183743.GB6860@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012818.28415.49000.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1310071717550.1975@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25594 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab3JGShu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Oct 2013 14:37:50 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1310071717550.1975@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 07, 2013 at 05:30:17PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Mon, 30 Sep 2013, Darrick J. Wong wrote:
>=20
> > Date: Mon, 30 Sep 2013 18:28:18 -0700
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > To: tytso@mit.edu, darrick.wong@oracle.com
> > Cc: linux-ext4@vger.kernel.org
> > Subject: [PATCH 15/31] e2fsck: Teach EA refcounting code to handle =
48bit block
> >      addresses
>=20
> Did you meant to say 64bit ?

Yep.

>=20
> >=20
> > The extended attribute refcounting code only accepts blk_t, which i=
s dangerous
> > because EA blocks can exist at high addresses (> 2^32) as well.  Th=
erefore,
> > widen the block fields to 64 bits.
> >=20
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  e2fsck/e2fsck.h      |   12 ++++++------
> >  e2fsck/ea_refcount.c |   36 ++++++++++++++++++------------------
> >  2 files changed, 24 insertions(+), 24 deletions(-)
> >=20
> >=20
> > diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
> > index 13d70f1..f1df525 100644
> > --- a/e2fsck/e2fsck.h
> > +++ b/e2fsck/e2fsck.h
> > @@ -432,17 +432,17 @@ extern struct dx_dir_info *e2fsck_dx_dir_info=
_iter(e2fsck_t ctx, int *control);
> >  /* ea_refcount.c */
> >  extern errcode_t ea_refcount_create(int size, ext2_refcount_t *ret=
);
> >  extern void ea_refcount_free(ext2_refcount_t refcount);
> > -extern errcode_t ea_refcount_fetch(ext2_refcount_t refcount, blk_t=
 blk,
> > +extern errcode_t ea_refcount_fetch(ext2_refcount_t refcount, blk64=
_t blk,
> >  				   int *ret);
> >  extern errcode_t ea_refcount_increment(ext2_refcount_t refcount,
> > -				       blk_t blk, int *ret);
> > +				       blk64_t blk, int *ret);
> >  extern errcode_t ea_refcount_decrement(ext2_refcount_t refcount,
> > -				       blk_t blk, int *ret);
> > +				       blk64_t blk, int *ret);
> >  extern errcode_t ea_refcount_store(ext2_refcount_t refcount,
> > -				   blk_t blk, int count);
> > -extern blk_t ext2fs_get_refcount_size(ext2_refcount_t refcount);
> > +				   blk64_t blk, int count);
> > +extern blk64_t ext2fs_get_refcount_size(ext2_refcount_t refcount);
> >  extern void ea_refcount_intr_begin(ext2_refcount_t refcount);
> > -extern blk_t ea_refcount_intr_next(ext2_refcount_t refcount, int *=
ret);
> > +extern blk64_t ea_refcount_intr_next(ext2_refcount_t refcount, int=
 *ret);
> > =20
> >  /* ehandler.c */
> >  extern const char *ehandler_operation(const char *op);
> > diff --git a/e2fsck/ea_refcount.c b/e2fsck/ea_refcount.c
> > index e66e636..bcce6a0 100644
> > --- a/e2fsck/ea_refcount.c
> > +++ b/e2fsck/ea_refcount.c
> > @@ -25,14 +25,14 @@
> >   * checked, its bit is set in the block_ea_map bitmap.
> >   */
> >  struct ea_refcount_el {
> > -	blk_t	ea_blk;
> > +	blk64_t	ea_blk;
> >  	int	ea_count;
> >  };
> > =20
> >  struct ea_refcount {
> > -	blk_t		count;
> > -	blk_t		size;
> > -	blk_t		cursor;
> > +	blk64_t		count;
> > +	blk64_t		size;
> > +	blk64_t		cursor;
>=20
> I am not sure if we really need count, size and cursor to be blk_t
> let alone blk64_t. It's a bit misleading because AFAICT those
> variable does not represent block numbers at all. Maybe it should be
> changed to something less confusing, preferably matching the actual
> xattr implementation ?

Oops, I got a little too s/blk_t/blk64_t/ happy there.  Those could be =
__u32, I
think.  Or unsigned long.

--D
>=20
> Thanks!
> -Lukas
>=20
> >  	struct ea_refcount_el	*list;
> >  };
> > =20
> > @@ -111,11 +111,11 @@ static void refcount_collapse(ext2_refcount_t=
 refcount)
> >   * 	specified position.
> >   */
> >  static struct ea_refcount_el *insert_refcount_el(ext2_refcount_t r=
efcount,
> > -						 blk_t blk, int pos)
> > +						 blk64_t blk, int pos)
> >  {
> >  	struct ea_refcount_el 	*el;
> >  	errcode_t		retval;
> > -	blk_t			new_size =3D 0;
> > +	blk64_t			new_size =3D 0;
> >  	int			num;
> > =20
> >  	if (refcount->count >=3D refcount->size) {
> > @@ -153,7 +153,7 @@ static struct ea_refcount_el *insert_refcount_e=
l(ext2_refcount_t refcount,
> >   * 	and we can't find an entry, create one in the sorted list.
> >   */
> >  static struct ea_refcount_el *get_refcount_el(ext2_refcount_t refc=
ount,
> > -					      blk_t blk, int create)
> > +					      blk64_t blk, int create)
> >  {
> >  	int	low, high, mid;
> > =20
> > @@ -206,7 +206,7 @@ retry:
> >  	return 0;
> >  }
> > =20
> > -errcode_t ea_refcount_fetch(ext2_refcount_t refcount, blk_t blk,
> > +errcode_t ea_refcount_fetch(ext2_refcount_t refcount, blk64_t blk,
> >  				int *ret)
> >  {
> >  	struct ea_refcount_el	*el;
> > @@ -220,7 +220,7 @@ errcode_t ea_refcount_fetch(ext2_refcount_t ref=
count, blk_t blk,
> >  	return 0;
> >  }
> > =20
> > -errcode_t ea_refcount_increment(ext2_refcount_t refcount, blk_t bl=
k, int *ret)
> > +errcode_t ea_refcount_increment(ext2_refcount_t refcount, blk64_t =
blk, int *ret)
> >  {
> >  	struct ea_refcount_el	*el;
> > =20
> > @@ -234,7 +234,7 @@ errcode_t ea_refcount_increment(ext2_refcount_t=
 refcount, blk_t blk, int *ret)
> >  	return 0;
> >  }
> > =20
> > -errcode_t ea_refcount_decrement(ext2_refcount_t refcount, blk_t bl=
k, int *ret)
> > +errcode_t ea_refcount_decrement(ext2_refcount_t refcount, blk64_t =
blk, int *ret)
> >  {
> >  	struct ea_refcount_el	*el;
> > =20
> > @@ -249,7 +249,7 @@ errcode_t ea_refcount_decrement(ext2_refcount_t=
 refcount, blk_t blk, int *ret)
> >  	return 0;
> >  }
> > =20
> > -errcode_t ea_refcount_store(ext2_refcount_t refcount, blk_t blk, i=
nt count)
> > +errcode_t ea_refcount_store(ext2_refcount_t refcount, blk64_t blk,=
 int count)
> >  {
> >  	struct ea_refcount_el	*el;
> > =20
> > @@ -263,7 +263,7 @@ errcode_t ea_refcount_store(ext2_refcount_t ref=
count, blk_t blk, int count)
> >  	return 0;
> >  }
> > =20
> > -blk_t ext2fs_get_refcount_size(ext2_refcount_t refcount)
> > +blk64_t ext2fs_get_refcount_size(ext2_refcount_t refcount)
> >  {
> >  	if (!refcount)
> >  		return 0;
> > @@ -277,7 +277,7 @@ void ea_refcount_intr_begin(ext2_refcount_t ref=
count)
> >  }
> > =20
> > =20
> > -blk_t ea_refcount_intr_next(ext2_refcount_t refcount,
> > +blk64_t ea_refcount_intr_next(ext2_refcount_t refcount,
> >  				int *ret)
> >  {
> >  	struct ea_refcount_el	*list;
> > @@ -370,7 +370,7 @@ int main(int argc, char **argv)
> >  	int	i =3D 0;
> >  	ext2_refcount_t refcount;
> >  	int		size, arg;
> > -	blk_t		blk;
> > +	blk64_t		blk;
> >  	errcode_t	retval;
> > =20
> >  	while (1) {
> > @@ -394,7 +394,7 @@ int main(int argc, char **argv)
> >  			printf("Freeing refcount\n");
> >  			break;
> >  		case BCODE_STORE:
> > -			blk =3D (blk_t) bcode_program[i++];
> > +			blk =3D (blk64_t) bcode_program[i++];
> >  			arg =3D bcode_program[i++];
> >  			printf("Storing blk %u with value %d\n", blk, arg);
> >  			retval =3D ea_refcount_store(refcount, blk, arg);
> > @@ -403,7 +403,7 @@ int main(int argc, char **argv)
> >  					"while storing blk %u", blk);
> >  			break;
> >  		case BCODE_FETCH:
> > -			blk =3D (blk_t) bcode_program[i++];
> > +			blk =3D (blk64_t) bcode_program[i++];
> >  			retval =3D ea_refcount_fetch(refcount, blk, &arg);
> >  			if (retval)
> >  				com_err("ea_refcount_fetch", retval,
> > @@ -413,7 +413,7 @@ int main(int argc, char **argv)
> >  				       blk, arg);
> >  			break;
> >  		case BCODE_INCR:
> > -			blk =3D (blk_t) bcode_program[i++];
> > +			blk =3D (blk64_t) bcode_program[i++];
> >  			retval =3D ea_refcount_increment(refcount, blk, &arg);
> >  			if (retval)
> >  				com_err("ea_refcount_increment", retval,
> > @@ -423,7 +423,7 @@ int main(int argc, char **argv)
> >  				       blk, arg);
> >  			break;
> >  		case BCODE_DECR:
> > -			blk =3D (blk_t) bcode_program[i++];
> > +			blk =3D (blk64_t) bcode_program[i++];
> >  			retval =3D ea_refcount_decrement(refcount, blk, &arg);
> >  			if (retval)
> >  				com_err("ea_refcount_decrement", retval,
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
