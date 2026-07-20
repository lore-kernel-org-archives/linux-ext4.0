Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6613B3C1F
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2026 06:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784530524; cv=none; b=o0Pa0ucNtTMsZkZZAe2d7NQ6Ar3Zgsh8Joippy2GZEaCfCleExmODg4SCokmd61HUcbVGk8PXCvca3Dh6DYb9YmSsYbm8Ws4Ydo6ALdnu1/iHmFfb/e399UXijJ5EqK+2FAx9y0mffaqlCMaE6WC2of5/F/Q0WcysKjDs9JLpqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784530524; c=relaxed/simple;
	bh=W7ZYjjP/Jvn9R55ZRQhyN+Oi0wv97eiYtUx5k3Wlk00=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YqKIvZeUNc2VjaIXhqkHfXDFCDqsyUMblOEVMQXGPPxbp0siPzrw4Hc5NdS5FytRmN8PuV2cSH+VqEr3i6aX43+f3B3EeQlYdr8BFyiCwpKMZV6bd7Wl+hVS4vKkeTgIxVz1hTMgJJ9/9Kc5Jx6MVDhYn5j4JyPqP68N0gIfBK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S3+QFL7m; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S3+QFL7m"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2caced6038eso46930015ad.0
        for <linux-ext4@vger.kernel.org>; Sun, 19 Jul 2026 23:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784530522; x=1785135322; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0p7pbJ0cZ8Uv0TYgYDuze87535aan42INqj1pm0xIVw=;
        b=S3+QFL7mZvZQhifKwWinssEyPKCFZm/7lBrV3cX8fPwsD4UV4tNfodsPeu5f4OReNW
         bRCQXPtQiy1wRIBgmYYugy753eTE3eyA2TwbZMhQ7r32c3hQsdURbdpMIDbCLtcKWp3F
         sX5ylfYzNks5MtxSRQwMOTzyWyKaKwfGNMAC4f636EG37ha1D6DDLy6kIyDrFJ9mp0Jh
         li9caawzXBZhV2EdG9nlXrRIzb/iminmiVVHDLriibb/+Ar8K5NkJQloGukUQExlHvxH
         b52i1ntfPVtmDruxix+yov9nSX30RNazaPQwth3+lIhI9PTVMf3oexx+RqBxvrECks2W
         10fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784530522; x=1785135322;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0p7pbJ0cZ8Uv0TYgYDuze87535aan42INqj1pm0xIVw=;
        b=jj7HZ5Zv2/sHqVWe1LXIuF2YO0yw+kjlLSVtg/wRiwXJH4QoJyoCvgoztE0fN2bqop
         FGxZZUyRsm/icVU8m/yVYIuOHq/4IWPidoQYOww5LKAawc1ZUAzh5Zb3WFwlfgFqLEzp
         DZH+QG8qx0CAIiWEFabVavlR6MY79ZViGt1hxxwDP971bMhl07brFGN3iJhPKOvZKYK+
         UChc7JErejxotRkjMUUmzDuYd2RG8Nhkrqd/p8zleC5q+DWbCZWZM4d8Ez+Y8aWxluPv
         HkKklsPA/qJRjJgckm9GKCjdWfSrIdxslecuVz//5iBvhlTwm7j4LqGKIlfya8/lOtRZ
         z2Cw==
X-Gm-Message-State: AOJu0YyDl1PIc8ew5lKpDHHIfdGQC4TkbmXKqGRAwrHCAOHLrlxiAWzp
	upMGIZaKYzoUH40bnjNbSfPczLas+Q6ENsQb0oujGNVh6o3PMA3ZjnH2
X-Gm-Gg: AfdE7cmSH+mQ6DYRgi3QAFpO0QMIqhLmi5riZm5BFHlIr1DOToz8dg8eAPSEZD4orwh
	IESCMUFQY97km86tlXM5c0GxDWm+ZgXt4UpjgZiFJTLORRIZwwP8P/vq4fyLgysz9KK2zJ4CtY9
	RJP4reQp1LnfNAufaJVt0AmLPhg3EiJnL8HR9XfRJSs/Unf1cTNKwfjX3eJIy4wiN/DuXoA47EV
	ljQbJD4EtQ3mnYoBKzE0WuMAOM5HN4KxFefLsXlrGAtdlxEQpa2t6ohof6A9IrvGF7pwuYHX+LA
	5HGJqLe09aqabz6kJoDVQ2N0Uoo2/8ZxBxhEWcmSZgt3aCYvHL0VyxqtHwwu/4o2FxMidR3U1gc
	sum5hLEkNRmIbTD5R/uEWBH1Bk7a1wey2Co0jPySmW4QUIjnAQz8UYFPbPoovNe+pBhGkMTDzLc
	Plmg==
X-Received: by 2002:a17:903:2990:b0:2cc:bdb9:3c04 with SMTP id d9443c01a7336-2cf1f4b9bf1mr173789445ad.17.1784530522497;
        Sun, 19 Jul 2026 23:55:22 -0700 (PDT)
Received: from tradnomic.. ([2601:646:8300:7570:f139:f861:e318:4f58])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347119dfsm51034595ad.56.2026.07.19.23.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 23:55:22 -0700 (PDT)
From: rafad900 <rafad900@gmail.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rafad900 <rafad900@gmail.com>
Subject: [PATCH v2] ext4: fix race in ext4_mb_check_group_pa
Date: Sun, 19 Jul 2026 23:54:59 -0700
Message-ID: <20260720065505.4019225-1-rafad900@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ext4_mb_check_group_pa drops the reference count on the previous
best PA using atomic_dec(&cpa->pa_count) without holding the
cpa->pa_lock.

This causes race with ext4_discard_preallocations() which checks
pa_count to decide whether a PA is still in use. If the pa_count
is dec between the check and the discard, the PA can be freed
while ext4_mb_check_group_pa() still holds a reference to
it.

Fix this by taking the cpa->pa_lock around the atomic_dec.
Similar to pa->pa_lock which is taken outside of the
ext4_mb_check_group_pa() function.

The race was found while testing a change related to a
Coccinelle warning from atomic_as_refcounter.cocci. The refcount
conversion was found to be incorrect but the change had revealed
the pre-exiting race condition.

Signed-off-by: rafad900 <rafad900@gmail.com>
---
Changes in v2:
- Identified correct race location: ext4_mb_check_group_pa rather
  than ext4_mb_use_preallocated (the inode PA path already holds
  pa_lock correctly)
- Dropped refcount_t conversion — incompatible with PA lifecycle
  where count=0 represents an idle but reusable PA
- Added spin_lock(&cpa->pa_lock) around atomic_dec in
  ext4_mb_check_group_pa

 fs/ext4/mballoc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ed1bd00e11cd..c9a118ae4658 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4833,7 +4833,9 @@ ext4_mb_check_group_pa(ext4_fsblk_t goal_block,
 		return cpa;
 
 	/* drop the previous reference */
+	spin_lock(&cpa->pa_lock);
 	atomic_dec(&cpa->pa_count);
+	spin_unlock(&cpa->pa_lock);
 	atomic_inc(&pa->pa_count);
 	return pa;
 }
-- 
2.43.0

