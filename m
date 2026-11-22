Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795373831;
	b=u+BrZAktO0mkyDmqL1nVDyg8rUTYevyIKcUU5JPRfdjXQr6Lf3K1lvQptNU4WV4P9CsL
	 lQ7PlJkDtokwwfK99EHIzo9Lzqwcdf92hcYmF+ha8alrE+QBYEimQeFsFtTq7+C9ITfMc
	 lfyV2IscYPK2YocFWdM4OSbj/bPOoXhZDh8XWEYk4zbEnT/J3odCEGdZCg4TjMJ4kl3C5
	 6WCRCTwjrDnCnJHdwkopWmgkYZI2q2S0vwgneQoZUhkeg/0OkqegL0wl0IMVK5aZtDwBn
	 9cdyR/A6eNMCRG68vyz3kusVRiZranDmh8Cto39sNX2P2VXB5wQ0LOreAZV7E7ixioQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795373831;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JzuiHg+IAobWVPJAcA8im9HNPpCPGeDwGM1r85UH5Js=;
	b=artx1PGIbq56SwB5LP49hqQ4xShdTrmp3PdHejG7CPvjQdF7hiK4LvavtE7o4tnUeQic
	 4lkITDP5z1aKbzUpy1DncektA5V9CLMFByaWgDOQep2TBC4enVi5QOOiSKO1KWRLBbhSw
	 cafUDWKKZ15g5aMM1y89SdBP7jxwaRhscSzyw1NnVROv8BhdNi9FVeE0KwquF3ZhDdm5m
	 qdJOPRH95vSt3X8QfhJqSMpOAa09a35bKEdRoTDeGsC94PO1g98b5er/PP+suM4uuPKcu
	 J4PbR7ePkmAYbBd20BtvWF80sn9GXIFtDvruIivP9HtHAoY3QM19bKO8E5m2Uj0om8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Ykwr/nMS";
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5716606A320
	for <linux-ext4@vger.kernel.org>; Sun, 22 Nov 2026 18:57:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5716606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ykwr/nMS
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso17889515e9.1
        for <linux-ext4@vger.kernel.org>; Sun, 22 Nov 2026 10:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795373829; x=1795978629; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JzuiHg+IAobWVPJAcA8im9HNPpCPGeDwGM1r85UH5Js=;
        b=Ykwr/nMSAnQ4LXfwHK+HR4zgm6lfAkpkJ1YlHILfaKdgOXmJpuGEj2ued7Ap5Q293M
         IFlfCpd3aYO4pfFZqXTYHapYcKu4KOh9tWJMh8V9QhLoBANYBtMdMjMN56jwSeiqF67f
         l6cLl9ncB87b9Wwz10eCUwon/mKFHNU9xY8MLxvloC0VVIq/XS8r60bU73CwWDl5Z2zn
         NAOA8B/M1QIuUa2znbF3pv197idiNGj32sDoJVa199M+gjboKWrwxgf0++NXZuI9Oxp1
         l3xMk/YOJO7sg9ZczSrzYRZDrfHInn/2/svZd4OSumWIP1CZW6nv8a5IMuXRkgdnAcoy
         zYhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795373829; x=1795978629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JzuiHg+IAobWVPJAcA8im9HNPpCPGeDwGM1r85UH5Js=;
        b=cdJ9z74Qs3uR3WEDAgOZmLKSyluc9m1ZmbrlzlLIP/0tzf+bBa/xW50uNG9HuBMpeg
         iK44DeD+ZckakD6iAE32gqJX2YSOHiapOBNJp5RnTMNVojxsSVQZ0MRou9LB4xFgvzUF
         84cEepesnqLoejBEfWdZNtqe9NPVDnVerA8IgSjkUETe4S6z+21vWEGTv6c+hn10EpnB
         X8HLzUhFtx05jg3ehZEcg3pvfJDVcGbHUVeV9kBuwXwU1PTogoOLeG0gOhY4HxvkL83s
         VfBvCu9UD5NvXNFwjxoVMuT+ZWgpRU+bmwlrtP9yA9q67X40sQ0Qlt6D7SDu+5HYdlNy
         hGHQ==
X-Gm-Message-State: APuU4Z+LYQLPIopaEfCJmp+FKurwxjzLFyMyt5hiuHR8BgeOsRAY5gdK
	mNvrub9wQCBMPXW7pxONrWnHeo8lRQaA9wzCMToZkIJCDnSV6kM5nGdt20+eYGoMueYZ
X-Gm-Gg: AZFdTZehpMuMP/777ho6CP+wEyOxyUJa0tcrwf26o5eQ+YhV3OxKmYAgixuRfkJFStp
	dx+kA0qaMyjcsUy0fhpEpIMz+nDbagauuEX58mc39TbFTHU6WghOzuVMNTzozA3rztEN0bdQa8R
	3yCzgHDcJXn4Ls7rwmXFETAAg7Uvaa/1e+nI188O7bf2MvHKKxmiPBnM9YfV7fv04yZJfgYW6fn
	ULUel54KU8F2gZBISufjfdtj6A4Qj5fedG0AtwSEbo1NbS1embw2kOKG3VdfRc5qtV9TKlvlXYJ
	w59HsKDODOMRYtUu2xFDt44Mq0d/foU50yjpibtRmhmjsUD+LlOBjPWj+ieeQ7PsgaG5Jn3cJkb
	6VhLY/WoD7HrKwHl35M98qygFLwXJaEHqD3n4GUjedg5yIakutW/NKPiDVLefym6PlDheX1zuyR
	rs32m/ZsSWVE1U78sg/dK7jISiWoPmw0zlSwOIhJOV3N06pXRa5Bk/pmYETGhxL5fRHJTtxrOgr
	l1QJxJex8vj+2WEc3Gt5jeDhgog2MWvbrUHsxnAjQEyla6jtzCbyUipyjyOzJDd9qc5RAeUfs6O
	DzUxh22evgJ7TvqQ
X-Received: by 2002:a05:600c:a0d:b0:4a1:825a:56fd with SMTP id 5b1f17b1804b1-4bb88826c1fmr194391895e9.32.1795373828993;
        Sun, 22 Nov 2026 10:57:08 -0800 (PST)
Received: from kali ([182.180.9.193])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb905f0f1csm113765085e9.0.2026.11.22.10.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 10:57:08 -0800 (PST)
From: Muhammad Umer <mumer.mobi@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	Muhammad Umer <mumer.mobi@gmail.com>
Subject: [PATCH 1/2] ext4: scan all groups before trimming the goal in CR_BEST_AVAIL_LEN
Date: Sun, 22 Nov 2026 13:56:29 -0500
Message-ID: <20261122185630.2112-2-mumer.mobi@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261122185630.2112-1-mumer.mobi@gmail.com>
References: <20261122185630.2112-1-mumer.mobi@gmail.com>
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

Since commit a3ce570a5d6a ("ext4: implement linear-like traversal across
order xarrays"), ext4_mb_scan_groups_best_avail() walks every order from
the goal order down to min_order over groups [start, ngroups) before it
looks at [0, start). A group below start is only considered after the
goal has been trimmed to min_order, so a 1024-cluster free extent in
group 2 loses to a 256-cluster one in group 9.

The ordering is harmless for CR_POWER2_ALIGNED and CR_GOAL_LEN_FAST,
where every order scanned satisfies the full goal. In CR_BEST_AVAIL_LEN
a lower order means a smaller allocation, so search both ranges at each
order before trimming further.

start is rarely 0: stream allocations start at s_mb_last_groups[], and
the linear prescan moves it forward by s_mb_max_linear_groups.

Reproducer: 16 groups, groups 0-7 with only 1024-block free extents,
groups 8-15 with only 256-block free extents. 32 MiB written with 64 KiB
O_DIRECT writes to a file with a 64 MiB i_size (8 MiB normalized goal).
Allocations made:

  start group, max_linear_groups   before               after
  0, 0                             8 x 1024             8 x 1024
  8, 0                             7 x 1024, 4 x 256    8 x 1024
  0, 4                             6 x 1024, 2 x 512,   8 x 1024
                                   4 x 256

Fixes: a3ce570a5d6a ("ext4: implement linear-like traversal across order xarrays")
Signed-off-by: Muhammad Umer <mumer.mobi@gmail.com>
---
 fs/ext4/mballoc.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a15285224..37825743f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1097,7 +1097,6 @@ static int ext4_mb_scan_groups_best_avail(struct ext4_allocation_context *ac,
 
 	start = group;
 	end = ext4_get_allocation_groups_count(ac);
-wrap_around:
 	for (i = order; i >= min_order; i--) {
 		int frag_order;
 		/*
@@ -1120,15 +1119,20 @@ static int ext4_mb_scan_groups_best_avail(struct ext4_allocation_context *ac,
 		frag_order = mb_avg_fragment_size_order(ac->ac_sb,
 							ac->ac_g_ex.fe_len);
 
+		/*
+		 * A lower order means a smaller allocation, so search all
+		 * groups at this order before trimming the goal further.
+		 */
 		ret = ext4_mb_scan_groups_avg_frag_order_range(ac, frag_order,
 							       start, end);
 		if (ret || ac->ac_status != AC_STATUS_CONTINUE)
 			return ret;
-	}
-	if (start) {
-		end = start;
-		start = 0;
-		goto wrap_around;
+		if (start) {
+			ret = ext4_mb_scan_groups_avg_frag_order_range(ac,
+							frag_order, 0, start);
+			if (ret || ac->ac_status != AC_STATUS_CONTINUE)
+				return ret;
+		}
 	}
 
 	/* Reset goal length to original goal length before falling into CR_GOAL_LEN_SLOW */
-- 
2.53.0

