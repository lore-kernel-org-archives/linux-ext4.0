From: scjody@sun.com
Subject: [patch 1/5] [md] Add fs_raidsync buffer & bio flags
Date: Thu, 19 Nov 2009 16:22:42 -0500
Message-ID: <20091119212355.980768235@sun.com>
References: <20091119212241.283629302@sun.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; NAME=''md-add-fs-raidsync.patch
Content-Transfer-Encoding: 7BIT
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <adilger@sun.com>
To: linux-ext4@vger.kernel.org, linux-raid@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:53932 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638AbZKSVXz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Nov 2009 16:23:55 -0500
Content-disposition: inline; filename=md-add-fs-raidsync.patch
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Adds the BIO_FS_RAIDSYNC bio flag and the fs_raidsync buffer flag.  These
are used to inform md that the filesystem takes responsibility for
resynchronizing parity information after a system crash.

When this flag is set on a raid4/5/6 device, the write will not be recorded
in the bitmap.

Signed-off-by: Jody McIntyre <scjody@sun.com>

Index: linux-2.6.18-128.7.1/drivers/md/raid5.c
===================================================================
--- linux-2.6.18-128.7.1.orig/drivers/md/raid5.c
+++ linux-2.6.18-128.7.1/drivers/md/raid5.c
@@ -1465,7 +1465,8 @@ static int add_stripe_bio(struct stripe_
 		(unsigned long long)bi->bi_sector,
 		(unsigned long long)sh->sector, dd_idx);
 
-	if (conf->mddev->bitmap && firstwrite) {
+	if (conf->mddev->bitmap && firstwrite &&
+				!bio_flagged(bi, BIO_FS_RAIDSYNC)) {
 		bitmap_startwrite(conf->mddev->bitmap, sh->sector,
 				  STRIPE_SECTORS, 0);
 		sh->bm_seq = conf->seq_flush+1;
@@ -1643,7 +1644,11 @@ static void handle_stripe5(struct stripe
 			/* fail all writes first */
 			bi = sh->dev[i].towrite;
 			sh->dev[i].towrite = NULL;
-			if (bi) { to_write--; bitmap_end = 1; }
+			if (bi) {
+				to_write--;
+				if (!bio_flagged(bi, BIO_FS_RAIDSYNC))
+					bitmap_end = 1;
+			}
 
 			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 				wake_up(&conf->wait_for_overlap);
@@ -1661,7 +1666,8 @@ static void handle_stripe5(struct stripe
 			/* and fail all 'written' */
 			bi = sh->dev[i].written;
 			sh->dev[i].written = NULL;
-			if (bi) bitmap_end = 1;
+			if (bi && !bio_flagged(bi, BIO_FS_RAIDSYNC))
+				bitmap_end = 1;
 			while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS) {
 				struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
 				clear_bit(BIO_UPTODATE, &bi->bi_flags);
@@ -1736,11 +1742,14 @@ static void handle_stripe5(struct stripe
 					    md_write_end(conf->mddev);
 					    wbi->bi_next = return_bi;
 					    return_bi = wbi;
+					    if (!bio_flagged(wbi,
+							     BIO_FS_RAIDSYNC))
+						    bitmap_end = 1;
 				    }
 				    wbi = wbi2;
 			    }
-			    if (dev->towrite == NULL)
-				    bitmap_end = 1;
+			    if (dev->towrite != NULL)
+				    bitmap_end = 0;
 			    spin_unlock_irq(&conf->device_lock);
 			    if (bitmap_end)
 				    bitmap_endwrite(conf->mddev->bitmap, sh->sector,
@@ -2220,7 +2229,11 @@ static void handle_stripe6(struct stripe
 			/* fail all writes first */
 			bi = sh->dev[i].towrite;
 			sh->dev[i].towrite = NULL;
-			if (bi) { to_write--; bitmap_end = 1; }
+			if (bi) {
+				to_write--;
+				if (!bio_flagged(bi, BIO_FS_RAIDSYNC))
+					bitmap_end = 1;
+			}
 
 			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 				wake_up(&conf->wait_for_overlap);
@@ -2238,7 +2251,8 @@ static void handle_stripe6(struct stripe
 			/* and fail all 'written' */
 			bi = sh->dev[i].written;
 			sh->dev[i].written = NULL;
-			if (bi) bitmap_end = 1;
+			if (bi && !bio_flagged(bi, BIO_FS_RAIDSYNC))
+				bitmap_end = 1;
 			while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS) {
 				struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
 				clear_bit(BIO_UPTODATE, &bi->bi_flags);
@@ -2324,11 +2338,14 @@ static void handle_stripe6(struct stripe
 							md_write_end(conf->mddev);
 							wbi->bi_next = return_bi;
 							return_bi = wbi;
+							if (!bio_flagged(wbi,
+							       BIO_FS_RAIDSYNC))
+								bitmap_end = 1;
 						}
 						wbi = wbi2;
 					}
-					if (dev->towrite == NULL)
-						bitmap_end = 1;
+					if (dev->towrite != NULL)
+						bitmap_end = 0;
 					spin_unlock_irq(&conf->device_lock);
 					if (bitmap_end)
 						bitmap_endwrite(conf->mddev->bitmap, sh->sector,
Index: linux-2.6.18-128.7.1/fs/buffer.c
===================================================================
--- linux-2.6.18-128.7.1.orig/fs/buffer.c
+++ linux-2.6.18-128.7.1/fs/buffer.c
@@ -2859,6 +2859,9 @@ int submit_bh(int rw, struct buffer_head
 	bio->bi_end_io = end_bio_bh_io_sync;
 	bio->bi_private = bh;
 
+	if (buffer_fs_raidsync(bh))
+		set_bit(BIO_FS_RAIDSYNC, &bio->bi_flags);
+
 	bio_get(bio);
 	submit_bio(rw, bio);
 
Index: linux-2.6.18-128.7.1/include/linux/bio.h
===================================================================
--- linux-2.6.18-128.7.1.orig/include/linux/bio.h
+++ linux-2.6.18-128.7.1/include/linux/bio.h
@@ -124,6 +124,7 @@ struct bio {
 #define BIO_BOUNCED	5	/* bio is a bounce bio */
 #define BIO_USER_MAPPED 6	/* contains user pages */
 #define BIO_EOPNOTSUPP	7	/* not supported */
+#define BIO_FS_RAIDSYNC	8	/* fs is responsible for RAID parity resync */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
Index: linux-2.6.18-128.7.1/include/linux/buffer_head.h
===================================================================
--- linux-2.6.18-128.7.1.orig/include/linux/buffer_head.h
+++ linux-2.6.18-128.7.1/include/linux/buffer_head.h
@@ -32,6 +32,7 @@ enum bh_state_bits {
 	BH_Write_EIO,	/* I/O error on write */
 	BH_Ordered,	/* ordered write */
 	BH_Eopnotsupp,	/* operation not supported (barrier) */
+	BH_FS_Raidsync,	/* FS is responsible for RAID parity resyncs */
 	BH_PrivateStart,/* not a state bit, but the first bit available
 			 * for private allocation by other entities
 			 */
@@ -124,6 +125,7 @@ BUFFER_FNS(Write_EIO, write_io_error)
 BUFFER_FNS(Ordered, ordered)
 BUFFER_FNS(Eopnotsupp, eopnotsupp)
 BUFFER_FNS(Unwritten, unwritten)
+BUFFER_FNS(FS_Raidsync, fs_raidsync)
 
 #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
 #define touch_buffer(bh)	mark_page_accessed(bh->b_page)

-- 
