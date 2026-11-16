Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794811452;
	b=lgLJ3ORDCoLA5f+4uZhXkPGULKuZQsHCd+/tWFgyJYybRgo62V4AqEvMe8dmK8kVkH38
	 vuDV4ga2atPhqAEfhIsJ3w0RVEJS0w3tHOh68J2GUlBjqaFnMjGzIX+UuuihngGyT7pWi
	 gpGV1t20TnoWX2SsbGv+uR4TsQcfeKCnFOl6Jp/E38pVxasKoxCWq3JxsCK+f53qnndoP
	 5bsIS8IliHQwrSyUE1KLhZHfib6KWcuP6j8CuUS5jkekliqpIDYBKwpms5Upkgn1ssNqB
	 Z/iuIyH/cMpw4oWh3kxWIaLM9WqOUKCh5syoPz91RDD/wionmM11rp7OrbZPAyWJUhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794811452;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=S2kVLGTUoyWly+/C2fag29eawzvQ7AOTazLS+saLn7s=;
	b=HyM9T0MaSxfla3QUS3MkHc5SAzH76LbLoR/x9T47hWmyA8wH6yZ59I5rxD2hJTGiEtVw
	 buub6sZdjfEGhmp+9nU0fYH0QdJgKFqkKx5CmNzqcwP91xKYd2yMP3XC1TPMhKBGj0QNV
	 aSQlXDqogLLcfKu5wmVYn5D73ZqwL9LQyLytVe9ZdzyGCu2mJcufr+YjCoTa7mLjKzL3u
	 Gc9N984WFacGCil5rg/jpzgRLXSOr1DvkwYnUuLmc35Z/g4QS7L69N32oufUlwObLrRNH
	 JpQg7/FnxkitSKw0KXZ42caRQ+up+QP/uHp+5ICLjby9cYe7tOpnKBE/HTAU54plhoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=hKAoy+FL;
	arc=none smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42854606A31C
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 06:44:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42854606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=hKAoy+FL
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8a058315c79so1682411b3a.3
        for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2026 22:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794811452; x=1795416252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=S2kVLGTUoyWly+/C2fag29eawzvQ7AOTazLS+saLn7s=;
        b=hKAoy+FLPby085FYwnhijHt6lzgi3Tc6PxiFhWMJVm9u3IlpYhvR1qwoHU22+h6oOC
         2cXzd9NeT1CV/sze76fO8AyATYSTuXroZDLCefi01DxCTFo7CvkTc5Oodo/auBwmboty
         KrvhxIe8/oC66J8VzyCs8pgdEpSYHBpjU5eQvDoW0RhElFhfZgU2AyQSAtstEaTMbb0e
         kkPCVfdFPm1sRWbb/5+llozQKi1EAeDyigN2t3vVMG5WaftL6rjhwCZr5RXSkh0ZwXv5
         4LH7Idb2nrHYOLqockDG7rqy+IiD5bIHNorWucTAS4AK2GNcxMn3mvAc9UoSs3jGHnn3
         L7Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794811452; x=1795416252;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S2kVLGTUoyWly+/C2fag29eawzvQ7AOTazLS+saLn7s=;
        b=fbAMc2Se3zMF4CjjxC9O2Te7tYS/c+SK7VQvBBeKqnOgZnQ3zuWwPvGfLvF87ATxIu
         BLPvGXU6j4+J61vI5Nbmb4F+O1JbqtNMAaHFq0CeC3xeg4lTer9/0MWj/HoyR4QOdQxv
         V2HgAy7Y9tjcYxE3qgPLv2sz4BDinQ1nZjFs/Ybl8x2/gEo9mHVKCwrwqtF+eBTLLMzv
         XcKLTbcU7tno4EDDCR4MHavA4zN9qf8QL9odRZRa3CHOXj+ppPupB/Aru9Lx309Yke8f
         WNn1zdOgDyZqQ1oJ4SZwJGRbNCe6yY5KVNNa324ON7AyKj/JemJEHESwNG0J9xIQXPiS
         nK4Q==
X-Gm-Message-State: APuU4Z8Pz05Lhu270wIEQO2WM2iNuQnhCNd3RRRP7zNGzxs63P38SSgR
	S36uMKZHXDpm9TcvcKwnTQnFjjO202OODE3jlZmWm8Lxtxh2Ka3kD9e8O2xqNBHPbK4dyp+RXyl
	2BAnb
X-Gm-Gg: AYBFou2f8p1gc+DS0A0cK3hMn9SVp8eoJmegJU13IrlzqqlTrww442F3NpfgCvwh2Nv
	LBprW4mLS2G7O76fOewf0wXhx3gpR88+EFtEAqyZcQmG3I6ia1bQopz765XZ1rw1mE9kA0DQgPH
	ZVhwYAXm+YsFZmFnUqPtbFb5gERoDQMh4UW+KBNfI0vTzYHfP55fJf/mHlSQuevJ0xwA66JtYHw
	DadoGBQYlJKJS12nj5OsThhBNdVx95g9BJV+ptdj8+dIbzuTN9JxKFQt+z0//1K56vaBYFHBE+E
	0i5K7av6FxPsunSZU2iGGysmaJisz8qbpaReo5WijsFv0l7qpl4b756VgBzdV9TIEOwoCaUJUyS
	Y87SHjl3jTZkdSySacWHpdtukUnftVgQmX7GnOHVEwUYfLkOYnqFD5VwglxZ6leOGOJBsA/6M66
	2g6KKuXDNknPQ0trxzmjvAFfirtHSAidSDDqrCS70/5TS2XLfBI+WaME+LUwke1E13W7fF5wB9C
	OWUP9HP4YHIojesndOgNW1toToh2YujHofO4o9jYTAbAWhFQZofJtT31LEQ2F0PN9qV9R2JqWJt
	C++BGtXfvtMpb/6K0a1T+i3LcJzkGxI7tA==
X-Received: by 2002:a05:6a00:1acd:b0:8b6:2fe8:3e16 with SMTP id d2e1a72fcca58-8beb56c9fb7mr8600715b3a.20.1794811451459;
        Sun, 15 Nov 2026 22:44:11 -0800 (PST)
Received: from localhost ([116.132.239.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed2053d26sm3216932b3a.36.2026.11.15.22.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 22:44:11 -0800 (PST)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-ext4@vger.kernel.org
Cc: yi.zhang@huawei.com,
	jack@suse.cz,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	ojaswin@linux.ibm.com,
	riteshh@linux.ibm.com
Subject: [PATCH v3 0/3] ext4: fix buffered writeback error handling
Date: Mon, 16 Nov 2026 14:44:01 +0800
Message-Id: <20261116064404.189911-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
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

This series fixes error handling and races in ext4 buffer_head writeback.

When the block size is smaller than the folio size, a fatal mapping error
can discard buffers whose mapping has already succeeded, potentially
exposing stale data. On retryable errors, those buffers are submitted,
but cleanup can race with truncation after the partial folio is unlocked
and trigger a BUG_ON by accessing a replacement folio.

Submit the mapped buffers on fatal errors as well, retain the remaining
dirty buffers for later writeback, and record the partial folio's end
before unlocking it so cleanup skips its entire range.

Concurrent updates from writeback and failed-bio completion can also lose
io_end flags. Use atomic bit operations so neither update overwrites the
other.

Sashiko helped identify all three issues addressed by this series.

Changes in v3:
1. Simplify the implementation following Zhang Yi's suggestion.
2. Fix the race between partial folio submission and truncation.

Julian Sun (3):
  ext4: fix a race between partial writeback and truncation
  ext4: submit mapped buffers after fatal mapping errors
  ext4: use atomic bitops for io_end flags

 fs/ext4/inode.c   |   81 +++++++++++++++++++++++++++++++++--------------------
 fs/ext4/ext4.h    |   16 ++++------
 fs/ext4/page-io.c |   20 +++++++------
 3 files changed, 68 insertions(+), 49 deletions(-)

base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
-- 
2.39.5
