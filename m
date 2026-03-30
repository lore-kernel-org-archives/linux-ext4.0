Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D0633CE92
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2026 04:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774845823; cv=none; b=Hgymmj9qX1UBQ73mkSSkZKdo1FKoRKxlN4eaWBLonMNAFynnsP8HYcX9h02HLtdPG3jzSJitXsTAYB24+ZU3YIdWPSnsuS5/u43RhGnHNqHzLsFB297q9zgqjwZPIDaNy3iZw++Gp0e3Mgh8waFeiGOnFEUwqT2ePPBa8DsbHBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774845823; c=relaxed/simple;
	bh=I/LoCE7ghR2fhykvvR2K6LR8ap7mzobL/J0+U6S3zt8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NgeKzVk5b1Nv+Lp0D2Yj6jLLUYCPt3grjUUOUY+2HnxQSQLj9YtyCR4RhDgBDaarQdYXUQkQv4g08DTVc1bCycvQKlupIvJKU38eNJoSLfwZHyLxDRsz+BkXhQ8JnmtouD/KEn6prMzGWrGTjiTQAVHCK7/VF55ntjCEtt4Ibhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pMK0iePC; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pMK0iePC"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-82a07738118so2226887b3a.0
        for <linux-ext4@vger.kernel.org>; Sun, 29 Mar 2026 21:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774845822; x=1775450622; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RVoLlmJXuoZFlO/T8+1qY4HcBw6xf89P3loI3tBHNJg=;
        b=pMK0iePCS5aflif8zwUM+BeK5h6mjM7yWshMb/Wjo3apEL74HB7aJY4SsW/peIEx1o
         DgvSW+BiXdCQXjJsJ2a9VjnF7TA8NLj00Z+AKQYeKzU2tNGJCTBHFtbEuD0MSMTfSZn2
         gm5Ak9CJ4CEca8pR3Bzt7XX3/Ar106N+0gpDzLaGMexUJWwsLI35mmCCKBkCJFzYtKti
         8Hd52F7zKOxql6I/OfRR3ua775/HvJmeQdQDSEQCwtPkHQnPZzXWmDsHr7QwLMxhP/li
         yIryBxCd+LG7rz/JMGifF13yYzRQYzwdgJrOcRm6waE+kMO8IxwA6bpZ0eudHCbDCU3Z
         8xOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774845822; x=1775450622;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RVoLlmJXuoZFlO/T8+1qY4HcBw6xf89P3loI3tBHNJg=;
        b=V9TyyvTw8Koxzdm+vwcXm9zoXwzEilEeF8iATBh4n2WbM+9xaAFclwuCw0v7KqOmls
         PO/G0EYnRBDdZ24yhrtg0CbxSHnHar8bbVzDPovSRqj1V5UjPANQ3e7BjTDxSO7lWMpc
         X+WF5GJtAAqu8vD1CBXZk8hx8CeilZdSxysk9eS7WmUZFCvsjTjsGSn3QbXQxqrQQxn5
         Yy9az43q8HDof9rsuplTIkE1CGn6qZmYjp5zLgtqtSyRbJqb/9LXG/ZBjA0qvjl8ZDmJ
         +DcgZ0pxQ2hmavL0lGzNSKWCtl7bnpOPDVdX37zbqX2S3h27HauMbpwgRhCT5pasIYfN
         hZcA==
X-Forwarded-Encrypted: i=1; AJvYcCV5GRXJeJLEDJ5pK/AgSYdPW8+IGkpHUtYk3Vd0NSJz7rAh1winXbYEC66gpVBcn215oS+/z5H2uEcz@vger.kernel.org
X-Gm-Message-State: AOJu0YxN1XNjCLuK4SAXykn/XBEU8SGb8DCrUHmadD/CrlHn0uQWZuOl
	aHSV5pia+XPpQQIeW+naLLgbHCWY0KxI97e/MqYaLEV9ZU3R300JXLsE
X-Gm-Gg: ATEYQzwvjL12279pK0oXSkV3iDxm9HMaym6du88bftn6zkWvLAYTLyneC9X8B1B+nEp
	zshgr/vzZKXN15OOpbM5eAIzraK2RtinmiEHcGkwHwG4gg7XJ9EmOACn52q9H5H9w8qVA/WvqGK
	I/EObbaPld+4bQY+9kuZu90hMw+rlB67SV3x2H9E+3ftfHAFAACotFirBmFs9SNEPxI9Wz191y5
	CAU5CcC6qZC1AcK4eQsyMisUQRUNGJnJm81qgIaM5DtuXc98c+1/S9dIlbwrW7fliScOeuNcguo
	+drGd/1J/e4qRHLJaDw8nSJxfxuXizx6yboq8jVjFtDAD/c432Ytkq7yW/twpC3Q4E2oMGqgpxq
	S2K/9E8fDhUvk3ff54+eOQMIZnAKaL8USMygn80Z0pomm6irwM9fNPpkdkCAwHI1o4s9B3vtc+V
	uMhuC8dgzD1hwNWlgkwtdEoscmKEpvw6uV6m7wO7KTzR12cxLiOlF5VQI+s6pqo2CMTKrnK7eQj
	bPqouo=
X-Received: by 2002:a05:6a00:b95:b0:81f:9b4c:81c0 with SMTP id d2e1a72fcca58-82c9608696cmr10223841b3a.41.1774845821829;
        Sun, 29 Mar 2026 21:43:41 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:d8f3:146b:e2bb:b2f0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca8464576sm6075154b3a.14.2026.03.29.21.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 21:43:41 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: axboe@kernel.dk,
	tytso@mit.edu,
	dvyukov@google.com
Cc: adilger.kernel@dilger.ca,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+fb32afec111a7d61b939@syzkaller.appspotmail.com
Subject: [PATCH] loop: block loop reconfiguration of offset/sizelimit on mounted device
Date: Mon, 30 Mar 2026 10:13:34 +0530
Message-ID: <20260330044334.373480-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

LOOP_SET_STATUS{64} allows changing lo_offset and lo_sizelimit while
a filesystem is mounted on the loop device. This effectively mutates
the data visible to the mounted filesystem, which is equivalent to
writing directly to the block device.

When bdev_allow_write_mounted is false, direct writes to a mounted
block device are blocked via bdev_writes_blocked(). However,
LOOP_SET_STATUS{64} bypasses this protection because it modifies
the loop configuration through an ioctl rather than opening the
block device for writing.

Fix this by checking bdev_writes_blocked() before allowing changes
to lo_offset or lo_sizelimit. If the loop device has writes blocked
(indicating a filesystem is mounted with write protection), return
-EBUSY. Other loop status fields that do not affect the visible
data can still be changed while mounted.

Export bdev_writes_blocked() so it can be used from the loop driver.

Suggested-by: Theodore Ts'o <tytso@mit.edu>
Reported-by: syzbot+fb32afec111a7d61b939@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fb32afec111a7d61b939
Tested-by: syzbot+fb32afec111a7d61b939@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 block/bdev.c           |  4 +++-
 drivers/block/loop.c   | 12 ++++++++++++
 include/linux/blkdev.h |  1 +
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/block/bdev.c b/block/bdev.c
index ed022f8c48c7..96520fac7b2f 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -860,10 +860,12 @@ void blkdev_put_no_open(struct block_device *bdev)
 	put_device(&bdev->bd_device);
 }
 
-static bool bdev_writes_blocked(struct block_device *bdev)
+bool bdev_writes_blocked(struct block_device *bdev)
 {
 	return bdev->bd_writers < 0;
 }
+EXPORT_SYMBOL_GPL(bdev_writes_blocked);
+
 
 static void bdev_block_writes(struct block_device *bdev)
 {
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 0000913f7efc..3f3a29abad1f 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1239,6 +1239,18 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 		goto out_unlock;
 	}
 
+	/*
+	 * Changing lo_offset or lo_sizelimit on a mounted device is
+	 * equivalent to modifying the block device contents, block
+	 * this if writes are blocked on the device.
+	 */
+	if ((lo->lo_offset != info->lo_offset ||
+	     lo->lo_sizelimit != info->lo_sizelimit) &&
+	    bdev_writes_blocked(lo->lo_device)) {
+		err = -EBUSY;
+		goto out_unlock;
+	}
+
 	if (lo->lo_offset != info->lo_offset ||
 	    lo->lo_sizelimit != info->lo_sizelimit) {
 		size_changed = true;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d463b9b5a0a5..6b908e9dd035 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -820,6 +820,7 @@ static inline bool bdev_read_only(struct block_device *bdev)
 	return bdev_test_flag(bdev, BD_READ_ONLY) || get_disk_ro(bdev->bd_disk);
 }
 
+bool bdev_writes_blocked(struct block_device *bdev);
 bool set_capacity_and_notify(struct gendisk *disk, sector_t size);
 void disk_force_media_change(struct gendisk *disk);
 void bdev_mark_dead(struct block_device *bdev, bool surprise);
-- 
2.43.0

