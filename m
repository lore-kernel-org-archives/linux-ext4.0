Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EEC190462
	for <linux-ext4@vger.kernel.org>; Mon, 13 Apr 2026 06:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776063087; cv=none; b=TBxDdR8PVwByIcIEuJAvmZZ1BZA0cR2oJJnIxNC3+pN59JtC6Fmzdo2d5ps9E9HB2urkAL+4a+uOKgW6nCD2uSMHnqg/WRkWZtJFyWwnELYVRzE5AQRPIXMS3YtdcFViJbxZ1yE2rgRdIBrrJkZcd6OOv3tubJ17/A+s9gmFKa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776063087; c=relaxed/simple;
	bh=hdzEHHiDuQkYCT0oJYKMNmRdp7u8sLKvaQtixqzWmk0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jLxb5WxCvlkhlVL4phXzPAAhdEYS9+nXlS+lqqq13tioiFF1nrNczQc4snEFIkEYP/r6ZSerlj7VabCW3khfaKRVBIV0ir9WBVivz/M24DuHxCEmwvv4KmPoa0PwOY7AyLALzlF8XTE8HXbOa20A+6HDRjx1hWP3oXtFgA8untg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20251104.gappssmtp.com header.i=@gms-tku-edu-tw.20251104.gappssmtp.com header.b=xR/cIh2g; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20251104.gappssmtp.com header.i=@gms-tku-edu-tw.20251104.gappssmtp.com header.b="xR/cIh2g"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2b0afa0210bso18593125ad.2
        for <linux-ext4@vger.kernel.org>; Sun, 12 Apr 2026 23:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20251104.gappssmtp.com; s=20251104; t=1776063085; x=1776667885; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Silftnwb2KljcFuK3BSdWypKl196gsQvFRq9QK9DEro=;
        b=xR/cIh2gSW+SYw135nERbnOYNlwOZ0FGutndXRnafIxHVz02bAYRjn/28U48KldZXF
         3WbuZFyh09YcmezNORxO4I+SLGGjLsIiUQvlw0tZW3gb09uBqc0LVuKFb7GdCJQGX67u
         ynIRUnR+ryTxgnAyr5dg7lUxpzWz8/J4LRO/5Sgv2XFwsy+wVkN6z5b00q+qM7lvnnhW
         U2LqdvFcHqCOqX0FkNKizyeL1I04XWsmBttXU7FBxFtQ7NCon/pwizyrjtM0296O9FMF
         /csI7VCRLs8C0JMYVlC4OM60IewKaMrDksFaRmt5XRG6EyvIDzLj0rihNJbW28LnA4wL
         cWcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776063085; x=1776667885;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Silftnwb2KljcFuK3BSdWypKl196gsQvFRq9QK9DEro=;
        b=FbYiXm5imibe12LZstg6MherlwrZl/J77zWB40hbGOuo6jUN80jApK5SY5i7Hq1ZEt
         QsD8zLvlsaph8PITzvgBE9ff53rsx6Y+SP+jMVwXRj1NQo2pq9sQUXxaYShSPRnWqjSC
         Q+miDmC5sA+1Ihch+qHJT1GRfT6DkyV1tTFKjcWbAatsLlnVJLdd4yLMC3O0rOAW0mwM
         PKgIT+n4QAY9SpdPTkYMj0PDV7jFap3glJ8Z8ty9+ta11ZTe+E+aFMx20UukVDHmQdhd
         ZXl55jNsNa4qyEpDfoCrlf/9mO0N8gKUXYTAtpK9m71+GL4IjX0YUItR/UdFizb7i8f5
         IksQ==
X-Gm-Message-State: AOJu0YyHntJ1Lpeuie4Soe3/JbSeW0/8FFTKmIDsIiYfZL0Y+KUgbzWg
	YYYiWtAFARVLOG2UJ8xthma85QjVW6e1eqRz+xdVHvQTtrSQr7LzPtjjlRda26hIInM=
X-Gm-Gg: AeBDieuIXvFf3jxaal4EiLQbm0rRLO2liwnYCb61OngnROZWbTyUVkB9PiRKB7pY+vY
	ChAqu/mPspsIdbYSp69lzxW+rlmQQ6691IUUL7D6/I7/z+ACNx417mjakLNlb5sPW2wODssBTVu
	h3JpXdQ32BM+vMqRb4dy8UgSYW6fVjL1UTpRDiZTRgiXP3kqTGJd04h/EYfgQXFoIpiZcgmO8aM
	P3KBFBW/ft3aHqBIKijVOmJaJsgSo5k63X+wTDuccdAxSwmhET/JR8hZeqOz8C3wlBeY1qD/KDF
	NSVst5Dg+u8DGXar66JAI2rBd5OZhn7jFPSl5XCvsXtX242yST4TXaZJyPHErUcX5rcW+J+Mx2O
	Fh3Sv4IHdbIjhN3xVzBiDVn9/CxyGusPnJWJH8DaUPwbp3qpS3gToYyQphRQ2edzFtRP06lzpbR
	UdPDpOmJGZ8P7cGgp/Iuzqms8IChAv/AVRpXUOD6SeZlIJHn5ZZKRnRbDCxg==
X-Received: by 2002:a17:903:1ae6:b0:2b2:5256:9ce7 with SMTP id d9443c01a7336-2b2d5a6121dmr123565645ad.36.1776063084710;
        Sun, 12 Apr 2026 23:51:24 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:d062:a770:8a34:87a2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4dde346sm100107855ad.29.2026.04.12.23.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 23:51:24 -0700 (PDT)
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
Subject: [PATCH v3 0/2] ext4: add hash Kunit tests and optimize str2hashbuf
Date: Mon, 13 Apr 2026 14:51:12 +0800
Message-Id: <20260413065114.730231-1-409411716@gms.tku.edu.tw>
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

Link: https://lore.kernel.org/lkml/20251122043929.1908643-1-409411716@gms.tku.edu.tw/

---

v2 -> v3 :

  - Added Kunit tests for fs/ext4/hash.c.

---

Guan-Chun Wu (2):
  ext4: add Kunit coverage for directory hash computation
  ext4: improve str2hashbuf by processing 4-byte chunks and removing
    function pointers

 fs/ext4/Makefile    |   2 +-
 fs/ext4/hash-test.c | 546 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/hash.c      |  64 ++++--
 3 files changed, 589 insertions(+), 23 deletions(-)
 create mode 100644 fs/ext4/hash-test.c

-- 
2.34.1

