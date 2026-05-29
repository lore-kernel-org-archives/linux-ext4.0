Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADB6426ED5
	for <linux-ext4@vger.kernel.org>; Fri, 29 May 2026 20:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780085056; cv=none; b=gMZh6J/BVQ7I1PTfaiBlZnfYNoauJl/53OdgTISFQYK9IoymFf0wx3TfwwEMozGDllXfu/R5z/goox8FKTC5z3P9IXkLeq1Q30VKsRFvGhjcjzFanyFVczcg0MT+mxf0VtL7Bn5r35ka8FfNHfc8eeOx/F7Fhq+p3ag83G14NyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780085056; c=relaxed/simple;
	bh=4VYCnTzsBua94qSojnAG+1PXkA0Q4/XbwdYlS8V9j3w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fGu4ETSXtyhiukRt8r8PQdPV4gH17PecOaQzPCdGuQ7dQ9WoMrTnBSDNrWEPWqFe9JnLk47TBKqbeSjN+eIMQg0hspIC36pi+SMtFYz9bbDyf5O01l50cuVj/o94EhmbZVfq3vnTLvtVTx1zSQWRwyNnvgEdabMvlK9lhMb1kxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20251104.gappssmtp.com header.i=@gms-tku-edu-tw.20251104.gappssmtp.com header.b=Mz+vTni/; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20251104.gappssmtp.com header.i=@gms-tku-edu-tw.20251104.gappssmtp.com header.b="Mz+vTni/"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2bf55c39e16so939365ad.0
        for <linux-ext4@vger.kernel.org>; Fri, 29 May 2026 13:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20251104.gappssmtp.com; s=20251104; t=1780085051; x=1780689851; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VYEUI7ha5/k7IrdtdHuKZLZ4LOY2S2118Gp+anAmFjc=;
        b=Mz+vTni/3jPpbxCLwIjrOx6rPt+VFJFT1qC5kirOJd9MYbJ8geWyvQbIO98l7mhsDH
         e5QGUJS4O28pfyAIUpHcNy129IpTKREIDQJYT0o3hHaJVyRnWZCxIpFuoPKfXyO4A0Di
         +7VROlThtVA5UHcyiolLkx1F5QfS3qoqwdu4g6D2ehf0oXLrmCD/i2GOrrQEWjbW2sFW
         M9oA5hqjuSQry4+DX0VkOLa3WpNcKdwOQHJCYT7eIwqFcZBV1ARPM+1R4xylb6DYdVtP
         yTCnQ0MlbGmkJU82JI6FjYKLAwk+4QXr7EJIgd/yESUZt0fM87Z6xb3FrJh3dIK1ZaCm
         kFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780085051; x=1780689851;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VYEUI7ha5/k7IrdtdHuKZLZ4LOY2S2118Gp+anAmFjc=;
        b=bz/lh2Ol8da8cih6l2+wxVNtGf0UDJNKp7kx5zQojWqXDgT/PNaK/GUZxvj8af5XFV
         Yg4Qb9c+Q3iu5Sq8SJ3XTN9Auym+1E3KDVWDr19PiHtGFS/t2Kqh4Mi2IcVeSc0I56pK
         prq8pmVKUHRr5rIYmFKp3jf0DEDj1zbYOyr6AkRMkCaMd7NnQoIKPnoTzH/kfB9xmlVE
         /U7iv+qIWE0QdME2Ol3v76EEP9bDt0P4lbvtFBg9p+AOgREFndwAT5+of2NIp9WYuOuQ
         WU+d2XF2BbMw6ghg8/1lQH1tpjVWBJWMSGJRv4oo7rzvjCvuUnI6eUxKU/yz/U3chgQT
         0o0w==
X-Gm-Message-State: AOJu0Yy5cXedbJ9g5E3RQ61nYqtJewXiZ3hWBvFI78uw0nK6AUub50mF
	vT7h4hPvinV/ue1YXX8fWiaB7ONfg59SSi5PjzA2fzTXfyk/lzyRfhs7tDAAabW5U3s=
X-Gm-Gg: Acq92OEbXdHvywjtKTvy2OpKv3QoQDo9TSvpV3a9vLpshON6ZMY6lSevinl4s0ub05R
	/QOj/VYpwEFetiFVhodAYDta7gYUUqH6ZynXIaxVejifQpFfXN055aTJwh+ZqX2f3U5ZtqeNhX2
	mMsFsSq+5wJh4V0ge0DJZBMUt2uYSG9tM5B7kOow7ioaY0+1sM0fyyGz2XUWPTh58YGHslaZaRP
	mF9dSBpz052mFxWskmadUYPHE6f8KGDFJTPW534om84ugFesUMti9ivxC4AjdF4eCYEExgfDR3j
	07JNkvvfehE7yJEDzPAWqvNgabcKD3OoSKgws5dXl4OmwAXDCWg5qnucKNf+B9TSxiST7z7DuII
	rLs4rN4IUTOO6RJKSfBRrFTY1tYXRWgw2VhYc62t/PUZRs8yxxS+4FqytD68eREq+qKkyOHSiTL
	g6o1xfGij9o/tzD/EYOzh8p4ci7BoA0IC39yUPX9CCH9lZby2qtOycE3xu
X-Received: by 2002:a17:902:f711:b0:2bd:8c03:2efe with SMTP id d9443c01a7336-2bf20651894mr45672565ad.26.1780085051607;
        Fri, 29 May 2026 13:04:11 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:2c74:88a:7b8d:d752])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf23c51f80sm30140075ad.80.2026.05.29.13.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 13:04:11 -0700 (PDT)
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	edward062254@gmail.com,
	visitorckw@gmail.com,
	david.laight.linux@gmail.com,
	Guan-Chun Wu <409411716@gms.tku.edu.tw>
Subject: [PATCH v4 0/2] ext4: add hash Kunit tests and optimize str2hashbuf
Date: Sat, 30 May 2026 04:03:06 +0800
Message-Id: <20260529200308.889706-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds Kunit tests for fs/ext4/hash.c and refactors
the str2hashbuf_{signed,unsigned}() helpers.

Patch 1 adds test coverage for ext4fs_dirhash(), including the main
hash variants and relevant edge cases.

Patch 2 simplifies the str2hashbuf helper implementation by processing
input in 4-byte chunks and removing function-pointer dispatch. This also
reduces overhead and shows roughly 2x improvement on longer inputs in
local testing.

Thanks,
Guan-Chun Wu

Link: https://lore.kernel.org/all/20260413065114.730231-1-409411716@gms.tku.edu.tw/

---

v3 -> v4 :

  - Fix a modpost undefined symbol error for ext4fs_dirhash when building
    ext4-test.ko.

---

Guan-Chun Wu (2):
  ext4: add Kunit coverage for directory hash computation
  ext4: improve str2hashbuf by processing 4-byte chunks and removing
    function pointers

 fs/ext4/Makefile    |   2 +-
 fs/ext4/hash-test.c | 546 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/hash.c      |  67 ++++--
 3 files changed, 592 insertions(+), 23 deletions(-)
 create mode 100644 fs/ext4/hash-test.c

-- 
2.34.1

