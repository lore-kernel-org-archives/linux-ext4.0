Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4188E334C35;
	Mon, 23 Feb 2026 23:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771888466; cv=none; b=KC2N0KG+dj1rDm9+zKdqz0SN4ImarBUdP7a0LA5vS/GG5Q47UY3hptPlNBmbcyMQUJmCpRE5N1/kJKvZtezW/8cFUUUszCFV6xwIQ2ZO9W2ibpm93Cqre8vVrmp7u0vSytMKpMenXVqx8l/73CBI4M+Uzs93bjYnbOKiylcYGYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771888466; c=relaxed/simple;
	bh=pMx14akQ9tbVp8vzUv0E30YnymERls5Fgx9/mxJHawk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ek34BhhS0o/1Fxs6i2g5tVam/Yxr/scxD4hfAFufVNllZ3ZYFTb09cBTg4Wen+0U6Rum4oYAe+ffR7es7NXlm7CBerYtYH5iuXL2k+GKRW83E9bYcnSEKXgeW1XdkjBzCfJBfZ/um0E8CVCHEraFW372snkkq8SjmyROa2qMD0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dRyQPvRh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dRyQPvRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7868C116C6;
	Mon, 23 Feb 2026 23:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771888465;
	bh=pMx14akQ9tbVp8vzUv0E30YnymERls5Fgx9/mxJHawk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dRyQPvRhlvSl4i5Gk/CafDDCBbMHEuTcRXgISOi//ffcIjRMv/AYbi2GNXbLhLxJD
	 nC1pg7LLs2BmASzQm2ne6xHg35c5oSRGUZ3Y2ERP6bLZ8r3zCNVAR5JqK7FXlp527Y
	 M+FmRdIHW/Ayo5vftlQWTGOUv3zysozyoCkRJVxfoSE5h5wi0RSVGvr/Nq1zeMHy50
	 sg8IjZOs4usnkPrYh/+oKnGBhY16rAo24JKlsI7fXxpvT7Bs1XLGLdqjGG8n44ZxE6
	 VPbxJR2u+7iSCj+G5saBqciSlHnB2wlDv8hqMASBoElLZh2CHsl1LaPIZ7QNjyRznl
	 ooQzsSJ2PC6vA==
Date: Mon, 23 Feb 2026 15:14:25 -0800
Subject: [PATCH 22/33] fuse_trace: query filesystem geometry when using iomap
From: "Darrick J. Wong" <djwong@kernel.org>
To: miklos@szeredi.hu, djwong@kernel.org
Cc: joannelkoong@gmail.com, bpf@vger.kernel.org, bernd@bsbernd.com,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Message-ID: <177188734717.3935739.6035579883274846217.stgit@frogsfrogsfrogs>
In-Reply-To: <177188734044.3935739.1368557343243072212.stgit@frogsfrogsfrogs>
References: <177188734044.3935739.1368557343243072212.stgit@frogsfrogsfrogs>
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
---
 fs/fuse/fuse_trace.h |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/fuse_iomap.c |    2 ++
 2 files changed, 50 insertions(+)


diff --git a/fs/fuse/fuse_trace.h b/fs/fuse/fuse_trace.h
index c832fb9012d983..96c4db84c7106a 100644
--- a/fs/fuse/fuse_trace.h
+++ b/fs/fuse/fuse_trace.h
@@ -58,6 +58,7 @@
 	EM( FUSE_SYNCFS,		"FUSE_SYNCFS")		\
 	EM( FUSE_TMPFILE,		"FUSE_TMPFILE")		\
 	EM( FUSE_STATX,			"FUSE_STATX")		\
+	EM( FUSE_IOMAP_CONFIG,		"FUSE_IOMAP_CONFIG")	\
 	EM( FUSE_IOMAP_BEGIN,		"FUSE_IOMAP_BEGIN")	\
 	EM( FUSE_IOMAP_END,		"FUSE_IOMAP_END")	\
 	EM( FUSE_IOMAP_IOEND,		"FUSE_IOMAP_IOEND")	\
@@ -345,6 +346,14 @@ TRACE_DEFINE_ENUM(FUSE_I_IOMAP);
 	{ IOMAP_IOEND_BOUNDARY,			"boundary" }, \
 	{ IOMAP_IOEND_DIRECT,			"direct" }
 
+#define FUSE_IOMAP_CONFIG_STRINGS \
+	{ FUSE_IOMAP_CONFIG_SID,		"sid" }, \
+	{ FUSE_IOMAP_CONFIG_UUID,		"uuid" }, \
+	{ FUSE_IOMAP_CONFIG_BLOCKSIZE,		"blocksize" }, \
+	{ FUSE_IOMAP_CONFIG_MAX_LINKS,		"max_links" }, \
+	{ FUSE_IOMAP_CONFIG_TIME,		"time" }, \
+	{ FUSE_IOMAP_CONFIG_MAXBYTES,		"maxbytes" }
+
 DECLARE_EVENT_CLASS(fuse_iomap_check_class,
 	TP_PROTO(const char *func, int line, const char *condition),
 
@@ -1005,6 +1014,45 @@ TRACE_EVENT(fuse_iomap_fallocate,
 		  __entry->mode,
 		  __entry->newsize)
 );
+
+TRACE_EVENT(fuse_iomap_config,
+	TP_PROTO(const struct fuse_mount *fm,
+		 const struct fuse_iomap_config_out *outarg),
+	TP_ARGS(fm, outarg),
+
+	TP_STRUCT__entry(
+		__field(dev_t,			connection)
+
+		__field(uint64_t,		flags)
+		__field(uint32_t,		blocksize)
+		__field(uint32_t,		max_links)
+		__field(uint32_t,		time_gran)
+
+		__field(int64_t,		time_min)
+		__field(int64_t,		time_max)
+		__field(int64_t,		maxbytes)
+		__field(uint8_t,		uuid_len)
+	),
+
+	TP_fast_assign(
+		__entry->connection	=	fm->fc->dev;
+		__entry->flags		=	outarg->flags;
+		__entry->blocksize	=	outarg->s_blocksize;
+		__entry->max_links	=	outarg->s_max_links;
+		__entry->time_gran	=	outarg->s_time_gran;
+		__entry->time_min	=	outarg->s_time_min;
+		__entry->time_max	=	outarg->s_time_max;
+		__entry->maxbytes	=	outarg->s_maxbytes;
+		__entry->uuid_len	=	outarg->s_uuid_len;
+	),
+
+	TP_printk("connection %u flags (%s) blocksize 0x%x max_links %u time_gran %u time_min %lld time_max %lld maxbytes 0x%llx uuid_len %u",
+		  __entry->connection,
+		  __print_flags(__entry->flags, "|", FUSE_IOMAP_CONFIG_STRINGS),
+		  __entry->blocksize, __entry->max_links, __entry->time_gran,
+		  __entry->time_min, __entry->time_max, __entry->maxbytes,
+		  __entry->uuid_len)
+);
 #endif /* CONFIG_FUSE_IOMAP */
 
 #endif /* _TRACE_FUSE_H */
diff --git a/fs/fuse/fuse_iomap.c b/fs/fuse/fuse_iomap.c
index d9be7d47fb7acd..b7614674fae9e5 100644
--- a/fs/fuse/fuse_iomap.c
+++ b/fs/fuse/fuse_iomap.c
@@ -745,6 +745,8 @@ static int fuse_iomap_process_config(struct fuse_mount *fm, int error,
 		return error;
 	}
 
+	trace_fuse_iomap_config(fm, outarg);
+
 	if (outarg->flags & ~FUSE_IOMAP_CONFIG_ALL)
 		return -EINVAL;
 

