Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794487757;
	b=yDVfTuaHeacQm4bWYqSQLpfaiE/fDnX84jKx4Xo75B2Yheaj0KHcF2MXtzisuiF6D0DW
	 Lpo287c7E4JVGiiBsqpxH1WB2lB3JDBqZDDCLAM7UYxQKLkra9sAC4UmrS8pAF48wGC4u
	 g1rssrq44IoyCw9nAk8Tk+PV70z42KcQdZjPkChSu9yrb840yuQKZM6qnBsiN6/9ihRhy
	 B995N5uSIuSb7t0Y/Q3B2x0rdP1I1cIMJjDskaEj02Ix+3AVTVDQeyw45K1eRfkEBJtS1
	 cNlFmJLJabZaEcdb/VUH9g0bT/+6NVNtoIRl681AF+O3bLmMytsoN8RTbaRuKj/kiww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794487757;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GP/sqeTHNOnsr03VKalftM5sm2xJbcWlNAUV3dWIgzM=;
	b=YbTPMQfoRtlKL0bbb+KXbPOxAnBu9VH3FcFP2ruMI0v6YouCJm9OMzvpvHYU6xgIS3/S
	 YlUdj4LQczVljGLgHAytgRfWUho5SiIoTyJtsiV9O+JwA7V8g/bnAe4ZHNcrxWRU6JHOJ
	 dxCyLOIH+9JNJElLTqwu4XeE4dYZO6eNvnXiG8faZDYzTZJzTnKx3iDsLd8MxuBrrAWZp
	 m+563CadOl/UFDUlAPqmhaNpFyKsouby6BkHxqPVmW6off1TwlNbcsnRF9/i3PEWep7oS
	 URJsYdnIl6MJzHEQiiLcJJpX+IikR1U2nZeh9wkMuerek61GpWAYAKFBFuZUr07jUZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tJM+CvfB;
	arc=none smtp.remote-ip=209.85.160.52
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E4E606A327
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 12:49:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4E4E606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tJM+CvfB
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-46556b9e02cso602343fac.1
        for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794487756; x=1795092556; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GP/sqeTHNOnsr03VKalftM5sm2xJbcWlNAUV3dWIgzM=;
        b=tJM+CvfBnK6ez5A+5cixlhaCf14yZlDGolLiXLpu8clT7DjboHI3VkU/tXO5CYOW4a
         6cu6ppRv3kFNSVduw2MoaFjKWB2VkkLoiX79pxeudu1kmJzJ7wqf5zBsGe+Yqgg8k0rF
         TwKlzrBOIRyzmwLdcN2GjvlR6diA6LC0PlAd/3K2RhFVNEm6DfXonXqhYM6PR8B8RZmh
         Lp0keCfCyZyJTEeBENN5cDekv3ui4o3msR8Jg9XEKvwCaMBSzNZPgG5zPT/gEZJZK8Ul
         hW8Iz0kPbPq6ep+x/0XNXRfx+VD4/F/ikFFKTrkZjyEcCek6fYJ9mrPr++OCm/tlONXs
         vv9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794487756; x=1795092556;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GP/sqeTHNOnsr03VKalftM5sm2xJbcWlNAUV3dWIgzM=;
        b=KRD8GTr9xfLSFpiboFM5pecV5d2/Zb8JApCxQP1V1PguVNRKwNkj4ckC00PcEWUx2W
         km4gs4o/ePm6gaMFcSqsr1ffKW7PpA27rpoq5eb0B9T+MyjZRinHwnN6k9HeCVwfwCBT
         NgagMlrgebwclZcWh/zD4f5bphJPWMVCDkG4YK/Lmynm3PRU+O2sDHq3vl6uy96MpG3J
         +iOz+lUuM4r338AlsC4ea8wzf5xnuVGh53D1HmGLraabCW9mLz2rSbfSa2+bwoLaToMn
         CZ8bjE2yxWhbC6qXV4CEK7AhY6z/fGVUtcrwPnukvQ0gANONmheBhmespBNe0OAs/jeU
         J5lg==
X-Forwarded-Encrypted: i=1; AL+hErHaD7m4EMAT5DdI6FAXquxSEfwoVmQiv5HbG+JTsUj5cbCCmjprbOs5J9hwdnk/eElFYpVpJwjAsy2Z@vger.kernel.org
X-Gm-Message-State: APuU4Z/j4x+kaVS/hbEy3zb1gPGjgRuILFt6g9OoIcXhKhFaSLaJ90SC
	0PPPot1jAYlaUwX3W9i5TYacDW/2TTcTPLjPyluE/S2fPvpPSdVlfaz4
X-Gm-Gg: AYBFou2jby7xxURHTgO3aEEAkAje7IDCB2FVjtHp+hXpl5JcHfNQzxFMRfh0XD4MKvc
	W02Ahu0RlGH2XiEo4YOCzUlYn+DO57dvZlhg/nT8nQtMTQ1L9UK29G/P1u0+62HhbfgHaMWn0W5
	IGFfUhJSE3gAlOhELOY4qLZhIfcfjJ1gqtYlKiBalCp2sPjSOQzr0ujrjBPWL/9ozqQmFa6vjK6
	P9boNbwf2WahBWT8rA9XJi+IAiySakwGYoAEAUcJtGk4kZNvvUR9pIp3fgXFhOePy2H0CVHNOI5
	Gx5hU2XE6BhYV16Lv4f5lDN7pSGE7tXX7NZ7CRPXPZX5maEhlUifYNbrMRLLWi5MnmqOWcARGnf
	p0pI84z0/2ocAK9xTTw0lnIn/b4M9bcKdHkZPB03gn495/47tvlV7IlDgcYoGG6cFDnpCzGzdny
	BFV4B77zpVWNHwg5Fcfg2Y2xacy75Bb3wRDuePdrZR9riyaLW0rX0VL+3Ig4kNGWSVjN6rNAG30
	7R3A9ABFI7GV8HbAWRuzOnZR926mAbkimTp1i6ijO14xFIQ0OJoJ91YOdygeOXTiNWEifOO2d9C
	DgC/JX/w1Xp07m/lhb6Pwtpv7YuwD62mvbYu+iA=
X-Received: by 2002:a05:6870:c28f:b0:45e:d645:e03d with SMTP id 586e51a60fabf-4ae63f762c0mr1576883fac.11.1794487755660;
        Thu, 12 Nov 2026 04:49:15 -0800 (PST)
Received: from TheRealOne ([152.58.138.3])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4ae23031a4dsm4819028fac.14.2026.11.12.04.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:49:15 -0800 (PST)
From: Chandradhar Kumar <chandradhar.2003@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Chandradhar Kumar <chandradhar.2003@gmail.com>,
	syzbot+f111db4cb2acd44eb2f4@syzkaller.appspotmail.com
Subject: [PATCH] ext4: wait for tail page commit in ext4_truncate_failed_write()
Date: Thu, 12 Nov 2026 18:18:32 +0530
Message-ID: <20261112124835.114888-1-chandradhar.2003@gmail.com>
X-Mailer: git-send-email 2.56.0
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

When a buffered write fails partially (e.g., due to a user page fault)
on an ext4 filesystem mounted in data=journal mode with blocksize <
PAGE_SIZE, ext4_journalled_write_end() invokes ext4_truncate_failed_write()
to discard newly allocated blocks beyond inode->i_size.

If the updated inode->i_size straddles a folio whose buffers are currently
being committed to the journal, truncate_inode_pages() attempts to
partially invalidate that folio via ext4_journalled_invalidate_folio().
Because JBD2 cannot unmap buffers belonging to a committing transaction
on a partial folio, journal_unmap_buffer() returns -EBUSY, triggering
the WARN_ON() in ext4_journalled_invalidate_folio().

Unlike the standard truncate path in ext4_truncate_down(),
ext4_truncate_failed_write() does not wait for the committing
transaction on the tail page to finish before truncating the page cache.
Export ext4_wait_for_tail_page_commit() and call it in
ext4_truncate_failed_write() when data=journal is enabled before
acquiring filemap_invalidate_lock() and calling truncate_inode_pages().

Fixes: 53e872681fed ("ext4: fix deadlock in journal_unmap_buffer()")
Reported-by: syzbot+f111db4cb2acd44eb2f4@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=f111db4cb2acd44eb2f4
Signed-off-by: Chandradhar Kumar <chandradhar.2003@gmail.com>
---
 fs/ext4/ext4.h     | 1 +
 fs/ext4/inode.c    | 2 +-
 fs/ext4/truncate.h | 3 +++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bf0325ecbec7..cc714d7b292c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3215,6 +3215,7 @@ int ext4_get_fc_inode_loc(struct super_block *sb, unsigned long ino,
 extern int ext4_inode_attach_jinode(struct inode *inode);
 extern int ext4_can_truncate(struct inode *inode);
 extern int ext4_truncate(struct inode *);
+extern void ext4_wait_for_tail_page_commit(struct inode *inode);
 extern int ext4_break_layouts(struct inode *);
 extern int ext4_truncate_page_cache_block_range(struct inode *inode,
 						loff_t start, loff_t end);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e3129353d4ed..366345981438 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6819,7 +6819,7 @@ int ext4_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
  * buffers that are attached to a folio straddling i_size and are undergoing
  * commit. In that case we have to wait for commit to finish and try again.
  */
-static void ext4_wait_for_tail_page_commit(struct inode *inode)
+void ext4_wait_for_tail_page_commit(struct inode *inode)
 {
 	unsigned offset;
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
diff --git a/fs/ext4/truncate.h b/fs/ext4/truncate.h
index ce84aa2786c7..19ed4673284c 100644
--- a/fs/ext4/truncate.h
+++ b/fs/ext4/truncate.h
@@ -17,6 +17,9 @@ static inline void ext4_truncate_failed_write(struct inode *inode)
 	 * We don't need to call ext4_break_layouts() because the blocks we
 	 * are truncating were never visible to userspace.
 	 */
+	if (ext4_should_journal_data(inode))
+		ext4_wait_for_tail_page_commit(inode);
+
 	filemap_invalidate_lock(mapping);
 	truncate_inode_pages(mapping, inode->i_size);
 	ext4_truncate(inode);
-- 
2.56.0

