From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/3] contrib: add thread locking and readdir64_r support to spd_readdir
Date: Mon, 21 Jan 2013 19:09:49 -0500
Message-ID: <1358813390-26466-2-git-send-email-tytso@mit.edu>
References: <1358813390-26466-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44700 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563Ab3AVAJ4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jan 2013 19:09:56 -0500
In-Reply-To: <1358813390-26466-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is part of a series of improvements from a 2008 version of
spd_readdir.c that somehow didn't make it into the version which we
checked into e2fsprogs git tree.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 contrib/spd_readdir.c | 75 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 57 insertions(+), 18 deletions(-)

diff --git a/contrib/spd_readdir.c b/contrib/spd_readdir.c
index 30c01b3..910b104 100644
--- a/contrib/spd_readdir.c
+++ b/contrib/spd_readdir.c
@@ -1,21 +1,22 @@
 /*
  * readdir accelerator
  *
- * (C) Copyright 2003, 2004 by Theodore Ts'o.
+ * (C) Copyright 2003, 2004, 2008 by Theodore Ts'o.
+ *
+ * 2008-06-08 Modified by Ross Boylan <RossBoylan stanfordalumni org>
+ *    Added support for readdir_r and readdir64_r calls.  Note
+ *     this has not been tested on anything other than GNU/Linux i386,
+ *     and that the regular readdir wrapper will take slightly more
+ *     space than Ted's original since it now includes a lock.
  *
  * Compile using the command:
  *
- * gcc -o spd_readdir.so -fPIC -shared spd_readdir.c -ldl
+ * gcc -o spd_readdir.so -shared -fpic spd_readdir.c -ldl
  *
  * Use it by setting the LD_PRELOAD environment variable:
  * 
  * export LD_PRELOAD=/usr/local/sbin/spd_readdir.so
  *
- * Note that this preload is not going to work for all programs.  In
- * particular, although it does supply readdir_r(), it is *not* thread
- * safe.  So I can't recommend this as something to be dropped in
- * /etc/ld.so.preload.
- *
  * %Begin-Header%
  * This file may be redistributed under the terms of the GNU Public
  * License.
@@ -55,6 +56,7 @@
 #else
 #define PR_GET_DUMPABLE 3
 #endif
+#include <pthread.h>
 
 struct dirent_s {
 	unsigned long long d_ino;
@@ -66,6 +68,7 @@ struct dirent_s {
 
 struct dir_s {
 	DIR	*dir;
+	pthread_mutex_t lock; /* Mutex lock for this structure.  */
 	int	num;
 	int	max;
 	struct dirent_s *dp;
@@ -83,6 +86,8 @@ static struct dirent *(*real_readdir)(DIR *dir) = 0;
 static int (*real_readdir_r)(DIR *dir, struct dirent *entry,
 			     struct dirent **result) = 0;
 static struct dirent64 *(*real_readdir64)(DIR *dir) = 0;
+static int (*real_readdir64_r)(DIR *dir, struct dirent64 *entry,
+			       struct dirent64 **result) = 0;
 static off_t (*real_telldir)(DIR *dir) = 0;
 static void (*real_seekdir)(DIR *dir, off_t offset) = 0;
 static int (*real_dirfd)(DIR *dir) = 0;
@@ -124,6 +129,7 @@ static void setup_ptr()
 	real_readdir = dlsym(RTLD_NEXT, "readdir");
 	real_readdir_r = dlsym(RTLD_NEXT, "readdir_r");
 	real_readdir64 = dlsym(RTLD_NEXT, "readdir64");
+	real_readdir64_r = dlsym(RTLD_NEXT, "readdir64_r");
 	real_telldir = dlsym(RTLD_NEXT, "telldir");
 	real_seekdir = dlsym(RTLD_NEXT, "seekdir");
 	real_dirfd = dlsym(RTLD_NEXT, "dirfd");
@@ -142,6 +148,8 @@ static void free_cached_dir(struct dir_s *dirstruct)
 {
 	int i;
 
+	pthread_mutex_destroy(&(dirstruct->lock));
+
 	if (!dirstruct->dp)
 		return;
 
@@ -181,11 +189,14 @@ static int ino_cmp(const void *a, const void *b)
 struct dir_s *alloc_dirstruct(DIR *dir)
 {
 	struct dir_s	*dirstruct;
+	static pthread_mutexattr_t mutexattr;
+	mutexattr.__align = PTHREAD_MUTEX_RECURSIVE;
 
 	dirstruct = malloc(sizeof(struct dir_s));
 	if (dirstruct)
 		memset(dirstruct, 0, sizeof(struct dir_s));
 	dirstruct->dir = dir;
+	pthread_mutex_init(&(dirstruct->lock), &mutexattr);
 	return dirstruct;
 }
 
@@ -268,7 +279,7 @@ DIR *fdopendir(int fd)
 	if (!real_fdopendir)
 		setup_ptr();
 
-	DEBUG_DIR(printf("fdpendir(%d) (%d open)\n", fd, num_open++));
+	DEBUG_DIR(printf("fdopendir(%d) (%d open)\n", fd, num_open++));
 	dir = (*real_fdopendir)(fd);
 	if (!dir)
 		return NULL;
@@ -336,19 +347,19 @@ int readdir_r(DIR *dir, struct dirent *entry, struct dirent **result)
 	if (dirstruct->direct)
 		return (*real_readdir_r)(dirstruct->dir, entry, result);
 
+	pthread_mutex_lock(&(dirstruct->lock));
 	if (dirstruct->pos >= dirstruct->num) {
 		*result = NULL;
-		return 0;
+	} else {
+		ds = &dirstruct->dp[dirstruct->pos++];
+		entry->d_ino = ds->d_ino;
+		entry->d_off = ds->d_off;
+		entry->d_reclen = ds->d_reclen;
+		entry->d_type = ds->d_type;
+		strncpy(entry->d_name, ds->d_name, sizeof(entry->d_name));
+		*result = entry;
 	}
-
-	ds = &dirstruct->dp[dirstruct->pos++];
-	entry->d_ino = ds->d_ino;
-	entry->d_off = ds->d_off;
-	entry->d_reclen = ds->d_reclen;
-	entry->d_type = ds->d_type;
-	strncpy(entry->d_name, ds->d_name, sizeof(entry->d_name));
-	*result = entry;
-
+	pthread_mutex_unlock(&(dirstruct->lock));
 	return 0;
 }
 
@@ -374,6 +385,32 @@ struct dirent64 *readdir64(DIR *dir)
 	return (&dirstruct->ret_dir64);
 }
 
+int readdir64_r (DIR *__restrict dir,
+		 struct dirent64 *__restrict entry,
+		 struct dirent64 **__restrict result)
+{
+	struct dir_s	*dirstruct = (struct dir_s *) dir;
+	struct dirent_s *ds;
+
+	if (dirstruct->direct)
+		return (*real_readdir64_r)(dir, entry, result);
+	pthread_mutex_lock(&(dirstruct->lock));
+	if (dirstruct->pos >= dirstruct->num) {
+		*result = NULL;
+	} else {
+		ds = &dirstruct->dp[dirstruct->pos++];
+		entry->d_ino = ds->d_ino;
+		entry->d_off = ds->d_off;
+		entry->d_reclen = ds->d_reclen;
+		entry->d_type = ds->d_type;
+		strncpy(entry->d_name, ds->d_name,
+			sizeof(entry->d_name));
+		*result = entry;
+	}
+	pthread_mutex_unlock(&(dirstruct->lock));
+	return 0;
+}
+
 off_t telldir(DIR *dir)
 {
 	struct dir_s	*dirstruct = (struct dir_s *) dir;
@@ -404,9 +441,11 @@ void rewinddir(DIR *dir)
 	if (dirstruct->direct)
 		return;
 	
+	pthread_mutex_lock(&(dirstruct->lock));
 	dirstruct->pos = 0;
 	free_cached_dir(dirstruct);
 	cache_dirstruct(dirstruct);
+	pthread_mutex_unlock(&(dirstruct->lock));
 }
 
 int dirfd(DIR *dir)
-- 
1.7.12.rc0.22.gcdd159b

