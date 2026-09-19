Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD6D547058
	for <linux-ext4@vger.kernel.org>; Sat, 19 Sep 2026 20:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789850901; cv=none; b=sW0aQpBWdhRavjCbss1BDEjQTGY+XAA6DnEH6MTfceP2lKErwRUOkv/GtsS/rrliTftkZ18+5+Ev9uJUTAdX6EPrHwVGYGkxNkCwb//m4vdkdiceVM5J35zxq6U1rrcMkLfczV7eSL+jx1zaEryQPwYkg4YWeJYvgP5IeMQpDiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789850901; c=relaxed/simple;
	bh=YWYmnTUofHLnZhhJn+qOOD+krg//1xjBLW3geEDwmbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S7aT+w2NkQeM1+zASsCggTp/5HPSe1Ca+4fo0kUCa53BgAYiBnk6M+PbpRvGPtRJREnnZHxq6f7rd2tiKCU5XzMnIcSpA+S5QcahXn9Go+tXf6lXemhCH8oScEYWi5WaOQf3DpXJDIZ0ZZklpJ4BlINNZzjS1Ia8+vk0p0AhT5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Aq7xJmVh; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Aq7xJmVh"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cc52c1b8286so1491607a12.1
        for <linux-ext4@vger.kernel.org>; Sat, 19 Sep 2026 13:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789850894; x=1790455694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=r3eIvhYC8FQ85KoT/nVPv+hrmn/g6RXreQMGPku9rwQ=;
        b=Aq7xJmVh7cIY7djGM1VttA0/4zpdfES4WURJ99P+GxHhb0iUUquBcSSlB5eZb6VGiK
         NiapAPQgr5EsJxGeIZSqThPj5HaOAyexIBlWpHz19suwVj7xvsGNyml1Sq6pvgRNELSc
         TCSJg0nD0/aaPaoqslxqARCdZvve8l51B309rW758hr5kUzWCsBFwMD7pN5qEdhOerIZ
         nzA1LjA1Pxz9cTc3qWA0+k0cOSpmipoamf1+iXmhrEV1L8k+YeyvJlMpR5cE5IbJztZg
         O8+NmMTw4Fkx+Pb4jfOdGBiwg45VF76rnGrg+EqgWOG4kSQQl22DkR/de6ez0klnpQPu
         CRCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789850894; x=1790455694;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r3eIvhYC8FQ85KoT/nVPv+hrmn/g6RXreQMGPku9rwQ=;
        b=Vzzh515H7abftBEEdID45d9c5AOme5v3RCR981zveFNjOJz+zQlFJKxzfNw15K9y64
         7Ke71CGCcvhs8d5exu9v3lOo0UeUFrqJuuQjRsNpgMtgoETcPJM9OF9cPVEyGhiHKB3e
         6jzaavMoG/neF9oBzKwvQXHc2vfIG4uCpRkB40N2XcEyiDPwnEnOqUAMannAMxy0564m
         MhPQQ0+oQKDHJq+8C1p5t9CpSim6nksrG/zjPn4ESvwhThGRSypCYNfByG5ViiBIjyVr
         KRF0ft7bEikQbmjLZvwBzpn1vu/33YLeUAATKWUSAH6NQcS6+Te2VHZPgGZYcP/8UGPK
         Ak2A==
X-Forwarded-Encrypted: i=1; AKwUvBzRTt0/AlI2HxePwqbbxyGXDZQt8vXcFnKPBL1f/sTGCoMXnKn3T4BLhinwMoLTPdhftEJnkjj64oOk@vger.kernel.org
X-Gm-Message-State: AFuF++mf8JUM6pGqc/ivIcUAnMXjtosi3s3w8XPQsNBtgFjtkiHC7SLo
	hqOrdaXHF1MoLsHiK+zwj+mATLYWKlngs2IY1hVy9NqxOTC45/agcqiy
X-Gm-Gg: AYBFou1DQKY3e9rOT1UBBJGR1X+ku+qGlZbXn4RweYHhWGe4zYulqynXpspKJx8U8jL
	UlAcAj/+Opei7eK3YHYogXQ91FSNhFlQt7ClkNYUY26mSHEKxVDP1ixwSBKedz5hZpMg3j3xB3f
	7LWnzxC92pDn3kIYfeDbkILEMpomxlZKD9Dms5WhClIU9AG32N+B6EltTm4vgJusGtpsiOCHaXk
	5El24auv+GwzDu5EgajpMT2GoLNdP88KVUfEyPGTLYwrj8215T8u9BznQFfjlqD+Q5wxG8m1P0C
	KrEpPzs6Ltkh6ldo6SeDeyFS8vfVvMcZ1rO7AJdgt/7JnujUcrTpUNtn30gU6kmuidP2OF6ke82
	f6x+BOkgmqXIwBRxCK6zqYODuuA0Axz3htiQKGkEJNzH1eb8FCQdR+PQ7YPHmUz4ngWg8HEDv7R
	OoWSSaHeX55k2ogCZmZcnyN1C4rora/8tGz4bGMzqe8ZLmauZJqF0Vy2oG16DbHuzhcJ8Uz//O9
	TWtepmk53xXUsFeJOtkwL6scKQm0Ka0JaMd3DzissG7zT9xImUJ3bttqDJjnMKZdHE18OGMEZcZ
	BgGtw/Frlg==
X-Received: by 2002:a05:6a00:b47:b0:874:72b6:7da7 with SMTP id d2e1a72fcca58-87472b680d8mr8829464b3a.34.1789850894124;
        Sat, 19 Sep 2026 13:48:14 -0700 (PDT)
Received: from phui-2.c.googlers.com.com (78.123.83.34.bc.googleusercontent.com. [34.83.123.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-877aa305dcfsm1319734b3a.52.2026.09.19.13.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 13:48:13 -0700 (PDT)
From: Hui Peng <benquike@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: clear EXT4_STATE_MAY_INLINE_DATA in swap_inode_boot_loader()
Date: Sat, 19 Sep 2026 20:48:12 +0000
Message-ID: <20260919204812.2814531-1-benquike@gmail.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

swap_inode_boot_loader() (EXT4_IOC_SWAP_BOOT) checks
!ext4_has_inline_data(inode), but neither checks
ext4_has_inline_data(inode_bl) nor clears EXT4_STATE_MAY_INLINE_DATA on
inode and inode_bl after swapping their inode data.

When a newly created empty file (which has EXT4_STATE_MAY_INLINE_DATA
set in memory) is swapped with a non-empty EXT4_BOOT_LOADER_INO that
already has extent blocks, the target inode retains
EXT4_STATE_MAY_INLINE_DATA == 1 alongside extent blocks. A subsequent
ftruncate() + small pwrite() + fsync() dirties folio 0 while converting
the inode to inline data, hitting
BUG_ON(ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) in
ext4_writepages().

Reject inline data on inode_bl and clear EXT4_STATE_MAY_INLINE_DATA on
both inodes in swap_inode_boot_loader().

Fixes: 67a11611e1a5 ("ext4: fix check of inode in swap_inode_boot_loader")
Assisted-by: LLM
Signed-off-by: Hui Peng <benquike@gmail.com>
---
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -397,7 +397,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 	if (inode->i_nlink != 1 || !S_ISREG(inode->i_mode) ||
 	    IS_SWAPFILE(inode) || IS_ENCRYPTED(inode) ||
 	    (EXT4_I(inode)->i_flags & EXT4_JOURNAL_DATA_FL) ||
-	    ext4_has_inline_data(inode)) {
+	    ext4_has_inline_data(inode) || ext4_has_inline_data(inode_bl)) {
 		err = -EINVAL;
 		goto journal_err_out;
 	}
@@ -461,6 +461,8 @@ static long swap_inode_boot_loader(struct super_block *sb,
 	size_bl = (qsize_t)(inode_bl->i_blocks) * (1 << 9) + inode_bl->i_bytes;
 	diff = size - size_bl;
 	swap_inode_data(inode, inode_bl);
+	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+	ext4_clear_inode_state(inode_bl, EXT4_STATE_MAY_INLINE_DATA);
 
 	inode_set_ctime_current(inode);
 	inode_set_ctime_current(inode_bl);
-- 
2.43.0
