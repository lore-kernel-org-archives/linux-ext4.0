Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71ADA30CD92
	for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2026 09:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774431273; cv=none; b=SYXLwVQJP2WlJ7hslEaE2+ap6vD7lWTJ45weWPHzeIUZveV0SFN0dJh48Ml9lkS37e1kMumnrmvakrBbg71A1Sve+/kvmCQEQhWo4PpnBfMmbNwob1X8venrHyYkejXQsO+uQT6utH/X6mbhPIIBgTyBr4oPMwn5QAqTwhIZHpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774431273; c=relaxed/simple;
	bh=zhfXxitK3GbVzP0cWaWb05D74FMylePtHteof0l3m0A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YacFOVV0KD3e6t8zY2ymK/RX7w6TjkKagd3mTrG+Ucw+M7W4cmcC3QRhveNWWxhU/PdM/AWRBGQ2Xoiq/lAm5X1Vlc3ottYWI2PiVlfZ5HJteju7+1KlUkL/s5otnmW30lyorRtcm8QtWRIFYBvM24ncrjMVqfl+3KlFvmbn/K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a/asXWCV; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a/asXWCV"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2b0b0064027so6265455ad.3
        for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2026 02:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774431271; x=1775036071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6bSkic//eLc54cP3e25oSENPT2tB4RkJc8+gyvzAmqU=;
        b=a/asXWCVpW864kGkkSn/0Z8Uf1Qyw1Wr+MBvsCpYCuVPj1604CKshxlMPzhBWRm5Ep
         AbN/jm0+Ht4QElFhNuKaYBLdTXtfJcvYS0sGfmq/u5962dUTO15dBKkXtbYpLXFNJOK0
         ZRjz9rAD27slX+ZqmkmmePk4w6K3TttssAz+oc9FIsPmNRNWDc71Upq4ADbom0M01g+k
         +5fTKtIy0rq88YLLBMy0GPTqws2fnOkB9iP4JuYvKcQDq+eBMsNOFnQ8NMP8NQNkpjhS
         k1H6g3NQgv2TOsN28vMkh5k3Ekt3Ym+GTHeNJiOm6bvjWTiN7Q5F38w81laRuT0tcbhC
         4zuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774431271; x=1775036071;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6bSkic//eLc54cP3e25oSENPT2tB4RkJc8+gyvzAmqU=;
        b=qBGTBTCchanl+ZWRR9cUdm43A1Kg/hy/THwOWDynKcuSx1vsoVmkmz87XXmjrYYvNy
         8dvQIzOQLvCN5f9N1g83ebwxk1KjnAouj/sHE+Zh1oyqOjxJ5VRohH1/JuRmFfa18eDf
         +9lhJDjn8H8ZdaDF2H5Ta2c9cavJW6OaDtQlPORrJ2jzzAT7VVQ7htxzUWpQykYI/hfN
         Br5dhP2fprUX7AdRPHu0ESkrpB7rd+o3T0u1OQlV9x1+RXAl+Eik6427kU/+931R/yS1
         GzZJoTOWi2mXTPeXZ0tbTfgswer93KAqZzr4IH+dtjlfgZc3+DY7sMS6MfOsOrTs4Naq
         krbQ==
X-Gm-Message-State: AOJu0Yz7FK1vdMsSZ5zNp+ECFLsIlLo6YlDSJqO4/qoKyaMPs6MeODmB
	rqBeSItpFmv8MgG8UzUnn45RmoT5ZCEx2fk5iAP1vNpaKCAR0Ca8Cbfm
X-Gm-Gg: ATEYQzzLR0gAZQCpwUk/yyeN9K1FK7Qk7vfoRkhYnE2aR4W8Ux6bLHyrqSEO6xoGrlS
	sXlno+jHESz1cuUlXYO/JrPuZ+g0oZ3aSuBjbiia23t3bGhSLfWC3MbInJ3vhZdS7Z8TP+eV7gY
	Ix1k/agYuFmpkRtPDufsZ9NZrqM1heXeaz1AQqqQeiriuVAixUSw+4Bklfl7Lt7VfLjIKxSUlKz
	D/5AVWB6/OidyFbi5ekkJfdMlR3ROCnQm82HnuoRCN8h6KtDhTuSQG3XrlaCTQFrZhyiq69OwB/
	am7V1uTdj3H9o8RSZXhPy2juqKlw5dNt2x7Qj1nXc5mU3wO4d+nbDHGaZFPn+m9sf/9YpplpVfE
	YzZdbFRHupjd/cmmwY+dAJIb8gNCtiPgchbwmssQvV/YygcffVqhFvexsBTvR0L+gM3XGSh6vp/
	+yjEHBvjMzhVIu3apZQArbL852mAjrd9y2LToD3FScrRTcI/4=
X-Received: by 2002:a17:903:1786:b0:2b0:5770:d484 with SMTP id d9443c01a7336-2b0b0ade793mr29220765ad.41.1774431270540;
        Wed, 25 Mar 2026 02:34:30 -0700 (PDT)
Received: from n37-098-250.byted.org ([115.190.40.15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083516ae1sm164266245ad.13.2026.03.25.02.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 02:34:30 -0700 (PDT)
From: Diangang Li <diangangli@gmail.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca
Cc: linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	changfengnan@bytedance.com,
	Diangang Li <lidiangang@bytedance.com>
Subject: [RFC PATCH 0/1] ext4: fail fast on repeated metadata reads after IO failure
Date: Wed, 25 Mar 2026 17:33:48 +0800
Message-Id: <20260325093349.630193-1-diangangli@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Diangang Li <lidiangang@bytedance.com>

A production system reported hung tasks blocked for 300s+ in ext4 metadata
lookup paths. Hung task reports were accompanied by disk IO errors, but
profiling showed that most individual reads completed (or failed) within
10s, with the worst case around 60s.

At the same time, we observed a high repeat rate to the same disk LBAs.
The repeated reads frequently showed seconds-level latency and ended with
IO errors, e.g.:

  [Tue Mar 24 14:16:24 2026] blk_update_request: I/O error, dev sdi,
      sector 10704150288 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
  [Tue Mar 24 14:16:25 2026] blk_update_request: I/O error, dev sdi,
      sector 10704488160 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
  [Tue Mar 24 14:16:26 2026] blk_update_request: I/O error, dev sdi,
      sector 10704382912 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0

We also sampled repeated-LBA latency histograms on /dev/sdi and saw that
the same error-prone LBAs were re-submitted many times with ~1-4s latency:

  LBA 10704488160 (count=22): 1-2s: 20, 2-4s: 2
  LBA 10704382912 (count=21): 1-2s: 20, 2-4s: 1
  LBA 10704150288 (count=21): 1-2s: 19, 2-4s: 2

Root cause
==========

ext4 metadata reads commonly use buffer_head caching and serialize IO via
BH_Lock (lock_buffer). When a read fails, the buffer remains !Uptodate.
With multiple threads concurrently accessing the same metadata block, each
waiter wakes up after the previous owner drops BH_Lock, then submits the
same read again and waits again. This makes the latency grow linearly with
the number of contending threads, leading to 300s+ hung tasks.

The failing IOs are repeatedly issued to the same LBA. The observed 1s+
per-IO latency is likely from device-side retry/error recovery. On SCSI the
driver typically retries reads several times (e.g. 5 retries in our
environment), so a single filesystem submission can easily accumulate 5s+
delay before failing. When multiple threads then re-submit the same failing
metadata read and serialize on BH_Lock, the delay is amplified into 300s+
hung tasks.

Similar behavior exists for other devices (e.g. NVMe with multiple internal
retries).

Example hung stacks:

  INFO: task toutiao.infra.t:3760933 blocked for more than 327 seconds.
  Call Trace:
   __schedule
   io_schedule
   __wait_on_bit_lock
   bh_uptodate_or_lock
   __read_extent_tree_block
   ext4_find_extent
   ext4_ext_map_blocks
   ext4_map_blocks
   ext4_getblk
   ext4_bread
   __ext4_read_dirblock
   dx_probe
   ext4_htree_fill_tree
   ext4_readdir
   iterate_dir
   ksys_getdents64

  INFO: task toutiao.infra.t:2724456 blocked for more than 327 seconds.
  Call Trace:
   __schedule
   io_schedule
   __wait_on_bit_lock
   ext4_read_bh_lock
   ext4_bread
   __ext4_read_dirblock
   htree_dirblock_to_tree
   ext4_htree_fill_tree
   ext4_readdir
   iterate_dir
   ksys_getdents64

Approach
========

Remember read failures on buffer_head and fail fast for ext4 metadata reads
once a buffer has already seen a read failure. Clear the flag on successful
read/write completion so the buffer can recover if the error is transient.

Note that ext4 read-ahead uses ext4_read_bh_nowait(), so it does not set
the failure flag and remains best-effort.

Patch summary
=============

  1) Add BH_Read_EIO buffer_head state bit and helpers.
  2) Clear BH_Read_EIO on successful read/write completion.
  3) In ext4 metadata reads, if BH_Read_EIO is already set (and not
     BH_Write_EIO), fail fast instead of re-submitting the same failing
     read. On read failure, set BH_Read_EIO.

Diangang Li (1):
  ext4: fail fast on repeated metadata reads after IO failure

 fs/buffer.c                 |  2 ++
 fs/ext4/super.c             | 12 +++++++++++-
 include/linux/buffer_head.h |  2 ++
 3 files changed, 15 insertions(+), 1 deletion(-)

-- 
2.39.5
