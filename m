From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 6/6] Add interface to advertise ext4 features in sysfs
Date: Thu, 16 Sep 2010 14:47:31 +0200
Message-ID: <1284641251-24531-7-git-send-email-lczerner@redhat.com>
References: <1284641251-24531-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, rwheeler@redhat.com, sandeen@redhat.com,
	adilger@dilger.ca, lczerner@redhat.com, snitzer@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab0IPMru (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Sep 2010 08:47:50 -0400
In-Reply-To: <1284641251-24531-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

User-space should have the opportunity to check what features doest ext4
support in each particular copy. This adds easy interface by creating new
"features" directory in sys/fs/ext4/. In that directory files
advertising feature names can be created.

Add lazy_itable_init to the feature list.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/ext4.h  |    5 +++++
 fs/ext4/super.c |   50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 54 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 96884c5..74ec1fc 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1572,6 +1572,11 @@ struct ext4_li_request {
 	unsigned long		lr_next_sched;
 };
 
+struct ext4_features {
+	struct kobject f_kobj;
+	struct completion f_kobj_unregister;
+};
+
 /*
  * Function prototypes
  */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2b53a48..bb84c27 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -57,6 +57,7 @@ struct proc_dir_entry *ext4_proc_root;
 static struct kset *ext4_kset;
 struct ext4_lazy_init *ext4_li_info;
 struct mutex ext4_li_mtx;
+struct ext4_features *ext4_feat;
 
 static int ext4_load_journal(struct super_block *, struct ext4_super_block *,
 			     unsigned long journal_devnum);
@@ -2413,6 +2414,7 @@ static struct ext4_attr ext4_attr_##_name = {			\
 #define EXT4_ATTR(name, mode, show, store) \
 static struct ext4_attr ext4_attr_##name = __ATTR(name, mode, show, store)
 
+#define EXT4_INFO_ATTR(name) EXT4_ATTR(name, 0444, NULL, NULL)
 #define EXT4_RO_ATTR(name) EXT4_ATTR(name, 0444, name##_show, NULL)
 #define EXT4_RW_ATTR(name) EXT4_ATTR(name, 0644, name##_show, name##_store)
 #define EXT4_RW_ATTR_SBI_UI(name, elname)	\
@@ -2449,6 +2451,14 @@ static struct attribute *ext4_attrs[] = {
 	NULL,
 };
 
+/* Features this copy of ext4 supports */
+EXT4_INFO_ATTR(lazy_itable_init);
+
+static struct attribute *ext4_feat_attrs[] = {
+	ATTR_LIST(lazy_itable_init),
+	NULL,
+};
+
 static ssize_t ext4_attr_show(struct kobject *kobj,
 			      struct attribute *attr, char *buf)
 {
@@ -2477,7 +2487,6 @@ static void ext4_sb_release(struct kobject *kobj)
 	complete(&sbi->s_kobj_unregister);
 }
 
-
 static const struct sysfs_ops ext4_attr_ops = {
 	.show	= ext4_attr_show,
 	.store	= ext4_attr_store,
@@ -2489,6 +2498,17 @@ static struct kobj_type ext4_ktype = {
 	.release	= ext4_sb_release,
 };
 
+static void ext4_feat_release(struct kobject *kobj)
+{
+	complete(&ext4_feat->f_kobj_unregister);
+}
+
+static struct kobj_type ext4_feat_ktype = {
+	.default_attrs	= ext4_feat_attrs,
+	.sysfs_ops	= &ext4_attr_ops,
+	.release	= ext4_feat_release,
+};
+
 /*
  * Check whether this filesystem can be mounted based on
  * the features present and the RDONLY/RDWR mount requested.
@@ -4716,6 +4736,30 @@ static struct file_system_type ext4_fs_type = {
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
+int __init ext4_init_feat_adverts(void)
+{
+	struct ext4_features *ef;
+	int ret = -ENOMEM;
+
+	ef = kzalloc(sizeof(struct ext4_features), GFP_KERNEL);
+	if (!ef)
+		goto out;
+
+	ef->f_kobj.kset = ext4_kset;
+	init_completion(&ef->f_kobj_unregister);
+	ret = kobject_init_and_add(&ef->f_kobj, &ext4_feat_ktype, NULL,
+				   "features");
+	if (ret) {
+		kfree(ef);
+		goto out;
+	}
+
+	ext4_feat = ef;
+	ret = 0;
+out:
+	return ret;
+}
+
 static int __init init_ext4_fs(void)
 {
 	int err;
@@ -4728,6 +4772,9 @@ static int __init init_ext4_fs(void)
 	if (!ext4_kset)
 		goto out4;
 	ext4_proc_root = proc_mkdir("fs/ext4", NULL);
+
+	err = ext4_init_feat_adverts();
+
 	err = init_ext4_mballoc();
 	if (err)
 		goto out3;
@@ -4756,6 +4803,7 @@ out1:
 out2:
 	exit_ext4_mballoc();
 out3:
+	kfree(ext4_feat);
 	remove_proc_entry("fs/ext4", NULL);
 	kset_unregister(ext4_kset);
 out4:
-- 
1.7.2.2

