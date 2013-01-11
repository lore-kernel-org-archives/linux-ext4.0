From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] debugfs: document zap_block & dump_block
Date: Fri, 11 Jan 2013 11:40:25 -0600
Message-ID: <50F04E89.7070501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886Ab3AKSiw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Jan 2013 13:38:52 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0BIcqXS029864
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2013 13:38:52 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r0BHePbv020618
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2013 12:40:32 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

What little docs there were had a cut & paste error.
We can do better. :)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/debugfs/debug_cmds.ct b/debugfs/debug_cmds.ct
index 520933a..9a05ef7 100644
--- a/debugfs/debug_cmds.ct
+++ b/debugfs/debug_cmds.ct
@@ -181,10 +181,10 @@ request do_set_mmp_value, "Set MMP value",
 request do_extent_open, "Open inode for extent manipulation",
 	extent_open, eo;
 
-request do_zap_block, "Zap block",
+request do_zap_block, "Zap block: fill with 0, pattern, flip bits etc.",
 	zap_block, zap;
 
-request do_dump_block, "Zap block",
+request do_dump_block, "Dump contents of a block",
 	block_dump, bp;
 
 end;
diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
index bfcb1a8..4164c3a 100644
--- a/debugfs/debugfs.8.in
+++ b/debugfs/debugfs.8.in
@@ -215,6 +215,10 @@ option is given set the owner, group and permissions information on
 to match 
 .IR filespec .
 .TP
+.I dump_block [-f out_file] block_num
+Dump the contents of a block, optionally to
+.IR out_file .
+.TP
 .I dump_mmp
 Display the multiple-mount protection (mmp) field values.
 .TP
@@ -612,6 +616,14 @@ Create a file in the filesystem named
 and copy the contents of
 .I source_file
 into the destination file.
+.TP
+.I zap_block [-f file] [-o offset] [-l length] [-p pattern] block_num
+Zero, or pattern-fill, portions of a block within a file or
+within the filesystem.
+.TP
+.I zap_block [-f file] [-b bit] block_num
+Bit-flip portions of a block within a file or
+within the filesystem.
 .SH ENVIRONMENT VARIABLES
 .TP
 .B DEBUGFS_PAGER, PAGER

