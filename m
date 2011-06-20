From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 7/8] btrfs: wait for direct I/O requests in truncate
Date: Mon, 20 Jun 2011 16:15:40 -0400
Message-ID: <20110620202031.775407797@bombadil.infradead.org>
References: <20110620201533.847236272@bombadil.infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com, jlbec@evilplan.org
To: viro@zeniv.linux.org.uk, tglx@linutronix.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline; filename=btrfs-call-dio_wait
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Wait for all direct I/O requests to finish before performing a truncate.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/btrfs/inode.c
===================================================================
--- linux-2.6.orig/fs/btrfs/inode.c	2011-06-11 12:58:46.615017504 +0200
+++ linux-2.6/fs/btrfs/inode.c	2011-06-11 12:59:23.218348984 +0200
@@ -3550,6 +3550,8 @@ static int btrfs_setsize(struct inode *i
 	loff_t oldsize = i_size_read(inode);
 	int ret;
 
+	inode_dio_wait(inode);
+
 	if (newsize == oldsize)
 		return 0;
 

