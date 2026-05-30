Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0DB33AD8A
	for <linux-ext4@vger.kernel.org>; Sat, 30 May 2026 15:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780156738; cv=none; b=ohGmzRPuZsn6HJRpTDQu/blZdQMd84c7V9Se0WV4W0f8Mh2JNvY25X87wgltg9api+E9baBOWLXLdfsmJ4KUEzOv3DwbazGdya0ywEupOn+9e3+vNOEx/yDtoXPhEZ4o8+5DjDdHSyE8lpxyGfdenY/Sdu0eRsUWEz8YsLMthEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780156738; c=relaxed/simple;
	bh=BrCPHH6r5zsUyKSv7Mkv7S3zvmAZrWx89EVqhJ2zFFQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HO0Z5h8dGyr/Ulox6kHFKFmQm//Gc8PeHGu5nX16kdTkYHIzMn9bVFzcZ7lGF3O58asM+GaRnNUG0rfIIk62d8jibowYtPGSqyM50iJic/jfMu7BCaEdbDOg5BAQB0hifP5UG9e+baLeOeFi6mXRut0UFYjhFxSHEmLUpddJ3Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20251104.gappssmtp.com header.i=@gms-tku-edu-tw.20251104.gappssmtp.com header.b=AbQLaC6g; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20251104.gappssmtp.com header.i=@gms-tku-edu-tw.20251104.gappssmtp.com header.b="AbQLaC6g"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2bcd730e090so116302075ad.2
        for <linux-ext4@vger.kernel.org>; Sat, 30 May 2026 08:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20251104.gappssmtp.com; s=20251104; t=1780156734; x=1780761534; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Idt+9cE9lpQYfI0YUQDcBwBnasY+aDQAevlG9dgnbbo=;
        b=AbQLaC6gjZhUoWCJ4QKXYaeo3qlFJIiPY+94Yi4MkDKMzijsyJvniw0RMK5NsYZKNA
         vucJhijrRr6szZUily7RIGrPLS27MwdZzbpi+2kYXsAkAhnw/XRmKUqa6BukNjsL14at
         2/21DB0CZnvW7TgcUvk/naY1J9WcuryRW9v7NIC35ehg1bGdkb9IcpJT0aqquFb65WlH
         5rZtS5QaGkH1WRUasFEau5HEYZzQMvpPyRhpTUu/thvD7wG1367ljEWveiXCskUuaewJ
         cGTWOrEn9kjxBj/WocCV316taoVAgLOY7lADNlywV6gyjThrejaY4DmAkLcWYxX9tgPr
         4btA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780156734; x=1780761534;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Idt+9cE9lpQYfI0YUQDcBwBnasY+aDQAevlG9dgnbbo=;
        b=XfSKkzy6eVCxdHk6MAIQOuSDsvfq4bQquDguhopp9wtzE3r1ktwAvw7vGbAvJtX8SG
         9kMcWEiMufsj0B6lVajqdMiDkD/cvptET4kgdCVR4WYHILNLAw48scU6OEHX77BmADZb
         zdVRY39XN0d6X9t1At189o7dNR3VoedriDiToZbDlmtRX1WpiDznhIRMHD47XuvOzJnF
         oWTg1agtNHRQkxXAnINGstz+rWJg0rsknUlbSTvJyBweVGj/9l948MScFPXeoUeECb9h
         J5AYITZNin8XoITUYdTS1MAvVxC2lvLKtItrp4etymSD8ees3hzyzjDRXjVIG9LaiDiV
         lsSw==
X-Gm-Message-State: AOJu0Yxr2XzgrRxskYI2kiDlS5hhis5uj+yLCHENPE+yTz5miNnBlf8n
	/IiUXQP0lMV7lsONMhX4l7P2ktd5tgf7cfVAR7mGqOXNgrm4Yf8utZ6B8Ll7FNSohV0=
X-Gm-Gg: Acq92OG05d58GvgAqgS+sU97yLL6/lqYv1kWmh6O/7cy6WBcPoNZ+hlE8Aj97J3pzVA
	BCQ6YTdElkwXKR/Tp12cVO5h3Wrx1XtfASjJCgbBhYIGBLhoqGl444tLcZtWI7DgHvbZtI4IxLG
	YJHSXGtPxCtsCjJrF+yhRwpgFy/fplS7KAZocizkgGZQZCWoBCb5Yu/jyvIdhukaPLXkRwK+B9e
	b0ubITyXhR+O+a7tlaY1dpNtkH49Z6TaITUu9CzdalIrUJwca6VHos9WyeI4vpbdTky3pD+hT7R
	ZIUS5PFue9o6LQf+2PjmTNkbKcQyMnwwSLUR8B5IcL8oLNLSgam8h7qm0VlJV3PePGHQFsf0YP+
	TEBgxJxTRKZP38sf5G6Jt9OZTPUcM/ge2mlBlx8gjwzUeFsBMtzcTOxt6/Lr2xSxf9tsUYIfymn
	nwpW2b8x4p+PqaJ17oLRFVSPL+YJJV3CMTPPRot8XxGsWU3tpg/570JuGO
X-Received: by 2002:a17:902:d4c4:b0:2bf:2256:732e with SMTP id d9443c01a7336-2bf3684da42mr54772185ad.23.1780156734131;
        Sat, 30 May 2026 08:58:54 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:429:4bda:e5dc:8a16])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf23c1e46asm51130855ad.61.2026.05.30.08.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 08:58:53 -0700 (PDT)
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
Subject: [PATCH v5 0/2] ext4: add hash Kunit tests and optimize str2hashbuf
Date: Sat, 30 May 2026 23:58:15 +0800
Message-Id: <20260530155817.2311587-1-409411716@gms.tku.edu.tw>
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

Link: https://lore.kernel.org/lkml/20260529200308.889706-1-409411716@gms.tku.edu.tw/

---

v4 -> v5 :

  - Fix NULL pointer dereference and out-of-bounds read in SipHash tests.
  - Use IS_ERR() instead of NULL check for utf8_load() error handling.
  - Fix unicode_map memory leaks on assertion failures via kunit_add_action_or_reset().
  - Avoid a UBSAN shift warning in str2hashbuf by casting signed char values
    to __u32 before left-shifting them.

---

Guan-Chun Wu (2):
  ext4: add Kunit coverage for directory hash computation
  ext4: improve str2hashbuf by processing 4-byte chunks and removing
    function pointers

 fs/ext4/Makefile    |   2 +-
 fs/ext4/hash-test.c | 560 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/hash.c      |  68 ++++--
 3 files changed, 607 insertions(+), 23 deletions(-)
 create mode 100644 fs/ext4/hash-test.c

-- 
2.34.1

