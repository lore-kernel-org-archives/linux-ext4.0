Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2923547DD47
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 16:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035594; cv=none; b=sRtG//qDqmIMy3srxk67D6uq8kAolNx85SazzQuSCFd8PRrzNy3QamU9GfcNRTCNjpQdgpVATMX6WXvA1uXppB8+hIdDkdluI9z4IhdkzEDK8nedKrhDJ0e/dtBXaBMImYXQSXpf83H9azgeQACHly1q6yhPE93818fRk2Bcpuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035594; c=relaxed/simple;
	bh=3V2E2gAPInTwE0n7u+WtHxKrTSKd6q7DUDLR8AMb2Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPipGyXZj42g7pwtmtlH0y/+Y1SXKiBEwL1DGpvi3i/VC4NpPa7HmjvpkA/gErUDloC6I+60r4B2XLvddqZLIjFiEZ0Jk4oiNg9931idwnQxxamT61KVzz2afCD9+DiEPFd7WaouzVk4niTCxWuXPwN6MAivdtiWhqZOIqm8oEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TuaoA23D; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TuaoA23D"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5bfa6766cf6so1277492e0c.3
        for <linux-ext4@vger.kernel.org>; Thu, 06 Aug 2026 09:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035592; x=1786640392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V2GNnxLBSrWkOcqqCLfBVyKRdpTurr41NHkw8NmYzAw=;
        b=TuaoA23D0SdIAExb4Gehe+KsbZn2uo5RY+BP4Q0vGRgX2ExuLN67k9MgXIkX1r40DF
         l+yWKpUCpjw12MnLTpVkWD8dNuH/Q3vlfk/wIL4EfzRid43guZxQDEP+YZH+RPzoPX/0
         QPDLW40xqJaExMdwGlKGE4iCXAYD515+z9F3Xt/IO7wm/swnP3OcIh1j466KAgChJ9dq
         TXfOrTBav1JB+Zpr/FL0hM198idL7VRMhpHHNPQJoZQgWR5AoDdZ0FM6UHQ4vqm0dDjd
         sCzgQQdEneikW6jmq2UtuosRVwX293K1IYVfVGDvIarGLBMTdIpkXBzdouquMW/f35xS
         Qhiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035592; x=1786640392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=V2GNnxLBSrWkOcqqCLfBVyKRdpTurr41NHkw8NmYzAw=;
        b=aChTU98bt9HoclPRS/5YWBZz8svtd2Gc8TnXUBSiepeAsPYMQaEHwQRbMz4CLMNfk0
         3e0uDJKnb23yMaRBTON+3caSfednLTZmrXucV9Z029e6V3/lXrC8VfGt/3GfjwsQQbHh
         a1doGyUhFqIkyolLQmTh80ERCQtuhu94O5j4pBDglgb68L/2FQ2ib2YbfSKymG1D+d+k
         wbNuBSzDfJrZR0r7Ru1u6MqjI/5YnJdMtPhqBUzbFB19dTV9aSCN9NG9lfV7hhgUXfa2
         Lz/Dnvp/ZWg3c13sDodBeEgVKD5omgQi0qD3FPoQqk8QxeCLteWj8ChcXI83kqe4fsYJ
         mKFw==
X-Forwarded-Encrypted: i=1; AHgh+Rolq7PsT0StDoK5yxtkNT4ib2BWIIrvEP35QJzBkhX3Nd6IYprGZyW6kp6zQcbGBFhCLZijXPmtgAEN@vger.kernel.org
X-Gm-Message-State: AOJu0YxNTMZYdAoZdx+MgyXNjVVctu2Gjhs9Pb4QDtd1jLbU7FTCaPC6
	cPuReU8TRiipWvHI9GhEEqIPKBzbxWijtFgChO+ExPEDpFA5uWbErHYB
X-Gm-Gg: AR+sD13aLW0gfuu+1bS2abdazVVNMLRIbU3dJazYBrf3aRaCjPcCJctu5b2wGH7dRmJ
	rvYMu/g0fg0WSIU/cNJ8y3Bjfg+ytY5Gu6gS3ZXolAjXXMmvOMglIUvPpVfl6G4gtBpi9rQBNuk
	HkmfvJE7LQbHfCLbzMuNQK0QF3Oxa8t/Mha1XuDcF0aQSJisodHaOqgr+8DaGAxhp+1+0xEG9TF
	el+/6uOwwB0E74hVF3qxpbN4NbaiBLYuLd5ZwAwuUC4rWzhP9vx7HgJsQQpuFqcUNjefaNTs1E6
	/GCmzDYBwxrPuh1rIGudeVsWEYz28jBCmakgguXpZEu5uTJ53Z4Iz23gMI4J44Y9XlNcRK9sS9r
	f8Z+/gfeHWRh4+J058BYntZgteDSOmKg/RPX/QfqgwxtEG9Lix95yV3EJjOVO2HBS/uxg5evDic
	coq5xEtGFGe2NaO9J4ECxOHYindsNV+fXL9gjrbSCCCHaz9xfhv3nj89KLxZKVZ3gGgk50gruzd
	sFclhz+IiHKeFaACQ==
X-Received: by 2002:a05:6122:179f:b0:5c3:367c:c001 with SMTP id 71dfb90a1353d-5c3d923fa4bmr2401901e0c.12.1786035592033;
        Thu, 06 Aug 2026 09:59:52 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:51 -0700 (PDT)
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
	Zhang Yi <yi.zhang@huaweicloud.com>,
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
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>,
	Weidong Zhu <weizhu@fiu.edu>
Subject: [PATCH v2 12/21] fat: check for a metadata write error with buffer_write_io_error()
Date: Thu,  6 Aug 2026 12:58:35 -0400
Message-ID: <4b6019b5a48b83c8235918b084248983a57692e1.1785951556.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785951556.git.coshi036@gmail.com>
References: <cover.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fat_sync_bhs() waits for the writes it issued and then tests
!buffer_uptodate() to find the ones that failed.  That relies on the write
completion handler clearing BH_Uptodate on error, which this series
removes: a buffer whose write failed still holds the data the filesystem
asked to be written, so declaring it not up to date is wrong and makes
callers re-read it.

Test BH_Write_EIO, which is what the completion handler sets and what this
code actually wants to know.

No behaviour change today - a failed write sets BH_Write_EIO and clears
BH_Uptodate together.  It stops being a no-op at the end of the series,
where the new test is the one that still works.

Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/fat/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index be18f6b5819b..4a4cd0111e47 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -356,7 +356,7 @@ int fat_sync_bhs(struct buffer_head **bhs, int nr_bhs)
 
 	for (i = 0; i < nr_bhs; i++) {
 		wait_on_buffer(bhs[i]);
-		if (!err && !buffer_uptodate(bhs[i]))
+		if (!err && buffer_write_io_error(bhs[i]))
 			err = -EIO;
 	}
 	return err;
-- 
2.43.0

