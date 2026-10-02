Received: from mail-ua2-f41.google.com (mail-ua2-f41.google.com [74.125.226.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC2F2DA759
	for <linux-ext4@vger.kernel.org>; Fri,  2 Oct 2026 00:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.226.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790901704; cv=none; b=AZ/cCJJQcMaTF3OStWMiSjMoPvA34HyVS7op8HtxcbUFEoCbQTpQVuCLJMI6POLYty/jK2jRIhETCxO+1egJr7BtYMjJFino7o/0bvnrPTzIe10BX4au5VZ2EIBrmNjXRA+Lquhv725cScLj3tQIz7w+40islQP8vKSC7YRcm0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790901704; c=relaxed/simple;
	bh=coPbEVU635kTDJ5rpJpWSMLlxl5aCTdBTQo8PREAd1c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rNSf9TdWr6P5AltXOiB2Sifz5+Ag/1BCPMi30L6Xh6IG55HPYMh5OgcRBj5a4yk0s6aJtvKfMyZlWzoZ+K7yGMvxH6mE6Lhofi0JE0M4TjNLsHHWJE3XGi+8JS7Kw0eeKRaZwM9RMyXhxTwQGrfHpNo+r3Azjja9iNFf6FVhcT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SvwDURJd; arc=none smtp.client-ip=74.125.226.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SvwDURJd"
Received: by mail-ua2-f41.google.com with SMTP id a1e0cc1a2514c-98a8e9cd8adso841124241.3
        for <linux-ext4@vger.kernel.org>; Thu, 01 Oct 2026 17:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790901701; x=1791506501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jAwTn9q8SUnFiLbMogXfXDX+dJCQYDVb282KSgjxcVA=;
        b=SvwDURJdw2pLdZZHZvhlvgXlHIftDXyrQ8tZ0LBWejuZ0ca/YXuHnVLpoOuiOmblQw
         95Xs3VhwqpQgbPEwFWJHGO5JP+lyo9AUG69TVsh7kwFQZ+nVN9HVDQLU7hUoJ+8mDVb4
         HbKW3HmYWUuE0L50E/new0+md5mvd+GMPYDKOsonXAFlH8bHCIee6O7Clob7VDw/dqLS
         AM4gur1znNwwU/22etNZn2MIT1OX1RRZq/9aTR6HpIYfBBGmY8i7h+zi009X6PXtaOxN
         ECElefUSXdHrQ5WKzgL0kKRQgVAKN65FWqH6+EXG7iqeiBbHeiZNMxJNM01UH62nwvQM
         Sgdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790901701; x=1791506501;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jAwTn9q8SUnFiLbMogXfXDX+dJCQYDVb282KSgjxcVA=;
        b=bpJoLmxK60kuEkYry2XypBs4m+3tnZfUjtGjfsUb2/tQ2WDOCGBjr4AAU2QXvylvOl
         1klX2FbYk7rJEsYx3WKAVQzPEhaRx0m8OqYHtm5DL0S3hlQw0W9GRdgiGzfFLTXR/JGb
         ccDp0FQQ5igE+RiNL2KbYOTvaSXyqHQvN/A8Sh3gQABWsCni7qxb59DLKbbqIowIuu4F
         E2kE58QjUEnOPeGryicyc03ycnrEEV/kpZFhVMIcvWHK9rHxDb7oOiSi90td/ZL1ZPuM
         uYrgOu/6tmxlcZGCQfB52v9gYXVn55zIJKGcp224s4ZxHKkvsehABEqbaF/C70xHvxcZ
         IYUA==
X-Forwarded-Encrypted: i=1; AKwUvBy5tvZCJQsfSFHNgnId/WdMCVnCQ7OQvxCpA530seapFhcWo1w5NmNqVcx95VPDctcTHNHMObDdZIQE@vger.kernel.org
X-Gm-Message-State: AFq9FYISVATVrvyAwBWi/o/KlM/BNe1jkXZu97jnBVxImtU+/wVL3b/l
	1928mpxNf/4Ceo9dRpBuQjMwSmum7tBhqgoBxyfGKkxtOdzD6sMOaQf8
X-Gm-Gg: AYBFou0wpiFGo1j3c4lRrfarPsvHSkW9rKmJUJYdqTe+dP9RavLr1/o5pQAAFz1KQGn
	bfv8KxfL5CJcrA97Jlu2h/bSHbi2Z4eEnuQh4cLWuFOkY/YU9tvasJA3qU5Jhcu1hccnL9B7Wtn
	WVuR36qwJHy2F69zQPFMs8e15stCsdNHuQk4qzVKP2L+eta9gi3SBwgSm/1eg5ysznJ/ii3kNbz
	ptyAnmSzs5PXClMAT2wQk6ijgEZhT3FYF2p7Bm9S1udXsZRNpJ568dilcOt4rUaVTXr6NioqfBZ
	kVApGf7eugFMl0eabrK8Rn8WBx9tMkSdVMTv0y6ry7mY/bRIWdTiAY3sU+tfbiujCN8hwa6covD
	jTo2jsbrj9pI2KYKVu3/UZWz+ICPd1fohT6uhfFrPSWAeqt7QLZFp3Xl1RMYDXrFcsy0ue5VfJM
	DXPWK2zWoxR20s7M8ZZlZr4RX9HnvaryyKaKFWwoekf/VpT5ApEfuVvzWI3EALfiiM
X-Received: by 2002:a05:6102:5cca:b0:7a1:f7d2:e81a with SMTP id ada2fe7eead31-7c0f4c9f080mr378970137.19.1790901701501;
        Thu, 01 Oct 2026 17:41:41 -0700 (PDT)
Received: from adriano ([191.118.25.221])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7c0ffaeedf5sm1025960137.7.2026.10.01.17.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 17:41:40 -0700 (PDT)
From: Adriano Cordova <adrianox@gmail.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Adriano Cordova <adrianox@gmail.com>,
	syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
Subject: [PATCH] ext4: wipe moved dirents with their real length
Date: Thu,  1 Oct 2026 21:41:27 -0300
Message-ID: <20261002004127.1332310-1-adrianox@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After copying a dirent to the new block, dx_move_dirents() wipes the
source entry using the on-disk rec_len.  Use the length already
computed for the copy instead because the on-disk rec_len is untrusted
and a corrupt value makes the memset() run out of bounds.

Reported-by: syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=09bec78ee77613a3efdd
Tested-by: syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
Signed-off-by: Adriano Cordova <adrianox@gmail.com>
---
 fs/ext4/namei.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a6386c1d237f..71e9e7c9a7fd 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1860,10 +1860,8 @@ dx_move_dirents(struct inode *dir, char *from, char *to,
 
 		/* wipe dir_entry excluding the rec_len field */
 		de->inode = 0;
-		memset(&de->name_len, 0, ext4_rec_len_from_disk(de->rec_len,
-								blocksize) -
-					 offsetof(struct ext4_dir_entry_2,
-								name_len));
+		memset(&de->name_len, 0, rec_len -
+		       offsetof(struct ext4_dir_entry_2, name_len));
 
 		map++;
 		to += rec_len;
-- 
2.51.0

