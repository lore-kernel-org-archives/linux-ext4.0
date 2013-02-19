From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 03/11] xfstest: add configurable load factors
Date: Tue, 19 Feb 2013 15:37:15 +0400
Message-ID: <1361273843-16094-3-git-send-email-dmonakhov@openvz.org>
References: <1361273843-16094-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, david@fromorbit.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:37383 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310Ab3BSLhp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Feb 2013 06:37:45 -0500
In-Reply-To: <1361273843-16094-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Most stress test has probable behaviour, the longer test run the
larger corner cases will be cover. It is reasonable to allow
user to provide some sort of system load factor.
This patch introduce two global variables
LOAD_FACTOR: Usually means factor number of running tasks
TIME_FACTOR: Usually means factor of run time, or number of operations
If not speficied both variables defined to 1, so original behaviour
preserved.

TODO: Change all stress tests to use this variables

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 common.config |    2 ++
 group         |    7 ++++++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/common.config b/common.config
index d5c8956..a956a46 100644
--- a/common.config
+++ b/common.config
@@ -73,6 +73,8 @@ export HOST_OPTIONS=${HOST_OPTIONS:=local.config}
 export CHECK_OPTIONS=${CHECK_OPTIONS:="-g auto"}
 export BENCH_PASSES=${BENCH_PASSES:=5}
 export XFS_MKFS_OPTIONS=${XFS_MKFS_OPTIONS:=-bsize=4096}
+export TIME_FACTOR=${TIME_FACTOR:=1}
+export LOAD_FACTOR=${LOAD_FACTOR:=1}
 
 export PWD=`pwd`
 #export DEBUG=${DEBUG:=...} # arbitrary CFLAGS really.
diff --git a/group b/group
index 697269b..810c938 100644
--- a/group
+++ b/group
@@ -113,7 +113,12 @@ dangerous
 # on current systems
 deprecated
 
-#
+# Stress test with probable behaviour, the longer test run the
+# larger corner cases will be covered. Configurable variables:
+# LOAD_FACTOR: Usually means factor number of running tasks
+# TIME_FACTOR: Usually means factor of run time, or number of operations
+stress
+
 # test-group association ... one line per test
 #
 001 rw dir udf auto quick
-- 
1.7.1

