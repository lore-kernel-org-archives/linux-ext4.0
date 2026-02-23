Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D5537E2F4;
	Mon, 23 Feb 2026 23:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771888121; cv=none; b=R5+ppccOccw3Ofd51fKYj4WPr5tMW4y4g7EfyL840mJ19UF/azVKz8+CdgZIglaTiVBoWqFu8z4ly9MEy7k2idVa+0TI006b5EW0ydNePYqUF7gwyDixkpzzeTCKWpumiAijnAvjkD9tLCbwVdCtMzIs1cDtFO6bbykZWDioDu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771888121; c=relaxed/simple;
	bh=IytVmE4pO4BPrH6h/7neOQU9xS9fu5UyQMn5loH/J30=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fxiqdQQg3gD3JVr07/qFvYIn0KpDY5bqb6EqmY1aDdf3B3elwXB/htOnIeRKIOnUupwLtr72MjkI/wMDyDEeT1VzVlkYIkSfsszuoQBe0ABpUvJyKzjddk9W8OenMSfD3z+RqL77Nu2jLJoMWeCU98duwgw23gEd4fBGBsw5E6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MkC2BbFi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MkC2BbFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8C6C116C6;
	Mon, 23 Feb 2026 23:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771888120;
	bh=IytVmE4pO4BPrH6h/7neOQU9xS9fu5UyQMn5loH/J30=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MkC2BbFiE3S0huWPxqC6+y/5sjAkQCnZCxwji4AyLwbs+iRqUD1ZhFCPdjAutuMWy
	 8RV4D3DVmkqf/DT7aF/NucQgnNVQpXkcwjoTL/Jm/1yYlNj8jgHAb5fS4zkGbRMgHe
	 uf1XLQwpmfd3FZfIma7BoSiDD51xVxjH8+19Wzlvft/1iOKbNQE2WcFcMBoyoNkX/F
	 juAaLKU0q0OuXfqOIXUU/XFG97GJ96uSfMf4Qi4GV6fdJouifBI+Wahrc4H3r1P1NN
	 L+KcoWikEHdG5Awc1bYQD71v0a+3019XexTVmcX0pZsTVQ6U8LOfy8J2C94v5t+G3j
	 8mXf97jPSAmOw==
Date: Mon, 23 Feb 2026 15:08:40 -0800
Subject: [PATCH 2/2] fuse_trace: move the passthrough-specific code back to
 passthrough.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: miklos@szeredi.hu, djwong@kernel.org
Cc: joannelkoong@gmail.com, joannelkoong@gmail.com, bpf@vger.kernel.org,
 bernd@bsbernd.com, neal@gompa.dev, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org
Message-ID: <177188733751.3935601.17061277930300835596.stgit@frogsfrogsfrogs>
In-Reply-To: <177188733698.3935601.154959695370946923.stgit@frogsfrogsfrogs>
References: <177188733698.3935601.154959695370946923.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add tracepoints for the previous patch.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/fuse_trace.h |   35 +++++++++++++++++++++++++++++++++++
 fs/fuse/backing.c    |    5 +++++
 2 files changed, 40 insertions(+)


diff --git a/fs/fuse/fuse_trace.h b/fs/fuse/fuse_trace.h
index bbe9ddd8c71696..286a0845dc0898 100644
--- a/fs/fuse/fuse_trace.h
+++ b/fs/fuse/fuse_trace.h
@@ -124,6 +124,41 @@ TRACE_EVENT(fuse_request_end,
 		  __entry->unique, __entry->len, __entry->error)
 );
 
+#ifdef CONFIG_FUSE_BACKING
+TRACE_EVENT(fuse_backing_class,
+	TP_PROTO(const struct fuse_conn *fc, unsigned int idx,
+		 const struct fuse_backing *fb),
+
+	TP_ARGS(fc, idx, fb),
+
+	TP_STRUCT__entry(
+		__field(dev_t,			connection)
+		__field(unsigned int,		idx)
+		__field(unsigned long,		ino)
+	),
+
+	TP_fast_assign(
+		struct inode *inode = file_inode(fb->file);
+
+		__entry->connection	=	fc->dev;
+		__entry->idx		=	idx;
+		__entry->ino		=	inode->i_ino;
+	),
+
+	TP_printk("connection %u idx %u ino 0x%lx",
+		  __entry->connection,
+		  __entry->idx,
+		  __entry->ino)
+);
+#define DEFINE_FUSE_BACKING_EVENT(name)		\
+DEFINE_EVENT(fuse_backing_class, name,		\
+	TP_PROTO(const struct fuse_conn *fc, unsigned int idx, \
+		 const struct fuse_backing *fb), \
+	TP_ARGS(fc, idx, fb))
+DEFINE_FUSE_BACKING_EVENT(fuse_backing_open);
+DEFINE_FUSE_BACKING_EVENT(fuse_backing_close);
+#endif /* CONFIG_FUSE_BACKING */
+
 #endif /* _TRACE_FUSE_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index adb4d2ebb21379..d7e074c30f46cc 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -72,6 +72,7 @@ static int fuse_backing_id_free(int id, void *p, void *data)
 
 	WARN_ON_ONCE(refcount_read(&fb->count) != 1);
 
+	trace_fuse_backing_close((struct fuse_conn *)data, id, fb);
 	fuse_backing_free(fb);
 	return 0;
 }
@@ -145,6 +146,8 @@ int fuse_backing_open(struct fuse_conn *fc, struct fuse_backing_map *map)
 		fb = NULL;
 		goto out;
 	}
+
+	trace_fuse_backing_open(fc, res, fb);
 out:
 	pr_debug("%s: fb=0x%p, ret=%i\n", __func__, fb, res);
 
@@ -194,6 +197,8 @@ int fuse_backing_close(struct fuse_conn *fc, int backing_id)
 	if (err)
 		goto out_fb;
 
+	trace_fuse_backing_close(fc, backing_id, fb);
+
 	err = -ENOENT;
 	test_fb = fuse_backing_id_remove(fc, backing_id);
 	if (!test_fb)

