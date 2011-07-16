From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] reiserfs: make reiserfs default to barrier=flush
Date: Sat, 16 Jul 2011 16:47:00 -0400
Message-ID: <20110716204700.GB16882@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jeffm@suse.com, chris.mason@oracle.com, jack@suse.cz,
	reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: viro@zeniv.linux.org.uk
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Change the default reiserfs mount option to barrier=flush.  Based on a patch
from Jeff Mahoney in the SuSE tree.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/reiserfs/super.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/super.c	2011-07-02 13:57:08.061117424 +0200
+++ linux-2.6/fs/reiserfs/super.c	2011-07-02 13:59:26.197782375 +0200
@@ -1643,6 +1643,7 @@ static int reiserfs_fill_super(struct su
 	/* Set default values for options: non-aggressive tails, RO on errors */
 	REISERFS_SB(s)->s_mount_opt |= (1 << REISERFS_SMALLTAIL);
 	REISERFS_SB(s)->s_mount_opt |= (1 << REISERFS_ERROR_RO);
+	REISERFS_SB(s)->s_mount_opt |= (1 << REISERFS_BARRIER_FLUSH);
 	/* no preallocation minimum, be smart in
 	   reiserfs_file_write instead */
 	REISERFS_SB(s)->s_alloc_options.preallocmin = 0;
