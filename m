Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E043B37E2FF;
	Mon, 23 Feb 2026 23:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771888513; cv=none; b=Sl4+xLQmgYWdWaH3EzArAg7vglMRqR5Ih3Cu41l74NOK5CGNFOvK7DawvZwLngg4ShL8MUho7c8Y8MGG8gSGiIBTDeTLnvuUobxF4W2oUCQiXqXQSWun4v4WOx4Q8pqXiUyM7n6Lsa2uXXYCJoOfvga36qHCDEeTJdM2shwNchM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771888513; c=relaxed/simple;
	bh=phKrDHiEL15WbgbqYMpIb0ZDNe6cqqfct4sMIGvs18I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WfyzXrAdvBaN/1S41M/WSDDhO4+sQq4S3V9IqhjGkCcbGFefxw7PGJoWyUWxqka5F+vy6Bp7sEHAwvD39udlqF5ul2nGLu8avfeUayhF7dHEN5jXqijJxBbBkURYjwAPMHmr5MA7HrFNEXWpR3955n/06aQVmO2+wVfepAuUqEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sJsDE/SR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sJsDE/SR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B851AC19421;
	Mon, 23 Feb 2026 23:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771888512;
	bh=phKrDHiEL15WbgbqYMpIb0ZDNe6cqqfct4sMIGvs18I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sJsDE/SRG7eEEuEdnKj4zPkfPAOGhDy8ILIXZR+MzSESeNKys3uzSixX9WYP0Ip0V
	 LLdyfaqt0Hgrz05W1MQC3Z/4nwBBR8DDRXs8sDkKHbc79G4WdRgfcNCcqPEJJ5T5Ms
	 +pB09O4GRVvtkHf0yREpYIA8BKM4tnTQfGBtYDj4Q6hGLx3BkzfgT2HsSKOENiUgRu
	 qdV88+GFCos6QAr6eAX+lti31t7WwsLjikkryx0uDCJhJU0SFaGQ6v/6pO9EIOeLdq
	 oSAuHdy54mD3VB6ulgvZo5spcAPfWOIxvzloQDTGD8MgCT7kqc39ZArQnJ5rgh6bmQ
	 mqtB7JXXuwaxQ==
Date: Mon, 23 Feb 2026 15:15:12 -0800
Subject: [PATCH 25/33] fuse_trace: invalidate ranges of block devices being
 used for iomap
From: "Darrick J. Wong" <djwong@kernel.org>
To: miklos@szeredi.hu, djwong@kernel.org
Cc: joannelkoong@gmail.com, bpf@vger.kernel.org, bernd@bsbernd.com,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Message-ID: <177188734781.3935739.13320921850274709434.stgit@frogsfrogsfrogs>
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
 fs/fuse/fuse_trace.h |   26 ++++++++++++++++++++++++++
 fs/fuse/fuse_iomap.c |    2 ++
 2 files changed, 28 insertions(+)


diff --git a/fs/fuse/fuse_trace.h b/fs/fuse/fuse_trace.h
index 96c4db84c7106a..0e4be645802055 100644
--- a/fs/fuse/fuse_trace.h
+++ b/fs/fuse/fuse_trace.h
@@ -1053,6 +1053,32 @@ TRACE_EVENT(fuse_iomap_config,
 		  __entry->time_min, __entry->time_max, __entry->maxbytes,
 		  __entry->uuid_len)
 );
+
+TRACE_EVENT(fuse_iomap_dev_inval,
+	TP_PROTO(const struct fuse_conn *fc,
+		 const struct fuse_iomap_dev_inval_out *arg),
+	TP_ARGS(fc, arg),
+
+	TP_STRUCT__entry(
+		__field(dev_t,			connection)
+		__field(int,			dev)
+		__field(unsigned long long,	offset)
+		__field(unsigned long long,	length)
+	),
+
+	TP_fast_assign(
+		__entry->connection	=	fc->dev;
+		__entry->dev		=	arg->dev;
+		__entry->offset		=	arg->range.offset;
+		__entry->length		=	arg->range.length;
+	),
+
+	TP_printk("connection %u dev %d offset 0x%llx length 0x%llx",
+		  __entry->connection,
+		  __entry->dev,
+		  __entry->offset,
+		  __entry->length)
+);
 #endif /* CONFIG_FUSE_IOMAP */
 
 #endif /* _TRACE_FUSE_H */
diff --git a/fs/fuse/fuse_iomap.c b/fs/fuse/fuse_iomap.c
index 21c286c285a59d..e8a0c1ceb409c4 100644
--- a/fs/fuse/fuse_iomap.c
+++ b/fs/fuse/fuse_iomap.c
@@ -2007,6 +2007,8 @@ int fuse_iomap_dev_inval(struct fuse_conn *fc,
 	loff_t end;
 	int ret = 0;
 
+	trace_fuse_iomap_dev_inval(fc, arg);
+
 	if (!fc->iomap || arg->dev == FUSE_IOMAP_DEV_NULL)
 		return -EINVAL;
 

