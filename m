From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH] ext4: Ensure zeroout blocks have no dirty metadata
Date: Fri, 11 Dec 2009 14:01:48 -0800
Message-ID: <6601abe90912111401t2749bc1en3d8e5b8f81787897@mail.gmail.com>
References: <6601abe90912100928v747671dat489aeee5dabf2c03@mail.gmail.com>
	 <8352E6B3-4561-40D7-AEC0-A4119A685F46@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:4015 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761488AbZLKWBq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Dec 2009 17:01:46 -0500
Received: from wpaz13.hot.corp.google.com (wpaz13.hot.corp.google.com [172.24.198.77])
	by smtp-out.google.com with ESMTP id nBBM1o7I014405
	for <linux-ext4@vger.kernel.org>; Fri, 11 Dec 2009 22:01:51 GMT
Received: from qw-out-1920.google.com (qwc5.prod.google.com [10.241.193.133])
	by wpaz13.hot.corp.google.com with ESMTP id nBBM1mrc020254
	for <linux-ext4@vger.kernel.org>; Fri, 11 Dec 2009 14:01:48 -0800
Received: by qw-out-1920.google.com with SMTP id 5so263961qwc.32
        for <linux-ext4@vger.kernel.org>; Fri, 11 Dec 2009 14:01:48 -0800 (PST)
In-Reply-To: <8352E6B3-4561-40D7-AEC0-A4119A685F46@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> IIRC, during the discussion of this problem, Ted pointed out that thi=
s can
> only happen if the filesystem is running in no-journal mode. =A0Other=
wise,
> there are shadow allocation bitmaps that prevent metadata blocks from=
 being
> reallocated until the transaction that released them has committed.
>
> In that case, it makes sense to only do this extra work if the filesy=
stem is
> running in no-journal mode.

Good point, Andreas.  I changed this to send in the handle to
ext4_ext_zeroout().

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

This fixes a bug with no journal being used, in which new blocks return=
ed
from an extent created with ext4_ext_zeroout() can have dirty metadata =
still
associated with them.

	Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---

This is for the problem I reported on 23 Nov ("Bug in extent zeroout: b=
locks
not marked as new").  I'm not seeing the corruption with this fix that =
I was
seeing without it.

diff -uprN orig/fs/ext4/extents.c new/fs/ext4/extents.c
--- orig/fs/ext4/extents.c	2009-12-09 15:09:25.000000000 -0800
+++ new/fs/ext4/extents.c	2009-12-11 13:56:11.000000000 -0800
@@ -2421,7 +2421,8 @@ static void bi_complete(struct bio *bio,
 }

 /* FIXME!! we need to try to merge to left or right after zero-out  */
-static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *e=
x)
+static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *e=
x,
+				handle_t *handle)
 {
 	int ret =3D -EIO;
 	struct bio *bio;
@@ -2474,9 +2475,28 @@ static int ext4_ext_zeroout(struct inode
 		submit_bio(WRITE, bio);
 		wait_for_completion(&event);

-		if (test_bit(BIO_UPTODATE, &bio->bi_flags))
+		if (test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+
 			ret =3D 0;
-		else {
+
+			/* On success, if there is no journal through which
+			 * metadata is committed, we need to insure all
+			 * metadata associated with each of these blocks is
+			 * unmapped. */
+			if (!ext4_handle_valid(handle)) {
+				sector_t block =3D ee_pblock;
+
+				done =3D 0;
+				while (done < len) {
+					unmap_underlying_metadata(inode->i_sb->
+							                s_bdev,
+								  block);
+
+					done++;
+					block++;
+				}
+			}
+		} else {
 			ret =3D -EIO;
 			break;
 		}
@@ -2532,7 +2552,7 @@ static int ext4_ext_convert_to_initializ
 		goto out;
 	/* If extent has less than 2*EXT4_EXT_ZERO_LEN zerout directly */
 	if (ee_len <=3D 2*EXT4_EXT_ZERO_LEN) {
-		err =3D  ext4_ext_zeroout(inode, &orig_ex);
+		err =3D  ext4_ext_zeroout(inode, &orig_ex, handle);
 		if (err)
 			goto fix_extent_len;
 		/* update the extent length and mark as initialized */
@@ -2583,7 +2603,8 @@ static int ext4_ext_convert_to_initializ
 			err =3D ext4_ext_insert_extent(handle, inode, path,
 							ex3, 0);
 			if (err =3D=3D -ENOSPC) {
-				err =3D  ext4_ext_zeroout(inode, &orig_ex);
+				err =3D  ext4_ext_zeroout(inode, &orig_ex,
+							handle);
 				if (err)
 					goto fix_extent_len;
 				ex->ee_block =3D orig_ex.ee_block;
@@ -2603,7 +2624,7 @@ static int ext4_ext_convert_to_initializ
 			 * implies that we can leak some junk data to user
 			 * space.
 			 */
-			err =3D  ext4_ext_zeroout(inode, ex3);
+			err =3D  ext4_ext_zeroout(inode, ex3, handle);
 			if (err) {
 				/*
 				 * We should actually mark the
@@ -2639,7 +2660,7 @@ static int ext4_ext_convert_to_initializ
 		ext4_ext_mark_uninitialized(ex3);
 		err =3D ext4_ext_insert_extent(handle, inode, path, ex3, 0);
 		if (err =3D=3D -ENOSPC) {
-			err =3D  ext4_ext_zeroout(inode, &orig_ex);
+			err =3D  ext4_ext_zeroout(inode, &orig_ex, handle);
 			if (err)
 				goto fix_extent_len;
 			/* update the extent length and mark as initialized */
@@ -2688,7 +2709,7 @@ static int ext4_ext_convert_to_initializ
 		 */
 		if (le16_to_cpu(orig_ex.ee_len) <=3D EXT4_EXT_ZERO_LEN &&
 							iblock !=3D ee_block) {
-			err =3D  ext4_ext_zeroout(inode, &orig_ex);
+			err =3D  ext4_ext_zeroout(inode, &orig_ex, handle);
 			if (err)
 				goto fix_extent_len;
 			/* update the extent length and mark as initialized */
@@ -2757,7 +2778,7 @@ static int ext4_ext_convert_to_initializ
 insert:
 	err =3D ext4_ext_insert_extent(handle, inode, path, &newex, 0);
 	if (err =3D=3D -ENOSPC) {
-		err =3D  ext4_ext_zeroout(inode, &orig_ex);
+		err =3D  ext4_ext_zeroout(inode, &orig_ex, handle);
 		if (err)
 			goto fix_extent_len;
 		/* update the extent length and mark as initialized */
@@ -2871,7 +2892,7 @@ static int ext4_split_unwritten_extents(
 		ext4_ext_mark_uninitialized(ex3);
 		err =3D ext4_ext_insert_extent(handle, inode, path, ex3, flags);
 		if (err =3D=3D -ENOSPC) {
-			err =3D  ext4_ext_zeroout(inode, &orig_ex);
+			err =3D  ext4_ext_zeroout(inode, &orig_ex, handle);
 			if (err)
 				goto fix_extent_len;
 			/* update the extent length and mark as initialized */
@@ -2942,7 +2963,7 @@ static int ext4_split_unwritten_extents(
 insert:
 	err =3D ext4_ext_insert_extent(handle, inode, path, &newex, flags);
 	if (err =3D=3D -ENOSPC) {
-		err =3D  ext4_ext_zeroout(inode, &orig_ex);
+		err =3D  ext4_ext_zeroout(inode, &orig_ex, handle);
 		if (err)
 			goto fix_extent_len;
 		/* update the extent length and mark as initialized */
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
