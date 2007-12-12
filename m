From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH -mm] ext3: remove unused code from ext3_find_entry()
Date: Wed, 12 Dec 2007 22:14:03 +0100
Message-ID: <200712122214.03879.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
To: sct@redhat.com, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1645 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbXLLVNF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Dec 2007 16:13:05 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

	This patch removes unused code from ext3_find_entry().
Compile and boot tested.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 fs/ext3/namei.c | 67174 -> 67077 (-97 bytes)
 fs/ext3/namei.o | 157944 -> 157896 (-48 bytes)

 fs/ext3/namei.c |    4 ----
 1 file changed, 4 deletions(-)

--- linux-2.6.24-rc4-mm1-a/fs/ext3/namei.c	2007-12-06 09:27:07.000000000 +0100
+++ linux-2.6.24-rc4-mm1-b/fs/ext3/namei.c	2007-12-12 21:14:07.000000000 +0100
@@ -860,14 +860,10 @@ static struct buffer_head * ext3_find_en
 	int nblocks, i, err;
 	struct inode *dir = dentry->d_parent->d_inode;
 	int namelen;
-	const u8 *name;
-	unsigned blocksize;

 	*res_dir = NULL;
 	sb = dir->i_sb;
-	blocksize = sb->s_blocksize;
 	namelen = dentry->d_name.len;
-	name = dentry->d_name.name;
 	if (namelen > EXT3_NAME_LEN)
 		return NULL;
 	if (is_dx(dir)) {
