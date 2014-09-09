From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] ext4: Provide separate operations for sysfs feature files
Date: Tue,  9 Sep 2014 13:32:20 +0200
Message-ID: <1410262340-13713-2-git-send-email-lczerner@redhat.com>
References: <1410262340-13713-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202AbaIILc2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Sep 2014 07:32:28 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s89BWSFs006343
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Tue, 9 Sep 2014 07:32:28 -0400
In-Reply-To: <1410262340-13713-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently sysfs feature files uses ext4_attr_ops as the file operations
to show/store data. However the feature files is not supposed to contain
any data at all, the sole existence of the file means that the module
support the feature. Moreover, none of the sysfs feature attributes
actually register show/store functions so that would not be a problem.

However if a sysfs feature attribute register a show or store function
we might be in trouble because the kobject in this case is _not_ embedded
in the ext4_sb_info structure as ext4_attr_show/store expect.

So just to be safe, provide separate empty sysfs_ops to use in
ext4_feat_ktype. This might safe us from potential problems in the
future. As a bonus we can "store" something more descriptive than
nothing in the files, so let it contain "enabled" to make it clear that
the feature is really present in the module.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/super.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8e55ae1..2eff922 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2754,9 +2754,25 @@ static void ext4_feat_release(struct kobject *kobj)
 	complete(&ext4_feat->f_kobj_unregister);
 }
 
+static ssize_t ext4_feat_show(struct kobject *kobj,
+			      struct attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "supported\n");
+}
+
+/*
+ * We can not use ext4_attr_show/store because it relies on the kobject
+ * being embedded in the ext4_sb_info structure which is definitely not
+ * true in this case.
+ */
+static const struct sysfs_ops ext4_feat_ops = {
+	.show	= ext4_feat_show,
+	.store	= NULL,
+};
+
 static struct kobj_type ext4_feat_ktype = {
 	.default_attrs	= ext4_feat_attrs,
-	.sysfs_ops	= &ext4_attr_ops,
+	.sysfs_ops	= &ext4_feat_ops,
 	.release	= ext4_feat_release,
 };
 
-- 
1.8.3.1

