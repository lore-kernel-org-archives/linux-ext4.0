From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] Fix up workarounds for dietlibc breakage
Date: Wed,  8 Jan 2014 22:26:59 -0500
Message-ID: <1389238019-18921-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46961 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbaAID1F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jan 2014 22:27:05 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The dietlibc doesn't support the TZ environment variable, which is
required by the standard.  Work around this so that we can run the
regression test suite when building with dietlibc.  (This is useful
for finding problems.)

With this change, the only thing which doesn't work as far as dietlibc
is concerned is the posix_memalign test, and the MMP support tests
(because posix_memalign isn't provided by dietlibc, sigh.)

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 debugfs/util.c               | 20 ++++++++++----------
 e2fsck/message.c             |  3 ++-
 tests/d_special_files/script |  2 +-
 tests/f_dup4/script          |  2 +-
 4 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/debugfs/util.c b/debugfs/util.c
index 21991cf..cf46cc3 100644
--- a/debugfs/util.c
+++ b/debugfs/util.c
@@ -201,7 +201,7 @@ char *time_to_string(__u32 cl)
 		tz = ss_safe_getenv("TZ");
 		if (!tz)
 			tz = "";
-		do_gmt = !strcmp(tz, "GMT");
+		do_gmt = !strcmp(tz, "GMT") | !strcmp(tz, "GMT0");
 	}
 
 	return asctime((do_gmt) ? gmtime(&t) : localtime(&t));
@@ -222,14 +222,18 @@ time_t string_to_time(const char *arg)
 	}
 	if (arg[0] == '@') {
 		/* interpret it as an integer */
-		ret = strtoul(arg+1, &tmp, 0);
+		arg++;
+	fallback:
+		ret = strtoul(arg, &tmp, 0);
 		if (*tmp)
 			return ((time_t) -1);
 		return ret;
 	}
 	memset(&ts, 0, sizeof(ts));
 #ifdef HAVE_STRPTIME
-	strptime(arg, "%Y%m%d%H%M%S", &ts);
+	ret = strptime(arg, "%Y%m%d%H%M%S", &ts);
+	if (ret == NULL)
+		goto fallback;
 #else
 	sscanf(arg, "%4d%2d%2d%2d%2d%2d", &ts.tm_year, &ts.tm_mon,
 	       &ts.tm_mday, &ts.tm_hour, &ts.tm_min, &ts.tm_sec);
@@ -241,13 +245,9 @@ time_t string_to_time(const char *arg)
 		ts.tm_mday = 0;
 #endif
 	ts.tm_isdst = -1;
-	ret = mktime(&ts);
-	if (ts.tm_mday == 0 || ret == ((time_t) -1)) {
-		/* Try it as an integer... */
-		ret = strtoul(arg, &tmp, 0);
-		if (*tmp)
-			return ((time_t) -1);
-	}
+	ret = ts.tm_sec + ts.tm_min*60 + ts.tm_hour*3600 + ts.tm_yday*86400 +
+		(ts.tm_year-70)*31536000 + ((ts.tm_year-69)/4)*86400 -
+		((ts.tm_year-1)/100)*86400 + ((ts.tm_year+299)/400)*86400;
 	return ret;
 }
 
diff --git a/e2fsck/message.c b/e2fsck/message.c
index 7b2cb62..7b84359 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -226,7 +226,8 @@ static void print_time(FILE *f, time_t t)
 			time_str = getenv("TZ");
 			if (!time_str)
 				time_str = "";
-			do_gmt = !strcmp(time_str, "GMT0");
+			do_gmt = !strcmp(time_str, "GMT") ||
+				!strcmp(time_str, "GMT0");
 		}
 #endif
 		time_str = asctime((do_gmt > 0) ? gmtime(&t) : localtime(&t));
diff --git a/tests/d_special_files/script b/tests/d_special_files/script
index 1a1999a..9bdff5d 100644
--- a/tests/d_special_files/script
+++ b/tests/d_special_files/script
@@ -18,7 +18,7 @@ status=$?
 echo Exit status is $status >> $OUT
 
 $DEBUGFS -w $TMPFILE << EOF > /dev/null 2>&1
-set_current_time 201301151400
+set_current_time 20130115140000
 set_super_value lastcheck 0
 set_super_value hash_seed null
 set_super_value mkfs_time 0
diff --git a/tests/f_dup4/script b/tests/f_dup4/script
index 7c45bed..498f525 100644
--- a/tests/f_dup4/script
+++ b/tests/f_dup4/script
@@ -8,7 +8,7 @@ echo "/ Murphy Magic.  The SeCrEt of the UnIvErSe is 43, NOT 42" > $TEST_DATA
 touch $TMPFILE
 $MKE2FS -N 32 -F -o Linux -b 1024 $TMPFILE 100 > /dev/null 2>&1 
 $DEBUGFS -w $TMPFILE << EOF > /dev/null 2>&1
-set_current_time 200704102100
+set_current_time 20070410210000
 set_super_value lastcheck 0
 set_super_value hash_seed null
 set_super_value mkfs_time 0
-- 
1.8.5.rc3.362.gdf10213

