From: Roel Kluin <12o3l@tiscali.nl>
Subject: [PATCH v2] mballoc: fix hot spins after err_freebuddy and err_freemeta
Date: Thu, 17 Apr 2008 20:29:18 +0200
Message-ID: <480796FE.2010707@tiscali.nl>
References: <4807762A.9090202@tiscali.nl> <20080417175843.GA7517@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: alex@clusterfs.com, sct@redhat.com, akpm@linux-foundation.org,
	adilger@clusterfs.com, linux-ext4@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934099AbYDQS3z@vger.kernel.org>
In-Reply-To: <20080417175843.GA7517@skywalker>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Aneesh Kumar K.V wrote:

> The function needs more changes. For ex:
> 
> 2279     if (meta_group_info[j] == NULL) {
> 2280               printk(KERN_ERR "EXT4-fs: can't allocate buddy mem\n");
> 2281               i--;
> 2282               goto err_freebuddy;
> 2283     }
> 
> That decrement  i--; could result in bad value if i == 0;.

Thanks Aneesh,
---
Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
ext4_mb_init_backend() has a variable i of type ext4_group_t. which is typedefined
in include/linux/ext4_fs_i.h:34 to unsigned long. Since unsigned, i >= 0 is always
true, so fix hot spins after err_freebuddy and err_freemeta.
Also when meta_group_info cannot be allocated prevent a decrement of i when zero.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ef97f19..2c13dca 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2572,8 +2572,13 @@ static int ext4_mb_init_backend(struct super_block *sb)
 		meta_group_info[j] = kzalloc(len, GFP_KERNEL);
 		if (meta_group_info[j] == NULL) {
 			printk(KERN_ERR "EXT4-fs: can't allocate buddy mem\n");
-			i--;
-			goto err_freebuddy;
+			if (i != 0) {
+				i--;
+				goto err_freebuddy;
+			} else {
+				i = num_meta_group_infos - 1;
+				goto err_freemeta;
+			}
 		}
 		desc = ext4_get_group_desc(sb, i, NULL);
 		if (desc == NULL) {
@@ -2618,14 +2623,14 @@ static int ext4_mb_init_backend(struct super_block *sb)
 	return 0;
 
 err_freebuddy:
-	while (i >= 0) {
+	do {
 		kfree(ext4_get_group_info(sb, i));
-		i--;
-	}
-	i = num_meta_group_infos;
+	} while (i-- != 0);
+	i = num_meta_group_infos - 1;
 err_freemeta:
-	while (--i >= 0)
+	do {
 		kfree(sbi->s_group_info[i]);
+	} while (i-- != 0);
 	iput(sbi->s_buddy_cache);
 err_freesgi:
 	kfree(sbi->s_group_info);
