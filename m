Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5AA34F48E;
	Wed, 22 Apr 2026 23:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776900244; cv=none; b=ZoYwH1mRD33gK4yb/bzKry3T+g/tzQdIvt8hb9deXaP6BVwN/tl9UxX8cV6yosOi4KulJh7Nt4BqXC5wXxCE8feHKGJw0HgXgsx61NE3dM2WC0s29JCcFnbTNk6pemLX09wH+SMwKsw7KHtL64y33IMapUVjtQmht+jvnOMkL+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776900244; c=relaxed/simple;
	bh=JYxdgXAAk37h6iFb0YjdjLOKoYVuZupQIUbjtX6RT2Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M+rcRVFhjmCIJgv+Ew0o32Ecym/EKo/gNfHLf/CqsYi53YReeJMRDFnqceaAtM85e4zozjasXqrXWi8UGyuqWqGjZWBLIZ5+TGzjq448kYDRQGabb18+EAOKNVUXgs5YvuHNoY45qASqrTT1jJhdqc7+lQk0gzxcyyo3bVgzqPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bfLr7CLG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bfLr7CLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372E0C2BCAF;
	Wed, 22 Apr 2026 23:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776900244;
	bh=JYxdgXAAk37h6iFb0YjdjLOKoYVuZupQIUbjtX6RT2Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bfLr7CLGEfIcHikXZAzsKG6z4WWvgC8JDrnnc7Ti13SXy4rAWAT8PLcqKnkkRbS9f
	 AGPARgnRGB7XF02H7ApdkSnnW2fT+L8Qf3rWnyede7ieUBeN+CDj85HcP8Ge6IQrvv
	 YpBwnOLY2o0csWID5QI8Oa5t8W7wdXp4qS4VD50BzpLc4wPOG/yTGjqcnYwwJn8+ae
	 5wUOxkNiOz+0RXBK98NUrid9bXSBdTN0v6jPOXmPrwYEAk10Qhm38MR8pW0adk0RC5
	 /30c4CTICCb5QGhIITbhr08AsNSAJYqSnxv5NDb2jt5OSFsQ9cOSat/BwpriUeL+3W
	 6IXWKlL5vBj1A==
Date: Wed, 22 Apr 2026 16:24:02 -0700
Subject: [PATCH 02/10] libext2fs: fix checking for valid fds in mmp.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 fuse-devel@lists.linux.dev, linux-ext4@vger.kernel.org, neal@gompa.dev,
 joannelkoong@gmail.com, miklos@szeredi.hu, bernd@bsbernd.com
Message-ID: <177689989576.3821326.18441817831051181225.stgit@frogsfrogsfrogs>
In-Reply-To: <177689989498.3821326.15497525132012299039.stgit@frogsfrogsfrogs>
References: <177689989498.3821326.15497525132012299039.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

File descriptors are non-negative numbers, which means that 0 is a valid
fd.  Fix the code to be consistent with Unix behaviors.

Cc: <linux-ext4@vger.kernel.org> # v1.42
Fixes: 0f5eba7501f467 ("ext2fs: add multi-mount protection (INCOMPAT_MMP)")
Fixes: 76a6c8788c79e4 ("mmp: do not use O_DIRECT when working with regular file")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 lib/ext2fs/mmp.c    |    6 +++---
 lib/ext2fs/openfs.c |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)


diff --git a/lib/ext2fs/mmp.c b/lib/ext2fs/mmp.c
index e2823732e2b6a2..cb15a18fce5547 100644
--- a/lib/ext2fs/mmp.c
+++ b/lib/ext2fs/mmp.c
@@ -59,11 +59,11 @@ errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 		return EXT2_ET_MMP_BAD_BLOCK;
 
 	/* ext2fs_open() reserves fd0,1,2 to avoid stdio collision, so checking
-	 * mmp_fd <= 0 is OK to validate that the fd is valid.  This opens its
+	 * mmp_fd < 0 is OK to validate that the fd is valid.  This opens its
 	 * own fd to read the MMP block to ensure that it is using O_DIRECT,
 	 * regardless of how the io_manager is doing reads, to avoid caching of
 	 * the MMP block by the io_manager or the VM.  It needs to be fresh. */
-	if (fs->mmp_fd <= 0) {
+	if (fs->mmp_fd < 0) {
 		struct stat st;
 		int flags = O_RDONLY | O_DIRECT;
 
@@ -427,7 +427,7 @@ errcode_t ext2fs_mmp_stop(ext2_filsys fs)
 	retval = ext2fs_mmp_write(fs, fs->super->s_mmp_block, fs->mmp_cmp);
 
 mmp_error:
-	if (fs->mmp_fd > 0) {
+	if (fs->mmp_fd >= 0) {
 		close(fs->mmp_fd);
 		fs->mmp_fd = -1;
 	}
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 2b8e0e753c46e8..41359d15740881 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -148,6 +148,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 	/* don't overwrite sb backups unless flag is explicitly cleared */
 	fs->flags |= EXT2_FLAG_MASTER_SB_ONLY;
 	fs->umask = 022;
+	fs->mmp_fd = -1;
 
 	time_env = ext2fs_safe_getenv("SOURCE_DATE_EPOCH");
 	if (time_env) {

