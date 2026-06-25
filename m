Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793C823ED60
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416237; cv=none; b=hYbovwpZa9eDocYASz9zS6u2ZCrMhf9AX5wijfdIcnhmJ0BiVqzjw/dn/mMGo+nL1355JyUGbeEZUitXB5VJYE9lySVN5bMPvlEIWl/bMd/ZVOKWKgJE3fLAWShObgbp/c1ivOZw3tqhpC3MiFaoo0ER9t4BmD/DYzTNzpQHlF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416237; c=relaxed/simple;
	bh=JYxdgXAAk37h6iFb0YjdjLOKoYVuZupQIUbjtX6RT2Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V/a+OqWggE5u/oMTy7SV4JVayoLecoRWsDZmrfZ8IGJi0pSHDWvmfQ0GOfg7e1jXnEFoSPiBYvOEYW5j+MPF/yJBxm8gPrcZYe2MwdcYnNv0kATjDscHon6nE0SG4TvqX661ViDHtA7ojyHZOPYYD3093E3zBgYcQ5sCKgZPDzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hn69eOxP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hn69eOxP"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 17D881F000E9;
	Thu, 25 Jun 2026 19:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416236;
	bh=ei8fXwKS/FfEuvT/CBqTAr8M+l20HGFBWwVHAdGxDrk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=hn69eOxPbsvTQnuswvn5T5ulgRbSlI/6fZ4ZKAoyp5hQtNORZoGOQcbyK1yT1Y3pJ
	 7GdpwdKh9yw9s0HdUy+mHL1AQKtM0i+lfEmy2rKXV498WWBy/HQbQTAcimugRUGxFM
	 6kcQuwU57uwY/mxOtoV8WsOX4KakyNHn4frW7/iinOGMpxilSYuYWZUIXesXUVOhYE
	 cgUKO39RqynDIhxN+fOlPg6nxUIRPtT0tohDSbYzRpmMRZxBs6hidgEg1hASVJNJZR
	 BdzFKZvkBH3bErOKHwpEanmTDkQR4is7fRZ8wvC4hhgOMSyszgYb8sJY99oPH08nVV
	 3+yMYY99TdZgQ==
Date: Thu, 25 Jun 2026 12:37:15 -0700
Subject: [PATCH 02/10] libext2fs: fix checking for valid fds in mmp.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org, linux-ext4@vger.kernel.org
Message-ID: <178241606848.1810414.3569894736078984351.stgit@frogsfrogsfrogs>
In-Reply-To: <178241606773.1810414.1910863348345107939.stgit@frogsfrogsfrogs>
References: <178241606773.1810414.1910863348345107939.stgit@frogsfrogsfrogs>
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

