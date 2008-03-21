From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH, E2FSPROGS] debugfs, tune2fs: Handle daylight savings time when parsing a time string
Date: Fri, 21 Mar 2008 09:17:13 -0400
Message-ID: <1206105433-15636-1-git-send-email-tytso@mit.edu>
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60118 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754948AbYCUNRQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Mar 2008 09:17:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to set tm_isdst to -1 so that mktime will automatically
determine whether or not daylight savings time (DST) is in effect.
Previously tm_isdst was set to 0, which caused mktime to interpret the
time as if it was always not using DST.

Addresses-Debian-Bug: #471882

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 debugfs/util.c |    1 +
 misc/tune2fs.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/debugfs/util.c b/debugfs/util.c
index 0633960..ebce9d6 100644
--- a/debugfs/util.c
+++ b/debugfs/util.c
@@ -231,6 +231,7 @@ extern time_t string_to_time(const char *arg)
 	    ts.tm_min > 59 || ts.tm_sec > 61)
 		ts.tm_mday = 0;
 #endif
+	ts.tm_isdst = -1;
 	ret = mktime(&ts);
 	if (ts.tm_mday == 0 || ret == ((time_t) -1)) {
 		/* Try it as an integer... */
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 4f66d42..4e731f5 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -540,6 +540,7 @@ static time_t parse_time(char *str)
 			str);
 		usage();
 	}
+	ts.tm_isdst = -1;
 	return (mktime(&ts));
 }
 
-- 
1.5.4.1.144.gdfee-dirty

