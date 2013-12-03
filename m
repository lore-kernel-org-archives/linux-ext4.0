From: Lukas Czerner <lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] libblkid: Identify extN file system properly
Date: Tue,  3 Dec 2013 16:24:44 +0100
Message-ID: <1386084284-22120-1-git-send-email-lczerner@redhat.com>
Cc: kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Lukas Czerner <lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Currently when trying to identify extN file system we're playing games
with searching for kernel modules and parsing /proc/filesystem. All of
this just because ext4 module can be used to mount ext3 and ext2 file
systems on recent kernel and also because of ext4dev.

However all of this is not necessary. Ext4 module which does support
mounting ext2 and ext3 file system is able to recognize and mount ext2
and ext3 type so there is no need to disguise it and ext4dev should only
be ever used for testing and not as fallback when other modules are
missing (use -t instead).

This also introduces a bug when in situation that we only have ext4
modules with ext2/ext3 support which is not loaded and we try to mount
ext2 file system we will mount it incorrectly as ext4. This will not
happen if the ext4 module is already loaded.

With this patch we remove all the unnecessary checks and return the real
type of the file system which is on the device. This fixes the issue.
However on the kernel which was not compiled with EXT4_USE_FOR_EXT23
support one would have to provide file system type (-t) to be able to
mount the file system with ext4 driver.

Signed-off-by: Lukas Czerner <lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 libblkid/src/superblocks/ext.c | 182 +----------------------------------------
 1 file changed, 3 insertions(+), 179 deletions(-)

diff --git a/libblkid/src/superblocks/ext.c b/libblkid/src/superblocks/ext.c
index 8d57cb5..c711168 100644
--- a/libblkid/src/superblocks/ext.c
+++ b/libblkid/src/superblocks/ext.c
@@ -18,7 +18,6 @@
 #endif
 #include <time.h>
 
-#include "linux_version.h"
 #include "superblocks.h"
 
 struct ext2_super_block {
@@ -132,140 +131,11 @@ struct ext2_super_block {
 #define EXT3_FEATURE_RO_COMPAT_UNSUPPORTED	~EXT3_FEATURE_RO_COMPAT_SUPP
 
 /*
- * Check to see if a filesystem is in /proc/filesystems.
- * Returns 1 if found, 0 if not
- */
-static int fs_proc_check(const char *fs_name)
-{
-	FILE	*f;
-	char	buf[80], *cp, *t;
-
-	f = fopen("/proc/filesystems", "r" UL_CLOEXECSTR);
-	if (!f)
-		return 0;
-	while (!feof(f)) {
-		if (!fgets(buf, sizeof(buf), f))
-			break;
-		cp = buf;
-		if (!isspace(*cp)) {
-			while (*cp && !isspace(*cp))
-				cp++;
-		}
-		while (*cp && isspace(*cp))
-			cp++;
-		if ((t = strchr(cp, '\n')) != NULL)
-			*t = 0;
-		if ((t = strchr(cp, '\t')) != NULL)
-			*t = 0;
-		if ((t = strchr(cp, ' ')) != NULL)
-			*t = 0;
-		if (!strcmp(fs_name, cp)) {
-			fclose(f);
-			return 1;
-		}
-	}
-	fclose(f);
-	return (0);
-}
-
-/*
- * Check to see if a filesystem is available as a module
- * Returns 1 if found, 0 if not
- */
-static int check_for_modules(const char *fs_name)
-{
-#ifdef __linux__
-	struct utsname	uts;
-	FILE		*f;
-	char		buf[1024], *cp;
-	int		namesz;
-
-	if (uname(&uts))
-		return 0;
-	snprintf(buf, sizeof(buf), "/lib/modules/%s/modules.dep", uts.release);
-
-	f = fopen(buf, "r" UL_CLOEXECSTR);
-	if (!f)
-		return 0;
-
-	namesz = strlen(fs_name);
-
-	while (!feof(f)) {
-		if (!fgets(buf, sizeof(buf), f))
-			break;
-		if ((cp = strchr(buf, ':')) != NULL)
-			*cp = 0;
-		else
-			continue;
-		if ((cp = strrchr(buf, '/')) == NULL)
-			continue;
-		cp++;
-
-		if (!strncmp(cp, fs_name, namesz) &&
-		    (!strcmp(cp + namesz, ".ko") ||
-		     !strcmp(cp + namesz, ".ko.gz"))) {
-			fclose(f);
-			return 1;
-		}
-	}
-	fclose(f);
-#endif /* __linux__ */
-	return 0;
-}
-
-/*
  * Starting in 2.6.29, ext4 can be used to support filesystems
  * without a journal.
  */
 #define EXT4_SUPPORTS_EXT2 KERNEL_VERSION(2, 6, 29)
 
-static int system_supports_ext2(void)
-{
-	static time_t	last_check = 0;
-	static int	ret = -1;
-	time_t		now = time(0);
-
-	if (ret != -1 || (now - last_check) < 5)
-		return ret;
-	last_check = now;
-	ret = (fs_proc_check("ext2") || check_for_modules("ext2"));
-	return ret;
-}
-
-static int system_supports_ext4(void)
-{
-	static time_t	last_check = 0;
-	static int	ret = -1;
-	time_t		now = time(0);
-
-	if (ret != -1 || (now - last_check) < 5)
-		return ret;
-	last_check = now;
-	ret = (fs_proc_check("ext4") || check_for_modules("ext4"));
-	return ret;
-}
-
-static int system_supports_ext4dev(void)
-{
-	static time_t	last_check = 0;
-	static int	ret = -1;
-	time_t		now = time(0);
-
-	if (ret != -1 || (now - last_check) < 5)
-		return ret;
-	last_check = now;
-	ret = (fs_proc_check("ext4dev") || check_for_modules("ext4dev"));
-	return ret;
-}
-
-static int system_supports_ext4_ext2(void)
-{
-#ifdef __linux__
-	return get_linux_version() >= EXT4_SUPPORTS_EXT2;
-#else
-	return 0;
-#endif
-}
 /*
  * reads superblock and returns:
  *	fc = feature_compat
@@ -357,15 +227,6 @@ static int probe_ext2(blkid_probe pr,
 	    (fi  & EXT2_FEATURE_INCOMPAT_UNSUPPORTED))
 		return -BLKID_ERR_PARAM;
 
-	/*
-	 * If ext2 is not present, but ext4 or ext4dev are, then
-	 * disclaim we are ext2
-	 */
-	if (!system_supports_ext2() &&
-	    (system_supports_ext4() || system_supports_ext4dev()) &&
-	    system_supports_ext4_ext2())
-		return -BLKID_ERR_PARAM;
-
 	ext_get_info(pr, 2, es);
 	return 0;
 }
@@ -408,31 +269,7 @@ static int probe_ext4dev(blkid_probe pr,
 	if (fi & EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)
 		return -BLKID_ERR_PARAM;
 
-	/*
-	 * If the filesystem does not have a journal and ext2 and ext4
-	 * is not present, then force this to be detected as an
-	 * ext4dev filesystem.
-	 */
-	if (!(fc & EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&
-	    !system_supports_ext2() && !system_supports_ext4() &&
-	    system_supports_ext4dev() &&
-	    system_supports_ext4_ext2())
-		goto force_ext4dev;
-
-	/*
-	 * If the filesystem is marked as OK for use by in-development
-	 * filesystem code, but ext4dev is not supported, and ext4 is,
-	 * then don't call ourselves ext4dev, since we should be
-	 * detected as ext4 in that case.
-	 *
-	 * If the filesystem is marked as in use by production
-	 * filesystem, then it can only be used by ext4 and NOT by
-	 * ext4dev, so always disclaim we are ext4dev in that case.
-	 */
-	if (le32_to_cpu(es->s_flags) & EXT2_FLAGS_TEST_FILESYS) {
-		if (!system_supports_ext4dev() && system_supports_ext4())
-			return -BLKID_ERR_PARAM;
-	} else
+	if (!(le32_to_cpu(es->s_flags) & EXT2_FLAGS_TEST_FILESYS))
 		return -BLKID_ERR_PARAM;
 
 force_ext4dev:
@@ -454,22 +291,11 @@ static int probe_ext4(blkid_probe pr,
 	if (fi & EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)
 		return -BLKID_ERR_PARAM;
 
-	/*
-	 * If the filesystem does not have a journal and ext2 is not
-	 * present, then force this to be detected as an ext2
-	 * filesystem.
-	 */
-	if (!(fc & EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&
-	    !system_supports_ext2() && system_supports_ext4() &&
-	    system_supports_ext4_ext2())
-		goto force_ext4;
-
 	/* Ext4 has at least one feature which ext3 doesn't understand */
 	if (!(frc & EXT3_FEATURE_RO_COMPAT_UNSUPPORTED) &&
 	    !(fi  & EXT3_FEATURE_INCOMPAT_UNSUPPORTED))
 		return -BLKID_ERR_PARAM;
 
-force_ext4:
 	/*
 	 * If the filesystem is a OK for use by in-development
 	 * filesystem code, and ext4dev is supported or ext4 is not
@@ -480,10 +306,8 @@ force_ext4:
 	 * filesystem, then it can only be used by ext4 and NOT by
 	 * ext4dev.
 	 */
-	if (le32_to_cpu(es->s_flags) & EXT2_FLAGS_TEST_FILESYS) {
-		if (system_supports_ext4dev() || !system_supports_ext4())
-			return -BLKID_ERR_PARAM;
-	}
+	if (le32_to_cpu(es->s_flags) & EXT2_FLAGS_TEST_FILESYS)
+		return -BLKID_ERR_PARAM;
 
 	ext_get_info(pr, 4, es);
 	return 0;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe util-linux" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
