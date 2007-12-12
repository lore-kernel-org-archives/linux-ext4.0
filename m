From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH -mm] ext4: remove unused code from ext4_find_entry()
Date: Wed, 12 Dec 2007 22:46:40 +0100
Message-ID: <200712122246.41284.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
To: sct@redhat.com, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2910 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759201AbXLLVpl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Dec 2007 16:45:41 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

	The unused code found in ext3_find_entry() is also present (and still unused)
in the ext4_find_entry() code. This patch removes it. Compile tested only.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 fs/ext4/namei.c | 68044 -> 67947 (-97 bytes)
 fs/ext4/namei.o | 183840 -> 183792 (-48 bytes)

 fs/ext4/namei.c |    4 ----
 1 file changed, 4 deletions(-)

--- linux-2.6.24-rc4-mm1-a/fs/ext4/namei.c	2007-12-06 09:27:07.000000000 +0100
+++ linux-2.6.24-rc4-mm1-b/fs/ext4/namei.c	2007-12-12 22:32:45.000000000 +0100
@@ -861,14 +861,10 @@ static struct buffer_head * ext4_find_en
 	int i, err;
 	struct inode *dir = dentry->d_parent->d_inode;
 	int namelen;
-	const u8 *name;
-	unsigned blocksize;

 	*res_dir = NULL;
 	sb = dir->i_sb;
-	blocksize = sb->s_blocksize;
 	namelen = dentry->d_name.len;
-	name = dentry->d_name.name;
 	if (namelen > EXT4_NAME_LEN)
 		return NULL;
 	if (is_dx(dir)) {
