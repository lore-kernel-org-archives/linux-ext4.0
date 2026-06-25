Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369DE3126CA
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416439; cv=none; b=E2N5JmUyePasT5F0DNq7r9cRVUQRNaZ4p4q8/PGlnrC8Lx/BHNTfhErw4m2646GDtAy+8bqUqLZvFQd0ZuTIdXKvxssU5mzg4ya/xi8iqMrLu4qaf3e76vd/83F/+3sBS/epCNOGvKvJASiR44i4lZc8f365591TJwB55CIv7ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416439; c=relaxed/simple;
	bh=LVCUNIQEHm5aui2Ee9Tfu6OYWxmp5ZDFvqMJDcHeXtI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qJ9EKkFAUnXViwn7pQBQqTH3fJZ9V5tQyoDM33wjtjVJEBCxFta0aipujNM7X9KrXvY8laWsNEXJDPYw2ahYPBa8uAKVBNrHGXhSUNlRJBMfvTsWQWR5g5LA7SR7XdRNcwOv+O+MXao40FEgS/t4HTIDP12iSboC3Y+YxTJw9d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VwdIMlwT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VwdIMlwT"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1028C1F000E9;
	Thu, 25 Jun 2026 19:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416438;
	bh=7EN/3z8oprJJKXURMCRJtuJqIpGT8H7ixBVJCuVA+kQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=VwdIMlwTLN+BMNkFn3Lrb6ivkW/mjFrMB2xb2tRQMEPtImz3r18KgVnG7NUctY5rG
	 Y0N967RLMuCtMhDm9ntWWTdVEAJkdciW+3M2/OXiQBx2wMYMSkxxSLn4mvQaobv/2R
	 PcrREGIBhuJUIt/i48SK5fSlxrKIeVs5rQsXA9WL7AvzSNJA+CbGPCCSc9gN/rLelP
	 8QXs40zDAnNTJ4Xkg1bMJhOZjP3enrRWXuFRS1MzeVtfwPo96dbxDQnp2phmuRpNl7
	 SJQf5bjRdmupbowQq6L7/3VUV7CFZxXnDBhqobY8y3jb+YZLolLvK5fCTRyCHFgliM
	 INW2OlqdbH26g==
Date: Thu, 25 Jun 2026 12:40:37 -0700
Subject: [PATCH 5/6] fuse2fs: increase inode cache size
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <178241607238.1810839.17492906811869681140.stgit@frogsfrogsfrogs>
In-Reply-To: <178241607127.1810839.16661954075518963408.stgit@frogsfrogsfrogs>
References: <178241607127.1810839.16661954075518963408.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Increase the internal inode cache size.  Does this improve performance
any?

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |    4 ++++
 misc/fuse2fs.c    |    4 ++++
 2 files changed, 8 insertions(+)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 43e7278ffec1a9..9744c0941cf31b 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -1689,6 +1689,10 @@ static errcode_t fuse4fs_open(struct fuse4fs *ff)
 	if (err)
 		return translate_error(ff->fs, 0, err);
 
+	err = ext2fs_create_inode_cache(ff->fs, 1024);
+	if (err)
+		return translate_error(ff->fs, 0, err);
+
 	ff->fs->priv_data = ff;
 	ff->blocklog = u_log2(ff->fs->blocksize);
 	ff->blockmask = ff->fs->blocksize - 1;
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 32f4f1e2a48056..caa675bc9f95e9 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -1277,6 +1277,10 @@ static errcode_t fuse2fs_open(struct fuse2fs *ff)
 		log_printf(ff, "%s %s.\n", _("mounted filesystem"), uuid);
 	}
 
+	err = ext2fs_create_inode_cache(ff->fs, 1024);
+	if (err)
+		return translate_error(ff->fs, 0, err);
+
 	ff->fs->priv_data = ff;
 	ff->blocklog = u_log2(ff->fs->blocksize);
 	ff->blockmask = ff->fs->blocksize - 1;

