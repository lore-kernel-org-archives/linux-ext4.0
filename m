From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] blkid: optimize dm_device_is_leaf() usage
Date: Tue, 26 Aug 2008 14:04:43 -0400
Message-ID: <20080826180443.GH8720@mit.edu>
References: <1219697316-5632-1-git-send-email-kzak@redhat.com> <20080826122405.GA8720@mit.edu> <20080826135102.GK6029@nb.net.home> <20080826144721.GD8720@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	mbroz@redhat.com, agk@redhat.com
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:33929 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758089AbYHZSEp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Aug 2008 14:04:45 -0400
Content-Disposition: inline
In-Reply-To: <20080826144721.GD8720@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here's the new patch.

						- Ted

commit 2e6c2735e19ec19821eeff1cbdf11c09c25540f0
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Tue Aug 26 08:13:56 2008 -0400

    libblkid: Optimize devicemapper support
    
    This commit works by removing all calls from libdevmapper altogether,
    and using the standard support for "normal" non-dm devices.
    
    It depends on dm devices being placed in /dev/mapper (but the previous
    code had this dependency anyway), and /proc/partitions containing dm
    devices.
    
    We don't actually rip out the libdevmapper code in this commit, but
    just disable it via #undef HAVE_DEVMAPPER, just so it's easier to
    review and understand the fundamental code changes.  A subsequent
    commit will remove the libdevmapper code, as well as unexport
    the blkid_devdirs string array.
    
    Thanks to Karel Zak for inspiring me to look at the dm code in blkid,
    so I could realize how much it deserved to ripped out by its roots.  :-)
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/lib/blkid/blkidP.h b/lib/blkid/blkidP.h
index dfe0eca..9d1e459 100644
--- a/lib/blkid/blkidP.h
+++ b/lib/blkid/blkidP.h
@@ -153,6 +153,13 @@ extern void blkid_debug_dump_dev(blkid_dev dev);
 extern void blkid_debug_dump_tag(blkid_tag tag);
 #endif
 
+/* devno.c */
+struct dir_list {
+	char	*name;
+	struct dir_list *next;
+};
+extern void blkid__scan_dir(char *, dev_t, struct dir_list **, char **);
+
 /* lseek.c */
 extern blkid_loff_t blkid_llseek(int fd, blkid_loff_t offset, int whence);
 
diff --git a/lib/blkid/devname.c b/lib/blkid/devname.c
index 86fd44c..ec3cff3 100644
--- a/lib/blkid/devname.c
+++ b/lib/blkid/devname.c
@@ -38,6 +38,8 @@
 
 #include "blkidP.h"
 
+#undef HAVE_DEVMAPPER
+
 #ifdef HAVE_DEVMAPPER
 #include <libdevmapper.h>
 #endif
@@ -122,6 +124,9 @@ blkid_dev blkid_get_dev(blkid_cache cache, const char *devname, int flags)
 static int dm_device_is_leaf(const dev_t dev);
 #endif
 
+/* Directories where we will try to search for device names */
+static const char *dirlist[] = { "/dev", "/devfs", "/devices", NULL };
+
 /*
  * Probe a single block device to add to the device cache.
  */
@@ -159,7 +164,7 @@ static void probe_one(blkid_cache cache, const char *ptname,
 	 * the stat information doesn't check out, use blkid_devno_to_devname()
 	 * to find it via an exhaustive search for the device major/minor.
 	 */
-	for (dir = blkid_devdirs; *dir; dir++) {
+	for (dir = dirlist; *dir; dir++) {
 		struct stat st;
 		char device[256];
 
@@ -174,6 +179,9 @@ static void probe_one(blkid_cache cache, const char *ptname,
 			break;
 		}
 	}
+	/* Do a short-cut scan of /dev/mapper first */
+	if (!devname)
+		blkid__scan_dir("/dev/mapper", devno, 0, &devname);
 	if (!devname) {
 		devname = blkid_devno_to_devname(devno);
 		if (!devname)
@@ -183,10 +191,14 @@ static void probe_one(blkid_cache cache, const char *ptname,
 	free(devname);
 
 set_pri:
-	if (!pri && !strncmp(ptname, "md", 2))
-		pri = BLKID_PRI_MD;
-	if (dev)
-		dev->bid_pri = pri;
+	if (dev) {
+		if (pri)
+			dev->bid_pri = pri;
+		else if (!strncmp(dev->bid_name, "/dev/mapper/", 11))
+			dev->bid_pri = BLKID_PRI_DM;
+		else if (!strncmp(ptname, "md", 2))
+			dev->bid_pri = BLKID_PRI_MD;
+ 	}
 	return;
 }
 
diff --git a/lib/blkid/devno.c b/lib/blkid/devno.c
index 61b34bf..1962c8d 100644
--- a/lib/blkid/devno.c
+++ b/lib/blkid/devno.c
@@ -33,11 +33,6 @@
 
 #include "blkidP.h"
 
-struct dir_list {
-	char	*name;
-	struct dir_list *next;
-};
-
 char *blkid_strndup(const char *s, int length)
 {
 	char *ret;
@@ -95,8 +90,8 @@ static void free_dirlist(struct dir_list **list)
 	*list = NULL;
 }
 
-static void scan_dir(char *dirname, dev_t devno, struct dir_list **list,
-			    char **devname)
+void blkid__scan_dir(char *dirname, dev_t devno, struct dir_list **list,
+		     char **devname)
 {
 	DIR	*dir;
 	struct dirent *dp;
@@ -127,7 +122,7 @@ static void scan_dir(char *dirname, dev_t devno, struct dir_list **list,
 				   path, *devname));
 			break;
 		}
-		if (S_ISDIR(st.st_mode) && !lstat(path, &st) && 
+		if (list && S_ISDIR(st.st_mode) && !lstat(path, &st) && 
 		    S_ISDIR(st.st_mode))
 			add_to_dirlist(path, list);
 	}
@@ -161,7 +156,7 @@ char *blkid_devno_to_devname(dev_t devno)
 
 		list = list->next;
 		DBG(DEBUG_DEVNO, printf("directory %s\n", current->name));
-		scan_dir(current->name, devno, &new_list, &devname);
+		blkid__scan_dir(current->name, devno, &new_list, &devname);
 		free(current->name);
 		free(current);
 		if (devname)
