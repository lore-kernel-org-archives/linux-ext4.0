Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B906516F0EB;
	Wed, 13 Nov 2024 04:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731472927; cv=none; b=tVW+mtVSuh9nhQBib8Zmvt4+wCULaZ9/1Wpva/UGjluiqqp6A/W4sD1/FagCc71kCdTUo8HnYPvXHaHNhqV0bQdDLjXn/3bgl8viZffDEvRARVY8vt/MZM1NTng2+Tv/zruATapAx4dtzhrm8wBiE9gpwxbRipBmGtQXzZvIKsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731472927; c=relaxed/simple;
	bh=4yhZ5b3CfOWzP4/u7LFTntBB+aHs/50fGPCzOxzMCUU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FD7t8HJgktxZyqXlehXGKG8X2t/2AkLVPc62cTFVVxvXG/HSmEgtLY/wIS2oFtRT5J02BWy1LFVflmcVnXvRVl3Ag0ESYs46NH5l/iIX4rNt0ePT+cR9i3mRhFxJXOyT48c1eaJ57BV/Jpzsuhp86t/o8F9kQUPc8XvkHdhadmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MF9/ef1T; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MF9/ef1T"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7180bd5b79dso2360089a34.2;
        Tue, 12 Nov 2024 20:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731472925; x=1732077725; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nIlUbeFchI2HNrkasT58vJGrzRZVQqFIj/GKrcFj8LM=;
        b=MF9/ef1T5aF3AU1zRFTN8VDubNYhb7LarU10yOEDR1/iulh/H6L5PbnJ8xOPXou6ns
         A0dCtfWt9ZGDi9bZ3mvwIbtiR6tfmNjtyw/RfDdtFA5fIPZGBgPkNMs6eW0UY4fvkTGp
         GwWjcNEjPUDAD+3hMAK+vszGT/Q7TxZr2ViaDQVV9C7yiJNJz0Oxu+B40UX9zEjZ1n62
         KPAxbusailATNpKWwTmFBe3N/lYO67dDTLdcEH92uA5YzFy7kzEuAh4Zo84KGG4ncq93
         WxttsDa9qR7dL0+6hRpkTJjhXvE4xxzXWfRwJDTcK/O3nToMjVM2gEmz5kXntH/hh5QJ
         3OUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731472925; x=1732077725;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nIlUbeFchI2HNrkasT58vJGrzRZVQqFIj/GKrcFj8LM=;
        b=YoUZfsRQS7NwG/1pjnBnT0VZn/XbX9OpYIpMy4cUpmoqHRXmTdfyKAEqNxXNA9N4zV
         j3NytEQnzL3qeeCTV/IM06IdWT+tBIOwhx899mhxAzdbW0RRFz6h5FFnUf66IsVZY2qW
         RUkN6koBZ0DY7twn87/2wPs9Tq79BIa65pUx76Lr0ZKzay334RFUbatUiI/eTrHDa9g+
         vXQ9rJFX82sWX6Bab9YootJT+qT80Y4hgWuQYIiXfWhu6hVJXMrzK41zs7AK0hotKXMV
         Wq4DSQzGO1VUErEYhPwR8TuS4ngdNMCgOyPKlcjuIgSQaTG4lwP34yVaakfZJM+WlLhK
         yYkg==
X-Forwarded-Encrypted: i=1; AJvYcCUssurOGv5Se8oIllL4Wf/0A2Mcqe+0JU6FXQCK7crGS2XXAIjNWCNg1uo0edKdvQ4aXyqju+XIabpQ@vger.kernel.org, AJvYcCWnFCLR1Bi+pu+ycWtuBXJt8if2kZ2AxvlsWcd7L+X3JwalxfELcwGxBSTrUji2Jjq/cxjFUPHLN2DmdUuK@vger.kernel.org
X-Gm-Message-State: AOJu0YyGTFtzP91p/Blm5yExbFpuc95bFp9PbUUyDOgA69EKxDJzxAD2
	PCYmRGU30ac4EiZh/g8yK5DmiDag3iX20pvlKaFViTT6PqueQDigSVNGdw==
X-Google-Smtp-Source: AGHT+IHPnxnVCo0BZqCpKPk+xL8mEoTrxotapUqiq/NUagewQcm6I3a4C3LKs/bslBViiayHeM/FvA==
X-Received: by 2002:a05:6830:3685:b0:717:f66b:da20 with SMTP id 46e09a7af769-71a1c22280amr19865288a34.16.1731472924699;
        Tue, 12 Nov 2024 20:42:04 -0800 (PST)
Received: from localhost.localdomain ([119.28.17.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724078a41cfsm12336557b3a.41.2024.11.12.20.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 20:42:04 -0800 (PST)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH] ext4: remove duplicate check for EXT4_FC_REPLAY
Date: Wed, 13 Nov 2024 12:41:58 +0800
Message-ID: <20241113044158.1609384-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EXT4_FC_REPLAY will be checked in ext4_es_lookup_extent(). If it is
set, ext4_es_lookup_extent() will return 0.

Remove the repeated check for EXT4_FC_REPLAY in ext4_map_blocks()
to simplify the code.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 fs/ext4/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 89aade6f45f6..999f947c13d2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -619,8 +619,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		return -EFSCORRUPTED;
 
 	/* Lookup extent status tree firstly */
-	if (!(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY) &&
-	    ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es)) {
+	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es)) {
 		if (ext4_es_is_written(&es) || ext4_es_is_unwritten(&es)) {
 			map->m_pblk = ext4_es_pblock(&es) +
 					map->m_lblk - es.es_lblk;
-- 
2.41.1

