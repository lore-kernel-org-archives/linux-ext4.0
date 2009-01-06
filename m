From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] block: Add Kconfig help which notes that ext4 needs
	CONFIG_LSF
Date: Tue, 6 Jan 2009 15:17:47 -0500
Message-ID: <20090106201747.GA12578@mit.edu>
References: <1231262490-15594-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <jens.axboe@oracle.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53406 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbZAFURt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Jan 2009 15:17:49 -0500
Content-Disposition: inline
In-Reply-To: <1231262490-15594-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I had to use a slightly different patch for 2.6.28-git7...

block: Add Kconfig help which notes that ext4 needs CONFIG_LBD

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>
diff --git a/block/Kconfig b/block/Kconfig
index ac0956f..0cbb3b8 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -36,6 +36,12 @@ config LBD
 	  This option also enables support for single files larger than
 	  2TB.
 
+	  The ext4 filesystem requires that this feature be enabled in
+	  order to support filesystems that have the huge_file feature
+	  enabled.    Otherwise, it will refuse to mount any filesystems
+	  that use the huge_file feature, which is enabled by default
+	  by mke2fs.ext4.   The GFS2 filesystem also requires this feature.
+
 	  If unsure, say N.
 
 config BLK_DEV_IO_TRACE
