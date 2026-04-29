Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F2734D4E2;
	Wed, 29 Apr 2026 14:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474687; cv=none; b=MsFr45rv57zO7cH6jE2/HyDF1TzyeTmaUtVegM2cusB2IKK9UK44q68nxGvcHpMKqcHuLRX+zk7Loub4pfAANZrI9/LJufAb/8QpxTpVVJreTW5K0QEDYepNTXc+xDvo2vQrIovFSHYl4ehsI4bwH5O4j5YMyF78lh/CXUxeHis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474687; c=relaxed/simple;
	bh=F8BRLl0qdY598FN7zilACacz0SD2KJpjudkm9dTB+0M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fs6ygS+VQP2m1QBwPn9I5z+8av00UtTdKXvvYppaxxzLzl4uS3J4Z56PkqGivlQCdRo4yGc5nUa+plY7mkkjnUgJUDQ7As00XfWpvYngYlOv1osCW/BTK1uIMy/bdxWUWJ2IlueAUGonBCNCk06dX5dAGUh+TFj8XSbHxDNfdx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GF9Oy7D6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GF9Oy7D6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EE9C19425;
	Wed, 29 Apr 2026 14:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474686;
	bh=F8BRLl0qdY598FN7zilACacz0SD2KJpjudkm9dTB+0M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GF9Oy7D63hIfZfFBjhJNYlpK/Q93uK9JJTFnC/GBu6E2CS+V4RbzmJ9jvGnB7m34J
	 OlUkAksTkhWuiJj7n4PLZRUtVtGHw5gFcmqqu7JAo5vrJKSZ9iVCsun8eag3Bq1Uyg
	 Hzoa7P26WWXtKSMhL1G88IuFA3UW/jx/zoyv6+ekUus2ZCSRy35OLR/Q0BugABBhsT
	 8iV9k7IVpOipu1pkMxYOHq2SX98VYaojf9DRyByLch7BirQJoWab9sid3KPpMAAis0
	 nOVQRwBPthyXSQ73a9MkCrrvUDw5PXUtgh/XdR7C1uf/IwIFYGxnYM1R5wUymqwxnO
	 GrSn+1Vb9UmuA==
Date: Wed, 29 Apr 2026 07:58:06 -0700
Subject: [PATCH 2/3] fuse4fs: set iomap backing device blocksize
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747215062.4109882.16836775067142129229.stgit@frogsfrogsfrogs>
In-Reply-To: <177747215017.4109882.630706253054166885.stgit@frogsfrogsfrogs>
References: <177747215017.4109882.630706253054166885.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If we're running as an unprivileged iomap fuse server, we must ask the
kernel to set the blocksize of the block device.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   42 ++++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index d7de2e94a7e536..e4338722e88e73 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -1610,10 +1610,27 @@ static int fuse4fs_service_configure_iomap(struct fuse4fs *ff)
 
 	return 0;
 }
+
+int fuse4fs_service_set_bdev_blocksize(struct fuse4fs *ff, int dev_index)
+{
+	int ret;
+
+	ret = fuse_lowlevel_iomap_set_blocksize(ff->fuse, dev_index,
+						ff->fs->blocksize);
+	if (ret) {
+		err_printf(ff, "%s: cannot set blocksize %u: %s\n", __func__,
+			   ff->fs->blocksize, strerror(-ret));
+		return -EIO;
+	}
+
+	return 0;
+}
 #else
 # define fuse4fs_service_configure_iomap(...)	(EOPNOTSUPP)
+# define fuse4fs_service_set_bdev_blocksize(...) (EOPNOTSUPP)
 #endif
 
+
 static errcode_t fuse4fs_acquire_lockfile(struct fuse4fs *ff)
 {
 	char *resolved;
@@ -7254,21 +7271,19 @@ static int fuse4fs_iomap_config_devices(struct fuse4fs *ff)
 {
 	errcode_t err;
 	int fd;
+	int dev_index;
 	int ret;
 
 	err = io_channel_get_fd(ff->fs->io, &fd);
 	if (err)
 		return translate_error(ff->fs, 0, err);
 
-	ret = fuse4fs_set_bdev_blocksize(ff, fd);
-	if (ret)
-		return ret;
-
-	ret = fuse_lowlevel_iomap_device_add(ff->fuse, fd, 0);
-	if (ret < 0) {
-		dbg_printf(ff, "%s: cannot register iomap dev fd=%d, err=%d\n",
-			   __func__, fd, -ret);
-		return translate_error(ff->fs, 0, -ret);
+	dev_index = fuse_lowlevel_iomap_device_add(ff->fuse, fd, 0);
+	if (dev_index < 0) {
+		ret = -dev_index;
+		dbg_printf(ff, "%s: cannot register iomap dev fd=%d: %s\n",
+			   __func__, fd, strerror(ret));
+		return translate_error(ff->fs, 0, ret);
 	}
 
 	dbg_printf(ff, "%s: registered iomap dev fd=%d iomap_dev=%u\n",
@@ -7276,7 +7291,14 @@ static int fuse4fs_iomap_config_devices(struct fuse4fs *ff)
 
 	fuse4fs_configure_atomic_write(ff, fd);
 
-	ff->iomap_dev = ret;
+	if (fuse4fs_is_service(ff))
+		ret = fuse4fs_service_set_bdev_blocksize(ff, dev_index);
+	else
+		ret = fuse4fs_set_bdev_blocksize(ff, fd);
+	if (ret)
+		return ret;
+
+	ff->iomap_dev = dev_index;
 	return 0;
 }
 

