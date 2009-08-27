From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH]ext4: Enable mount ext4 with AGGRESSIVE_TEST
Date: Thu, 27 Aug 2009 13:54:39 +0900
Message-ID: <4A96118F.5040707@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: "tytso@mit.edu >> Theodore Tso" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:34119 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbZH0EzD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Aug 2009 00:55:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When the AGGRESSIVE_TEST is enabled,
the maximum extent count of inode becomes '3' in ext4_ext_space_root(),
but __ext4_ext_check() which is called via ext4_fill_super()
checks eh_max is larger '4', therefore we always get -EIO and can not mount ext4.
The patch fix this issue.

Aug 26 15:43:50 bsd086 kernel: [   96.070277] EXT4-fs error (device sda8): ext4_ext_check_inode: bad header/extent in inode #8: too large eh_max - magic f30a, entries 1, max 4(3), depth 0(0)
Aug 26 15:43:50 bsd086 kernel: [   96.070526] EXT4-fs (sda8): no journal found


Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 extents.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
--- linux-2.6.31-rc4-A/fs/ext4/extents.c        2009-08-26 14:59:47.000000000 +0900
+++ linux-2.6.31-rc4-B/fs/ext4/extents.c        2009-08-26 15:45:31.000000000 +0900
@@ -263,8 +263,8 @@ static int ext4_ext_space_root(struct in
        size -= sizeof(struct ext4_extent_header);
        size /= sizeof(struct ext4_extent);
 #ifdef AGGRESSIVE_TEST
-       if (size > 3)
-               size = 3;
+       if (size > 4)
+               size = 4;
 #endif
        return size;
 }

