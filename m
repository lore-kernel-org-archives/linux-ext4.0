Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EFE48B383
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 17:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035608; cv=none; b=onwrKGZrgs7MOmOGwo6rvlzXcikZQJyN5vZpxsIY+dPtsLO5uCdwh46q1giCa3JT3ZROqMqmGWvoMvTJUzaMpevMay5qZ+vzBVp3UW3JSrjk+WTbVbKixzzeV2+sdnZ9F10IrL2Y1Ezzr9qngKsyo/qFa39+oi7cX59LaJ/Z0Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035608; c=relaxed/simple;
	bh=nwDfftK6tDKKFwsyIY1zmP/nNMRDmqL5O9HNMSOfLoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=karXQ5OpzfWHXG5dNTDdPUw454QptN1CYvJjUuac6/PsSMkFATwiOAeiv+B/ILfy3Bff2znyUd0xmVvKtn7HUz3HTLCxzUqqDFQUtER0Fhd12moKtxUEUI7yw+7oH+hxkvxic0AGBIyw3+tVo8z5Tfl48aFEBfJnwkJHLOF0Jzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RpJjo3Df; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RpJjo3Df"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5c38565e774so714137e0c.2
        for <linux-ext4@vger.kernel.org>; Thu, 06 Aug 2026 10:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035606; x=1786640406; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VOSQ52yeWBlRERTYkX4++c0c05H07NL60x8ILsT5aXA=;
        b=RpJjo3Df9WQveeK5T0fUBs9J7PtwKjP6ioFb1A9txPdlCDx0C30fHZz8SkCYXE9rXT
         vleecIQEGfHJtpZcIhsM7jqm+xVr0aCFNRX0/X7mSCfVkrSbunGL7BWRDx/0L6ovsFh/
         HFKnEh9dt5/H4ecILk9rfj+ElJQqahGBT9ILKccOnbElXJLsaHSwxQK7nH04BNmB3k2b
         GUQTrrMxcUEf5NSI1p9U3ogHsfCLme+6vl9l43I259uy7drmEHz+MromgdxrLR8PvIDK
         tlQY0/sUZa0iOnRQTEd/QScs8bSIGkMoHa3ICCftGpd1M2nEkyheJjM6zfH2Q2tfz1rO
         EZmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035606; x=1786640406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VOSQ52yeWBlRERTYkX4++c0c05H07NL60x8ILsT5aXA=;
        b=UHM2RVn92MDXa14ACylcr8cUuanoNHIZwRvn+MiLPQnbFx8fn554v0JM8mwNl4veDQ
         Kf+F4qrXBOI1XNftdMIlrRB0Pi+2cYR1vPQAKQvD8ZSgEeohQaz/QSbUTVk+MoRqvS+B
         PAfXxySjpjQ9lKLNgqoj75Gq3Q+/GDRdsB2OkWee2R2yg/yPXaWOwF5MkpgNhNp6besX
         REyJT8hUhzJv29ErfN7QuY/1MxBOlDvgvhv5eIXgXDy+NVqt0xe3BgKEgnX7h+jbz/uX
         F+Pu9k7FqaDI+0uKHijTQ6c1IoLq50hZm6lLilrgh9SD10HpYltY51omu9a/CLBNZd/J
         BGNA==
X-Forwarded-Encrypted: i=1; AHgh+Rr3G7DwLoY/5P6uXq95Krm12gEkrRZnet9lfRY34xBNAbOcE0FkyJAcVPItQW5fkNuxe85eafLnvTu2@vger.kernel.org
X-Gm-Message-State: AOJu0YyK1tIriR0rMvSchd4WIYx9jl07zQoiiWLLRt6p0mWs2jl6qSX9
	/9gyDe5veds8CFPmc2i4uIYn0XnVrEKJISvO5GtA92g2QvIYwklb9XNl
X-Gm-Gg: AR+sD13NDnZW/zTzq5xKenwPFZldW/vk5PuZ8gIXpM0p86uzT2syv2ouLftU+DvJAdX
	AgIiHG7u4JywEEa7BGLgDMagPvk7+SUTU59kkE/RZnXGOh9+sFP1BCEysMIH6JDb/xznVIXSuFZ
	soZA1oCYU5zUhCp7Z/elaa7MN8eGDhyTkrCjwNSVm2ji5d+mqr4cHrHFAQHkxEbeVs+9UCVmuOd
	xjkQlP0nFyBZ2Y+Idofr1CDgbTaDANcaABsfKK2LyoNxH8Fyq6cWSGPb6aJGk19owtp9t7G5mh3
	qjCE+ZOaKTPwzm99WzMfVxutudfq7FN+tBL9aLFqDDuePh/2KpDxuRU6TcbujeYYrYrnJEeEbJP
	5Ov3PW4cSHFCUF02th4iuvGbCU/vWL9VRKv8UdqK+P82BIPdzz30bWcOq6zfmhO+5zKmNlgf+Zc
	o3wZXeKXsb6b7rPkgLTRI4mhu7wa/4D5Ht8u9pJyh20aNpK3qPwIvu+D2Qm81p2hy4vTds91NBu
	GU679o=
X-Received: by 2002:a05:6122:8f88:b0:5bf:b3a0:388c with SMTP id 71dfb90a1353d-5c3d91849cemr2185136e0c.6.1786035605840;
        Thu, 06 Aug 2026 10:00:05 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.10.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 10:00:05 -0700 (PDT)
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
Subject: [PATCH v2 18/21] jbd2: say what jbd2_freeze_jh_data()'s assertion is actually checking
Date: Thu,  6 Aug 2026 12:58:41 -0400
Message-ID: <713ffb9c0cdfe55499b3cdd2c06a59a2c152c46c.1785951556.git.coshi036@gmail.com>
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

The assertion that the buffer about to be copied out is up to date is
correct and stays, but its message - "Possible IO failure" - describes what
a buffer that is not up to date used to mean rather than what is being
checked.

Once this series stops clearing BH_Uptodate on write error, that reading is
wrong twice over.  A failed write no longer makes a buffer not up to date,
and a buffer that does carry BH_Write_EIO is fine here: it still holds
valid data and the journal will write it again.  What the assertion is
really guarding is that there is something valid to copy at all.

Say that instead.

Suggested-by: Jan Kara <jack@suse.cz>
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/jbd2/transaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 5cc7d097b2ac..85d84d909f78 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -920,7 +920,7 @@ static void jbd2_freeze_jh_data(struct journal_head *jh)
 	char *source;
 	struct buffer_head *bh = jh2bh(jh);
 
-	J_EXPECT_JH(jh, buffer_uptodate(bh), "Possible IO failure.\n");
+	J_EXPECT_JH(jh, buffer_uptodate(bh), "Buffer not uptodate!\n");
 	source = kmap_local_folio(bh->b_folio, bh_offset(bh));
 	/* Fire data frozen trigger just before we copy the data */
 	jbd2_buffer_frozen_trigger(jh, source, jh->b_triggers);
-- 
2.43.0

