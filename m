From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfstests: fix src/seek_sanity_test -t option
Date: Fri, 24 May 2013 00:03:42 -0500
Message-ID: <519EF4AE.60702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab3EXFDp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 May 2013 01:03:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

_require_seek_data_hole() does not work because
the -t (test) option of seek_sanity_test is broken,
because of an early check for (argc != 2):

# src/seek_sanity_test -t foo
Usage: src/seek_sanity_test base_file_path

So _require_seek_data_hole() doesn't see the
"Kernel does not support" string it's looking for,
and passes the check.

So rather than _notrun-ing the test, it proceeds to
fail with noisy errors.

Fix that, make a common usage() function, and check for
too many args as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
index 4275a84..f957178 100644
--- a/src/seek_sanity_test.c
+++ b/src/seek_sanity_test.c
@@ -656,6 +656,12 @@ out:
 	return ret;
 }
 
+void usage(char *cmd)
+{
+	fprintf(stdout, "Usage: %s [-t] base_file_path\n", cmd);
+	exit(1);
+}
+
 int main(int argc, char **argv)
 {
 	int ret = -1;
@@ -664,23 +670,20 @@ int main(int argc, char **argv)
 	int check_support = 0;
 	int numtests = sizeof(seek_tests) / sizeof(struct testrec);
 
-	if (argc != 2) {
-		fprintf(stdout, "Usage: %s base_file_path\n", argv[0]);
-		return ret;
-	}
