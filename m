Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3313A3E97
	for <linux-ext4@vger.kernel.org>; Tue, 17 Mar 2026 10:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773743301; cv=none; b=e1xglcvs7nro6VYmd6yRhr1qD85vJ035ck+CV8MdCCcBX83JnMGQ8dbn8zcFMtmD2sXH2QmenbqTPBCcneqeb7VR8VkhM74Kb+egku1oN72MRvFtvK6AIvx/g3e9ieD5t3itG87w3oCRxBmOwMk2aYpoiC+rJhCBEwtrPpLzyG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773743301; c=relaxed/simple;
	bh=eSDEhGnUS+hAx0HE05ggNscZBkEooyvYYY/Flhz53xo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Nlyv0VwOhiJLFCgE/EDTzIy5x0+qyL/SsUqPa6W2VnE8HhvypTgdezQkLstvb+8yQ+5AsYGZPB9TTjLp+7ByreEFQHA25FIlv2CKQev4veGiMfwSGVzwdwkC2QQnsVz5aPv0w9yTZ3nvTzdFX/tNbw5eplEg9VIuJJCUAE8iAlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ifVa5RCk; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ifVa5RCk"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-82a62714fe6so89244b3a.0
        for <linux-ext4@vger.kernel.org>; Tue, 17 Mar 2026 03:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773743300; x=1774348100; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O+pmK7JMn7hogCUOpU9+zmNgnz8sS6V1SySHGsHErGw=;
        b=ifVa5RCkHq3J7iBqZFgpszbffzRyHQUXSu1UsHGf5kbO0zsjV5jWZQhD+U/S5u5Q85
         yscmsQbgaXTdPHv1CfErHGxJlyD/1YMd0puYXYuc1NK0rVzzZ8hFBIH9NC6RDxW2L0oT
         BqLBPdq0kf+OY8R87kaVe6FVExcldzWXYyyusGepQJtjNgpe3oVHFolNYwovnYLeEaKy
         gqia5Ic0UTqjqxj6x8qetNac3R29Nj0+4GCnza+v4h1KJGDBjxCoL/Rwls2Oq5tHktFb
         dCdOLh0YTg+gw2Mgj10z4B2zaoAN8QUXe9odJugahb0DYO1M6t4WWq0/aZSA7iLqniMN
         nw0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773743300; x=1774348100;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O+pmK7JMn7hogCUOpU9+zmNgnz8sS6V1SySHGsHErGw=;
        b=fGI9ePROeNi8qFWdAPWEsPgG5SqZ1epaxs1jdK3okAIi5PHnbK7KZ5Tem8cdvuGPth
         KktOB1HiUbPpYSzrxHdlZ/ysK07YMMDoew+RcXH0mcmeHqzEXC8GmQ5jxolAdKJcbqaN
         I+akwW2eqFQmHNj+Pdt98LUJ7R2phB2aaqwRwqIQWLnoLgxWMOrUeKjRe1lqZnid9qdi
         tr2zfyYvzxAycTVkKqOfd5DJT/QH76DURlURwwO1DdKg1yOIvifa9vwe+binUp4wyImy
         IK8k7WQbtbepD5EZZQhQPdy/GGxT5SzuKh+nP1pK8s37ZvTWrugrAeK0aXuRppx09CiY
         7GaA==
X-Gm-Message-State: AOJu0Yw0n69Wu4RGzNRgiDvNJrdqPoGf3VTHLZ3nnJWgWDt4t3EgVm8U
	hBqBP0E/H/lYhwNn0HP/z8+nxgZMPnIlMmD/QEa87TOdx02LoIzRqbB7o7JKOLYRRb/uFg==
X-Gm-Gg: ATEYQzzyPmKEeeY7sO0T4k4dlxklXZB8Ih+VpSRkgY5a5wg1JsYXmydjRFSLvICnrea
	oI/rsxYuDBx7Bnj6VpGZ0p69DmN0eh1hCbvxapIEdF/uPplGlbdatWOWErrl7B2VoORPgvKjfvn
	W9qfSO3fhi/dk21WQxXzkLRqOo87zIyrkIzQGJacqUmb9KMfv9egn9FBYGJlA63r4VD6HvZ+/Cf
	LPbDqHRYhHdKaOrMq1mVZsq4V0avR+FgQeKqA7ZKUw3afwaikkKzaB6QwHMpq3CjYvfHJwlUibq
	qbk8FAAAS1pUVtWlz+HIgq2k6kQeRjTIGiPADjcmuHra5VsnOScNXX7ilRezudDEntWx14GLcZ4
	ESB0kF9lTZgxrEtGDr3BMzG41Hsi0tCNnjCtcEBfDhHS6Ndoa2LsbqQWorEEUUhJiHBwsLcizqd
	oAxe4D/hqXv746OcaCPbvhVKPGdM8LGg9SFT2akRPf1bCOIoQ/m/HOfMkoyHDRy+l8MIJZpqc=
X-Received: by 2002:a05:6a00:7083:b0:81f:5acb:55fc with SMTP id d2e1a72fcca58-82a56042489mr1971355b3a.10.1773743299558;
        Tue, 17 Mar 2026 03:28:19 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.183.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a07287ef8sm18339705b3a.29.2026.03.17.03.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 03:28:18 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] ext4: xattr: fix size_t underflow in ext4_xattr_set_entry
Date: Tue, 17 Mar 2026 18:28:10 +0800
Message-ID: <20260317102810.2984100-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
KASAN reports an out-of-bounds read with an astronomically large access
size when ext4_xattr_set_entry() deletes a corrupted ibody xattr entry:

  BUG: KASAN: out-of-bounds in ext4_xattr_set_entry+0x11a3/0x1f40 fs/ext4/xattr.c:1756
  Read of size 18446744073709551600 at addr ffff8880179737cc
  Call Trace:
   ...
   ext4_xattr_set_entry+0x11a3/0x1f40 fs/ext4/xattr.c:1756
   ext4_xattr_ibody_set+0x396/0x5a0 fs/ext4/xattr.c:2268
   ext4_destroy_inline_data_nolock+0x25e/0x560 fs/ext4/inline.c:463
   ext4_convert_inline_data_nolock+0x186/0xa80 fs/ext4/inline.c:1105
   ext4_try_add_inline_entry+0x58e/0x960 fs/ext4/inline.c:1224
   ext4_add_entry+0x6d2/0xce0 fs/ext4/namei.c:2389
   ext4_add_nondir+0x9c/0x280 fs/ext4/namei.c:2784
   ext4_create+0x380/0x500 fs/ext4/namei.c:2830
   ...

The access size 18446744073709551600 equals (size_t)(-16), the result of
a pointer arithmetic underflow.

The bug is reproducible on next-20260313 with our dynamic metadata
fuzzing tool that corrupts ext4 metadata at runtime.

[CAUSE]
When deleting an ibody xattr entry (i->value == NULL), the code computes
the memmove length as:

  (void *)last - (void *)here + sizeof(__u32)

where `last` is first the result of walking the xattr entry list to its
terminating IS_LAST_ENTRY, and then stepped back by EXT4_XATTR_LEN(name_len):

  last = ENTRY((void *)last - size);

Consider a corrupted ibody xattr list where a spurious IS_LAST_ENTRY (four
zero bytes) has been planted before the real target entry (e.g.,
system.data used for inline data).  When ext4_xattr_ibody_find() calls
xattr_find_entry() to locate the entry, the walk stops at the spurious
terminator.  xattr_find_entry() returns -ENODATA and sets s->here to that
terminator position; s->not_found is set to -ENODATA accordingly.

Back in ext4_xattr_set_entry(), the entry-walking for loop starts from
s->first and also stops at the same spurious IS_LAST_ENTRY, so
last == here after the loop.  Because the "remove old value" block is
guarded by (!s->not_found), it is skipped.  The delete-name path
(if (!i->value)) is not guarded by s->not_found at all, so it runs
unconditionally.  It then executes:

  last = ENTRY((void *)last - size);  /* last = here - 20 */

which places last before here.  The subsequent memmove() computes its
length as:

  (here - 20) - here + sizeof(__u32) = -16

which wraps to (size_t)(-16) = 18446744073709551600 as an unsigned type,
causing memmove() to attempt an enormous read.

The load-time check_xattrs() call also stops at the first IS_LAST_ENTRY
it encounters.  A spurious terminator inserted before the real entries
silently truncates the range that check_xattrs() examines, so entries
beyond it are never validated at load time.

[FIX]
After adjusting `last`, check that it has not moved before `here`. If it
has, the xattr entry list is corrupted; reject it with -EFSCORRUPTED.

After this fix, the code will detect the corrupted entry and reject it with
-EFSCORRUPTED, preventing the out-of-bounds access.

Cc: stable@vger.kernel.org
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
It might also be worth considering whether check_xattrs() needs a similar fix.
I'm not deeply familiar with the ext4 codebase, so I'd appreciate any guidance
from the maintainers and would be happy to update and resend the patch if needed.
---
 fs/ext4/xattr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index ce7253b3f549..b8f1102972f0 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1753,6 +1753,11 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 		size_t size = EXT4_XATTR_LEN(name_len);
 
 		last = ENTRY((void *)last - size);
+		if ((void *)last < (void *)here) {
+			EXT4_ERROR_INODE(inode, "corrupted xattr entries: last before here");
+			ret = -EFSCORRUPTED;
+			goto out;
+		}
 		memmove(here, (void *)here + size,
 			(void *)last - (void *)here + sizeof(__u32));
 		memset(last, 0, size);
-- 
2.43.0
