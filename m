Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B663749E2
	for <linux-ext4@vger.kernel.org>; Mon, 21 Sep 2026 16:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790008189; cv=none; b=PR7BsgiJAaLK+GyWx5nvrnaTP/C4fFGWJB7suqjJfHvVxLe3y+0/QrwTsiLOWJINx2+nMVT6SRu2dZPVNoX4zS7krq6HIzF5wLiY2YnjgODxHVbNdpUd4FnSPkUPiOMINHt7c21fyviyzYkBGHHLLc634vR9KHL0gCCUAeYqbQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790008189; c=relaxed/simple;
	bh=c/5WDjkFhuWzhWzDdeFPCMrN8uCfS9d4paNo3Oa6OCs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EmEOQS8KegEb5g5rYyAmWF643rzw1/WvGskTh3hiSYaS1uhwMOGakPJwwy5Szf+WhmcugfH1E/kxsC7rRl3AcdgxPN/zy7qUfnf2MTJxvB+XYFDL5ANQreV7laZ5ValyV2VQDCM89bKbULEfzWmdjiqoBtMxEAdaly2N+PTqLYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L1vcOWTW; arc=none smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L1vcOWTW"
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910c9ff1fso356284785a.2
        for <linux-ext4@vger.kernel.org>; Mon, 21 Sep 2026 09:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790008187; x=1790612987; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=x5nhm1P7UOKeAC+5GR7Due5qULQR/abe6TZBilAFd30=;
        b=L1vcOWTWyZMLUoHF+u5QM+Yi7tau5uO9jNVUX4zciikDBDYJ9BJVdSswYPAxLTBp6G
         +t3Kqoq3oc/wTgF5TQ7GCod5EbJ0sPj2pSTfr8kHyPpJSUAlyIjE0MErIP/kCJWhvtcY
         NiTguJJ0Y/DrVuHFtL8EpXOVOccmFGdkMjOkz567X+7hSQr1590tCNdZdwcsZERyN6ph
         cA46GJbYGsy02Ie2m9021Pl8amcT9qUa2NrrX6hFi9IGg0XuUKwEKRH+n+IzOqKGrQ42
         m8JUCuXEErStwaZEnbEaGo22IIVXjMcMKAcczwiuZmwzXQxRFCNVc9WzvuMumO5c6Ngz
         +8Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790008187; x=1790612987;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x5nhm1P7UOKeAC+5GR7Due5qULQR/abe6TZBilAFd30=;
        b=xwiWB6MZFxdQCCR3Qrg5dlCdR4VrZXKaQvKzMocB7hJfBVdzNhjbXc5YvcUqivuHj9
         0LOwS07WAT6daiostM7wdUSMfKO9Slq15bEzXe+7Xdy9UbG3RV7KH0bXmR4swsXJxxrQ
         6dchhWUyFNEx1YvCdrum2fQ2h78wudtKm0l9W/c0y1jQxRTrUPgUuYLXL1/GD8STg9Gz
         /tACug7dnDGOVC1+VH90KM831Lk4r5S/QhMwHF2gpAVPbVPBgly8484/JRa1pt1x8UgA
         lZ5C4azso0O5xNsXkoaxgE5ifoku4+0ER/h3GlExdpD0JpDJnSVs/YKpdwiIhH0ch24R
         J52w==
X-Gm-Message-State: AFuF++l8guoT/UFBmVh67Mjt4mrTO3iEjcz5GR0bHRtAPIzidV4vgh/c
	Y+rfXRak7QX8SDAGMm5/LLOTmdIhyO5hK4dCwMMXC8+CzDMh6B6LQHS3hD6vk76t
X-Gm-Gg: AYBFou3bRwGV9+1KS/e8SR7EdUE0bl80zkpMPcuNtjFWLoZpSgNj7bK9P7jRwa68Ebi
	2a4aUE5HueSD7q7K5rm6BNSHfHMiDsVpKbFo1EbIeEnrd4r/sbba4RPLpxH2+hWLa3KVXyAmT5p
	bCHfux4SAuOZo+svVjMnGkvvMaKhNNk+YXdmfYJQqMu+WwWefP2kWNtUQzOYXlJFnMSfFEksE8z
	S7620U3wY0hWGcCNGwo9l80QPZiDVwpwgVbJ2CZUQzYlTgGh1BeoTWqMJir1IHZE/94KXQ8fsp+
	TlDajEEFloD+nqvkDt9rTzZmY1aC72c5rWoA/nJmkcwPSEtQHHaX73Rd+Zduax46DChkmLpBQpW
	qSkNqYBg07hZjuBtc4IS+4kJZWVIXMDBFgEsnMvzyGCvKmqQfM5ab8dldoQJhLmlEjzVz6olri/
	JtOEUMQaVYeBFLu5PobsQ+BzYFsQGVtaAb20M+0XygMVP/+o6DE3zSCEnfTrzmatsQpRyya7lZ5
	0EKV60GOHmZzGan+oaUFwMCxt2aQIRDXR2gpzVZeKQPe4NmrUDun1albDkH2z5IeQSgDnj6bo5v
	6jFX4xaZ
X-Received: by 2002:a05:620a:2685:b0:93a:1b82:495a with SMTP id af79cd13be357-93c15e5b3a4mr133947285a.37.1790008186796;
        Mon, 21 Sep 2026 09:29:46 -0700 (PDT)
Received: from localhost.localdomain (pool-173-71-97-169.cmdnnj.fios.verizon.net. [173.71.97.169])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93beda702f9sm682753885a.15.2026.09.21.09.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 09:29:46 -0700 (PDT)
From: Akira Patafio <kokokoala4211@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: [PATCH] libblkid: avoid undefined shifts and an unaligned read in the probes
Date: Mon, 21 Sep 2026 12:29:45 -0400
Message-ID: <20260921162945.32486-1-kokokoala4211@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Three sites in lib/blkid/probe.c operate on values taken straight from a
superblock, which on any system that probes removable media is
attacker-supplied.

probe_jfs() uses js_l2bsize and js_l2pbsize as shift exponents on a
32-bit 1U.  Both are 16-bit on-disk fields, so any value of 32 or more
makes the shift undefined.  No such value can describe a valid 32-bit
block size, so reject the superblock rather than shift by it.

exfat_next_cluster() casts the result of get_buffer() to uint32_t * and
dereferences it.  get_buffer() returns a pointer into a byte buffer at an
offset computed from fat_block_start, so it carries no alignment
guarantee and the offset is under the volume's control; the dereference
is undefined when that offset is not 4-byte aligned.  Copy the bytes out
with memcpy() instead, which the compiler turns back into a load where
unaligned access is permitted.

Neither has a memory-safety consequence: the shifts only produce a wrong
comparison, and get_buffer() already bounds-checks the read it returns.
This is a correctness and undefined-behaviour fix.

Found with libFuzzer and UBSan (clang 18, aarch64) over a corpus of
NTFS/exFAT/JFS superblocks.  util-linux made equivalent changes to its
fork of this code in 585815c1f8f7 ("libblkid: exfat - avoid undefined
shift") and 9c82a8ca123a ("libblkid: ntfs: avoid UB in signed shift").

Signed-off-by: Akira Patafio <kokokoala4211@gmail.com>
---
 lib/blkid/probe.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index 6a3bb24..689ee6d 100644
--- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -854,13 +854,16 @@ static int probe_jfs(struct blkid_probe *probe,
 {
 	struct jfs_super_block *js;
 	const char *label = 0;
+	uint16_t l2bsize, l2pbsize;
 
 	js = (struct jfs_super_block *)buf;
 
-	if (blkid_le32(js->js_bsize) != (1U << blkid_le16(js->js_l2bsize)))
+	l2bsize = blkid_le16(js->js_l2bsize);
+	if (l2bsize >= 32 || blkid_le32(js->js_bsize) != (1U << l2bsize))
 		return 1;
 
-	if (blkid_le32(js->js_pbsize) != (1U << blkid_le16(js->js_l2pbsize)))
+	l2pbsize = blkid_le16(js->js_l2pbsize);
+	if (l2pbsize >= 32 || blkid_le32(js->js_pbsize) != (1U << l2pbsize))
 		return 1;
 
 	if ((blkid_le16(js->js_l2bsize) - blkid_le16(js->js_l2pbsize)) !=
@@ -1461,14 +1464,19 @@ static uint32_t exfat_next_cluster(struct blkid_probe *probe,
                                    const struct exfat_super_block *sb,
                                    uint32_t cluster)
 {
-    uint32_t *next;
+    uint32_t next;
     uint64_t offset;
+    unsigned char *buf;
 
     offset = exfat_block_to_offset(sb, sb->fat_block_start)
             + (uint64_t) cluster * sizeof (cluster);
-    next = (uint32_t *)get_buffer(probe, offset, sizeof (uint32_t));
+    buf = get_buffer(probe, offset, sizeof (uint32_t));
+    if (!buf)
+        return 0;
 
-    return next ? *next : 0;
+    memcpy(&next, buf, sizeof(next));
+
+    return next;
 }
 
 static struct exfat_entry_label *find_exfat_entry_label(
-- 
2.50.1

