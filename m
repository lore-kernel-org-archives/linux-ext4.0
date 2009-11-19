From: scjody@sun.com
Subject: [patch 2/5] [md] Add syncraid buffer & bio flags
Date: Thu, 19 Nov 2009 16:22:43 -0500
Message-ID: <20091119212358.875539573@sun.com>
References: <20091119212241.283629302@sun.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; NAME=''md-add-bio-syncraid.patch
Content-Transfer-Encoding: 7BIT
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <adilger@sun.com>
To: linux-ext4@vger.kernel.org, linux-raid@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:35463 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639AbZKSVXz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Nov 2009 16:23:55 -0500
Content-disposition: inline; filename=md-add-bio-syncraid.patch
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Adds the BIO_SYNCRAID bio flag and the syncraid buffer flag.  These
are used to request a resync of the stripe containing the data being read
or written.

Signed-off-by: Jody McIntyre <scjody@sun.com>

Index: linux-2.6.18-128.7.1/drivers/md/raid5.c
===================================================================
--- linux-2.6.18-128.7.1.orig/drivers/md/raid5.c
+++ linux-2.6.18-128.7.1/drivers/md/raid5.c
@@ -1704,7 +1704,8 @@ static void handle_stripe5(struct stripe
 		}
 	}
 	if (failed > 1 && syncing) {
-		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
+		if (!test_bit(STRIPE_RESYNC_REQ, &sh->state))
+			md_done_sync(conf->mddev, STRIPE_SECTORS, 0);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 		syncing = 0;
 	}
@@ -1941,7 +1942,8 @@ static void handle_stripe5(struct stripe
 		}
 	}
 	if (syncing && locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
-		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
+		if (!test_bit(STRIPE_RESYNC_REQ, &sh->state))
+			md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 	}
 
@@ -2289,7 +2291,8 @@ static void handle_stripe6(struct stripe
 		}
 	}
 	if (failed > 2 && syncing) {
-		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
+		if (!test_bit(STRIPE_RESYNC_REQ, &sh->state))
+			md_done_sync(conf->mddev, STRIPE_SECTORS, 0);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 		syncing = 0;
 	}
@@ -2589,6 +2592,8 @@ static void handle_stripe6(struct stripe
 
 	if (syncing && locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
+		if (!test_bit(STRIPE_RESYNC_REQ, &sh->state))
+			md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 	}
 
@@ -2880,6 +2885,9 @@ static int make_request(request_queue_t 
 	else
 		atomic_inc(&conf->reads_in);
 
+	PRINTK("make_request on %llu, %s\n", bi->bi_sector,
+	       ((rw == WRITE) ? "write" : "read"));
+
 	logical_sector = bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	last_sector = bi->bi_sector + (bi->bi_size>>9);
 	bi->bi_next = NULL;
@@ -3006,6 +3014,19 @@ retry:
 			r_sector += sectors_per_chunk;
 		}
 		if (sh) {
+			if (bio_flagged(bi, BIO_SYNCRAID)) {
+				if (test_bit(STRIPE_RESYNC_REQ, &sh->state)) {
+					PRINTK("SYNCRAID on %llu, already "
+					       "resynced\n", bi->bi_sector);
+				} else {
+					PRINTK("SYNCRAID on %llu, "
+					       "resyncing\n", bi->bi_sector);
+					set_bit(STRIPE_SYNCING, &sh->state);
+					set_bit(STRIPE_RESYNC_REQ, &sh->state);
+					clear_bit(STRIPE_INSYNC, &sh->state);
+				}
+			}
+
 			handle_stripe(sh, NULL, bios);
 			release_stripe(sh);
 			sh = NULL;
@@ -3234,6 +3255,7 @@ static inline sector_t sync_request(mdde
 	spin_lock(&sh->lock);
 	set_bit(STRIPE_SYNCING, &sh->state);
 	clear_bit(STRIPE_INSYNC, &sh->state);
+	clear_bit(STRIPE_RESYNC_REQ, &sh->state);
 	spin_unlock(&sh->lock);
 
 	handle_stripe(sh, NULL, NULL);
Index: linux-2.6.18-128.7.1/fs/buffer.c
===================================================================
--- linux-2.6.18-128.7.1.orig/fs/buffer.c
+++ linux-2.6.18-128.7.1/fs/buffer.c
@@ -2861,6 +2861,8 @@ int submit_bh(int rw, struct buffer_head
 
 	if (buffer_fs_raidsync(bh))
 		set_bit(BIO_FS_RAIDSYNC, &bio->bi_flags);
+	if (buffer_syncraid(bh))
+		set_bit(BIO_SYNCRAID, &bio->bi_flags);
 
 	bio_get(bio);
 	submit_bio(rw, bio);
Index: linux-2.6.18-128.7.1/include/linux/bio.h
===================================================================
--- linux-2.6.18-128.7.1.orig/include/linux/bio.h
+++ linux-2.6.18-128.7.1/include/linux/bio.h
@@ -125,6 +125,7 @@ struct bio {
 #define BIO_USER_MAPPED 6	/* contains user pages */
 #define BIO_EOPNOTSUPP	7	/* not supported */
 #define BIO_FS_RAIDSYNC	8	/* fs is responsible for RAID parity resync */
+#define BIO_SYNCRAID	9	/* perform RAID parity resync now */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
Index: linux-2.6.18-128.7.1/include/linux/buffer_head.h
===================================================================
--- linux-2.6.18-128.7.1.orig/include/linux/buffer_head.h
+++ linux-2.6.18-128.7.1/include/linux/buffer_head.h
@@ -33,6 +33,7 @@ enum bh_state_bits {
 	BH_Ordered,	/* ordered write */
 	BH_Eopnotsupp,	/* operation not supported (barrier) */
 	BH_FS_Raidsync,	/* FS is responsible for RAID parity resyncs */
+	BH_SyncRAID,	/* Perform RAID parity resync now */
 	BH_PrivateStart,/* not a state bit, but the first bit available
 			 * for private allocation by other entities
 			 */
@@ -126,6 +127,7 @@ BUFFER_FNS(Ordered, ordered)
 BUFFER_FNS(Eopnotsupp, eopnotsupp)
 BUFFER_FNS(Unwritten, unwritten)
 BUFFER_FNS(FS_Raidsync, fs_raidsync)
+BUFFER_FNS(SyncRAID, syncraid)
 
 #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
 #define touch_buffer(bh)	mark_page_accessed(bh->b_page)
Index: linux-2.6.18-128.7.1/include/linux/raid/raid5.h
===================================================================
--- linux-2.6.18-128.7.1.orig/include/linux/raid/raid5.h
+++ linux-2.6.18-128.7.1/include/linux/raid/raid5.h
@@ -180,6 +180,8 @@ struct stripe_head {
 #define	STRIPE_EXPANDING	9
 #define	STRIPE_EXPAND_SOURCE	10
 #define	STRIPE_EXPAND_READY	11
+#define	STRIPE_RESYNC_REQ	12
+
 /*
  * Plugging:
  *

-- 
