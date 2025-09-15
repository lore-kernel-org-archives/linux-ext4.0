Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8022D7DDE
	for <linux-ext4@vger.kernel.org>; Mon, 15 Sep 2025 22:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757976192; cv=none; b=NctcIQLgwMoirHxg46XDkEjYtq7K555RUV4NImoJoDnwcRgEmw1ruGpwu+Cp0Mtw6g7iYSPIceDjEYnfj0luClmbwa6VGlTFd2QOGdGQR6oh34VLkcPzjhHUcbB4Gx9gRH1R+5tmnrH37ZA1tGR0e+2LA3JcUr2TxVtCvS+LFgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757976192; c=relaxed/simple;
	bh=o8NhxSeY5vfLtcJotDQbfcrRXGHErCYvqLuIwnksPow=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A4cHlMl9s8cvZGmlJXSjmJ84cOdnwpm410/bmqz3hIQPnHCfPHe7iwXs6Ua0WAeR/+bXBjGEO3ld81TbednAHFEDvjKc+KFycnI8E9/WhIhx4eoCYA1fbDfJUNMo22XwyoISElC/jpm+jeac4iPZXHc78xiBVWgXb0IqNexobkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HqQQbevb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HqQQbevb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B4CC4CEF1;
	Mon, 15 Sep 2025 22:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757976191;
	bh=o8NhxSeY5vfLtcJotDQbfcrRXGHErCYvqLuIwnksPow=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HqQQbevbmNKKm6X1XeOfXu70qoQf/upJrD8AyA9Mi57kydZWBs8K8ay2pvlo5Smw2
	 s0GlPgoceXNAfnHTv7XpI81burexOlZOnUNlaXu9G9J0Jol4knltnOGB0/KN14BOdW
	 4RaiVHex0QXZfNNjOSqZlVGpw2v0xiHTFjbCJmuFoz6oY3JMo15REnLOHIGgvD2RLe
	 S2lEiOSSqw1Ad6dt2SRpuEUnRdqjyvTihmFC+3/0zSbMKkDKVljSxqXSQa+nPW/ehi
	 0ce4lJ+I92Rmf5ZrwcPs55kEYvALEUL13QEMbbutwS/MVm7Bje5Ss12Agr6dsHpiLE
	 rkO7NUMdo2aNw==
Date: Mon, 15 Sep 2025 15:43:11 -0700
Subject: [PATCH 09/11] fuse2fs: cache symlink targets in the kernel
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <175797570175.246189.2359979607630459146.stgit@frogsfrogsfrogs>
In-Reply-To: <175797569966.246189.4996503880732213475.stgit@frogsfrogsfrogs>
References: <175797569966.246189.4996503880732213475.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Speed up symlinks by allowing the kernel to cache them.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 misc/fuse2fs.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index f4ae7a273a83f5..1f2700b5f95270 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -951,6 +951,9 @@ static void *op_init(struct fuse_conn_info *conn
 	if (ff->acl)
 		conn->want |= FUSE_CAP_POSIX_ACL;
 #endif
+#ifdef FUSE_CAP_CACHE_SYMLINKS
+	conn->want |= FUSE_CAP_CACHE_SYMLINKS;
+#endif
 #if FUSE_VERSION >= FUSE_MAKE_VERSION(3, 0)
 	conn->time_gran = 1;
 	cfg->use_ino = 1;

