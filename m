From: Celine Bourde <celine.bourde@bull.net>
Subject: [PATCH][e2fsprogs][mke2fs] fix FLEX_BG offset
Date: Thu, 03 Jul 2008 10:21:02 +0200
Message-ID: <486C8BEE.5030200@bull.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010005050104000007010305"
Cc: SOLOFO RAMANGALAHY <Solofo.Ramangalahy@bull.net>,
	Jean-Pierre Dion <jean-pierre.dion@bull.net>
To: linux-ext4@vger.kernel.org, "Jose R. Santos" <jrs@us.ibm.com>,
	cmm@us.ibm.com,
	=?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:36380 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbYGCMXP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jul 2008 08:23:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010005050104000007010305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch resolves the offset problem of the flex_bg
option when you use mke2fs tool.

For example, if you type mkfs.ext4 -I256 -O flex_bg -G32 -E test_fs <device>
and look dumpe2fs <device> result you will see an offset problem.

Group 0: (Blocks 0-32767)
Primary superblock at 0, Group descriptors at 1-5
Reserved GDT blocks at 6-1024
Block bitmap at 1025 (+1025), Inode bitmap at 1058 (+1058)
Inode table at 1090-1601 (+1090)
0 free blocks, 8181 free inodes, 2 directories
Free blocks:
Free inodes: 12-8192

Inode bitmap must start at 1025 + 32 = 1057
In all flexbg groups, the block between the last block bitmap and the 
first inode
bitmap (metatdata) is not used, which introduced a hole.

This patch corrects it.
You have to apply it on e2fsprogs (mke2fs 1.41-WIP (17-Jun-2008)) master 
branch.

Celine Bourde.

--------------010005050104000007010305
Content-Type: text/x-patch;
 name="flexbg_offset.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="flexbg_offset.patch"

Signed-off-by: Bourde Celine <celine.bourde@bull.net>

alloc_tables.c |    8 +++++---
1 file changed, 5 insertions(+), 3 deletions(-)

diff -rpu a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
--- a/lib/ext2fs/alloc_tables.c	2008-07-01 16:11:49.000000000 +0200
+++ b/lib/ext2fs/alloc_tables.c	2008-07-02 16:38:22.000000000 +0200
@@ -71,9 +71,11 @@ static blk_t flexbg_offset(ext2_filsys f
 				   &first_free))
 		return first_free;
 
-	if (ext2fs_get_free_blocks(fs, first_free + offset, last_blk, size,
-				   bmap, &first_free))
-		return first_free;
+	if (offset)
+		if (ext2fs_get_free_blocks(fs, first_free + offset - 1,
+					   last_blk, size, bmap,
+					   &first_free))
+			return first_free;
 
 	return first_free;
 }

--------------010005050104000007010305--
