Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A13939903E
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2026 10:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779963682; cv=none; b=hKOGYCcwAxv+1yuGSy0SUpO1DiXK1xgbGmvTvxGNpGOQuD/yosZK9knN1phG4LYQaUOdLH71IfHjJOgiiAw3okMzI2YOFhShNt+b2U8z/mViGjy+DUcrNbzFPxOWttquankidH9my6DCERzFS+ScQDFgOXkyHzwqhVPfLqcO9lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779963682; c=relaxed/simple;
	bh=jI7Cg78izFhc8YwkzdLdR1Hg35pDNSXzTk8tL+TVGH4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=ihFlHFYyLATXTRwcDJWowqJDyfYDP8SQeCfbIV32K1jcLoOzenrZ8hb2eTn3H6wG1R4m05MaiqQ79Ohm1kjcqd93DYFQYq80zRri9mx1h3f3bI0T9DRVcESTmkYcSrnKioaFkGSDvD+Jmr5PStREfQnetkYLzQcI/UfYRUy/2oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hViMuKTK; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hViMuKTK"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-516d0119e4aso64958641cf.1
        for <linux-ext4@vger.kernel.org>; Thu, 28 May 2026 03:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779963678; x=1780568478; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=843k2tDUPYbkxqgPxtYSJoHk8y8WS2/E2oa/7Uhir+8=;
        b=hViMuKTKvFIMvxu1HjuIlf3ZkD+TJ0rNrzf/ombQKk/rVbQ2PaLfxYmKiI2Wae8iUN
         Ex3UE1BRYRc+pI5Bchl1IVkxYWIJ9hiOt6ZiMcQ9C8Cy4mf0qpfOgvsaraa/X2u3IGNv
         v5QLjnYGmhLkxJCgXtul5UuQSSEERIohajkDmTNux06EM9MdM8SICU/nRc6qGPLV1QVo
         sec7ioTJxikaZ4mhtHMRLHR0ZYgYwHB2LzmMfVO9D9vhahMQmky6DSjjGXqAzHgHmNfX
         as2k23GhF16zVLO3xtGe0ikI1/+orCRtC8uF9h0f68G/mbfNG2aa51oxcZ0PQSC4zaOF
         Vwaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779963678; x=1780568478;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=843k2tDUPYbkxqgPxtYSJoHk8y8WS2/E2oa/7Uhir+8=;
        b=TQC6QmbW9gZ/iGGH6i+nl4pEUTqgCv+TA92yCpj4mTZ3NyVEH3ngjc+EDSowaOMdHm
         a17PvgiBacvd5r5ZH8IdH3c8NwWNIK5vs2ulBkaPnFm7vFhTyRbyG/nEiNWqQdI/Fp28
         vLncVfGcrODVxstOwJMepzK6aG/4bCNi6mWE4M/5WySkwPBka7S4rLOJT+GWzLuz1OqE
         V5MITt2M5TSmainDQ2yYX4W7YaRvuzA9satVU0HBrdGg4Qu+dz/hOWtqaRKG9uMCB4aF
         46r5rNBKPAHpQPUb3P83xrgQFmW/xNpcHnDT62dPYtf5D2KanM2DBz4+qhZAuQ3FXqU0
         UdKw==
X-Gm-Message-State: AOJu0YxJmy3xhREiTKodXnNlBKWIaH8VUotYMSY2AA6b1qYYKcI61ggZ
	NH4D/rx+BqscMr9DaZDzznAdrlD85vMOc/ytKA2k3lAgYpjIlxayr+3R
X-Gm-Gg: Acq92OHktkcdJ117atc/XQChWCvIFrzYdZYbO/YA2Xs4Qde6GCT/Z/wQt/17irDzxHP
	uT+ZByo6PkAfSCZrHqS8/FekSHuUnt60deZ2ODrxGn9R5HP/FrD1yeT4BR0K26V+9a/ZH+VsiZm
	2ZeVjAqgykP1Wc4TgNRmst0ib92wbiocnddKYc7YeSdiEC/ySqwkQNtmjE8VaJ3drqL+tdf34I5
	nlc+Pb7NrPbDWMiPIMU//mZc9pYDnLb+/YdB4tiLjY2uniKkFIVmNbBwGegihHMUWqR2r6jcFJc
	K7+z6oB9stLx0DwnEYiWDAmxe95kVF1B/PzUgKLZrZVhGExxenGmITbGwwMsKnSEYm+lGXoFbwA
	W0XlyyEkLyIw5BYB0wwlOjSHqHj0fHpxcZr6XsfODCB1+Gp2YAsHNcsfKMbNZUolr62pe5gJB0O
	AfGW85e908damJ5JVyDgYluyGj12/PBIDVX5itjk6+WzAQhrj04wE=
X-Received: by 2002:ac8:5847:0:b0:516:d83d:b28 with SMTP id d75a77b69052e-51722fe9387mr7859781cf.17.1779963678071;
        Thu, 28 May 2026 03:21:18 -0700 (PDT)
Received: from wujing.localdomain ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccc4e8b923sm35754166d6.37.2026.05.28.03.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 03:21:17 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Thu, 28 May 2026 18:21:13 +0800
Subject: [PATCH] ext4: fix quota accounting WARN in bigalloc punch hole
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-fix-ext4-bigalloc-punch-hole-quota-v2-v1-1-32871356273b@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2NQQqDMBAAvyJ77oLZVin9ivSwJqtZCIkmKoL49
 4Ye5zAzFxTJKgU+zQVZDi2aYgXzaMB6jrOguspALfVtR2+c9EQ5txeOOnMIyeKyR+vRpyC47ml
 jPAiJneWn6ZwZGWpryVLF/2f43vcPbTyV4HcAAAA=
X-Change-ID: 20260528-fix-ext4-bigalloc-punch-hole-quota-v2-2adca315d1ba
To: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Zijing Yin <yzjaurora@gmail.com>, Qiliang Yuan <realwujing@gmail.com>
X-Mailer: b4 0.14.3

When doing direct I/O write on a bigalloc filesystem, the allocated
extent might not cover entire clusters at its boundaries, leaving
delayed blocks in those boundary clusters.  In ext4_es_insert_extent(),
__revise_pending() inserts new pending reservations for those boundary
clusters, and the return value (pending=true) was added to resv_used,
causing ext4_da_update_reserve_space() to incorrectly release the
quota reservations for those boundary clusters.

Later when PUNCH_HOLE removes the DIO-allocated blocks, the
extent removal path detects the pending reservation via
ext4_is_pending() and calls ext4_rereserve_cluster().  This tries
to reclaim quota from dq_dqb.dqb_curspace back to dqb_rsvspace,
but since the quota was already incorrectly released, dqb_curspace
is insufficient, triggering:

  WARNING at dquot_reclaim_space_nodirty+0x77c/0x8c0

The subsequent delalloc writeback then fires a second WARN from
dquot_claim_space_nodirty() for the same reason: dqb_rsvspace was
depleted by the earlier incorrect release.

__es_remove_extent() -> get_rsvd() already correctly excludes
boundary clusters that still contain delayed blocks from resv_used.
Adding pending to resv_used double-counts those boundary clusters,
erroneously releasing reservations that are still needed.

Remove the pending variable and the resv_used += pending addition.

Fixes: c543e2429640 ("ext4: update delalloc data reserve spcae in ext4_es_insert_extent()")
Reported-by: Zijing Yin <yzjaurora@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221570
Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 fs/ext4/extents_status.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 6e4a191e82191..fefe0bb8ac4d1 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -909,7 +909,7 @@ void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 	struct extent_status newes;
 	ext4_lblk_t end = lblk + len - 1;
 	int err1 = 0, err2 = 0, err3 = 0;
-	int resv_used = 0, pending = 0;
+	int resv_used = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	struct extent_status *es1 = NULL;
 	struct extent_status *es2 = NULL;
@@ -977,7 +977,6 @@ void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 			__free_pending(pr);
 			pr = NULL;
 		}
-		pending = err3;
 	}
 	ext4_es_inc_seq(inode);
 error:
@@ -998,7 +997,6 @@ void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 	 * any previously delayed allocated clusters instead of claim them
 	 * again.
 	 */
-	resv_used += pending;
 	if (resv_used)
 		ext4_da_update_reserve_space(inode, resv_used,
 					     delalloc_reserve_used);

---
base-commit: eb3f4b7426cfd2b79d65b7d37155480b32259a11
change-id: 20260528-fix-ext4-bigalloc-punch-hole-quota-v2-2adca315d1ba

Best regards,
-- 
Qiliang Yuan <realwujing@gmail.com>

