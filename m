From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/4] ioengine: Add fallocate ioengine
Date: Wed, 19 Sep 2012 23:22:55 +0400
Message-ID: <1348082576-10528-4-git-send-email-dmonakhov@openvz.org>
References: <1348082576-10528-1-git-send-email-dmonakhov@openvz.org>
Cc: axboe@kernel.dk, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org, fio@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54003 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab2ISTXF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Sep 2012 15:23:05 -0400
In-Reply-To: <1348082576-10528-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

IO engine that does regular fallocate to simulate data transfer
as fio ioengine.
 DDIR_READ  does fallocate(,mode=FALLOC_FL_KEEP_SIZE,)
 DDIR_WRITE does fallocate(,mode=0) : fallocate with file extention
 DDIR_TRIM  does fallocate(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)

This engine may be useful to perform various tests:
1) Generation highly fragmentated files
2) Various fs stress testing in parallel with others io activity

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 HOWTO            |    2 +
 Makefile         |    2 +-
 engines/falloc.c |  121 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 124 insertions(+), 1 deletions(-)
 create mode 100644 engines/falloc.c

diff --git a/HOWTO b/HOWTO
index 025443b..3eb5510 100644
--- a/HOWTO
+++ b/HOWTO
@@ -602,6 +602,8 @@ ioengine=str	Defines how the job issues io to the file. The following
 				channel semantics (Send/Recv) for the
 				InfiniBand, RoCE and iWARP protocols.
 
+			falloc  Perform fallocate/punch_hole to files
+	
 			external Prefix to specify loading an external
 				IO engine object file. Append the engine
 				filename, eg ioengine=external:/tmp/foo.o
diff --git a/Makefile b/Makefile
index 83fbd59..a047079 100644
--- a/Makefile
+++ b/Makefile
@@ -21,7 +21,7 @@ ifeq ($(UNAME), Linux)
 		engines/libaio.c engines/posixaio.c engines/sg.c \
 		engines/splice.c engines/syslet-rw.c engines/guasi.c \
 		engines/binject.c engines/rdma.c profiles/tiobench.c \
-		engines/fusion-aw.c
+		engines/fusion-aw.c engines/falloc.c
   LIBS += -lpthread -ldl -lrt -laio
   LDFLAGS += -rdynamic
 endif
diff --git a/engines/falloc.c b/engines/falloc.c
new file mode 100644
index 0000000..cbb30cb
--- /dev/null
+++ b/engines/falloc.c
@@ -0,0 +1,121 @@
+/*
+ * falloc: ioengine for git://git.kernel.dk/fio.git
+ *
+ * IO engine that does regular fallocate to simulate data transfer 
+ * as fio ioengine.
+ * DDIR_READ  does fallocate(,mode = FALLOC_FL_KEEP_SIZE,)
+ * DDIR_WRITE does fallocate(,mode = 0) : fallocate with size extention 
+ * DDIR_TRIM  does fallocate(,mode = FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)
+ *
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/uio.h>
+#include <errno.h>
+#include <assert.h>
+#include <fcntl.h>
+
+#include "../fio.h"
+#include "../filehash.h"
+
+/*
+ * generic_open_file is not appropriate because does not allow to perform
+ * TRIM in to file
+ */
+int open_file(struct thread_data *td, struct fio_file *f)
+{
+	int from_hash = 0;
+
+	dprint(FD_FILE, "fd open %s\n", f->file_name);
+
+	if (f->filetype != FIO_TYPE_FILE) {
+		log_err("fio: only files are supported fallocate \n");
+		return 1;
+	}
+	if (!strcmp(f->file_name, "-")) {
+		log_err("fio: can't read/write to stdin/out\n");
+		return 1;
+	}
+
+open_again:
+	from_hash = file_lookup_open(f, O_CREAT|O_RDWR);
+
+	if (f->fd == -1) {
+		char buf[FIO_VERROR_SIZE];
+		int __e = errno;
+		snprintf(buf, sizeof(buf) - 1, "open(%s)", f->file_name);
+		td_verror(td, __e, buf);
+	}
+
+	if (!from_hash && f->fd != -1) {
+		if (add_file_hash(f)) {
+			int fio_unused ret;
+
+			/*
+			 * OK to ignore, we haven't done anything with it
+			 */
+			ret = generic_close_file(td, f);
+			goto open_again;
+		}
+	}
+
+	return 0;
+}
+
+#ifndef FALLOC_FL_KEEP_SIZE
+#define FALLOC_FL_KEEP_SIZE     0x01 /* default is extend size */
+#endif
+#ifndef FALLOC_FL_PUNCH_HOLE
+#define FALLOC_FL_PUNCH_HOLE    0x02 /* de-allocates range */
+#endif 
+static int fio_fallocate_queue(struct thread_data *td, struct io_u *io_u)
+{
+	struct fio_file *f = io_u->file;
+	int ret;
+	int flags = 0;
+
+	fio_ro_check(td, io_u);
+
+	if (io_u->ddir == DDIR_READ)
+		flags = FALLOC_FL_KEEP_SIZE;
+	else if (io_u->ddir == DDIR_WRITE)
+		flags = 0;
+	else if (io_u->ddir == DDIR_TRIM)
+		flags = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
+
+	ret = fallocate(f->fd, flags, io_u->offset, io_u->xfer_buflen);
+
+	if (ret) {
+		io_u->error = errno;
+		if (io_u->error)
+			td_verror(td, io_u->error, "xfer");
+	}
+	if (io_u->ddir == DDIR_TRIM && !ret)
+		return io_u->xfer_buflen;
+
+	if (io_u->file && ret == 0 && ddir_rw(io_u->ddir))
+		io_u->file->file_pos = io_u->offset + ret;
+
+	return FIO_Q_COMPLETED;
+}
+
+static struct ioengine_ops ioengine = {
+	.name		= "falloc",
+	.version	= FIO_IOOPS_VERSION,
+	.queue		= fio_fallocate_queue,
+	.open_file	= open_file,
+	.close_file	= generic_close_file,
+	.get_file_size	= generic_get_file_size,
+	.flags		= FIO_SYNCIO
+};
+
+static void fio_init fio_syncio_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_syncio_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
-- 
1.7.7.6

