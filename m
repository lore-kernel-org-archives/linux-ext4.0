From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 17/31] libext2fs: Refactor u32-list to handle 32 and
 64-bit data types
Date: Thu, 10 Oct 2013 11:05:30 -0700
Message-ID: <20131010180530.GO6860@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012831.28415.54890.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1310101537440.1925@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47882 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab3JJSFm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Oct 2013 14:05:42 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1310101537440.1925@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 10, 2013 at 04:46:23PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Mon, 30 Sep 2013, Darrick J. Wong wrote:
>=20
> > Date: Mon, 30 Sep 2013 18:28:31 -0700
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > To: tytso@mit.edu, darrick.wong@oracle.com
> > Cc: linux-ext4@vger.kernel.org
> > Subject: [PATCH 17/31] libext2fs: Refactor u32-list to handle 32 an=
d 64-bit
> >     data types
> >=20
> > The curernt ext2_u32_list implementation manages a sorted sparse li=
st of 32-bit
> > numbers.  This is currently used to collect directory inodes for re=
hashing in
> > e2fsck, and creating a list of bad blocks for mkfs.  However, block=
 numbers are
> > now 64-bit, so we need to refactor the sparse list to be able to ha=
ndle both 32
> > and 64-bit numbers.
> >=20
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  lib/ext2fs/badblocks.c |  271 ++++++++++++++++++++++++++++++++++++=
+-----------
> >  lib/ext2fs/ext2fs.h    |   23 +++-
> >  lib/ext2fs/ext2fsP.h   |   13 +-
> >  lib/ext2fs/inode.c     |   12 +-
> >  4 files changed, 237 insertions(+), 82 deletions(-)
> >=20
>=20
> -- snip --
>=20
> > =20
> > @@ -105,64 +129,107 @@ errcode_t ext2fs_badblocks_copy(ext2_badbloc=
ks_list src,
> >  /*
> >   * This procedure adds a block to a badblocks list.
> >   */
> > -errcode_t ext2fs_u32_list_add(ext2_u32_list bb, __u32 blk)
> > +static int compare32(const void *a, const void *b)
> > +{
> > +	__u32 i, j;
> > +	i =3D *(__u32 *)a;
> > +	j =3D *(__u32 *)b;
> > +
> > +	return i - j;
> > +}
> > +
> > +static int compare64(const void *a, const void *b)
> > +{
> > +	__u64 i, j;
> > +	i =3D *(__u64 *)a;
> > +	j =3D *(__u64 *)b;
> > +
> > +	return i - j;
>=20
> Hmm this does not seem right. What if:
>=20
> i =3D 4294967296
> j =3D 8589934592
>=20
> then you would return 0 even though the two block numbers differs.
> The problem here is that even though you compare __u64 you return
> int.

Oops. :/

I think Ted would rather not deal with 64bit badblocks, so I think I'm
withdrawing patches 17-19 anyway.

--D
>=20
> Thanks!
> -Lukas
>=20
> > +}
> > +
> > +static errcode_t sparse_list_add(struct ext2_sparse_list *bb, void=
 *item)
> >  {
> >  	errcode_t	retval;
> > -	int		i, j;
> > +	int		i, j, k;
> >  	unsigned long	old_size;
> > +	int (*cmp)	(const void *a, const void *b);
> > =20
> >  	EXT2_CHECK_MAGIC(bb, EXT2_ET_MAGIC_BADBLOCKS_LIST);
> > =20
> >  	if (bb->num >=3D bb->size) {
> > -		old_size =3D bb->size * sizeof(__u32);
> > +		old_size =3D bb->size * bb->item_size;
> >  		bb->size +=3D 100;
> > -		retval =3D ext2fs_resize_mem(old_size, bb->size * sizeof(__u32),
> > +		retval =3D ext2fs_resize_mem(old_size, bb->size * bb->item_size,
> >  					   &bb->list);
> >  		if (retval) {
> >  			bb->size -=3D 100;
> >  			return retval;
> >  		}
> >  	}
> > -
> > +	if (bb->item_size =3D=3D sizeof(__u32))
> > +		cmp =3D compare32;
> > +	else if (bb->item_size =3D=3D sizeof(__u64))
> > +		cmp =3D compare64;
> > +	else
> > +		return EXT2_ET_INVALID_ARGUMENT;
> >  	/*
> >  	 * Add special case code for appending to the end of the list
> >  	 */
> >  	i =3D bb->num-1;
> > -	if ((bb->num !=3D 0) && (bb->list[i] =3D=3D blk))
> > +	if ((bb->num !=3D 0) && cmp(LIST_ITEM(bb, i), item) =3D=3D 0)
> >  		return 0;
> > -	if ((bb->num =3D=3D 0) || (bb->list[i] < blk)) {
> > -		bb->list[bb->num++] =3D blk;
> > +	if ((bb->num =3D=3D 0) || cmp(LIST_ITEM(bb, i), item) < 0) {
> > +		memcpy(LIST_ITEM(bb, bb->num++), item, bb->item_size);
> >  		return 0;
> >  	}
> > =20
> >  	j =3D bb->num;
> >  	for (i=3D0; i < bb->num; i++) {
> > -		if (bb->list[i] =3D=3D blk)
> > +		k =3D cmp(LIST_ITEM(bb, i), item);
> > +		if (k =3D=3D 0)
> >  			return 0;
> > -		if (bb->list[i] > blk) {
> > +		if (k > 0) {
>=20
> Since you're possibly comparing 64bit numbers and return int this
> would not work very well at all.
>=20
> >  			j =3D i;
> >  			break;
> >  		}
> >  	}
> > -	for (i=3Dbb->num; i > j; i--)
> > -		bb->list[i] =3D bb->list[i-1];
> > -	bb->list[j] =3D blk;
> > +	memmove(LIST_ITEM(bb, i + 1), LIST_ITEM(bb, i),
> > +		(bb->num - j) * bb->item_size);
> > +	memcpy(LIST_ITEM(bb, j), item, bb->item_size);
>=20
> What is the difference between j and i here ? I've got the feeling
> that both should be the same ?
>=20
> Thanks!
> -Lukas
>=20
> >  	bb->num++;
> >  	return 0;
> >  }
> > =20
> > +errcode_t ext2fs_u32_list_add(ext2_u32_list bb, __u32 blk)
> > +{
> > +	return sparse_list_add(bb, &blk);
> > +}
> > +
> > +errcode_t ext2fs_badblocks_list_add2(ext2_badblocks_list bb, blk64=
_t blk)
> > +{
> > +	return sparse_list_add(bb, &blk);
> > +}
> > +
> >  errcode_t ext2fs_badblocks_list_add(ext2_badblocks_list bb, blk_t =
blk)
> >  {
> > -	return ext2fs_u32_list_add((ext2_u32_list) bb, (__u32) blk);
> > +	return ext2fs_badblocks_list_add2(bb, blk);
> >  }
> > =20
> >  /*
> >   * This procedure finds a particular block is on a badblocks
> >   * list.
> >   */
> > -int ext2fs_u32_list_find(ext2_u32_list bb, __u32 blk)
> > +static int sparse_list_find(struct ext2_sparse_list *bb, void *ite=
m)
> >  {
> > -	int	low, high, mid;
> > +	int	low, high, mid, k;
> > +	int (*cmp)	(const void *a, const void *b);
> > +
> > +	if (bb->item_size =3D=3D sizeof(__u32))
> > +		cmp =3D compare32;
> > +	else if (bb->item_size =3D=3D sizeof(__u64))
> > +		cmp =3D compare64;
> > +	else
> > +		return EXT2_ET_INVALID_ARGUMENT;
> > =20
> >  	if (bb->magic !=3D EXT2_ET_MAGIC_BADBLOCKS_LIST)
> >  		return -1;
> > @@ -172,18 +239,19 @@ int ext2fs_u32_list_find(ext2_u32_list bb, __=
u32 blk)
> > =20
> >  	low =3D 0;
> >  	high =3D bb->num-1;
> > -	if (blk =3D=3D bb->list[low])
> > +	if (cmp(LIST_ITEM(bb, low), item) =3D=3D 0)
> >  		return low;
> > -	if (blk =3D=3D bb->list[high])
> > +	if (cmp(LIST_ITEM(bb, high), item) =3D=3D 0)
> >  		return high;
> > =20
> >  	while (low < high) {
> >  		mid =3D ((unsigned)low + (unsigned)high)/2;
> >  		if (mid =3D=3D low || mid =3D=3D high)
> >  			break;
> > -		if (blk =3D=3D bb->list[mid])
> > +		k =3D cmp(item, LIST_ITEM(bb, mid));
> > +		if (k =3D=3D 0)
> >  			return mid;
> > -		if (blk < bb->list[mid])
> > +		if (k < 0)
> >  			high =3D mid;
> >  		else
> >  			low =3D mid;
> > @@ -191,13 +259,26 @@ int ext2fs_u32_list_find(ext2_u32_list bb, __=
u32 blk)
> >  	return -1;
> >  }
> > =20
> > +int ext2fs_u32_list_find(ext2_u32_list bb, __u32 blk)
> > +{
> > +	return sparse_list_find(bb, &blk);
> > +}
> > +
> >  /*
> >   * This procedure tests to see if a particular block is on a badbl=
ocks
> >   * list.
> >   */
> >  int ext2fs_u32_list_test(ext2_u32_list bb, __u32 blk)
> >  {
> > -	if (ext2fs_u32_list_find(bb, blk) < 0)
> > +	if (sparse_list_find(bb, &blk) < 0)
> > +		return 0;
> > +	else
> > +		return 1;
> > +}
> > +
> > +int ext2fs_badblocks_list_test2(ext2_badblocks_list bb, blk64_t bl=
k)
> > +{
> > +	if (sparse_list_find(bb, &blk) < 0)
> >  		return 0;
> >  	else
> >  		return 1;
> > @@ -205,65 +286,83 @@ int ext2fs_u32_list_test(ext2_u32_list bb, __=
u32 blk)
> > =20
> >  int ext2fs_badblocks_list_test(ext2_badblocks_list bb, blk_t blk)
> >  {
> > -	return ext2fs_u32_list_test((ext2_u32_list) bb, (__u32) blk);
> > +	return ext2fs_badblocks_list_test2(bb, blk);
> >  }
> > =20
> > =20
> >  /*
> >   * Remove a block from the badblock list
> >   */
> > -int ext2fs_u32_list_del(ext2_u32_list bb, __u32 blk)
> > +static int sparse_list_del(struct ext2_sparse_list *bb, void *item=
)
> >  {
> > -	int	remloc, i;
> > +	int	remloc;
> > =20
> >  	if (bb->num =3D=3D 0)
> >  		return -1;
> > =20
> > -	remloc =3D ext2fs_u32_list_find(bb, blk);
> > +	remloc =3D sparse_list_find(bb, item);
> >  	if (remloc < 0)
> >  		return -1;
> > =20
> > -	for (i =3D remloc ; i < bb->num-1; i++)
> > -		bb->list[i] =3D bb->list[i+1];
> > +	memmove(LIST_ITEM(bb, remloc), LIST_ITEM(bb, remloc + 1),
> > +		(bb->num - remloc - 1) * bb->item_size);
> >  	bb->num--;
> >  	return 0;
> >  }
> > =20
> > +int ext2fs_u32_list_del(ext2_u32_list bb, __u32 blk)
> > +{
> > +	return sparse_list_del(bb, &blk);
> > +}
> > +
> > +void ext2fs_badblocks_list_del2(ext2_u32_list bb, blk64_t blk)
> > +{
> > +	sparse_list_del(bb, &blk);
> > +}
> > +
> >  void ext2fs_badblocks_list_del(ext2_u32_list bb, __u32 blk)
> >  {
> > -	ext2fs_u32_list_del(bb, blk);
> > +	ext2fs_badblocks_list_del(bb, blk);
> >  }
> > =20
> > -errcode_t ext2fs_u32_list_iterate_begin(ext2_u32_list bb,
> > -					ext2_u32_iterate *ret)
> > +static errcode_t sparse_list_iterate_begin(struct ext2_sparse_list=
 *bb,
> > +					   struct ext2_sparse_list_iterate **r)
> >  {
> > -	ext2_u32_iterate iter;
> > +	struct ext2_sparse_list_iterate *iter;
> >  	errcode_t		retval;
> > =20
> >  	EXT2_CHECK_MAGIC(bb, EXT2_ET_MAGIC_BADBLOCKS_LIST);
> > =20
> > -	retval =3D ext2fs_get_mem(sizeof(struct ext2_struct_u32_iterate),=
 &iter);
> > +	retval =3D ext2fs_get_mem(sizeof(struct ext2_sparse_list_iterate)=
,
> > +				&iter);
> >  	if (retval)
> >  		return retval;
> > =20
> >  	iter->magic =3D EXT2_ET_MAGIC_BADBLOCKS_ITERATE;
> >  	iter->bb =3D bb;
> >  	iter->ptr =3D 0;
> > -	*ret =3D iter;
> > +	*r =3D iter;
> >  	return 0;
> >  }
> > =20
> > +errcode_t ext2fs_u32_list_iterate_begin(ext2_u32_list bb,
> > +					ext2_u32_iterate *ret)
> > +{
> > +	return sparse_list_iterate_begin(bb, ret);
> > +}
> > +
> >  errcode_t ext2fs_badblocks_list_iterate_begin(ext2_badblocks_list =
bb,
> >  					      ext2_badblocks_iterate *ret)
> >  {
> > -	return ext2fs_u32_list_iterate_begin((ext2_u32_list) bb,
> > -					      (ext2_u32_iterate *) ret);
> > +	return sparse_list_iterate_begin((ext2_u32_list) bb,
> > +					 (ext2_u32_iterate *) ret);
> >  }
> > =20
> > =20
> > -int ext2fs_u32_list_iterate(ext2_u32_iterate iter, __u32 *blk)
> > +static int sparse_list_iterate(struct ext2_sparse_list_iterate *it=
er,
> > +			       void *item)
> >  {
> > -	ext2_u32_list	bb;
> > +	struct ext2_sparse_list	*bb;
> > =20
> >  	if (iter->magic !=3D EXT2_ET_MAGIC_BADBLOCKS_ITERATE)
> >  		return 0;
> > @@ -274,21 +373,35 @@ int ext2fs_u32_list_iterate(ext2_u32_iterate =
iter, __u32 *blk)
> >  		return 0;
> > =20
> >  	if (iter->ptr < bb->num) {
> > -		*blk =3D bb->list[iter->ptr++];
> > +		memcpy(item, LIST_ITEM(bb, iter->ptr++), bb->item_size);
> >  		return 1;
> >  	}
> > -	*blk =3D 0;
> > +	memset(item, 0, bb->item_size);
> >  	return 0;
> >  }
> > =20
> > +int ext2fs_u32_list_iterate(ext2_u32_iterate iter, __u32 *blk)
> > +{
> > +	return sparse_list_iterate(iter, blk);
> > +}
> > +
> > +int ext2fs_badblocks_list_iterate2(ext2_badblocks_iterate iter, bl=
k64_t *blk)
> > +{
> > +	return sparse_list_iterate(iter, blk);
> > +}
> > +
> >  int ext2fs_badblocks_list_iterate(ext2_badblocks_iterate iter, blk=
_t *blk)
> >  {
> > -	return ext2fs_u32_list_iterate((ext2_u32_iterate) iter,
> > -				       (__u32 *) blk);
> > +	blk64_t x;
> > +	int ret;
> > +
> > +	ret =3D ext2fs_badblocks_list_iterate2(iter, &x);
> > +	*blk =3D x;
> > +	return ret;
> >  }
> > =20
> > =20
> > -void ext2fs_u32_list_iterate_end(ext2_u32_iterate iter)
> > +static void sparse_list_iterate_end(struct ext2_sparse_list_iterat=
e *iter)
> >  {
> >  	if (!iter || (iter->magic !=3D EXT2_ET_MAGIC_BADBLOCKS_ITERATE))
> >  		return;
> > @@ -297,13 +410,19 @@ void ext2fs_u32_list_iterate_end(ext2_u32_ite=
rate iter)
> >  	ext2fs_free_mem(&iter);
> >  }
> > =20
> > +void ext2fs_u32_list_iterate_end(ext2_u32_iterate iter)
> > +{
> > +	sparse_list_iterate_end(iter);
> > +}
> > +
> >  void ext2fs_badblocks_list_iterate_end(ext2_badblocks_iterate iter=
)
> >  {
> > -	ext2fs_u32_list_iterate_end((ext2_u32_iterate) iter);
> > +	sparse_list_iterate_end(iter);
> >  }
> > =20
> > =20
> > -int ext2fs_u32_list_equal(ext2_u32_list bb1, ext2_u32_list bb2)
> > +static int sparse_list_equal(struct ext2_sparse_list *bb1,
> > +			     struct ext2_sparse_list *bb2)
> >  {
> >  	EXT2_CHECK_MAGIC(bb1, EXT2_ET_MAGIC_BADBLOCKS_LIST);
> >  	EXT2_CHECK_MAGIC(bb2, EXT2_ET_MAGIC_BADBLOCKS_LIST);
> > @@ -311,18 +430,46 @@ int ext2fs_u32_list_equal(ext2_u32_list bb1, =
ext2_u32_list bb2)
> >  	if (bb1->num !=3D bb2->num)
> >  		return 0;
> > =20
> > -	if (memcmp(bb1->list, bb2->list, bb1->num * sizeof(blk_t)) !=3D 0=
)
> > +	if (bb1->item_size !=3D bb2->item_size)
> > +		return 0;
> > +
> > +	if (memcmp(bb1->list, bb2->list, bb1->num * bb1->item_size) !=3D =
0)
> >  		return 0;
> >  	return 1;
> >  }
> > =20
> > +int ext2fs_u32_list_equal(ext2_u32_list bb1, ext2_u32_list bb2)
> > +{
> > +	return sparse_list_equal(bb1, bb2);
> > +}
> > +
> >  int ext2fs_badblocks_equal(ext2_badblocks_list bb1, ext2_badblocks=
_list bb2)
> >  {
> > -	return ext2fs_u32_list_equal((ext2_u32_list) bb1,
> > -				     (ext2_u32_list) bb2);
> > +	return sparse_list_equal(bb1, bb2);
> >  }
> > =20
> > -int ext2fs_u32_list_count(ext2_u32_list bb)
> > +static unsigned int sparse_list_count(struct ext2_sparse_list *bb)
> >  {
> > +	EXT2_CHECK_MAGIC(bb, EXT2_ET_MAGIC_BADBLOCKS_LIST);
> >  	return bb->num;
> >  }
> > +
> > +int ext2fs_u32_list_count(ext2_u32_list bb)
> > +{
> > +	return sparse_list_count(bb);
> > +}
> > +
> > +unsigned int ext2fs_badblocks_count(ext2_badblocks_list bb)
> > +{
> > +	return sparse_list_count(bb);
> > +}
> > +
> > +blk64_t ext2fs_badblocks_get(ext2_badblocks_list bb, unsigned int =
i)
> > +{
> > +	blk64_t x;
> > +
> > +	if (i < 0 || i >=3D bb->num)
> > +		return 0;
> > +	memcpy(&x, LIST_ITEM(bb, i), bb->item_size);
> > +	return x;
> > +}
> > diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> > index d5d8d03..b4ba421 100644
> > --- a/lib/ext2fs/ext2fs.h
> > +++ b/lib/ext2fs/ext2fs.h
> > @@ -111,15 +111,15 @@ typedef struct ext2fs_struct_generic_bitmap *=
ext2fs_block_bitmap;
> >   * Badblocks list definitions
> >   */
> > =20
> > -typedef struct ext2_struct_u32_list *ext2_badblocks_list;
> > -typedef struct ext2_struct_u32_iterate *ext2_badblocks_iterate;
> > +typedef struct ext2_sparse_list *ext2_badblocks_list;
> > +typedef struct ext2_sparse_list_iterate *ext2_badblocks_iterate;
> > =20
> > -typedef struct ext2_struct_u32_list *ext2_u32_list;
> > -typedef struct ext2_struct_u32_iterate *ext2_u32_iterate;
> > +typedef struct ext2_sparse_list *ext2_u32_list;
> > +typedef struct ext2_sparse_list_iterate *ext2_u32_iterate;
> > =20
> >  /* old */
> > -typedef struct ext2_struct_u32_list *badblocks_list;
> > -typedef struct ext2_struct_u32_iterate *badblocks_iterate;
> > +typedef struct ext2_sparse_list *badblocks_list;
> > +typedef struct ext2_sparse_list_iterate *badblocks_iterate;
> > =20
> >  #define BADBLOCKS_FLAG_DIRTY	1
> > =20
> > @@ -702,6 +702,8 @@ extern int ext2fs_u32_list_iterate(ext2_u32_ite=
rate iter, blk_t *blk);
> >  extern void ext2fs_u32_list_iterate_end(ext2_u32_iterate iter);
> >  extern errcode_t ext2fs_u32_copy(ext2_u32_list src, ext2_u32_list =
*dest);
> >  extern int ext2fs_u32_list_equal(ext2_u32_list bb1, ext2_u32_list =
bb2);
> > +extern int ext2fs_u32_list_del(ext2_u32_list bb, __u32 blk);
> > +extern int ext2fs_u32_list_count(ext2_u32_list bb);
> > =20
> >  extern errcode_t ext2fs_badblocks_list_create(ext2_badblocks_list =
*ret,
> >  					    int size);
> > @@ -709,7 +711,6 @@ extern errcode_t ext2fs_badblocks_list_add(ext2=
_badblocks_list bb,
> >  					   blk_t blk);
> >  extern int ext2fs_badblocks_list_test(ext2_badblocks_list bb,
> >  				    blk_t blk);
> > -extern int ext2fs_u32_list_del(ext2_u32_list bb, __u32 blk);
> >  extern void ext2fs_badblocks_list_del(ext2_u32_list bb, __u32 blk)=
;
> >  extern errcode_t
> >  	ext2fs_badblocks_list_iterate_begin(ext2_badblocks_list bb,
> > @@ -721,7 +722,13 @@ extern errcode_t ext2fs_badblocks_copy(ext2_ba=
dblocks_list src,
> >  				       ext2_badblocks_list *dest);
> >  extern int ext2fs_badblocks_equal(ext2_badblocks_list bb1,
> >  				  ext2_badblocks_list bb2);
> > -extern int ext2fs_u32_list_count(ext2_u32_list bb);
> > +extern errcode_t ext2fs_badblocks_list_add2(ext2_badblocks_list bb=
,
> > +					    blk64_t blk);
> > +extern int ext2fs_badblocks_list_test2(ext2_badblocks_list bb, blk=
64_t blk);
> > +extern void ext2fs_badblocks_list_del2(ext2_u32_list bb, blk64_t b=
lk);
> > +extern int ext2fs_badblocks_list_iterate2(ext2_badblocks_iterate i=
ter,
> > +					  blk64_t *blk);
> > +extern blk64_t ext2fs_badblocks_get(ext2_badblocks_list bb, unsign=
ed int i);
> > =20
> >  /* bb_compat */
> >  extern errcode_t badblocks_list_create(badblocks_list *ret, int si=
ze);
> > diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
> > index 80d2d0a..592527c 100644
> > --- a/lib/ext2fs/ext2fsP.h
> > +++ b/lib/ext2fs/ext2fsP.h
> > @@ -16,17 +16,18 @@
> >  /*
> >   * Badblocks list
> >   */
> > -struct ext2_struct_u32_list {
> > +struct ext2_sparse_list {
> >  	int	magic;
> > -	int	num;
> > -	int	size;
> > -	__u32	*list;
> > +	unsigned int	num;
> > +	unsigned int	size;
> > +	unsigned int	item_size;
> > +	void	*list;
> >  	int	badblocks_flags;
> >  };
> > =20
> > -struct ext2_struct_u32_iterate {
> > +struct ext2_sparse_list_iterate {
> >  	int			magic;
> > -	ext2_u32_list		bb;
> > +	struct ext2_sparse_list	*bb;
> >  	int			ptr;
> >  };
> > =20
> > diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
> > index 46c1c58..6579512 100644
> > --- a/lib/ext2fs/inode.c
> > +++ b/lib/ext2fs/inode.c
> > @@ -313,8 +313,8 @@ static errcode_t check_for_inode_bad_blocks(ext=
2_inode_scan scan,
> >  	 * is no longer the case.  If we run out of bad blocks, then
> >  	 * we don't need to do any more checking!
> >  	 */
> > -	while (blk > bb->list[scan->bad_block_ptr]) {
> > -		if (++scan->bad_block_ptr >=3D bb->num) {
> > +	while (blk > ext2fs_badblocks_get(bb, scan->bad_block_ptr)) {
> > +		if (++scan->bad_block_ptr >=3D ext2fs_badblocks_count(bb)) {
> >  			scan->scan_flags &=3D ~EXT2_SF_CHK_BADBLOCKS;
> >  			return 0;
> >  		}
> > @@ -328,10 +328,10 @@ static errcode_t check_for_inode_bad_blocks(e=
xt2_inode_scan scan,
> >  	 * expense of a huge expense of code complexity, and for an
> >  	 * uncommon case at that.)
> >  	 */
> > -	if (blk =3D=3D bb->list[scan->bad_block_ptr]) {
> > +	if (blk =3D=3D ext2fs_badblocks_get(bb, scan->bad_block_ptr)) {
> >  		scan->scan_flags |=3D EXT2_SF_BAD_INODE_BLK;
> >  		*num_blocks =3D 1;
> > -		if (++scan->bad_block_ptr >=3D bb->num)
> > +		if (++scan->bad_block_ptr >=3D ext2fs_badblocks_count(bb))
> >  			scan->scan_flags &=3D ~EXT2_SF_CHK_BADBLOCKS;
> >  		return 0;
> >  	}
> > @@ -342,8 +342,8 @@ static errcode_t check_for_inode_bad_blocks(ext=
2_inode_scan scan,
> >  	 * don't read in the bad block.  (Then the next block to read
> >  	 * will be the bad block, which is handled in the above case.)
> >  	 */
> > -	if ((blk + *num_blocks) > bb->list[scan->bad_block_ptr])
> > -		*num_blocks =3D (int) (bb->list[scan->bad_block_ptr] - blk);
> > +	if ((blk + *num_blocks) > ext2fs_badblocks_get(bb, scan->bad_bloc=
k_ptr))
> > +		*num_blocks =3D (int)(ext2fs_badblocks_get(bb, scan->bad_block_p=
tr) - blk);
> > =20
> >  	return 0;
> >  }
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
