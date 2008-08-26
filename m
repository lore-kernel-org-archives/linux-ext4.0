From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] blkid: optimize dm_device_is_leaf() usage
Date: Tue, 26 Aug 2008 08:24:05 -0400
Message-ID: <20080826122405.GA8720@mit.edu>
References: <1219697316-5632-1-git-send-email-kzak@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:57554 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752926AbYHZMYI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Aug 2008 08:24:08 -0400
Content-Disposition: inline
In-Reply-To: <1219697316-5632-1-git-send-email-kzak@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Karel,

Thanks!  Your patch forced me to look much more closely at the device
mapper code, and after looking at it, I've been led to the inescapable
conclusion that the whole thing is total cr*p.  :-)

My only excuse was that at the time when I accepted the patch, I
wasn't using a device-mapper based system, and couldn't do live
testing of the code, so I didn't realize how much of what it was doing
was totally unnecessary.

What I've commited into the git tree completely rips out the need to
use the device mapper library, and instead relies on the already
existing and well-tested code paths that supports non-dm devices.
This has the nice side benefit that initrd's that want to use blkid
will no longer need to pull in libdevmapper, libselinux, and libsepol
--- or at least, if initrd's need them, it will no longer be on
/sbin/blkid's account.  And, we can yank all of the configure
machinery for including libdevmapper, et. al., from e2fsprogs.

It has an even more salutory performance benefit (about 3-6 times
faster than yours, I estimate, since we don't end up calling into
libdevmapper *at* *all*).  On an X61s laptop, with:

# for i in $(seq 1 100); do dmsetup create $i --table "0 1 zero"; done

old version:

# time /sbin/blkid >& /dev/null

real   0m4.227s
user   0m0.623s
sys    0m3.406s

new version:

# time ./misc/blkid >& /dev/null

real   0m0.080s
user   0m0.000s
sys    0m0.010s

						- Ted


commit 3f66ecf24e896377997b909edef040be98ac76b3
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Tue Aug 26 08:13:56 2008 -0400

    libblkid: Optimize devicemapper support
    
    This commit works by removing all calls from libdevicemapper
    altogether, and using the standard support for "normal" non-dm
    devices.
    
    It depends on dm devices being placed in /dev/mapper (but the previous
    code had this dependency anyway), and /proc/partitions containing dm
    devices.
    
    We don't actually rip out the libdevicemapper code in this commit, but
    just disable it via #undef HAVE_DEVMAPPER, just so it's easier to
    review and understand the changes that were made.  A subsequent commit
    will remove the libdevicemapper code, as well as unexport blkid_devdirs.
    
    Thanks to Karel Zak for inspiring me to look at the dm code in blkid,
    so I could realize how much it deserved to ripped out by its roots.  :-)
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/lib/blkid/devname.c b/lib/blkid/devname.c
index 86fd44c..5f9c228 100644
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
+static const char *dirlist[] = { "/dev", "/dev/mapper", "/devfs", "/devices", NULL };
+
 /*
  * Probe a single block device to add to the device cache.
  */
@@ -159,17 +164,17 @@ static void probe_one(blkid_cache cache, const char *ptname,
 	 * the stat information doesn't check out, use blkid_devno_to_devname()
 	 * to find it via an exhaustive search for the device major/minor.
 	 */
-	for (dir = blkid_devdirs; *dir; dir++) {
+	for (dir = dirlist; *dir; dir++) {
 		struct stat st;
 		char device[256];
 
-		sprintf(device, "%s/%s", *dir, ptname);
 		if ((dev = blkid_get_dev(cache, device, BLKID_DEV_FIND)) &&
 		    dev->bid_devno == devno)
 			goto set_pri;
 
 		if (stat(device, &st) == 0 && S_ISBLK(st.st_mode) && 
 		    st.st_rdev == devno) {
+			sprintf(device, "%s/%s", *dir, ptname);
 			devname = blkid_strdup(device);
 			break;
 		}
@@ -183,10 +188,14 @@ static void probe_one(blkid_cache cache, const char *ptname,
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
 
