Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793585036;
	b=urU5bdOej8DIbs97dFiZ+D62WkSZBqBDlKTfjH4OzTnhOY4ACbJKEeOU6iYeyxWTNIcY
	 4tClBJCZdf7iV2PtLfc/hAYeNaaiobGyUqWBH8Y9Xc1T1iivfeqYIrGg4ZhL6dG+rs34e
	 bf59uUd0JO5xWho6fi/PbvS1T7zhZHdiNNEqwN3SHvo4zCeje6B6ZvYHB8Ro559ipqI3f
	 TTL/f0mW1FJWqOytKhgA6/NYGlfnYiF2i83SScVJanJbLnkQWuRHDjcLVkv7N3VaNMFhS
	 /FAfpGDolMiiVP0qe/buoaZHLJkiUFaJh/u/bRIo3wQQd+PKzNpGCp1tMM938Lt7zqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793585036;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer;
	bh=+wjicLxXLe0gzUFdN1SPp+yYA5R4cKA9OIuHvIpazYc=;
	b=F8F5zngQzWTl0FWSHWF2zvlDQINVMd3czCzv3NU7VhnVS876+gM37RGpJY52dVhECu0A
	 uZh9FbPe2aetABUn0iCLvYY3tGFrLM+1LBkP3U7H3zZB5VgKJnVQMIpNi5mIiAlpHxNsH
	 anni2dufCIJHzq9JIyN2wZp6VxQQdIwH4eyGOKiyEdNMyUqWf1a39akVFTxXiRki7DTQO
	 ulUwrpkdcSsT1z2wTtsxHYWPTLupCGzhVCKOEcsgjRFy0niEYTtIbluKZAQSYDywDa6mt
	 Qihp07V4op1JIzPrBw8PzBs8USfuxh5XKOikCuoPZ+eN+ohdrvrpkTDApgGI0ARHD7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=emRaZmZY;
	arc=none smtp.remote-ip=74.125.82.42
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06A6606A32F
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 02:03:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A06A6606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=emRaZmZY
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1adbf62dd31so2508183c88.0
        for <linux-ext4@vger.kernel.org>; Sun, 01 Nov 2026 18:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793585035; x=1794189835; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+wjicLxXLe0gzUFdN1SPp+yYA5R4cKA9OIuHvIpazYc=;
        b=emRaZmZY5iNJQfmThWHmDzHUsSjvyThqGyel7vW3dwMxAgvjMYzooaZcAat+yDQERL
         QIPkG9UHkqzHOqRevQHzKd4OGmAQPuXxObczt5TGBlOxcreqHxjZysw5jfYGiHKPM57j
         9u827Wr3MiNuC62iUQfL8sUlbTe24GA+VrCeKXDuNiLgh3CxuiM//GYjhPbDOdbmsgkm
         jVfSJB4T4x4uUZjpZSepRsC/WybtagpYLqmsjDmVO93O2TOakDFR4hudHx40hVeTdGFw
         xsTuCpHnKtbqGPd+qZ9HE0JVsXXob0uUbWlGq4MmMqLWbxKGrV3CX8SfCab33YS+pFmJ
         b7qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793585035; x=1794189835;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+wjicLxXLe0gzUFdN1SPp+yYA5R4cKA9OIuHvIpazYc=;
        b=YDesLWFfh2hX31riqPj2ap4+ppJSkrjFg6OHnxXka44qSPWIPmPix6sf4mmcDNVidO
         MPhr2pH90X8GYsPuJoGJarBbb6J1umeb/fakg7/Vlkz5PYvi43uY1B9evXHzpRS9NNhj
         /Z9HMnThGg7LLhKrVhZXQKhJZ+rIaRvD1kNjS3fOEiolKd50ZoII73PeX9+uzRtuFJXh
         hVwgpxbbLot0FswQzAxNiVxtvY8aEFL70oOHzGTi3NUXBvJgJHLkhQilTDjrhhH8vN98
         MSk60gsWNgJ4gNXH6y0a+u2Tbl3ldBawOtEYuZypzoP8Mj9UeU7zTY8pqrmucdgv5txy
         SFHg==
X-Gm-Message-State: AFq9FYJLs4/AhfNMinETmH+wcJMGNNgQnNOfIfuO+J+Y0znWlGA2KyX6
	0KeE/VvlCgAmDF8drEH+tT2ZoWkjLGHeoxUxAUrIGCEctVitjRLYnRGq
X-Gm-Gg: AYBFou1jDzKlCDhWiSY7i9/UFKOQbZnZQl7DCObSIq5xk3O6KvOSBDOmDoCHwaUqro0
	yRGtaCDuQOZICCyNR9AZoRqGtq55tTlxAWLNSP9opsdz11yo9gwRlXhSPdHAEJadL2jurberR9h
	dH659M6KuCkpvoMOCRsIEaSTL1uW6Whi0JAmwoWaz8Ie14VixNYtujbS0oFqnmhF/2gqhr7eM3S
	mNPCGaI74jy8llq+UYtzT3hGzuJiXUnxomoM5CDJbM0z1e1YuCMLGjIZvl9rp4uqdb1eFhCBwOT
	swEvMpvjsyO52ohq4xbfzOxz8v7xdrEOHHv12UdZlXed6Y82PmQR82ZN5pHXBMt5XkDd6Z7xK1x
	mpYurulaeA4ObNuqVQiFZhgSx2KYzhoIA7Wl44cofimkLF/vCbscqzz2T2KRsjUurwGu3QHuwnm
	x+IuUit+DnAtssALxRRtjgp1DlB0bm26h7t0G2xbxbxFzXAwNxXlsptaTBAEPRd/eDlCXbB9m9o
	CB7NvoIIuCj6cEkF6ASt1LHRa2Vq31KsbxWUArd9HJIhWplq+K7J/vQuc6KILC07y/9nDHGLjM5
	9aqt12EfkpNDl1HXDgJPg43wHd+8gcBPngHW9sjZ0YP0AA==
X-Received: by 2002:a05:7022:258f:b0:165:dd90:1f54 with SMTP id a92af1059eb24-1ac5eea0384mr17582931c88.47.1793585034818;
        Sun, 01 Nov 2026 18:03:54 -0800 (PST)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1b38ac58sm28456015c88.23.2026.11.01.18.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 18:03:54 -0800 (PST)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Sun, 01 Nov 2026 21:03:45 -0500
Subject: [PATCH RESEND v4 2/2] ext4: remove unused locked_ei parameter from
 __es_shrink()
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261101-fix-ext4-es-scan-nr-scanned-v4-2-1290a288f5ea@gmail.com>
References: <20261101-fix-ext4-es-scan-nr-scanned-v4-0-1290a288f5ea@gmail.com>
In-Reply-To: <20261101-fix-ext4-es-scan-nr-scanned-v4-0-1290a288f5ea@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0

__es_shrink()'s locked_ei parameter exists to let a caller pass in an
inode it already holds i_es_lock on, so the shrinker walk can skip
that inode instead of deadlocking on write_trylock(), and fall back
to reclaiming from it directly if nothing else could be freed. Its
only caller, ext4_es_scan(), always passes NULL.

Drop the parameter along with the two code paths that exist solely to
support it: the ei == locked_ei skip check, and the trailing
es_reclaim_extents(locked_ei, ...) fallback, neither of which can ever
run while locked_ei is always NULL.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/extents_status.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index b8821b93693a9..77786111ce59c 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -184,7 +184,7 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 			      struct extent_status *prealloc);
 static int es_reclaim_extents(struct ext4_inode_info *ei, int *nr_to_scan);
 static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
-		       struct ext4_inode_info *locked_ei, int *nr_scanned);
+		       int *nr_scanned);
 static int __revise_pending(struct inode *inode, ext4_lblk_t lblk,
 			    ext4_lblk_t len,
 			    struct pending_reservation **prealloc);
@@ -1670,7 +1670,7 @@ void ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 }
 
 static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
-		       struct ext4_inode_info *locked_ei, int *nr_scanned)
+		       int *nr_scanned)
 {
 	struct ext4_inode_info *ei;
 	struct ext4_es_stats *es_stats;
@@ -1707,7 +1707,7 @@ static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 			continue;
 		}
 
-		if (ei == locked_ei || !write_trylock(&ei->i_es_lock)) {
+		if (!write_trylock(&ei->i_es_lock)) {
 			nr_skipped++;
 			continue;
 		}
@@ -1735,9 +1735,6 @@ static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 		goto retry;
 	}
 
-	if (locked_ei && nr_shrunk == 0)
-		nr_shrunk = es_reclaim_extents(locked_ei, &nr_to_scan);
-
 out:
 	*nr_scanned = orig_nr_to_scan - nr_to_scan;
 
@@ -1782,7 +1779,7 @@ static unsigned long ext4_es_scan(struct shrinker *shrink,
 	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
 	trace_ext4_es_shrink_scan_enter(sbi->s_sb, nr_to_scan, ret);
 
-	nr_shrunk = __es_shrink(sbi, nr_to_scan, NULL, &nr_scanned);
+	nr_shrunk = __es_shrink(sbi, nr_to_scan, &nr_scanned);
 	sc->nr_scanned = nr_scanned;
 
 	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);

-- 
2.43.0

