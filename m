From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: re-inline ext4_rec_len_(to|from)_disk functions
Date: Wed, 04 Aug 2010 10:52:05 -0500
Message-ID: <4C598CA5.70707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426Ab0HDPwK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Aug 2010 11:52:10 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o74Fq9lo022891
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 4 Aug 2010 11:52:09 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o74Fq6CQ004856
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 4 Aug 2010 11:52:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

commit 3d0518f4, "ext4: New rec_len encoding for very
large blocksizes" made several changes to this path, but from
a perf perspective, un-inlining ext4_rec_len_from_disk() seems
most significant.  This function is called from ext4_check_dir_entry(),
which on a file-creation workload is called extremely often.

I tested this with bonnie:

# bonnie++ -u root -s 0 -f -x 200 -d /mnt/test -n 32

(this does 200 iterations) and got this for the file creations:

ext4 stock:   Average =  21206.8 files/s
ext4 inlined: Average =  22346.7 files/s  (+5%)

We may get a little more by optimizing around the extra complexity
for > 64K blocks, but for now simply inlining is a nice improvement,
without a huge change in code size:

   text	   data	    bss	    dec	    hex	filename
 314580	  11888	    176	 326644	  4fbf4	ext4-stock.ko
 315246	  11888	    176	 327310	  4fe8e	ext4-inlined.ko

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 19a4de5..8aba5b8 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1378,6 +1378,31 @@ struct ext4_dir_entry_2 {
 					 ~EXT4_DIR_ROUND)
 #define EXT4_MAX_REC_LEN		((1<<16)-1)
 
+static inline unsigned int
+ext4_rec_len_from_disk(__le16 dlen, unsigned blocksize)
+{
+	unsigned len = le16_to_cpu(dlen);
+
+	if (len == EXT4_MAX_REC_LEN || len == 0)
+		return blocksize;
+	return (len & 65532) | ((len & 3) << 16);
+}
+
+static inline __le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize)
+{
+	if ((len > blocksize) || (blocksize > (1 << 18)) || (len & 3))
+		BUG();
+	if (len < 65536)
+		return cpu_to_le16(len);
+	if (len == blocksize) {
+		if (blocksize == 65536)
+			return cpu_to_le16(EXT4_MAX_REC_LEN);
+		else
+			return cpu_to_le16(0);
+	}
+	return cpu_to_le16((len & 65532) | ((len >> 16) & 3));
+}
+
 /*
  * Hash Tree Directory indexing
  * (c) Daniel Phillips, 2001
@@ -1601,8 +1626,6 @@ extern long ext4_compat_ioctl(struct file *, unsigned int, unsigned long);
 extern int ext4_ext_migrate(struct inode *);
 
 /* namei.c */
-extern unsigned int ext4_rec_len_from_disk(__le16 dlen, unsigned blocksize);
-extern __le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize);
 extern int ext4_orphan_add(handle_t *, struct inode *);
 extern int ext4_orphan_del(handle_t *, struct inode *);
 extern int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a43e661..77a7468 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -179,30 +179,6 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
 static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			     struct inode *inode);
 
-unsigned int ext4_rec_len_from_disk(__le16 dlen, unsigned blocksize)
-{
-	unsigned len = le16_to_cpu(dlen);
-
-	if (len == EXT4_MAX_REC_LEN || len == 0)
-		return blocksize;
-	return (len & 65532) | ((len & 3) << 16);
-}
-
-__le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize)
-{
-	if ((len > blocksize) || (blocksize > (1 << 18)) || (len & 3))
-		BUG();
-	if (len < 65536)
-		return cpu_to_le16(len);
-	if (len == blocksize) {
-		if (blocksize == 65536)
-			return cpu_to_le16(EXT4_MAX_REC_LEN);
-		else
-			return cpu_to_le16(0);
-	}
-	return cpu_to_le16((len & 65532) | ((len >> 16) & 3));
-}
