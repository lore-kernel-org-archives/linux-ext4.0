From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [RFC] ext4: simplify the code a bit
Date: Thu, 6 Jun 2013 11:56:53 +1000
Message-ID: <20130606115653.a21b0c6a7bdbbbac23164b85@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Jun_2013_11_56_53_+1000_leyrFH.KCQfZY7NM"
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from haggis.pcug.org.au ([203.10.76.10]:33865 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590Ab3FFB5G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Jun 2013 21:57:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Signature=_Thu__6_Jun_2013_11_56_53_+1000_leyrFH.KCQfZY7NM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi guys,

I noticed the following warning in a linux-next build:

fs/ext4/inode.c: In function 'ext4_da_writepages':
fs/ext4/inode.c:2212:6: warning: 'err' may be used uninitialized in this fu=
nction [-Wmaybe-uninitialized]

In tracking this down, I followed the call chains and discovered that
io_submit_init_bio() only ever returned 0.  Switching that to return
void and following back up the chain lead to the following patch.  This
makes it far more obvious that by the end of the loop in
mpage_map_and_submit_extent(), err must be zero, which allows the final
removal of err2 and the check that caused the above warning.

This does remove the above warning and simplifies the code a bit, but may
be removing error infrastructure that may be used in the future.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/ext4/ext4.h    |  8 ++++----
 fs/ext4/inode.c   | 46 +++++++++++++---------------------------------
 fs/ext4/page-io.c | 35 ++++++-----------------------------
 3 files changed, 23 insertions(+), 66 deletions(-)

This is against today's ext4 tree dev branch.

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bd9890f..1341452 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2660,10 +2660,10 @@ extern void ext4_io_submit_init(struct ext4_io_subm=
it *io,
 extern void ext4_end_io_rsv_work(struct work_struct *work);
 extern void ext4_end_io_unrsv_work(struct work_struct *work);
 extern void ext4_io_submit(struct ext4_io_submit *io);
-extern int ext4_bio_write_page(struct ext4_io_submit *io,
-			       struct page *page,
-			       int len,
-			       struct writeback_control *wbc);
+extern void ext4_bio_write_page(struct ext4_io_submit *io,
+				struct page *page,
+				int len,
+				struct writeback_control *wbc);
=20
 /* mmp.c */
 extern int ext4_multi_mount_protect(struct super_block *, ext4_fsblk_t);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 442c5d2..80bc416 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1832,7 +1832,6 @@ out:
 static int ext4_writepage(struct page *page,
 			  struct writeback_control *wbc)
 {
-	int ret =3D 0;
 	loff_t size;
 	unsigned int len;
 	struct buffer_head *page_bufs =3D NULL;
@@ -1884,11 +1883,11 @@ static int ext4_writepage(struct page *page,
 		unlock_page(page);
 		return -ENOMEM;
 	}
-	ret =3D ext4_bio_write_page(&io_submit, page, len, wbc);
+	ext4_bio_write_page(&io_submit, page, len, wbc);
 	ext4_io_submit(&io_submit);
 	/* Drop io_end reference we got from init */
 	ext4_put_io_end_defer(io_submit.io_end);
-	return ret;
+	return 0;
 }
=20
 #define BH_FLAGS ((1 << BH_Unwritten) | (1 << BH_Delay))
@@ -1963,11 +1962,10 @@ static bool add_page_bufs_to_extent(struct mpage_da=
_data *mpd,
 	return true;
 }
=20
-static int mpage_submit_page(struct mpage_da_data *mpd, struct page *page)
+static void mpage_submit_page(struct mpage_da_data *mpd, struct page *page)
 {
 	int len;
 	loff_t size =3D i_size_read(mpd->inode);
-	int err;
=20
 	BUG_ON(page->index !=3D mpd->first_page);
 	if (page->index =3D=3D size >> PAGE_CACHE_SHIFT)
@@ -1975,12 +1973,9 @@ static int mpage_submit_page(struct mpage_da_data *m=
pd, struct page *page)
 	else
 		len =3D PAGE_CACHE_SIZE;
 	clear_page_dirty_for_io(page);
-	err =3D ext4_bio_write_page(&mpd->io_submit, page, len, mpd->wbc);
-	if (!err)
-		mpd->wbc->nr_to_write--;
+	ext4_bio_write_page(&mpd->io_submit, page, len, mpd->wbc);
+	mpd->wbc->nr_to_write--;
 	mpd->first_page++;
-
-	return err;
 }
=20
 /*
@@ -1997,7 +1992,7 @@ static int mpage_submit_page(struct mpage_da_data *mp=
d, struct page *page)
  * mapped, we update @map to the next extent in the last page that needs
  * mapping. Otherwise we submit the page for IO.
  */
-static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
+static void mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
 {
 	struct pagevec pvec;
 	int nr_pages, i;
@@ -2009,7 +2004,6 @@ static int mpage_map_and_submit_buffers(struct mpage_=
da_data *mpd)
 	pgoff_t start, end;
 	ext4_lblk_t lblk;
 	sector_t pblock;
-	int err;
=20
 	start =3D mpd->map.m_lblk >> bpp_bits;
 	end =3D (mpd->map.m_lblk + mpd->map.m_len - 1) >> bpp_bits;
@@ -2043,7 +2037,7 @@ static int mpage_map_and_submit_buffers(struct mpage_=
da_data *mpd)
 					add_page_bufs_to_extent(mpd, head, bh,
 								lblk);
 					pagevec_release(&pvec);
-					return 0;
+					return;
 				}
 				if (buffer_delay(bh)) {
 					clear_buffer_delay(bh);
@@ -2060,11 +2054,7 @@ static int mpage_map_and_submit_buffers(struct mpage=
_da_data *mpd)
 			 */
 			mpd->io_submit.io_end->size +=3D PAGE_CACHE_SIZE;
 			/* Page fully mapped - let IO run! */
-			err =3D mpage_submit_page(mpd, page);
-			if (err < 0) {
-				pagevec_release(&pvec);
-				return err;
-			}
+			mpage_submit_page(mpd, page);
 			start++;
 		}
 		pagevec_release(&pvec);
@@ -2072,7 +2062,6 @@ static int mpage_map_and_submit_buffers(struct mpage_=
da_data *mpd)
 	/* Extent fully mapped and matches with page boundary. We are done. */
 	mpd->map.m_len =3D 0;
 	mpd->map.m_flags =3D 0;
-	return 0;
 }
=20
 static int mpage_map_one_extent(handle_t *handle, struct mpage_da_data *mp=
d)
@@ -2191,9 +2180,7 @@ static int mpage_map_and_submit_extent(handle_t *hand=
le,
 		 * Update buffer state, submit mapped pages, and get us new
 		 * extent to map
 		 */
-		err =3D mpage_map_and_submit_buffers(mpd);
-		if (err < 0)
-			return err;
+		mpage_map_and_submit_buffers(mpd);
 	}
=20
 	/* Update on-disk size after IO is submitted */
@@ -2201,16 +2188,12 @@ static int mpage_map_and_submit_extent(handle_t *ha=
ndle,
 	if (disksize > i_size_read(inode))
 		disksize =3D i_size_read(inode);
 	if (disksize > EXT4_I(inode)->i_disksize) {
-		int err2;
-
 		ext4_update_i_disksize(inode, disksize);
-		err2 =3D ext4_mark_inode_dirty(handle, inode);
-		if (err2)
+		err =3D ext4_mark_inode_dirty(handle, inode);
+		if (err)
 			ext4_error(inode->i_sb,
 				   "Failed to mark inode %lu dirty",
 				   inode->i_ino);
-		if (!err)
-			err =3D err2;
 	}
 	return err;
 }
@@ -2321,11 +2304,8 @@ static int mpage_prepare_extent_to_map(struct mpage_=
da_data *mpd)
 			if (!add_page_bufs_to_extent(mpd, head, head, lblk))
 				goto out;
 			/* So far everything mapped? Submit the page for IO. */
-			if (mpd->map.m_len =3D=3D 0) {
-				err =3D mpage_submit_page(mpd, page);
-				if (err < 0)
-					goto out;
-			}
+			if (mpd->map.m_len =3D=3D 0)
+				mpage_submit_page(mpd, page);
=20
 			/*
 			 * Accumulated enough dirty pages? This doesn't apply
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index ce8c15a..530ccb0 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -365,7 +365,7 @@ void ext4_io_submit_init(struct ext4_io_submit *io,
 	io->io_end =3D NULL;
 }
=20
-static int io_submit_init_bio(struct ext4_io_submit *io,
+static void io_submit_init_bio(struct ext4_io_submit *io,
 			      struct buffer_head *bh)
 {
 	int nvecs =3D bio_get_nr_vecs(bh->b_bdev);
@@ -378,10 +378,9 @@ static int io_submit_init_bio(struct ext4_io_submit *i=
o,
 	bio->bi_private =3D ext4_get_io_end(io->io_end);
 	io->io_bio =3D bio;
 	io->io_next_block =3D bh->b_blocknr;
-	return 0;
 }
=20
-static int io_submit_add_bh(struct ext4_io_submit *io,
+static void io_submit_add_bh(struct ext4_io_submit *io,
 			    struct inode *inode,
 			    struct buffer_head *bh)
 {
@@ -391,19 +390,15 @@ static int io_submit_add_bh(struct ext4_io_submit *io,
 submit_and_retry:
 		ext4_io_submit(io);
 	}
-	if (io->io_bio =3D=3D NULL) {
-		ret =3D io_submit_init_bio(io, bh);
-		if (ret)
-			return ret;
-	}
+	if (io->io_bio =3D=3D NULL)
+		io_submit_init_bio(io, bh);
 	ret =3D bio_add_page(io->io_bio, bh->b_page, bh->b_size, bh_offset(bh));
 	if (ret !=3D bh->b_size)
 		goto submit_and_retry;
 	io->io_next_block++;
-	return 0;
 }
=20
-int ext4_bio_write_page(struct ext4_io_submit *io,
+void ext4_bio_write_page(struct ext4_io_submit *io,
 			struct page *page,
 			int len,
 			struct writeback_control *wbc)
@@ -411,7 +406,6 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 	struct inode *inode =3D page->mapping->host;
 	unsigned block_start, blocksize;
 	struct buffer_head *bh, *head;
-	int ret =3D 0;
 	int nr_submitted =3D 0;
=20
 	blocksize =3D 1 << inode->i_blkbits;
@@ -471,30 +465,13 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 	do {
 		if (!buffer_async_write(bh))
 			continue;
-		ret =3D io_submit_add_bh(io, inode, bh);
-		if (ret) {
-			/*
-			 * We only get here on ENOMEM.  Not much else
-			 * we can do but mark the page as dirty, and
-			 * better luck next time.
-			 */
-			redirty_page_for_writepage(wbc, page);
-			break;
-		}
+		io_submit_add_bh(io, inode, bh);
 		nr_submitted++;
 		clear_buffer_dirty(bh);
 	} while ((bh =3D bh->b_this_page) !=3D head);
=20
-	/* Error stopped previous loop? Clean up buffers... */
-	if (ret) {
-		do {
-			clear_buffer_async_write(bh);
-			bh =3D bh->b_this_page;
-		} while (bh !=3D head);
-	}
 	unlock_page(page);
 	/* Nothing submitted - we have to end page writeback */
 	if (!nr_submitted)
 		end_page_writeback(page);
-	return ret;
 }
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Jun_2013_11_56_53_+1000_leyrFH.KCQfZY7NM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRr+xpAAoJEECxmPOUX5FE6iUQAKMmp07Y7vpxxybOqxDNiN0Y
c006l70nN5gryhUnqwQTWgedwoBOavxas7Y3RBywXCH2j9iVYMxtdRB1h09m/v+P
4HouEBnmYRrNpvQSnGo42olBdfV9ChRdvcpZWQV+JP4jEPM1zDACM5BkoxDAblDc
CdQXKcx7uV8SX3zhnKjEpGrJ3df+ENOVCG8RyJL2K/OnMBQIrM8GR6UXfNE3feNe
1GkluPkaj5X03i2uhcE8GqhKRdA6IMEEboPaRoC1ndxkD238wxoggBKTJf0Frahx
zMFTHGt8fafwDFjkA8cI8UYnmP5B2uYYCKbt6RBUPw0JkkxkjQ5ABk/O+Z/NpWBF
Tq1Mu9JycajArgkTf3AA0KJaBPKnsltOPdB4WpXOSZyIUyklSkLv0gZz0WYs9G5g
g0B0Wx39tlPE3kkDPzLWoCE7+YlRiklnKLtXhdRWBN2KPM5xmGWkCuoqQLXqaCK4
xACsv/smDF+i1fHv6WbpvY2InkxM+6waad6ET3sWn6PgH8ZalKNO1T4plp2JLfDX
vPbCMka+vSbjr4GBpbN0PQRHPbmNYULWQKhqHHu41+p9eRfg0dfpzvR+J+DXVqcT
sqy8SFd0dFU3/Jg9d0GLEEDosluTOWOc/05MLIheUduY5yDsNJ6eJNi1UNuo5Pf4
4PkIk6q7QWnKN7qNAQtA
=/eDL
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Jun_2013_11_56_53_+1000_leyrFH.KCQfZY7NM--
