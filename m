From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v2] check: add support for an external file containing tests to exclude
Date: Wed, 16 Apr 2014 00:58:22 -0400
Message-ID: <1397624302-9577-1-git-send-email-tytso@mit.edu>
References: <20140416001530.GU15995@dastard>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54941 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbaDPE63 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Apr 2014 00:58:29 -0400
In-Reply-To: <20140416001530.GU15995@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently the -X option is intended to specify a set of expunging
files which are stored in each test/* subdirectory.  As described in
the commit description for 0b1e8abd4, in order to exclude the test
generic/280, the -X option is used as follows:

    $ cat tests/generic/3.0-stable-avoid
    280
    $ sudo ./check -X 3.0-stable-avoid generic/280

However, it is sometimes useful to store the set of expunged tests in
a single file, outside of tests/* subdirectories.  This commit enables
the following:

    $ cat /root/conf/data_journal.exclude
    generic/068
    ext4/301
    $ sudo ./check -E /root/conf/data_journal.exclude -g auto

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 check | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/check b/check
index e7ace63..b1eaed2 100755
--- a/check
+++ b/check
@@ -81,6 +81,7 @@ testlist options
     -g group[,group...]	include tests from these groups
     -x group[,group...]	exclude tests from these groups
     -X file		exclude individual tests
+    -E external_file	exclude individual tests
     [testlist]		include tests matching names in testlist
 '
 	    exit 0
@@ -222,6 +223,11 @@ while [ $# -gt 0 ]; do
 			done
 		done
 		;;
+	-E)	xfile=$2; shift ;
+		if [ -f $xfile ]; then
+			cat "$xfile" >> $tmp.xlist
+	        fi
+		;;
 	-s)	RUN_SECTION="$RUN_SECTION $2"; shift ;;
 	-l)	diff="diff" ;;
 	-udiff)	diff="$diff -u" ;;
-- 
1.9.0

