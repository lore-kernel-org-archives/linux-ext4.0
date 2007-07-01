From: Mingming Cao <cmm@us.ibm.com>
Subject: [EXT4 set 1][PATCH 1/2] Add noextents mount option
Date: Sun, 01 Jul 2007 03:35:48 -0400
Message-ID: <1183275348.4010.118.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add a mount option to turn off extents.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
Index: linux-2.6.22-rc4/fs/ext4/super.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/ext4/super.c	2007-06-11 17:02:18.000000000 -0700
+++ linux-2.6.22-rc4/fs/ext4/super.c	2007-06-11 17:02:22.000000000 -0700
@@ -725,7 +725,7 @@
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
-	Opt_grpquota, Opt_extents,
+	Opt_grpquota, Opt_extents, Opt_noextents,
 };
 
 static match_table_t tokens = {
@@ -776,6 +776,7 @@
 	{Opt_usrquota, "usrquota"},
 	{Opt_barrier, "barrier=%u"},
 	{Opt_extents, "extents"},
+	{Opt_noextents, "noextents"},
 	{Opt_err, NULL},
 	{Opt_resize, "resize"},
 };
@@ -1111,6 +1112,9 @@
 		case Opt_extents:
 			set_opt (sbi->s_mount_opt, EXTENTS);
 			break;
+		case Opt_noextents:
+			clear_opt (sbi->s_mount_opt, EXTENTS);
+			break;
 		default:
 			printk (KERN_ERR
 				"EXT4-fs: Unrecognized mount option \"%s\" "


