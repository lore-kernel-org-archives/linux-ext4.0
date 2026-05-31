Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795FF3BB40
	for <linux-ext4@vger.kernel.org>; Sun, 31 May 2026 08:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780214502; cv=none; b=P3ReHDAZuUXdrKpLQ8xePqRjACdfNZe9tXfI+Xx4FeQrNl1mMJLK41MbWsJzHa2qMRhOKSWwYO3s79Yn8sMeSkd8tjq9dh+V3DNZKzJf7nRxQNkIz9DMwoImOr5RFXZkPsBnZ5pPjAInAiaSG7iojmfyCJO/nyLmm4uJ/1iYAXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780214502; c=relaxed/simple;
	bh=58ABsLjjB3hqTQYAu02aAecPOA/W9Jvdr79ZqtFClSU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bQ4DqAeF1cD7XqacTVu+6pj7QpeNNG5mMojEjofmNYapP/B5yJuf1V+uFhGFhFl0mX10CV5j2rfO4hBr+ZklY+vze+x8okEUvxDXUpu76GTKmwoYcfjenQVKoqwcdnqixtrQ7+HPdDTzHLKvYeg8wMQ6TyfV2FacgaO7B120U1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20251104.gappssmtp.com header.i=@gms-tku-edu-tw.20251104.gappssmtp.com header.b=NKt+WUSF; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20251104.gappssmtp.com header.i=@gms-tku-edu-tw.20251104.gappssmtp.com header.b="NKt+WUSF"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2c0aa420401so4970635ad.3
        for <linux-ext4@vger.kernel.org>; Sun, 31 May 2026 01:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20251104.gappssmtp.com; s=20251104; t=1780214498; x=1780819298; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2/Q84AEUJqcidHEn6hd3KLdSUH7qXEvckFGBgY0rOts=;
        b=NKt+WUSFOX0COusXa4jBPRtoHsY0LanjbNBd3C3vT+aO9djkN8t6kQV+37DwGaum5y
         RojZ0wqFBw97sD0OLFXbT5GoSMz4xgvU2k+/oAJh8qpwM7fWpkMPMiefNZ6yn8eYyNlp
         PGCboKaK+54JFr0qTtlpSeHVA/FjZR4NF0aCu4lHneOAihl+J22Ki9kp2wqVZpcMY9dc
         1tFni2JrQdRJLQmETVd3EFGCnriTmdAf/Deix5mQBb9JwGQ5d5i/wtM/BTw2tf1uqfAK
         iq4Ir/znYkqNX53hgNHXjJ5FCjyKURuLjmGgtcqbtgopKOfl2vNOhfQxEs5vaXvBOCI/
         ksTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780214498; x=1780819298;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2/Q84AEUJqcidHEn6hd3KLdSUH7qXEvckFGBgY0rOts=;
        b=mcQGeSChiviCSohtHgG3YtCrQxM5r7AZyPILLEs0+j1vJTqbpfzI79sWES5Oydkhkl
         Byw2GHD4scto+G2cSKJ+XcSWV0prJjKcmNwEvbBZx1fUt7PpoNDrjxk7NR/p1F9rJW9A
         TnKmE2ygSoiK50JyA/ly5TnOnJ/VF/DlMI5+buymcmHTrWoSq3tixw/XLmAH7Lhg6JCn
         DidF/3KTTT7rgkSf0tswXhUUhotOlL3lpOlmBCDein93noh7XYeZYgklbANYKsJeNJDH
         APfLAZW58BgW0avmV+wdL5Dd1hnHH6rHcGKYIHq8yOgI7iskWsSNrLY/JFnfcyT0nHvM
         oBgQ==
X-Gm-Message-State: AOJu0YzNQp6ExEcnX44hO03StZffVPvjg8goYepidbyN/dIdYQPYI4VZ
	rZKkh8LKM1FKO1u+JohLJ9MtbgXg/m+wvethIhrhVeJyveUnSzvIknqy4JjPSYNcL/U=
X-Gm-Gg: Acq92OHVR+Kzr79408aNZc0EN0lRAcoCSiV3No83IrgQ9+sFU715t7HVFJ1auy3T6u6
	3qdarqaeE5MkEZPSmEvUtt30pObmL42iWrFjQtmJosM29SbP5Yv28aa/Vr+X+HGJFOwFGSG2gB7
	QEeZHql91kX8HVc5FLXssLDm/vzhOaVd1b2BjshmT+oGF3W2TVFHQm9S14lv62d4EBAdsuaYxA5
	wtFdz+mGGmf8HKwnghhWQub87pk+dOc22SjCz9322q5qjSH6W8P6CO5GqLNAgzghIbGgPIOoHoG
	RuhBUmcSodVzV+TbSREBC5Z6xVIBBStavku1E5NEetLaN5dU6OKoUle6OTxIKCyOhw6khcThwbw
	w4Ddi161Z4Z2h8YwjP6JcGDpHLGWQMz0jF0mWFqlGWBqUqGpJMfQhz5fqsjYYoc1V7/s1LQ7+of
	k3zq00vQxKDL9uosDB/sTdFxDyk+jFBF6BDBa3ygVVvhvnFgsgvqmFWMVC
X-Received: by 2002:a17:903:906:b0:2bc:8f9a:3642 with SMTP id d9443c01a7336-2bf367d329cmr78669635ad.16.1780214497453;
        Sun, 31 May 2026 01:01:37 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:429:4bda:e5dc:8a16])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf23c3f496sm70588225ad.76.2026.05.31.01.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 01:01:37 -0700 (PDT)
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
Subject: [PATCH v6 0/2] ext4: add hash Kunit tests and optimize str2hashbuf
Date: Sun, 31 May 2026 16:00:17 +0800
Message-Id: <20260531080019.3794809-1-409411716@gms.tku.edu.tw>
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

Link: https://lore.kernel.org/lkml/20260530155817.2311587-1-409411716@gms.tku.edu.tw/

---

v5 -> v6 :

  - Fix a modpost undefined symbol error for ext4_cryptops
    when building ext4-test.ko.

v4 -> v5 :

  - Fix NULL pointer dereference and out-of-bounds read in SipHash tests.
  - Use IS_ERR() instead of NULL check for utf8_load() error handling.
  - Fix unicode_map memory leaks on assertion failures via kunit_add_action_or_reset().
  - Avoid a UBSAN shift warning in str2hashbuf by casting signed char values
    to __u32 before left-shifting them.

v3 -> v4 :

  - Fix a modpost undefined symbol error for ext4fs_dirhash when building
    ext4-test.ko.

v2 -> v3 :

  - Added Kunit tests for fs/ext4/hash.c.

v1 -> v2:

  - Drop redundant (int) casts.
  - Replace indirect calls with simple conditionals.
  - Use get_unaligned_be32() instead of manual byte extraction.

---

Guan-Chun Wu (2):
  ext4: add Kunit coverage for directory hash computation
  ext4: improve str2hashbuf by processing 4-byte chunks and removing
    function pointers

 fs/ext4/Makefile    |   2 +-
 fs/ext4/hash-test.c | 567 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/hash.c      |  68 ++++--
 3 files changed, 614 insertions(+), 23 deletions(-)
 create mode 100644 fs/ext4/hash-test.c

-- 
2.34.1

