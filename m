Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABDA3D5C1D
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 22:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621700; cv=none; b=YL1udlmch8VqTWNq2krkde6Abkj4K3aS0D4wvmdMaJXl+1T2gmqJ1Kkio3Z8Ji+vZveZvOeaJr7vFMlvMOyBfulYAs0QvdQ5LbJShPNgaTM3t2lrEEsmFWUKsVUgQ9lQGYKCfJka0GMmdSJzXMB0yo7yVDDRXEG8KzNcSph60x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621700; c=relaxed/simple;
	bh=/v7VBJbAb9aO5qRUONItTpWH4owbSyqDIsLqUgwMCt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epLhpg/YvTOWrUdWtk7iQoFY6NxOdnIL38cdAXzFYGAZ6srStyWV1pJcb8jQrtAiMVxpGFnD5cj2IjsXqCtXsS84XfbXlwdUoBp6sAGIxCj/4U/6okDnzfjgZEuBsSWeY7wzDMOMAGEN4anQ05hNKthsWqzjrbdgepgvzhWEaNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cONoK9DE; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cONoK9DE"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-81ed073fed0so31938617b3.0
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 15:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621696; x=1786226496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XvLI01z2FUEK9ccgzSRudNIsKkvOOlfj4ulYih3+qTw=;
        b=cONoK9DEybQyse0MMTQ578SeX73NzsGajXVpScsaVCJ+Q1kArj6DfxOs2OefFKR2K5
         uJMfUUjnbC/vVh4s+ij14YZW41ohWsko3lGk8C16Q6ICvWjdXbC/fZZupzXFfsJA+c6Z
         o7tCP54FlCsxzO1DWuiLIvDAhEKlnlsPKfJBYkbbvC9JeNHC/7QqAAYrMPtNJXY6GrMj
         CZOPk6hpy/Ujf3U+k72bjN9mHQ7hXN7Mjk1+9ky5SfnQ0dBAKQ+RAayPm09T6WRAoa6i
         TqqKi1B1w1iG8gWtbWmvBZcvS+rv5GfHCb92w0oSCPudhnQS3MGXHCr//Ng5XGCVnuhQ
         oBTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621696; x=1786226496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XvLI01z2FUEK9ccgzSRudNIsKkvOOlfj4ulYih3+qTw=;
        b=gtEHjQVZD1c+1rZZG3BDcu+hGLThSzm0xij5DaB44YAnaaE45q3je7WMPx5+7VI5aS
         07mvRzXlnFnpzpceWXbs+ubet42ksxI2LbOC/R46m37LBFUSzQZBOIzFGu8llgt+fMEG
         mz5tYJQLQrp75/VE4UpqEx4nhaeT1Pcj2tD6q49eHvMWG3D+ViyQNRsTlrbps5Wi66my
         oRIjXuFaw39fN9qbbmzLKKagWdcgyKkDmdclDnpKYW7NXQLf48qXu0ZOPa7DFLTiJNjr
         A+lcoZz86A1z6jGkxRcTcd1UYdrh18O2kBe0m4t1AEcKcVUeA2zQm4k+J4PEm0WFCJW3
         IKlg==
X-Forwarded-Encrypted: i=1; AHgh+RoePq6U+9D8tJLDS7gkg1oCiaLMA39dPtMvUj091ebzynKGsCvM/LOmMRsKvl3esn3F3y9fnyFf1Hik@vger.kernel.org
X-Gm-Message-State: AOJu0YweWquj0S8LYSV7+YbOPxcQryq0YMJZNbWzpEbZlLCvzatL3CSf
	5dU05syviKjIRSTsrZKrey57yOlxrG8Y4cdKtaEIrFVHndbI8u4Ws4k3
X-Gm-Gg: AR+sD12DIRljfC6ZNFQBnIDWlT5ytG0XfAZqKd2BiH4O/GCm6bCyMdmBKnLbxJDrm4K
	6FeJdWXrQUOLCBidtCg/YFSJo8vFx38BgrDe8DzU1m6fq5kt/bvxHchmLSLJKbdZjZtXuUkmIs9
	tR0SjKshnc6byysqV54QFhXlPAZnSPDT8sY968R/KphnKprsOlkhlnXV5La4LWIfjk2y5iuGYri
	K+D/k9qR1yrGgxwZzfJ4mFSdOpJmGYQI9wkV7VBY1Hk8KQM4SU+Uh2zfn4tvzUTBQF/L7EpfLyt
	EjzA0Iyd0p+xEd6HuEVgDoYyDzbE15tPOvGP/5bNhgBdlXbv1vl90GAi9Go13CCnVQYfn32Jofe
	n1W2PcOdW69WcLYwBireF8v6prm1O2D3h+WFHJTtfhwA42fTgPDvCTvfe3FI8ZVLuFUP/DrpiRF
	274OzyMPa+qfgCca37oiTqanSjHUlZbFL/q7gGpRgRg5YCxZ7HAbZonC2Zciwf3zaHuo/2ELEku
	BfexbqymUtClYrI+1A=
X-Received: by 2002:a05:690c:eca:b0:7ff:87e1:34d1 with SMTP id 00721157ae682-81fd4a5a892mr78630197b3.11.1785621696163;
        Sat, 01 Aug 2026 15:01:36 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:35 -0700 (PDT)
From: Chao Shi <coshi036@gmail.com>
To: Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-karma-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>
Subject: [PATCH 18/19] ext4, jbd2: report fast commit write errors with BH_Write_EIO
Date: Sat,  1 Aug 2026 18:01:02 -0400
Message-ID: <7f988ec74b5d1135d5d67771240639e57ba9e0f4.1785621505.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785621505.git.coshi036@gmail.com>
References: <cover.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_end_buffer_io_sync() is the third completion handler in this
series that reports a failed write by clearing BH_Uptodate, and
jbd2_fc_wait_bufs() is the only thing that looks at the result.
Convert both.

They have to move in the same patch.  The handler lives in ext4 and
the wait in jbd2, but neither is used by anything else: the buffers
are ext4's fast commit blocks, submitted by ext4_fc_submit_bh() and
waited for by jbd2_fc_wait_bufs().  Converting one without the other
silently disables fast commit write error reporting.

Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/ext4/fast_commit.c | 2 +-
 fs/jbd2/journal.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 8e2259799614..8cd60c9f2272 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -213,7 +213,7 @@ static void ext4_end_buffer_io_sync(struct bio *bio)
 	} else {
 		ext4_debug("%s: Block %lld not up-to-date",
 			   __func__, bh->b_blocknr);
-		clear_buffer_uptodate(bh);
+		mark_buffer_write_io_error(bh);
 	}
 
 	unlock_buffer(bh);
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 9e4cb04587b4..ffe7a22e6699 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -890,7 +890,7 @@ int jbd2_fc_wait_bufs(journal_t *journal, int num_blks)
 		 * Update j_fc_off so jbd2_fc_release_bufs can release remain
 		 * buffer head.
 		 */
-		if (unlikely(!buffer_uptodate(bh))) {
+		if (unlikely(buffer_write_io_error(bh))) {
 			journal->j_fc_off = i + 1;
 			return -EIO;
 		}
-- 
2.43.0

