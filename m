From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch 2/2] ext4: silence a format string false positive
Date: Fri, 14 Aug 2015 12:47:32 +0300
Message-ID: <20150814094732.GB14179@mwanda>
References: <3FC4DED5-76F2-45DE-8E01-8796850CB120@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51248 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbbHNJrt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Aug 2015 05:47:49 -0400
Content-Disposition: inline
In-Reply-To: <3FC4DED5-76F2-45DE-8E01-8796850CB120@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Static checkers complain that the format string should be "%s".  It does
not make a difference for the current code.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 0880ec9..8b72634 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -115,7 +115,7 @@ warn_exit:
 void __dump_mmp_msg(struct super_block *sb, struct mmp_struct *mmp,
 		    const char *function, unsigned int line, const char *msg)
 {
-	__ext4_warning(sb, function, line, msg);
+	__ext4_warning(sb, function, line, "%s", msg);
 	__ext4_warning(sb, function, line,
 		       "MMP failure info: last update time: %llu, last update "
 		       "node: %s, last update device: %s\n",
