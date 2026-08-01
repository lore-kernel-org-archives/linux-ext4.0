Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC91238B122
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 22:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621683; cv=none; b=E5CxrN8HwVaZc1HgqrUuUc8MwzacSb4knS+2TV9ms+jzke3pd303Mdp3gSoVST0fzmdKI7rIgZL6l4tUAJwrQE+9WFnBF0RKwHkk7WtsbRrPBXTitEJ5ZUUxu8L7ptNZcwiJpauU9JtBTy+GjdtuWdTRdC/II/ZKOMc8rAml4Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621683; c=relaxed/simple;
	bh=rmASDDjzyu7ORP+REJJAPqpbg4Lkmrb9SobBQ2fdR4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNy69yMLpoyax5DTFGRNrsw5XJpAxjpLoVJ0o5iJsy7zEM9xYwfAjh+iQ80C2x2ZkBgRqMx/LQGzj4DYoMYL8TJ2JAZPJzCZf0WNXSnDz2NVAm4+gKKIPGy27bogOpt/9MuIyO/jGB5XlxlXiEimC6di9D66NaIWChov3HXF8kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZMnnxug9; arc=none smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZMnnxug9"
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-664c6304683so1983142d50.2
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 15:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621680; x=1786226480; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CmPK9JWvOViXyoDvMWnuptWNftqO/5jbHBuyoy5p9Iw=;
        b=ZMnnxug9XdWQ0aXvQSPCN2jWf+hw2NGNaI9rsERvZSxtiKGb4zMc+oFGf51JQt0eTo
         ngmYksGG9+iDAue1aGPDPVXT/bdWSYFaOsCl0F9aT06Q4M1tTiK+WrswQRDxYqSYxmKG
         uDq4Q93W0SVAB8dXdzOhKahfz5q5/HDeabMMVjWPrJeKwU8Pvq8ctmeDz5nQU5f3MpxS
         8rx0dnvWPfjc1b0j874DqBxATRVdprSV0tX3oNXEVkTinZLeC/hvKP+L3fdPq/EWLJhz
         Z6mmStYrX/1cmxkP+A3B2YudrR6I/nR0wKy07aHxBzn7OkqxqYi8Rb3ryVdAbEEXzaE+
         10gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621680; x=1786226480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CmPK9JWvOViXyoDvMWnuptWNftqO/5jbHBuyoy5p9Iw=;
        b=H2B6NKiskvjbySZQVzszFtuUNv3xdfSPMKTUBoPf8WfYAIn+iITgd4CvvjE2D4APmS
         dHf8XUA2QTqn9BJku6rsK31U9E2/zkz1kLf2lWKfzyxoFiV4HtlqABXmDI1WVXRauWq5
         3NwGNUr2yVV6PU/QDE0vylkOFktQZN6AgV8hji613YpHrP4WsCtjs43zWHvVQtEnwqd9
         ipXVZ4j/A6H/w3zYiuZOIszR32cWGF+y/6HvyqNE+yj2gpVQnQgVIP6ajJ3w/7+wglKE
         jIcw/NoyjeqeSqGw7N6l+ILLKbysmynGY6DXsMBdOgi6yhTTeLGq9CH2LWO5KvJJC1Bn
         LD9w==
X-Forwarded-Encrypted: i=1; AHgh+RpWXZwyh/5NWDP36/+lUJW9ovINmcgChENM0nAI8EzWP4oT5ARbhOitZxwkFMTv/bPG1uzeMSjIktND@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+4Hf3csBD41oHbF9fZclkSMZCvRY8HU8NlbyVDn9BpOXsBPK+
	NLYsMKGT+9iUIoJtm9LiIM/1Uimev3p3l5lm13pLniIvfQ51Nx0lUfJ/
X-Gm-Gg: AR+sD11NvRDcIJz4z5HCy/aAjEkgqAekv/YOa9Yl0ekErL4LUBPr7mlHxKnEB7hPazs
	Q71pEyzreG8XDflEXvWLqjbfDvWmZ4duqgLZBgZlvboP8Nm73bLyc8icR0FcsoavH0ZZjRR2Nx6
	pHXo097uYxiLLXNjEUsLn9zFu+ubUwb/Gwcgkv6O83HqYntfrqac1VwGvRJ3ik8lyYTdScva2SV
	JgYfYRAOt195gEYtYS58g/ZeRXxvWOEResAJNfsMBewcy8uWygDtEatXOQ/nvyj1ZRSf/sDrWnC
	FKwDsy3s1HEYiS+JKqfuSSfZ3t2ML/ijZv4jgpISxZKPO75mhY/m/EFJLtZLt2U6jfJAlOagByh
	4nyasntj16OBg2/88tXprREejhTd6fl81+SAhgaLneHUcNvlLORsBxlZIvFSbv+NxKfwp2ILfgJ
	J7xI8duoQijODqpjbhdOZlaxQ/HwmsJYpUkP0dKHr60sw2AaFCWZHgUxI7wz8SxDPhmIFEIvWoi
	fNrfUg=
X-Received: by 2002:a05:690c:dcb:b0:81e:d009:1956 with SMTP id 00721157ae682-81fd4a21566mr79336867b3.12.1785621679620;
        Sat, 01 Aug 2026 15:01:19 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:19 -0700 (PDT)
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
Subject: [PATCH 07/19] adfs: check for a directory write error with buffer_write_io_error()
Date: Sat,  1 Aug 2026 18:00:51 -0400
Message-ID: <b688ce1ef8805684f8c529b8934406ddf6e34da5.1785621505.git.coshi036@gmail.com>
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

adfs_dir_sync() spots a failed write by testing BH_Req together with
!BH_Uptodate.  That relies on the write completion handler clearing
BH_Uptodate on error, which this series removes: a buffer whose write
failed still holds the data the filesystem asked to be written, so
declaring it not up to date is wrong and makes callers re-read it.

BH_Write_EIO says exactly what this code wants to know, and it implies
BH_Req, so the pair collapses into one test.

No behaviour change today - a failed write sets BH_Write_EIO and clears
BH_Uptodate together.  It stops being a no-op at the end of the series,
where the new test is the one that still works.

Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/adfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/adfs/dir.c b/fs/adfs/dir.c
index 11afa9e157aa..b8cc6a697a05 100644
--- a/fs/adfs/dir.c
+++ b/fs/adfs/dir.c
@@ -191,7 +191,7 @@ static int adfs_dir_sync(struct adfs_dir *dir)
 	for (i = dir->nr_buffers - 1; i >= 0; i--) {
 		struct buffer_head *bh = dir->bhs[i];
 		sync_dirty_buffer(bh);
-		if (buffer_req(bh) && !buffer_uptodate(bh))
+		if (buffer_write_io_error(bh))
 			err = -EIO;
 	}
 
-- 
2.43.0

