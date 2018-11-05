Return-Path: <SRS0=Yxos=NQ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43662 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387515AbeKFDUp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Nov 2018 22:20:45 -0500
Date: Mon, 5 Nov 2018 09:59:46 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
Subject: [PATCH] e2scrub: fix systemd escaping again
Message-ID: <20181105175946.GA4124@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Apparently newer versions of systemd than the one on this author's
laptop <cough> now complain about lack of (path) escaping in unit
instance variable contents:

 # e2scrub_all
 Scrubbing /home...
 Invalid unit name "e2scrub@/home" was escaped as "e2scrub@-home"
 (maybe you should use systemd-escape?)
 Starting Online ext4 Metadata Check for /home...

So change the escape_path_for_systemd function to escape paths
unconditionally to make the warning go away.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/e2scrub_all.in |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/scrub/e2scrub_all.in b/scrub/e2scrub_all.in
index 9581dc2c4..23d122d25 100644
--- a/scrub/e2scrub_all.in
+++ b/scrub/e2scrub_all.in
@@ -101,13 +101,18 @@ ls_scrub_targets() {
 # systemd doesn't know to do path escaping on the instance variable we pass
 # to the e2scrub service, which breaks things if there is a dash in the path
 # name.  Therefore, do the path escaping ourselves if needed.
+#
+# systemd path escaping also drops the initial slash so we add that back in so
+# that log messages from the service units preserve the full path and users can
+# look up log messages using full paths.  However, for "/" the escaping rules
+# do /not/ drop the initial slash, so we have to special-case that here.
 escape_path_for_systemd() {
 	local path="$1"
 
-	if echo "${path}" | grep -q -- "-"; then
+	if [ "${path}" != "/" ]; then
 		echo "-$(systemd-escape --path "${path}")"
 	else
-		echo "${path}"
+		echo "-"
 	fi
 }
 
