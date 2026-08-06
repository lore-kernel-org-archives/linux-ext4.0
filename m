Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1D83A9D9C
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 16:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035554; cv=none; b=VUgpzkFtOnEnGZVUe40oTbRPgvUntDAawNLdod4Mq0+XmcRcZmb+Rs2sLoMDJLLJ78R79Jjrto8GkSa2dE8zdKLGflGbF3hGtO7gfD8q6Blh7K72bZgPfDirORYRB4Hty9F6gYZqNsfjrqEvoyw2HKqh6PC9o/Fbf1ezLO7j1x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035554; c=relaxed/simple;
	bh=nXfjVTs2WwI7r48njT1474MNwTWULNnJflHmHfHsQpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFnSVjgGEpseYjjyGn+A02yfsSEIgUkhBhNp5eE7Aov5dLJ68/iBm30cjqsMsEV68GEraBfQJF3xWDZ0U5Gt0i2TxcfgbwUce8DZM8CXJzSkMcPgzZDJOWB6PSQDhG7VWjMx+8BLfYbpgcTDsdB3KQk8mWo53pziAaHJS2ZDuTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rCjwZ9ZH; arc=none smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rCjwZ9ZH"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-97017a60b06so750198241.2
        for <linux-ext4@vger.kernel.org>; Thu, 06 Aug 2026 09:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035551; x=1786640351; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/lKy66WaG7+TnlzmHpXjsimPtvzEbNlkmMtBXzg/7M8=;
        b=rCjwZ9ZHWX41u7MfJ+MryPhCI8vGY/L8sYpgkXPgIfdNOuJ357cyBStukNEZ+WPC8x
         pKvE1d5mqR9qjiUoJ28Djmysne+CaumKECJBG1EXqQctXaCyGT6voAWXZ0y5Jrtytqha
         LhG3ndoxi4p32VUIJPd1zRasy5YjXlVop2LKrJr8LAoYUVE36vunoOZ2tmqylhpIQ0Wn
         +osJFGgG2OWfKyETBj7A+zIP+OLgNlIArcYpTGrtQTfFn1MFg2o7UJNtdMJXJnx9gG0d
         fEi0+4jSKrpxlc+cagh2eEGliYPxweH1BRLN/nyRwlWiYJ5VebD3a52EhtEdRPTlzK2e
         QhrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035551; x=1786640351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/lKy66WaG7+TnlzmHpXjsimPtvzEbNlkmMtBXzg/7M8=;
        b=DV65qRphQVvq0Bjg08T1/TNveMPKXBL/GxviGX1ewJOr555DunetI/LRtHbF25gYdz
         wSkiMQGvctJb4WjMIVStUQCcMjpwTHf9WkzMF2dKpxBlNPl+VKJmNDi8d51phYFEXThc
         uy9t69KaV/L7uyqlsqbALCBg8wZzIc8cviHL0ga1/5dl8l+mIWVElbL9VZ5kOHnbNCrk
         hWd6DeQRIXqQaqsfa9O6YHBwyCIGQ44uxkTVa34y6GSaRlSmvUcIXdbmrp8etEgWACDw
         p80RrmzC0kntQJZxA97udzZ8X+vCulgCCToV7KmIScEzWF3tKPw3p8oDhoF2wOhI5Ltg
         +b0Q==
X-Forwarded-Encrypted: i=1; AHgh+RqAoA+QmrwbDqV9nV9yVGFYgttvpW2ZqHHhZ3E9H1H/nkxm95cF1YDWH29tl+bJIyeA5kpIM+RM6nXQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yzq0Ftmm+L+3z9Y1DffIEZsO1J+NugZLwpPYJ7Y2DyhE8R6mk3P
	MXC/7vxkKJZlxxez3OMu42IqcvxTO3eEVdYvj2VPFljNNTeTriiNblPo
X-Gm-Gg: AR+sD12jZM+9/VJCmxwz/SUhKbFlT8BiVXh0fTS2dvCYAgqy9ula4xDxuOxmYsc44to
	RB2ANCACWPZV3xRaky86zwCsbDeBPj+1vAhjBLtgYK9FgHS//ZLHSaJEHWwl4+GGvhTR7Fhei78
	37YQUoVd+WZ4dR8OGDoxx/SDzbWP47kLZgRVtM0GRVhcaV+dB5XKqJ1IAlopJ117SpC+zuDzUwi
	vetRwWF/3Epe/mCVpipH4wQIXh1KdWVRc0kkupzZa7FoSKLX0GvPI8GHWr9pwLzidy54gRiAhW6
	7IYrCIJqRfn4yFoL71cMhCAVizjyOHMyGoTlt7FzDMXoU+yFcOjsFUKFgu85U6F5r5N4WGrBvSB
	m263no7kigZiIulZ0v0DZysY5HqAlSObUa/8bcTN/SGRDT07GdN0dl/sOsQnB1sFBbvXCdcA9Gx
	3cGEcecBSVZ7pSAFLwhCh3aHTiZ1zW+GLo2W1jOZ/Ng5uaf5Wdom3/8F/yPWhb+HJsOYivyIGEd
	vzcDXA=
X-Received: by 2002:a05:6102:f09:b0:6f0:3ba3:7d84 with SMTP id ada2fe7eead31-760e77f0ff5mr4020392137.5.1786035551228;
        Thu, 06 Aug 2026 09:59:11 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:10 -0700 (PDT)
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
Subject: [PATCH v2 04/21] buffer: read the folio's mapping directly in buffer_set_crypto_ctx()
Date: Thu,  6 Aug 2026 12:58:27 -0400
Message-ID: <3fe72ec37bf8491a69031db5f3ba1319da935b97.1785951556.git.coshi036@gmail.com>
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

folio_mapping() was doing two jobs here.  One was to turn a slab folio into
NULL, which is what made this safe for jbd2's shadow buffers; the previous
patch removed the need for that by giving those buffers no folio at all.

The other is a hazard.  folio_mapping() maps a folio in the swap cache to
its swap_address_space, so if a buffer_head were ever attached to such a
folio this would hand fscrypt a swap mapping and dereference ->host on it.
There is no reason to want that here: this path wants the file's mapping or
nothing.

Read ->mapping directly.  Buffers with no folio are already handled above.

Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 04fcc34e4fa6..2851830995d8 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1108,7 +1108,7 @@ static void buffer_set_crypto_ctx(struct bio *bio, const struct buffer_head *bh,
 	 */
 	if (!bh->b_folio)
 		return;
-	mapping = folio_mapping(bh->b_folio);
+	mapping = bh->b_folio->mapping;
 	if (!mapping)
 		return;
 	fscrypt_set_bio_crypt_ctx(bio, mapping->host,
-- 
2.43.0

