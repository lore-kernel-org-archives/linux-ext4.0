From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/9] fs: simplify handling of zero sized reads in __blockdev_direct_IO
Date: Fri, 24 Jun 2011 14:29:42 -0400
Message-ID: <20110624183207.346483338@bombadil.infradead.org>
References: <20110624182939.401012221@bombadil.infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com, jlbec@evilplan.org
To: viro@zeniv.linux.org.uk, tglx@linutronix.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56816
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191Ab1FXScO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Jun 2011 14:32:14 -0400
Content-Disposition: inline; filename=fs-cleanup-zero-size-dio-reads
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Reject zero sized reads as soon as we know our I/O length, and don't
borther with locks or allocations that might have to be cleaned up
otherwise.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/direct-io.c
===================================================================
--- linux-2.6.orig/fs/direct-io.c	2011-06-24 14:30:22.488402525 +0200
+++ linux-2.6/fs/direct-io.c	2011-06-24 15:13:16.711605526 +0200
@@ -1200,6 +1200,10 @@ __blockdev_direct_IO(int rw, struct kioc
 		}
 	}
 
+	/* watch out for a 0 len io from a tricksy fs */
+	if (rw == READ && end == offset)
+		return 0;
+
 	dio = kmalloc(sizeof(*dio), GFP_KERNEL);
 	retval = -ENOMEM;
 	if (!dio)
@@ -1213,8 +1217,7 @@ __blockdev_direct_IO(int rw, struct kioc
 
 	dio->flags = flags;
 	if (dio->flags & DIO_LOCKING) {
-		/* watch out for a 0 len io from a tricksy fs */
-		if (rw == READ && end > offset) {
+		if (rw == READ) {
 			struct address_space *mapping =
 					iocb->ki_filp->f_mapping;
 

