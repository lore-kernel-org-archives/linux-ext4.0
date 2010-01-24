From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mke2fs: fix up topo complaints on regular files
Date: Sat, 23 Jan 2010 21:50:45 -0600
Message-ID: <4B5BC395.2050805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab0AXDut (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Jan 2010 22:50:49 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0O3ombq021235
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Sat, 23 Jan 2010 22:50:49 -0500
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o0O3oi6u006941
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 23 Jan 2010 22:50:48 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

mkfsing a plain file would lead to a warning about being unable
to determine geometry; we should just skip the topology-getting
if we see that we have a regular file.

This was breaking "make check" but I had missed it since I
inadvertently stopped running the checks during the Fedora
RPM build.

Also, add a newline to the warning.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 94b4c81..81b34ab 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -47,6 +47,7 @@ extern int optind;
 #endif
 #include <sys/ioctl.h>
 #include <sys/types.h>
+#include <sys/stat.h>
 #include <libgen.h>
 #include <limits.h>
 #include <blkid/blkid.h>
@@ -1035,6 +1036,11 @@ static int ext2fs_get_device_geometry(const char *file,
 	blkid_topology tp;
 	unsigned long min_io;
 	unsigned long opt_io;
+	struct stat statbuf;
+
+	/* Nothing to do for a regular file */
+	if (!stat(file, &statbuf) && S_ISREG(statbuf.st_mode))
+		return 0;
 
 	pr = blkid_new_probe_from_filename(file);
 	if (!pr)
@@ -1630,7 +1636,7 @@ got_size:
 	retval = ext2fs_get_device_geometry(device_name, &fs_param);
 	if (retval < 0) {
 		fprintf(stderr,
-			_("warning: Unable to get device geometry for %s"),
+			_("warning: Unable to get device geometry for %s\n"),
 			device_name);
 	} else if (retval) {
 		printf(_("%s alignment is offset by %lu bytes.\n"),

