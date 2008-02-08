From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH, E2FSPROGS] blkid: Automatically chose between ext4 and ext4dev as appropriate
Date: Fri, 08 Feb 2008 17:35:04 -0500
Message-ID: <E1JNboG-0000IP-8D@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:48373 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762131AbYBHWfK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Feb 2008 17:35:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I plan to release this in an upcoming 1.40.6 release, along with code
that allows "tune2fs -E test_fs" to work on ext4 filesystems.  The idea
is that if I can get this into community distro's, it will make it
easier for them to experiment with ext4/ext4dev, with the appropriate
forward compatibility when sometime (hopefully 2.6.26 or 2.6.27?) we
rename ext4dev to ext4.

Any comments before I push this change out to the maint branch?

						- Ted


commit feac6e49211a44ef6f560b3b362fb132a474a471
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Feb 8 16:04:12 2008 -0500

    blkid: Automatically chose between ext4 and ext4dev as appropriate
    
    Add logic that on Linux systems will check for the presence of the
    ext4dev filesystem; if it isn't present, fall back to ext4 for
    filesystems that are marked as being "OK for use on test filesystem
    code".  If they are OK for use for in-development filesystem code, it
    should also be fine to use stable filesystem code if there is no test
    filesystem code (ext4dev) available.
    
    The reverse is not true, of course.  We don't ever want to mount a
    production filesystem using test filesystem code unless the user gives
    us explicit permission via "tune2fs -E test_fs".
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index 492a36a..456e9bb 100644
--- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -25,6 +25,7 @@
 #ifdef HAVE_SYS_MKDEV_H
 #include <sys/mkdev.h>
 #endif
+#include <sys/utsname.h>
 #ifdef HAVE_ERRNO_H
 #include <errno.h>
 #endif
@@ -158,6 +159,109 @@ static void get_ext2_info(blkid_dev dev, struct blkid_magic *id,
 		blkid_set_tag(dev, "SEC_TYPE", "ext2", sizeof("ext2"));
 }
 
+/*
+ * Check to see if a filesystem is in /proc/filesystems.
+ * Returns 1 if found, 0 if not
+ */
+int fs_proc_check(const char *fs_name)
+{
+	FILE	*f;
+	char	buf[80], *cp, *t;
+
+	f = fopen("/proc/filesystems", "r");
+	if (!f)
+		return (0);
+	while (!feof(f)) {
+		if (!fgets(buf, sizeof(buf), f))
+			break;
+		cp = buf;
+		if (!isspace(*cp)) {
+			while (*cp && !isspace(*cp))
+				cp++;
+		}
+		while (*cp && isspace(*cp))
+			cp++;
+		if ((t = strchr(cp, '\n')) != NULL)
+			*t = 0;
+		if ((t = strchr(cp, '\t')) != NULL)
+			*t = 0;
+		if ((t = strchr(cp, ' ')) != NULL)
+			*t = 0;
+		if (!strcmp(fs_name, cp)) {
+			fclose(f);
+			return (1);
+		}
+	}
+	fclose(f);
+	return (0);
+}
+
+/*
+ * Check to see if a filesystem is available as a module
+ * Returns 1 if found, 0 if not
+ */
+int check_for_modules(const char *fs_name)
+{
+	struct utsname	uts;
+	FILE		*f;
+	char		buf[1024], *cp, *t;
+	int		i;
+
+	if (uname(&uts))
+		return (0);
+	snprintf(buf, sizeof(buf), "/lib/modules/%s/modules.dep", uts.release);
+
+	f = fopen(buf, "r");
+	if (!f)
+		return (0);
+	while (!feof(f)) {
+		if (!fgets(buf, sizeof(buf), f))
+			break;
+		if ((cp = strchr(buf, ':')) != NULL)
+			*cp = 0;
+		else
+			continue;
+		if ((cp = strrchr(buf, '/')) != NULL)
+			cp++;
+		i = strlen(cp);
+		if (i > 3) {
+			t = cp + i - 3;
+			if (!strcmp(t, ".ko"))
+				*t = 0;
+		}
+		if (!strcmp(cp, fs_name))
+			return (1);
+	}
+	fclose(f);
+	return (0);
+}
+
+static int system_supports_ext4()
+{
+	static time_t	last_check = 0;
+	static int	ret = -1;
+	time_t		now = time(0);
+
+	if (ret != -1 || (last_check - now) > 5)
+		return ret;
+	last_check = now;
+	ret = (fs_proc_check("ext4") || check_for_modules("ext4"));
+	return ret;
+}
+
+static int system_supports_ext4dev()
+{
+	static time_t	last_check = 0;
+	static int	ret = -1;
+	time_t		now = time(0);
+
+	if (ret != -1 || (last_check - now) > 5)
+		return ret;
+	last_check = now;
+	ret = (fs_proc_check("ext4dev") || check_for_modules("ext4dev"));
+	return ret;
+}
+
 static int probe_ext4dev(struct blkid_probe *probe,
 			 struct blkid_magic *id,
 			 unsigned char *buf)
@@ -165,10 +269,6 @@ static int probe_ext4dev(struct blkid_probe *probe,
 	struct ext2_super_block *es;
 	es = (struct ext2_super_block *)buf;
 
-	/* Distinguish between ext4dev and other filesystems */
-	if ((blkid_le32(es->s_flags) & EXT2_FLAGS_TEST_FILESYS) == 0)
-		return -BLKID_ERR_PARAM;
-
 	/* Distinguish from jbd */
 	if (blkid_le32(es->s_feature_incompat) &
 	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)
@@ -179,6 +279,22 @@ static int probe_ext4dev(struct blkid_probe *probe,
 	      EXT3_FEATURE_COMPAT_HAS_JOURNAL))
 		return -BLKID_ERR_PARAM;
 
+	/*
+	 * If the filesystem is marked as OK for use by in-development
+	 * filesystem code, but ext4dev is not supported, and ext4 is,
+	 * then don't call ourselves ext4dev, since we should be
+	 * detected as ext4 in that case.
+	 *
+	 * If the filesystem is marked as in use by production
+	 * filesystem, then it can only be used by ext4 and NOT by
+	 * ext4dev, so always disclaim we are ext4dev in that case.
+	 */
+	if (blkid_le32(es->s_flags) & EXT2_FLAGS_TEST_FILESYS) {
+		if (!system_supports_ext4dev() && system_supports_ext4())
+			return -BLKID_ERR_PARAM;
+	} else
+		return -BLKID_ERR_PARAM;
+
     	get_ext2_info(probe->dev, id, buf);
 	return 0;
 }
@@ -189,10 +305,6 @@ static int probe_ext4(struct blkid_probe *probe, struct blkid_magic *id,
 	struct ext2_super_block *es;
 	es = (struct ext2_super_block *)buf;
 
-	/* Distinguish from ext4dev */
-	if (blkid_le32(es->s_flags) & EXT2_FLAGS_TEST_FILESYS)
-		return -BLKID_ERR_PARAM;
-
 	/* Distinguish from jbd */
 	if (blkid_le32(es->s_feature_incompat) & 
 	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)
@@ -210,6 +322,20 @@ static int probe_ext4(struct blkid_probe *probe, struct blkid_magic *id,
 	      EXT3_FEATURE_INCOMPAT_UNSUPPORTED))
 		return -BLKID_ERR_PARAM;
 
+	/*
+	 * If the filesystem is a OK for use by in-development
+	 * filesystem code, and ext4dev is supported or ext4 is not
+	 * supported, then don't call ourselves ext4, so we can redo
+	 * the detection and mark the filesystem as ext4dev.
+	 *
+	 * If the filesystem is marked as in use by production
+	 * filesystem, then it can only be used by ext4 and NOT by
+	 * ext4dev.
+	 */
+	if (blkid_le32(es->s_flags) & EXT2_FLAGS_TEST_FILESYS) {
+		if (system_supports_ext4dev() || !system_supports_ext4())
+			return -BLKID_ERR_PARAM;
+	}
     	get_ext2_info(probe->dev, id, buf);
 	return 0;
 }
