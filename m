Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1182A353A98
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 22:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621671; cv=none; b=fw3pN5g64mPFluEFgOwe12ypHXEgmff43uPpjIFJleRaNyfRcpzgZG1cmaIjYvjFpSQ6mVBy0oB35KQGuIt1UeMf9nC6wsTpFJJuAs65HuRuDz1qK/j3ozhBvyo2NJSx3kDSt9xYy+Uvgl0QjEkJF4s1CV8e0k+rw9ju84JcKKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621671; c=relaxed/simple;
	bh=fQPgfXMhlq+1VG0MRuQEzdSC7q5vWTQFKVnCNqnuFvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sur+xfrFKYP0Mm0zrmuXXDZ/A/t7QjXa8GvTbgk0YO63BgvIgo5Z90NBz1qx3afv0/lX2JuBai6D/FgVi5QB+WGIgwaWpmWTSZ7qGOuduE0YzIYcgMZdKhi6yEZ3JnX4QDxsjXHOxkCeZTJ/Jtn7LylGmCxYjp/uSEIJM1mpYeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QOCmht6G; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QOCmht6G"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-81e9d8f3289so31561627b3.1
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 15:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621669; x=1786226469; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=boTJ4NLnnkEUxDYA6Ii16la58dxC2XdEwOIDbV8GTAs=;
        b=QOCmht6GN+gIAff33a6iQXQu2gFFYkEh8ROR8X66nLwsVhM3eANiFUbiKvLCjtanHB
         M73eFpJ9SDjG5EhyDZ5NO8AVXtN7Vt0gyCaJKXwagSHdPgzz1yYsHdP55rp7UUl6sgDo
         l4MfUcdMURX4bSTzSsDRAATt3Kwcpj2L/nQF2z3/2DWgoFRLXVo/p1sbbC6JPP6+/NBx
         CwVjbRWHr5/4OuA9Q6Ujbvy8j8uqW/boI9L+AHOzYqhrjWaJD8o6VHcYliDXSlYUGel9
         5ouLtzhFQbzmbFtf4GF/oB6EImRtHPDX0bW6VA3En5HY16AinGjUcHp1KI933r4Q+SuY
         v8gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621669; x=1786226469;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=boTJ4NLnnkEUxDYA6Ii16la58dxC2XdEwOIDbV8GTAs=;
        b=q9kJE87WLrtVdGUmvOYTKNkqLsEp5R6Cyg3TmvIwZFScgUXrhmxsNr53E3FHbUFMZF
         ilEg+RmZww8G/D7zGK4i4YWAQxJrgP7d7f/UbZ9A4s4J+Jw0Lcw7XGP7fMbEy7CCknGX
         CKPqzO2oD6GRDqXW01e+xNcxMDZZDYS5/16JH8auc+52S68nRDxDNQjEPBZG+e/xV1KR
         5WD+DfPPNoQDyTZRmt6tHXxkHxhxU2hQnbjiqYR3fsz6nGGnpHTLer9hyjKaFHdBAkBO
         al3Iks+QNmcsuJb6Ah6VC6OfNy9HvZvk6RukxG1njGiXN9GUFQ5kfIZUPEMLLw12J1gs
         vcjw==
X-Forwarded-Encrypted: i=1; AHgh+RrAy3FFLgLTCFH+22YsP77OsNS8S2ck1zhtuRZT7XQnKUyfuybjzb6S3V/uARLzjXsZf1u0IP+Hx+gH@vger.kernel.org
X-Gm-Message-State: AOJu0Yzqc1tadNCJqeuAma9Zus3Gl2tKCOZcgkITaVkQWKgF9cr2YhYS
	f+znX5nd04e8ImIfRguHc5VcrST/NxwDSHUgjOqermzqFeoQ2Ega18pM
X-Gm-Gg: AR+sD11wJvudx16fN8tnXPTFNQe7mH5IQEVnGJvwLh0BdZ6xyv5C0pA5mNN4XDn9iHJ
	VnYqEHteMTsFX8Q6wcyE3BQUyRLs7ToRlVeSdvxwNsSiX4GHADeG8MB+r54yAdERA95SL4ONUnh
	87tHE7Yp2D0NdNmSBwWpyjsAQ/Wbb0eH10XZSUr5RKPpn5R7MAbOAVC8xnmwx7Q65BZX/YcCOg9
	n0tik3hbJu/jSQ8UfqO+cwNGxrpG1BS8cpTz9sc+OLTpjW/NFmJVp6PaM3ee2mdtJud8PTlLilw
	Mfb/KhUqBtCbeV23GAVA1lK7yCUfYflr7Mtfwk6GYV8v9KCLNmuCwse9e/j1xOHLCw67vjdU+eJ
	VbP6iuQDg5xwTIWCctAWZe1rN9yvVhFuldq7IpLfcbZE2f2UhP947ERf5fmUWeoKazLQBqMSjr8
	incOhBTlxiaz0z05a0WpsOihX296ZVclCreUbGKSk8vAIi5S5ADoLqbDrEXqM6ZbCkc8JwMwehE
	6FtIdk=
X-Received: by 2002:a05:690c:688e:b0:81e:c998:9c9a with SMTP id 00721157ae682-81fd4bce906mr71495667b3.17.1785621668857;
        Sat, 01 Aug 2026 15:01:08 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:07 -0700 (PDT)
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
Subject: [PATCH 01/19] buffer_head: Remove b_page
Date: Sat,  1 Aug 2026 18:00:45 -0400
Message-ID: <e0780ecfda9137d5755b4ac3e227152bf4c7983c.1785621505.git.coshi036@gmail.com>
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

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

All users except bh_offset() have been converted to use b_folio instead.
Convert bh_offset() and remove b_page.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 include/linux/buffer_head.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index fd2c7115c054..699970b4bbf2 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -59,10 +59,7 @@ struct address_space;
 struct buffer_head {
 	unsigned long b_state;		/* buffer state bitmap (see above) */
 	struct buffer_head *b_this_page;/* circular list of page's buffers */
-	union {
-		struct page *b_page;	/* the page this bh is mapped to */
-		struct folio *b_folio;	/* the folio this bh is mapped to */
-	};
+	struct folio *b_folio;		/* the folio this bh is mapped to */
 
 	sector_t b_blocknr;		/* start block number */
 	size_t b_size;			/* size of mapping */
@@ -172,7 +169,7 @@ static __always_inline int buffer_uptodate(const struct buffer_head *bh)
 
 static inline unsigned long bh_offset(const struct buffer_head *bh)
 {
-	return (unsigned long)(bh)->b_data & (page_size(bh->b_page) - 1);
+	return (unsigned long)(bh)->b_data & (folio_size(bh->b_folio) - 1);
 }
 
 /* If we *know* page->private refers to buffer_heads */
-- 
2.43.0

