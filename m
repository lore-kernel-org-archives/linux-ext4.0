From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/2] ext3: make ext3 mount default to barrier=1
Date: Mon, 11 Jul 2011 14:25:59 -0400
Message-ID: <20110711182558.GB12099@infradead.org>
References: <20110711182532.GA12099@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jeffm@suse.com, chris.mason@oracle.com, jack@suse.cz,
	reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: viro@zeniv.linux.org.uk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47035
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757032Ab1GKS0D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jul 2011 14:26:03 -0400
Content-Disposition: inline
In-Reply-To: <20110711182532.GA12099@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Chris Mason <mason@suse.com>

This patch turns on barriers by default for ext3.  mount -o barrier=0
will turn them off.

Acked-by: Jeff Mahoney <jeffm@suse.com>

Index: linux-2.6/fs/ext3/super.c
===================================================================
--- linux-2.6.orig/fs/ext3/super.c	2011-06-30 21:19:37.389544975 +0200
+++ linux-2.6/fs/ext3/super.c	2011-07-02 13:56:51.877784292 +0200
@@ -1718,6 +1718,8 @@ static int ext3_fill_super (struct super
 	sbi->s_resuid = le16_to_cpu(es->s_def_resuid);
 	sbi->s_resgid = le16_to_cpu(es->s_def_resgid);
 
+	/* enable barriers by default */
+	set_opt(sbi->s_mount_opt, BARRIER);
 	set_opt(sbi->s_mount_opt, RESERVATION);
 
 	if (!parse_options ((char *) data, sb, &journal_inum, &journal_devnum,
