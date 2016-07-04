From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v2] quota: fix generic/244 on 32-bit platforms
Date: Mon,  4 Jul 2016 10:09:48 -0400
Message-ID: <1467641388-26577-1-git-send-email-tytso@mit.edu>
Cc: sandeen@redhat.com,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The test program src/test-nextquota.c relies on atoi() to convert a
string to an *unsigned* int.  If the string represents an integer
which is greater than INT_MAX, it is undefined how atoi(3) works, and
it turns out that:

       uint id = atoi("2147483649");

results in id == 2147483649 on x86_64, and id == 2147483647 on a
32-bit x86 platform.

So use strtoul(3) instead, which is portable and technically correct.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---

v2: cast to uint instead of int

 src/test-nextquota.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/test-nextquota.c b/src/test-nextquota.c
index a2bbad9..3baa296 100644
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
+			id = (uint) strtoul(optarg, &tmp, 0);
+			if (*tmp) {
+				fprintf(stderr, "Bad id: %s\n", optarg);
+				exit(1);
+			}
 			idflag++;
 			break;
 		case 'd':
-- 
2.5.0
