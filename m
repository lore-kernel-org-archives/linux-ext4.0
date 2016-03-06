From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 4/6] lsattr: treat inode generation as an unsigned int
Date: Sat,  5 Mar 2016 17:38:34 -0700
Message-ID: <1457224716-72388-4-git-send-email-adilger@dilger.ca>
References: <1457224716-72388-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.13]:33815 "EHLO
	smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbcCFAqc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Mar 2016 19:46:32 -0500
In-Reply-To: <1457224716-72388-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The EXT2_GETVERSION ioctl is defined to take a "long" parameter, but
fgetversion() calls ioctl() with an "int" parameter instead.  This is
handled in the kernel correctly, but the generation is sign-extended
in fgetversion() before return on 64-bit systems and lsattr prints
it as a huge positive number for inode generation above 0x80000000:

        1635574212 -------------e-- /mnt/ost0/O/0/d0/12928
        18446744073045131735 -------------e-- /mnt/ost0/O/0/d0/166240
        782808861 -------------e-- /mnt/ost0/O/0/d0/31744
        18446744072181134840 -------------e-- /mnt/ost0/O/0/d0/135008

Correctly assign the returned generation number as an unsigned value,
and print it with a 10-character field width.  The version is printed
left-aligned for consistency with the old code and to ensure it is
always printed in the first column for use with tools like "cut":

        1635574212 -------------e-- /mnt/ost0/O/0/d0/12928
        3630547415 -------------e-- /mnt/ost0/O/0/d0/166240
        782808861  -------------e-- /mnt/ost0/O/0/d0/31744
        2766550520 -------------e-- /mnt/ost0/O/0/d0/135008

Do not return a random value from the stack as the version on error.
Clean up some style issues and consolidate some duplicate code.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 lib/e2p/fgetversion.c | 36 +++++++++++++++++++-----------------
 misc/lsattr.c         |  2 +-
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/lib/e2p/fgetversion.c b/lib/e2p/fgetversion.c
index e6cee8b..2ad813b 100644
--- a/lib/e2p/fgetversion.c
+++ b/lib/e2p/fgetversion.c
@@ -37,32 +37,34 @@
 #define OPEN_FLAGS (O_RDONLY|O_NONBLOCK)
 #endif
 
-int fgetversion (const char * name, unsigned long * version)
+int fgetversion(const char *name, unsigned long *version)
 {
+	unsigned int ver = -1;
+	int rc = -1;
 #if HAVE_EXT2_IOCTLS
-#if !APPLE_DARWIN
-	int fd, r, ver, save_errno = 0;
+# if !APPLE_DARWIN
+	int fd, save_errno = 0;
 
-	fd = open (name, OPEN_FLAGS);
+	fd = open(name, OPEN_FLAGS);
 	if (fd == -1)
 		return -1;
-	r = ioctl (fd, EXT2_IOC_GETVERSION, &ver);
-	if (r == -1)
+
+	rc = ioctl(fd, EXT2_IOC_GETVERSION, &ver);
+	if (rc == -1)
 		save_errno = errno;
-	*version = ver;
-	close (fd);
-	if (save_errno)
+	close(fd);
+	if (rc == -1)
 		errno = save_errno;
-	return r;
-#else
-   int ver=-1, err;
-   err = syscall(SYS_fsctl, name, EXT2_IOC_GETVERSION, &ver, 0);
-   *version = ver;
-   return(err);
-#endif
+# else /* APPLE_DARWIN */
+	rc = syscall(SYS_fsctl, name, EXT2_IOC_GETVERSION, &ver, 0);
+# endif /* !APPLE_DARWIN */
 #else /* ! HAVE_EXT2_IOCTLS */
 	extern int errno;
+
 	errno = EOPNOTSUPP;
-	return -1;
 #endif /* ! HAVE_EXT2_IOCTLS */
+	if (rc == 0)
+		*version = ver;
+
+	return rc;
 }
diff --git a/misc/lsattr.c b/misc/lsattr.c
index e5e5969..4c34e2f 100644
--- a/misc/lsattr.c
+++ b/misc/lsattr.c
@@ -92,7 +92,7 @@ static int list_attributes (const char * name)
 				 name);
 			return -1;
 		}
-		printf ("%5lu ", generation);
+		printf ("%-10lu ", generation);
 	}
 	if (pf_options & PFOPT_LONG) {
 		printf("%-28s ", name);
-- 
1.8.0

