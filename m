From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/4] engine: add e4defrag engine
Date: Wed, 19 Sep 2012 23:22:56 +0400
Message-ID: <1348082576-10528-5-git-send-email-dmonakhov@openvz.org>
References: <1348082576-10528-1-git-send-email-dmonakhov@openvz.org>
Cc: axboe@kernel.dk, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org, fio@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61800 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab2ISTXG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Sep 2012 15:23:06 -0400
In-Reply-To: <1348082576-10528-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

IO engine that does regular EXT4_IOC_MOVE_EXT ioctls to simulate
defragment activity

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 Makefile           |    2 +-
 engines/e4defrag.c |  215 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 examples/e4defrag  |   32 ++++++++
 3 files changed, 248 insertions(+), 1 deletions(-)
 create mode 100644 engines/e4defrag.c
 create mode 100644 examples/e4defrag

diff --git a/Makefile b/Makefile
index a047079..7972508 100644
--- a/Makefile
+++ b/Makefile
@@ -21,7 +21,7 @@ ifeq ($(UNAME), Linux)
 		engines/libaio.c engines/posixaio.c engines/sg.c \
 		engines/splice.c engines/syslet-rw.c engines/guasi.c \
 		engines/binject.c engines/rdma.c profiles/tiobench.c \
-		engines/fusion-aw.c engines/falloc.c
+		engines/fusion-aw.c engines/falloc.c engines/e4defrag.c
   LIBS += -lpthread -ldl -lrt -laio
   LDFLAGS += -rdynamic
 endif
diff --git a/engines/e4defrag.c b/engines/e4defrag.c
new file mode 100644
index 0000000..5affaa0
--- /dev/null
+++ b/engines/e4defrag.c
@@ -0,0 +1,215 @@
+/*
+ * ioe_e4defrag:  ioengine for git://git.kernel.dk/fio.git
+ *
+ * IO engine that does regular EXT4_IOC_MOVE_EXT ioctls to simulate
+ * defragment activity
+ *
+ */
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/uio.h>
+#include <errno.h>
+#include <assert.h>
+#include <fcntl.h>
+
+#include "../fio.h"
+
+#ifndef EXT4_IOC_MOVE_EXT
+#define EXT4_IOC_MOVE_EXT               _IOWR('f', 15, struct move_extent)
+struct move_extent {
+	__u32 reserved;         /* should be zero */
+	__u32 donor_fd;         /* donor file descriptor */
+	__u64 orig_start;       /* logical start offset in block for orig */
+	__u64 donor_start;      /* logical start offset in block for donor */
+	__u64 len;              /* block length to be moved */
+	__u64 moved_len;        /* moved block length */
+};
+#endif
+
+struct e4defrag_data {
+	int donor_fd;
+	int bsz;
+};
+
+struct e4defrag_options {
+	struct thread_data *td;
+	unsigned int inplace;
+	char * donor_name;
+};
+
+static struct fio_option options[] = {
+	{
+		.name	= "donorname",
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct e4defrag_options, donor_name),
+		.help	= "File used as a block donor",
+	},
+	{
+		.name	= "inplace",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct e4defrag_options, inplace),
+		.minval	= 0,
+		.maxval	= 1,
+		.help	= "Alloc and free space inside defrag event",
+	},
+	{
+		.name	= NULL,
+	},
+};
+
+static int fio_e4defrag_init(struct thread_data *td)
+{
+	int r, len = 0;
+	struct e4defrag_options *o = td->eo;
+	struct e4defrag_data *ed;
+	struct stat stub;
+	char donor_name[PATH_MAX];
+
+	if (!strlen(o->donor_name)) {
+		log_err("'donorname' options required\n");
+		return 1;
+	}
+
+	ed = malloc(sizeof(*ed));
+	if (!ed) {
+		td_verror(td, -ENOMEM, "io_queue_init");
+		return 1;
+	}
+	memset(ed, 0 ,sizeof(*ed));
+
+	if (td->o.directory)
+		len = sprintf(donor_name, "%s/", td->o.directory);
+	sprintf(donor_name + len, "%s", o->donor_name);
+
+	ed->donor_fd = open(donor_name, O_CREAT|O_WRONLY, 0644);
+	if (ed->donor_fd < 0) {
+		td_verror(td, ed->donor_fd, "io_queue_init");
+		log_err("Can't open donor file %s err:%d", ed->donor_fd);
+		free(ed);
+		return 1;
+	}
+
+	if (!o->inplace) {
+		long long len = td->o.file_size_high - td->o.start_offset;
+		r = fallocate(ed->donor_fd, 0, td->o.start_offset, len);
+		if (r)
+			goto err;
+	}
+	r = fstat(ed->donor_fd, &stub);
+	if (r)
+		goto err;
+
+	ed->bsz = stub.st_blksize;
+	td->io_ops->data = ed;
+	return 0;
+err:
+	td_verror(td, errno, "io_queue_init");
+	close(ed->donor_fd);
+	free(ed);
+	return 1;
+}
+
+static void fio_e4defrag_cleanup(struct thread_data *td)
+{
+	struct e4defrag_data *ed = td->io_ops->data;
+	if (ed) {
+		if (ed->donor_fd >= 0)
+			close(ed->donor_fd);
+		free(ed);
+	}
+}
+
+
+static int fio_e4defrag_queue(struct thread_data *td, struct io_u *io_u)
+{
+
+	int ret;
+	unsigned long long len;
+	struct move_extent me;
+	struct fio_file *f = io_u->file;
+	struct e4defrag_data *ed = td->io_ops->data;
+	struct e4defrag_options *o = td->eo;
+
+	fio_ro_check(td, io_u);
+
+	/* Theoretically defragmentation should not change data, but it
+	 * changes data layout. So this function handle only DDIR_WRITE
+	 * in order to satisfy strict read only access pattern
+	 */
+	if (io_u->ddir != DDIR_WRITE) {
+		io_u->error = errno;
+		return FIO_Q_COMPLETED;
+	}
+
+	if (o->inplace) {
+		ret = fallocate(ed->donor_fd, 0, io_u->offset, io_u->xfer_buflen);
+		if (ret) {
+			io_u->error = errno;
+			goto out;
+		}
+	}
+
+	memset(&me, 0, sizeof(me));
+	me.donor_fd = ed->donor_fd;
+	me.orig_start = io_u->offset / ed->bsz;
+	me.donor_start = me.orig_start;
+	len = (io_u->offset + io_u->xfer_buflen + ed->bsz -1);
+	me.len = len / ed->bsz - me.orig_start;
+
+	ret = ioctl(f->fd, EXT4_IOC_MOVE_EXT, &me);
+	len = me.moved_len * ed->bsz;
+
+	if (io_u->file && len >= 0 && ddir_rw(io_u->ddir))
+		io_u->file->file_pos = io_u->offset + len;
+
+	if (len > io_u->xfer_buflen)
+		len = io_u->xfer_buflen;
+
+	if (len != io_u->xfer_buflen) {
+		io_u->resid = io_u->xfer_buflen - len;
+		io_u->error = 0;
+	}
+	if (ret)
+		io_u->error = errno;
+	
+	if (o->inplace) {
+		ret = ftruncate(ed->donor_fd, 0);
+		if (ret)
+			io_u->error = errno;
+	}
+out:
+	if (io_u->error)
+		td_verror(td, errno, "xfer");
+
+
+	return FIO_Q_COMPLETED;
+}
+
+static struct ioengine_ops ioengine = {
+	.name			= "e4defrag",
+	.version		= FIO_IOOPS_VERSION,
+	.init			= fio_e4defrag_init,
+	.queue			= fio_e4defrag_queue,
+	.open_file		= generic_open_file,
+	.close_file		= generic_close_file,
+	.get_file_size		= generic_get_file_size,
+	.flags			= FIO_SYNCIO,
+	.cleanup		= fio_e4defrag_cleanup,
+	.options		= options,
+	.option_struct_size	= sizeof(struct e4defrag_options),
+
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
diff --git a/examples/e4defrag b/examples/e4defrag
new file mode 100644
index 0000000..d392149
--- /dev/null
+++ b/examples/e4defrag
@@ -0,0 +1,32 @@
+[global]
+
+direct=0
+buffered=0
+directory=/scratch
+
+nrfiles=1
+
+filesize=4G
+fadvise_hint=0
+
+group_reporting
+
+[defrag-fuzzer-8k]
+ioengine=e4defrag
+iodepth=1
+size=1G
+bs=8k
+donorname=file.def
+filename=file
+inplace=0
+rw=randwrite
+numjobs=1
+
+[random-aio-32k]
+ioengine=libaio
+iodepth=128
+bs=32k
+size=4G
+filename=file
+rw=randwrite
+numjobs=1
-- 
1.7.7.6

