Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7F637E5D7
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187498; cv=none; b=HyJ6EzY+cdPBXYvKTOLWyCj/HReMu25TbOad9RGX6q/ttJrHtCU8ztnXa5Fcmhs6hP/MEZ1ZSntlTo910vorC21kUM7QzsqqSsinlLWhPyHCjtOCPw2QiKAAvq8gIsMdWDb7xrXOZ/SsBR4fBL7YF0Zy9ojb+adVKdzvbKJElgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187498; c=relaxed/simple;
	bh=3Fbl5MaGSEhPrjx9pliGoJqPoQm8nDp7ZS+WKqitgus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2+M5WzGEtDzVnIzLTD7lKBpEE8OS/IGOiKz9Wl3DAT+AAkw+C+LtE6VeJbHUsGcJuJ0n1sveKr3lzSGIw/AgU8oY4tuybWNJsGutr6U+Z4/yUEGumLXeKaaiiyt7q3l1mBbSHJgXYcQ2lqznvMiHgb+ml1NGWE5SnC+iJXmP14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EkZ+UVDq; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EkZ+UVDq"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84e0688b859so1944873b3a.0
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187496; x=1785792296; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jH+TeFe4eS2WsKabb3CNPoYBr5KTegiyeJHR2iqxc70=;
        b=EkZ+UVDq09X6A5c3r9RfwA38QlXAzXsX0Dei3s7Uo1Tnh6zEXehHR8e5+ztXW02D+f
         GqMkRZ5YxhC0XKbfRBPAl0BKTzTxMbS/0KxABPGk5zViByiLA2nyCMfOgKZknIR152PN
         1zzQmSVlqp5As4jStS1kucydy1sHTGZCva3fVcP64AlfrjQZ8XPf1lTLXARxDUtlNQ+a
         zA+uOkxN4kKPu+0XD5kDqSXV5VhLZ4M0+oZ1qBdcD4N5pCo591WXIMI29E4ziLdaQoFm
         z3oMbAwxBEskwO5T60u4K9tCTfMA9HzI6o/jIieYWKBkKxShjJp0JDL0/y63kw+c4hiK
         P2AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187496; x=1785792296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jH+TeFe4eS2WsKabb3CNPoYBr5KTegiyeJHR2iqxc70=;
        b=oLlUrfrpPwF89jwJnIj64RR/NPIdXT94kxvpjMD+mbFJdYn+lgqopfUjzRvppTTEZm
         5U0HA/xe7fIhu2XVaBuBgL+gotcFLEL+C+jxhL7/55LF2E41v2mFuS53KZYI6SjMwMXX
         +QR5UZZW//abVwtA4Wq6+B5fcijakZLM40NILNP45i3F2fmnyFszMRqW3XBwl1YYPKmU
         cX+XHaooMvZ3E9zMnGksSAgGOjxDV22c8eAolx2HRESSLyWt/S3FG8Pcm0iYS5gT32wj
         KOsxQ/nlES058e+JsENcwrw03qbs/FKdXqLK+Idr2Y+a2AaDa2bY8+wajT1YfYKz9DKw
         MOww==
X-Forwarded-Encrypted: i=1; AHgh+Rpf82u/qsDEy1T3gkLVVDLuAXfruX3pm3PWX4Ds94XBrelT6uZz/x0bzD7HUFrtIhWiPTi4cGNfoXAN@vger.kernel.org
X-Gm-Message-State: AOJu0YzaRhCWlXgKaVJnBWgA8glW+kMYftvOQFRFpG3GaEDttj2yO79e
	NekRJA0CoOmr1y8/yu46J9hklw2lmSDFXYLv48zwUImAXYhY04Z00M6Z
X-Gm-Gg: AR+sD12c8vm2RmqBXPoZgYG5lW8vHaG/ZxCRZZcFewNBpz5bBIQ+XysqxhF1x03TpHs
	OQVIuydG8VFOC+4BI1xIx7552m0fgFiOcsS4jH/uVD/bxiM3kEcWLs5uz55qdxzwfR6GGkv8k9g
	lHokGL+yMukWSWChiwkFLLYluie35EabgdrGg/Gcl0EcNLPKwxFP52cNFFslzIXGkJ/a2asgqwh
	5TuNJjJG+ZTKPQ8kqgsnAdSJGTJExaFfsF9+nOdn6ZkxqFHXr2KGqAxlW2QGt8z362YfI2fJ+jv
	rzgGzkmrlhaD/NODScWU9lwWeY570RdICrI4vY7CyQ7oe5PzwrXrOMgNuUdP4klG6jKmtXDk5qg
	VgvoTK341m2M0QquEQhLNVYJq+OjWCpjmP+CEnrWznt1sGdXRcPk9DEx8UgBznA/C67a7jqbwWb
	5MpXbEi3We9hgIftvdEklui8SPVnGXUdXtHz+ID1LJKk5FbQEfg0Cv7GxQXPg2f9ogKzTKQsuZN
	TC9s2i6LuiIK6BooVfmhFk7wnkFF/CfcY/z9YLa
X-Received: by 2002:a05:6a00:1827:b0:848:8027:cac with SMTP id d2e1a72fcca58-84e8d0950f1mr997486b3a.23.1785187496247;
        Mon, 27 Jul 2026 14:24:56 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4c::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e5342471dsm3476124b3a.47.2026.07.27.14.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:55 -0700 (PDT)
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
Subject: [PATCH v4 14/21] f2fs: convert iomap ops to ->iomap_next()
Date: Mon, 27 Jul 2026 14:17:51 -0700
Message-ID: <20260727211758.1116539-15-joannelkoong@gmail.com>
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

Convert f2fs iomap_ops to the new ->iomap_next() callback. The callback is
generated with the DEFINE_IOMAP_ITER_NEXT() macro, which wraps the
iomap_iter_next() helper to finish the previous mapping if needed and
produce the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/f2fs/data.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index a765fda71536..8977ad379f50 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -4653,6 +4653,8 @@ static int f2fs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(f2fs_iomap_next, f2fs_iomap_begin);
+
 const struct iomap_ops f2fs_iomap_ops = {
-	.iomap_begin	= f2fs_iomap_begin,
+	.iomap_next	= f2fs_iomap_next,
 };
-- 
2.52.0

