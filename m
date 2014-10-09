From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] add aio/dio regression test race between write and fcntl
Date: Thu,  9 Oct 2014 13:59:58 +0400
Message-ID: <1412848798-27033-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:19749 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbaJIKAQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Oct 2014 06:00:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Original report: https://lkml.org/lkml/2014/10/8/545
perform AIO-DIO and fcntl(F_SETFL) concurently
Unaligned AIO likely result in synchronization which makes racewindow wider.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 src/aio-dio-regress/aio-dio-fcntl-race.c |  144 ++++++++++++++++++++++++++++++
 tests/generic/326                        |   51 +++++++++++
 tests/generic/326.out                    |    2 +
 tests/generic/group                      |    1 +
 4 files changed, 198 insertions(+), 0 deletions(-)
 create mode 100644 src/aio-dio-regress/aio-dio-fcntl-race.c
 create mode 100755 tests/generic/326
 create mode 100644 tests/generic/326.out

diff --git a/src/aio-dio-regress/aio-dio-fcntl-race.c b/src/aio-dio-regress/aio-dio-fcntl-race.c
new file mode 100644
index 0000000..db012d8
--- /dev/null
+++ b/src/aio-dio-regress/aio-dio-fcntl-race.c
@@ -0,0 +1,144 @@
+/*
+ * Perform aio writes to file and toggle O_DIRECT flag concurrently
+ * this may trigger race between file->f_flags read and modification
+ * unuligned aio allow to makes race window wider.
+ * Regression test for https://lkml.org/lkml/2014/10/8/545
+ *
+ * Copyright (C) 2010 Red Hat, Inc. All Rights reserved.
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
+int do_aio_write(int fd, void *buf)
+{
+	struct io_context *ctx = NULL;
+	struct io_event ev;
+	struct iocb iocb, *iocbs[] = { &iocb };
+	int err;
+
+	err = io_setup(1, &ctx);
+	if (err) {
+		if (err == -EAGAIN)
+			return 0;
+		fprintf(stderr, "error %s during %s\n",
+			strerror(-err), "io_setup" );
+		return 1;
+	}
+	io_prep_pwrite(&iocb, fd, buf, BUF_SIZE, BUF_SIZE);
+	err = io_submit(ctx, 1, iocbs);
+	if (err != 1) {
+		fprintf(stderr, "error %s during %s\n",
+			strerror(-err),
+			"io_submit");
+		return 1;
+	}
+	err = io_getevents(ctx, 1, 1, &ev, NULL);
+	if (err != 1) {
+		fprintf(stderr, "error %s during %s\n",
+			strerror(-err),
+			"io_getevents");
+		return 1;
+	}
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	int flags, fd;
+	int pid1, pid2 = 0;
+	int ret1, ret = 0;
+
+	struct timeval start, now, delta = { 0, 0 };
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
+	gettimeofday(&start, NULL);
+	if (pid1 == 0) {
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
+		while(1) {
+			do_aio_write(fd, buf);
+
+			gettimeofday(&now, NULL);
+			timersub(&now, &start, &delta);
+			if (delta.tv_sec >= LOOP_SECONDS)
+				break;
+		}
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
diff --git a/tests/generic/326 b/tests/generic/326
new file mode 100755
index 0000000..8975a91
--- /dev/null
+++ b/tests/generic/326
@@ -0,0 +1,51 @@
+#! /bin/bash
+# FS QA Test No. 326
+#
+# Run aio-dio-fcntl-race - test aio write race with O_DIRECT toggle
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2009 Dmitry Monakhov.  All Rights Reserved.
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
+#
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
diff --git a/tests/generic/326.out b/tests/generic/326.out
new file mode 100644
index 0000000..a0c44b9
--- /dev/null
+++ b/tests/generic/326.out
@@ -0,0 +1,2 @@
+QA output created by 326
+All tasks are spawned
diff --git a/tests/generic/group b/tests/generic/group
index 799bfd8..4aea4c6 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -151,3 +151,4 @@
 323 auto aio stress
 324 auto fsr quick
 325 auto quick data log
+326 auto quick aio rw stress
-- 
1.7.1

