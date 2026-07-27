Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3330F429CF1
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187476; cv=none; b=G8R9eN5gpdBIWLd9OVm44MgDz+GosSxC325EkMGXkcGgaOnPjWyynQGLTcCuraf0JZJy2fO0vyBIuYeacxZjjhVpFhln95+0QkqtL29+U5ukZD3kDw1oQXDmLyDMOb3MFGQT/7+wdR+f7TCp6UjNwbP7uoNeKZEEDxXX5rTEpJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187476; c=relaxed/simple;
	bh=gRVbFpxn5kG8aCnSm5vf7ltvO3Q5lHYy12p0O96RkME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FURLa9yNJwSixcEe1lhBBwY3UWkae8hC+IxsXXw7SAO39RWSTod/5bKU+NdfPyS7mneXezrH0BmT4QxHVsnfDb5I0RVmaXBKtvdNBctQOEBaxYCviT9lekwVVBXqQ+Jw+pYq2iS/zpHhnXSBZApGkOXNqgj51Pc1hvqJW9gmfHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Od+dhuU5; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Od+dhuU5"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-848d21bbaffso3278691b3a.0
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187474; x=1785792274; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gBTzrcmdmtkEpiXXJ0sz+z/YX24zqKRtOQsTmMKXrM8=;
        b=Od+dhuU564vbnO3QNU6uIGWUPMGvbtn5ZI5aDrln1FwVYF43kPRNgGz0fRbPzSYPaA
         PN72Cnh7435CguPY/IwwKE/xMhIlSHhotP6H6m98oDzBFi9iZXCBlbWqfLZdOCus+cjm
         PSllfoxWgtUo6Rn+PDxkkwfKrNsrGGdK+I28GtLclnCYSKUlanFYFx0OTyG3JOxu622c
         DxOUDywHJwUszL0ZHWd8mCEE+HtX5JH7aUmzOizSE0NPdZWs7cjVIeDOVgXqgu5MP3Sd
         6t3J3EDYyCdJ69o0jISxmWXdZ4quVjDP7pTuuUhxfFWRoP4S4zpHs+sRNDZb80wD0QkQ
         XIvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187474; x=1785792274;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gBTzrcmdmtkEpiXXJ0sz+z/YX24zqKRtOQsTmMKXrM8=;
        b=HCdd8Xay1xM0tDqS2ty4b8GEyPdYQkj4cPUvon+6uIIMxhSPjjiQZ+iU5g4h6oXctm
         Kbdv9c4I4tWChv1i4ddhVJQjjnGRniYdKPFwqpnAMOrRCPzbdLIvEq28/XeLSTZ9jNKH
         y+OLoxny5AFaNUPuZleq0PEoJxeo44LL3K5drTgEoGBGhfFk9pQ6cBsd84gMpsde8eAR
         +hFoqkNzQ4aYLcy+m9IiuUnjj5d64POCo1aPP4seV2lY5HngHs7YncW9IElFTyOXLNgt
         2vHTuYVtNAoo1DLxRRfT3wUW1hhtObhry5gPcnQjnUeaUeEgvpzXS2vfMSoe/aZ67BbZ
         f8kQ==
X-Forwarded-Encrypted: i=1; AHgh+RpMidDLJ6WEXWU8/LXUO9Goqu+ET4K7exS303Sdb3gi0eHcpb6sr/hM4QJj4s3sH+JQdJs+3mdFKC5u@vger.kernel.org
X-Gm-Message-State: AOJu0YySFYKNWdS3T01XiSPcdw7P1jFxcU7JhoK7Ghv+2OS1xm8/SmsP
	xPbcRFaST03eQ5g/+AqPbNL4Mhhi+DMfkp7Mw7ZlPYnH2IM17J/1joVu
X-Gm-Gg: AR+sD11etwiUZdjK3TaxPQOGe+nmmawGCLm4g0t5MKFJJ4xW0pXhu+C1ZQKlEfiF90B
	6PNKlBPFBQkpPcd1OENA3IreYolmps9tJOradRPSF1Yh+mQOmgq8gFDWF0o/q9LB/qxvE7Vsx4K
	Ad7AQkvZBxzMRFUzbJqdP936yvd+MoIKJHKh78Jfy+AOS+U4yy5zq8deIiUmuRLwKTExadX5Zfm
	vIvAtuKdaf/kinJybplTNKAypc0JjwYFKRvC8akzOZ+J/wiAopO540VbtC+QrX11aUJeODP5NaX
	7+GxxBX1KOg9ekRoWxMi6lZF1rIi8BWp/6L0XiQQDXUrOKUUMJfGnmY5gCcxEHhPPV8XmdDybul
	/pnfBfHPXV/x2dE0gJqJnhsXqU/rl+gAedsmiHzLFjE2+UNvPeUMw1JmmFrKnJChVF7l3GpGiLL
	NoegYB0h2Pq2e7F+7xEee/Caqy0L/wqyyhej2WVLPKc7mFCltFLGAdfFW3Q4Nj1u7B
X-Received: by 2002:a05:6a00:99e:b0:848:2f84:736 with SMTP id d2e1a72fcca58-84e8d1234cfmr929145b3a.73.1785187474644;
        Mon, 27 Jul 2026 14:24:34 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:51::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e5327f116sm3537052b3a.16.2026.07.27.14.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:34 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	tytso@mit.edu,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 04/21] iomap: add ->iomap_next()
Date: Mon, 27 Jul 2026 14:17:41 -0700
Message-ID: <20260727211758.1116539-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260727211758.1116539-1-joannelkoong@gmail.com>
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Have one ->iomap_next() callback instead of ->iomap_begin() and
->iomap_end(). ->iomap_next() finishes the previous mapping if needed,
and produces the next mapping.

Collapsing to a single callback lets a performance-critical caller
inline its iteration loop and pass its ->iomap_next() function as a
compile-time constant, so the compiler can devirtualize that callback
into a direct call instead of an indirect call through a function
pointer.

iomap_iter() uses ->iomap_next() when the filesystem provides that
callback and otherwise falls back to the ->iomap_begin()/->iomap_end()
path, so filesystems can be converted one at a time.

Suggested-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/iomap/iter.c       | 8 ++++++--
 include/linux/iomap.h | 9 +++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index 66ccb87441ab..e05574602946 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -107,8 +107,12 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 
 	trace_iomap_iter(iter, ops, _RET_IP_);
 
-	ret = iomap_iter_next(iter, &iter->iomap, &iter->srcmap,
-			ops->iomap_begin, ops->iomap_end);
+	if (ops->iomap_next)
+		ret = ops->iomap_next(iter, &iter->iomap, &iter->srcmap);
+	else
+		ret = iomap_iter_next(iter, &iter->iomap, &iter->srcmap,
+				ops->iomap_begin, ops->iomap_end);
+
 	iter->status = 0;
 	if (ret > 0)
 		iomap_iter_done(iter);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 80832edc7ec2..d203d9fe0f89 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -231,9 +231,18 @@ typedef int (*iomap_iter_begin_fn)(struct inode *inode, loff_t pos,
 typedef int (*iomap_iter_end_fn)(struct inode *inode, loff_t pos, loff_t length,
 		ssize_t written, unsigned flags, struct iomap *iomap);
 
+/*
+ * Produce the next mapping (finishing the previous one if needed).
+ * Return 1 to continue iterating, 0 if the range is fully consumed, or a
+ * negative error on failure.
+ */
+typedef int (*iomap_iter_next_fn)(const struct iomap_iter *iter,
+		struct iomap *iomap, struct iomap *srcmap);
+
 struct iomap_ops {
 	iomap_iter_begin_fn iomap_begin;
 	iomap_iter_end_fn iomap_end;
+	iomap_iter_next_fn iomap_next;
 };
 
 /**
-- 
2.52.0

