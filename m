Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2537139FCDC
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 22:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621685; cv=none; b=fg2UQvRV3SvidvnUE4h9sG06sAtr2Uygh4dYqi9bVfJ5QsSGQblDczAk1XG2CgcWdG3AncqtQqDVq3votsBH6e0Asl/97R5sN7ucDYA/vooUN/qV+2U+mc+3ggCS0oI+dTI4eJsRSaKmH6y5m256ZLaPLefJDB4YH2ON7Z6AWLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621685; c=relaxed/simple;
	bh=k+XwpsvdR4lXnK8J7akvyHhiQeX6iOLIGH6lriW/zZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UuvpHRJZOkwAHWVYv6d7N/Ufuq/IAVcBcmlF4hRl8vRDnjrMl6jYeeeAnWy2fgYhX99Hh8cBAUwn5AhKZhMvxMbaQ+JIb3rjVFx4h76QBRjWH/FWV8vB4qwslrMqTdsQIcDgUiYKchhiNxSrEJ6ZUM66ZybpFLPBgI0rxfoog7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LjF6511M; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LjF6511M"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-81e9f7491ffso34126587b3.0
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 15:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621682; x=1786226482; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qR4j1ND7sU3DHEeB5SkE24JFiOq+gxamuNrGyu3FS3k=;
        b=LjF6511MD8nyx8OgsBaCVjrtAId5xfEyV9Mla+K1MgBFkCXjSOtDDh4FrzzGiIgCYG
         rg6ez4+UbzKcMgRNqTBV/vSr4vBOxenfTN7yvq377FOV49TEgxtoWpoyyCg6Nf9yWtOq
         yxhLAAE12uLnCLsNx6OFA9wIczk1fHp9PmTSOL8655l3xvJLKk9dqQO5YL9yeUGiI5r4
         vFigq4zGJeymgJTrqEPeR6GUNaT8iTHSE5d7p3hBn1FCH8Fn821F4fD511QmILnQZfaR
         VEsI+Hjmibx7q+C6zbLrWdlm0gmRBoiz6r+K9Y8cA03955hqcrDcJJXROOFxlWZ5tpAi
         aNHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621682; x=1786226482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qR4j1ND7sU3DHEeB5SkE24JFiOq+gxamuNrGyu3FS3k=;
        b=ig3YrZTjuPbkcK9ELTjnGRm7TgMtjyFVTqrb/T7kXDfUSQjftrJW1pmJ0Zge1mChZG
         c3PgJhR9JMsH/Io/TFak0ENwj85X+c40rJSD0iM9z2L1+UvWQnApBGDUHBvF2tABrUYN
         ETE3TzoxnfaDoLgIDVXNoOEibdf3S+YrXT+bKld3ge5ZcYMLC53FQkebci7UE0NASw5O
         3aDnTi1U0pdUaeILOhy79eADz6njoxmzjNWaRW8kDPt/wcSNZk+4JQD9/n/6XHIGyrgO
         SvGLLtUQTkekStOR3CYTURoCFNFZB7TS8D+lXvPB4KU9DiIU5JLtp7Kzo/nyIWVrqqC1
         vL5Q==
X-Forwarded-Encrypted: i=1; AHgh+Rp4OBmMkxhhZTr8qM40cJCioimU47n4JCUVGZO1+4mbOD/21RTD+N7E02SLnqbEUyU1wYhvbOrAa80V@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4CCwsmi2QA7kRUL/YmYkfZbqfxIxkQ1zVzK/llVDhbo03Lw9S
	ZUOfjgGxaeWxdwowtmprDRUCgdxtOE6cokkD6OcCHBtX/8WogTkkA7pS
X-Gm-Gg: AR+sD13YSOmT9nOw5P/Kmf7aV3EW+z6jZ/zdXsGpvFXMtD11G3VDzNRAZnVi5KU3bUV
	+M49D/y/dUfuyYLpI9KR0kFjpJ4YfWcW/xE71dw8+5qqaG9fkf/eakUBIlLVzldT6PXu64IbhNm
	Vm17pkroN0sOfWAbP8w8Phum0nUJvz9MufdFNNlOBN4jqRK6s+keA+CVcm/aTiS/zkP86A01vHO
	MSwrlk80eE7ZTe4nJnF/kQCkSjXQeJUVL7S2B/621QoKYd7RQGhLFQW+pvxCV1FnJ4rzzdkTEX0
	MX3c8Q2GC+nO7FbpOV8jomdmJtKa4gjRblY69M4/SNwWkEAAstCUdNDKRluBGSSK0X4X4nNbxCC
	RhuXLTPOlkanPrjzi0BBqUSfFXZdYEJlYDC9SW2pdJSGLHgp+FYzEvIjX0oyo0hgSXRy2NQD2Mt
	i3R2+PW97Zp/03A72wSIEsveKuKQVTd5a9zFqlTDk/YzovqxXA6B/GA066rWVdUirk4p01YjhMj
	7ssIFV0
X-Received: by 2002:a05:690c:6d07:b0:81f:27f8:2de4 with SMTP id 00721157ae682-81fd4a04799mr74061547b3.8.1785621681823;
        Sat, 01 Aug 2026 15:01:21 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:21 -0700 (PDT)
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
Subject: [PATCH 09/19] omfs: check for an inode write error with buffer_write_io_error()
Date: Sat,  1 Aug 2026 18:00:53 -0400
Message-ID: <e7e644120766bc3e7ea9598754f7b56000da42c6.1785621505.git.coshi036@gmail.com>
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

__omfs_write_inode() spots a failed synchronous write, on both the primary
block and each mirror, by testing BH_Req together with !BH_Uptodate.  That
relies on the write completion handler clearing BH_Uptodate on error, which
this series removes: a buffer whose write failed still holds the data the
filesystem asked to be written, so declaring it not up to date is wrong and
makes callers re-read it.

BH_Write_EIO says exactly what this code wants to know, and it implies
BH_Req, so each pair collapses into one test.

No behaviour change today - a failed write sets BH_Write_EIO and clears
BH_Uptodate together.  It stops being a no-op at the end of the series,
where the new test is the one that still works.

Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/omfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index 1d915ef72119..bc37029a4afb 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -145,7 +145,7 @@ static int __omfs_write_inode(struct inode *inode, int wait)
 	mark_buffer_dirty(bh);
 	if (wait) {
 		sync_dirty_buffer(bh);
-		if (buffer_req(bh) && !buffer_uptodate(bh))
+		if (buffer_write_io_error(bh))
 			sync_failed = 1;
 	}
 
@@ -159,7 +159,7 @@ static int __omfs_write_inode(struct inode *inode, int wait)
 		mark_buffer_dirty(bh2);
 		if (wait) {
 			sync_dirty_buffer(bh2);
-			if (buffer_req(bh2) && !buffer_uptodate(bh2))
+			if (buffer_write_io_error(bh2))
 				sync_failed = 1;
 		}
 		brelse(bh2);
-- 
2.43.0

