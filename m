From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] reiserfs: make reiserfs default to barrier=flush
Date: Mon, 11 Jul 2011 14:26:19 -0400
Message-ID: <20110711182619.GC12099@infradead.org>
References: <20110711182532.GA12099@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jeffm@suse.com, chris.mason@oracle.com, jack@suse.cz,
	reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: viro@zeniv.linux.org.uk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47042
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758035Ab1GKS0X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jul 2011 14:26:23 -0400
Content-Disposition: inline
In-Reply-To: <20110711182532.GA12099@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Change the default reiserfs mount option to barrier=flush.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

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
