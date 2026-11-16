Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794855525;
	b=pwPEdRrrdvWFBBm0QB+kwuoJ5ziiDKKsNcxC7ajN442lIaV+sFH0BcNvjvqFY668s/Bh
	 1MYrDW1UqiNYIRjVmNBrggPb2qQJFLPLcrrP1W0tVTzxGkR8PC6e6qRwaUtrhjAYmRrBg
	 X7Ul/kkFTtlEpqIjYAojAEm2WOJXNFdUz1t7T8mUeN3aBVgSXksGoEbRl98ya0pJJJbsH
	 j+vder8RxfrUZRjUCn2LsRfFMYo02iv6vwfJUcfQADlt90EgX6GHxXtk3J9oajJq+kQh5
	 wa+xN/1u+habUsKTAWC1Rss1HLexdSW/KfXYn4OBAAmAhdKcQhn12EdoTTMBXmQRAUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855525;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ad5dFKw+CLO5JX/Tnr2WBnwMJWSG8HNIuJVYxZG860s=;
	b=P9M/bh2kSFYpYU69XdyqjK2KzVSwT9uYazuAXSbMxqKW+C1EaE59h4fs/shV5muYg6j1
	 xwBJJSpvIJ14HV9paZ9EJQaO30svIkFc0Et0UvnmsZKqsfEV1+RPyqTLzLJYrekh+qFAc
	 cKXqhS0aqZTOBSyZzvg8Z7N30QAObTH8ylPcdgg0T7x9spYHUWYIW8eqN4mP1riew6hPq
	 WVahPoSQHocdCKH1SkyPGKx0rHp46shTP+TSNkBJQr42uiKlYNlx1NPjt9F6WsRxvIyzu
	 5uBzuc22NyF6pRGDBI8kNYFOWMdAADbhbsxgfV6YsZxICdmGZzRysGsypqHcOxLWabA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i0g2YEcD;
	arc=none smtp.remote-ip=74.125.229.5
Received: from mail-dy2-f5.google.com (mail-dy2-f5.google.com [74.125.229.5])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0F9606A339
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 18:58:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E0F9606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i0g2YEcD
Received: by mail-dy2-f5.google.com with SMTP id 5a478bee46e88-36caa19b0ffso1692775eec.0
        for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 10:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794855522; x=1795460322; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ad5dFKw+CLO5JX/Tnr2WBnwMJWSG8HNIuJVYxZG860s=;
        b=i0g2YEcDeidHN8wm9CcxCq5SoRkb3tmS/L72+eeURILaUQ/CB39bmWdQIIN3/I+WLX
         oCl4WBaNj/7nc5ujxBVziB8HdlERBejMx3BJagy/xvatfLb6jzIqAyzgUEN4rfC+qXz8
         MIXtNs9gcR8xw636Ke/vZ+piHf/xBHJKuRgFLc5sXt9dBhOKCqq7vpRKj4DdXiY7sHDo
         kealraA1vD2tMcMxuLIOFZRbvG38/H51s0DGy4M0QPSQnt27mNkmQkernnAqp6aTxqLM
         +o+9zXGqD+59W5R96qUgG4AMBsVUZoCgcUCrNow+uPFDozEQjCXMQpHkL0uiAOYzq8TE
         i/sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794855522; x=1795460322;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ad5dFKw+CLO5JX/Tnr2WBnwMJWSG8HNIuJVYxZG860s=;
        b=wJ7GYx/CHKLLaeqrIJCCjgWO9bE82sI78Zi4uv9+iHPkh9Oo0n1WhcrhdrjKcU4eMZ
         mj7f8hNZaCanpulyvsYUgNyGBGrNr4+F/m84i2SqXa6h9kvc1vrDl1lYIsNDZd3fNLLm
         ZkNf+QwIQFRomOhvjTq7Am4RcLiiuI0dLhnaNOc75uOeU90VUwhNcMWoXn/K4jlKj22h
         lxtEBjuv6H6+1U6jbziovz49OrfUUk+AZX09jxEQKTB79dLTZwtXFyP4iWi1MdP8fkFP
         sVW5SOA+kHhtXgNrFUc5JcK7/D+rGZfNW1lGRxbB1Lq8/M8gd8xcAvz1R1kMNp8XwxXH
         AqGw==
X-Forwarded-Encrypted: i=1; AL+hErG9uBhM+ieBcrK1yx/3qp9nZy3faoCp5EcDdP/LvPhNIvCg92gqvkZrJ5GNM5qG0G1OuZFnys+R5T1H@vger.kernel.org
X-Gm-Message-State: APuU4Z87TBjfTH+2xxzzcsgbMxuzSTpjjRpg5msoSGLhFLb0Qrq0+AeP
	//XjqW5VsgCo3LVJlwZCUgpLlimcQZy5Yoba5n+ECvYLfrAQ4Eq7H8Ho
X-Gm-Gg: AZFdTZcxtTLFdS/9J+WJw1qpYn2cpXc60926g6e4DE381YzrnRGnkizzsl/N3iIkHl7
	ipKia1rF37MtSANeofdPIenbfKkrQu6eO5LM9i/WDHbHSZ/plYyBgeJfTaFMCN6jp7g0w6hkBdn
	VA3NNpby4fLruYMekBi6RqmL+6hguXft2+N5aMDWr56/d5PLlh82YqZEWVU5jyqdXUXmllW4l7j
	M+UhpUg0J24/4X9qTZlhJnEiG35DLRljx0vlgB/YEBAQhoJTBvrUktkOhEpYqHdweB1LUCJiMuZ
	I3sXueXL3+drtsr+NpsUA+RIIFywjBLluDlaeMViYkVlB+aDk29+DXqKKmOJ+g7Txn8MMVQaKf5
	FgP7o3BSiZQHAAbP7zjnhowesCwd1dVKtWqXy0X4CDVf1138MZz/6Qw0SffOQ5W03s+fgPxbrcm
	VvabwZxmP2Ui4UGuYo1gVXaIO+NxIbyeoupYPUaGN3IxTEq2Kjob38jQRxNWaqXaDW8Mb16YfRZ
	NJOX4X555a5ifCkjAIY0syHI+NLG2X7UL5TAzyBQKv1YozPbPOtW4zN0MeyI2uhSJ+2JM9miKJW
	1j8Ic2K04wyCUft0CwMueLsdIPTWlMDp0Kh3oMe6Qr8QnPI518UBlt0G/chW6HqOqjW+bvqNOHX
	5y+d6D71+9Qg93vUhoKr/Bjtkfx0XUVasdVQznhe8/CmqzfMzTZRZcU7KRmQ=
X-Received: by 2002:a05:7301:428f:b0:369:5583:bf4c with SMTP id 5a478bee46e88-379684ae79dmr11080301eec.28.1794855522299;
        Mon, 16 Nov 2026 10:58:42 -0800 (PST)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37956bad6casm35583453eec.26.2026.11.16.10.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 10:58:41 -0800 (PST)
From: Hungyu Lin <dennylin0707@gmail.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	namjae.jeon@samsung.com,
	a.sangwan@samsung.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dennylin0707@gmail.com
Subject: [PATCH] ext4: check RLIMIT_FSIZE in insert range
Date: Mon, 16 Nov 2026 18:58:10 +0000
Message-ID: <20261116185810.82581-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
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

ext4_insert_range() grows the file by len bytes but only checks the new
size against s_maxbytes. FALLOC_FL_INSERT_RANGE can therefore make a
file larger than RLIMIT_FSIZE allows, while ftruncate() and the
fallocate() modes that extend a file fail with -EFBIG and SIGXFSZ. xfs,
f2fs and ntfs3 already refuse to insert a range past the limit.

Fix this by validating the new size with inode_newsize_ok(), as
ext4_do_fallocate() and ext4_zero_range() do.

Fixes: 331573febb6a ("ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 fs/ext4/extents.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ad0d80e33f60..94b9e091ef5f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5803,6 +5803,9 @@ static int ext4_insert_range(struct file *file, loff_t offset, loff_t len)
 	/* Check whether the maximum file size would be exceeded */
 	if (len > inode->i_sb->s_maxbytes - inode->i_size)
 		return -EFBIG;
+	ret = inode_newsize_ok(inode, inode->i_size + len);
+	if (ret)
+		return ret;
 
 	/*
 	 * Persist the pending zeroed EOF block to ensure i_disksize
-- 
2.43.0

