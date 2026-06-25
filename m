Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F2425785C
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416501; cv=none; b=FP876FbAPPh7Z57FUtXKp6rPFJdVmM7zLYTn+NAXhIzZU3OpCyBbEBJEXLHjdkgHcZfX1ZxycbTcKWdC1/3CBq8FFqHqOouKpzLVPrI654YJQN0Zp+fmO6O0nbexbeMWd12LMOYXbzB5bsg04TiNBvA2uuLrZIz2pmjMReq/NQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416501; c=relaxed/simple;
	bh=YOytTo1YbU+8VqVnmDUg7l2fFKihqfbZqD/iK6Ptvg8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q7388FxGI3RD4TrOHlKWkNsRnEWaDIzKgRCo9PzHv8seT+BQTqy59GfP1siVUdscKOylyrzy2Bibx2tE4X1IEE304T4uHAksTJTiod3OAM4izy3CFLwHCk/XUM92kpuT4ajP6dyJj1PZVgxnPeL3CRv95CVlFWwYvjhwQSw0e7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kz5H4KY0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kz5H4KY0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 218421F000E9;
	Thu, 25 Jun 2026 19:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416500;
	bh=wWznmkaxdc8WC8oOqmjIZPYuIxJhKCciNu17aFCHeoI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Kz5H4KY0Mh6g6e/K12r+VEOwVtNPppBnT+scGZhunX4TGxsXU5V8Xuq5LVVuTqs0/
	 nRwt4MiRMveu9yGNQaYeCY7+7wmMi1dZc5MJBMzcPXmU6nlXzAYrvcKzbudQQZIWUZ
	 7MyBTsT45/Gl2end2xoMfpQgMvnkmkD8Jjp3EcAttvsu6Ct08n+VgzGBCqk5dsHJQY
	 wDH/Xr0RXAGhlDVcN97yffm9tbMpZJEe3c4c3V2pWyQ4dyxCR6Yw8v8LtZcXgPtVCw
	 ixROuxmijirvMZEagCmI4IxksLiCn3cKVVFxhaNOmzgyhaQf4dl44MtowgwDtEHrz8
	 mRqZFn/V1rWaw==
Date: Thu, 25 Jun 2026 12:41:39 -0700
Subject: [PATCH 3/4] fuse4fs: enable memory pressure monitoring with service
 containers
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <178241607459.1811120.4991014485565516712.stgit@frogsfrogsfrogs>
In-Reply-To: <178241607392.1811120.7216807779096078422.stgit@frogsfrogsfrogs>
References: <178241607392.1811120.7216807779096078422.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Ask the fuse filesystem service mount helper to open the memory pressure
stall files because we cannot open them ourselves.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 lib/support/psi.h |    9 +++++++
 fuse4fs/fuse4fs.c |   73 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 lib/support/psi.c |   53 ++++++++++++++++++++++++++++++++++++--
 3 files changed, 130 insertions(+), 5 deletions(-)


diff --git a/lib/support/psi.h b/lib/support/psi.h
index 675ebeb553da3e..916ebf15d17431 100644
--- a/lib/support/psi.h
+++ b/lib/support/psi.h
@@ -54,4 +54,13 @@ static inline bool psi_active(struct psi *psi)
 	return psi != NULL;
 }
 
+char *psi_system_path(enum psi_type type);
+ssize_t psi_cgroup_path(enum psi_type type, char *path, size_t pathsize);
+
+#define PSI_OPEN_FLAGS (O_RDWR | O_NONBLOCK)
+
+int psi_create_from(enum psi_type type, unsigned int psi_flags,
+		    uint64_t stall_us, uint64_t window_us, uint64_t timeout_us,
+		    int *system_fd, int *cgroup_fd, struct psi **psip);
+
 #endif /* __PSI_H__ */
diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 9b04d12f7c8762..83855e4c5e63d7 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -304,6 +304,8 @@ struct fuse4fs {
 	char *svc_cmdline;
 # endif
 	int bdev_fd;
+	int psi_sys_mem_fd;
+	int psi_cgroup_mem_fd;
 #endif
 	struct psi *mem_psi;
 	struct psi_handler *mem_psi_handler;
@@ -935,8 +937,16 @@ static int fuse4fs_psi_config(struct fuse4fs *ff)
 	 * Activate when there are memory stalls for 200ms every 2s; or
 	 * 5min goes by.  Unprivileged processes can only use 2s windows.
 	 */
-	err = psi_create(PSI_MEMORY, PSI_TRIM_HEAP, 20100, 2000000,
-			 5 * 60 * 1000000, &ff->mem_psi);
+#ifdef HAVE_FUSE4FS_SERVICE
+	if (fuse4fs_is_service(ff))
+		err = psi_create_from(PSI_MEMORY, PSI_TRIM_HEAP, 202002,
+				      2000000, 5 * 60 * 1000000,
+				      &ff->psi_sys_mem_fd,
+				      &ff->psi_cgroup_mem_fd, &ff->mem_psi);
+	else
+#endif
+		err = psi_create(PSI_MEMORY, PSI_TRIM_HEAP, 202002, 2000000,
+				 5 * 60 * 1000000, &ff->mem_psi);
 	if (err) {
 		switch (errno) {
 		case ENOENT:
@@ -1438,6 +1448,14 @@ static int fuse4fs_service_exit(struct fuse4fs *ff, int exitcode)
 	close(ff->bdev_fd);
 	ff->bdev_fd = -1;
 
+	if (ff->psi_sys_mem_fd >= 0)
+		close(ff->psi_sys_mem_fd);
+	ff->psi_sys_mem_fd = -1;
+
+	if (ff->psi_cgroup_mem_fd >= 0)
+		close(ff->psi_cgroup_mem_fd);
+	ff->psi_cgroup_mem_fd = -1;
+
 	return fuse_service_exit(exitcode);
 }
 
@@ -1480,12 +1498,61 @@ static int fuse4fs_service_open_bdev(struct fuse4fs *ff)
 	return 0;
 }
 
+/* Open pressure stall control files for self monitoring */
+static int fuse4fs_service_open_psi_controls(struct fuse4fs *ff)
+{
+	const char *psifile = psi_system_path(PSI_MEMORY);
+	char cgpath[PATH_MAX];
+	ssize_t cgpathlen;
+	int fd;
+	int ret;
+
+	ret = fuse_service_request_file(ff->service, psifile, PSI_OPEN_FLAGS,
+					0, FUSE_SERVICE_REQUEST_FILE_QUIET);
+	if (ret)
+		return ret;
+
+	ret = fuse_service_receive_file(ff->service, psifile, &fd);
+	if (ret)
+		return ret;
+	if (fd < 0)
+		err_printf(ff, "%s %s: %s.\n",
+			   _("opening system memory pressure monitor"),
+			   psifile, strerror(-fd));
+	ff->psi_sys_mem_fd = fd;
+
+	cgpathlen = psi_cgroup_path(PSI_MEMORY, cgpath, sizeof(cgpath));
+	if (!cgpathlen || cgpathlen >= sizeof(cgpath))
+		return 0;
+
+	ret = fuse_service_request_file(ff->service, cgpath, PSI_OPEN_FLAGS,
+					0, FUSE_SERVICE_REQUEST_FILE_QUIET);
+	if (ret)
+		return ret;
+
+	ret = fuse_service_receive_file(ff->service, cgpath, &fd);
+	if (ret)
+		return ret;
+	if (fd < 0)
+		err_printf(ff, "%s %s: %s.\n",
+			   _("opening cgroup memory pressure monitor"),
+			   cgpath, strerror(-fd));
+	ff->psi_sys_mem_fd = fd;
+
+	return 0;
+}
+
 static int fuse4fs_service_get_config(struct fuse4fs *ff)
 {
 	int ret, ret2;
 
 	ret = fuse4fs_service_open_bdev(ff);
+	if (ret)
+		goto out_seal;
 
+	ret = fuse4fs_service_open_psi_controls(ff);
+
+out_seal:
 	/* Always prevent further fds from being added to our file table */
 	ret2 = fuse_service_finish_file_requests(ff->service);
 	if (ret2 && !ret)
@@ -6551,6 +6618,8 @@ int main(int argc, char *argv[])
 		.opstate = F4OP_WRITABLE,
 #ifdef HAVE_FUSE4FS_SERVICE
 		.bdev_fd = -1,
+		.psi_sys_mem_fd = -1,
+		.psi_cgroup_mem_fd = -1,
 #endif
 	};
 	errcode_t err;
diff --git a/lib/support/psi.c b/lib/support/psi.c
index 26ce6ee1985641..531ae935701edf 100644
--- a/lib/support/psi.c
+++ b/lib/support/psi.c
@@ -54,7 +54,7 @@ struct psi {
 	enum psi_state state;
 };
 
-static const char *psi_system_path(enum psi_type type)
+char *psi_system_path(enum psi_type type)
 {
 	switch (type) {
 	case PSI_MEMORY:
@@ -300,7 +300,7 @@ void psi_destroy(struct psi **psip)
 
 static int psi_open_control(const char *path)
 {
-	return open(path, O_RDWR | O_NONBLOCK);
+	return open(path, PSI_OPEN_FLAGS);
 }
 
 static void psi_open_system_control(struct psi *psi)
@@ -309,7 +309,7 @@ static void psi_open_system_control(struct psi *psi)
 	psi->system_fd = psi_open_control(psi_system_path(psi->type));
 }
 
-static ssize_t psi_cgroup_path(enum psi_type type, char *path, size_t pathsize)
+ssize_t psi_cgroup_path(enum psi_type type, char *path, size_t pathsize)
 {
 	char cgpath[PATH_MAX];
 	char *p = cgpath;
@@ -485,6 +485,53 @@ int psi_create(enum psi_type type, unsigned int psi_flags, uint64_t stall_us,
 	return -1;
 }
 
+/*
+ * Same as psi_create, but you can specify the whole-system and per-cgroup
+ * monitoring fds.
+ */
+int psi_create_from(enum psi_type type, unsigned int psi_flags,
+		    uint64_t stall_us, uint64_t window_us, uint64_t timeout_us,
+		    int *system_fd, int *cgroup_fd, struct psi **psip)
+{
+	struct psi *psi;
+	int ret;
+
+	if (psi_flags & ~PSI_FLAGS) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	psi = psi_alloc(type, psi_flags, timeout_us);
+	if (!psi)
+		return -1;
+
+	psi->system_fd = *system_fd;
+	psi->cgroup_fd = *cgroup_fd;
+
+	*system_fd = -1;
+	*cgroup_fd = -1;
+
+	if (psi->system_fd < 0 && psi->cgroup_fd < 0 && !psi->timeout_us) {
+		errno = ENOENT;
+		goto out_fds;
+	}
+
+	ret = psi_config_fd(psi, psi->system_fd, stall_us, window_us);
+	if (ret)
+		goto out_fds;
+
+	ret = psi_config_fd(psi, psi->cgroup_fd, stall_us, window_us);
+	if (ret)
+		goto out_fds;
+
+	*psip = psi;
+	return 0;
+
+out_fds:
+	psi_destroy(&psi);
+	return -1;
+}
+
 /* Start monitoring for resource pressure stalls */
 int psi_start_thread(struct psi *psi)
 {

