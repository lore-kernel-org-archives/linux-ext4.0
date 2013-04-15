From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] xfstests: dump _require_fio output to log
Date: Mon, 15 Apr 2013 15:09:47 +0400
Message-ID: <1366024188-21756-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org, dchinner@redhat.com
To: xfs@oss.sgi.com
Return-path: <xfs-bounces@oss.sgi.com>
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

This should helps to find incompatibility issues.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 common/rc      |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
 mode change 100644 => 100755 tests/ext4/301

diff --git a/common/rc b/common/rc
index 09fb83f..ad3e378 100644
--- a/common/rc
+++ b/common/rc
@@ -1967,8 +1967,8 @@ _require_fio()
 		return 1;
 	fi
 
-	$FIO_PROG --warnings-fatal --showcmd $job >/dev/null 2>&1
-	[ $? -eq 0 ] || _notrun "$FIO_PROG too old"
+	$FIO_PROG --warnings-fatal --showcmd $job >> $seqres.full 2>&1
+	[ $? -eq 0 ] || _notrun "$FIO_PROG too old, see $seqres.full"
 }
 
 # Does freeze work on this fs?
diff --git a/tests/ext4/301 b/tests/ext4/301
old mode 100644
new mode 100755
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
