From: Jinshan Xiong <jinshan.xiong@intel.com>
Subject: [PATCH] staging/lustre/llite: remove lustre_generic_file_{read,write}
Date: Tue, 11 Feb 2014 21:32:44 -0800
Message-ID: <1392183164-49332-1-git-send-email-jinshan.xiong@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	andreas.dilger@intel.com, tao.peng@emc.com,
	Jinshan Xiong <jinshan.xiong@intel.com>
To: greg@kroah.com, viro@zeniv.linux.org.uk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:32874 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbaBLFcq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Feb 2014 00:32:46 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It looks like lustre_generic_file_{read,write} are a holdover from
2.6.19 where generic_file_aio_read() replaced generic_file_readv()
and cross-kernel interoperability was required for some period of
time. Lustre has since removed support for those older kernels, but
it looks like the wrappers were not deleted at that time. This patch
will delete them.

Pass &iocb->ki_pos as the last argument for these functions instead
of crw_pos, since this is the convention for other callers.  Verify
that this is the same as the current crw_pos argument.  This code can
likely be cleaned up further in a later patch.

Signed-off-by: Jinshan Xiong <jinshan.xiong@intel.com>
---
 drivers/staging/lustre/lustre/include/lclient.h    |  2 +-
 drivers/staging/lustre/lustre/llite/file.c         |  4 ---
 .../staging/lustre/lustre/llite/llite_internal.h   | 12 +--------
 drivers/staging/lustre/lustre/llite/rw.c           |  2 +-
 drivers/staging/lustre/lustre/llite/vvp_io.c       | 31 ++++++++--------------
 5 files changed, 14 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lclient.h b/drivers/staging/lustre/lustre/include/lclient.h
index 27316f7..de8f82c 100644
--- a/drivers/staging/lustre/lustre/include/lclient.h
+++ b/drivers/staging/lustre/lustre/include/lclient.h
@@ -118,7 +118,7 @@ struct ccc_io {
 };
 
 /**
- * True, if \a io is a normal io, False for other (sendfile, splice*).
+ * True, if \a io is a normal io, False for splice_{read,write}.
  * must be impementated in arch specific code.
  */
 int cl_is_normalio(const struct lu_env *env, const struct cl_io *io);
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index c12821a..6f8a4cf 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -1092,10 +1092,6 @@ restart:
 				down_read(&lli->lli_trunc_sem);
 			}
 			break;
-		case IO_SENDFILE:
-			vio->u.sendfile.cui_actor = args->u.sendfile.via_actor;
-			vio->u.sendfile.cui_target = args->u.sendfile.via_target;
-			break;
 		case IO_SPLICE:
 			vio->u.splice.cui_pipe = args->u.splice.via_pipe;
 			vio->u.splice.cui_flags = args->u.splice.via_flags;
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 7ee5c02..9949036 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -919,8 +919,6 @@ void vvp_write_complete(struct ccc_object *club, struct ccc_page *page);
 enum vvp_io_subtype {
 	/** normal IO */
 	IO_NORMAL,
-	/** io called from .sendfile */
-	IO_SENDFILE,
 	/** io started from splice_{read|write} */
 	IO_SPLICE
 };
@@ -932,10 +930,6 @@ struct vvp_io {
 
 	union {
 		struct {
-			read_actor_t      cui_actor;
-			void	     *cui_target;
-		} sendfile;
-		struct {
 			struct pipe_inode_info *cui_pipe;
 			unsigned int	    cui_flags;
 		} splice;
@@ -981,7 +975,7 @@ struct vvp_io {
  * IO arguments for various VFS I/O interfaces.
  */
 struct vvp_io_args {
-	/** normal/sendfile/splice */
+	/** normal/splice */
 	enum vvp_io_subtype via_io_subtype;
 
 	union {
@@ -991,10 +985,6 @@ struct vvp_io_args {
 			unsigned long      via_nrsegs;
 		} normal;
 		struct {
-			read_actor_t       via_actor;
-			void	      *via_target;
-		} sendfile;
-		struct {
 			struct pipe_inode_info  *via_pipe;
 			unsigned int       via_flags;
 		} splice;
diff --git a/drivers/staging/lustre/lustre/llite/rw.c b/drivers/staging/lustre/lustre/llite/rw.c
index e9ba38a..ca8fa4e 100644
--- a/drivers/staging/lustre/lustre/llite/rw.c
+++ b/drivers/staging/lustre/lustre/llite/rw.c
@@ -135,7 +135,7 @@ static struct ll_cl_context *ll_cl_init(struct file *file,
 		}
 
 		/*
-		 * Loop-back driver calls ->prepare_write() and ->sendfile()
+		 * Loop-back driver calls ->prepare_write().
 		 * methods directly, bypassing file system ->write() operation,
 		 * so cl_io has to be created here.
 		 */
diff --git a/drivers/staging/lustre/lustre/llite/vvp_io.c b/drivers/staging/lustre/lustre/llite/vvp_io.c
index 93cbfbb..50383d3 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_io.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_io.c
@@ -51,7 +51,7 @@ static struct vvp_io *cl2vvp_io(const struct lu_env *env,
 				const struct cl_io_slice *slice);
 
 /**
- * True, if \a io is a normal io, False for sendfile() / splice_{read|write}
+ * True, if \a io is a normal io, False for splice_{read,write}
  */
 int cl_is_normalio(const struct lu_env *env, const struct cl_io *io)
 {
@@ -474,20 +474,6 @@ static void vvp_io_setattr_fini(const struct lu_env *env,
 	vvp_io_fini(env, ios);
 }
 
-static ssize_t lustre_generic_file_read(struct file *file,
-					struct ccc_io *vio, loff_t *ppos)
-{
-	return generic_file_aio_read(vio->cui_iocb, vio->cui_iov,
-				     vio->cui_nrsegs, *ppos);
-}
-
-static ssize_t lustre_generic_file_write(struct file *file,
-					struct ccc_io *vio, loff_t *ppos)
-{
-	return generic_file_aio_write(vio->cui_iocb, vio->cui_iov,
-				      vio->cui_nrsegs, *ppos);
-}
-
 static int vvp_io_read_start(const struct lu_env *env,
 			     const struct cl_io_slice *ios)
 {
@@ -540,8 +526,11 @@ static int vvp_io_read_start(const struct lu_env *env,
 	file_accessed(file);
 	switch (vio->cui_io_subtype) {
 	case IO_NORMAL:
-		 result = lustre_generic_file_read(file, cio, &pos);
-		 break;
+		LASSERT(cio->cui_iocb->ki_pos == pos);
+		result = generic_file_aio_read(cio->cui_iocb,
+					       cio->cui_iov, cio->cui_nrsegs,
+					       cio->cui_iocb->ki_pos);
+		break;
 	case IO_SPLICE:
 		result = generic_file_splice_read(file, &pos,
 				vio->u.splice.cui_pipe, cnt,
@@ -586,7 +575,6 @@ static int vvp_io_write_start(const struct lu_env *env,
 	struct cl_io       *io    = ios->cis_io;
 	struct cl_object   *obj   = io->ci_obj;
 	struct inode       *inode = ccc_object_inode(obj);
-	struct file	*file  = cio->cui_fd->fd_file;
 	ssize_t result = 0;
 	loff_t pos = io->u.ci_wr.wr.crw_pos;
 	size_t cnt = io->u.ci_wr.wr.crw_count;
@@ -601,6 +589,8 @@ static int vvp_io_write_start(const struct lu_env *env,
 		 */
 		pos = io->u.ci_wr.wr.crw_pos = i_size_read(inode);
 		cio->cui_iocb->ki_pos = pos;
+	} else {
+		LASSERT(cio->cui_iocb->ki_pos == pos);
 	}
 
 	CDEBUG(D_VFSTRACE, "write: [%lli, %lli)\n", pos, pos + (long long)cnt);
@@ -608,8 +598,9 @@ static int vvp_io_write_start(const struct lu_env *env,
 	if (cio->cui_iov == NULL) /* from a temp io in ll_cl_init(). */
 		result = 0;
 	else
-		result = lustre_generic_file_write(file, cio, &pos);
