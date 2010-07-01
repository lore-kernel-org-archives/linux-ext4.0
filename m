From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/3] xstat: Provide a mechanism to gather extra results for
	[f]xstat() [ver #4]
Date: Fri, 02 Jul 2010 00:57:33 +0100
Message-ID: <20100701235733.19035.14966.stgit@warthog.procyon.org.uk>
References: <20100701235727.19035.84584.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org, linux-ext4@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20100701235727.19035.84584.stgit@warthog.procyon.org.uk>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-ext4.vger.kernel.org

Provide a mechanism in the kernel by which extra results beyond those allocated
space in the xstat struct can be returned to userspace.

[I'm not sure this is the best way to do this; it's a bit unwieldy.  However,
 I'd rather not overburden struct kstat with fields for every extra result we
 might want to return as it's allocated on the stack in various places.
 Possibly the pass_result of struct xstat_extra_result could be placed in
 struct kstat to be used if pass_result is non-NULL, and struct kstat could be
 passed to container_of().]

This is modelled on the filldir approach used to read directory entries.  This
allows kernel routines (such as NFSD) to access this information too.

A new inode operation (getattr_extra) is provided that interested filesystems
need to implement.  If this is not provided, then it is assumed that no extra
results will be returned.

The getattr_extra() routine is passed a token to represent the request:

	struct xstat_extra_result {
		u64			request_mask;
		struct kstat		*stat;
		xstat_extra_result_t	pass_result;
	};

The three fields in this struct are: the request_mask (with bits not
representing extra results edited out); the pointer to the kstat structure as
passed to getattr() (stat->query_flags may be useful); and a pointer to a
function to which each individual result should be passed.

The requests can be handled in order with something like the following:

	u64 request_mask = token->request_mask;
	do {
		int request = __ffs64(request_mask);
		request_mask &= ~(1ULL << request);
		switch (request) {
		case ilog2(XSTAT_REQUEST_FOO): {
			struct xstat_foo foo;
			ret = myfs_get_foo(inode, token, &foo);
			if (!ret)
				token->pass_result(token, request,
						   &foo, sizeof(foo));
			break;
		}
		default:
			ret = 0;
			break;
		}
	} while (ret == 0 && request_mask);

The caller should probably embed token in something so that they can retrieve
it in the pass_result() function with container_of().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/stat.c            |   98 ++++++++++++++++++++++++++++++++++++++++++--------
 include/linux/fs.h   |   12 +++++-
 include/linux/stat.h |   27 ++++++++++++++
 3 files changed, 119 insertions(+), 18 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index defed4f..b2eaa82 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -108,6 +108,25 @@ int vfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 }
 EXPORT_SYMBOL(vfs_getattr);
 
+/*
+ * Get the extra stat results
+ */
+static int vfs_get_xstat_extra_results(struct path *path,
+				       struct xstat_extra_result *extra)
+{
+	struct vfsmount *mnt = path->mnt;
+	struct dentry *dentry = path->dentry;
+	struct inode *inode = dentry->d_inode;
+
+	if (extra && inode->i_op->getattr_extra) {
+		extra->request_mask =
+			extra->stat->request_mask & XSTAT_REQUEST__EXTRA_STATS;
+		if (extra->request_mask)
+			return inode->i_op->getattr_extra(mnt, dentry, extra);
+	}
+	return 0;
+}
+
 /**
  * vfs_fxstat - Get extended attributes by file descriptor
  * @fd: The file descriptor refering to the file of interest
@@ -121,7 +140,8 @@ EXPORT_SYMBOL(vfs_getattr);
  *
  * 0 will be returned on success, and a -ve error code if unsuccessful.
  */
-int vfs_fxstat(unsigned int fd, struct kstat *stat)
+int vfs_fxstat(unsigned int fd, struct kstat *stat,
+	       struct xstat_extra_result *extra)
 {
 	struct file *f = fget(fd);
 	int error = -EBADF;
@@ -130,6 +150,8 @@ int vfs_fxstat(unsigned int fd, struct kstat *stat)
 		return -EINVAL;
 	if (f) {
 		error = vfs_xgetattr(f->f_path.mnt, f->f_path.dentry, stat);
+		if (!error)
+			error = vfs_get_xstat_extra_results(&f->f_path, extra);
 		fput(f);
 	}
 	return error;
@@ -150,7 +172,7 @@ int vfs_fstat(unsigned int fd, struct kstat *stat)
 {
 	stat->query_flags = 0;
 	stat->request_mask = XSTAT_REQUEST__BASIC_STATS;
-	return vfs_fxstat(fd, stat);
+	return vfs_fxstat(fd, stat, NULL);
 }
 EXPORT_SYMBOL(vfs_fstat);
 
@@ -172,7 +194,7 @@ EXPORT_SYMBOL(vfs_fstat);
  * 0 will be returned on success, and a -ve error code if unsuccessful.
  */
 int vfs_xstat(int dfd, const char __user *filename, int flags,
-	      struct kstat *stat)
+	      struct kstat *stat, struct xstat_extra_result *extra)
 {
 	struct path path;
 	int error, lookup_flags;
@@ -186,6 +208,8 @@ int vfs_xstat(int dfd, const char __user *filename, int flags,
 	error = user_path_at(dfd, filename, lookup_flags, &path);
 	if (!error) {
 		error = vfs_xgetattr(path.mnt, path.dentry, stat);
+		if (!error)
+			error = vfs_get_xstat_extra_results(&path, extra);
 		path_put(&path);
 	}
 	return error;
@@ -210,7 +234,7 @@ int vfs_fstatat(int dfd, const char __user *filename, struct kstat *stat,
 		int flags)
 {
 	stat->request_mask = XSTAT_REQUEST__BASIC_STATS;
-	return vfs_xstat(dfd, filename, flags, stat);
+	return vfs_xstat(dfd, filename, flags, stat, NULL);
 }
 EXPORT_SYMBOL(vfs_fstatat);
 
@@ -229,7 +253,7 @@ EXPORT_SYMBOL(vfs_fstatat);
 int vfs_stat(const char __user *filename, struct kstat *stat)
 {
 	stat->request_mask = XSTAT_REQUEST__BASIC_STATS;
-	return vfs_xstat(AT_FDCWD, filename, 0, stat);
+	return vfs_xstat(AT_FDCWD, filename, 0, stat, NULL);
 }
 EXPORT_SYMBOL(vfs_stat);
 
@@ -247,7 +271,7 @@ EXPORT_SYMBOL(vfs_stat);
  */
 int vfs_lstat(const char __user *name, struct kstat *stat)
 {
-	return vfs_xstat(AT_FDCWD, name, AT_SYMLINK_NOFOLLOW, stat);
+	return vfs_xstat(AT_FDCWD, name, AT_SYMLINK_NOFOLLOW, stat, NULL);
 }
 EXPORT_SYMBOL(vfs_lstat);
 
@@ -555,16 +579,51 @@ SYSCALL_DEFINE4(fstatat64, int, dfd, const char __user *, filename,
 }
 #endif /* __ARCH_WANT_STAT64 */
 
+struct xstat_extra_result_token {
+	struct xstat_extra_result	extra;
+	void __user			*buffer;
+	size_t				buf_remain;
+	size_t				fill_size;
+};
+
+/*
+ * copy extra results to userspace
+ */
+static int xstat_pass_result(struct xstat_extra_result *extra,
+			     unsigned request, const void *result,
+			     size_t len)
+{
+	struct xstat_extra_result_token *token =
+		container_of(extra, struct xstat_extra_result_token, extra);
+
+	/* we shouldn't see anything that wasn't asked for */
+	BUG_ON(!((token->extra.request_mask >> request) & 1));
+	token->extra.stat->result_mask |= 1ULL << request;
+	token->fill_size += len;
+
+	if (len > token->buf_remain)
+		len = token->buf_remain;
+	if (copy_to_user(token->buffer, result, len) != 0)
+		return -EFAULT;
+	token->buffer += len;
+	token->buf_remain -= len;
+	return 0;
+}
+
 /*
  * Get the xstat parameters if supplied
  */
 static int xstat_get_params(struct xstat_parameters __user *_params,
-			    struct kstat *stat)
+			    struct xstat __user *buffer, size_t bufsize,
+			    struct kstat *stat,
+			    struct xstat_extra_result_token *token)
 {
 	struct xstat_parameters params;
 
 	memset(stat, 0xde, sizeof(*stat));	// DEBUGGING
 
+	if (!buffer)
+		return -EINVAL;
 	if (_params) {
 		if (copy_from_user(&params, _params, sizeof(params)) != 0)
 			return -EFAULT;
@@ -574,6 +633,12 @@ static int xstat_get_params(struct xstat_parameters __user *_params,
 		stat->request_mask = XSTAT_REQUEST__EXTENDED_STATS;
 	}
 	stat->result_mask = 0;
+	token->extra.stat = stat;
+	token->extra.pass_result = xstat_pass_result;
+	token->buffer = buffer->st_extra_results;
+	token->buf_remain = token->fill_size = 0;
+	if (bufsize > sizeof(struct xstat))
+		token->buf_remain = bufsize - sizeof(struct xstat);
 	return 0;
 }
 
@@ -582,7 +647,8 @@ static int xstat_get_params(struct xstat_parameters __user *_params,
  * into the buffer
  */
 static long xstat_set_result(struct kstat *stat,
-			     struct xstat __user *buffer, size_t bufsize)
+			     struct xstat __user *buffer, size_t bufsize,
+			     struct xstat_extra_result_token *token)
 {
 	struct xstat tmp;
 	size_t copy;
@@ -623,7 +689,7 @@ static long xstat_set_result(struct kstat *stat,
 		copy = bufsize;
 	if (copy_to_user(buffer, &tmp, copy) != 0)
 		return -EFAULT;
-	return sizeof(tmp);
+	return sizeof(tmp) + token->fill_size;
 }
 
 /*
@@ -634,16 +700,17 @@ SYSCALL_DEFINE6(xstat,
 		struct xstat_parameters __user *, params,
 		struct xstat __user *, buffer, size_t, bufsize)
 {
+	struct xstat_extra_result_token token;
 	struct kstat stat;
 	int error;
 
-	error = xstat_get_params(params, &stat);
+	error = xstat_get_params(params, buffer, bufsize, &stat, &token);
 	if (error != 0)
 		return error;
-	error = vfs_xstat(dfd, filename, atflag, &stat);
+	error = vfs_xstat(dfd, filename, atflag, &stat, &token.extra);
 	if (error)
 		return error;
-	return xstat_set_result(&stat, buffer, bufsize);
+	return xstat_set_result(&stat, buffer, bufsize, &token);
 }
 
 /*
@@ -653,18 +720,19 @@ SYSCALL_DEFINE5(fxstat, unsigned int, fd, unsigned int, flags,
 		struct xstat_parameters __user *, params,
 		struct xstat __user *, buffer, size_t, bufsize)
 {
+	struct xstat_extra_result_token token;
 	struct kstat stat;
 	int error;
 
-	error = xstat_get_params(params, &stat);
+	error = xstat_get_params(params, buffer, bufsize, &stat, &token);
 	if (error < 0)
 		return error;
 	stat.query_flags = flags;
-	error = vfs_fxstat(fd, &stat);
+	error = vfs_fxstat(fd, &stat, &token.extra);
 	if (error)
 		return error;
 
-	return xstat_set_result(&stat, buffer, bufsize);
+	return xstat_set_result(&stat, buffer, bufsize, &token);
 }
 
 /* Caller is here responsible for sufficient locking (ie. inode->i_lock) */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 37cadd8..48616db 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1529,7 +1529,9 @@ struct inode_operations {
 	int (*permission) (struct inode *, int);
 	int (*check_acl)(struct inode *, int);
 	int (*setattr) (struct dentry *, struct iattr *);
-	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
+	int (*getattr) (struct vfsmount *, struct dentry *, struct kstat *);
+	int (*getattr_extra) (struct vfsmount *, struct dentry *,
+			      struct xstat_extra_result *);
 	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
 	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
@@ -2332,6 +2334,8 @@ extern int generic_readlink(struct dentry *, char __user *, int);
 extern void generic_fillattr(struct inode *, struct kstat *);
 extern int vfs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int vfs_xgetattr(struct vfsmount *, struct dentry *, struct kstat *);
+extern int vfs_xgetattr_extra(struct vfsmount *, struct dentry *, struct kstat *,
+			      xstat_extra_result_t, void *);
 void __inode_add_bytes(struct inode *inode, loff_t bytes);
 void inode_add_bytes(struct inode *inode, loff_t bytes);
 void inode_sub_bytes(struct inode *inode, loff_t bytes);
@@ -2344,8 +2348,10 @@ extern int vfs_stat(const char __user *, struct kstat *);
 extern int vfs_lstat(const char __user *, struct kstat *);
 extern int vfs_fstat(unsigned int, struct kstat *);
 extern int vfs_fstatat(int , const char __user *, struct kstat *, int);
-extern int vfs_xstat(int, const char __user *, int, struct kstat *);
-extern int vfs_xfstat(unsigned int, struct kstat *);
+extern int vfs_xstat(int, const char __user *, int, struct kstat *,
+		     struct xstat_extra_result *);
+extern int vfs_xfstat(unsigned int, struct kstat *,
+		      struct xstat_extra_result *);
 
 extern int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		    unsigned long arg);
diff --git a/include/linux/stat.h b/include/linux/stat.h
index e0b89e4..9e27f88 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -108,6 +108,7 @@ struct xstat_parameters {
 #define XSTAT_REQUEST_DATA_VERSION	0x00002000ULL	/* want/got st_data_version */
 #define XSTAT_REQUEST__EXTENDED_STATS	0x00003fffULL	/* the stuff in the xstat struct */
 #define XSTAT_REQUEST__ALL_STATS	0x00003fffULL	/* the defined set of requestables */
+#define XSTAT_REQUEST__EXTRA_STATS	(XSTAT_REQUEST__ALL_STATS & ~XSTAT_REQUEST__EXTENDED_STATS)
 };
 
 struct xstat_dev {
@@ -152,6 +153,32 @@ struct xstat {
 #include <linux/types.h>
 #include <linux/time.h>
 
+/**
+ * xstat_extra_result_t - Function to call to return extra stat results
+ * @token: The token given to the caller
+ * @request: The bit number of the request
+ * @result: The result data to include
+ * @len: The length of the result data
+ *
+ * Request is the bit number from one of the bits that may be set in
+ * (kstat->request_mask & XSTAT_REQUEST__EXTRA_STATS).
+ *
+ * The results must be passed in ascending order of bit number.
+ */
+struct xstat_extra_result;
+typedef int (*xstat_extra_result_t)(struct xstat_extra_result *token,
+				    unsigned request, const void *result,
+				    size_t len);
+
+struct xstat_extra_result {
+	u64			request_mask;
+	struct kstat		*stat;
+	xstat_extra_result_t	pass_result;
+};
+
+/*
+ * Linux's internal stat record, obtained by vfs_[x]getattr()
+ */
 struct kstat {
 	u64		ino;
 	dev_t		dev;
