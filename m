From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2.6.33.y 04/40] ext4: Fix fencepost error in chosing choosing group vs file preallocation.
Date: Tue,  1 Jun 2010 08:02:51 -0400
Message-ID: <1275393807-14369-4-git-send-email-tytso@mit.edu>
References: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Tao Ma <tao.ma@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47277 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756069Ab0FAMDd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 08:03:33 -0400
In-Reply-To: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <tao.ma@oracle.com>

commit cc483f102c3f703e853c96f95a654f0106fb2603 upstream (as of v2.6.33-git11)

The ext4 multiblock allocator decides whether to use group or file
preallocation based on the file size.  When the file size reaches
s_mb_stream_request (default is 16 blocks), it changes to use a
file-specific preallocation. This is cool, but it has a tiny problem.

See a simple script:
mkfs.ext4 -b 1024 /dev/sda8 1000000
mount -t ext4 -o nodelalloc /dev/sda8 /mnt/ext4
for((i=0;i<5;i++))
do
cat /mnt/4096>>/mnt/ext4/a	#4096 is a file with 4096 characters.
cat /mnt/4096>>/mnt/ext4/b
done
debuge4fs -R 'stat a' /dev/sda8|grep BLOCKS -A 1

And you get
BLOCKS:
(0-14):8705-8719, (15):2356, (16-19):8465-8468

So there are 3 extents, a bit strange for the lonely 15th logical
block.  As we write to the 16 blocks, we choose file preallocation in
ext4_mb_group_or_file, but in ext4_mb_normalize_request, we meet with
the 16*1024 range, so no preallocation will be carried. file b then
reserves the space after '2356', so when when write 16, we start from
another part.

This patch just change the check in ext4_mb_group_or_file, so
that for the lonely 15 we will still use group preallocation.
After the patch, we will get:
debuge4fs -R 'stat a' /dev/sda8|grep BLOCKS -A 1
BLOCKS:
(0-15):8705-8720, (16-19):8465-8468

Looks more sane. Thanks.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d34afad..301b173 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3938,7 +3938,7 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 
 	/* don't use group allocation for large files */
 	size = max(size, isize);
-	if (size >= sbi->s_mb_stream_request) {
+	if (size > sbi->s_mb_stream_request) {
 		ac->ac_flags |= EXT4_MB_STREAM_ALLOC;
 		return;
 	}
-- 
1.6.6.1.1.g974db.dirty

