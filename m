From: TR Reardon <thomas_reardon@hotmail.com>
Subject: RE: possible different donor file naming in e4defrag
Date: Thu, 11 Sep 2014 18:49:07 -0400
Message-ID: <BAY179-W1E8676C4343760B6A8332FDCC0@phx.gbl>
References: <BLU436-SMTP2540BD5998FEB4A3695A2E4FDE90@phx.gbl>
 <20140815203909.GM2808@birch.djwong.org>
 <BAY179-W62818B481ECC21D8121A2FFDE90@phx.gbl>,<4DF4149D-9995-475D-B25E-DAE799DE6100@dilger.ca>
 <BAY179-W923915B59A3302CF7A1CB0FDCC0@phx.gbl>,<25905DD3-CD3E-42F2-A101-715E7C205CEB@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bay004-omc3s27.hotmail.com ([65.54.190.165]:57404 "EHLO
	BAY004-OMC3S27.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751105AbaIKWtI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 18:49:08 -0400
In-Reply-To: <25905DD3-CD3E-42F2-A101-715E7C205CEB@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Sep 11, 2014, at 1:48 PM, TR Reardon <thomas_reardon@hotmail.com> =
wrote:
>> Picking this back up. How would O_TMPFILE avoid races? It definitely=
 avoids the unwanted mtime/atime update, but then the existing "<filena=
me>.defrag" pseudo-lock file would no longer be available. How could yo=
u use O_TMPFILE and still avoid multiple defrag? If this isn't possible=
, then resetting the parent times on unlink(tmpfile), as you suggest, i=
s the simplest way out of this.
>
> Looking at this the opposite way - what are the chances that there
> will be concurrent defrags on the same file? Basically no chance at
> all. So long as it doesn't explode (the kernel would need to protect
> against this anyway to avoid malicious apps), the worst case is that
> there will be some extra defragmentation done in a very rare case.
>
> Conversely, creating a temporary filename and then resetting the
> parent directory timestamp is extra work for every file defragmented,
> and is racy because e4defrag may "reset" the time to before the temp
> file was created, but clobber a legitimate timestamp update in the
> directory from some other concurrent update. That timestamp update
> is always going to be racy, even if e4defrag tries to be careful.
>
> Cheers, Andreas


Thanks, well described.

So a simple attempt with O_TMPFILE first, then revert to original behav=
ior, like below?


diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index d0eac60..8001182 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -40,6 +40,7 @@
=A0#include <sys/stat.h>
=A0#include <sys/statfs.h>
=A0#include <sys/vfs.h>
+#include <libgen.h>
=A0
=A0/* A relatively new ioctl interface ... */
=A0#ifndef EXT4_IOC_MOVE_EXT
@@ -1526,31 +1527,36 @@ static int file_defrag(const char *file, const =
struct stat64 *buf,
=A0
=A0	/* Create donor inode */
=A0	memset(tmp_inode_name, 0, PATH_MAX + 8);
-	sprintf(tmp_inode_name, "%.*s.defrag",
-				(int)strnlen(file, PATH_MAX), file);
-	donor_fd =3D open64(tmp_inode_name, O_WRONLY | O_CREAT | O_EXCL, S_IR=
USR);
+	/* Try O_TMPFILE first, to avoid changing directory mtime */
+	sprintf(tmp_inode_name, "%.*s", (int)strnlen(file, PATH_MAX), file);
+	donor_fd =3D open64(dirname(tmp_inode_name), O_TMPFILE | O_WRONLY | O=
_EXCL, S_IRUSR | S_IWUSR );
=A0	if (donor_fd < 0) {
-		if (mode_flag & DETAIL) {
-			PRINT_FILE_NAME(file);
-			if (errno =3D=3D EEXIST)
-				PRINT_ERR_MSG_WITH_ERRNO(
-				"File is being defraged by other program");
-			else
-				PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_OPEN);
+		sprintf(tmp_inode_name, "%.*s.defrag",
+					(int)strnlen(file, PATH_MAX), file);
+		donor_fd =3D open64(tmp_inode_name, O_WRONLY | O_CREAT | O_EXCL, S_I=
RUSR);
+		if (donor_fd < 0) {
+			if (mode_flag & DETAIL) {
+				PRINT_FILE_NAME(file);
+				if (errno =3D=3D EEXIST)
+					PRINT_ERR_MSG_WITH_ERRNO(
+					"File is being defraged by other program");
+				else
+					PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_OPEN);
+			}
+			goto out;
=A0		}
-		goto out;
-	}
=A0
-	/* Unlink donor inode */
-	ret =3D unlink(tmp_inode_name);
-	if (ret < 0) {
-		if (mode_flag & DETAIL) {
-			PRINT_FILE_NAME(file);
-			PRINT_ERR_MSG_WITH_ERRNO("Failed to unlink");
+		/* Unlink donor inode */
+		ret =3D unlink(tmp_inode_name);
+		if (ret < 0) {
+			if (mode_flag & DETAIL) {
+				PRINT_FILE_NAME(file);
+				PRINT_ERR_MSG_WITH_ERRNO("Failed to unlink");
+			}
+			goto out;
=A0		}
-		goto out;
=A0	}
