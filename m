Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85221433BD9
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 16:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035581; cv=none; b=fF6tC0YgEEGy/5Ww62CpHRkRwvsOOsgwtLzGNzKav6qjc8RKxh8W9SZSccgYNHRpdMVw0pepw/jyCTwraBzGpq3VWnraHDCTsE4lAXnpHqrbpBvmzk84S2wl3tcGDApiUwzzRZKl/iJt++8jIccoPutqusSW3tctBxRU0DdiA7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035581; c=relaxed/simple;
	bh=tpriWxWOl+J6JwWfTTr6TdF9jz0JsOXJvxWyKOuU9Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FalOqfn/YKaIvwdPDxlY7XJfsx1Hpu1dJEcJFOtqi1/aKuDwGpOj01k3dOAAJDGUQPBihJ3qZmeSxyO4GUTnG+VkekM/mn52Gs38reVfKqyW3D80B9pTv3g6AJqef7SpxPatwfsj5QVZFnRp19fvzjtyJY4W+YWLBhXP5rMWsA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bo0d+42b; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bo0d+42b"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-5bfc5b77c02so1791980e0c.0
        for <linux-ext4@vger.kernel.org>; Thu, 06 Aug 2026 09:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035579; x=1786640379; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=duwKRHlWbKUb/BOL4rfzAJNO2P4dXrVaNM+8BQLZ4gY=;
        b=bo0d+42bvRuWcxvl9oRfa245IM6mXsp/UqtsZ81UG6HCbTeG1P+89qWhMg8tJj/TtC
         I2TEUZCbYsLqS/GjLCMj92lPj2KygZ+5Y5YGbsLsKmEqHGMQxRL8vkOYyPOronlXlGkk
         l3ZKvlAgM8OuXeMl3nxvjLosaZ00O6z7tkbSRPMkr7t0jhMVXfot1TXvK9W3RujchWgN
         i13gt9oN58lUIbPpUI2yLkX5chiNtH6AQOHtXPXSmw3KaGjNy5S3ICbPlSC731OCsTwb
         DGGIWgjIHseapbdUvrjtrpH5Gu9gNUSmiI9YqVOlazDSLSF8anKVNDTHLkKgu8hBZUnt
         WUaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035579; x=1786640379;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=duwKRHlWbKUb/BOL4rfzAJNO2P4dXrVaNM+8BQLZ4gY=;
        b=pmOmpxJpnTgRXXXiLJMsRcMYd9zzGgGGhYHUiTHIo+LS0cWzmwWWH6ZvOK6Tc9pMbU
         L+bkyffkNAm0vWLqfnNOkRYJQP7+X06KN5ymdMiorbWg/++18+yf6zTItc5k1VnoM/zz
         hmIwWXuEqUrYeqqREZwNsw7OhBg6d/NWSxM0uB2mFfiG2IVUoO/CksCNyumD64DEUe8h
         wZfQCcVz4Ecij774k7JWpos+xB3KQ/DfnmLAfkplUEzX0YyNQB2woYAQs9bvmNU9U53S
         cFiPV0IuImEgfWZdwLQah/GT/V8FHuxnOsxXIVGJ1wPzWVdBQXb3xqx+5ignsj5QVvoJ
         ySXw==
X-Forwarded-Encrypted: i=1; AHgh+Rq97TzNVTUHR5ezwBmNXbPXtZAKggxt+RdCxwOHsXFP2cTst5/oFj0GFpMNT5YNnhU/1y5IND7f0a5l@vger.kernel.org
X-Gm-Message-State: AOJu0YzL+KuLqOYjICtmKm9kQ8olh1kRjBWOvgs8tpXKHV1Dku6EwZcN
	iuXb5WJRNCfbjEeV98mtSvo6w6FogSos1wOZhRaj83ZPYfzUAQaAoczb
X-Gm-Gg: AR+sD12pyjfrIPJiXh5tjVrINepv3/GUbvkVRwCOn2ZKfNZ5AxodXlh/ucuAACfV0cO
	EVkhIn9zPeTclfYHoOBq7KWBWQOvOzasYXocc1RjHjgzsufP+RpwnYRAKiVukJEjuKH5Y2Qhbr4
	Qo4uAtXIs+M2LsSUGex0x96HnyXNtyQvlrudKKo5beuuyTK1oZoVbIVQH79jllF/MvYpkllBkD9
	drpaOs3PBzq4OnVxiyOBf2UuFnwpJlk8cQC2wxIY1IeraxPoD5qqQWsbCBaKhR0zRdb/yd02WyW
	UhY+3MWk3RTSgZ9MmDee6pgTXprs43GRVv/O30PrsZrdjLbPYC+CMU0Q8hdqGPOL6lSvso+FRIf
	zkCDHdb4EhUJfkHbjmPtfS3uPEizTElud8d1KJDoSSFUePJEQ8dScBPnYsFBq2qg3hyLfG9PtPV
	TmHRSDsqUwFqGfDn8RkTAlVJLU1g9ONXz36h+necEjywjagfmhdWNBUch7m6yrTbJfmeieuZEOy
	3s61nPsy+G3Fu/K2Q==
X-Received: by 2002:a05:6122:3d0e:b0:5bd:b27c:bace with SMTP id 71dfb90a1353d-5c3d926476emr2526056e0c.14.1786035579340;
        Thu, 06 Aug 2026 09:59:39 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:38 -0700 (PDT)
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
Subject: [PATCH v2 09/21] ext2: check for an xattr block write error with buffer_write_io_error()
Date: Thu,  6 Aug 2026 12:58:32 -0400
Message-ID: <fcc530fffd0f1e18e8cd1a3974bc0ccc5b4c4b66.1785951556.git.coshi036@gmail.com>
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

ext2_xattr_set2() spots a failed synchronous write by testing BH_Req
together with !BH_Uptodate.  That relies on the write completion handler
clearing BH_Uptodate on error, which this series removes: a buffer whose
write failed still holds the data the filesystem asked to be written, so
declaring it not up to date is wrong and makes callers re-read it.

BH_Write_EIO says exactly what this code wants to know, and it implies
BH_Req, so the pair collapses into one test.

No behaviour change today - a failed write sets BH_Write_EIO and clears
BH_Uptodate together.  It stops being a no-op at the end of the series,
where the new test is the one that still works.

Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index be63f89402a3..39005ec23fe5 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -769,7 +769,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 		if (IS_SYNC(inode)) {
 			sync_dirty_buffer(new_bh);
 			error = -EIO;
-			if (buffer_req(new_bh) && !buffer_uptodate(new_bh))
+			if (buffer_write_io_error(new_bh))
 				goto cleanup;
 		}
 	}
-- 
2.43.0

