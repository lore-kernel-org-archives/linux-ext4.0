Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0132027EFE9;
	Wed, 29 Apr 2026 14:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474718; cv=none; b=QaQFCgchqROaKpMMTxeiDIEmVvMSgCMeiZ//I0wgpv1CBvEybZ+JGGLXFHqCS3gQppHLcQ1UHqrcD59/W/k3JvALlpUak2wHO8FXRWZTPwYAfCwKWuFnUyWEnVM1Qw89JCE3ZO3IsigGAX7kX6WglYkdRzy7nBNnOuhR8erqzK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474718; c=relaxed/simple;
	bh=NLhvkKHU5NHtnqxNTg/61tBL9Mp/om6VgPhnPentcLE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vDoseldRY0bEut5ADtksMYiNdIc5HkZUOTNjcq258m67lo0fYr061zoiX34T2RDhpCUjzvfxWbUKS0kyqdGrR1y5xu+L+uCnUiCz/dhW/eYx4pO7dhGLkoGzOK0V0VkhBfa/qjMq30E9KJ1hh482VPY0BpPbS9PaSdTLd1IE0Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U5+UND7N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U5+UND7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5B0C19425;
	Wed, 29 Apr 2026 14:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474717;
	bh=NLhvkKHU5NHtnqxNTg/61tBL9Mp/om6VgPhnPentcLE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U5+UND7N22XXaCwX+pHrdhEhNTgu69/TR7IRT06HPrNtkPI7/QFDN1itY2Dm/hrnW
	 tmE7LryN+rconNDQPkAxPd91aAmGbWE2q9NzVpqJWrY7tdWBqO7hAw3t+z1CTo7smW
	 uxOEaIrIKXyztLUe1jziuaYy6Mq4bWwSIHaY08bD6qZU93yrjdXxt7duG2tfcsIC4/
	 GQDYxzJWlkU8/gfOH2JFUf7y9IZLPL9hRbE8m4V7xkYlDlHJHn/0E22TGxdAhNXqSF
	 oaBbga9590etIuQWnIlY3jakRcqBpOHAsjfZUxAQd5O0vXimm+Ecx3yRhBSE+DMEtk
	 wdU5enxYc7pDg==
Date: Wed, 29 Apr 2026 07:58:37 -0700
Subject: [PATCH 1/1] fuse4fs: don't use inode number translation when possible
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747215219.4110055.1405517682620840141.stgit@frogsfrogsfrogs>
In-Reply-To: <177747215201.4110055.6021378863218591603.stgit@frogsfrogsfrogs>
References: <177747215201.4110055.6021378863218591603.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Prior to the integration of iomap into fuse, the fuse client (aka the
kernel) required that the root directory have an inumber of
FUSE_ROOT_ID, which is 1.  However, the ext2 filesystem defines the root
inode number to be EXT2_ROOT_INO, which is 2.  This dissonance means
that we have to have translator functions, and that any access to
inumber 1 (the ext2 badblocks file) will instead redirect to the root
directory.

That's horrible.  Use the new mount option to set the root directory
nodeid to EXT2_ROOT_INO so that we don't need this translation.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 7c861fc28e9fa4..ec6af3813a661a 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -285,6 +285,7 @@ struct fuse4fs {
 	int directio;
 	int acl;
 	int dirsync;
+	int translate_inums;
 
 	enum fuse4fs_opstate opstate;
 	int logfd;
@@ -379,17 +380,19 @@ static int fuse4fs_service_discover_iomap(struct fuse4fs *ff)
 #define FUSE4FS_CHECK_CONTEXT_INIT(req) \
 	__FUSE4FS_CHECK_CONTEXT((req), abort(), abort())
 
-static inline void fuse4fs_ino_from_fuse(ext2_ino_t *inop, fuse_ino_t fino)
+static inline void fuse4fs_ino_from_fuse(const struct fuse4fs *ff,
+					 ext2_ino_t *inop, fuse_ino_t fino)
 {
-	if (fino == FUSE_ROOT_ID)
+	if (ff->translate_inums && fino == FUSE_ROOT_ID)
 		*inop = EXT2_ROOT_INO;
 	else
 		*inop = fino;
 }
 
-static inline void fuse4fs_ino_to_fuse(fuse_ino_t *finop, ext2_ino_t ino)
+static inline void fuse4fs_ino_to_fuse(const struct fuse4fs *ff,
+				       fuse_ino_t *finop, ext2_ino_t ino)
 {
-	if (ino == EXT2_ROOT_INO)
+	if (ff->translate_inums && ino == EXT2_ROOT_INO)
 		*finop = FUSE_ROOT_ID;
 	else
 		*finop = ino;
@@ -405,7 +408,7 @@ static inline void fuse4fs_ino_to_fuse(fuse_ino_t *finop, ext2_ino_t ino)
 			fuse_reply_err((req), EIO); \
 			return; \
 		} \
-		fuse4fs_ino_from_fuse(ext2_inop, fuse_ino); \
+		fuse4fs_ino_from_fuse(fuse4fs_get(req), ext2_inop, fuse_ino); \
 	} while (0)
 
 static int __translate_error(ext2_filsys fs, ext2_ino_t ino, errcode_t err,
@@ -2403,7 +2406,7 @@ static int fuse4fs_stat_inode(struct fuse4fs *ff, ext2_ino_t ino,
 			statbuf->st_rdev = inodep->i_block[1];
 	}
 
-	fuse4fs_ino_to_fuse(&entry->ino, ino);
+	fuse4fs_ino_to_fuse(ff, &entry->ino, ino);
 	entry->generation = inodep->i_generation;
 	entry->attr_timeout = FUSE4FS_ATTR_TIMEOUT;
 	entry->entry_timeout = FUSE4FS_ATTR_TIMEOUT;
@@ -8087,6 +8090,20 @@ static void fuse4fs_compute_libfuse_args(struct fuse4fs *ff,
  "-oallow_other,default_permissions,suid,dev");
 	}
 
+	if (fuse4fs_can_iomap(ff)) {
+		/*
+		 * The root_nodeid mount option was added when iomap support
+		 * was added to fuse.  This enables us to control the root
+		 * nodeid in the kernel, which enables a 1:1 translation of
+		 * ext2 to kernel inumbers.
+		 */
+		snprintf(extra_args, BUFSIZ, "-oroot_nodeid=%d",
+			 EXT2_ROOT_INO);
+		fuse_opt_add_arg(args, extra_args);
+		ff->translate_inums = 0;
+	}
+
+
 	if (ff->debug) {
 		int	i;
 
@@ -8366,6 +8383,7 @@ int main(int argc, char *argv[])
 #ifdef HAVE_FUSE_LOOPDEV
 		.loop_fd = -1,
 #endif
+		.translate_inums = 1,
 	};
 	errcode_t err;
 	FILE *orig_stderr = stderr;

