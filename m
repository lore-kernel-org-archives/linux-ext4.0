From: Alex Tomas <alex@clusterfs.com>
Subject: [RFC] booked-page-flag.patch
Date: Fri, 22 Dec 2006 23:23:55 +0300
Message-ID: <m33b77wug4.fsf@bzzz.home.net>
References: <m37iwjwumf.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: <linux-kernel@vger.kernel.org>, alex@clusterfs.com
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752742AbWLVVJt@vger.kernel.org>
To: linux-ext4@vger.kernel.org
In-Reply-To: <m37iwjwumf.fsf@bzzz.home.net> (Alex Tomas's message of "Fri\, 22
	Dec 2006 23\:20\:08 +0300")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Index: linux-2.6.20-rc1/include/linux/page-flags.h
===================================================================
--- linux-2.6.20-rc1.orig/include/linux/page-flags.h	2006-12-14 04:14:23.000000000 +0300
+++ linux-2.6.20-rc1/include/linux/page-flags.h	2006-12-22 20:05:31.000000000 +0300
@@ -90,6 +90,7 @@
 #define PG_reclaim		17	/* To be reclaimed asap */
 #define PG_nosave_free		18	/* Used for system suspend/resume */
 #define PG_buddy		19	/* Page is free, on buddy lists */
+#define PG_booked		20	/* Has blocks reserved on-disk */
 
 
 #if (BITS_PER_LONG > 32)
@@ -230,6 +231,10 @@ static inline void SetPageUptodate(struc
 #define SetPageMappedToDisk(page) set_bit(PG_mappedtodisk, &(page)->flags)
 #define ClearPageMappedToDisk(page) clear_bit(PG_mappedtodisk, &(page)->flags)
 
+#define PageBooked(page)	test_bit(PG_booked, &(page)->flags)
+#define SetPageBooked(page)	set_bit(PG_booked, &(page)->flags)
+#define ClearPageBooked(page)	clear_bit(PG_booked, &(page)->flags)
+
 #define PageReclaim(page)	test_bit(PG_reclaim, &(page)->flags)
 #define SetPageReclaim(page)	set_bit(PG_reclaim, &(page)->flags)
 #define ClearPageReclaim(page)	clear_bit(PG_reclaim, &(page)->flags)
