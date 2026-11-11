Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794400545;
	b=MEWwqDqab5kGkYMcUjQldbntUS4sskqQ92Z6M93qbZj9o8hf0apul/2gpe60A5zcp8UZ
	 /BlOYJfXMYGSe85L8NKSGO1CVcA/ND0OuSwih4qeiWDrgSoEAW/8ccp7j7y0U3DQxyHUg
	 u22rgHLf4xG3IqZ6+fXiVz0hh5ahsomjFF124J/jI6V4i2m2wSERr/BeIQnw0V28uZRq2
	 wdlIVWLUfhBe5e6wKpIegeggH68KmdYlNI9QAVet1D/QmBbX6AoX/NRZpXBssJRui0f8+
	 071D9It5NP5UmeIHxXN8/sv5qZRtNiMpvWGbosmhFntv4lC5cPHkaLE5lFGssZkpYjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794400545;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qEns8j9TNQ6X545oefisWAHMaLi6RDahAOhPC5RfDi4=;
	b=QMbCiw0hm0Nfhr5F/BWeB0qf7UxMhLAcaj8U8ywXBjzXz5oSXYFKOVgpLYZ4DOg+WGGx
	 pRSLGwe3H/xZWnVA2Yqhw4lT2WwKc15EZbSXsjMkssHqM0Zg4tcQjGNWP25KSZLorbJlU
	 EDEqMDcE4IC6NJ7H7U/cF0NmBToCjYkHzJjQBvBEQGX4oL1dUuqzAD1T+YWBf5Ew6LX46
	 ObpEYuO2+9cUE4FYDiMnk55pxsmGuOdUZM1OSgDNZC23HSqHJWPMfqb0/hbXglXu+Bd35
	 Gt0TP8aM1RgvShvrB0NZzATXJyVIMWlk/dz3fxKaEQHqKypCRcEX6oeiaFU2kHqulSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AMO6Sf42;
	arc=none smtp.remote-ip=209.85.215.180
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812F6606A321
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 12:35:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 812F6606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AMO6Sf42
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cdb2dfcca94so1417983a12.1
        for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 04:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794400545; x=1795005345; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qEns8j9TNQ6X545oefisWAHMaLi6RDahAOhPC5RfDi4=;
        b=AMO6Sf42HMxpa/RUtsNsKu9oaktHRowsQ1OjLfufSbUd0H/O0bVGuGJFnKUj/kMcE0
         L43cgNELZGL1x/unT80EVCikKU6iWTVCoDRY2SwfO2ll4Ptxw67R6bVko8s9Wtqoaztp
         m/MTROlVppiphLCrdWLtwz1X2FSxcUUDStFP8ygQHfPlp+wSXq2MKMJe7RFX1msSa+r9
         YOtAOhIC6zg2UQthwdjD6Rj+r+6em3LVdGQyvzj/Tqf7VBEnolw7CZ3iDFnuHT5bRfr7
         hBf84SgQ2TW+DVT8kii5kKgtG/lmvDwvtZesONwtOnjfwzqUeuqh0KUrFRBQ1TbfM7GV
         e8GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794400545; x=1795005345;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qEns8j9TNQ6X545oefisWAHMaLi6RDahAOhPC5RfDi4=;
        b=irienXePYGA84j74QFg28k5V15hgExHM4kcbIfdrKu4t0pvUr/apf+xEeYShlu0f1a
         rU53Gv9nKa70nnZSiTjtvbsDqKOU3Ptgd7sJYpgnpFPjm5ewF8n/sEHt8XPTWlcgaXac
         eCzkMGIxe7NmmR7ky1GqkBkQ6h7/gprGXxhfsrzaIckoSoLAEabaQVQQF1m9a8gLxoLH
         pp5j0bEU1QBZq0riryFLd51EJ6kNR58Fv7e9fq6mHtbCr7HtBzpTpkP0s+GEYpmIqP8w
         c5Kpxg0WKOp3o+LDmwcz7t08Jqtc2aYs/j4VYVFV455SZNWO78hkgGkSW+Rv7miX85vX
         ysbg==
X-Forwarded-Encrypted: i=1; AL+hErGQTFSR2Fl62bwgVJwAm52yQ2LmmHFBlQWu4iwYzfbDZn1wUTcd1/2xhmJx6pdJcnPMDgq0OdK91Whs@vger.kernel.org
X-Gm-Message-State: APuU4Z8V5isZXqcqQTnMFR1BvyKZ3wO1RxYz932fOVc/sSUDqJH5FiXt
	Jm0LbrCG84CjWvKxB9+ECtvPyAGVpsCEQhzRr3It7t37q/Q8GOCZTO/I
X-Gm-Gg: AYBFou0RMUHqYGjVTwDcyHyGX08JYpt3v/ome/qEojRFFeynu89h75ENgmgJyIcFA01
	bxBH4ggicYd+e6Kg2HPPc5DGGjAUwxS/mqTESssRwwdbjErohCvH+vYUmkm7p6Xlev08uoe4v0B
	pIlccVVtv0x5q3T422EQYaXzip9fj89nl8if9ile5jkIh6rSKTk/+OaDpIVDJS93M2j4sF2wviA
	iBH3YWD7oA8KIAIR3Ai1L+u3tnfqi/qhGxxgNliu7Ag/0aGgcMxp5kyp25fGYi7YJNErbDiLHJQ
	Cynp7unwnf+unmS4sYcIYrMPFhP4UJp1a2jFCmBb1Tlx965sawlv1bek3rzYOzs9UtqvxCAYM+f
	GmalFTuEBeh3GVvs9ipXlGoFg0tYRkFDlWOFBx807R8iJqD1gMxLVSOpB9arY6/JelXEQwJONgt
	UiHjl2VMwoS5Viz8eYyCh32y++OaVon+pW9TWWieMGXRJwsSi6KErTGCxZmGwMX5HCm9UNQCrWZ
	EOXUS0yCCWPXymnzX+qy6u2wJ5qQVEZRAfEq/cyvDiexI5cmfrPzUxFhj3qb449VJ76bIof2hD9
	avVKNbbk6WnnrMhLzVa9r80lecH0lZT6gD4KPKYV/8Z9+6BY8lrJ
X-Received: by 2002:a17:90b:2e83:b0:3b0:ada3:b505 with SMTP id 98e67ed59e1d1-3b182efad80mr2416852a91.19.1794400544724;
        Wed, 11 Nov 2026 04:35:44 -0800 (PST)
Received: from localhost.localdomain ([152.136.45.109])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17e0d550dsm4364082a91.8.2026.11.11.04.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 04:35:44 -0800 (PST)
From: diasyzhangqing@gmail.com
To: axboe@kernel.dk,
	linux-block@vger.kernel.org
Cc: jack@suse.cz,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	syzbot+d4ecb9a1e5b3dcf8baec@syzkaller.appspotmail.com,
	diasyzhang@tencent.com
Subject: [PATCH v2] block: make bdev_freeze() mutex waits killable
Date: Wed, 11 Nov 2026 20:35:29 +0800
Message-ID: <20261111123530.871952-1-diasyzhangqing@gmail.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261110132118.11265-1-diasyzhangqing@gmail.com>
References: <20261110132118.11265-1-diasyzhangqing@gmail.com>
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

From: Qing Zhang <diasyzhang@tencent.com>

Concurrent bdev_freeze() callers may wait a long time on
bd_fsfreeze_mutex while another caller freezes and syncs the filesystem.
Use mutex_lock_killable() to allow fatal signals to interrupt this wait.

An interrupted wait returns -EINTR before bd_fsfreeze_count is
incremented, so no freeze reference needs to be dropped. This does not
make the filesystem freeze operation itself killable.

Reported-by: syzbot+d4ecb9a1e5b3dcf8baec@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d4ecb9a1e5b3dcf8baec
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Qing Zhang <diasyzhang@tencent.com>
---
 Changes since v1:
- per Jan's suggestion, move the killable wait from a new ext4
  per-superblock mutex into bdev_freeze() itself.

block/bdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/bdev.c b/block/bdev.c
index f20f91b3176e..e57be2320423 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -301,7 +301,9 @@ int bdev_freeze(struct block_device *bdev)
 {
 	int error = 0;
 
-	mutex_lock(&bdev->bd_fsfreeze_mutex);
+	error = mutex_lock_killable(&bdev->bd_fsfreeze_mutex);
+	if (error)
+		return error;
 
 	/* A device being removed from its filesystem refuses freezes. */
 	if (!atomic_inc_unless_negative(&bdev->bd_fsfreeze_count)) {
-- 
2.43.7

