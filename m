Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9851937F8C6;
	Mon, 23 Feb 2026 23:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771889700; cv=none; b=QZpF4WKacnT342KMvOpWgjj905c6kxeDKWgzYcPXvHx4zMZaoigN+rdG3QktCBlpy/tr1I3OiMuJdwocPy1xPLS3EL8ln/0l+1r9XpgHdAUNmwTB0j2/gclhv9wLARhHhNEu6ZLcWIlsRrj8lD5532LDbxM3KfwnYnExXazMtvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771889700; c=relaxed/simple;
	bh=NMUBsuxzD00vjfzQY2j5mBOaGuT092JLXC/TnXErE8A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=txR86Kf9S3qENXP567cQmN1pb1q1uzydyOP2VTR5zAzcoALlFJ4rO42KfzNMzPeIfE4KHLSrRmJ13aYsLHt8GX15P9gWwU4H7izHsd1MPuHDDIW92osvLTSDuDR5/253zGzkJ5A+xWOx/UBYmhOUzcLVW+ATSd9/GLGdi689S7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kK4j74UV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kK4j74UV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75526C19421;
	Mon, 23 Feb 2026 23:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771889700;
	bh=NMUBsuxzD00vjfzQY2j5mBOaGuT092JLXC/TnXErE8A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kK4j74UV6YgDqqIOABYGhQp9/AF80yaUKKdMeFTxKBRIEGSkRnVygFtqcWC6Nt5VQ
	 lTxilqSacCsfqvFZshEUUIOD/61JHw4foUr5qpTiN2E9vSwsf1MLZGnbCx/MpT47mp
	 P+5D8wJ20jBJQUe84fMoRn0l/U3qGf3z9hN0RPJjXgyoGD9ZHgQqZs89q22UqzDuYC
	 K9wCFxxL8H8oD0EtFZ7G+eOKSZxtuKK5qCj+QFqlIVoxWBMuQy8xc8StKbZMXtn2E/
	 M/OwFgj1LBuvcPEWuPZ6mFSSrXSK5EsUk5nIDggYbS5DsOxqeRAd572O9QcxE9kCYy
	 Yr6XjW5t0fd+A==
Date: Mon, 23 Feb 2026 15:34:59 -0800
Subject: [PATCH 4/5] libfuse: enable setting iomap block device block size
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, bschubert@ddn.com
Cc: bernd@bsbernd.com, miklos@szeredi.hu, neal@gompa.dev,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 bpf@vger.kernel.org, joannelkoong@gmail.com
Message-ID: <177188741387.3942122.18133435502561484609.stgit@frogsfrogsfrogs>
In-Reply-To: <177188741298.3942122.15899633653835028664.stgit@frogsfrogsfrogs>
References: <177188741298.3942122.15899633653835028664.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a means for an unprivileged fuse server to set the block size of
a block device that it previously opened and associated with the fuse
connection.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 include/fuse_kernel.h   |    7 +++++++
 include/fuse_lowlevel.h |   12 ++++++++++++
 lib/fuse_lowlevel.c     |   11 +++++++++++
 lib/fuse_versionscript  |    1 +
 4 files changed, 31 insertions(+)


diff --git a/include/fuse_kernel.h b/include/fuse_kernel.h
index 417f1d42b0618d..d9b65fe2395bde 100644
--- a/include/fuse_kernel.h
+++ b/include/fuse_kernel.h
@@ -1184,6 +1184,11 @@ struct fuse_iomap_support {
 	uint64_t	padding;
 };
 
+struct fuse_iomap_backing_info {
+	uint32_t	backing_id;
+	uint32_t	blocksize;
+};
+
 /* Device ioctls: */
 #define FUSE_DEV_IOC_MAGIC		229
 #define FUSE_DEV_IOC_CLONE		_IOR(FUSE_DEV_IOC_MAGIC, 0, uint32_t)
@@ -1194,6 +1199,8 @@ struct fuse_iomap_support {
 					     struct fuse_iomap_support)
 #define FUSE_DEV_IOC_SET_NOFS		_IOW(FUSE_DEV_IOC_MAGIC, 100, uint32_t)
 #define FUSE_DEV_IOC_ADD_IOMAP		_IO(FUSE_DEV_IOC_MAGIC, 101)
+#define FUSE_DEV_IOC_IOMAP_SET_BLOCKSIZE _IOW(FUSE_DEV_IOC_MAGIC, 102, \
+					      struct fuse_iomap_backing_info)
 
 struct fuse_lseek_in {
 	uint64_t	fh;
diff --git a/include/fuse_lowlevel.h b/include/fuse_lowlevel.h
index eefc69360b8aa8..f0dba1918f09b6 100644
--- a/include/fuse_lowlevel.h
+++ b/include/fuse_lowlevel.h
@@ -2809,6 +2809,18 @@ int fuse_lowlevel_disable_fsreclaim(struct fuse_session *se, int val);
  */
 int fuse_lowlevel_add_iomap(int fd);
 
+/**
+ * Set the block size of an open block device that has been opened for use with
+ * iomap.
+ *
+ * @param fd open file descriptor to a fuse device
+ * @param dev_index device index returned by fuse_lowlevel_iomap_device_add
+ * @param blocksize block size in bytes
+ * @return 0 on success, -1 on failure with errno set
+ */
+int fuse_lowlevel_iomap_set_blocksize(int fd, int dev_index,
+				      unsigned int blocksize);
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/lib/fuse_lowlevel.c b/lib/fuse_lowlevel.c
index 4f27603400f2da..1549b1d339e24b 100644
--- a/lib/fuse_lowlevel.c
+++ b/lib/fuse_lowlevel.c
@@ -5354,3 +5354,14 @@ int fuse_lowlevel_add_iomap(int fd)
 {
 	return ioctl(fd, FUSE_DEV_IOC_ADD_IOMAP);
 }
+
+int fuse_lowlevel_iomap_set_blocksize(int fd, int dev_index,
+				      unsigned int blocksize)
+{
+	struct fuse_iomap_backing_info fbi = {
+		.backing_id = dev_index,
+		.blocksize = blocksize,
+	};
+
+	return ioctl(fd, FUSE_DEV_IOC_IOMAP_SET_BLOCKSIZE, &fbi);
+}
diff --git a/lib/fuse_versionscript b/lib/fuse_versionscript
index 334a0f7cf3a096..5f1a50701a9ba9 100644
--- a/lib/fuse_versionscript
+++ b/lib/fuse_versionscript
@@ -268,6 +268,7 @@ FUSE_3.99 {
 		fuse_service_request_file;
 		fuse_service_send_goodbye;
 		fuse_service_take_fusedev;
+		fuse_lowlevel_iomap_set_blocksize;
 } FUSE_3.19;
 
 # Local Variables:

