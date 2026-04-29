Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6AA355F36;
	Wed, 29 Apr 2026 15:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474874; cv=none; b=sPnz/8VMrZNO//Wao3twQoLKGI+QkMlT/IuGOmzKtOurVyNhaoqIE6YKKX5+zz0Zy3s3HCTbAijpSxvqOlZtdVFOs0Q2pVGBi1EeN5USOOc3NjGn1VfdxtP30E6EZBrKooFT4pbpOx6nC01PQPnmgHZhtN6uemnPzWaF8xVfLKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474874; c=relaxed/simple;
	bh=Cvt3s9nv0WmmjasPQjtoyo7FZdZ46hpRXMa3yGH9jCg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gXZbqj/0sduKLHeigNOdL/BV4Y453zFn5i9cUCYc7x5GR2mVGJlTPzAeL5kLXI0sNFtLDB5f3ZOoreA7h8AT58dqqRVLf4Frr6M6m0e7NsWMuvqKEwkjTACrwPI9C4Rr1B4ycDT8Y5JoReH1y710xGyhed7K5sMatPXtPX+LxNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ciHKo6Vw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ciHKo6Vw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD86DC19425;
	Wed, 29 Apr 2026 15:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474873;
	bh=Cvt3s9nv0WmmjasPQjtoyo7FZdZ46hpRXMa3yGH9jCg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ciHKo6VwGHfaHCl79cyzD4OCPN2h0WpgeLAPXB3U3gpT+N2NEkkOno4nLs0txjvU+
	 jDUOlzTV7LXARqmuT7jCdOydD8k46gf1crUO709vlIFcFSYI+7x/wrq0beWA1bSJcr
	 iM3IhtsgArqrbzKICp8W716RkmksqfGrLkYon+ZvUQE/lXbwvapBsz+llo7mMPaQls
	 UVrgm+XXcWkSyt59qg1BW+OoJsrcslECX2rm3aYj1yoTIJ3JtfFMXw6oy/GUJ6kglh
	 LERtGmHx6oEYcMHEHYhiqu4bcnAeklgMJS6F73aIptSslJV2tbfWie/E4PudvAFFRL
	 jVXHdDDwHpVBg==
Date: Wed, 29 Apr 2026 08:01:13 -0700
Subject: [PATCH 10/10] fuse4fs: increase attribute timeout in iomap mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747215562.4110156.8990534145359592512.stgit@frogsfrogsfrogs>
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

In iomap mode, we trust the kernel to cache file attributes, because it
is critical to keep all of the file IO permissions checking in the
kernel as part of keeping all the file IO paths in the kernel.
Therefore, increase the attribute timeout to 30 seconds to reduce the
number of upcalls even further.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index b4105333f4fe22..9f7fe365ccdf87 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -131,7 +131,8 @@
 #endif
 #endif /* !defined(ENODATA) */
 
-#define FUSE4FS_ATTR_TIMEOUT	(0.0)
+#define FUSE4FS_IOMAP_ATTR_TIMEOUT	(0.0)
+#define FUSE4FS_ATTR_TIMEOUT		(30.0)
 
 #ifndef O_DIRECT
 # define O_DIRECT	(0)
@@ -2437,8 +2438,14 @@ static int fuse4fs_stat_inode(struct fuse4fs *ff, ext2_ino_t ino,
 
 	fuse4fs_ino_to_fuse(ff, &entry->ino, ino);
 	entry->generation = inodep->i_generation;
-	entry->attr_timeout = FUSE4FS_ATTR_TIMEOUT;
-	entry->entry_timeout = FUSE4FS_ATTR_TIMEOUT;
+
+	if (fuse4fs_iomap_enabled(ff)) {
+		entry->attr_timeout = FUSE4FS_IOMAP_ATTR_TIMEOUT;
+		entry->entry_timeout = FUSE4FS_IOMAP_ATTR_TIMEOUT;
+	} else {
+		entry->attr_timeout = FUSE4FS_ATTR_TIMEOUT;
+		entry->entry_timeout = FUSE4FS_ATTR_TIMEOUT;
+	}
 
 	fstat->iflags = 0;
 
@@ -2671,6 +2678,8 @@ static void op_statx(fuse_req_t req, fuse_ino_t fino, int flags, int mask,
 	fuse4fs_finish(ff, ret);
 	if (ret)
 		fuse_reply_err(req, -ret);
+	else if (fuse4fs_iomap_enabled(ff))
+		fuse_reply_statx(req, 0, &stx, FUSE4FS_IOMAP_ATTR_TIMEOUT);
 	else
 		fuse_reply_statx(req, 0, &stx, FUSE4FS_ATTR_TIMEOUT);
 }

