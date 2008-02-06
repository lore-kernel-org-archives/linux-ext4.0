From: Matthias Koenig <mkoenig-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 2/3] fsck: add support for the fsprobe library wrapper
Date: Wed, 06 Feb 2008 12:39:02 +0100
Message-ID: <20080206113902.7833.57924.stgit@sor.suse.de>
References: <20080206113426.7833.59505.stgit@sor.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080206113426.7833.59505.stgit-qv7XSOoqp4Ab1SvskN2V4Q@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Allows fsck to work with blkid or volume_id as defined
by the configure invocation.

Signed-off-by: Matthias Koenig <mkoenig-l3A5Bk7waGM@public.gmane.org>
---

 fsck/Makefile.am |   17 +++++++++++++++--
 fsck/fsck.c      |   13 ++++++-------
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/fsck/Makefile.am b/fsck/Makefile.am
index 59523fc..bf2ac6c 100644
--- a/fsck/Makefile.am
+++ b/fsck/Makefile.am
@@ -1,7 +1,20 @@
 include $(top_srcdir)/config/include-Makefile.am
 
 usrsbinexec_PROGRAMS = fsck
-fsck_SOURCES = fsck.c fsck.h base_device.c
-fsck_LDADD = -lblkid
 man_MANS = fsck.8
 
+utils_common = ../mount/sundries.c ../mount/xmalloc.c ../mount/realpath.c ../mount/fsprobe.c
+
+fsck_SOURCES = fsck.c fsck.h base_device.c $(utils_common)
+fsck_LDADD =
+
+if HAVE_BLKID
+utils_common += ../mount/fsprobe_blkid.c
+fsck_LDADD += -lblkid
+endif
+
+if HAVE_VOLUME_ID
+utils_common += ../mount/fsprobe_volumeid.c ../lib/blkdev.c ../lib/linux_version.c
+fsck_LDADD += -lvolume_id
+endif
+
diff --git a/fsck/fsck.c b/fsck/fsck.c
index 6b39b21..c7905c4 100644
--- a/fsck/fsck.c
+++ b/fsck/fsck.c
@@ -45,7 +45,7 @@
 #include "../config.h"
 #include "nls.h"
 #include "fsck.h"
-#include "blkid/blkid.h"
+#include "../mount/fsprobe.h"
 
 #ifndef _PATH_MNTTAB
 #define	_PATH_MNTTAB	"/etc/fstab"
@@ -104,7 +104,6 @@ struct fs_info *filesys_info = NULL, *filesys_last = NULL;
 struct fsck_instance *instance_list;
 const char *fsck_prefix_path = "/sbin:/sbin/fs.d:/sbin/fs:/etc/fs:/etc";
 char *fsck_path = 0;
-blkid_cache cache = NULL;
 
 static char *string_copy(const char *s)
 {
@@ -282,7 +281,7 @@ static int parse_fstab_line(char *line, struct fs_info **ret_fs)
 	parse_escape(freq);
 	parse_escape(passno);
 
-	dev = blkid_get_devname(cache, device, NULL);
+	dev = fsprobe_get_devname(device);
 	if (dev)
 		device = dev;
 
@@ -307,7 +306,7 @@ static void interpret_type(struct fs_info *fs)
 	
 	if (strcmp(fs->type, "auto") != 0)
 		return;
-	t = blkid_get_tag_value(cache, "TYPE", fs->device);
+	t = fsprobe_get_fstype_by_devname(fs->device);
 	if (t) {
 		free(fs->type);
 		fs->type = t;
@@ -1090,7 +1089,7 @@ static void PRS(int argc, char *argv[])
 					progname);
 				exit(EXIT_ERROR);
 			}
-			dev = blkid_get_devname(cache, arg, NULL);
+			dev = fsprobe_get_devname(arg);
 			if (!dev && strchr(arg, '=')) {
 				/*
 				 * Check to see if we failed because
@@ -1235,7 +1234,7 @@ int main(int argc, char *argv[])
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	blkid_get_cache(&cache, NULL);
+	fsprobe_init();
 	PRS(argc, argv);
 
 	if (!notitle)
@@ -1304,6 +1303,6 @@ int main(int argc, char *argv[])
 	}
 	status |= wait_many(FLAG_WAIT_ALL);
 	free(fsck_path);
-	blkid_put_cache(cache);
+	fsprobe_exit();
 	return status;
 }
