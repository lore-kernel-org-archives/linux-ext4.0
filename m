From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/8] fs: simpler handling of zero sized reads in __blockdev_direct_IO
Date: Mon, 20 Jun 2011 16:15:36 -0400
Message-ID: <20110620202030.966337660@bombadil.infradead.org>
References: <20110620201533.847236272@bombadil.infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com, jlbec@evilplan.org
To: viro@zeniv.linux.org.uk, tglx@linutronix.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline; filename=fs-cleanup-zero-size-dio-reads
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Reject zero sized reads as soon as we know our I/O length, and don't
borther with locks or allocations that might have to be cleaned up
otherwise.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/direct-io.c
===================================================================
--- linux-2.6.orig/fs/direct-io.c	2011-06-11 12:10:10.205165161 +0200
+++ linux-2.6/fs/direct-io.c	2011-06-11 12:12:49.161823781 +0200
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
 

