Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4769B32694F;
	Wed, 29 Apr 2026 14:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474671; cv=none; b=Rb8jTMU8EPvALe8CUEyMnb/SjA+OE+uQwM09ahnVBT1kwKw5Ks05syb/maty1zfxT/LpRgkovweTRcr9rReTDGhjAuzfzmWtqXpthmS5dopfVImpyzSm6m4AW+jWDIH9+ogeNmJSJcWl/AeABFMJfry0u7eSOwaGDbkA3IkHY6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474671; c=relaxed/simple;
	bh=+1qcRrkwPkKYIhYfSSdw6RXfN4OfMOmlIcoWZLsn9cc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dqgfaNhKS3351wniOzcTJoWxu2XyQ2/79ZjMxr1ZmUa2c6fjFQUI7De65R89ZU2XFjIuXp6iHhblrPErIGr26FIgP2qKaChEFcbJBUJuQLfZ6T3xaZjD33gs/7jiyggB2sduAnCY+9Bo7uR08M3ZsO3OWyF4VD1ZbHEc669YdhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BiUlI2jO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BiUlI2jO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA1BC19425;
	Wed, 29 Apr 2026 14:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474671;
	bh=+1qcRrkwPkKYIhYfSSdw6RXfN4OfMOmlIcoWZLsn9cc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BiUlI2jOAcIng1GDMvjmueoAWOLRyUi0on22X5CfMmeGZ12bfdL/Ye9vmLrl7wxaw
	 5qdsPLk8RCKcg+tRT3H5WIJV4U26LxLDxpsWlj08auJhGTGZ1l4ya196RUoA3Yoxvd
	 JH93WIvc0vDJVDu+/YLuxFP93NMkcX6IoTr/aGMdckMwzD3wMf20RA6EkbfKprYyzI
	 SrwrYsjHGs3O0DL3yT5330Bk0/xLU1WwpRx5b98dyjs8Ug2XEZYGf2Rbid57iGQqSL
	 ew8otYYzHY18VPwut5qWGXWfy8UHfleo4hdhZ+zQG67p8gukkZI8GCkp4dqfjhAS7I
	 x+KfXpxUrtqDA==
Date: Wed, 29 Apr 2026 07:57:50 -0700
Subject: [PATCH 1/3] fuse4fs: configure iomap when running as a service
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747215045.4109882.5372076002580949348.stgit@frogsfrogsfrogs>
In-Reply-To: <177747215017.4109882.630706253054166885.stgit@frogsfrogsfrogs>
References: <177747215017.4109882.630706253054166885.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We have to ask the mount helper to enable iomap for us on the fuse
connection, so do that before mounting.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 46f81e2066b044..d7de2e94a7e536 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -334,8 +334,14 @@ static inline bool fuse4fs_is_service(const struct fuse4fs *ff)
 {
 	return fuse_service_accepted(ff->service);
 }
+
+static int fuse4fs_service_discover_iomap(struct fuse4fs *ff)
+{
+	return fuse_service_discover_iomap(ff->service);
+}
 #else
 # define fuse4fs_is_service(...)		(false)
+# define fuse4fs_service_discover_iomap(...)	(0)
 #endif
 
 #define FUSE4FS_CHECK_HANDLE(req, fh) \
@@ -935,6 +941,11 @@ static inline void fuse4fs_discover_iomap(struct fuse4fs *ff)
 	if (ff->iomap_want == FT_DISABLE)
 		return;
 
+	if (fuse4fs_is_service(ff)) {
+		ff->iomap_cap = fuse4fs_service_discover_iomap(ff);
+		return;
+	}
+
 	ff->iomap_cap = fuse_lowlevel_discover_iomap(-1);
 }
 
@@ -1579,6 +1590,30 @@ static errcode_t fuse4fs_service_openfs(struct fuse4fs *ff, char *options,
 # define fuse4fs_service_openfs(...)		(EOPNOTSUPP)
 #endif
 
+#if defined(HAVE_FUSE4FS_SERVICE) && defined(HAVE_FUSE_IOMAP)
+static int fuse4fs_service_configure_iomap(struct fuse4fs *ff)
+{
+	int error = 0;
+	int ret;
+
+	ret = fuse_service_configure_iomap(ff->service,
+					   ff->iomap_want == FT_ENABLE,
+					   &error);
+	if (ret)
+		return -1;
+
+	if (error) {
+		err_printf(ff, "%s: %s.\n", _("enabling iomap"),
+			   strerror(error));
+		return -1;
+	}
+
+	return 0;
+}
+#else
+# define fuse4fs_service_configure_iomap(...)	(EOPNOTSUPP)
+#endif
+
 static errcode_t fuse4fs_acquire_lockfile(struct fuse4fs *ff)
 {
 	char *resolved;
@@ -8373,6 +8408,16 @@ int main(int argc, char *argv[])
 			ret = 2;
 			goto out;
 		}
+
+#ifdef HAVE_FUSE_IOMAP
+		if (fctx.iomap_want != FT_DISABLE) {
+			ret = fuse4fs_service_configure_iomap(&fctx);
+			if (ret) {
+				ret = 2;
+				goto out;
+			}
+		}
+#endif
 	}
 
 	try_adjust_oom_score(&fctx);

