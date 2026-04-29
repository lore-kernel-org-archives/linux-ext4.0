Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8737A1E98E3;
	Wed, 29 Apr 2026 15:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474889; cv=none; b=XAchhGVb6OVje0u9JMf31ZHTA3tub79Rfwr3BTjP+0atoctsfaA5A3W44XIUbIAmdGWiG61VDbVqmTxyjZgJeez3Wy4m5j+u+fYnf7nqbrke1emNjZjjnFl3kxiJxx3xWjaDT0eBlsEG5nreLkXpIQQiSY7t7LZpW/6veJIUSbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474889; c=relaxed/simple;
	bh=UchNZ+sOI1GCFZfSgmmjrxLhVsiKxaRAhoi0+Mwhm5A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VazZWAy8DVKijxTTCZ+L+m57C8VS34QRZf1T9g35Nr/+mTrqKmaCkqmirEtDSer70YTdqFu8Ag/dDnovpp3MB4HjkXytjn6AI0vQEWHkgK9xUdydvM1gmqx/pkIFL2jwz6palcgy1bOHB794gtONKmuLISXNY00bjcS2Ay2TclQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fk88YCE8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fk88YCE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61968C19425;
	Wed, 29 Apr 2026 15:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474889;
	bh=UchNZ+sOI1GCFZfSgmmjrxLhVsiKxaRAhoi0+Mwhm5A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Fk88YCE8cWacVfhXT5p4Da1NqZ5MvmNosqeOZUklrG30XbA4Mupzm00bC+JLnRG7I
	 Ao9rfCyBv8k7u+3wnJATfnRLxpK8zIbmyt7R9srmoE+Z5NdggoG537AR4yJysHK1EQ
	 9UdxskYZ5A9K4MLf/8N/j8WgIeNAH7rF5eHdCEsJ4HA2p6tEA+81FHpn7WvfaDaOGx
	 sIv1HMiKYTYpIc6Niv3zsBhJnw/leudscWId9VOpvwFNQiF9L/P2h4zXIJ86JOpOw+
	 12mfw8BpI+5u77M+K5+8ssla4IrQHTc5G4GSsa9HZgFu6aaIDG88pvqb2xvIe72Fx+
	 yE2rbzoAAmqNg==
Date: Wed, 29 Apr 2026 08:01:29 -0700
Subject: [PATCH 1/4] fuse2fs: enable caching of iomaps
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747215717.4110581.2902242851952264152.stgit@frogsfrogsfrogs>
In-Reply-To: <177747215686.4110581.16852917113451473539.stgit@frogsfrogsfrogs>
References: <177747215686.4110581.16852917113451473539.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Cache the iomaps we generate in the kernel for better performance.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   30 ++++++++++++++++++++++++++++++
 misc/fuse2fs.c    |   29 +++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 9f7fe365ccdf87..56a79dd48c9f43 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -304,6 +304,8 @@ struct fuse4fs {
 #ifdef STATX_WRITE_ATOMIC
 	unsigned int awu_min, awu_max;
 #endif
+	/* options set by fuse_opt_parse must be of type int */
+	int iomap_cache;
 #endif
 	unsigned int blockmask;
 	unsigned long offset;
@@ -2314,6 +2316,7 @@ static void fuse4fs_iomap_enable(struct fuse_conn_info *conn,
 			err_printf(ff, "%s\n", _("Could not enable iomap."));
 		if (ff->iomap_passthrough_options)
 			err_printf(ff, "%s\n", _("Some mount options require iomap."));
+		ff->iomap_cache = 0;
 		return;
 	}
 }
@@ -7169,6 +7172,28 @@ static void op_iomap_begin(fuse_req_t req, fuse_ino_t fino, uint64_t dontcare,
 	if (opflags & FUSE_IOMAP_OP_ATOMIC)
 		read.flags |= FUSE_IOMAP_F_ATOMIC_BIO;
 
+	/*
+	 * For real IO operations, cache the mapping in the kernel so that we
+	 * can reuse them for subsequent IO to the same regions.  Don't let
+	 * FIEMAP thrash the cache.
+	 */
+	if (!(opflags & FUSE_IOMAP_OP_REPORT) && ff->iomap_cache) {
+		ret = fuse_lowlevel_iomap_upsert_mappings(ff->fuse, fino, ino,
+							  &read, NULL);
+		if (ret) {
+			/*
+			 * Log the cache upsert error, but we can still return
+			 * the mapping via the reply.  EINVAL is the magic code
+			 * for the kernel declining to cache the mapping.
+			 */
+			if (ret != -ENOMEM && ret != -EINVAL)
+				translate_error(fs, ino, -ret);
+			goto out_unlock;
+		}
+
+		fuse_file_iomap_retry_cache(&read);
+	}
+
 out_unlock:
 	fuse4fs_finish(ff, ret);
 	if (ret)
@@ -7993,6 +8018,10 @@ static struct fuse_opt fuse4fs_opts[] = {
 #ifdef HAVE_CLOCK_MONOTONIC
 	FUSE4FS_OPT("timing",		timing,			1),
 #endif
+#ifdef HAVE_FUSE_IOMAP
+	FUSE4FS_OPT("iomap_cache",	iomap_cache,		1),
+	FUSE4FS_OPT("noiomap_cache",	iomap_cache,		0),
+#endif
 
 #ifdef HAVE_FUSE_IOMAP
 #ifdef MS_LAZYTIME
@@ -8487,6 +8516,7 @@ int main(int argc, char *argv[])
 		.iomap_want = FT_DEFAULT,
 		.iomap_state = IOMAP_UNKNOWN,
 		.iomap_dev = FUSE_IOMAP_DEV_NULL,
+		.iomap_cache = 1,
 #endif
 #ifdef HAVE_FUSE_LOOPDEV
 		.loop_fd = -1,
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 6e4780121d5c83..e485c38bda41e8 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -285,6 +285,8 @@ struct fuse2fs {
 #ifdef STATX_WRITE_ATOMIC
 	unsigned int awu_min, awu_max;
 #endif
+	/* options set by fuse_opt_parse must be of type int */
+	int iomap_cache;
 #endif
 	unsigned int blockmask;
 	unsigned long offset;
@@ -1870,6 +1872,7 @@ static void fuse2fs_iomap_enable(struct fuse_conn_info *conn,
 			err_printf(ff, "%s\n", _("Could not enable iomap."));
 		if (ff->iomap_passthrough_options)
 			err_printf(ff, "%s\n", _("Some mount options require iomap."));
+		ff->iomap_cache = 0;
 		return;
 	}
 }
@@ -6453,6 +6456,27 @@ static int op_iomap_begin(const char *path, uint64_t nodeid, uint64_t attr_ino,
 	if (opflags & FUSE_IOMAP_OP_ATOMIC)
 		read->flags |= FUSE_IOMAP_F_ATOMIC_BIO;
 
+	/*
+	 * For real IO operations, cache the mapping in the kernel so that we
+	 * can reuse them for subsequent IO to the same regions.  Don't let
+	 * FIEMAP thrash the cache.
+	 */
+	if (!(opflags & FUSE_IOMAP_OP_REPORT) && ff->iomap_cache) {
+		ret = fuse_fs_iomap_upsert(nodeid, attr_ino, read, NULL);
+		if (ret) {
+			/*
+			 * Log the cache upsert error, but we can still return
+			 * the mapping via the reply.  EINVAL is the magic code
+			 * for the kernel declining to cache the mapping.
+			 */
+			if (ret != -ENOMEM && ret != -EINVAL)
+				translate_error(fs, attr_ino, -ret);
+			goto out_unlock;
+		}
+
+		fuse_file_iomap_retry_cache(read);
+	}
+
 out_unlock:
 	fuse2fs_finish(ff, ret);
 	return ret;
@@ -7259,6 +7283,10 @@ static struct fuse_opt fuse2fs_opts[] = {
 #ifdef HAVE_CLOCK_MONOTONIC
 	FUSE2FS_OPT("timing",		timing,			1),
 #endif
+#ifdef HAVE_FUSE_IOMAP
+	FUSE2FS_OPT("iomap_cache",	iomap_cache,		1),
+	FUSE2FS_OPT("noiomap_cache",	iomap_cache,		0),
+#endif
 
 #ifdef HAVE_FUSE_IOMAP
 #ifdef MS_LAZYTIME
@@ -7539,6 +7567,7 @@ int main(int argc, char *argv[])
 		.iomap_want = FT_DEFAULT,
 		.iomap_state = IOMAP_UNKNOWN,
 		.iomap_dev = FUSE_IOMAP_DEV_NULL,
+		.iomap_cache = 1,
 #endif
 #ifdef HAVE_FUSE_LOOPDEV
 		.loop_fd = -1,

