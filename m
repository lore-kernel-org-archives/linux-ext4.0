From: Wei Yongjun <yjwei@cn.fujitsu.com>
Subject: ext2: Fix support for empty directory blocks in 64k blocksize filesystems
Date: Tue, 10 Feb 2009 16:39:50 +0800
Message-ID: <49913D56.9040506@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62112 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbZBJIkC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Feb 2009 03:40:02 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The rec_len field in the directory entry is 16 bits, so if the
filesystem is completely empty, rec_len of 0 is used to designate
65536 in e2fsprogs, for the case where the directory entry takes
the entire 64k block.

But if empty directory is read, error message will be output by
current kernel. You can do the following commands to reproduct it.

  - mkfs.ext2 -b $(( 64 * 1024 )) /dev/sdc1
  - mount /dev/sda1 /mnt
  - cd /mnt/lost+found
  - ll
  - tail /var/log/messages
  EXT2-fs error (device sdc1): ext2_check_page: bad entry in \
  directory #11: : rec_len is smaller than minimal - offset=65536, \
  inode=0, rec_len=0, name_len=0
  EXT2-fs error (device sdc1): ext2_readdir: bad page in #11

This patch fix to treat rec_len of 0 as 65536, like what e2fsprogs do.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 fs/ext2/dir.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 2999d72..d10907d 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -32,7 +32,7 @@ static inline unsigned ext2_rec_len_from_disk(__le16 dlen)
 {
 	unsigned len = le16_to_cpu(dlen);
 
-	if (len == EXT2_MAX_REC_LEN)
+	if (len == EXT2_MAX_REC_LEN || len == 0)
 		return 1 << 16;
 	return len;
 }
@@ -40,7 +40,7 @@ static inline unsigned ext2_rec_len_from_disk(__le16 dlen)
 static inline __le16 ext2_rec_len_to_disk(unsigned len)
 {
 	if (len == (1 << 16))
-		return cpu_to_le16(EXT2_MAX_REC_LEN);
+		return cpu_to_le16(0);
 	else
 		BUG_ON(len > (1 << 16));
 	return cpu_to_le16(len);
-- 
1.5.3.8



