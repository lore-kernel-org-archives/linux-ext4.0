From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: error checking in blkid/devname.c
Date: Thu, 21 Feb 2008 16:10:17 -0600
Message-ID: <47BDF6C9.8090009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: pspencer@fields.utoronto.ca
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933522AbYBUWKX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Feb 2008 17:10:23 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is for RH Bugzilla #433857: 
rpc.mountd segfaults due to uninitialized value in e2fsprogs devname.c

https://bugzilla.redhat.com/show_bug.cgi?id=433857

which did some very helpful analysis & provided a patch.

This patch is based on that, but checks all the devicemapper calls,
and does some goto error handling / unwrapping, in the same style as
the device-mapper lib code itself.

Compile-tested only, but seems fine to me.

Thanks,

-Eric


Index: e2fsprogs-1.40.5/lib/blkid/devname.c
===================================================================
--- e2fsprogs-1.40.5.orig/lib/blkid/devname.c
+++ e2fsprogs-1.40.5/lib/blkid/devname.c
@@ -171,37 +171,42 @@ static int dm_device_has_dep(const dev_t
 	struct dm_deps *deps;
 	struct dm_info info;
 	unsigned int i;
+	int ret = 0;
 
 	task = dm_task_create(DM_DEVICE_DEPS);
 	if (!task)
-		return 0;
+		goto out;
 
-	dm_task_set_name(task, name);
-	dm_task_run(task);
-	dm_task_get_info(task, &info);
+	if (!dm_task_set_name(task, name))
+		goto out;
 
-	if (!info.exists) {
-		dm_task_destroy(task);
-		return 0;
-	}
+	if (!dm_task_run(task))
+		goto out;
+
+	if (!dm_task_get_info(task, &info))
+		goto out;
+
+	if  (!info.exists)
+		goto out;
 
 	deps = dm_task_get_deps(task);
-	if (!deps || deps->count == 0) {
-		dm_task_destroy(task);
-		return 0;
-	}
+	if (!deps || deps->count == 0)
+		goto out;
 
 	for (i = 0; i < deps->count; i++) {
 		dev_t dep_dev = deps->device[i];
 
 		if (dev == dep_dev) {
-			dm_task_destroy(task);
-			return 1;
+			ret = 1;
+			goto out;
 		}
 	}
 
-	dm_task_destroy(task);
-	return 0;
+out:
+	if (task)
+		dm_task_destroy(task);
+
+	return ret;
 }
 
 static int dm_device_is_leaf(const dev_t dev)
@@ -214,15 +219,16 @@ static int dm_device_is_leaf(const dev_t
 	dm_log_init(dm_quiet_log);
 	task = dm_task_create(DM_DEVICE_LIST);
 	if (!task)
-		return 1;
+		goto out;
+
 	dm_log_init(0);
 
-	dm_task_run(task);
+	if (!dm_task_run(task))
+		goto out;
+
 	names = dm_task_get_names(task);
-	if (!names || !names->dev) {
-		dm_task_destroy(task);
-		return 1;
-	}
+	if (!names || !names->dev)
+		goto out;
 
 	n = 0;
 	do {
@@ -234,7 +240,9 @@ static int dm_device_is_leaf(const dev_t
 		next = names->next;
 	} while (next);
 
-	dm_task_destroy(task);
+out:
+	if (task)
+		dm_task_destroy(task);
 
 	return ret;
 }
@@ -247,20 +255,25 @@ static dev_t dm_get_devno(const char *na
 
 	task = dm_task_create(DM_DEVICE_INFO);
 	if (!task)
-		return ret;
+		goto out;
 
-	dm_task_set_name(task, name);
-	dm_task_run(task);
-	dm_task_get_info(task, &info);
+	if (!dm_task_set_name(task, name))
+		goto out;
 
-	if (!info.exists) {
-		dm_task_destroy(task);
-		return ret;
-	}
+	if (!dm_task_run(task))
+		goto out;
+
+	if (!dm_task_get_info(task, &info))
+		goto out;
+
+	if (!info.exists)
+		goto out;
 
 	ret = makedev(info.major, info.minor);
 
-	dm_task_destroy(task);
+out:
+	if (task)
+		dm_task_destroy(task);
 	
 	return ret;
 }
@@ -275,15 +288,15 @@ static void dm_probe_all(blkid_cache cac
 	dm_log_init(dm_quiet_log);
 	task = dm_task_create(DM_DEVICE_LIST);
 	if (!task)
-		return;
+		goto out;
 	dm_log_init(0);
 
-	dm_task_run(task);
+	if (!dm_task_run(task))
+		goto out;
+
 	names = dm_task_get_names(task);
-	if (!names || !names->dev) {
-		dm_task_destroy(task);
-		return;
-	}
+	if (!names || !names->dev)
+		goto out;
 
 	n = 0;
 	do {
@@ -311,7 +324,9 @@ try_next:
 		next = names->next;
 	} while (next);
 
-	dm_task_destroy(task);
+out:
+	if (task)
+		dm_task_destroy(task);
 }
 #endif /* HAVE_DEVMAPPER */
 
