Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8293637C0F7;
	Mon, 23 Feb 2026 23:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771889200; cv=none; b=oPouqvNa8+ig5gUjrlj9uSWdKpXBYvi0MF+GrMVu1sfbvFcYABqaCxBKPcA+1IaGt5HMsqPjF51PNuSI7xSQeFolwslMrJQHajjpHBut/DDc0EPfBjN4FiF3Bnn9iEVSRHYAp5vvEVZpYxD7K1i8OjVbV9afYTH36RZOAbS8Frk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771889200; c=relaxed/simple;
	bh=boz0XzPWqnMhLozCHpaFxedLj2f1DlgXaeDV3k7Ci7k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JbxZRfQoO4zoi8YiAwuM204iB8llr+a8Gz9v3rkg4Z9K2WhJWnOXiGATr1hvDp6jXKRCaCC7FtygBqw18jgk2yyV5x8xV9F6L1OTWyK5FGjSaW8OSA0IBsaH5URzQo706eWZnAKX3xejnjawFncdiwQCbY3AVvmXqdcmAQEN+sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LzhM2Mc7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LzhM2Mc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECA9C19421;
	Mon, 23 Feb 2026 23:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771889200;
	bh=boz0XzPWqnMhLozCHpaFxedLj2f1DlgXaeDV3k7Ci7k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LzhM2Mc7ZhygzEo8riqMRda/OQ04BR6tX5ZjV8rqr9nWn9MigIbMZuLuDPnFGj0ca
	 N3+vUKed8Fsz81I3miAD22ENqLs0tpWgqvInO7pRLZQAp+iIi/ARtTMQr6MoywI3me
	 BBDd7I3BRw163JmjIo/TyLrmn5fPRmCHNpOe42HtamqZUlM+jHuUjOaHbt4CghO6FZ
	 GS5OtEoaDKKbftlcOsGF84YCOPUrBYiIZYkNKQK9rwmyCdFkAUqTnSBKGp3aFk2Aqy
	 4HzFAq72ZKZnXWq4pdfwGGaH0SqP8nf9/Pq1pGsLR122gEUwyhWL/wttmNrpD/GPLS
	 TKA4G86QZDNBQ==
Date: Mon, 23 Feb 2026 15:26:39 -0800
Subject: [PATCH 05/25] libfuse: add upper level iomap commands
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, bschubert@ddn.com
Cc: bernd@bsbernd.com, miklos@szeredi.hu, neal@gompa.dev,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 bpf@vger.kernel.org, joannelkoong@gmail.com
Message-ID: <177188740026.3940670.6750030552213407506.stgit@frogsfrogsfrogs>
In-Reply-To: <177188739839.3940670.15233996351019069073.stgit@frogsfrogsfrogs>
References: <177188739839.3940670.15233996351019069073.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Teach the upper level fuse library about the iomap begin and end
operations, and connect it to the lower level.  This is needed for
fuse2fs to start using iomap.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 include/fuse.h |   17 +++++++++
 lib/fuse.c     |  102 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 119 insertions(+)


diff --git a/include/fuse.h b/include/fuse.h
index 595cac07f2be36..1c8caf0c2ee034 100644
--- a/include/fuse.h
+++ b/include/fuse.h
@@ -885,6 +885,23 @@ struct fuse_operations {
 	 * calling fsync(2) on every file on the filesystem.
 	 */
 	int (*syncfs)(const char *path);
+
+	/**
+	 * Send a mapping to the kernel so that a file IO operation can run.
+	 */
+	int (*iomap_begin) (const char *path, uint64_t nodeid,
+			    uint64_t attr_ino, off_t pos_in,
+			    uint64_t length_in, uint32_t opflags_in,
+			    struct fuse_file_iomap *read_out,
+			    struct fuse_file_iomap *write_out);
+
+	/**
+	 * Respond to the outcome of a previous file mapping operation.
+	 */
+	int (*iomap_end) (const char *path, uint64_t nodeid, uint64_t attr_ino,
+			  off_t pos_in, uint64_t length_in,
+			  uint32_t opflags_in, ssize_t written_in,
+			  const struct fuse_file_iomap *iomap);
 };
 
 /** Extra context that may be needed by some filesystems
diff --git a/lib/fuse.c b/lib/fuse.c
index 65c3ce217a7784..ac325b1a3d9e82 100644
--- a/lib/fuse.c
+++ b/lib/fuse.c
@@ -2804,6 +2804,49 @@ int fuse_fs_chmod(struct fuse_fs *fs, const char *path, mode_t mode,
 	return fs->op.chmod(path, mode, fi);
 }
 
+static int fuse_fs_iomap_begin(struct fuse_fs *fs, const char *path,
+			       fuse_ino_t nodeid, uint64_t attr_ino, off_t pos,
+			       uint64_t count, uint32_t opflags,
+			       struct fuse_file_iomap *read,
+			       struct fuse_file_iomap *write)
+{
+	fuse_get_context()->private_data = fs->user_data;
+	if (!fs->op.iomap_begin)
+		return -ENOSYS;
+
+	if (fs->debug) {
+		fuse_log(FUSE_LOG_DEBUG,
+			 "iomap_begin[%s] nodeid %llu attr_ino %llu pos %llu count %llu opflags 0x%x\n",
+			 path, (unsigned long long)nodeid,
+			 (unsigned long long)attr_ino, (unsigned long long)pos,
+			 (unsigned long long)count, opflags);
+	}
+
+	return fs->op.iomap_begin(path, nodeid, attr_ino, pos, count, opflags,
+				  read, write);
+}
+
+static int fuse_fs_iomap_end(struct fuse_fs *fs, const char *path,
+			     fuse_ino_t nodeid, uint64_t attr_ino, off_t pos,
+			     uint64_t count, uint32_t opflags, ssize_t written,
+			     const struct fuse_file_iomap *iomap)
+{
+	fuse_get_context()->private_data = fs->user_data;
+	if (!fs->op.iomap_end)
+		return -ENOSYS;
+
+	if (fs->debug) {
+		fuse_log(FUSE_LOG_DEBUG,
+			 "iomap_end[%s] nodeid %llu attr_ino %llu pos %llu count %llu opflags 0x%x written %zd\n",
+			 path, (unsigned long long)nodeid,
+			 (unsigned long long)attr_ino, (unsigned long long)pos,
+			 (unsigned long long)count, opflags, written);
+	}
+
+	return fs->op.iomap_end(path, nodeid, attr_ino, pos, count, opflags,
+				written, iomap);
+}
+
 static void fuse_lib_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
 			     int valid, struct fuse_file_info *fi)
 {
@@ -4497,6 +4540,63 @@ static void fuse_lib_syncfs(fuse_req_t req, fuse_ino_t ino)
 	reply_err(req, err);
 }
 
+static void fuse_lib_iomap_begin(fuse_req_t req, fuse_ino_t nodeid,
+				 uint64_t attr_ino, off_t pos, uint64_t count,
+				 uint32_t opflags)
+{
+	struct fuse *f = req_fuse_prepare(req);
+	struct fuse_file_iomap read = { };
+	struct fuse_file_iomap write = { };
+	struct fuse_intr_data d;
+	char *path;
+	int err;
+
+	err = get_path_nullok(f, nodeid, &path);
+	if (err) {
+		reply_err(req, err);
+		return;
+	}
+
+	fuse_prepare_interrupt(f, req, &d);
+	err = fuse_fs_iomap_begin(f->fs, path, nodeid, attr_ino, pos, count,
+				  opflags, &read, &write);
+	fuse_finish_interrupt(f, req, &d);
+	free_path(f, nodeid, path);
+	if (err) {
+		reply_err(req, err);
+		return;
+	}
+
+	if (write.length == 0)
+		fuse_iomap_pure_overwrite(&write, &read);
+
+	fuse_reply_iomap_begin(req, &read, &write);
+}
+
+static void fuse_lib_iomap_end(fuse_req_t req, fuse_ino_t nodeid,
+			       uint64_t attr_ino, off_t pos, uint64_t count,
+			       uint32_t opflags, ssize_t written,
+			       const struct fuse_file_iomap *iomap)
+{
+	struct fuse *f = req_fuse_prepare(req);
+	struct fuse_intr_data d;
+	char *path;
+	int err;
+
+	err = get_path_nullok(f, nodeid, &path);
+	if (err) {
+		reply_err(req, err);
+		return;
+	}
+
+	fuse_prepare_interrupt(f, req, &d);
+	err = fuse_fs_iomap_end(f->fs, path, nodeid, attr_ino, pos, count,
+				opflags, written, iomap);
+	fuse_finish_interrupt(f, req, &d);
+	free_path(f, nodeid, path);
+	reply_err(req, err);
+}
+
 static int clean_delay(struct fuse *f)
 {
 	/*
@@ -4599,6 +4699,8 @@ static struct fuse_lowlevel_ops fuse_path_ops = {
 	.statx = fuse_lib_statx,
 #endif
 	.syncfs = fuse_lib_syncfs,
+	.iomap_begin = fuse_lib_iomap_begin,
+	.iomap_end = fuse_lib_iomap_end,
 };
 
 int fuse_notify_poll(struct fuse_pollhandle *ph)

