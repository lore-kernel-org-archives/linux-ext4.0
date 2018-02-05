From: Tyson Nottingham <tgnottingham@gmail.com>
Subject: [PATCH v2] chattr/lsattr: update obsolete attribute support
Date: Mon,  5 Feb 2018 14:45:30 -0800
Message-ID: <1517870730-20883-1-git-send-email-tgnottingham@gmail.com>
Cc: tytso@mit.edu, Tyson Nottingham <tgnottingham@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:36329 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751671AbeBEWqG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Feb 2018 17:46:06 -0500
Received: by mail-pl0-f67.google.com with SMTP id v3so12771696plg.3
        for <linux-ext4@vger.kernel.org>; Mon, 05 Feb 2018 14:46:06 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Remove description of and printing of h, which was never visible to
  clients of the EXT4_IOC_GETFLAGS ioctl, including chattr and lsattr.

* Remove descriptions of X and Z, whose support was removed in
  4a05268cf86f713 (Remove compression support).

* Update a brief description of E, whose meaning was changed in
  22f22ab1d2bc5ae (Reserve the codepoints for the new INCOMPAT
  feature ENCRYPT).

* Add P to symbolic mode format string.

Signed-off-by: Tyson Nottingham <tgnottingham@gmail.com>
---

v2: Remove h flag support.

The one line summary for v1 was "chattr: update man page attribute
descriptions." The additions to the patch made that summary somewhat
inaccurate. Apologies for any confusion.

---
 lib/e2p/pf.c     |  1 -
 misc/chattr.1.in | 29 +++--------------------------
 2 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/lib/e2p/pf.c b/lib/e2p/pf.c
index b4a086f..f93f22f 100644
--- a/lib/e2p/pf.c
+++ b/lib/e2p/pf.c
@@ -43,7 +43,6 @@ static struct flags_name flags_array[] = {
 	{ EXT2_NOTAIL_FL, "t", "No_Tailmerging" },
 	{ EXT2_TOPDIR_FL, "T", "Top_of_Directory_Hierarchies" },
 	{ EXT4_EXTENTS_FL, "e", "Extents" },
-	{ EXT4_HUGE_FILE_FL, "h", "Huge_file" },
 	{ FS_NOCOW_FL, "C", "No_COW" },
 	{ EXT4_INLINE_DATA_FL, "N", "Inline_Data" },
 	{ EXT4_PROJINHERIT_FL, "P", "Project_Hierarchy" },
diff --git a/misc/chattr.1.in b/misc/chattr.1.in
index 6a1d446..fa53ee7 100644
--- a/misc/chattr.1.in
+++ b/misc/chattr.1.in
@@ -23,7 +23,7 @@ chattr \- change file attributes on a Linux file system
 .B chattr
 changes the file attributes on a Linux file system.
 .PP
-The format of a symbolic mode is +-=[aAcCdDeijsStTu].
+The format of a symbolic mode is +-=[aAcCdDeijPsStTu].
 .PP
 The operator '+' causes the selected attributes to be added to the
 existing attributes of the files; '-' causes them to be removed; and '='
@@ -49,12 +49,9 @@ and undeletable (u).
 The following attributes are read-only, and may be listed by
 .BR lsattr (1)
 but not modified by chattr:
-compression error (E),
-huge file (h),
+encrypted (E),
 indexed directory (I),
-inline data (N),
-compression raw access (X),
-and compressed dirty file (Z).
+and inline data (N).
 .PP
 Not all flags are supported or utilized by all filesystems; refer to
 filesystem-specific man pages such as
@@ -122,13 +119,6 @@ set or reset using
 although it can be displayed by
 .BR lsattr (1).
 .PP
-The 'h' attribute indicates the file is storing its blocks in units of the
-filesystem blocksize instead of in units of sectors, and means that the file
-is (or at one time was) larger than 2TB.  It may not be set or reset using
-.BR chattr (1),
-although it can be displayed by
-.BR lsattr (1).
-.PP
 A file with the 'i' attribute cannot be modified: it cannot be deleted or
 renamed, no link can be created to this file and no data can be written
 to the file.  Only the superuser or a process possessing the
@@ -192,19 +182,6 @@ saved.  This allows the user to ask for its undeletion.  Note: please
 make sure to read the bugs and limitations section at the end of this
 document.
 .PP
-The 'X' attribute is used by the experimental compression patches to
-indicate that the raw contents of a compressed file can be accessed
-directly.  It currently may not be set or reset using
-.BR chattr (1),
-although it can be displayed by
-.BR lsattr (1).
-.PP
-The 'Z' attribute is used by the experimental compression patches to
-indicate a compressed file is dirty.  It may not be set or reset using
-.BR chattr (1),
-although it can be displayed by
-.BR lsattr (1).
-.PP
 .SH AUTHOR
 .B chattr
 was written by Remy Card <Remy.Card@linux.org>.  It is currently being
-- 
2.7.4
