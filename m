From: Tyson Nottingham <tgnottingham@gmail.com>
Subject: [PATCH] chattr: update man page attribute descriptions.
Date: Tue, 23 Jan 2018 19:23:34 -0800
Message-ID: <1516764214-27295-1-git-send-email-tgnottingham@gmail.com>
Cc: tytso@mit.edu, Tyson Nottingham <tgnottingham@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33502 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752009AbeAXDXj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jan 2018 22:23:39 -0500
Received: by mail-pf0-f196.google.com with SMTP id t5so2006520pfi.0
        for <linux-ext4@vger.kernel.org>; Tue, 23 Jan 2018 19:23:39 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Remove descriptions of X and Z, whose support was removed in
  4a05268cf86f713 (Remove compression support).

* Update a brief description of E, whose meaning was changed in
  22f22ab1d2bc5ae (Reserve the codepoints for the new INCOMPAT
  feature ENCRYPT).

* Add P to symbolic mode format string.

Signed-off-by: Tyson Nottingham <tgnottingham@gmail.com>
---
 misc/chattr.1.in | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/misc/chattr.1.in b/misc/chattr.1.in
index 6a1d446..cf9cb11 100644
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
@@ -49,12 +49,10 @@ and undeletable (u).
 The following attributes are read-only, and may be listed by
 .BR lsattr (1)
 but not modified by chattr:
-compression error (E),
+encrypted (E),
 huge file (h),
 indexed directory (I),
-inline data (N),
-compression raw access (X),
-and compressed dirty file (Z).
+and inline data (N).
 .PP
 Not all flags are supported or utilized by all filesystems; refer to
 filesystem-specific man pages such as
@@ -192,19 +190,6 @@ saved.  This allows the user to ask for its undeletion.  Note: please
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
