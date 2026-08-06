Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425983A7F46
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 16:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035541; cv=none; b=LUg2nmzeAyF8ICAsj8eOxlIbXgIr8OvBpIIxIJ9jNtQ+izu/cNJg8qkuGTmZfbmhahLnzPbK2AYU/D9EXsVbGQLEaJvKEyjRVKRGV13SJChgD048GZLVk8qQeU3WxjeOO9FqZAW2XZ8wR8x7Fu08NyP0GFJaxvCeg4ilri5cK8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035541; c=relaxed/simple;
	bh=lzP4aegwZTPCQw0cJ3VVWrrvdN+pa1Cx+PvabTKZT/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlIefpwoimzVpwkf+/xUaSeo9fIbUJ7f171ReNlACMo6GA1+VxUSXY1fHCKWNRfqdMyT6+2aT4SzUFV6dO5qB47VRfkNgXtsAwTnAiihokVGGpDk7FyEt3d35fHoeWgxVHeBhLdT944nF0DLS8cVNTkl48kLr8jZIktgXn+Z8AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pfdXrfjU; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pfdXrfjU"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5bf5370d38fso785400e0c.2
        for <linux-ext4@vger.kernel.org>; Thu, 06 Aug 2026 09:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035539; x=1786640339; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l4wawGSh1ayASvpYyyNUW0xG9j87AeVkrycNAPRNAqw=;
        b=pfdXrfjUkNr+YpIAxW3VGw7zEHPJpnM4qqP0VGAcK90I0ESgxg6n2lugFNQwdGQr6T
         BPonjuqzbAnVfl63svf4eLuxkOM8AjZFstSyYR77ttZFSv6fdkdle3O99IOdmH1CElSB
         iKV6emEWyJSIvk63ESopkxAU+GhZZs9+7dHy3ihJB+2VMnH59Zn2+0J9UMJr/Fm56qny
         b0mH2jjV+v0dSEcOWQsfrix5fOvbg7uZcQR03od6zRbrMdxhcHZm8KtGuiMhCTo5QTB1
         cWCVsKV7mOMDB1J1EEj3u5X4aqrbThx0DNb+RyWieF+QBN1OnnNKmKWImgzw+YX75oDp
         rhiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035539; x=1786640339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=l4wawGSh1ayASvpYyyNUW0xG9j87AeVkrycNAPRNAqw=;
        b=eZ5sxF+o4eRfR+b1jxvcgeyVNnGgbfuyXnPvre1jIJAEiHVtBfMCxkNWzigrNeLyAl
         d566scCWTvdLdy4tQq6oLnweCImXfyoP6KXknjSAQJFhl5U+DPPO2MzwN5hWpv+PMySO
         cBNb9JyvIvYVDKoi7l/Dldqfzmhk5U2UQuFLuW5bsw3wqYtJ70zvjR8gfOFUq+EU66UR
         GW8YuQCTXY3kqtoEBuVK0nfM90VRYOdaebP+GMLBmTwzkeSeeV0ZZegrJhNoNM5+LpAC
         VCn001pVOocG/UfIHY2g0sn/x85bR7rUMAYMEQpdMnxzdDWnUpM2PsqhK1Ksm7MpKUZb
         Fizg==
X-Forwarded-Encrypted: i=1; AHgh+Rqr/uzvIFq2UhecriHD2FmaTF372HoWhswW5BXFF4V+qNcQ1/uuaPt9LG/8Fm5Vy1zNP2EntrVjfV9Y@vger.kernel.org
X-Gm-Message-State: AOJu0YyHfaHb3oZ5x02kbZN3hc0grVZJeeiy4A2t6aUY5bo/CsqQozCY
	HJXwdBcu9MmmJwanG3xO0eH8OiMGWZShyfhB0TIB+Ju7w4D3tySdzwhh
X-Gm-Gg: AR+sD10QaSxqgWQWewcKiuwZoEkPQZzCZdcKyRx1gLh+o4cHxNwYzCSp6XErSl4jBc+
	8mB5Wv1v2Vcua6qh7dd5xc0PEqVdtZPASSZ/QXo8mVnJ+ipBaSNK9o4jvZ9mZf9eoaP3BPMP0PI
	REmXPRlVwfCDa+X6358bJoJrKDT2zAKNQkBpmtbNM/mGorOAta9vcbjkuYRd1ws6Q+dCH8iU/zh
	I1qgDUt01UysG3+xIf5AjFMLFGNB1q36Z4Mshyg2juAznItmrrvf0LRmk+fB2DeX537DqpnJKcF
	NBG7j1FD+dLe1fBDnH0RuxgxV7GC9++Q74qMW7gshUr7mFc0hh1JQ3nuVsQrDUcNCy6VaQWoO/9
	VlnMFSJKKZXxs52pjAAMB0czd7VJiJk++I1cSB/nU8bvihFsOnmCYhEcZT+Mpey+UYy7RMQX/97
	ESnsQDbnxXuQFN4v12OjaMUPdXu+WbCirfm2wX++YUPzbb46ySkZnY7PktPhv8wGlKR8yEa0QtS
	reUcPw=
X-Received: by 2002:a05:6123:2c7:b0:5bd:faa8:74e1 with SMTP id 71dfb90a1353d-5c3d92900f0mr2224979e0c.13.1786035539083;
        Thu, 06 Aug 2026 09:58:59 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:58:58 -0700 (PDT)
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
Subject: [PATCH v2 01/21] buffer_head: Remove b_page
Date: Thu,  6 Aug 2026 12:58:24 -0400
Message-ID: <e9d168901578902bffe78ac8b5dfaf1210ee7fb3.1785951556.git.coshi036@gmail.com>
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

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

All users except bh_offset() have been converted to use b_folio instead.
Convert bh_offset() and remove b_page.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Chao Shi <coshi036@gmail.com>
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
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

