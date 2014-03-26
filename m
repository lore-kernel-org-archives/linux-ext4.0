From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH] ext4: FIBMAP ioctl causes BUG_ON due to handle
 EXT_MAX_BLOCKS
Date: Wed, 26 Mar 2014 05:20:54 +0000
Message-ID: <C26C67884C4B7A48980D574635594864E16DD8@BPXM20GP.gisp.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:63729 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaCZHAL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Mar 2014 03:00:11 -0400
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id s2Q5QIR2014393
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 26 Mar 2014 14:26:18 +0900 (JST)
Content-Language: ja-JP
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we try to get 2^32-1 block of the file which has the extent
(ee_block=2^32-2, ee_len=1) with FIBMAP ioctl, it causes BUG_ON
in ext4_ext_put_gap_in_cache().

To avoid the problem, ext4_bmap() needs to check the file logical block number.
ext4_ext_put_gap_in_cache() called via ext4_get_block() cannot handle 2^32-1
because the maximum file logical block number is 2^32-2.
However, the block number in ext4_bmap() which is gotten from user space
is passed to ext4_get_block() directly.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 fs/ext4/inode.c |    6 ++++++
 1 file changed, 6 insertions(+)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 61d49ff..aef3501 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2873,6 +2873,12 @@ static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 	if (ext4_has_inline_data(inode))
 		return 0;
 
+	/*
+	 * We cannot get physical block number over EXT_MAX_BLOCKS
+	 */
+	if ((ext4_lblk_t)block >= EXT_MAX_BLOCKS)
+		return 0;
+
 	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) &&
 			test_opt(inode->i_sb, DELALLOC)) {
 		/*

