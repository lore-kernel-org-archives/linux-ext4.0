Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087B644E043
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 16:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035557; cv=none; b=I4zNeMx1YIlxNfB1gvmjhcIvvi3qkq0GIGq2fpKqH1aFni6RxVImkay+chdHp0EIqDbZP8AbruPTC9jq0ZgYIL4Qe9O+oHCWCwq2c5c4908FKGIYTTE3vZwzY4yMWFMywRbo78eZcs+t6eb7lZD1QR27ceR6jDLEgOiY8DnuKuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035557; c=relaxed/simple;
	bh=5Z1GSiO2bc0sbRA3/0yuB6INnEL0uS+pxP2xPMYMvWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IY8BavD4GrHOSLb2N6D0284JYwGCdsHpJNC0D4Im+NbSEKZwAPn70v5VsFArWj0wY+6os2lxOPYC1aXjSGw9oZZKQLJH2j4T5mFz+CWgcQ1zhCyz+dBQDjykEcUTaUPsQSz9a6Fd9zgspA/2aBOeeIigx9U7QyIuEmkq5TKLUcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qk37Wmp/; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qk37Wmp/"
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5c2c46a428eso1703666e0c.2
        for <linux-ext4@vger.kernel.org>; Thu, 06 Aug 2026 09:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035554; x=1786640354; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ft6ziQssPBfawpI3vOIh0QGxtSEYHeudqaZ7dvpKRmU=;
        b=qk37Wmp/CtD/1kafq+OBtkVnhWi4T9bibGAL69z78ETPBUq2jUUdtCmYmR9EGWeIkV
         QA7wAo8NWiYw+DjG+w6Fc3StZRMLlswI6mjhyr1Z586dr69ff56iqFH7+BcHrVDNNQ9l
         9OohvovEjMUDchjHqe+AIAQYrpGE2LVban+ffN/loaZ/82ZrvyClcLer5BFWkbgZO5u6
         aeJENLErJTWzQpFbkUqWi7zZnacELJv6m/hc3UMcivc6n/WGLLkhBjZS4pssx0lwakkK
         hxjc1/QOl0yuqP+BeB68Fa6JeN1PL8XuhfQ1aR7/dGLcdpG1C2sLjBu/IsBGiJlcOcTl
         YmeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035554; x=1786640354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ft6ziQssPBfawpI3vOIh0QGxtSEYHeudqaZ7dvpKRmU=;
        b=BglZpy+xHkpbpgy95naGJ1I4oy6FP9jJsjDE/lJneDMbyK2YW8BSLSuEieZO06HfrJ
         DnoGxsLCW9za+7OQc+pddCju2OsFX1Pk/9qX5wsRKpjnZWWftP2/HDuJr2tobeny2/FE
         n7v5a77BNqtQonnka/AwaMKfAUcs9UIVyFsccuudbB5uG3RoW0GqG53khdtjBqezhkcz
         LTh2i8lrBirlPf09gaqAJmHdrMhrO7JTlvyccwFKTWWi6QbOaZWVL1MudpcxfNjc+zKX
         Q/KSuCyZKPauVYpZJ4oq+rrDYSZzXdFBAxQRQSoOHr7ROxwHKgEkRQNTdUrAlOr0GC7g
         0HxA==
X-Forwarded-Encrypted: i=1; AHgh+RpdyV2OXGqIrmsMlVln4LwW+j9JQAh8qX3ShPyd6hxuhbNdnZJyeM62vHMEPugF/xeMvdP3PkI3yBFw@vger.kernel.org
X-Gm-Message-State: AOJu0YxA/hTjqO2xiTPk8okcolb32n5JOaPL6KaUrwce3fY5CPnc4JIi
	AcLqAIbp0bxpkX5dSNWeBm09o8aogNWUvmd1Av53Zst4+kwZNJExBmrq
X-Gm-Gg: AR+sD11vfgrsQBGsz294GmEFKLpFfDpyobUph6650FqXdGzaxZ+Idz5OUioXxu/j3bn
	EZCWataFXTq5eI3tCqEapnejSazk0H3bMlJ7ZjAESP9m3t/Tehh8nakO0qWpqeYGF6L9+XP/CJO
	WrztjLt1iIDuvSdt5+ZOoctnm5BbGtjdcdamFtT+It4rcFFbkgmzw8cjUIt8wpF2A9UE1bPXnve
	P5Ban/lX1nLyfgrT+QfUPrDfIRhTduy4BPoXj2zvcechm5kS3BftubZyS1zkjHE2GJanN/P9DuI
	o2zXn8OxayjpSsz/T0jIs/4co9/YhUsO8/V+TTno8qRi9YkDCJt0EnrG3I4D1lnKjZG0u+rVaSx
	ZVRX17DZ2Ro13C+BTOSans1JRLfvl1dsUeNZEz6FUjwvQQRTnBTd7sYO/9iwDdsurJgYrae2pBI
	Yj0Nt0wiFSOEYv+zG9xMi8TovslUyZ2U5Y1eUvzezQWi2tZ4jIDo7T6ra4LOsow8/Kc/GKnyLgL
	XNMMtk=
X-Received: by 2002:a05:6122:1c85:b0:5bd:8c84:59aa with SMTP id 71dfb90a1353d-5c3d9162e78mr2479549e0c.8.1786035553890;
        Thu, 06 Aug 2026 09:59:13 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:13 -0700 (PDT)
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
Subject: [PATCH v2 05/21] buffer: clear BH_Write_EIO when a buffer is forgotten
Date: Thu,  6 Aug 2026 12:58:28 -0400
Message-ID: <ebe0b4f179ccdac7a9400fe2611623ce218c8d87.1785951556.git.coshi036@gmail.com>
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

BH_Write_EIO records that the last write of this buffer failed.  It is
cleared when the buffer is written again, but a filesystem freeing a
metadata block never writes it again.  It calls bforget() and hands the
block back to the allocator, so the flag outlives the block it refers to.

That does not matter much today, because the write error is also recorded
by clearing BH_Uptodate and the buffer is discarded soon after.  It starts
to matter in the rest of this series, which stops clearing BH_Uptodate on
write error and makes BH_Write_EIO the way a failed metadata write is
reported.

bforget() is where a filesystem says it no longer cares about this
buffer's contents, so clear the error there alongside the dirty flag.

Suggested-by: Jan Kara <jack@suse.cz>
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index 2851830995d8..381690479520 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1091,6 +1091,7 @@ EXPORT_SYMBOL(__brelse);
 void __bforget(struct buffer_head *bh)
 {
 	clear_buffer_dirty(bh);
+	clear_buffer_write_io_error(bh);
 	remove_assoc_queue(bh);
 	__brelse(bh);
 }
-- 
2.43.0

