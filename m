From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/4] ext4: ignore valid errors from defragmentation tests
Date: Tue,  9 Jul 2013 15:05:17 +0400
Message-ID: <1373367918-7516-3-git-send-email-dmonakhov@openvz.org>
References: <1373367918-7516-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org, dchinner@redhat.com
To: xfs@oss.sgi.com
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1373367918-7516-1-git-send-email-dmonakhov@openvz.org>
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


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 tests/ext4/301 |    3 +++
 tests/ext4/302 |    3 +++
 tests/ext4/303 |    6 ++++++
 tests/ext4/304 |    3 +++
 4 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/tests/ext4/301 b/tests/ext4/301
index 0ca3622..30e4273 100755
--- a/tests/ext4/301
+++ b/tests/ext4/301
@@ -74,6 +74,9 @@ donorname=test1.def
 filename=test1
 inplace=0
 rw=write
+continue_on_error=write
+ignore_error=,ENOSPC:EBUSY
+error_dump=0
 numjobs=${NUM_JOBS}
 runtime=30*${TIME_FACTOR}
 time_based
diff --git a/tests/ext4/302 b/tests/ext4/302
index 497f4c6..5ce007b 100755
--- a/tests/ext4/302
+++ b/tests/ext4/302
@@ -76,6 +76,9 @@ donorname=test2.def
 filename=test2
 inplace=0
 rw=write
+continue_on_error=write
+ignore_error=,ENOSPC:EBUSY
+error_dump=0
 numjobs=${LOAD_FACTOR}
 runtime=30*${TIME_FACTOR}
 time_based
diff --git a/tests/ext4/303 b/tests/ext4/303
index 93354e5..f96264e 100755
--- a/tests/ext4/303
+++ b/tests/ext4/303
@@ -72,6 +72,9 @@ donorname=test3.def
 filename=test31
 inplace=0
 rw=write
+continue_on_error=write
+ignore_error=,ENOSPC:EBUSY
+error_dump=0
 numjobs=${LOAD_FACTOR}
 runtime=30*${TIME_FACTOR}
 time_based
@@ -84,6 +87,9 @@ donorname=test3.def
 filename=test32
 inplace=0
 rw=write
+continue_on_error=write
+ignore_error=,ENOSPC:EBUSY
+error_dump=0
 numjobs=${LOAD_FACTOR}
 runtime=30*${TIME_FACTOR}
 time_based
diff --git a/tests/ext4/304 b/tests/ext4/304
index 74e601a..5e03d4a 100755
--- a/tests/ext4/304
+++ b/tests/ext4/304
@@ -76,6 +76,9 @@ donorname=test4.def
 filename=test4
 inplace=1
 rw=randwrite
+continue_on_error=write
+ignore_error=,ENOSPC:EBUSY:EINVAL:61
+error_dump=0
 numjobs=4*${LOAD_FACTOR}
 runtime=30*${TIME_FACTOR}
 time_based
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
