From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Is e2fsprogs-lustre_ismounted.patch actually needed?
Date: Sun, 08 Oct 2006 15:50:42 -0400
Message-ID: <E1GWefa-0000r5-L8@candygram.thunk.org>
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39086 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1751371AbWJHTup (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 8 Oct 2006 15:50:45 -0400
To: Andreas Dilger <adilger@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Hey Andreas,

	I've been reviewing some of your patches that you've submitted,
and I came across e2fsprogs-lustre_ismounted.patch.  It violated a
number of basic libext2fs rules, such as never calling printf/fprintf
from inside a libext2fs routine, and using a non-standard return code
convention.  So I started reworking it so it would be acceptable, and
then I realized it defined two new static functions, neither of which
were actually used in the patch.

	I hooked the patch into the appropriate place, and was going to
send it to you for review and testing, since I don't have a Lustre
system to play with, when I came to my second realization --- perhaps
the reason why it was never linked is because it isn't needed any more!
At least in 2.6 kernels, hopefully devices which are in use by Lustre
should be marked as busy, so that when they are opened O_EXCL, the
kernel should return EBUSY --- and that should be enough for e2fsprogs
without needing to use all sorts of complicated Lustre-specific code,
right?

	So could you verify for me that without applying the patch
below, that if you build tst_ismounted, and run it on a device which is
currently in use by Lustre, that it is reporting the device to be busy
(EXT2_MF_BUSY).  And if not, would you agree that is a bug that should
be fixed in the Lustre code?

	If for some reason there is a good reason why Lustre isn't
marking the device as busy, then we can look at the attached patch, but
hopefully it isn't required at all.

	Regards,

						- Ted

--------------
Add checks to see if the partition is in use by Lustre

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>


diff -r 32c7d2357ee2 lib/ext2fs/ismounted.c
--- a/lib/ext2fs/ismounted.c	Wed Oct 04 09:12:35 2006 -0400
+++ b/lib/ext2fs/ismounted.c	Sun Oct 08 15:03:22 2006 -0400
@@ -30,6 +30,8 @@
 #endif /* HAVE_GETMNTINFO */
 #include <string.h>
 #include <sys/stat.h>
+#include <sys/types.h>
+#include <dirent.h>
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
@@ -276,6 +278,109 @@ static int is_swap_device(const char *fi
 	return ret;
 }
 
+/*
+ * Check to see if filesystem is in use by Lustre
+ */
+static errcode_t check_if_lustre_busy(const char *devname, int *mount_flags)
+{
+	errcode_t	retval = 0;
+	struct dirent	*direntp;
+	const char	*procname;
+	char		*ptr, *mnt_device = 0, *proc_val = 0;
+	char		*real_devname = 0, *real_mnt_device = 0;
+	DIR		*dirp;
+	int		fd, numr;
+
+	procname = "/proc/fs/lustre/obdfilter";
+	dirp = opendir(procname);
+	if (!dirp) {
+		procname = "/proc/fs/lustre/mds";
+		dirp = opendir(procname);
+	}
+	if (!dirp)
+		return 0;
+
+	retval = ENOMEM;
+	if ((real_devname = malloc(PATH_MAX)) == NULL)
+		goto out;
+	if ((mnt_device = malloc(PATH_MAX)) == NULL)
+		goto out;
+	if ((proc_val = malloc(PATH_MAX)) == NULL)
+		goto out;
+	if ((real_mnt_device = malloc(PATH_MAX)) == NULL)
+		goto out;
+
+	if (realpath(devname, real_devname) == NULL) {
+		retval = errno;
+		goto out;
+	}
+
+	while ((direntp = readdir(dirp)) != NULL) {
+		if ((strncmp(direntp->d_name, ".", 1) == 0) ||
+		    (strncmp(direntp->d_name, "..", 2) == 0)) {
+			continue;
+		}
+
+		memset(proc_val, 0, PATH_MAX);
+		snprintf(proc_val, PATH_MAX, "%s/%s/mntdev", procname,
+			 direntp->d_name);
+		fd = open(proc_val, O_RDONLY);
+		if (fd < 0)  {
+			if (errno == ENOENT || errno == ENOTDIR)
+				continue;
+			retval = errno;
+			goto out;
+		}
+
+		memset(mnt_device, 0, PATH_MAX);
+		numr = 0;
+		ptr = mnt_device;
+		do {
+			numr = read(fd, ptr, PATH_MAX);
+			if (numr < 0) {
+				retval = errno;
+				close(fd);
+				goto out;
+			}
+			ptr += numr;
+		} while (numr != 0);
+		close(fd);
+
+		ptr = strchr(mnt_device, '\n');
+		if (ptr)
+			*ptr = '\0';
+
+		memset(real_mnt_device, 0, PATH_MAX);
+		if (realpath(mnt_device, real_mnt_device) == NULL) {
+			retval = errno;
+			goto out;
+		}
+
+		if (strcmp(real_devname, real_mnt_device) == 0) {
+#ifdef DEBUG
+			fprintf(stderr,
+				"device %s mounted by lustre per %s\n",
+				real_devname, proc_val);
+#endif
+			*mount_flags = EXT2_MF_BUSY;
+			retval = 0;
+			goto out;
+		}
+	}
+
+out:
+	if (proc_val)
+		free(proc_val);
+	if (mnt_device)
+		free(mnt_device);
+	if (real_mnt_device)
+		free(real_mnt_device);
+	if (dirp)
+		closedir(dirp);
+
+	return retval;
+}
+
 
 /*
  * ext2fs_check_mount_point() fills determines if the device is
@@ -327,7 +432,10 @@ errcode_t ext2fs_check_mount_point(const
 		close(fd);
 #endif
 
-	return 0;
+	if (*mount_flags == 0) 
+		retval = check_if_lustre_busy(device, mount_flags);
+
+	return retval;
 }
 
 /*

