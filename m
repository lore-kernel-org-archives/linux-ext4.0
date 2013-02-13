From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/8] xfstests: add fio requirement V2
Date: Wed, 13 Feb 2013 12:49:56 +0400
Message-ID: <1360745403-6373-2-git-send-email-dmonakhov@openvz.org>
References: <1360745403-6373-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org, dchinner@redhat.com
To: xfs@oss.sgi.com
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1360745403-6373-1-git-send-email-dmonakhov@openvz.org>
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

FIO is very flexible io generator, I would call it IO swiss knife.
Currently we have tonns of hardcoded application which reproduces
some predefined scenario. This approach has obvious dissadvantages
1) Lack of flexability: one written it is hard to modify it in future
2) Code base is large, many routines written again and again

At the same time add new fio based tast is just add simle INI file.
This greatly simplify code review. I do beleve that some day we will
replace most of hardcoded io binaries with fio.

One who is planning to run $FIO_PROG should first check that system
contains appropriate version which is able to handle jobfile
for example:  _require_fio 286-job.fio

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 common.config |    1 +
 common.rc     |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/common.config b/common.config
index 7bed1c5..d5c8956 100644
--- a/common.config
+++ b/common.config
@@ -158,6 +158,7 @@ export XFS_QUOTA_PROG="`set_prog_path xfs_quota`"
 export KILLALL_PROG="`set_prog_path killall`"
 export INDENT_PROG="`set_prog_path indent`"
 export XFS_COPY_PROG="`set_prog_path xfs_copy`"
+export FIO_PROG="`set_prog_path fio`"
 
 # Generate a comparable xfsprogs version number in the form of
 # major * 10000 + minor * 100 + release
diff --git a/common.rc b/common.rc
index 602513a..f5027e7 100644
--- a/common.rc
+++ b/common.rc
@@ -1758,6 +1758,21 @@ _require_btrfs()
 	[ $? -eq 0 ] || _notrun "$BTRFS_UTIL_PROG too old (must support $cmd)"
 }
 
+# Check that fio is present, and it is able to execute given jobfile
+_require_fio()
+{
+	job=$1
+
+	_require_command $FIO_PROG
+	if [ -z "$1" ]; then
+		return 1;
+	fi
+	
+	$FIO_PROG --warnings-fatal --showcmd $job >/dev/null 2>&1
+	[ $? -eq 0 ] || _notrun "$FIO_PROG too old"
+}
+
+
 # arg 1 is dev to remove and is output of the below eg.
 # ls -l /sys/class/block/sdd | rev | cut -d "/" -f 3 | rev
 _devmgt_remove()
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
