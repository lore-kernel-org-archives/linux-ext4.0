From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: add supported file attributes to ext4.5 manpage
Date: Wed, 20 Aug 2014 13:02:50 -0500
Message-ID: <53F4E2CA.80004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbaHTSCt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Aug 2014 14:02:49 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s7KI2lu9014559
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2014 14:02:48 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s7KI2kKY012643
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2014 14:02:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The chattr(1) manpage now refers users to filesystem-specific
manpages for details on supported attributes, so add those to
ext4.5.

I've left out oddities like being able to set the compressed
or no-tail-packing flags, or setting data journaling on ext2.

That behavior seems like a bug, not a feature.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Sorry, thought I had sent this earlier, but I guess I didn't.

diff --git a/misc/ext4.5.in b/misc/ext4.5.in
index ca197cb..19302a7 100644
--- a/misc/ext4.5.in
+++ b/misc/ext4.5.in
@@ -611,6 +611,37 @@ seriously cramp the system's style.)
 .B i_version
 Enable 64-bit inode version support. This option is off by default.
 
+.SH FILE ATTRIBUTES
+The ext2, ext3, and ext4 filesystems support setting the following file
+attributes on Linux systems using the
+.BR chattr (1)
+utility:
+.sp
+.BR a " - append only"
+.sp
+.BR A " - no atime updates"
+.sp
+.BR d " - no dump"
+.sp
+.BR D " - synchronous directory updates"
+.sp
+.BR i " - immutable"
+.sp
+.BR S " - synchronous updates"
+.sp
+.BR u " - undeletable"
+.sp
+In addition, the ext3 and ext4 filesystems support the following flag:
+.sp
+.BR j " - data journaling"
+.sp
+Finally, the ext4 filesystem also supports the following flag:
+.sp
+.BR e " - extents format"
+.sp
+For descriptions of these attribute flags, please refer to the
+.BR chattr (1)
+man page.
 .SH SEE ALSO
 .BR mke2fs (8),
 .BR mke2fs.conf (5),
@@ -618,4 +649,5 @@ Enable 64-bit inode version support. This option is off by default.
 .BR dumpe2fs (8),
 .BR tune2fs (8),
 .BR debugfs (8),
-.BR mount (8)
+.BR mount (8),
+.BR chattr (1)

