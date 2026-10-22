Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792681867;
	b=FG+zNNslHVyOxgKEyq1wQ3AY/NPToQzCW9gdP0JF+FYAXa9k/qjziGR9MuMqRuxcw0Qs
	 k+s8HjMKepxS26iDNudhPnRAGV7eyh94U2TPI9bB/kFE5xsM9MXRlZPBATYsodvQf24KQ
	 +aVAJ4vCMOMjEUEFFcvbSzbAd4aatR4AC2lONg7woBTmn0UNcuQ9scPAkCYBmdqFzUIsY
	 0NWX7sjd+LBjwZHjCM3fwq4fsgHZ851ZTUe7EAqTYvgF4HIpopRcZzkVfck/1B/BWydMz
	 +1WzTFeikNGMu4KDqmT088H1N8x2PVhut46a/z62R1yw364guZaPlCluV6wbC+X2Q1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792681867;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=i1MeOHbnAz2XPwWKD4K6nVWG0NQK2yC/K+u8PITqSic=;
	b=eLKgV5pID1HA2vwvn620XAWgI+lr1BKdHY/eMX5A+3ytjmVNU2g05dkhveUlxHBUg7mE
	 DBsdgfgxuqOLau7/+B9TFilVyxeHzDBoE8XNSFiIIbbFrYZz7RIlkH1nI6ovO7zTDvd2o
	 jOoG6XpXrMx/XHQDZr4qbOa30ECW7WRAwNI7ZXL7VlCtA+HPtaZEc45PUnVDaWPKfhhuU
	 UjlJxf813Nd8pOuD6wRJ1l4rKnyoMh0TNzXF2hAE43RWsATUgIfm7GbnMpaRt3rkklmdw
	 QEOn9FOUdTnhqHI9RRK+YcCh3rl9eXWqxjo0bJ53rtgmnw71DHUM3foA/YD3hmglITA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=QQiWhdcO;
	arc=none smtp.remote-ip=209.85.214.176
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3BA60A3819
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 15:11:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF3BA60A3819
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=QQiWhdcO
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2db80fcdf8bso12822335ad.2
        for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 08:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792681866; x=1793286666; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i1MeOHbnAz2XPwWKD4K6nVWG0NQK2yC/K+u8PITqSic=;
        b=QQiWhdcOZkKyWl6XXEFD9Lolk9XRmurX2n9NKNyxwt3UtMGTBnA9he1YJQtiykyX50
         hMqRwks86LPfooKudsXoAlSME0yLsrcRKCh0VEGOWtBa8OfnSdtO1rj0efp1N0FxgiYX
         3j6pwkpfkM43npgcn2LP0F7Bll1x67iVcSNCbhMx7+xYaZW8WHUQ25oPEVb9U43I1gL2
         uvv1p4W92mr92/XCfQsKH8QcFJR+xvskFeDcWqMVQbAlwf5b6JxamrX17aLPyLm1chbQ
         QxvGushkzEHH8csApGb3KOTUYGCEW/AX+GlmENBUGrf73djoVvk04CCZbijlS8WeFue3
         F47Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792681866; x=1793286666;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i1MeOHbnAz2XPwWKD4K6nVWG0NQK2yC/K+u8PITqSic=;
        b=lTFSr43Sdt+ZqpNKKci1a9ZwwqdnuQeUlJVedRYRkQUAchegdV/YmZZEzCYBvHXh/j
         a47xIIboUNZi1bShNcyvXHtPdu6m4RFPosEwN6kHGpgAQn2ifQqd+hPEeeGO3XK4BvTd
         8yVGek90lrtHEwFXlMpE4tSZuCpEo4k4ZcZ8QFmRTdLVLtnaTXdhxCFuyYnFjFwuLFAm
         YapAjMNnc3qhLyUXOaY2wlzRFBzlAmnd9QYDK4UaQXTSLMmxEBMVxQjufDwgwsYwZhHW
         /1NrA3xFIHb+IF7/LWa6Y/DeGSbp3+jdV+Q6BYwa7QLoW7H3WSnpoMxbiy/+hRlV4anT
         v5Cw==
X-Gm-Message-State: AFq9FYK3Sq5YCvphPXk+fOL/dRu0ryfAjmqwZnxBJDUNmwczHNYlw3OJ
	+J5o4y4IwVTDekeaVp6Qezd9+HZXRQdySG5saXI1PkkkNwCf4y9pYrOD4iqC2LI0xOqhUEXDdi8
	h7zqJrk0=
X-Gm-Gg: AYBFou1wqUPd/bOQfZskkMhuiczJ0oo9uVy/ONHbbcRzMG3tE92/FtlZKiDPD+QIBkT
	8LcOIUmIfANQ3QCyvb8rPMwivJwBIjzEVqQKX1NlYMaWOe9ysOOVc6GSDIZ638Rz/4cqfkXM5/J
	L/xN3palyvOTAEYYub0TFuRekBK94rjqI7z96HdtjIdUL7J6xfD864PTtY1OWfGlLQXGm+j3RYx
	XV/SDmFWgZ2XOFLd5NeYAIs2yP61/n/r0vXXetsGjB/uva6QAPiDo6QwXEf4AvzUJo+Lf6fjk9R
	iz+xvsQYW+qeMAYfali4olf9cJ84xCsu5nJOdHlhyTuEDYVqklZffGSOplfL9F8wXVevstFN893
	Ct4yje3k1Sza1nkJ/J5NBqtzscjs5kuiFhOOGUALi/CEushPqtw+zUKhVk+PGRrJ9dKZmykLUPr
	QDY4YdyX34wvNvR7DOVmy1nRUTi9OAitkUxhCAOBSU/ohYUdHTrxiTTZWaTrXwbLTrjwFNgDzCB
	i8SeJjVXNcm4za1/NoIpfCMLUVfUlTJz4uwrEOgBtd2y21P+Y9bHpxoXJs=
X-Received: by 2002:a17:902:ccc8:b0:2e9:8202:5083 with SMTP id d9443c01a7336-2ea43d2a528mr42018815ad.55.1792681866041;
        Thu, 22 Oct 2026 08:11:06 -0700 (PDT)
Received: from localhost ([106.38.226.26])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea3b308966sm25070165ad.2.2026.10.22.08.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 08:11:05 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	riteshh@linux.ibm.com
Subject: [PATCH 4/6] ext4: put folio on partial writeback validation failure
Date: Thu, 22 Oct 2026 23:02:42 +0800
Message-Id: <20261022150244.2969056-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261022145241.2950379-1-sunjunchao@bytedance.com>
References: <20261022145241.2950379-1-sunjunchao@bytedance.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mpage_submit_partial_folio() takes a reference with filemap_get_folio(),
but returns without dropping it if the mapping position fails the
WARN_ON_ONCE() check. Release the lookup reference before returning
-EINVAL. Leave the folio locked for the caller's cleanup.

Fixes: ded2d726a304 ("ext4: fix stale data if it bail out of the extents mapping loop")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 fs/ext4/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 534833b13098..90be191715d7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2447,8 +2447,10 @@ static loff_t mpage_submit_partial_folio(struct mpage_da_data *mpd, bool fatal)
 	 */
 	pos = ((loff_t)mpd->map.m_lblk) << inode->i_blkbits;
 	if (WARN_ON_ONCE((folio_pos(folio) == pos) ||
-			 !folio_contains(folio, pos >> PAGE_SHIFT)))
+			 !folio_contains(folio, pos >> PAGE_SHIFT))) {
+		folio_put(folio);
 		return -EINVAL;
+	}
 
 	end = folio_next_pos(folio);
 	mpage_submit_folio(mpd, folio, fatal);
-- 
2.39.5

