Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D787D480321
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 16:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035592; cv=none; b=lI4Wf4S2/4Wd2pUJDFSpG71SB6rGUcbIz0kJXl0Q+0KeB2KBbdwXmP7+qQdlV7/mF+2u0XoF5rb+iTQ0NBrt6Q/VuOn6khGfVG/gT+9meemXXE6bKxvkLdKzCUAWDX4raIG4wea5qS+UuvGitsJQdvC6RRVUpXMchnKNECRjif8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035592; c=relaxed/simple;
	bh=oJD4nFEyaXWgVqYToy/GNwtnNE2Mg2QHu3WCWAeSWAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txUQjKDmHp8/4Zg4nqVnsNKYKOsyiB7Blr1zCy9tbpYAt2uOOp9eKIL0EI8LUPz+veAGx9UtcGxqrTfYQpIgGNpHmG3QBQbHPlGej+eZiBmSHH6huVdtTrri25m3Uv7bSaXWDNr+qIH/7CNUcOO5FskiQL5nyUAuLtKODBV3aqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F4InoYPE; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F4InoYPE"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5bf94664327so1024612e0c.1
        for <linux-ext4@vger.kernel.org>; Thu, 06 Aug 2026 09:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035587; x=1786640387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i1O4+GTfBoV2V1bEoIh5L2jSUBNvl32w940uX7HvSIA=;
        b=F4InoYPEd7e4RlzP/rCzVMcbllbtFfDmi4H5AlZl4mehvdu9C6eLjw0+2rrfBHnw8k
         m/xCJRI93plaouBs7wlDC3LcUu3epffd9nlF5MBl+0Lgq/Yxu163lrMGKqBks2ONRENl
         rVWlq9pvvs63vIzhmUMVgK17woMEQrkTJGm14fIC6EXHS466O4AwDO3DdUnYnZIQeO1x
         9CRcfjVMBROY4ylwdaVX6a1w1qF3kr5ZNYgoFWHHKnH8dbaNAoaPEKAdllMysktMZ3lw
         ykXd6Kr+y9IaeKi3VfIa+FCCLmP9vIgcuct6iNuWNdBeO82L41MdbGq3wAYRNPKUeBRb
         QBYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035587; x=1786640387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i1O4+GTfBoV2V1bEoIh5L2jSUBNvl32w940uX7HvSIA=;
        b=IzfgwSTfWdfgqvMZ7/C7G5O7ZnRwB95LyEcleCrfhQZIKyuE34Ipb8V7Ia23YuIuAA
         KdADyYb6g+X9l36RhHA6iV7L9Yff+t11UCpiQx8gwSZve0eDAMDcZhhtampF/qyNbZDL
         kkkq6Lfn2TPA7tIqgeVYTP7jbaMrI5eskTg/zJMyXDfd0NSzhNm5+LAvugoAl3v3GYp6
         LyIh2Y5ZHItbCdATn8n8NjVeZr1ciyZU6g87/jMWLWyzDeZMVluzfSUr1rTfo4tJBm19
         Suhj2+0BPgwfwflqqdSAZGOxAwNNYLPdsStR/JUieICIbNQfWmPd8lHEtiZYxRzdqAs4
         ntIA==
X-Forwarded-Encrypted: i=1; AHgh+Rr/LcdK9T58Vqk05dZXWdHTcpJs4PNdiyLtgiQ+/J9iigSV5whbDRWiNGPm393Wk+c3no5p/poRg2F/@vger.kernel.org
X-Gm-Message-State: AOJu0YwFIIVR960mur76zOsf9pBP3bGWcUyK4d2vu7Bnmr3CL/M+msYe
	h/07sLLWNFnjQjYVmEbOQlwSnWRw+zWHLaSVHqbWK/CnUihpCp2B0Frr
X-Gm-Gg: AR+sD11kLefZlOxrHTRQ007zWCYP+iJLwesSJHNVjQmmovfclXRYR6pyD1QM1VJPg5r
	xxp8gxZebAtSVsBCMvG2h+9rdwPbSM7GLkHRzgfX0qBnrD+z1AyxHdFekxfCumV+CrmQHXkaFU4
	spO0ChUqnKf5CY3RyRXof9BYpwMwRggpXLeDTw2/I6WugroVuP/7H62Xe1Q3q/e/Cgkfzfe6BSy
	djS0QUFR6UI0BXkdXWRrt2s+qpQlUxnkc6Qhek7NzalfxnNlZ/hihaD4S53sqKeN329pils4ICW
	A5b8ztOIbJtfsLQDRJCde8/zI1Fx9ACq6/GYPJVBE0WjLEbpuGOBTdDz+GlOIIkfCKXwsIEiqRV
	v2zZCE43nAllK9SpGELAX5II1BHNvLJAIOcRI6Y+bH3RntzDn553L4lgVl9kF5wnEJDumSXOfcP
	yx46mrzIvY0NZgqKGgE44JqrcXRfUoGaU2oOY/JgqWvoo6VqslieuWEyfC9hX5iIXUZHVYTOPeH
	JUqJK0=
X-Received: by 2002:a05:6122:3a0c:b0:5c2:ac92:eb18 with SMTP id 71dfb90a1353d-5c3d919ab80mr2046889e0c.7.1786035586648;
        Thu, 06 Aug 2026 09:59:46 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:45 -0700 (PDT)
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
Subject: [PATCH v2 10/21] omfs: check for an inode write error with buffer_write_io_error()
Date: Thu,  6 Aug 2026 12:58:33 -0400
Message-ID: <b33ccb12c29ae743ccfa48cdf1e9140fbf2dabcc.1785951556.git.coshi036@gmail.com>
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

Acked-by: Weidong Zhu <weizhu@fiu.edu>
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

