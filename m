From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/3] generic/237: fix filtering for expected failure message
Date: Sat, 12 Apr 2014 18:55:17 -0400
Message-ID: <1397343317-14669-4-git-send-email-tytso@mit.edu>
References: <1397343317-14669-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: xfs@oss.sgi.com
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1397343317-14669-1-git-send-email-tytso@mit.edu>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

Newer kernels return EACCES instead of EPERM when modifying an acl
fails.  Update the filtering to handle this.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 tests/generic/237     | 2 +-
 tests/generic/237.out | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/generic/237 b/tests/generic/237
index 6a61ec8..b068150 100755
--- a/tests/generic/237
+++ b/tests/generic/237
@@ -68,7 +68,7 @@ touch file1
 chown $acl1.$acl1 file1
 
 echo "Expect to FAIL"
-$runas -u $acl2 -g $acl2 -- `which setfacl` -m u::rwx file1 2>&1 | sed 's/^setfacl: \/.*file1: Operation not permitted$/setfacl: file1: Operation not permitted/'
+$runas -u $acl2 -g $acl2 -- `which setfacl` -m u::rwx file1 2>&1 | sed -e 's/Permission denied/Operation not permitted/' -e 's/file1: //' -e 's,[/a-zA-Z]*setfacl: ,setfacl: ,'
 
 echo "Test over."
 # success, all done
diff --git a/tests/generic/237.out b/tests/generic/237.out
index 09d98c6..4edafa6 100644
--- a/tests/generic/237.out
+++ b/tests/generic/237.out
@@ -1,4 +1,4 @@
 QA output created by 237
 Expect to FAIL
-setfacl: file1: Operation not permitted
+setfacl: Operation not permitted
 Test over.
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
