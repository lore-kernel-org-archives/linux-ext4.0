Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78C527EFE9;
	Wed, 29 Apr 2026 14:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474577; cv=none; b=XFNd0s395Bzu5IRz8ZAKnfU9dQAaR8oYUFnz92cgwud+cN/i2rhqAFbRXs3wDcyrLhawyQ4V1moY5FCXGyFHBcmKkQ9dKECc6SFk0K9LrnZYmnizoHWEiuzYZB77Zb4bzmbzfYGkaXmD6GC0vK8rkfaYcFyIk3Xz905W0NlDT0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474577; c=relaxed/simple;
	bh=Gp4tKHLmNcgnhXdR79ayHiGMEIzy1dTJzbSE3IvNSHc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HBYCM4is2V+GGy2llXbATLlIdPJaAWl7PAau/7ciTAuGVBh8yq7T8eF2nX+MuUklpyTRY3v1T5nTmxT8ZpUi0KIXafcq0wSJa4iuuTNaMmFOplx3UZxNn/+xA0iJXcNmcgWYGRINIPJVSUdeuZsF7hwsP/Qb3U9vBcZlHqBh4/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QasxMH05; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QasxMH05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD7EC19425;
	Wed, 29 Apr 2026 14:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474577;
	bh=Gp4tKHLmNcgnhXdR79ayHiGMEIzy1dTJzbSE3IvNSHc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QasxMH05kEEkSWxzrIDxObwckTSuQL4loFrXdkbVZ8mEbeWIlTa1HGTvPwKHJfJms
	 MuLVyL959IlBmrueptdFXuwmxShPayQL7UuQ8j0mZ1yVCWW3vcm5WIBdKcsT4whFAq
	 H0djGTFqBWHK0CIxjLMtaCN7yRosqXVZ/xhx0vHFIFSK+eIKbbWoXmN7mJMSqmK5vS
	 fhh5MJwH4sVvoBZPKwSDFiLYIgaWqDVwfGhD4ifFFEM85CAdAaYHb55cQtZq4g6Zpq
	 S7dZz5byrSl4WEO1FqI3v/xK8VB5M43gAzdUueDUXomY77iOTzTG3peeeGxSvyHwbk
	 mVr3UX6A+zrjA==
Date: Wed, 29 Apr 2026 07:56:16 -0700
Subject: [PATCH 14/19] fuse2fs: configure block device block size
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214787.4107473.16073984189804321726.stgit@frogsfrogsfrogs>
In-Reply-To: <177747214459.4107473.9520724883867588970.stgit@frogsfrogsfrogs>
References: <177747214459.4107473.9520724883867588970.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Set the blocksize of the block device to the filesystem blocksize.
This prevents the bdev pagecache from caching file data blocks that
iomap will read and write directly.  Cache duplication is dangerous.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 misc/fuse2fs.c    |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index f9c905c0805d9e..e92a85da0115ca 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -6891,6 +6891,45 @@ static off_t fuse4fs_max_size(struct fuse4fs *ff, off_t upper_limit)
 	return res;
 }
 
+/*
+ * Set the block device's blocksize to the fs blocksize.
+ *
+ * This is required to avoid creating uptodate bdev pagecache that aliases file
+ * data blocks because iomap reads and writes directly to file data blocks.
+ */
+static int fuse4fs_set_bdev_blocksize(struct fuse4fs *ff, int fd)
+{
+	int blocksize = ff->fs->blocksize;
+	int set_error;
+	int ret;
+
+	ret = ioctl(fd, BLKBSZSET, &blocksize);
+	if (!ret)
+		return 0;
+
+	/*
+	 * Save the original errno so we can report that if the block device
+	 * blocksize isn't set in an agreeable way.
+	 */
+	set_error = errno;
+
+	ret = ioctl(fd, BLKBSZGET, &blocksize);
+	if (ret)
+		goto out_bad;
+
+	/* Pretend that BLKBSZSET rejected our proposed block size */
+	if (blocksize > ff->fs->blocksize) {
+		set_error = EINVAL;
+		goto out_bad;
+	}
+
+	return 0;
+out_bad:
+	err_printf(ff, "%s: cannot set blocksize %u: %s\n", __func__,
+		   blocksize, strerror(set_error));
+	return -EIO;
+}
+
 static int fuse4fs_iomap_config_devices(struct fuse4fs *ff)
 {
 	errcode_t err;
@@ -6901,6 +6940,10 @@ static int fuse4fs_iomap_config_devices(struct fuse4fs *ff)
 	if (err)
 		return translate_error(ff->fs, 0, err);
 
+	ret = fuse4fs_set_bdev_blocksize(ff, fd);
+	if (ret)
+		return ret;
+
 	ret = fuse_lowlevel_iomap_device_add(ff->fuse, fd, 0);
 	if (ret < 0) {
 		dbg_printf(ff, "%s: cannot register iomap dev fd=%d, err=%d\n",
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index c6472a1c45506f..c922c7fb45d311 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -6211,6 +6211,45 @@ static off_t fuse2fs_max_size(struct fuse2fs *ff, off_t upper_limit)
 	return res;
 }
 
+/*
+ * Set the block device's blocksize to the fs blocksize.
+ *
+ * This is required to avoid creating uptodate bdev pagecache that aliases file
+ * data blocks because iomap reads and writes directly to file data blocks.
+ */
+static int fuse2fs_set_bdev_blocksize(struct fuse2fs *ff, int fd)
+{
+	int blocksize = ff->fs->blocksize;
+	int set_error;
+	int ret;
+
+	ret = ioctl(fd, BLKBSZSET, &blocksize);
+	if (!ret)
+		return 0;
+
+	/*
+	 * Save the original errno so we can report that if the block device
+	 * blocksize isn't set in an agreeable way.
+	 */
+	set_error = errno;
+
+	ret = ioctl(fd, BLKBSZGET, &blocksize);
+	if (ret)
+		goto out_bad;
+
+	/* Pretend that BLKBSZSET rejected our proposed block size */
+	if (blocksize > ff->fs->blocksize) {
+		set_error = EINVAL;
+		goto out_bad;
+	}
+
+	return 0;
+out_bad:
+	err_printf(ff, "%s: cannot set blocksize %u: %s\n", __func__,
+		   blocksize, strerror(set_error));
+	return -EIO;
+}
+
 static int fuse2fs_iomap_config_devices(struct fuse2fs *ff)
 {
 	errcode_t err;
@@ -6221,6 +6260,10 @@ static int fuse2fs_iomap_config_devices(struct fuse2fs *ff)
 	if (err)
 		return translate_error(ff->fs, 0, err);
 
+	ret = fuse2fs_set_bdev_blocksize(ff, fd);
+	if (ret)
+		return ret;
+
 	ret = fuse_fs_iomap_device_add(fd, 0);
 	if (ret < 0) {
 		dbg_printf(ff, "%s: cannot register iomap dev fd=%d, err=%d\n",

