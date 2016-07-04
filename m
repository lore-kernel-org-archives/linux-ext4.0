From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] quota: fix generic/244 on 32-bit platforms
Date: Sun,  3 Jul 2016 20:11:56 -0400
Message-ID: <1467591116-16880-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60728 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236AbcGDAMW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Jul 2016 20:12:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The test program src/test-nextquota.c relies on atoi() to convert a
string to an *unsigned* int.  If the string represents an integer
which is greater than INT_MAX, it is undefined how atoi(3) works, and
it turns out that:

       uint id = atoi("2147483649");

results in id == 2147483649 on x86_64, and id == 2147483647 on a
32-bit x86 platform.

So use strtoul(3) instead, which is portable and technically correct.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>
---
 src/test-nextquota.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/test-nextquota.c b/src/test-nextquota.c
index a2bbad9..6eec1f9 100644
--- a/src/test-nextquota.c
+++ b/src/test-nextquota.c
@@ -74,6 +74,7 @@ int main(int argc, char *argv[])
 	int verbose = 0;
 	uint id = 0, idflag = 0;
 	char *device = NULL;
+	char *tmp;
 	struct nextdqblk dqb;
 	struct fs_disk_quota xqb;
 
@@ -92,7 +93,11 @@ int main(int argc, char *argv[])
 			typeflag++;
 			break;
 		case 'i':
-			id = atoi(optarg);
+			id = (int) strtoul(optarg, &tmp, 0);
+			if (*tmp) {
+				fprintf(stderr, "Bad id: %s\n", optarg);
+				exit(1);
+			}
 			idflag++;
 			break;
 		case 'd':
-- 
2.5.0

