From: Mingming Cao <cmm@us.ibm.com>
Subject: [EXT4 set 1][PATCH 2/2] Enable extents by default for ext4dev
Date: Sun, 01 Jul 2007 03:36:01 -0400
Message-ID: <1183275361.4010.119.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Turn on extents feature by default in ext4 filesystem. User could use
-o noextents to turn it off.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>

Index: linux-2.6.22-rc4/fs/ext4/super.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/ext4/super.c	2007-06-11 17:02:22.000000000 -0700
+++ linux-2.6.22-rc4/fs/ext4/super.c	2007-06-11 17:03:09.000000000 -0700
@@ -1546,6 +1546,12 @@
 
 	set_opt(sbi->s_mount_opt, RESERVATION);
 
+	/*
+	 * turn on extents feature by default in ext4 filesystem
+	 * User -o noextents to turn it off
+	 */
+	set_opt (sbi->s_mount_opt, EXTENTS);
+
 	if (!parse_options ((char *) data, sb, &journal_inum, &journal_devnum,
 			    NULL, 0))
 		goto failed_mount;


