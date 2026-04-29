Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCA3261B92;
	Wed, 29 Apr 2026 14:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474749; cv=none; b=j0H0V0bLS9FYOT6Y9c1H/9J2pOdQlHZg0qLrNBi0fuYFlGHMkFVJbD7eM80aPMkp0EfdcPASSSIhw2E2LcWZ2pXu5FHQ1huXVpr+Gzd/61f+ypVTRMpnhhrG8I2NKbVmgvQcDzCCjmCaMpQEAArYMmyTLynGqPm3iYwaT7ldmA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474749; c=relaxed/simple;
	bh=0e+WKfynnsmHZf/HwaxlXjOzFJqq93oYsiEXz8JKHOg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HExP7172QxH3/ly9c+aRj7BtlUIWq6WZWaWp8Mx2StdESxVRfpYAp3Gs06WA8f67XjzwTnllczlzaHPHPjTYp9NLr5r68YDhyB7uX1SKHrG8fyT4eSJXgmlw3wy3hERbKWGdAmkXppb1Zp3bBIlcTIRfeOu+8wmn9OW2dmQZtpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=okfpoFRk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="okfpoFRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057C2C19425;
	Wed, 29 Apr 2026 14:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474749;
	bh=0e+WKfynnsmHZf/HwaxlXjOzFJqq93oYsiEXz8JKHOg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=okfpoFRk7nF5xM2/6Sduwx/z94e9wLErYxC8c8F38tbIPSMGldQHClGyecoAezbfl
	 AJkldSaoTVCPUKFi2rR79IiVXJGVS0H1TFXfdb8BjjPpFNhqG8qQ4lDJXDvTkjSdOg
	 aFka3g06PyHlFvcu5ozGM9iuPZHDrguuTK8SSqCjKZo5K/ypqx8cgPqKAn2d/Cj14H
	 mtIsfy3nvaQoIFdKxjK7UUjn3NNgTOafyZ+DNC3xtjX4Xq87atqY85JU2SVmw9qKQ9
	 p2t3o+N833W7NjW77gEuoX9Xjti5vz0vYA64HIpWU/blprvIBQaekH7ptz2zXOzcmn
	 7eUVneEdmMLrg==
Date: Wed, 29 Apr 2026 07:59:08 -0700
Subject: [PATCH 02/10] fuse2fs: skip permission checking on utimens when iomap
 is enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747215418.4110156.14001316870433107933.stgit@frogsfrogsfrogs>
In-Reply-To: <177747215344.4110156.17216553139316774040.stgit@frogsfrogsfrogs>
References: <177747215344.4110156.17216553139316774040.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When iomap is enabled, the kernel is in charge of enforcing permissions
checks on timestamp updates for files.  We needn't do that in userspace
anymore.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   11 +++++++----
 misc/fuse2fs.c    |   11 +++++++----
 2 files changed, 14 insertions(+), 8 deletions(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 6e5683dba4c918..7163c440c9ee66 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -5555,13 +5555,16 @@ static int fuse4fs_utimens(struct fuse4fs *ff, const struct fuse_ctx *ctxt,
 
 	/*
 	 * ext4 allows timestamp updates of append-only files but only if we're
-	 * setting to current time
+	 * setting to current time.  If iomap is enabled, the kernel does the
+	 * permission checking for timestamp updates; skip the access check.
 	 */
 	if (aact == TA_NOW && mact == TA_NOW)
 		access |= A_OK;
-	ret = fuse4fs_inum_access(ff, ctxt, ino, access);
-	if (ret)
-		return ret;
+	if (!fuse4fs_iomap_enabled(ff)) {
+		ret = fuse4fs_inum_access(ff, ctxt, ino, access);
+		if (ret)
+			return ret;
+	}
 
 	if (aact != TA_OMIT)
 		EXT4_INODE_SET_XTIME(i_atime, &atime, inode);
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 02ca7ade4aaad6..670411c1117e44 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -4939,13 +4939,16 @@ static int op_utimens(const char *path, const struct timespec ctv[2],
 
 	/*
 	 * ext4 allows timestamp updates of append-only files but only if we're
-	 * setting to current time
+	 * setting to current time.  If iomap is enabled, the kernel does the
+	 * permission checking for timestamp updates; skip the access check.
 	 */
 	if (ctv[0].tv_nsec == UTIME_NOW && ctv[1].tv_nsec == UTIME_NOW)
 		access |= A_OK;
-	ret = check_inum_access(ff, ino, access);
-	if (ret)
-		goto out;
+	if (!fuse2fs_iomap_enabled(ff)) {
+		ret = check_inum_access(ff, ino, access);
+		if (ret)
+			goto out;
+	}
 
 	err = fuse2fs_read_inode(fs, ino, &inode);
 	if (err) {

