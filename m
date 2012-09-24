From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/6] xfstests: add fio requirement V2
Date: Mon, 24 Sep 2012 18:23:16 +0400
Message-ID: <1348496601-32637-1-git-send-email-dmonakhov@openvz.org>
Cc: xfs@oss.sgi.com, hch@lst.de, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44315 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795Ab2IXOX1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Sep 2012 10:23:27 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

FIO is very flexible io generator, i would call it IO swiss knife.
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
1.7.7.6

