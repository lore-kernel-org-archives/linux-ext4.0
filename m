From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/2 V2] e2fsprogs: reorder flags in chattr(1)
Date: Thu, 19 Jun 2014 18:17:49 -0500
Message-ID: <53A36F9D.3010803@redhat.com>
References: <53A36F0E.6090105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965467AbaFSXRu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jun 2014 19:17:50 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s5JNHo3v025894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 19 Jun 2014 19:17:50 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s5JNHniG015037
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 19 Jun 2014 19:17:50 -0400
In-Reply-To: <53A36F0E.6090105@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The flags described in chattr usage() and the chattr(1) manpage
were in semi-random order, which makes it hard to ascertain
which flags might be missing or undocumented, and to locate
flags within the manpage.

Re-order the list of flags in alphanumeric order, and do
the same for the flag descriptions in the body of the manpage.

There should be no content changes here, just reordering
for consistency.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: remove duplicate line in usage()!
(why do I only spot these things immediately after I hit send?)

diff --git a/misc/chattr.1.in b/misc/chattr.1.in
index 2a3640c..ce426e8 100644
--- a/misc/chattr.1.in
+++ b/misc/chattr.1.in
@@ -19,24 +19,36 @@ chattr \- change file attributes on a Linux file system
 .B chattr
 changes the file attributes on a Linux file system.
 .PP
-The format of a symbolic mode is +-=[acdeijstuACDST].
+The format of a symbolic mode is +-=[aAcCdDeijsStTu].
 .PP
 The operator `+' causes the selected attributes to be added to the
 existing attributes of the files; `-' causes them to be removed; and
 `=' causes them to be the only attributes that the files have.
 .PP
-The letters `acdeijstuACDST' select the new attributes for the files:
-append only (a), compressed (c), no dump (d), extent format (e), immutable (i),
-data journalling (j), secure deletion (s), no tail-merging (t),
-undeletable (u), no atime updates (A), no copy on write (C),
-synchronous directory updates (D), synchronous updates (S),
-and top of directory hierarchy (T).
+The letters `aAcCdDeijsStTu' select the new attributes for the files:
+append only (a),
+no atime updates (A),
+compressed (c),
+no copy on write (C),
+no dump (d),
+synchronous directory updates (D),
+extent format (e),
+immutable (i),
+data journalling (j),
+secure deletion (s),
+synchronous updates (S),
+no tail-merging (t),
+top of directory hierarchy (T),
+and undeletable (u).
 .PP
 The following attributes are read-only, and may be listed by
 .BR lsattr (1)
-but not modified by chattr: huge file (h), compression error (E),
-indexed directory (I), compression raw access (X), and compressed dirty
-file (Z).
+but not modified by chattr:
+compression error (E),
+huge file (h),
+indexed directory (I),
+compression raw access (X),
+and compressed dirty file (Z).
 .SH OPTIONS
 .TP
 .B \-R
@@ -51,14 +63,14 @@ Suppress most error messages.
 .BI \-v " version"
 Set the file's version/generation number.
 .SH ATTRIBUTES
-When a file with the 'A' attribute set is accessed, its atime record is
-not modified.  This avoids a certain amount of disk I/O for laptop
-systems.
-.PP
 A file with the `a' attribute set can only be open in append mode for writing.
 Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE
 capability can set or clear this attribute.
 .PP
+When a file with the 'A' attribute set is accessed, its atime record is
+not modified.  This avoids a certain amount of disk I/O for laptop
+systems.
+.PP
 A file with the `c' attribute set is automatically compressed on the disk
 by the kernel.  A read from this file returns uncompressed data.  A write to
 this file compresses data before storing them on the disk.  Note: please
@@ -74,27 +86,21 @@ be fully stable.  If the 'C' flag is set on a directory, it will have no
 effect on the directory, but new files created in that directory will
 the No_COW attribute.)
 .PP
-When a directory with the `D' attribute set is modified,
-the changes are written synchronously on the disk; this is equivalent to
-the `dirsync' mount option applied to a subset of the files.
-.PP
 A file with the `d' attribute set is not candidate for backup when the
 .BR dump (8)
 program is run.
 .PP
-The 'E' attribute is used by the experimental compression patches to
-indicate that a compressed file has a compression error.  It may not be
-set or reset using
-.BR chattr (1),
-although it can be displayed by
-.BR lsattr (1).
+When a directory with the `D' attribute set is modified,
+the changes are written synchronously on the disk; this is equivalent to
+the `dirsync' mount option applied to a subset of the files.
 .PP
 The 'e' attribute indicates that the file is using extents for mapping
 the blocks on disk.  It may not be removed using
 .BR chattr (1).
 .PP
-The 'I' attribute is used by the htree code to indicate that a directory
-is being indexed using hashed trees.  It may not be set or reset using
+The 'E' attribute is used by the experimental compression patches to
+indicate that a compressed file has a compression error.  It may not be
+set or reset using
 .BR chattr (1),
 although it can be displayed by
 .BR lsattr (1).
@@ -111,6 +117,12 @@ renamed, no link can be created to this file and no data can be written
 to the file.  Only the superuser or a process possessing the
 CAP_LINUX_IMMUTABLE capability can set or clear this attribute.
 .PP
+The 'I' attribute is used by the htree code to indicate that a directory
+is being indexed using hashed trees.  It may not be set or reset using
+.BR chattr (1),
+although it can be displayed by
+.BR lsattr (1).
+.PP
 A file with the `j' attribute has all of its data written to the ext3
 or ext4 journal before being written to the file itself, if the filesystem
 is mounted with the "data=ordered" or "data=writeback" options.  When the
@@ -127,6 +139,13 @@ When a file with the `S' attribute set is modified,
 the changes are written synchronously on the disk; this is equivalent to
 the `sync' mount option applied to a subset of the files.
 .PP
+A file with the 't' attribute will not have a partial block fragment at
+the end of the file merged with other files (for those filesystems which
+support tail-merging).  This is necessary for applications such as LILO
+which read the filesystem directly, and which don't understand tail-merged
+files.  Note: As of this writing, the ext2 or ext3 filesystems do not
+(yet, except in very experimental patches) support tail-merging.
+.PP
 A directory with the 'T' attribute will be deemed to be the top of
 directory hierarchies for the purposes of the Orlov block allocator.
 This is a hint to the block allocator used by ext3 and ext4 that the
@@ -137,13 +156,6 @@ and /home/mary are placed into separate block groups.  For directories
 where this attribute is not set, the Orlov block allocator will try to
 group subdirectories closer together where possible.
 .PP
-A file with the 't' attribute will not have a partial block fragment at
-the end of the file merged with other files (for those filesystems which
-support tail-merging).  This is necessary for applications such as LILO
-which read the filesystem directly, and which don't understand tail-merged
-files.  Note: As of this writing, the ext2 or ext3 filesystems do not
-(yet, except in very experimental patches) support tail-merging.
-.PP
 When a file with the `u' attribute set is deleted, its contents are
 saved.  This allows the user to ask for its undeletion.  Note: please
 make sure to read the bugs and limitations section at the end of this
diff --git a/misc/chattr.c b/misc/chattr.c
index 39a6016..d5a6a61 100644
--- a/misc/chattr.c
+++ b/misc/chattr.c
@@ -83,7 +83,7 @@ static unsigned long sf;
 static void usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-RVf] [-+=AaCcDdeijsSu] [-v version] files...\n"),
+		_("Usage: %s [-RVf] [-+=aAcCdDeijsSu] [-v version] files...\n"),
 		program_name);
 	exit(1);
 }

