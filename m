From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 1/6] ext4: sysfs: print ext4_super_block fields as little-endian
Date: Wed, 11 Jul 2018 11:14:09 +0200
Message-ID: <20180711091414.1494843-1-arnd@arndb.de>
Cc: arnd@arndb.de, jack@suse.cz, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, sirmy15@gmail.com,
        stable@vger.kernel.org, tgnottingham@gmail.com, tytso@mit.edu,
        y2038@lists.linaro.org
To: adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

While working on extended rand for last_error/first_error timestamps,
I noticed that the endianess is wrong, we access the little-endian
fields in struct ext4_super_block as native-endian when we print them.

This adds a special case in ext4_attr_show() and ext4_attr_store()
to byteswap the superblock fields if needed.

In older kernels, this code was part of super.c, it got moved to sysfs.c
in linux-4.4.

Cc: stable@vger.kernel.org
Fixes: 52c198c6820f ("ext4: add sysfs entry showing whether the fs contains errors")
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/ext4/sysfs.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index f34da0bb8f17..b970a200f20c 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -274,8 +274,12 @@ static ssize_t ext4_attr_show(struct kobject *kobj,
 	case attr_pointer_ui:
 		if (!ptr)
 			return 0;
-		return snprintf(buf, PAGE_SIZE, "%u\n",
-				*((unsigned int *) ptr));
+		if (a->attr_ptr == ptr_ext4_super_block_offset)
+			return snprintf(buf, PAGE_SIZE, "%u\n",
+					le32_to_cpup(ptr));
+		else
+			return snprintf(buf, PAGE_SIZE, "%u\n",
+					*((unsigned int *) ptr));
 	case attr_pointer_atomic:
 		if (!ptr)
 			return 0;
@@ -308,7 +312,10 @@ static ssize_t ext4_attr_store(struct kobject *kobj,
 		ret = kstrtoul(skip_spaces(buf), 0, &t);
 		if (ret)
 			return ret;
-		*((unsigned int *) ptr) = t;
+		if (a->attr_ptr == ptr_ext4_super_block_offset)
+			*((__le32 *) ptr) = cpu_to_le32(t);
+		else
+			*((unsigned int *) ptr) = t;
 		return len;
 	case attr_inode_readahead:
 		return inode_readahead_blks_store(sbi, buf, len);
-- 
2.9.0
