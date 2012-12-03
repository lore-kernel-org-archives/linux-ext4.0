From: kbuild test robot <fengguang.wu@intel.com>
Subject: [ext4:dev 54/60] fs/ext4/xattr.c:999:5: sparse: symbol
 'ext4_xattr_ibody_set' was not declared. Should it be static?
Date: Mon, 03 Dec 2012 13:53:43 +0800
Message-ID: <50bc3e67.aUvaPpYYPGZetZCY%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_50bc3e67.1s2/R4iwQzojG97W/V4yRHX3DmkY8QT4hZzqP6WYq913TW+e"
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Tao Ma <boyu.mt@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55660 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab2LCFyU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Dec 2012 00:54:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.

--=_50bc3e67.1s2/R4iwQzojG97W/V4yRHX3DmkY8QT4hZzqP6WYq913TW+e
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
head:   e9f49e454264c1cdd793552bfeb44f337508201b
commit: 00002fa945a62d74ace3da9da0bc8660500e4c8b [54/60] ext4: evict inline data out if we need to strore xattr in inode


sparse warnings:

fs/ext4/xattr.c:127:13: sparse: incorrect type in assignment (different base types)
fs/ext4/xattr.c:127:13:    expected unsigned int [unsigned] [usertype] old
fs/ext4/xattr.c:127:13:    got restricted __le32 [usertype] h_checksum
fs/ext4/xattr.c:129:18: sparse: incorrect type in assignment (different base types)
fs/ext4/xattr.c:129:18:    expected unsigned long long [unsigned] [usertype] block_nr
fs/ext4/xattr.c:129:18:    got restricted __le64 [usertype] <noident>
fs/ext4/xattr.c:135:25: sparse: incorrect type in assignment (different base types)
fs/ext4/xattr.c:135:25:    expected restricted __le32 [usertype] h_checksum
fs/ext4/xattr.c:135:25:    got unsigned int [unsigned] [usertype] old
+ fs/ext4/xattr.c:999:5: sparse: symbol 'ext4_xattr_ibody_set' was not declared. Should it be static?

Please consider folding the attached diff :-)

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation

--=_50bc3e67.1s2/R4iwQzojG97W/V4yRHX3DmkY8QT4hZzqP6WYq913TW+e
Content-Type: text/x-diff;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="make-it-static-00002fa.diff"

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 18e565d..bbf4852 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -996,7 +996,7 @@ int ext4_xattr_ibody_inline_set(handle_t *handle, struct inode *inode,
 	return 0;
 }
 
-int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
+static int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 			 struct ext4_xattr_info *i,
 			 struct ext4_xattr_ibody_find *is)
 {

--=_50bc3e67.1s2/R4iwQzojG97W/V4yRHX3DmkY8QT4hZzqP6WYq913TW+e--
