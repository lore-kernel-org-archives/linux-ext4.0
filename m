Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7FF3DD514
	for <linux-ext4@vger.kernel.org>; Mon,  4 May 2026 23:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777937609; cv=none; b=WsqH7sD83uSaCuAwr5wZlgZvInaGv6odWCCLfkrfI0cwMMKqmn6YdYfxY0b1Fok+9ogtDY9UkE/qJwZCUwuas07OeuYU8xQsMWozwkoBztIFAxLdSb5Eh62cwn3HClwgQyyFxNnyKjNc4i/fDm0Ee/ChMK3aWBUqPR0OT1J9jRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777937609; c=relaxed/simple;
	bh=UJftfRWyrhUNrUAN1OIV3hssSIeFM3Kg1peGdg0EvLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xyag0AB/nZ2IaF4vOqdHlQ60jTfwf5gRFour46nI+hMQ+EmI/gUxqZxLP9GqduALvQRX1hf56p0SxAV6mdOmZjIpZAovX8ASxSdI9FkUnBEWlGDyIZQ7FJgzNShG2PY4uSL+Sotda0HWQo9dfIFblbxGCwKK52M8+6DBLBaFdMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=cuaynlWf; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="cuaynlWf"
Received: from trampoline.thunk.org (pool-173-48-114-3.bstnma.fios.verizon.net [173.48.114.3])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 644NX9C6019587
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 4 May 2026 19:33:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1777937591; bh=/CKw94rtLKlTyHveWP3NtTWlvlJL24XJTQ+DH/P8GGA=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=cuaynlWf0FZb2e+66+BJq1Cq8SGjMzEzoqH27y+B2m/ktzrltOO1VycaF10J+i7H0
	 bHvPLB8SqLRWkMig2cEJXVeXPwFULkgMIx1N5arGvDevlEQmCfCzuEyexhgKWBOV4Q
	 lu0DKp0wfTIGiJ1hzV7lzNJ8fdIgDLTrr5LQhwLbhMps3pVSm7q+Z2+Fl6CoJ8unWd
	 yrneA5eP3N4+sx4W0Gcf/8V671glf8luGzQWMH0vMcEAkpaiTH7/YMQHHaolUBEKBa
	 NgFXg/l08bzcxI8Pd5wEiGp1DLkhlAK3iqsmRlIVeb35z3vvozkIlNl2ULMcvaJLzG
	 gdhnEqq+lsHag==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 0C73F2E00D7; Mon, 04 May 2026 19:33:08 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 7/7] fuse2fs: fix uninitialized variable warnings
Date: Mon,  4 May 2026 19:33:01 -0400
Message-ID: <20260504233301.2345652-8-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260504233301.2345652-1-tytso@mit.edu>
References: <20260504233301.2345652-1-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clang treats use of unitialized variables found by static analysis to
be serious enough that it will emit them by default (even without
-Wall).  So let's fix them up.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fuse4fs/fuse4fs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index b883083f8..928473268 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -2216,7 +2216,7 @@ static void op_mknod(fuse_req_t req, fuse_ino_t fino, const char *name,
 	const struct fuse_ctx *ctxt = fuse_req_ctx(req);
 	struct fuse4fs *ff = fuse4fs_get(req);
 	ext2_filsys fs;
-	ext2_ino_t parent, child;
+	ext2_ino_t parent, child = 0;
 	errcode_t err;
 	int filetype;
 	gid_t gid;
@@ -2311,7 +2311,7 @@ static void op_mkdir(fuse_req_t req, fuse_ino_t fino, const char *name,
 	const struct fuse_ctx *ctxt = fuse_req_ctx(req);
 	struct fuse4fs *ff = fuse4fs_get(req);
 	ext2_filsys fs;
-	ext2_ino_t parent, child;
+	ext2_ino_t parent, child = 0;
 	errcode_t err;
 	char *block;
 	blk64_t blk;
@@ -2990,7 +2990,7 @@ static void op_symlink(fuse_req_t req, const char *target, fuse_ino_t fino,
 	const struct fuse_ctx *ctxt = fuse_req_ctx(req);
 	struct fuse4fs *ff = fuse4fs_get(req);
 	ext2_filsys fs;
-	ext2_ino_t parent, child;
+	ext2_ino_t parent, child = 0;
 	errcode_t err;
 	gid_t gid;
 	int ret = 0;
@@ -6042,7 +6042,7 @@ static int fuse4fs_main(struct fuse_args *args, struct fuse4fs *ff)
 	struct fuse_cmdline_opts opts;
 	struct fuse_session *se;
 	struct fuse_loop_config *loop_config = NULL;
-	int ret;
+	int ret = 0;
 
 	if (fuse_parse_cmdline(args, &opts) != 0) {
 		ret = 1;
-- 
2.53.0

