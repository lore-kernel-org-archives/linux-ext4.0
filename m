From: Leonard Michlmayr <leonard.michlmayr@gmail.com>
Subject: [PATCH 2.6.32.7] ext4: number of blocks for fiemap
Date: Sat, 13 Feb 2010 00:20:01 +0100
Message-ID: <1266016801.27587.13.camel@michlmayr>
References: <1257360161.22057.16.camel@michlmayr>
	 <372739E0-41AD-4DEC-9187-1396BE5894BD@sun.com>
	 <1257371050.13852.28.camel@michlmayr> <4B701793.9010005@canonical.com>
	 <1266000136.4310.36.camel@michlmayr>
	 <4D0CB743-94B6-49AB-B838-BCDD2EC8C3ED@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org Mailinglist"
	<linux-kernel@vger.kernel.org>, 474597@bugs.launchpad.net
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:42441 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab0BLXUH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Feb 2010 18:20:07 -0500
In-Reply-To: <4D0CB743-94B6-49AB-B838-BCDD2EC8C3ED@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-02-12, at 14:49 -0700 Andreas Dilger wrote:
> If "last_blk" is only used in this one place, please put the  
> declaration inside the scope of the "else" clause.  Looks fine  
> otherwise.

Done. Thanks.

---

Problem:
fs/ext4/extents.c:ext4_fiemap rounds the length of the requested range
down to blocksize. This is not the true number of blocks that cover the
requested region. This problem is especially impressive if the user
requests only the first byte of a file: not a single extent will be
reported.

Solution:
Calculate the last byte of the region and round to blocksize. Then get
the number of blocks by subtracting last_blk - start_blk and adding 1
for the first block. (The variable last_blk is introduced just for
easier reading.) This patch will fix this.

Signed-off-by: Leonard Michlmayr <leonard.michlmayr@gmail.com>

diff -rup linux-2.6.32.7/fs/ext4/extents.c linux-2.6.32.7-lm/fs/ext4/extents.c
--- linux-2.6.32.7/fs/ext4/extents.c	2010-01-29 00:06:20.000000000 +0100
+++ linux-2.6.32.7-lm/fs/ext4/extents.c	2010-02-13 00:01:56.000000000 +0100
@@ -3725,8 +3725,11 @@ int ext4_fiemap(struct inode *inode, str
 	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR) {
 		error = ext4_xattr_fiemap(inode, fieinfo);
 	} else {
+		ext4_lblk_t last_blk;
 		start_blk = start >> inode->i_sb->s_blocksize_bits;
-		len_blks = len >> inode->i_sb->s_blocksize_bits;
+		/* the last byte in the range is (start + len - 1) */
+		last_blk = (start + len - 1) >> inode->i_sb->s_blocksize_bits;
+		len_blks = last_blk - start_blk + 1;
 
 		/*
 		 * Walk the extent tree gathering extent information.


