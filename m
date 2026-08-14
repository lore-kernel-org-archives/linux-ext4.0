Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89CC468C0F
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 11:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786708024; cv=none; b=DLWfmW+74k8n02mfBwX82JgEoPjQ9aNwl5ycONeq8+ea3MR55BF8RiDdHym1qwHNvaduRT18cqAkb+R3WGPUtHAg6ImuwJ/hx7dllg1wjCyIJ3EQ2NKR2aqKVd5yeLPZkp/CxXRDM1+d47fUZeXSPCJJLIyRPM3pNtEfx3/K2go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786708024; c=relaxed/simple;
	bh=+2iizW267rS48I87lDAJbDJ6lsKdwz04TyNcyAaFHJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clHxWjqfo4ckljqHKEn8ZtXRNQQphrX+9KLWhnmY9rTqV4mWJm+gJs34L5baS5AgOX6SRdz53361RhlpNPsw7NEm1TJ4QvmaBwZphPEZdhZAGJFRA7Mal7CB2RSEeXvQt8vRmFgQ3VG48jRNTn/nhd/LFQYcWWqCw37jN5D3yNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KKUQb01Z; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KKUQb01Z"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84e3007a2b7so699993b3a.0
        for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 04:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786708022; x=1787312822; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P4USnQ+SH4S6o6UUa3QazIlBZ1RxVg3Vv6Ro4+AqyBQ=;
        b=KKUQb01ZCQK0Z39hBZilJRApmQx8mzHGJtWVf6lFkijGKDk0GgcJQ6C5/qPtj2AMqt
         VVj5+54lMtbVnVbGDB4NflKjlx7kfYK24Z0NkybDlH9FQdIGbyc4Va3TS6kF2CCqBhL/
         SmiVsWz1u5vwXSYqNAKo4j4KwRKrrRFFwyeiyEfSivvjaJYmennBkOoN9V09n9Sp7YQk
         NVX8YhZCKdr6PFdClxLMCc4x11edLzwco6yYvHqD09bSckrFf8yeoQHs16Lq5Nvrunw+
         O6PW63eIjwJX1sGWR5JaNl+xFNTAnR7bRqMEhukW0DoqwjgA4hnsIWCwtsLoX72GQ58d
         dklQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786708022; x=1787312822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=P4USnQ+SH4S6o6UUa3QazIlBZ1RxVg3Vv6Ro4+AqyBQ=;
        b=DaRZATNNu9r9JEpwzEHpbgiqWSJijn/1NXVSxvfzdYPVAnnXqss8FxBsmczvtVyjxI
         dDJuH2mqUYd6LLwh0i6wz0cG3K86yxeP6jU2Wu2gfVAuPBAvkTUH8yMphf5Vjz44EinH
         BKqgOxgUHcyayVXE6Kvyl68ZlY+S91Fv0+ZDY4a/HxeAOJ/i3dcR6IZLHIVd0FNi/DJt
         JieFSqLeEegsk4nyVqElkWZzR0LIboAXpCxFEOLphrxy4zKE+1HY+Wn3ZworE3GsGtrh
         LM/Oxnte+AUn+o2S20caDTioSpLkV8OoSCuLVoG2h06oN7mIX75y4W4OthyBPF+MKdou
         K4eQ==
X-Forwarded-Encrypted: i=1; AHgh+RoXi+YIlnWIbbNLgop5HkYkH6YgsC6GomS6VYgwIF1arLURReWcWEVMgBP0SJyAT2R+UBWD55lVl9pE@vger.kernel.org
X-Gm-Message-State: AOJu0YxXLgVfFK00NtXG64RDxecHObXtaYRibR0gxcEFcn6Zcm1ALgK6
	XKZJSmpfepzMAX9I+kvEmZTvDGTEznP8JV4mNHYaDMBlknmEe48EJsQ6
X-Gm-Gg: AR+sD12a9iBcqSkPJ60MD9nfifvfPug0FaeUQZdsfTuzlPCxjzjMzND1T2VXz4oIjkJ
	4giHw/0W5la2gJEEBUImj1BiHXdwMGByRY+hcBfQdX+lCIcmhoF8HatitGicmIxJ9mb9mq1fFcL
	DKLSP/jbewbKfaNHw/QJ6k4de7XGR9LNVvXsLwE1McPiNfwtx5gdReResd6DPqZ0LmVLWAFhFlh
	fA35NDYB1eBUmoMEqXDSMAfijBQeiP84PVxwwyIEcAN0rkJQ15ERlfu+yqk5GD/QuJ7tviEk9e+
	sQw9cOAybFkoza7h5Vk12CMMArWJtzwk3BpnjZkiDUvqL7jg60adJrkKU9e2c5k/Z958cATodQ7
	PxFJQVxK2ch+RYN16iuN/Hah2ZTjXawmxsrXN5wayfitiOgYEXvOPBIErF5uG/TkM4Trofbqf7s
	RvPxQGNlmyH+5zoI0pLoylRtfQ5M5cZWBw+RRLqKWQSb8E6/AVRMd44D/AHdgDNO9DNrn653yyB
	6SMfe0YY6yUeUY=
X-Received: by 2002:a05:6a00:bb0f:b0:84e:2722:5da4 with SMTP id d2e1a72fcca58-84fde2e8c7emr4787148b3a.20.1786708021747;
        Fri, 14 Aug 2026 04:47:01 -0700 (PDT)
Received: from localhost.localdomain ([219.251.253.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8517d223e4bsm339450b3a.30.2026.08.14.04.47.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 14 Aug 2026 04:47:01 -0700 (PDT)
From: Kitae Yoo <kitaeyoo777@gmail.com>
To: Jan Kara <jack@suse.com>
Cc: linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kitae Yoo <kitaeyoo777@gmail.com>
Subject: [RFC PATCH 1/2] quota: allow DQF_ROOT_SQUASH on all quota formats
Date: Fri, 14 Aug 2026 20:46:48 +0900
Message-ID: <20260814114649.51253-2-kitaeyoo777@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260814114649.51253-1-kitaeyoo777@gmail.com>
References: <20260814114649.51253-1-kitaeyoo777@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ignore_hardlimit() exempts CAP_SYS_RESOURCE holders from enforcement of
hard limits and of soft limits whose grace time expired.
DQF_ROOT_SQUASH disables that exemption, but it has been confined to the
old v1 quota format since the quota format abstraction was introduced,
and commit ca6cb0918e87 ("quota: Verify flags passed to Q_SETINFO")
later made Q_SETINFO reject it explicitly on other formats.

That confinement predates generic project quota support. Project limits
bound the size of a directory tree rather than restrict a user, and are
commonly used for capacity isolation of container volumes and NFS
exports. There the exemption defeats the purpose: knfsd raises
CAP_SYS_RESOURCE for requests mapped to root on no_root_squash exports
(CAP_NFSD_SET), so any remote root write silently exceeds project hard
limits. XFS enforces project limits regardless of capabilities.

Lift the format restriction so the flag can be set per quota type
through Q_SETINFO on journaled quota as well. Existing setups keep their
behaviour: the flag stays clear unless explicitly set, and setting it
was previously rejected with -EINVAL on anything but QFMT_VFS_OLD -
accepting it there is the user-visible ABI change this patch makes.

Signed-off-by: Kitae Yoo <kitaeyoo777@gmail.com>
---
 fs/quota/dquot.c           | 8 +-------
 include/uapi/linux/quota.h | 2 +-
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 9850de3955..e431e72dfe 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1309,8 +1309,7 @@ static int ignore_hardlimit(struct dquot *dquot)
 	struct mem_dqinfo *info = &sb_dqopt(dquot->dq_sb)->info[dquot->dq_id.type];
 
 	return capable(CAP_SYS_RESOURCE) &&
-	       (info->dqi_format->qf_fmt_id != QFMT_VFS_OLD ||
-		!(info->dqi_flags & DQF_ROOT_SQUASH));
+	       !(info->dqi_flags & DQF_ROOT_SQUASH);
 }
 
 static int dquot_add_inodes(struct dquot *dquot, qsize_t inodes,
@@ -2900,11 +2899,6 @@ int dquot_set_dqinfo(struct super_block *sb, int type, struct qc_info *ii)
 	if (!sb_has_quota_active(sb, type))
 		return -ESRCH;
 	mi = sb_dqopt(sb)->info + type;
-	if (ii->i_fieldmask & QC_FLAGS) {
-		if ((ii->i_flags & QCI_ROOT_SQUASH &&
-		     mi->dqi_format->qf_fmt_id != QFMT_VFS_OLD))
-			return -EINVAL;
-	}
 	spin_lock(&dq_data_lock);
 	if (ii->i_fieldmask & QC_SPC_TIMER)
 		mi->dqi_bgrace = ii->i_spc_timelimit;
diff --git a/include/uapi/linux/quota.h b/include/uapi/linux/quota.h
index 52090105b8..a34f43519a 100644
--- a/include/uapi/linux/quota.h
+++ b/include/uapi/linux/quota.h
@@ -149,7 +149,7 @@ enum {
 	DQF_PRIVATE
 };
 
-/* Root squash enabled (for v1 quota format) */
+/* Enforce limits also for CAP_SYS_RESOURCE processes */
 #define DQF_ROOT_SQUASH	(1 << DQF_ROOT_SQUASH_B)
 /* Quota stored in a system file */
 #define DQF_SYS_FILE	(1 << DQF_SYS_FILE_B)
-- 
2.50.1 (Apple Git-155)

