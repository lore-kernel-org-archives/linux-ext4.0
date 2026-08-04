Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665AB175A99
	for <linux-ext4@vger.kernel.org>; Tue,  4 Aug 2026 04:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785819338; cv=none; b=T/W9OKhjinWlF1UyhRspgyhf6RsbZ9P/sbDe3+Jj6rO9Owa3r3WBwmbptxDiS0X2eJiatko5zKP8APYB8MaKpDfXd26o8sCsrpLVB5d+jXbNhI2xd+OaQxoCbOiApCT2y+UxXx+qakF6lbEKuvRa4oAfQjeYNJ2738EWFcQQb4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785819338; c=relaxed/simple;
	bh=iV2nAHfGhDwkMGCRqBFtmMrC9pjdP1du9lckNNaqVYk=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=MhwHHL4mDIbTPFu0PWcGQHsXj53jV5LJEGUgNBFj6xoHKd5lGTTSZwpk3F4/lbub1Rb+avENI7+ARE+nHpDqR6tNFlmCuzQ8qYu4z45iOl+GBHO3kIeJzFCd8vXgOBaTP18sUgOiNI+A1tAaoq1IRNToDH0kdWaDL3Oe7MBehHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lDz/9Vk7; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lDz/9Vk7"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cf420670bbso3680685ad.1
        for <linux-ext4@vger.kernel.org>; Mon, 03 Aug 2026 21:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785819337; x=1786424137; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LjdXQJGz+lwElkC0697Bamhm02fodNd9qx878yCNFEw=;
        b=lDz/9Vk7B02QQ/3qzDtk5wA+6SdRLexqNKSDu8o/SEmqwbi/xZQX/yfMKBtPFbclYc
         sisXmVNEBL+2QBhBtxf0tOa9B8RGfHdBdGBilMiVcAKHF0te9p65M+XL7R8L/CJNq+Ij
         SjAYAi5rXidj3s0nRdhMrUi0tU3uhVJd/T9Yd4od2A8V17O+g4jZ7qgr2kwRkyBUPanN
         vGqS+IlvMEyxUJP1h6Gm+6bHxUURLKev8Q5mpPp5MQw9o2GZ3DsGSvUaQJl/3IwBZKoW
         Gtfv8EQcNMfPFr2wgbf90dG2r8PKdt9K3oe040gQz8mfG0t3QmSafMzeY/I2V/0ntzZp
         ykmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785819337; x=1786424137;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LjdXQJGz+lwElkC0697Bamhm02fodNd9qx878yCNFEw=;
        b=Jx5Rb7r54t+o9RzFyoEjh0Vib7gxxBKJL+AmAQBiVnjDFtG3dckbTl9Tybu2l7XWfC
         S8prDZRefFpGAqrjpNj+pE4sK3JEyoH9HSbZX9hDYntvF8LqUw2Kb7fH5IFAeJXcodsx
         Kmo5c0Z3Lm/9fxL4MjQ3fzOxO/Pn6mnG5oAO2krPNIp+Zy6YIlfDcX+DJiI13JpTxvgg
         f8CA/ZNM7zYSrblcXRbXaSkvfpQOij6j5MZTLs5qFm9NQfyo6azDpkfJe4qdbxm//v5O
         XMMhjpLZlNQ9pCz46JWP+jAO+UDhPk0FwK1nHX0JWqs/ABONm7H7Kub1vMr7mVOzU3xS
         nEaQ==
X-Gm-Message-State: AOJu0Yx5MCLrC77T9HDcGhBsqTfw4tdQDlKXvlYdOKicqC797TZtOWFK
	qD9Ul891nd0m9DCiJ+6+0uYZgu1UIK4Hj2LFG1VEAfmQt3/xzpMGZWrj
X-Gm-Gg: AR+sD10+mhT0EC41fN/WIJ8pBTqLI5FmQLB4i37LIaFRJo3KH4JFNQ+Kxnt3Pii7nCv
	aHmC+tJAJzrrASjGqzsgwfXc+spRrG9XJiZzMBI26g4SPDqwmIfcdC15kroQbqq3qd+nQFG793/
	jIkSXGERUbA78FbF72Sqbaf2mehu1LjV21ets6kpUrRGKJH1SP3iLcJAljV8APZle2FFDjx4f8K
	B2kuUvW4HhPdpB35EnCe9yP/brRPr8cvLeq7K9wIR1fYNSYEkY5TdesEsJVbl/XMVevYGCr+zBv
	7GAewMGy0I7Lb3zmXam8FnpxdhY/tQxi4k+icac/1H64Gi9dkczWwU70rH/tgvTEngh3twh0FjU
	ln4Fg8ZkgOYvQObSnV+8CSgKhQcCUFB3WZ8ZZ50SD+CRu//TBA59BnnncSdLiQP2swiR57NsLpm
	Visn3I1EmsQWD9N6gB+77QkzRrj/aQ73twzEqMe2ApEXfla9USk0tYqaPHM1OBwPzge9gltGGGF
	g4BrTNVY6clQw==
X-Received: by 2002:a17:90b:3a10:b0:38e:91a8:fb85 with SMTP id 98e67ed59e1d1-38fbc507730mr15816320a91.3.1785819336654;
        Mon, 03 Aug 2026 21:55:36 -0700 (PDT)
Received: from [10.70.111.138] ([202.189.104.49])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38feda512f3sm645617a91.11.2026.08.03.21.55.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 21:55:35 -0700 (PDT)
Message-ID: <65c955b0-716b-4599-b925-59c2782e38b4@gmail.com>
Date: Tue, 4 Aug 2026 12:55:33 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
From: Junzhe Yu <junzheyu1@gmail.com>
Subject: [PATCH] ext4: guard against NULL s_group_info in ext4_get_group_info
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Resend: previous attempt was rejected by vger for containing HTML.

==================================================================

ext4_mark_group_bitmap_corrupted() already treats a NULL return from
ext4_get_group_info() as "nothing to do", but ext4_get_group_info()
indexes s_group_info without checking whether the array exists.

During mount, fast-commit replay runs inside jbd2_journal_load() from
ext4_load_and_init_journal(), which is before ext4_mb_init() allocates
s_group_info. Replaying an FC UNLINK for an inode whose bitmap bit is
already clear takes:

   ext4_fc_replay_unlink -> iput -> ext4_evict_inode -> ext4_free_inode
     -> ext4_mark_group_bitmap_corrupted -> ext4_get_group_info

and faults on the NULL s_group_info base. Userspace only mounts a dirty
ext4 image; this is a supported recovery path.

Return NULL when s_group_info (or the per-block grp_info row) is unset
so the existing caller check is effective during early mount.

Tested on Linux v6.6.145 KASAN: crafted FC-unlink image previously
triggered KASAN null-ptr-deref / panic in ext4_get_group_info; with this
patch, mount succeeds (EXT4 "bit already cleared" may still log). Also
observed on v6.6.144; still present on torvalds/linux as of
f5098b6bae76 (2026-07-26).

A self-contained Docker/QEMU reproducer (craft + mount + patch verify) is
available on request.

Signed-off-by: Yu Junzhe <junzheyu1@gmail.com>
---
  fs/ext4/balloc.c | 4 ++++
  1 file changed, 4 insertions(+)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 3a2dfc5..80c81bc 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -329,9 +329,13 @@ struct ext4_group_info *ext4_get_group_info(struct 
super_block *sb,

      if (unlikely(group >= EXT4_SB(sb)->s_groups_count))
          return NULL;
+    if (unlikely(!EXT4_SB(sb)->s_group_info))
+        return NULL;
      indexv = group >> (EXT4_DESC_PER_BLOCK_BITS(sb));
      indexh = group & ((EXT4_DESC_PER_BLOCK(sb)) - 1);
      grp_info = sbi_array_rcu_deref(EXT4_SB(sb), s_group_info, indexv);
+    if (unlikely(!grp_info))
+        return NULL;
      return grp_info[indexh];
  }

-- 
2.53.0


