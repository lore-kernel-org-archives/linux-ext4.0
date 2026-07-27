Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCE33E51FF
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186784; cv=none; b=qr+MLKN3ZBt6YRPAVpNBJcuYPBRALA6y7MoRroMfgiauygQTFWS/IVD34hSyUY2d/yxPvpc8VEgxvUYahh4Uh7ZlptVPUy42sL7+h8bQgOwJeAbUuWui78mI2XZeATrSiQ0AdGK7ER2hyqEJaQmrn0JX4LU4Nj+6dgyK/yGK9ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186784; c=relaxed/simple;
	bh=mMwmh8CunMxX79/11+cozJ4+J2RN0zZKe8Q4zjY9iCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DkQeFQtOV2i8dkyDkLG2Fd5OD/4EN7vFXMODnqmNOXnS/BvCcU0P1s4qrvNQ8uKY/gFthAVyxQBQ0bKnF35ZUPjrLJwruZFxrYdgTVtTKh6nnbd5eD2urlSwjX9a9ya0scJWvrITwKyexOYfzBw6G7O1M6589SVUvR2VBhWLpVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qB4Xh8p/; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qB4Xh8p/"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4953de5be0aso21006815e9.0
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186781; x=1785791581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wFueboZLPWAkgNDj6HQNTjnIe1s16kAVfyJgzcPKDFk=;
        b=qB4Xh8p/5fqvNaHBF+Ka3O2hhFqrmqMKHzhXXAeUYkIuymChQoL3/b7Q9fzvELUSlW
         epx+u5ku2hCmlmzSwN4j74QPvLewsN+VnqC+CxyUjeMspzFpwLK53Lmr1szcRJC6qAXo
         IBy3/vwriSc4YRLyrvBjeEmUQMv9ooVaDbUGeu4zWub4R8bb7hF1e+R5QvPLDOr3+0aT
         yoUu6cWmxDG22KDWEiu/zKQSHkYL9T0tC+21sS2TyJbjVYwXr/Uj9lx4P+w2sQKAAKe9
         hQ1OcUyhT0v8HPwn3qjDaeOpXbkjOQsv0abMExZ3SQ2DRicp29sQIoNcg/T6rV4b2h64
         oOgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186781; x=1785791581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wFueboZLPWAkgNDj6HQNTjnIe1s16kAVfyJgzcPKDFk=;
        b=NoVeFGghFXI9W08mRpq522csS6STOm0cFQSIjxKONBwodvJLE+LuSZrqlOxEWPF7rE
         S+724qgebW8gLn3M7B8z6GQFJKD/UIsNIGtxCfTKwrbP1xUZ4+Siq5ltOSOqZTWi9qiP
         qda46EZnFdwPe+N3xpC+y2fUKLBWsrtCGnFL9VAGOtrUt1fHmhFAhQsdya1jGWhEGgTm
         KwM+mUZeVwzXytua9BpwJa4ThxTGTZm+rHjZi/6Uq3t/KHX7TIxu1ZsfN+a/V3KgxT6Z
         Usr7BtORqS2cZG6C/esUc+nh6LA0A687pJk8RtnCDDrQxQNhmmjKJ0cgDv/Ag/SsJJQS
         Ql1A==
X-Gm-Message-State: AOJu0Yx9Kzy74mnpoZHjek63lIhIuQLSjFGcSxCLgcslTu3HqbCGjcZi
	WYvt5BMnFtj+CYS20taZ38ii+qqv8ap36oUfuTJ19VGnAO/Ey5ioLkS0KpNcVA==
X-Gm-Gg: AR+sD10RVwzB4uvLN1hYet9HZw21BB6tocGXIkEXHUVWhkTvukp9Rl6a4b6ZqA7ra7e
	W9VHvNcJ2u+Kz/72MWLG1sE+q5yVPeXY989J0/BLw2rzZ68thu/OorQ0HHDhVnmB3IZ9zp9AKt8
	3BXAWYbMcHeVm+//x0+5LX9y1lAp8l1C96luyQjjKHC9lgquVNOO4AU8UzhwOE5plCGa+nD2L6J
	qxV/ze1EhaAvdbtORGO9PnDXfHm4Han7QQmqtVRNld49YjsrBJLtXDZkRF/bvPh2mlMavvtV5dm
	vK8WNamuNClNiUUoO7Zz1I2JFxmASCaQQCK6irWM4qtqCn9JcjKJP8tF6gUczus2KlR67qHWrbC
	u1bqzNikcmrUsUlKiDZHmYyXHYe8mn9xCu8CnOFIuey6Mb1JUNbLhLEZRcipUsdVjqXRroKGQzO
	KorcWGuxfTrjnpnVvcE752UOFymEQxKkhh8w==
X-Received: by 2002:a05:600c:3113:b0:495:4811:7998 with SMTP id 5b1f17b1804b1-496b57013f0mr123897145e9.17.1785186780584;
        Mon, 27 Jul 2026 14:13:00 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c44afaecsm24910245e9.2.2026.07.27.14.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:13:00 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	xiaowu.417@qq.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v6 01/11] ext4: validate count against limit in ext4_dx_csum_verify/_set
Date: Mon, 27 Jul 2026 17:11:13 -0400
Message-ID: <20260727211125.19632-2-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727211125.19632-1-ablagodarenko@thelustrecollective.com>
References: <20260727211125.19632-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dx_countlimit's count field was read from disk and used directly to
compute the checksummed range (count_offset + count * sizeof(dx_entry))
without ever being checked against limit -- only limit itself was
bounds-checked against the block size. A corrupted or maliciously
crafted filesystem image that sets count to a large value (e.g. 65535)
makes ext4_chksum() read far past the end of the directory block
buffer, hitting adjacent slab objects.

Reported-by: xiaowu.417@qq.com
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 fs/ext4/namei.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index cc49ae04a6f6..a283e285937a 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -477,6 +477,10 @@ static int ext4_dx_csum_verify(struct inode *inode,
 		warn_no_space_for_csum(inode);
 		return 0;
 	}
+	if (count > limit) {
+		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+		return 0;
+	}
 	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
 
 	if (t->dt_checksum != ext4_dx_csum(inode, dirent, count_offset,
@@ -506,6 +510,10 @@ static void ext4_dx_csum_set(struct inode *inode, struct ext4_dir_entry *dirent)
 		warn_no_space_for_csum(inode);
 		return;
 	}
+	if (count > limit) {
+		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+		return;
+	}
 	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
 
 	t->dt_checksum = ext4_dx_csum(inode, dirent, count_offset, count, t);
-- 
2.43.7

