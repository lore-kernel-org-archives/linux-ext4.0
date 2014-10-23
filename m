From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] add aio/dio regression test race between write and fcntl V5
Date: Thu, 23 Oct 2014 15:08:38 +0400
Message-ID: <1414062518-30942-2-git-send-email-dmonakhov@openvz.org>
References: <1414062518-30942-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, root <root@ts105.qa.sw.ru>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:44088 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651AbaJWLIo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Oct 2014 07:08:44 -0400
In-Reply-To: <1414062518-30942-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: root <root@ts105.qa.sw.ru>

Original report: https://lkml.org/lkml/2014/10/8/545
perform AIO-DIO and fcntl(F_SETFL) concurently
Unaligned AIO likely result in synchronization which makes racewindow wider.

changes from v4
   fix incorrect timer initialization
changes from v3
   rebase to current xfstests HEAD
changes from v2->v3
 - Copyright fixes according to Dave's comments
changes from v1->v2
 - Properly reuse aio context

Reviewed-by: Eryu Guan <eguan@redhat.com>
---
 src/aio-dio-regress/aio-dio-fcntl-race.c |  150 ++++++++++++++++++++++++++++++
 tests/generic/036                        |   51 ++++++++++
 tests/generic/036.out                    |    2 +
 tests/generic/group                      |    1 +
 4 files changed, 204 insertions(+), 0 deletions(-)
 create mode 100644 src/aio-dio-regress/aio-dio-fcntl-race.c
 create mode 100755 tests/generic/036
 create mode 100644 tests/generic/036.out

diff --git a/src/aio-dio-regress/aio-dio-fcntl-race.c b/src/aio-dio-regress/aio-dio-fcntl-race.c
new file mode 100644
index 0000000..cdf9773
--- /dev/null
+++ b/src/aio-dio-regress/aio-dio-fcntl-race.c
@@ -0,0 +1,150 @@
+/*
+ * Perform aio writes to file and toggle O_DIRECT flag concurrently
+ * this may trigger race between file->f_flags read and modification
+ * unuligned aio allow to makes race window wider.
+ * Regression test for https://lkml.org/lkml/2014/10/8/545 CVE-2014-8086
+ * Patch proposed: http://www.spinics.net/lists/linux-ext4/msg45683.html
+ *
+ * Copyright (c) 2014 Dmitry Monakhov.  All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ */
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <libaio.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <time.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+
+#define BUF_SIZE	512
+#define LOOP_SECONDS 10
+
+
+static int do_aio_loop(int fd, void *buf)
+{
+	int err, ret;
+	struct io_context *ctx = NULL;
+	struct io_event ev;
+	struct iocb iocb, *iocbs[] = { &iocb };
+	struct timeval start, now, delta = { 0, 0 };
+
+	ret = 0;
+	err = io_setup(1, &ctx);
+	if (err) {
+		fprintf(stderr, "error %s during %s\n",
+			strerror(-err), "io_setup" );
+		return 1;
+	}
+	gettimeofday(&start, NULL);
+	while (1) {
+		io_prep_pwrite(&iocb, fd, buf, BUF_SIZE, BUF_SIZE);
+		err = io_submit(ctx, 1, iocbs);
+		if (err != 1) {
+			fprintf(stderr, "error %s during %s\n",
+				strerror(-err),
+				"io_submit");
+			ret = 1;
+			break;
+		}
+		err = io_getevents(ctx, 1, 1, &ev, NULL);
+		if (err != 1) {
+			fprintf(stderr, "error %s during %s\n",
+				strerror(-err),
+				"io_getevents");
+			ret = 1;
+			break;
+		}
+		gettimeofday(&now, NULL);
+		timersub(&now, &start, &delta);
+		if (delta.tv_sec >= LOOP_SECONDS)
+			break;
+	}
+	io_destroy(ctx);
+	return ret;
+}
+
+int main(int argc, char **argv)
+{
+	int flags, fd;
+	int pid1, pid2 = 0;
+	int ret1, ret = 0;
+
+	if (argc != 2){
+		printf("Usage %s fname\n", argv[0]);
+		return 1;
+	}
+	fd = open(argv[1], O_CREAT | O_TRUNC | O_RDWR, 0600);
+	if (fd < 0)
+		return 1;
+
+	pid1 = fork();
+	if (pid1 < 0)
+		return 1;
+
+	if (pid1 == 0) {
+		struct timeval start, now, delta = { 0, 0 };
+
+		gettimeofday(&start, NULL);
+
+		/* child: toggle O_DIRECT*/
+		flags = fcntl(fd, F_GETFL);
+		while (1) {
+			ret = fcntl(fd, F_SETFL, flags | O_DIRECT);
+			if (ret)
+				return ret;
+			ret = fcntl(fd, F_SETFL, flags);
+			if (ret)
+				return ret;
+
+			gettimeofday(&now, NULL);
+			timersub(&now, &start, &delta);
+			if (delta.tv_sec >= LOOP_SECONDS)
+				break;
+		}
+	} else {
+		/* parent: AIO */
+		void *buf;
+		posix_memalign(&buf, BUF_SIZE, BUF_SIZE);
+		/* Two tasks which performs unaligned aio will be serialized
+		   which maks race window wider */
+		pid2 = fork();
+		if (pid2 < 0)
+			goto out;
+		else if (pid2 > 0)
+			printf("All tasks are spawned\n");
+
+		ret = do_aio_loop(fd, buf);
+	}
+out:
+	/* Parent wait for all others */
+	if (pid2 > 0){
+		waitpid(pid1, &ret1, 0);
+		if (!ret)
+			ret = ret1;
+		waitpid(pid2, &ret1, 0);
+	} else {
+		waitpid(pid1, &ret1, 0);
+	}
+	if (!ret)
+		ret = ret1;
+
+	return ret;
+}
diff --git a/tests/generic/036 b/tests/generic/036
new file mode 100755
index 0000000..0615dad
--- /dev/null
+++ b/tests/generic/036
@@ -0,0 +1,51 @@
+#! /bin/bash
+# FS QA Test No. 036
+#
+# CVE-2014-8086
+# Run aio-dio-fcntl-race - test aio write race with O_DIRECT toggle
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Dmitry Monakhov.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+
+_supported_fs generic
+_supported_os Linux
+_require_test
+
+_run_aiodio aio-dio-fcntl-race
+
+exit $status
diff --git a/tests/generic/036.out b/tests/generic/036.out
new file mode 100644
index 0000000..59719d6
--- /dev/null
+++ b/tests/generic/036.out
@@ -0,0 +1,2 @@
+QA output created by 036
+All tasks are spawned
diff --git a/tests/generic/group b/tests/generic/group
index 9c82a6f..d6629a8 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -38,6 +38,7 @@
 033 auto quick rw
 034 auto quick metadata log
 035 auto quick
+036 auto aio rw stress
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.7.1

