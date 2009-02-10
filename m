From: Wei Yongjun <yjwei@cn.fujitsu.com>
Subject: ext3: Fix support for empty directory blocks in 64k blocksize filesystems
Date: Tue, 10 Feb 2009 16:36:27 +0800
Message-ID: <49913C8B.2060605@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55983 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbZBJIgj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Feb 2009 03:36:39 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The rec_len field in the directory entry is 16 bits, so if the
filesystem is completely empty, rec_len of 0 is used to designate
65536 in e2fsprogs, for the case where the directory entry takes
the entire 64k block.

But if empty directory is read, error message will be output by
current kernel. You can do the following commands to reproduct it.

  - mkfs.ext3 -b $(( 64 * 1024 )) /dev/sdc1
  - mount /dev/sda1 /mnt
  - cd /mnt/lost+found
  - ll
  - tail /var/log/messages
  EXT3-fs error (device sdc1): ext3_readdir: bad entry in \
  directory #11: rec_len is smaller than minimal - offset=0, \
  inode=0, rec_len=0, name_len=0

This patch fix to treat rec_len of 0 as 65536, like what e2fsprogs do.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 include/linux/ext3_fs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index dd495b8..dc975ad 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -711,7 +711,7 @@ static inline unsigned ext3_rec_len_from_disk(__le16 dlen)
 {
 	unsigned len = le16_to_cpu(dlen);
 
-	if (len == EXT3_MAX_REC_LEN)
+	if (len == EXT3_MAX_REC_LEN || len == 0)
 		return 1 << 16;
 	return len;
 }
@@ -719,7 +719,7 @@ static inline unsigned ext3_rec_len_from_disk(__le16 dlen)
 static inline __le16 ext3_rec_len_to_disk(unsigned len)
 {
 	if (len == (1 << 16))
-		return cpu_to_le16(EXT3_MAX_REC_LEN);
+		return cpu_to_le16(0);
 	else if (len > (1 << 16))
 		BUG();
 	return cpu_to_le16(len);
-- 
1.5.3.8



