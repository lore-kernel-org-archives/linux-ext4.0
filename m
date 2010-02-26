From: Tao Ma <tao.ma@oracle.com>
Subject: [RFC] ext4: Change check for choosing group/file preallocation.
Date: Fri, 26 Feb 2010 16:05:22 +0800
Message-ID: <1267171522-17439-1-git-send-email-tao.ma@oracle.com>
Cc: linux-kernel@vger.kernel.org, Tao Ma <tao.ma@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:34007 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935455Ab0BZIHK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Feb 2010 03:07:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4 predicts whether we use group or file preallocation
by the file size. So in general, if the file size has
reached s_mb_stream_request(default is 16 blocks),
it will change to use file preallocation. This is cool, but
it has a tiny problem.
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

So there are 3 extents, a bit strange for the lonely 15.
The reason is that if blocksize is 1K, As we write to the
16 blocks, we choose file preallocation in
ext4_mb_group_or_file, but in ext4_mb_normalize_request,
we meet with the 16*1024 range, so no preallocation will
be carried. file b then reserves the space after '2356',
so when when write 16, we start from another part.

This patch just change the check in ext4_mb_group_or_file, so
that for the lonely 15 we will still use group preallocation.
After the patch, we will get:
debuge4fs -R 'stat a' /dev/sda8|grep BLOCKS -A 1
BLOCKS:
(0-15):8705-8720, (16-19):8465-8468

Looks more sane. Thanks.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>

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
1.5.5

