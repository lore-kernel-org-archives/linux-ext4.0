Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF6F3A9D8D
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 02:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785982869; cv=none; b=r6Vuox0W4pNYrTJzkOPsbOikC+cNxWWXuIXeQTTozY08FJCDgxpWGjbd0Px8E9nWwJItdlOw7tWqD43WoCj7n4WxgR2b3UxGJ4k5svPuly/Mqr9gPoCYcHvq1za3Iub3U3OYD0Ivv+hmCll3izb8chHF1RHhau3RWvHRP7FFO2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785982869; c=relaxed/simple;
	bh=aElr+oM8GmnVf2UqrRKSwUcnpHH/Ir6i4A3hxs7+FYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X90i64iC8X8bwHvW+bJ12/FyovNDCrUgIugND0WI+Oq96J6LXV+CZIE6kEl81Um5vRzQZ3+4AnkVc8oGtBzz1QHWQNYm3UWeSab9GVUhil7NjacZ6e/Ofa/gVpe7X4IzjZJb9y/ZHcQb41dABuDyoU2ENnSMuDuwFpg5rd3gKI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FHzcEQEE; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FHzcEQEE"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-ca913a601fbso1528853a12.3
        for <linux-ext4@vger.kernel.org>; Wed, 05 Aug 2026 19:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785982867; x=1786587667; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t9bmjwDcDA8gcdpbpxOdxxL0d4dzraqR1O53qZdgMcs=;
        b=FHzcEQEEhJgE8U7+z/KrfR/c6N+rz+L9S5Glo0nDTuMzr2uo8ChzIljN/5SCGlpZme
         LRlSgVfRI0+IUeG69ChfwMfBApN98jzRoQU4w6CC9LkIcDJAxBZbuULOPEHnDuOhFDGA
         rzy65zMmRBD7+lXKg1GB2545M7BbNI5KPS+fKrPYmbpCC9fdLnYIyZGpwZjoZzylrlrJ
         R+pw350Dy/iIYWoeCAIENoH19w2noNwuv04BImWKV4E2IiWYHw+aB4OR6CjBykRjvUzU
         pRNGCqw9wEA9tLUdIH9xYH/7IkhfJSkNXrCqemTGiiVtWk5/KbQjya8OfWXtMFwhlA4z
         J7Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785982867; x=1786587667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=t9bmjwDcDA8gcdpbpxOdxxL0d4dzraqR1O53qZdgMcs=;
        b=oVm9CdDv+jb8kFMZXUiYhZc9WH4X46d/S4TgwKiDo0HwLVQQRuMeLhSSZL1xiUMSaR
         G3teYkOklZLGG64BmF1uJ1Qms24AFuGrTFzyF9bd4DqBCEiLFGM8vm/nb0kpXEkxuSas
         KpkdvxutkIJQGITdkcsiJu3U9QTEYqdY6q3k58R+eD4mruybayKYpYqBvZT+eAR1KYKm
         oXS0x0IAX2fmkDBhpcs2lsgs0PtNuaj9HUmrW653jQwKwJs+cG0X59to+yM/zK9Fi9hG
         T7YLkCumW59CqGQ3GNutEDSrn21lK3ZhmX8hOjWMG7sLK6hNQtjc9+pStQqiH/pi6ZJt
         4NWA==
X-Forwarded-Encrypted: i=1; AHgh+Rp98C241Sb7nx1j5SL+CnjNYOloJHBCxtXr1YfkzuIrX3kgtrtF9bJoRsB2IH9fxqtpkLf9stPNkEwM@vger.kernel.org
X-Gm-Message-State: AOJu0YwAA1lg85YXb3mBFIyoa5PJYfa7kYUmYaRzRfDMU6xJlnhYw0dv
	4Pw7pktXh2u4vU641aJugLlVaHay8HgbHU0cgkWiDJJmKigbYfrDK65p
X-Gm-Gg: AR+sD12KoQ9oXofICX9GyVAVakT0i0sTVjyObzvhaWRQhwKpSl/614CQXc0w7SjDsZD
	9YcLEwWmh0F+5zY6BVf/PBPhMSefRD0gR6Pah+dFo+uycesrk6bIdOr71gh1kpcLDREvYQdsyXN
	UrKNgACoaNwPHT+E7LngsqCZGDu6UIDWLpU0jfxtTANDpK2d6QeR2f7h7ExSH8rrbTM8PUeLW61
	GlZrbr1t91IfX51rbVENYqEfdSb49CoGPCGSKUe+0oQxwwyqXgRo7PmtghIwvT2xi2VQENbcOg6
	ZdMA04jVblTkq3NH5ypshEAocQMo8KgugqIEMPJfkLIKU/w0+9i4hmPKSF/Ek1ZcGnh+jMcAHWg
	wteuMd38ySHSRkbu3SB3MboSnGauDc5X8Ma36KZOJlY+Dcl4jdz8kpuzXvgQXId+mTYkkHldgYK
	3YynAiV/82BggzeHuA2kCzOIsRggMzUb5y0RfrlhIqwNVODQ/KDrExhhSfPhBaKD4lEsJ5kiJS8
	0OIJUJTeAQ=
X-Received: by 2002:a05:6a00:9a9:b0:837:e9cc:d474 with SMTP id d2e1a72fcca58-84f2dfcdcb6mr12615394b3a.2.1785982867454;
        Wed, 05 Aug 2026 19:21:07 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f4538ba99sm323012b3a.9.2026.08.05.19.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 19:21:06 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com,
	stable@vger.kernel.org
Subject: [PATCH 2/2] ocfs2: fix readdir position truncation on 32-bit kernels
Date: Thu,  6 Aug 2026 10:20:44 +0800
Message-ID: <20260806022044.167962-3-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260806022044.167962-1-zhanxusheng@xiaomi.com>
References: <20260806022044.167962-1-zhanxusheng@xiaomi.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In ocfs2_dir_foreach_blk_el(), the directory cookie position is
rebuilt with

	ctx->pos = (ctx->pos & ~(sb->s_blocksize - 1)) | offset;

`ctx->pos` is loff_t (signed 64-bit), while `sb->s_blocksize` is
unsigned long.  On 32-bit kernels unsigned long is 32-bit, so the mask

	~(sb->s_blocksize - 1)

is computed as a 32-bit unsigned value (e.g. 0xfffff000 for a 4 KiB
block size).  In the AND expression with the 64-bit `ctx->pos`, that
unsigned operand is zero-extended to 64 bits per the usual arithmetic
conversions, yielding 0x00000000fffff000.  The high 32 bits of
`ctx->pos` are silently cleared, even though directory size is
allowed to exceed 4 GiB.

When readdir() crosses the 4 GiB boundary on a 32-bit kernel the
position is reset back into the first 4 GiB block, making the
re-validation path re-enumerate already-returned dirents indefinitely.

This is ocfs2_dir_foreach_blk_el(), the extent-list readdir path taken
for all non-inline directories, so a directory large enough to cross
4 GiB reaches it.

This is the same class of bug that commit 3dce5bb82c97 ("exfat: Fix
bitwise operation having different size") fixed in exfat, and the
fix mirrors the equivalent ext4 fix in this series.  Cast the operand
to loff_t so the mask is 64-bit before the AND:

	ctx->pos = (ctx->pos & ~((loff_t)sb->s_blocksize - 1)) | offset;

64-bit kernels are unaffected.

Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 fs/ocfs2/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index d7fc3cccf2f4..c30a86856d5b 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1917,7 +1917,7 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
 				i += le16_to_cpu(de->rec_len);
 			}
 			offset = i;
-			ctx->pos = (ctx->pos & ~(sb->s_blocksize - 1))
+			ctx->pos = (ctx->pos & ~((loff_t)sb->s_blocksize - 1))
 				| offset;
 			*f_version = inode_query_iversion(inode);
 		}
-- 
2.43.0

