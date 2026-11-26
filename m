Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795676897;
	b=vbv9CJMRebRFGJ131BPDxetGS8Cx7NSxWfKxHTvZslu82dkleGyrgcK1vXj0J11R30sc
	 xNy3eaftAcoFKXye7HSiY9ldhqVkmivxaQmH1z/Q4lsLe99ZiczRWMV9FEeGRqtLVsZr7
	 hauNAa3HI5xyPli61ftl05RODDlEM7MtGQy2aTQpYZZMTDRWCh+MEmPCgzqyQ3cwKgMHu
	 954EdFihv+1HVZJayGAD4iO/EWeeX6lT4bIz9Gx8SqgzQ2la4gY8VVLpb3ZzTpvgSm9gI
	 tAP7ScX7epmCXk+JpFmqmHnoNBF2Uievpqn1fMKwDc6u/a+4jbcBSLPiXscsWXneMrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795676897;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RRzFeMo2WDsI7ij7b4kIfq1QEoLvG17j0R+GJSyvN34=;
	b=R5jXHcY/b2vkk8qKIVguyEn7ZqKj7W+wc5mEMTw43x+BpVWexFzCPLL82IcGFK9KY5Wf
	 lXnI+vr2rZpNiHZsNil08lZ61Mr9KNErZgvgF4nPmU2Qv9VKbO2P5elts3UktWmWvyF4z
	 yXfGBjvHZz+l1CvCLfQ2tFe/Ufa2gajqR8bA/7QmwPwSsQFotNgRGz0gTDtU3ldhhxJqu
	 Xw1biGJTtsUL0LTP82ro+K2bZPw/EPh6IgNahU8SVj4pye7BEdXO6OEXqY7qptNKv1BdI
	 u6QE8OHpnNc2VA4dVanEdKuEPQMOCU3Ur2BUdjuqoGgjZ/PcdC2KJV2f9KacJw74+1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YzXebyYp;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB65606A31E
	for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2026 07:08:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EDB65606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YzXebyYp
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4b467581b98so64408825e9.0
        for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 23:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795676895; x=1796281695; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RRzFeMo2WDsI7ij7b4kIfq1QEoLvG17j0R+GJSyvN34=;
        b=YzXebyYpMCwQ5jOWryjzHneSvapya+hUYAtjl3lttnp6ffTCsXXZntKMKFDHRt/YrP
         fBJsmGCH+B4NDW0L6UD0ab7Gwge2pBjuZrYlZvvHDEmi05cw0p+vq6NMZuWx3sSremU0
         2hIyBWEz8JJec12WOjDpdhZVbz6tU41NzRsd+BZlsFBQOHstmiTst0ABM9jAd9s7yMGM
         ORjSDUAP6IAQNDV7onIosnOOEo6I6inUAupEIm4H5fxzuJXnhjO2TOstDLfMFH0s3rfn
         waLeVHwgULx3Kcdr47USksDd6q1KaE3la3ZBYY53hAMcpPvi9l27xg1CLfPUhsCC5rpt
         HjXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795676895; x=1796281695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RRzFeMo2WDsI7ij7b4kIfq1QEoLvG17j0R+GJSyvN34=;
        b=uT1+7VA4Qhq5NOOp5DpqCWG6q3GFi3owO3d9w9nLfjBdCFEXP3bcqCrHN8Hf9+B1yH
         rZXncT1LXk1cv6P/7qwgMh14+qtrKxwcbi9oMfsxVYgnxVyNy7kWTRM2CgTI9fmH3xMU
         TYNG/5vQxzwQtcE731A0WxJOh+THOR7e5do+7AQ5TbMKs47Ki2/596z1PJy/XSs9Jckt
         H7PAiT85THbqh4ZdiTQbGq2dnz2FR/uiLEp2clDax8EDnhL1EFQBUBtF3Fy5K3BTrpiU
         QtDQsvOozmSoIifl1EwkqqPLtl1Pz9UbpHpnk9ujMlBjg6W8nCNi+TjFgsu4cVoH5Iiu
         Cbjw==
X-Forwarded-Encrypted: i=1; AL+hErEVff41PRgtFyvxCp1G9hEl0m9Z+6M8+NZTlkZgvmS2n2n9UHwAUUb0dVcm6Jp59kevawmlCYMWv4cY@vger.kernel.org
X-Gm-Message-State: APuU4Z8o7Vo3KcS4w2H6WztXfSW5GIGag3sw7pZOKywVx1pQe448u2hn
	cVQSoulPuVTYlg8Rj/b7P41vB8TC9jC9mqk0PxCcyCkEv3EO4cg/j5Ds
X-Gm-Gg: AZFdTZfYDwDDrQU3myuUoxRXus6vol6J3Ws/UFaAAQPa7SdS3+rL3Rkzl9JPomsYk9l
	ogS2Kwo8SH7OiQvbyPw4w34awtdzEsd1hQW9YILzSpKn/62XuVGR4uWlqbGAk4+Ijw0ucKVKZUt
	xomOMxQZNg97tbuIFFvtLtaGT2PTdPxCpVUZnMZxbbOHe9C5wqHlPPNX7zH3Bb45W5EwHQG5Gwk
	7E/07jdUPaxljNb0KlrZ/zn3KsWAdW1L3hYHg1EW5iX5iUER+yzNuggFqS4GDhpqNX8XSfdzie7
	motltk9vrhJAHqlaJigZ7pwz2RVPmjyS5mouMZ5dwMZUwG9mCE7idegLrbzK0eY6FBLSbBAyV09
	ZTm5nukYZUkj06fgdebyvEl7D08tdcO+reijh5LuF4bsBeGHw+FgdKD0YY2aRhqOi6QPzA+arcA
	cFdYBINABwMlxtEOHYUDr427P3KMhXp/OChz0lnUJUbbqLpJ7mnmHKuOXohILiwLMJzu0y7MmsN
	9YgDTBLon0WLmW/RwTQ5HhWjA4UCetIKRcO/8R//kTFri0VV8GKhZF3C07Uko7F1c3kEQW4fclL
	tprIpbvGnIIahzbquBSpoxvQpWQsaHnqAcTbyBcq5KklOe2rYA==
X-Received: by 2002:a05:600c:670b:b0:4a6:30c3:1114 with SMTP id 5b1f17b1804b1-4bb88922df3mr383180515e9.12.1795676895315;
        Wed, 25 Nov 2026 23:08:15 -0800 (PST)
Received: from DESKTOP-V28CTA4.dbs.corp ([110.93.227.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b09bsm1071077895e9.4.2026.11.25.23.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 23:08:14 -0800 (PST)
From: Arbab Haider <arbabhaider649@gmail.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	yebin10@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/5] ext4: stub the nonatomic buffer lookup in inode KUnit tests
Date: Thu, 26 Nov 2026 12:07:45 +0500
Message-ID: <20261126070748.272109-3-arbabhaider649@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261126070748.272109-2-arbabhaider649@gmail.com>
References: <20261126070748.272109-2-arbabhaider649@gmail.com>
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

ext4_get_inode_loc_noio() uses ext4_sb_find_get_block_nonatomic(),
but the inode test fixture only stubs the atomic buffer lookup.
The real lookup cannot find the fixture's synthetic inode table
buffers, so it returns -EAGAIN even for the cached test buffer.
ext4_sync_inode_metadata() then treats the same cache miss as success
and never observes the synthetic buffer's write error.

Register the existing fake-cache lookup stub for the nonatomic
helper as well.

Signed-off-by: Arbab Haider <arbabhaider649@gmail.com>
---
 fs/ext4/inode-test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/inode-test.c b/fs/ext4/inode-test.c
index ab1ca5982..529cab24d 100644
--- a/fs/ext4/inode-test.c
+++ b/fs/ext4/inode-test.c
@@ -1149,6 +1149,8 @@ static struct inode_test_ctx *inode_test_setup(struct kunit *test)
 				   inode_test_sb_getblk_stub);
 	kunit_activate_static_stub(test, ext4_sb_find_get_block,
 				   inode_test_sb_find_get_block_stub);
+	kunit_activate_static_stub(test, ext4_sb_find_get_block_nonatomic,
+				   inode_test_sb_find_get_block_stub);
 	kunit_activate_static_stub(test, ext4_sb_getblk_unmovable,
 				   inode_test_sb_getblk_unmovable_stub);
 	kunit_activate_static_stub(test, ext4_ext_getblk,
-- 
2.53.0

