From: David Turner <novalis@novalis.org>
Subject: [PATCH v7 2/2] debugfs: Decode {a,c,cr,m}time_extra fields in stat
Date: Sat, 07 Dec 2013 15:02:45 -0500
Message-ID: <1386446565.10748.6.camel@chiang>
References: <1383808590.23882.13.camel@chiang>
	 <20131107160341.GA3850@quack.suse.cz> <1383864864.23882.33.camel@chiang>
	 <20131107231445.GG2054@quack.suse.cz> <1383866807.23882.41.camel@chiang>
	 <D8C465B6-15A7-473A-BA26-8037AF9CE739@dilger.ca>
	 <1383981551.8994.27.camel@chiang>
	 <CADQUmxULoLgXRyoPpJJMJLqJPsZ8M4oPP8ScGxWp+Np8-efq3g@mail.gmail.com>
	 <1384070214.8994.47.camel@chiang> <20131112003018.GA30281@thunk.org>
	 <6DE0AF86-98E6-4DE9-BB7F-40FB32E1BC26@dilger.ca>
	 <1384326020.8994.186.camel@chiang>
	 <276FA06E-1EE0-4FB4-94E1-B6D9F05F0B5B@dilger.ca>
	 <1384418641.1957.1.camel@chiang>
	 <CADQUmxVEyV796xTuy6LytketqEDsCQYH0vOpH79FSfo9mhgsEw@mail.gmail.com>
	 <1384463193.1957.27.camel@chiang> <1385762083.20396.48.camel@chiang>
	 <B3592308-F3D8-4887-AF52-812EA988410E@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Mark Harris <mhlk@osj.us>, Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from caiajhbdccac.dreamhost.com ([208.97.132.202]:52795 "EHLO
	homiemail-a100.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759026Ab3LGUCr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Dec 2013 15:02:47 -0500
In-Reply-To: <B3592308-F3D8-4887-AF52-812EA988410E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Decodes post-2038 dates correctly on on machines with a 64-bit time_t.
When decoding dates from xtime+xtime_extra fields, we assume that
these dates are in the correct format (i.e. pre-1970 dates have
xtime_extra low bits == 0 instead of 3).  So uncorrected pre-1970
dates will be displayed as post-2310 dates.  This is because we don't
want our filesystem debugging tools to silently correct data errors.

Signed-off-by: David Turner <novalis@novalis.org>
---
 debugfs/debugfs.c | 22 ++++++++++++++++++----
 debugfs/debugfs.h |  2 +-
 debugfs/util.c    |  7 +++----
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 8c32eff..aa2f972 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -37,6 +37,8 @@ extern char *optarg;
 #include "../version.h"
 #include "jfs_user.h"
 
+#include "extra_epoch.h"
+
 #ifndef BUFSIZ
 #define BUFSIZ 8192
 #endif
@@ -718,6 +720,14 @@ static void dump_extents(FILE *f, const char
*prefix, ext2_ino_t ino,
 		fprintf(f, "\n");
 }
 
+char* inode_time_to_string(__s32 xtime, __u32 xtime_extra) {
+	time_t time = (time_t) xtime;
+	if (sizeof(time_t) > 4) {
+		time += (xtime_extra & EXT4_EPOCH_MASK) << 32;
+	}
+	return time_to_string(time);
+}
+
 void internal_dump_inode(FILE *out, const char *prefix,
 			 ext2_ino_t inode_num, struct ext2_inode *inode,
 			 int do_dump_blocks)
@@ -791,16 +801,20 @@ void internal_dump_inode(FILE *out, const char
*prefix,
 	if (is_large_inode && large_inode->i_extra_isize >= 24) {
 		fprintf(out, "%s ctime: 0x%08x:%08x -- %s", prefix,
 			inode->i_ctime, large_inode->i_ctime_extra,
-			time_to_string(inode->i_ctime));
+			inode_time_to_string(inode->i_ctime,
+					     large_inode->i_ctime_extra));
 		fprintf(out, "%s atime: 0x%08x:%08x -- %s", prefix,
 			inode->i_atime, large_inode->i_atime_extra,
-			time_to_string(inode->i_atime));
+			inode_time_to_string(inode->i_atime,
+					     large_inode->i_atime_extra));
 		fprintf(out, "%s mtime: 0x%08x:%08x -- %s", prefix,
 			inode->i_mtime, large_inode->i_mtime_extra,
-			time_to_string(inode->i_mtime));
+			inode_time_to_string(inode->i_mtime,
+					     large_inode->i_mtime_extra));
 		fprintf(out, "%scrtime: 0x%08x:%08x -- %s", prefix,
 			large_inode->i_crtime, large_inode->i_crtime_extra,
-			time_to_string(large_inode->i_crtime));
+			inode_time_to_string(large_inode->i_crtime,
+					     large_inode->i_crtime_extra));
 	} else {
 		fprintf(out, "%sctime: 0x%08x -- %s", prefix, inode->i_ctime,
 			time_to_string(inode->i_ctime));
diff --git a/debugfs/debugfs.h b/debugfs/debugfs.h
index 45175cf..a02f29c 100644
--- a/debugfs/debugfs.h
+++ b/debugfs/debugfs.h
@@ -33,7 +33,7 @@ extern int check_fs_not_open(char *name);
 extern int check_fs_read_write(char *name);
 extern int check_fs_bitmaps(char *name);
 extern ext2_ino_t string_to_inode(char *str);
-extern char *time_to_string(__u32);
+extern char *time_to_string(time_t);
 extern time_t string_to_time(const char *);
 extern unsigned long parse_ulong(const char *str, const char *cmd,
 				 const char *descr, int *err);
diff --git a/debugfs/util.c b/debugfs/util.c
index cf3a6c6..a60aec7 100644
--- a/debugfs/util.c
+++ b/debugfs/util.c
@@ -187,13 +187,12 @@ int check_fs_bitmaps(char *name)
 }
 
 /*
- * This function takes a __u32 time value and converts it to a string,
- * using ctime
+ * This function takes a time_t time value and converts it to a string,
+ * using asctime
  */
-char *time_to_string(__u32 cl)
+char *time_to_string(time_t t)
 {
 	static int	do_gmt = -1;
-	time_t		t = (time_t) cl;
 	const char	*tz;
 
 	if (do_gmt == -1) {
-- 
1.8.1.2



