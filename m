From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][27/28] e2fsprogs-debugfs-supported_features.patch
Date: Sat, 02 Feb 2008 01:56:07 -0700
Message-ID: <20080202085607.GB31694@webber.adilger.int>
References: <20080202075943.GB23836@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:49959 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757613AbYBBI4K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2008 03:56:10 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m128uA61021750
	for <linux-ext4@vger.kernel.org>; Sat, 2 Feb 2008 00:56:10 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JVL00501SFKSW00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 02 Feb 2008 00:56:10 -0800 (PST)
In-reply-to: <20080202075943.GB23836@webber.adilger.int>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Print out the currently supported features of e2fsprogs/libext2fs
via a new "debugfs supported_features" command.

Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>

Index: e2fsprogs-1.40.2/debugfs/debug_cmds.ct
===================================================================
--- e2fsprogs-1.40.2.orig/debugfs/debug_cmds.ct
+++ e2fsprogs-1.40.2/debugfs/debug_cmds.ct
@@ -154,5 +154,8 @@ request	do_dump_unused, "Dump unused blo
 request do_set_current_time, "Set current time to use when setting filesystme fields",
 	set_current_time;
 
+request do_supported_features, "Print features supported by this version of e2fsprogs",
+	supported_features;
+
 end;
 
Index: e2fsprogs-1.40.2/debugfs/debugfs.c
===================================================================
--- e2fsprogs-1.40.2.orig/debugfs/debugfs.c
+++ e2fsprogs-1.40.2/debugfs/debugfs.c
@@ -1772,6 +1772,44 @@ void do_set_current_time(int argc, char 
 	}
 }
 
+void do_supported_features(int argc, char *argv[])
+{
+        FILE	*out = stdout;
+        int	i, j, ret;
+        __u32	supp[3] = { EXT2_LIB_FEATURE_COMPAT_SUPP,
+			    EXT2_LIB_FEATURE_INCOMPAT_SUPP,
+			    EXT2_LIB_FEATURE_RO_COMPAT_SUPP };
+	__u32	m;
+	int compat;
+	unsigned int feature_flag;
+
+	if (argc >= 1) {
+		ret = e2p_string2feature(argv[1], &compat, &feature_flag);
+		if (ret)
+			goto err;
+
+		if (!(supp[compat] & feature_flag))
+			goto err;
+
+		fprintf(out, "Supported feature: %s\n", argv[1]);
+	} else {
+		fprintf(out, "Supported features:");
+	        for (i = 0; i < 3; i++) {
+		        for (j = 0, m = 1; j < 32; j++, m <<= 1) {
+			        if (supp[i] & m)
+        			        fprintf(out, " %s",
+						e2p_feature2string(i, m));
+	        	}
+		}
+	        fprintf(out, "\n");
+	}
+
+	return;
+
+err:
+	com_err(argv[0], 0, "Unknown feature: %s\n", argv[1]);
+}
+
 static int source_file(const char *cmd_file, int sci_idx)
 {
 	FILE		*f;
Index: e2fsprogs-1.40.2/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs-1.40.2.orig/lib/ext2fs/ext2_fs.h
+++ e2fsprogs-1.40.2/lib/ext2fs/ext2_fs.h
@@ -656,8 +656,7 @@ struct ext2_super_block {
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
-					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE| \
-					 EXT2_FEATURE_RO_COMPAT_BTREE_DIR)
+					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE)
 
 /*
  * Default values for user and/or group using reserved blocks

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
