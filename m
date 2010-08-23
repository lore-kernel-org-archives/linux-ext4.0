From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH]: icount: Replace the icount list by a two-level tree
Date: Mon, 23 Aug 2010 17:53:00 +0200
Message-ID: <20100823155259.GD16603@skl-net.de>
References: <20100818140422.GL27457@skl-net.de> <EDA85D20-C083-41FE-B561-8014C496C4CB@dilger.ca> <20100819130123.GU16603@skl-net.de> <ABE19F5B-74C8-47E9-B359-D3FB2C137087@dilger.ca> <20100820143943.GZ16603@skl-net.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ioqcch2Htvy99P9q"
Cc: Ted Ts'o <tytso@mit.edu>,
	Marcus Hartmann <marcus.hartmann@tuebingen.mpg.de>,
	linux-ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:57335 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182Ab0HWPxT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Aug 2010 11:53:19 -0400
Content-Disposition: inline
In-Reply-To: <20100820143943.GZ16603@skl-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Ioqcch2Htvy99P9q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 20, 2010 at 04:39:43PM +0200, Andre Noll wrote:
> > One simple way that this could be fixed fairly easily (which would
> > presumably allow swap to be used) is to have a 2-level (or N-level)
> > tree of allocations for the icount->list array, with the first level
> > being just an array of pointers to individually-allocated arrays of
> > ext2_icount_el.  The sub-arrays can be some reasonable size (maybe
> > 64kB), which would give us a fan-out of 64k / 8 =3D 8k, and if the
> > top-level array is (re-)allocated in chunks of, say 64 pointers, the
> > number of times the top-level array needs to be reallocated would only
> > be every 64 * 8192 insertions, and only the pointer array needs to be
> > reallocated/copied.
>=20
> Seems to be simple enough. If Ted does not object to this approach
> in general, I'll try to send some patches next week.  Probably I will
> need some further advise though.

Here is a patch against the next branch that implements your idea. It
compiles without (additional) warnings on Linux/i386 and Linux/x86_64
even with "make gcc-wall", and checkpatch.pl is also happy with
it. Moreover, it passes the test suite though this does probably not
prove much because the icount tests insert less than 8192 inodes, so
only one sub-array is created by these tests. I also ran the patched
e2fsck against a 100M toy file system containing many directories
and hard links and it seems to work fine.

Most importantly, this version no longer exits due to failing memory
allocations while checking my problematic file system on the 32bit
box. Instead memory and swap usage increase steadily as new icount
sub-arrays are being allocated. Therefore I think the patch has real
benefits and is worth considering for inclusion. Please review.

Note: Although the two-level tree approach avoids large reallocations,
for insertions it is as inefficient as the old sorted list method
because both the old and the new code move large amounts of memory
around in insert_icount_el(). This could be avoided by replacing the
sorted lists by a hash table, with open addressing and maybe double
hashing to deal with collisions. But for this to work out we'd need an
upper bound on the number of inodes to be inserted. So I like Ted's
proposal to store some information in the superblock that allows to
allocate a suitably sized structure up front.

Thanks
Andre
---
commit 0e115a361efe70b26a4f5daa10a3a7afda145e2c
Author: Andre Noll <maan@systemlinux.org>
Date:   Mon Aug 23 00:12:22 2010 +0200

    icount: Replace the icount list by a two-level tree.
   =20
    Currently, inode counts are stored in an array of struct ext2_icount_el
    which is resized on demand.  This array may become very large,
    eventually causing the reallocation to fail due to memory or address
    space limits, especially on 32 bit systems.
   =20
    This patch changes the way the ext2_icount_el structures are stored to
    a two-level tree with the first level being just an array of pointers
    to individually-allocated sub-arrays of ext2_icount_el, each of which
    stores up to 8192 entries. If all sub-arrays are full, only the small
    first-level array has to be resized while a new second-level array
    is allocated from scratch. This avoids reallocations of large amounts
    of memory and allows to use swap efficiently.
   =20
    Several simple accessor functions are introduced to keep the changes
    to users of the icount API minimal. However, the fact that new icounts
    are now allocated in chunks of 8192 entries breaks the expectations
    of the icount test programs. So tests/progs/test_data/expect.icount
    had to be patched as well to reflect this change.
   =20
    Signed-off-by: Andre Noll <maan@systemlinux.org>

diff --git a/lib/ext2fs/icount.c b/lib/ext2fs/icount.c
index 43cc53e..aad4866 100644
--- a/lib/ext2fs/icount.c
+++ b/lib/ext2fs/icount.c
@@ -31,14 +31,14 @@
  * Also, e2fsck tends to load the icount data sequentially.
  *
  * So, we use an inode bitmap to indicate which inodes have a count of
- * one, and then use a sorted list to store the counts for inodes
+ * one, and then use a sorted tree to store the counts for inodes
  * which are greater than one.
  *
  * We also use an optional bitmap to indicate which inodes are already
- * in the sorted list, to speed up the use of this abstraction by
+ * in the sorted tree, to speed up the use of this abstraction by
  * e2fsck's pass 2.  Pass 2 increments inode counts as it finds them,
- * so this extra bitmap avoids searching the sorted list to see if a
- * particular inode is on the sorted list already.
+ * so this extra bitmap avoids searching the sorted tree to see if a
+ * particular inode is on the sorted tree already.
  */
=20
 struct ext2_icount_el {
@@ -54,7 +54,7 @@ struct ext2_icount {
 	ext2_ino_t		size;
 	ext2_ino_t		num_inodes;
 	ext2_ino_t		cursor;
-	struct ext2_icount_el	*list;
+	struct ext2_icount_el	**tree;
 	struct ext2_icount_el	*last_lookup;
 	char			*tdb_fn;
 	TDB_CONTEXT		*tdb;
@@ -69,14 +69,82 @@ struct ext2_icount {
  */
 #define icount_16_xlate(x) (((x) > 65500) ? 65500 : (x))
=20
+/*
+ * Number of elements in one icount group. This should be a power of two
+ * so that modulo operations are fast.
+ */
+#define ICOUNT_FANOUT (65536 / sizeof(struct ext2_icount_el))
+
+static inline ext2_ino_t num_icount_groups(ext2_icount_t icount)
+{
+	return (icount->size + ICOUNT_FANOUT - 1) / ICOUNT_FANOUT;
+}
+
+static inline void get_icount_indices(ext2_ino_t num, ext2_ino_t *group_nu=
m,
+				      ext2_ino_t *group_index)
+{
+	*group_num =3D num / ICOUNT_FANOUT;
+	*group_index =3D num % ICOUNT_FANOUT;
+}
+
+static inline struct ext2_icount_el *get_icount_entry(ext2_icount_t icount,
+						      ext2_ino_t num)
+{
+	ext2_ino_t gnum, gidx;
+
+	get_icount_indices(num, &gnum, &gidx);
+	return icount->tree[gnum] + gidx;
+}
+
+static inline ext2_ino_t get_icount_ino(ext2_icount_t icount, ext2_ino_t n=
um)
+{
+	struct ext2_icount_el *el =3D get_icount_entry(icount, num);
+
+	return el->ino;
+}
+
+static inline void set_icount_ino(ext2_icount_t icount, ext2_ino_t num,
+				  ext2_ino_t ino)
+{
+	struct ext2_icount_el *el =3D get_icount_entry(icount, num);
+
+	el->ino =3D ino;
+}
+
+static inline struct ext2_icount_el *set_icount_entry(ext2_icount_t icount,
+						      ext2_ino_t num,
+						      ext2_ino_t ino,
+						      __u32 count)
+{
+	struct ext2_icount_el *el =3D get_icount_entry(icount, num);
+
+	el->ino =3D ino;
+	el->count =3D count;
+	return el;
+}
+
+static inline errcode_t alloc_icount_group(struct ext2_icount_el **ptr)
+{
+	errcode_t retval =3D ext2fs_get_array(ICOUNT_FANOUT,
+					    sizeof(struct ext2_icount_el), ptr);
+	if (retval)
+		return retval;
+	memset(*ptr, 0, ICOUNT_FANOUT * sizeof(struct ext2_icount_el));
+	return 0;
+}
+
 void ext2fs_free_icount(ext2_icount_t icount)
 {
 	if (!icount)
 		return;
=20
 	icount->magic =3D 0;
-	if (icount->list)
-		ext2fs_free_mem(&icount->list);
+	if (icount->tree) {
+		ext2_ino_t i, num_groups =3D num_icount_groups(icount);
+		for (i =3D 0; i < num_groups; i++)
+			ext2fs_free_mem(&icount->tree[i]);
+		ext2fs_free_mem(&icount->tree);
+	}
 	if (icount->single)
 		ext2fs_free_inode_bitmap(icount->single);
 	if (icount->multiple)
@@ -214,8 +282,7 @@ errcode_t ext2fs_create_icount2(ext2_filsys fs, int fla=
gs, unsigned int size,
 {
 	ext2_icount_t	icount;
 	errcode_t	retval;
-	size_t		bytes;
-	ext2_ino_t	i;
+	ext2_ino_t	i, num_groups;
=20
 	if (hint) {
 		EXT2_CHECK_MAGIC(hint, EXT2_ET_MAGIC_ICOUNT);
@@ -240,29 +307,34 @@ errcode_t ext2fs_create_icount2(ext2_filsys fs, int f=
lags, unsigned int size,
 			goto errout;
 		icount->size +=3D fs->super->s_inodes_count / 50;
 	}
-
-	bytes =3D (size_t) (icount->size * sizeof(struct ext2_icount_el));
-#if 0
-	printf("Icount allocated %u entries, %d bytes.\n",
-	       icount->size, bytes);
-#endif
-	retval =3D ext2fs_get_array(icount->size, sizeof(struct ext2_icount_el),
-			 &icount->list);
+	num_groups =3D num_icount_groups(icount);
+	/* always allocate full icount groups */
+	icount->size =3D num_groups * ICOUNT_FANOUT;
+	retval =3D ext2fs_get_array(num_groups, sizeof(struct ext2_icount_el *),
+				  &icount->tree);
 	if (retval)
 		goto errout;
-	memset(icount->list, 0, bytes);
-
+	memset(icount->tree, 0, num_groups * sizeof(struct ext2_icount_el *));
+	for (i =3D 0; i < num_groups; i++) {
+		retval =3D alloc_icount_group(icount->tree + i);
+		if (retval)
+			goto errout;
+	}
+#if 0
+	printf("Icount allocated %zu entries, %d groups\n",
+	       icount->size, num_groups);
+#endif
 	icount->count =3D 0;
 	icount->cursor =3D 0;
=20
 	/*
-	 * Populate the sorted list with those entries which were
+	 * Populate the sorted tree with those entries which were
 	 * found in the hint icount (since those are ones which will
-	 * likely need to be in the sorted list this time around).
+	 * likely need to be in the sorted tree this time around).
 	 */
 	if (hint) {
-		for (i=3D0; i < hint->count; i++)
-			icount->list[i].ino =3D hint->list[i].ino;
+		for (i =3D 0; i < hint->count; i++)
+			set_icount_ino(icount, i, get_icount_ino(hint, i));
 		icount->count =3D hint->count;
 	}
=20
@@ -282,59 +354,65 @@ errcode_t ext2fs_create_icount(ext2_filsys fs, int fl=
ags,
 }
=20
 /*
- * insert_icount_el() --- Insert a new entry into the sorted list at a
+ * insert_icount_el() --- Insert a new entry into the sorted tree at a
  * 	specified position.
  */
 static struct ext2_icount_el *insert_icount_el(ext2_icount_t icount,
 					    ext2_ino_t ino, int pos)
 {
-	struct ext2_icount_el 	*el;
 	errcode_t		retval;
-	ext2_ino_t		new_size =3D 0;
-	int			num;
+	ext2_ino_t		num_groups =3D num_icount_groups(icount);
+	ext2_ino_t		i, gnum, gidx;
=20
 	if (icount->last_lookup && icount->last_lookup->ino =3D=3D ino)
 		return icount->last_lookup;
=20
 	if (icount->count >=3D icount->size) {
-		if (icount->count) {
-			new_size =3D icount->list[(unsigned)icount->count-1].ino;
-			new_size =3D (ext2_ino_t) (icount->count *
-				((float) icount->num_inodes / new_size));
-		}
-		if (new_size < (icount->size + 100))
-			new_size =3D icount->size + 100;
-#if 0
-		printf("Reallocating icount %u entries...\n", new_size);
-#endif
-		retval =3D ext2fs_resize_mem((size_t) icount->size *
-					   sizeof(struct ext2_icount_el),
-					   (size_t) new_size *
-					   sizeof(struct ext2_icount_el),
-					   &icount->list);
+		retval =3D ext2fs_resize_mem(num_groups *
+					   sizeof(struct ext2_icount_el *),
+					   (num_groups + 1) *
+					   sizeof(struct ext2_icount_el *),
+					   &icount->tree);
 		if (retval)
-			return 0;
-		icount->size =3D new_size;
+			return NULL;
+		retval =3D alloc_icount_group(icount->tree + num_groups);
+		if (retval)
+			return NULL;
+		icount->size +=3D ICOUNT_FANOUT;
+		num_groups++;
 	}
-	num =3D (int) icount->count - pos;
-	if (num < 0)
-		return 0;	/* should never happen */
-	if (num) {
-		memmove(&icount->list[pos+1], &icount->list[pos],
-			sizeof(struct ext2_icount_el) * num);
+	if ((ext2_ino_t)pos =3D=3D icount->count) /* Just insert the new element =
*/
+		goto success;
+	/* Shift entries by one. */
+	get_icount_indices(pos, &gnum, &gidx);
+	for (i =3D num_groups - 1; i !=3D (ext2_ino_t)-1 && i >=3D gnum; i--) {
+		struct ext2_icount_el *g =3D icount->tree[i];
+		const size_t s =3D sizeof(struct ext2_icount_el);
+
+		/*
+		 * If g is not the last group, move the last element
+		 * of this group to the beginning of the next group.
+		 */
+		if (i < num_groups - 1)
+			icount->tree[i + 1][0] =3D g[ICOUNT_FANOUT - 1];
+
+		if (i > gnum) /* shift the whole group */
+			memmove(g + 1, g, (ICOUNT_FANOUT - 1) * s);
+		else if (gidx < ICOUNT_FANOUT - 1)
+			/* shift starts at entry gidx */
+			memmove(g + gidx + 1, g + gidx,
+				(ICOUNT_FANOUT - gidx - 1) * s);
 	}
+success:
+	icount->last_lookup =3D set_icount_entry(icount, pos, ino, 0);
 	icount->count++;
-	el =3D &icount->list[pos];
-	el->count =3D 0;
-	el->ino =3D ino;
-	icount->last_lookup =3D el;
-	return el;
+	return icount->last_lookup;
 }
=20
 /*
  * get_icount_el() --- given an inode number, try to find icount
- * 	information in the sorted list.  If the create flag is set,
- * 	and we can't find an entry, create one in the sorted list.
+ *     information in the sorted tree. If the create flag is set,
+ *     and we can't find an entry, create one in the sorted tree.
  */
 static struct ext2_icount_el *get_icount_el(ext2_icount_t icount,
 					    ext2_ino_t ino, int create)
@@ -343,11 +421,11 @@ static struct ext2_icount_el *get_icount_el(ext2_icou=
nt_t icount,
 	int	low, high, mid;
 	ext2_ino_t	lowval, highval;
=20
-	if (!icount || !icount->list)
+	if (!icount || !icount->tree)
 		return 0;
=20
 	if (create && ((icount->count =3D=3D 0) ||
-		       (ino > icount->list[(unsigned)icount->count-1].ino))) {
+		       (ino > get_icount_ino(icount, icount->count - 1)))) {
 		return insert_icount_el(icount, ino, (unsigned) icount->count);
 	}
 	if (icount->count =3D=3D 0)
@@ -355,8 +433,8 @@ static struct ext2_icount_el *get_icount_el(ext2_icount=
_t icount,
=20
 	if (icount->cursor >=3D icount->count)
 		icount->cursor =3D 0;
-	if (ino =3D=3D icount->list[icount->cursor].ino)
-		return &icount->list[icount->cursor++];
+	if (ino =3D=3D get_icount_ino(icount, icount->cursor))
+		return get_icount_entry(icount, icount->cursor++);
 #if 0
 	printf("Non-cursor get_icount_el: %u\n", ino);
 #endif
@@ -370,8 +448,8 @@ static struct ext2_icount_el *get_icount_el(ext2_icount=
_t icount,
 			mid =3D low;
 		else {
 			/* Interpolate for efficiency */
-			lowval =3D icount->list[low].ino;
-			highval =3D icount->list[high].ino;
+			lowval =3D get_icount_ino(icount, low);
+			highval =3D get_icount_ino(icount, high);
=20
 			if (ino < lowval)
 				range =3D 0;
@@ -388,11 +466,11 @@ static struct ext2_icount_el *get_icount_el(ext2_icou=
nt_t icount,
 			mid =3D low + ((int) (range * (high-low)));
 		}
 #endif
-		if (ino =3D=3D icount->list[mid].ino) {
+		if (ino =3D=3D get_icount_ino(icount, mid)) {
 			icount->cursor =3D mid+1;
-			return &icount->list[mid];
+			return get_icount_entry(icount, mid);
 		}
-		if (ino < icount->list[mid].ino)
+		if (ino < get_icount_ino(icount, mid))
 			high =3D mid-1;
 		else
 			low =3D mid+1;
@@ -480,10 +558,10 @@ errcode_t ext2fs_icount_validate(ext2_icount_t icount=
, FILE *out)
 		return EXT2_ET_INVALID_ARGUMENT;
 	}
 	for (i=3D1; i < icount->count; i++) {
-		if (icount->list[i-1].ino >=3D icount->list[i].ino) {
-			fprintf(out, "%s: list[%d].ino=3D%u, list[%d].ino=3D%u\n",
-				bad, i-1, icount->list[i-1].ino,
-				i, icount->list[i].ino);
+		if (get_icount_ino(icount, i-1) >=3D get_icount_ino(icount, i)) {
+			fprintf(out, "%s: tree[%d].ino=3D%u, tree[%d].ino=3D%u\n",
+				bad, i-1, get_icount_ino(icount, i - 1),
+				i, get_icount_ino(icount, i));
 			ret =3D EXT2_ET_INVALID_ARGUMENT;
 		}
 	}
@@ -525,7 +603,7 @@ errcode_t ext2fs_icount_increment(ext2_icount_t icount,=
 ext2_ino_t ino,
 	if (ext2fs_test_inode_bitmap2(icount->single, ino)) {
 		/*
 		 * If the existing count is 1, then we know there is
-		 * no entry in the list.
+		 * no entry in the tree.
 		 */
 		if (set_inode_count(icount, ino, 2))
 			return EXT2_ET_NO_MEMORY;
@@ -535,7 +613,7 @@ errcode_t ext2fs_icount_increment(ext2_icount_t icount,=
 ext2_ino_t ino,
 		/*
 		 * The count is either zero or greater than 1; if the
 		 * inode is set in icount->multiple, then there should
-		 * be an entry in the list, so we need to fix it.
+		 * be an entry in the tree, so we need to fix it.
 		 */
 		if (ext2fs_test_inode_bitmap2(icount->multiple, ino)) {
 			get_inode_count(icount, ino, &curr_value);
@@ -555,7 +633,7 @@ errcode_t ext2fs_icount_increment(ext2_icount_t icount,=
 ext2_ino_t ino,
 	} else {
 		/*
 		 * The count is either zero or greater than 1; try to
-		 * find an entry in the list to determine which.
+		 * find an entry in the tree to determine which.
 		 */
 		get_inode_count(icount, ino, &curr_value);
 		curr_value++;
diff --git a/tests/progs/test_data/expect.icount b/tests/progs/test_data/ex=
pect.icount
index b58a373..c36f7de 100644
--- a/tests/progs/test_data/expect.icount
+++ b/tests/progs/test_data/expect.icount
@@ -56,7 +56,7 @@ test_icount: store 20000 0
 test_icount: fetch 20000
 Count is 0
 test_icount: get_size
-Size of icount is: 5
+Size of icount is: 8192
 test_icount: decrement 2
 decrement: Invalid argument passed to ext2 library while calling ext2fs_ic=
ount_decrement
 test_icount: increment 2
@@ -145,7 +145,7 @@ Count is now 0
 test_icount: decrement 5
 decrement: Invalid argument passed to ext2 library while calling ext2fs_ic=
ount_decrement
 test_icount: get_size
-Size of icount is: 105
+Size of icount is: 8192
 test_icount: validate
 Icount structure successfully validated
 test_icount: store 10 10
@@ -188,6 +188,6 @@ test_icount: dump
 95: 95
 100: 100
 test_icount: get_size
-Size of icount is: 105
+Size of icount is: 8192
 test_icount: validate
 Icount structure successfully validated
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--Ioqcch2Htvy99P9q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFMcplbWto1QDEAkw8RAgspAJ91rPGrZMuAYWoq4cOoIozVXeNxkgCeOEr1
d5cOS2EGk4ytYiOg+ySmrk0=
=igoz
-----END PGP SIGNATURE-----

--Ioqcch2Htvy99P9q--
