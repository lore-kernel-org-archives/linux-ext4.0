Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8CE36C0B3;
	Mon, 23 Feb 2026 23:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771889419; cv=none; b=qtC/J9a2qMUoTW07U4rC+sXADkgpzcNSvQDhSq/y/n3A/2sG4YwuHP+tE0T7QbBJKajUX9rbz1VZKwTYbrItCCM/YbaquuhlXljK6k4Z1+C84kr0xfuY4BJ8H3BApfLi2QjPxOpQJVotkhAyfq2m6usvfW6t/Hk80iLOA1HfLY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771889419; c=relaxed/simple;
	bh=iAwgUar5P4pk3WC4IOyq3A+2LgxQcBc68GyrE7bowQs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cWtK6pjh3zp+bxKOvtZqEipUY9Y1HXeMw14C+CGg3eoGjaGYEQr/LUMDMQ696TEt4EN+YWHgNqd4qxJ40rjUNoluNltoOf1iAA/pKB/0QK1YcqM9lD32Q3F1w1e79d0AH22yNHKw2wSvQ3K049wyyXxsX9y5JTkm8vaMUVTOwUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i4DaHelH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i4DaHelH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFD6C19421;
	Mon, 23 Feb 2026 23:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771889419;
	bh=iAwgUar5P4pk3WC4IOyq3A+2LgxQcBc68GyrE7bowQs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i4DaHelHSs0rwi4M1h8at7QI9fbyFwlEYTMbt4ylxbyNuiuMp5Ja0qKVSoxCAA2xb
	 Qhm7gGeJkb9LsFUgZCJOQYzFK1klAgJilBueMRyBINuxvuDOmCdWUGxjSGxs/c0mM5
	 Ev9XahmfIJ5YL2zqHuz5AyBcRD3N9qk3O3XudG8b+WXz71gVi4fFwmRhIz3oSQCiVG
	 wYckqXe9aPtdKhb8rBEMkHX6pMhMNTDru3lF4niAv96VzV35Lo6Zb4gZsHquTFMlZv
	 x754c6CuzauRPb+4EmNwDV5+WgbKkhICU+ibornaJMDbZycW3jthSQPktber95kHHr
	 yfC5+X3Rcm1hQ==
Date: Mon, 23 Feb 2026 15:30:18 -0800
Subject: [PATCH 19/25] libfuse: add upper-level API to invalidate parts of an
 iomap block device
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, bschubert@ddn.com
Cc: bernd@bsbernd.com, miklos@szeredi.hu, neal@gompa.dev,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 bpf@vger.kernel.org, joannelkoong@gmail.com
Message-ID: <177188740274.3940670.14027096129181459664.stgit@frogsfrogsfrogs>
In-Reply-To: <177188739839.3940670.15233996351019069073.stgit@frogsfrogsfrogs>
References: <177188739839.3940670.15233996351019069073.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Wire up the upper-level wrappers to
fuse_lowlevel_iomap_invalidate_device.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 include/fuse.h         |   10 ++++++++++
 lib/fuse.c             |    9 +++++++++
 lib/fuse_versionscript |    1 +
 3 files changed, 20 insertions(+)


diff --git a/include/fuse.h b/include/fuse.h
index 9f0ac44295e46f..db4281e3f330c6 100644
--- a/include/fuse.h
+++ b/include/fuse.h
@@ -1445,6 +1445,16 @@ int fuse_fs_iomap_device_add(int fd, unsigned int flags);
  */
 int fuse_fs_iomap_device_remove(int device_id);
 
+/**
+ * Invalidate any pagecache for the given iomap (block) device.
+ *
+ * @param device_id device index as returned by fuse_lowlevel_iomap_device_add
+ * @param offset starting offset of the range to invalidate
+ * @param length length of the range to invalidate
+ * @return 0 on success, or negative errno on failure
+ */
+int fuse_fs_iomap_device_invalidate(int device_id, off_t offset, off_t length);
+
 /**
  * Decide if we can enable iomap mode for a particular file for an upper-level
  * fuse server.
diff --git a/lib/fuse.c b/lib/fuse.c
index 5301e34901bb3e..022888c475cb3d 100644
--- a/lib/fuse.c
+++ b/lib/fuse.c
@@ -2932,6 +2932,15 @@ int fuse_fs_iomap_device_remove(int device_id)
 	return fuse_lowlevel_iomap_device_remove(se, device_id);
 }
 
+int fuse_fs_iomap_device_invalidate(int device_id, off_t offset, off_t length)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse_session *se = fuse_get_session(ctxt->fuse);
+
+	return fuse_lowlevel_iomap_device_invalidate(se, device_id, offset,
+						     length);
+}
+
 static int fuse_fs_iomap_ioend(struct fuse_fs *fs, const char *path,
 			       uint64_t nodeid, uint64_t attr_ino, off_t pos,
 			       uint64_t written, uint32_t ioendflags, int error,
diff --git a/lib/fuse_versionscript b/lib/fuse_versionscript
index 56edd16862ca30..56cc5fade272e5 100644
--- a/lib/fuse_versionscript
+++ b/lib/fuse_versionscript
@@ -247,6 +247,7 @@ FUSE_3.99 {
 		fuse_lowlevel_discover_iomap;
 		fuse_reply_iomap_config;
 		fuse_lowlevel_iomap_device_invalidate;
+		fuse_fs_iomap_device_invalidate;
 } FUSE_3.19;
 
 # Local Variables:

