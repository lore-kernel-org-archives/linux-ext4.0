Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493C247A88F
	for <linux-ext4@vger.kernel.org>; Sun,  4 Oct 2026 18:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791137208; cv=none; b=TM+JPP0+/jIzPO97Wec+SfrxxZBJW59M3sIpLZvbJW4tdsRZm1PjGN6ey+kllFhtDz56m1O9CCxk3uoi3mANDUhkPDllYTP9ocvIWQeLC5UjTHY8fBUKw4fwfFDpAY8kG3UUcW1l7gQEgyUlR7LfSnhtg7sdFndWxF/6j2WHeNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791137208; c=relaxed/simple;
	bh=J+rAe8YaV0xE6ynsuCf8y2AgnV7iwVIBFQVqkbHSmcU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=O3Td0K4WMlgVhzBfupFmIUljShi529hmSz6VCRrxLgVoF/TCoZclQBe5IapIMHzVPB5oEQkEsDgL3f83DheHdHIiMK6DpmayW3lNiILQY1QnR1dNYI8uQK5RAwncjq9YNHkTKWr/M0ZGtt5dzzYHtW1x84koCUBx429xSP7YEPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iTn1sU2F; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iTn1sU2F"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e79a408deso6102295e9.2
        for <linux-ext4@vger.kernel.org>; Sun, 04 Oct 2026 11:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791137202; x=1791742002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CeVyw0XFTEgDWZ2YAol6WHysCU6w9ObR3PQ8hHYNkL4=;
        b=iTn1sU2FG+AeaKQFCaZnQXTA7ahgpiGRlNcJY07y5WXJ7ONHksiIW/72dLZEKa19CQ
         63hQak5WvwLTQRoMTEKUBL1Pa8Yjdqn5hTVxiKLHwPxQHxQmuPhgSwbEnlGBN0omRthe
         frbwhqryNgDRRnaZm4sXC8k7kOD0yV9yxq8eTEjK2ji5P5gdJ4FcIm6cKjNzNXCHaAUx
         0EduLgP1xsnYLE3DxCHJII7Z7BlRvx14QAHs/Ol+VBar6DgI50BcvOJi80bjLwbN+q1J
         Ygj8TEH7JarECTpniXAmHTahNp65N3JBn1u9GIcNx2lmO8jIO7erRPyA75PpUyCom1jC
         EDmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791137202; x=1791742002;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CeVyw0XFTEgDWZ2YAol6WHysCU6w9ObR3PQ8hHYNkL4=;
        b=rj3C0Sgq37iNJosr7HimCCj6gCECg/R9hBk1HlDvq1bYMzVOxNdmxNEPxEDucTaAjL
         JEpVdtWLWwCWHPULxTOE5W0iOleasGftP5D7467bVUU1JqrSuILP+dVBtSu9HyAkXR+O
         wTNDvICh6OMY0qynQdSB0hR4ehzIf3aepnwG8ohQ7X87+hKJ/5H1uQ8ZhD7ry40Y0SrI
         10J5MtQM888Vf4wflpyAIMSEXMSlKYA65FvZECKF0PUw8zasRotUAs37gdFsRZjrLwQI
         Y96MK/Fo/Fg7jndvXI8lSijIfL3CZlkixHHTuI4yd/vIHzheKHJfLGeo69CCZj/BKlcz
         EYvQ==
X-Forwarded-Encrypted: i=1; AKwUvBxgKEprgYD4XAmtOfR0a2L9X2mSXHUmgqhJZVICIgGgGBW2AfenY7Rd0OGTlrxraWlLKmFaZZ+NgAjC@vger.kernel.org
X-Gm-Message-State: AFuF++lgMydi3/fT+JnevGqSF3eMEGpjj67ZLdHGR90oXT+LRKZ1HqEU
	XfoUnOg0YpTksHup+HfZHOkLOulU5J0/6U4ciBKDPRVESZHVPsiIPxTi
X-Gm-Gg: AYBFou3TOez6deWpI5h+kgdduqODB0RuBzWLZoITfZ9m5hv5+fJi4jvDAhTureMGwP/
	jUqJ89iyWaP0QUWHthpJwAvwMmR0IzMmD6eqGsfXCEXdVr0n+obG0n4O/ZRK7c16J5fVZ2+bq7c
	ZkQJ7g/xSYPgEr4dXTNiGGjKyDzPAj3V9s4Zk1vd4p9h468Pw0ZEK7dCdJ5EobJh2w/Msc741Xe
	rnMjcDS1hoD6IF8zflgbVoCkY+5sNtafJxh1qcrYFkLPMNgc8JVfZRbF5oRnLIdLre/6vCQrTnq
	HYElj/5lDXH4WlCGaI6X2uMjYXfLKrzgigFOaHFY3r4FSylFNSvZyZrdcOIjT46J99MEpimO6ki
	lKFitetuZl9prNeiWqHxmq0Cn7Q/L7oXvyWUxI+oK3IOdTximXobR/wDqIYayWXCbyI3ZciUv/7
	OwkNIGH4Db1gra1OI4J0fDgWwiFBds6jS3TZeii4r3Q24Von4H3wxtDR8AbA0IAcF84eFKuA2Nh
	xmuX/DJhWCr7IZqCW5pZZrUwQrNHqETEQ0TufVKdkkWiRrQ7ye7hw5GAL+NovtYgx7wd8cVTzHG
	y+G0Sq6IX21Bse6neh8vX7TmxRSheYERK99D0Vitbupice7cFjBCmBDaZhW8hRtjQD2moYs3kcE
	HzA==
X-Received: by 2002:a05:600c:8b6a:b0:4a0:2391:6529 with SMTP id 5b1f17b1804b1-4a02757f1e4mr134280115e9.29.1791137197310;
        Sun, 04 Oct 2026 11:06:37 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a190-7401-a90c-9d77-a1b8-e6a2.310.pool.telefonica.de. [2a02:3100:a190:7401:a90c:9d77:a1b8:e6a2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a02752aeb3sm283644635e9.0.2026.10.04.11.06.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 04 Oct 2026 11:06:36 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: return an error when a journal block is not mapped
Date: Sun,  4 Oct 2026 20:06:29 +0200
Message-Id: <20261004180629.27213-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the internal journal inode contains a hole, ext4_map_blocks() returns
0. ext4_journal_bmap() logs "journal bmap failed" and aborts the
journal, but also returns 0 and leaves *block unchanged.

jbd2_journal_bmap() takes that as success and uses the unchanged logical
journal block number as a physical filesystem block number. Journal I/O
can then overwrite filesystem blocks outside the journal despite the
abort.

Return -EFSCORRUPTED for a hole, matching the error passed to
jbd2_journal_abort(). Keep propagating negative mapping errors.

Fixes: 62913ae96de7 ("ext4, jbd2: add an optimized bmap for the journal inode")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Found with an experimental clang that warns when a function returns 0
right after reporting a failure.

Recorded QEMU A/B testing used x86_64 kernels and a 1 KiB-block image
with a hole in the journal inode starting at logical block 40. The
unpatched kernel overwrote filesystem block 40, a reserved GDT block.
With the patch, none of the marker blocks changed. There were three
runs per kernel.

Both kernels logged the mapping failure and journal abort:

  EXT4-fs (vda): journal bmap failed: block 40 ret 0
  Aborting journal on device vda-8.

 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index bca0dc87d0b7..3e7dabe45153 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5967,7 +5967,7 @@ static int ext4_journal_bmap(journal_t *journal, sector_t *block)
 			 "journal bmap failed: block %llu ret %d\n",
 			 *block, ret);
 		jbd2_journal_abort(journal, ret ? ret : -EFSCORRUPTED);
-		return ret;
+		return ret ? ret : -EFSCORRUPTED;
 	}
 	*block = map.m_pblk;
 	return 0;

base-commit: e767a4ea70a3992c37ed604157d32f0dfbf9b1e3
-- 
2.53.0
