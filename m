From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] blkid: optimize dm_device_is_leaf() usage
Date: Wed, 27 Aug 2008 00:40:54 -0400
Message-ID: <20080827044054.GE29936@mit.edu>
References: <1219697316-5632-1-git-send-email-kzak@redhat.com> <20080826122405.GA8720@mit.edu> <20080826135102.GK6029@nb.net.home> <20080826144721.GD8720@mit.edu> <20080826204737.GM6029@nb.net.home> <20080826233224.GB29936@mit.edu> <20080827001942.GN6029@nb.net.home> <20080827012121.GD29936@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	mbroz@redhat.com, agk@redhat.com
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:42663 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750903AbYH0Ek5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 00:40:57 -0400
Content-Disposition: inline
In-Reply-To: <20080827012121.GD29936@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I think we can ignore this minor problem for now. I'll try to found a
> better solution for dependencies resolution without libdevmapper. My
> wish is to avoid libdevmapper in libfsprobe.

Here's a patch that I've been working on which gives a priority bonus
to dm leaf devices, without needing libdevmapper.  As I've mentioned
before, I'm not 100% convinced this is always the right thing.  But
it's probably a not-half-bad hueristic...

						- Ted

diff --git a/lib/blkid/devname.c b/lib/blkid/devname.c
index 48a1dcc..2b3855b 100644
--- a/lib/blkid/devname.c
+++ b/lib/blkid/devname.c
@@ -25,6 +25,7 @@
 #if HAVE_SYS_TYPES_H
 #include <sys/types.h>
 #endif
+#include <dirent.h>
 #if HAVE_SYS_STAT_H
 #include <sys/stat.h>
 #endif
@@ -117,6 +118,38 @@ blkid_dev blkid_get_dev(blkid_cache cache, const char *devname, int flags)
 /* Directories where we will try to search for device names */
 static const char *dirlist[] = { "/dev", "/devfs", "/devices", NULL };
 
+static int is_dm_leaf(const char *devname)
+{
+	struct dirent	*de, *d_de;
+	DIR		*dir, *d_dir;
+	char		path[256];
+	int		ret = 1;
+
+	if ((dir = opendir("/sys/block")) == NULL)
+		return 0;
+	while ((de = readdir(dir)) != NULL) {
+		if (!strcmp(de->d_name, ".") || !strcmp(de->d_name, "..") ||
+		    !strcmp(de->d_name, devname) ||
+		    strncmp(de->d_name, "dm-", 3) ||
+		    strlen(de->d_name) > sizeof(path)-32)
+			continue;
+		sprintf(path, "/sys/block/%s/slaves", de->d_name);
+		if ((d_dir = opendir(path)) == NULL)
+			continue;
+		while ((d_de = readdir(d_dir)) != NULL) {
+			if (!strcmp(d_de->d_name, devname)) {
+				ret = 0;
+				break;
+			}
+		}
+		closedir(d_dir);
+		if (!ret)
+			break;
+	}
+	closedir(dir);
+	return ret;
+}
+
 /*
  * Probe a single block device to add to the device cache.
  */
@@ -180,9 +213,11 @@ set_pri:
 	if (dev) {
 		if (pri)
 			dev->bid_pri = pri;
-		else if (!strncmp(dev->bid_name, "/dev/mapper/", 11))
+		else if (!strncmp(dev->bid_name, "/dev/mapper/", 11)) {
 			dev->bid_pri = BLKID_PRI_DM;
-		else if (!strncmp(ptname, "md", 2))
+			if (is_dm_leaf(ptname))
+				dev->bid_pri += 5;
+		} else if (!strncmp(ptname, "md", 2))
 			dev->bid_pri = BLKID_PRI_MD;
  	}
 	return;
@@ -198,7 +233,6 @@ set_pri:
  * safe thing to do?)
  */
 #ifdef VG_DIR
-#include <dirent.h>
 static dev_t lvm_get_devno(const char *lvm_device)
 {
 	FILE *lvf;
