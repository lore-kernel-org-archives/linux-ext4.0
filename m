Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795373828;
	b=BUdVq3hIW5VAGUxl74x+TLLJ1hSPjm5A64pwy8GRwBmc8/yLsrOoZ4T0Dwy1+Je6nU9Y
	 w0GGAxCuxcbuvsTTVOqgL6S01ZzxW5q10HtIjcO6SrCQjqpnMpLUP3hgAbxYKeqkI4wgY
	 33Kj1IYtLsBNnVm3FpXuhyzpEuTExGC5zVMlJgv+G6othqDjT5ndti48pYnmUPXjBUY00
	 slYJHF5cm1+X/ibVThORLGvlJBbrioIrpozCiIwsmbiMkV2pG9AR5EKP4RZKk9j6tns0w
	 b0xqtqDHYXCRyeznPb5E4lpuQNykEb4NKV+atMC7XnuEAYmieEl5penukn0FXhoadUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795373828;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=gwVsdS2VxO+lVSjx9HqitPt5+T+GabPdn25jJLmsx6k=;
	b=uN7j/EsHrX3YNHRKpmUWiUd4Wa8c9nc/c9hK64u2Om1xabLD0RDsPIHHAYx4kmD5vgE7
	 CKRfaEirCqaltRRllpiBLjpGRL2iZFVq6S35pIY4DPGGiaQKI+9TNHs4/5a3IekCz4PXh
	 M9AxIhPKlh1MyOC6tBEwISpwefPxCfUbIUfzzJGUUEhbUuvz9HT5bEK2o7wfBr6MJ+/ws
	 bton+vNJ0r0ILGmTNz2tkQIADaZoz25jnn4z46enxyRAz2aYmyRJ4F2HRsghsLkbw5/cd
	 AqHdYGzF70ee8MR96KYZF6PyOiLON2KJp7RMXVtZwknpmBDr/UqU1ZJVSOcALs5XK1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MqnRKfcL;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF4A606A32A
	for <linux-ext4@vger.kernel.org>; Sun, 22 Nov 2026 18:57:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6BF4A606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MqnRKfcL
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso22560805e9.1
        for <linux-ext4@vger.kernel.org>; Sun, 22 Nov 2026 10:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795373827; x=1795978627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gwVsdS2VxO+lVSjx9HqitPt5+T+GabPdn25jJLmsx6k=;
        b=MqnRKfcL4vp58CHr3kNBRw+2DCXdaxeTQuGwJUqKNXz3zyNaiGqK19PwTVl4dmTDsX
         9dGr8iDOz0ui8bodePjStgsmO4jaRlXdiMgDJoj2bW9pe81wzDkernUFTHFLByxVkQgQ
         4LKjD3nPnblDjkea31Ou5thQPR1kD+eqjHRNJjY7z+L0fv+W7EjKiT6BJO+n08SbH8Jr
         iCBtf7feN8NIwgB661MM1aalOX6K5UjZFzy5S973Nr02X8uCU3Q+kQkJKbaQ3bMBrb7I
         CaZF6+dxpKK/3hreUHBGeecQKVb5mccJ3ysmVLy9pfueLAds5If0YyrXZ4QxrsLTisNB
         kXmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795373827; x=1795978627;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gwVsdS2VxO+lVSjx9HqitPt5+T+GabPdn25jJLmsx6k=;
        b=x6+qRy78cSHW/w4P46FYwITSTOUxsJJN6nVEQdsEUlXXbgI5N4Pe7Dek2eFQgGvcEc
         BCe0EqqY1VabszVySHvG2gcSMPwyF/kg89fbORSvz+UxnvR4jkqvJGlv7H4x1ID/98kf
         TzncihQQRyI7IoMvEuMz0l102PqnJkoi4UnqQhf18vn7HiXIkqWZm9WzYgw5cApPoyps
         tgu8aeJaDRvnewaivBDRzGYp5ByXLenq2AVTG1AAYmwL9P/G9L0xaGZlbKCH+g4hzHDw
         9dPy+RY+6UJAfABRT2drWJVk5Z0R9SpBG3BmR3Fmu04OM2WqaxAfsKPLh0UYnPXK01B0
         wIRw==
X-Gm-Message-State: APuU4Z/z18CIl5YJ/hubNK/LbjDmTxrAPwlo/9Ap3gI3T3j1JT6/DaJ1
	tOWxAUTf5d+Xvh2uY8ZTkzEI/V3fnBgcipLTK+rAFA3k1BEOP+WSHkE6RzVeHFDU6e3V
X-Gm-Gg: AZFdTZcAphQaW5Bh1IDTrstk8fYy3IUK3KePYO22My+8gGyEuHzucIuUH/Ys1wTAinE
	qH+wSe4xb2Om2nOQ/9JCGPYHXFfVmsnBi6FXhTR7hAGh1nnUzmV84qVlyZKQB044/yrcOXPtG7+
	fXf7eIqpNkEZH66h7iTjzlEE1rzHex2PGpej76mzxgUIt8fcEYpaXD4YshMaITP51FivU2hDNnN
	hBOqhpkvIuznESeRlztDcW+V/FyVAG7DvsbCr+q43AFGYk6eT51dFGHmyj8BmOSec7O6eM33jz6
	ShKwcsJiKxw3IUntglOnZDj16MQ+yaSBKq24g3okoQ7KU1o3t36jAPHLSJIji+LokfBsWk1k0EX
	JoIB6p7saON3bz1ufNvJIHtRIA+W/mYMhEOEipm3oyIw7NCqGLIxmYp2DMlRTMxBLX/V5MsHF93
	pkYiiAsEtGIz7rLV53EGWn8lIVxcVW+/vvzEY+XCa1wsdlA928QkEOXJjKvq460aSdFZ2xwH7wl
	1+VRvCja266FR0vZ8MSme8Dn1YilynaQpWNJuhb1EewITzKuCl6qSOkgBoF2HhvdfFYM4JXl20U
	oB08giKjLfGpgpvi
X-Received: by 2002:a05:600c:64c6:b0:4bb:6fd3:5aaa with SMTP id 5b1f17b1804b1-4bb887c30fbmr175754855e9.3.1795373826666;
        Sun, 22 Nov 2026 10:57:06 -0800 (PST)
Received: from kali ([182.180.9.193])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb905f0f1csm113765085e9.0.2026.11.22.10.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 10:57:06 -0800 (PST)
From: Muhammad Umer <mumer.mobi@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	Muhammad Umer <mumer.mobi@gmail.com>
Subject: [PATCH 0/2] ext4: fix goal trimming in CR_BEST_AVAIL_LEN
Date: Sun, 22 Nov 2026 13:56:28 -0500
Message-ID: <20261122185630.2112-1-mumer.mobi@gmail.com>
X-Mailer: git-send-email 2.53.0
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

Two issues in ext4_mb_scan_groups_best_avail() that make mballoc trim
allocations more than needed or skip CR_BEST_AVAIL_LEN entirely.

1/2: groups below the scan start are only searched after the goal has
     been trimmed to min_order. Regression from a3ce570a5d6a (v6.17).
2/2: min_order is one order too high for power-of-two requests, so they
     fall through to CR_GOAL_LEN_SLOW. Present since 7e170922f06b.

Both reproduce on 6.18.44, 7.1.5 and 7.2.15. The two fixes were tested
together on 7.2.15. Reproducers (loop device, run as root, read the
ext4_mballoc_alloc tracepoint):

  https://github.com/mumer2834/ext4-best-avail-repro

Patch 1 only changes the order in which CR_BEST_AVAIL_LEN visits groups;
CR_POWER2_ALIGNED and CR_GOAL_LEN_FAST keep the linear-like traversal
from a3ce570a5d6a. I have not measured multi-writer contention with this
change.



Muhammad Umer (2):
  ext4: scan all groups before trimming the goal in CR_BEST_AVAIL_LEN
  ext4: fix off-by-one in CR_BEST_AVAIL_LEN min_order

 fs/ext4/mballoc.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)


base-commit: 4843f6873f7c4835e62f2c73ba0fd538e57a2f22
-- 
2.53.0

