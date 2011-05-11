From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] debugfs: document htree-related commands in man page
Date: Wed, 11 May 2011 11:49:07 -0500
Message-ID: <4DCABE03.7040300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558Ab1EKR17 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 May 2011 13:27:59 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p4BHRvJw030883
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 11 May 2011 13:27:59 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p4BGn749020147
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 11 May 2011 12:49:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The debugfs commands dirsearch, dx_hash, and htree_dump were
never documented in the man page.  Do so.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Please feel free to check my manpage-fu, as well as checking
for accurate descriptions of these commands, thanks...

diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
index 41c73fd..f5deb7a 100644
--- a/debugfs/debugfs.8.in
+++ b/debugfs/debugfs.8.in
@@ -187,6 +187,12 @@ master superblock.
 Clear the contents of the inode 
 .IR file .
 .TP
+.I dirsearch filespec filename
+Search the directory
+.I filespec
+for
+.IR filename .
+.TP
 .I dump [-p] filespec out_file
 Dump the contents of the inode 
 .I filespec
@@ -199,6 +205,16 @@ option is given set the owner, group and permissions information on
 to match 
 .IR filespec .
 .TP
+.I dx_hash [-h hash_alg] [-s hash_seed] filename
+Calculate the directory hash of
+.IR filename .
+The hash algorithm specified with
+.I -h
+may be "legacy" "half_md4" or "tea".
+The hash seed specified with
+.I -s
+must be in UUID format.
+.TP
 .I dump_extents [-n] [-l] filespec
 Dump the the extent tree of the inode
 .IR filespec .
@@ -264,6 +280,11 @@ Free the inode specified by
 Print a list of commands understood by 
 .BR debugfs .
 .TP
+.I htree_dump filespec
+Dump the hash-indexed directory
+.IR filespec ,
+showing its tree structure.
+.TP
 .I icheck block ...
 Print a listing of the inodes which use the one or more blocks specified
 on the command line.

