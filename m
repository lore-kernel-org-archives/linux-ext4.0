Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FC847254D
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 16:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035572; cv=none; b=Pnjra+jFV9v0Q4mjqsfeWn6dG/je0PtuHitp7vRz/DX8Nl33IXDPSDF0XCCVcfQbOY/0ptUhsokblR7F3J4x94svi81hwTUqlkNGQNwB2xFWkH9tAC98lb8/hI/5PTrgrw6Qdz63oGqYcgpzuNdUfQAkDsZ9fPWYu4zZ1184fBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035572; c=relaxed/simple;
	bh=XCQvARYs03Jg6cCkHO2H308pJ7dd7LthVfdbsY3TGbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrjv7jsXMbK9zHS65qlgtTwSoP672hdP4LKqyTrMm08knp5XTuZLnW/PQ+v+KPjvlcLzNS+8Ixg7yLLnM3MzoL9kaC/jlxRu4pp0c3Xcnm9XqY0YrM1Zf8uK+x3Kc7olJbPTxez2zJu3Vug3fmN0Te+XwWGJL2AWL5TR1AaT694=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p3w7NRw3; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p3w7NRw3"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5c3163a88a1so677764e0c.3
        for <linux-ext4@vger.kernel.org>; Thu, 06 Aug 2026 09:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035570; x=1786640370; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W/UkvZ9btqQ9UcKZM3gfiOG/tPkCxSDzu5UxeQemPOo=;
        b=p3w7NRw3KIrR80GcScsOy40s/lALyhTKudwesZMfKknNR8x1gXe5vHuVU9hYF1ivv2
         602Siw/IvGzD55HABAY9E5VZdSrcuK9FRtmtf5zQn5vJIPR1ly4rUvKrjhQ4Ahp5wIqj
         j2gLgFQgAMDgCS7dwgC70Mua1Ykq8G3ffD/IyyMXXcDfkD91iYLNUdltKI2kDlX2Oy8S
         NB83SAxhmYB+KCu79bFrerlpRiN/gNyVoHYpub+SIX+s7wgVgnmF68y4lbGEs320s0yk
         AaAjsSOEbkWaOuDjYG9AsM6JUBT6L1kNvppiOafOzx8encGz0caVWk2TOT9W187BhzwJ
         xZxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035570; x=1786640370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=W/UkvZ9btqQ9UcKZM3gfiOG/tPkCxSDzu5UxeQemPOo=;
        b=UCChCtHQLCLvB6F3hjMEhxdUtd5sA+HtvxcojWcWefD+sWevavV9YRO3n3gMAjkAf7
         wI//tkO+wTji/LZBAFXquKWp848hG30h/9s/rTfrwzuns1quz9CH9TLaMZ4+f+0l1S0t
         8i7ixhmqh4F8HAPf6e55J8vY0KsdOUnl9pRDXK3gTiZsIufTOD/w0e9jUm/3zBA1ULad
         40cKR7iR5UdfefcyffApjt5s574y5YqGz3SfVGKWgbCYPDI2MTMlTznLu1eD5nqmzBZ0
         5UaVWrcmfQbsF60T+oAvJBxN8bddqzhraFW+AV5k+74rcTIzp/upl9eq50A11KwvCUTE
         8KZw==
X-Forwarded-Encrypted: i=1; AHgh+Rosy5/3RsG+PBoeDaBbY2fAwr5A/Kq1H1/7CWD6VkD+bz2ohHn0DGYU7t+t2umqnS9VvoMJ8F+ibqD7@vger.kernel.org
X-Gm-Message-State: AOJu0YyjqbEsI5Sv/+RilTgCiysTU1nYRpKXaavMXw2kpV0PN3q8nKQn
	tIpDQIUC1zftoPDalkv3cx4ghzu89dFwvXyzRIMuMMCn10+zi0crRhsf
X-Gm-Gg: AR+sD12IWXysVajLwY1pXT7a2pOMS1iJpVEoUHr7WDt+7evhQ2G3x97Z/VKC3ickCWR
	iwK3ws4b1IAI6Qefbfb1AuTbc+NTj7pwvmC/vHfLVUHg0zJn9E4n5aKaVfIhDBCGMHJ4x/Ce9sP
	ZFH2AUx5A7yU0cPtdVJFpiYWYbA04sOvAUhCmp7+fBDGuk37dkGkXRstLrwtMZCoqJZ7L7D8Q1h
	opvjlJieeRwmcvJZJPkAjQDVsuheKl/QiQaIfDNgLwksS5naP/K88A3oL0Y2I62N0ox1BsaDEa+
	2R8i1CZEX4zgHj6TiBrD5McVU0GYgN+EnE1jV2ilj0LA3VyPVHqd7jggnV4B02gADA1PE3GzDyq
	1Nlo7hk03UXQd451zKE5r5ta4EsUEKbY8kFZVltqQS/QuIiLgkor0MSQVsEgDNosDIF+U68xWyE
	0SHe9Yn6zuKhNQfFTxb0CQh1bDyiagOfeYYfIHClH/Rff6iYQ6hm5ex+tAQdCbpRm1ZQECFWUEH
	fXnn32dEphe038/cg==
X-Received: by 2002:a05:6122:e248:b0:5bf:9bd1:791 with SMTP id 71dfb90a1353d-5c3d912095cmr2047468e0c.1.1786035569648;
        Thu, 06 Aug 2026 09:59:29 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:29 -0700 (PDT)
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
Subject: [PATCH v2 08/21] adfs: check for a directory write error with buffer_write_io_error()
Date: Thu,  6 Aug 2026 12:58:31 -0400
Message-ID: <05cf8ad911ad7a6eb68f42e38f1eea39c38e246b.1785951556.git.coshi036@gmail.com>
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

Acked-by: Weidong Zhu <weizhu@fiu.edu>
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

