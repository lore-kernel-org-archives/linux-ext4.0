Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725F934CFBA;
	Mon, 23 Feb 2026 23:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771890437; cv=none; b=TIiqQSVFsb5FSJzGSQhCO13xLqc89y43HFzdn+KOCr7ombBX/g4oTIDwX1HJnRnhAIDMC6jH+dK8xNWDDhb/WC11ngOdq73hYOcxX2+mVMbjY1wO72zGzZkLuKDfbT5/mUndFpyzq/zOuloLufZxbayVv2qN9fWvSxU4oPca6VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771890437; c=relaxed/simple;
	bh=YUUqqqHB3o5BfarB0zxyYpnmpDVuIDt8VFkqIJsghG4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GscdQqhB6gp0WVXU49Fhs6+fWKuxEFfKrbWZe9uzuJ3K1X891Ip++aNsQ/JG5ozgbjzl9s1IKUy98HkjNq9msxd4Rn/uYHzJvRjtMkZERXBLUb5Jl6pfq2gfNvhf7Ex1AxI3j4F/xI0fv1u9L8mFia6H+wRNQ+V8czsw1IDi1S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nlgee/Zd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nlgee/Zd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C298C116C6;
	Mon, 23 Feb 2026 23:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771890437;
	bh=YUUqqqHB3o5BfarB0zxyYpnmpDVuIDt8VFkqIJsghG4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nlgee/ZdfZhVqbyjvHcgGaGSLeH4ct1zXEQ4xyg7VoOOKbgqoQNiv4J299xh1YQE/
	 SLG9JHMxCZQg0tGCLO/RLwluwgHycjcEC0A0RdeQC8/so1kxu41wF5z+fbRw063LOy
	 CQCsydeZS8XYHOXQ7nsu6RdaVSBXKf9Q/z5bZYx8uVpgZwfVI+LoCKlMujw1mcfzZ/
	 bRQQA23Pn2T4ilgyiu9toH097yx331Vx/nAEqwgQuM2twahXRXSJbk2dH9beSE1NEn
	 vEYcM3mpR0dEUcQslPynG+E7tNXvGGBCC4ZhUKnw0zkxbocMTVCMbQEHIsEaYN/bkz
	 NuxxMv7wsEd/Q==
Date: Mon, 23 Feb 2026 15:47:16 -0800
Subject: [PATCH 4/8] fuse4fs: upsert first file mapping to kernel on open
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bpf@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, miklos@szeredi.hu, bernd@bsbernd.com,
 joannelkoong@gmail.com, neal@gompa.dev
Message-ID: <177188746027.3944907.5357211470201884352.stgit@frogsfrogsfrogs>
In-Reply-To: <177188745924.3944907.12406087337118974135.stgit@frogsfrogsfrogs>
References: <177188745924.3944907.12406087337118974135.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Try to speed up the first access to a file by upserting the first
file space mapping to the kernel at open time.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 522afde7c9356b..ad701649886380 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -4364,6 +4364,37 @@ static int fuse4fs_iomap_begin_read(struct fuse4fs *ff, ext2_ino_t ino,
 				    uint64_t count, uint32_t opflags,
 				    struct fuse_file_iomap *read);
 
+static void fuse4fs_try_upsert_first_mapping(struct fuse4fs *ff, ext2_ino_t ino,
+					     struct fuse_file_info *fp)
+{
+	struct ext2_inode_large inode;
+	struct fuse_file_iomap read = { };
+	uint64_t fsize;
+	errcode_t err;
+
+	if (!ff->iomap_cache || (fp->flags & O_TRUNC))
+		return;
+
+	err = fuse4fs_read_inode(ff->fs, ino, &inode);
+	if (err)
+		return;
+
+	if (!S_ISREG(inode.i_mode))
+		return;
+
+	fsize = EXT2_I_SIZE(&inode);
+	if (!fsize)
+		return;
+
+	/* try to map the first 64k */
+	err = fuse4fs_iomap_begin_read(ff, ino, &inode, 0, min(fsize, 65536),
+			0, &read);
+	if (err)
+		return;
+
+	fuse_lowlevel_iomap_upsert_mappings(ff->fuse, ino, ino, &read, NULL);
+}
+
 static int fuse4fs_open_file(struct fuse4fs *ff, const struct fuse_ctx *ctxt,
 			     ext2_ino_t ino, bool linked,
 			     struct fuse_file_info *fp)
@@ -4458,7 +4489,7 @@ static int fuse4fs_open_file(struct fuse4fs *ff, const struct fuse_ctx *ctxt,
 	/* fuse 3.5: cache dirents from readdir contents */
 	fp->cache_readdir = 1;
 #endif
-
+	fuse4fs_try_upsert_first_mapping(ff, ino, fp);
 out:
 	if (ret)
 		ext2fs_free_mem(&file);

