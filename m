From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] ext4: do not advertise encryption support when disabled
Date: Mon, 10 Oct 2016 12:05:31 -0700
Message-ID: <1476126331-82810-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        richard@nod.at, Eric Biggers <ebiggers@google.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The sysfs file /sys/fs/ext4/features/encryption was present on kernels
compiled with CONFIG_EXT4_FS_ENCRYPTION=n.  This was misleading because
such kernels do not actually support ext4 encryption.  Therefore, only
provide this file on kernels compiled with CONFIG_EXT4_FS_ENCRYPTION=y.

Note: since the ext4 feature files are all hardcoded to have a contents
of "supported", it really is the presence or absence of the file that is
significant, not the contents (and this change reflects that).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 73bcfd4..42145be 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -223,14 +223,18 @@ static struct attribute *ext4_attrs[] = {
 EXT4_ATTR_FEATURE(lazy_itable_init);
 EXT4_ATTR_FEATURE(batched_discard);
 EXT4_ATTR_FEATURE(meta_bg_resize);
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
 EXT4_ATTR_FEATURE(encryption);
+#endif
 EXT4_ATTR_FEATURE(metadata_csum_seed);
 
 static struct attribute *ext4_feat_attrs[] = {
 	ATTR_LIST(lazy_itable_init),
 	ATTR_LIST(batched_discard),
 	ATTR_LIST(meta_bg_resize),
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
 	ATTR_LIST(encryption),
+#endif
 	ATTR_LIST(metadata_csum_seed),
 	NULL,
 };
-- 
2.8.0.rc3.226.g39d4020
