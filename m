From: kbuild test robot <fengguang.wu@intel.com>
Subject: [ext4:dev 45/57] fs/ext4/inline.c:1025:6: sparse: symbol
 'ext4_get_inline_xattr_pos' was not declared. Should it be static?
Date: Mon, 03 Dec 2012 13:20:34 +0800
Message-ID: <50bc36a2.lAcRnrpMvOgx7DsQ%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_50bc36a2.U6wo+FXELd89yglBND/l9vxbv5D7mxddsHgTgGSaOMsefv70"
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Tao Ma <boyu.mt@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:36000 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab2LCFVK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Dec 2012 00:21:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.

--=_50bc36a2.U6wo+FXELd89yglBND/l9vxbv5D7mxddsHgTgGSaOMsefv70
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
head:   b0c30cdb0d3fcf5a04de4a46fceba767cf8be022
commit: 83cd81a477199a3f0c01a609069423d5c6e9805d [45/57] ext4: let add_dir_entry handle inline data properly


sparse warnings:

+ fs/ext4/inline.c:1025:6: sparse: symbol 'ext4_get_inline_xattr_pos' was not declared. Should it be static?

Please consider folding the attached diff :-)

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation

--=_50bc36a2.U6wo+FXELd89yglBND/l9vxbv5D7mxddsHgTgGSaOMsefv70
Content-Type: text/x-diff;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="make-it-static-83cd81a.diff"

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 89d6a25..a39b632 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1022,7 +1022,7 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 	return 1;
 }
 
-void *ext4_get_inline_xattr_pos(struct inode *inode, struct ext4_iloc *iloc)
+static void *ext4_get_inline_xattr_pos(struct inode *inode, struct ext4_iloc *iloc)
 {
 	struct ext4_xattr_entry *entry;
 	struct ext4_xattr_ibody_header *header;

--=_50bc36a2.U6wo+FXELd89yglBND/l9vxbv5D7mxddsHgTgGSaOMsefv70--
