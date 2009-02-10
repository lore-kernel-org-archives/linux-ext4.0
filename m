From: akpm@linux-foundation.org
Subject: + ext2-fix-support-for-empty-directory-blocks-in-64k-blocksize-filesystems.patch added to -mm tree
Date: Tue, 10 Feb 2009 14:57:58 -0800
Message-ID: <200902102257.n1AMvwKl006860@imap1.linux-foundation.org>
Cc: yjwei@cn.fujitsu.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757501AbZBJW6U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Feb 2009 17:58:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext2: fix support for empty directory blocks in 64k blocksize filesystems
has been added to the -mm tree.  Its filename is
     ext2-fix-support-for-empty-directory-blocks-in-64k-blocksize-filesystems.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: fix support for empty directory blocks in 64k blocksize filesystems
From: Wei Yongjun <yjwei@cn.fujitsu.com>

The rec_len field in the directory entry is 16 bits, so if the filesystem
is completely empty, rec_len of 0 is used to designate 65536 in e2fsprogs,
for the case where the directory entry takes the entire 64k block.

But if an empty directory is read, an error message will be output by
current kernels.  You can use the following commands to reproduce it.

  - mkfs.ext2 -b $(( 64 * 1024 )) /dev/sdc1
  - mount /dev/sda1 /mnt
  - cd /mnt/lost+found
  - ll
  - tail /var/log/messages
  EXT2-fs error (device sdc1): ext2_check_page: bad entry in \
  directory #11: : rec_len is smaller than minimal - offset=65536, \
  inode=0, rec_len=0, name_len=0
  EXT2-fs error (device sdc1): ext2_readdir: bad page in #11

Treat a rec_len of 0 as 65536, as e2fsprogs does.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/dir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ext2/dir.c~ext2-fix-support-for-empty-directory-blocks-in-64k-blocksize-filesystems fs/ext2/dir.c
--- a/fs/ext2/dir.c~ext2-fix-support-for-empty-directory-blocks-in-64k-blocksize-filesystems
+++ a/fs/ext2/dir.c
@@ -33,7 +33,7 @@ static inline unsigned ext2_rec_len_from
 {
 	unsigned len = le16_to_cpu(dlen);
 
-	if (len == EXT2_MAX_REC_LEN)
+	if (len == EXT2_MAX_REC_LEN || len == 0)
 		return 1 << 16;
 	return len;
 }
@@ -41,7 +41,7 @@ static inline unsigned ext2_rec_len_from
 static inline __le16 ext2_rec_len_to_disk(unsigned len)
 {
 	if (len == (1 << 16))
-		return cpu_to_le16(EXT2_MAX_REC_LEN);
+		return cpu_to_le16(0);
 	else
 		BUG_ON(len > (1 << 16));
 	return cpu_to_le16(len);
_

Patches currently in -mm which might be from yjwei@cn.fujitsu.com are

linux-next.patch
fs-jffs2-mallocc-kmem_cache_alloc-memset-kmem_cache_zalloc.patch
scsi-used-kmem_cache_zalloc-instead-of-kmem_cache_alloc-memset.patch
ext2-fix-support-for-empty-directory-blocks-in-64k-blocksize-filesystems.patch
ext3-fix-support-for-empty-directory-blocks-in-64k-blocksize-filesystems.patch

