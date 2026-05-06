Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB894418D7
	for <linux-ext4@vger.kernel.org>; Wed,  6 May 2026 13:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778075481; cv=none; b=X77WLDf/CLO5QRD7jy3tHz6cdVUuBrSgj+Y+9+QTE5tXT/ReVV1UEWsJbj9LakuqY+BUWnCJEAJY6N+auL4YG8y3O2krYjQCoTmPHawwg6VropOcBWceM0F/htkeboLauKE09GUfR0LyCSQiuzEmwG9PR1l23bDLYnHv9AJz+JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778075481; c=relaxed/simple;
	bh=URnkf5RkyFWCiwuC7crpWYvpHdTESNB+bPjqHfHOcDw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CEtbTn+NlKhkvV2FmpFZ07Dcb/GS+eDRzJwJ8IjQ32lDEK36Yzd/4xmlcvZa6AzqCrOeLbyUiOvK+G//eIbCtnWjLkfzNNuLMkJAXHRuKQPpW/o+gP0lomu7OTIfTLRtXnyfZXaUn0NlqGd2kFAQ28wGKTSh/+DNoE6go64csuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VBta+2el; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VBta+2el"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ba4a1a0325so18597175ad.0
        for <linux-ext4@vger.kernel.org>; Wed, 06 May 2026 06:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778075479; x=1778680279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YVI1pdoyKD96TavOxlQpvmNCRqmQwCeQQwtusJVnWcI=;
        b=VBta+2el3YzbscXC/3OQeQ4FcwcPBzMUKkKwzuDPQ3Nxpc4f1pJrcju/n+i1FtzS+l
         xNGB4uBYFtK8p/EXjtSmx5B/JkP4rR6wlXcStTekI0WTyCHHPrXG49a/eooVkOags02Y
         grSdHKJDDXwHNYKhbX4abWCZgdtsEozqHXYdTWGeihyhyT4cDkQKfc+95TcGZx80UYGB
         05//faN4M6Aweo3mucb6NhCLxfLdHXY3/9Gy3B7niileO4c1BNj2TmBlh6JSFh71hAND
         OOkRivG8DmFDeP3xAYnZdBW64jtZ9qA1A4yxjCY4LxD91q62BXB93JZrS4SbkhmecWP4
         iZ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778075479; x=1778680279;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YVI1pdoyKD96TavOxlQpvmNCRqmQwCeQQwtusJVnWcI=;
        b=sXOOK42SYawtB6OWfF3+OtB9g2plbQfTg5V2cx0Wj6gfrN8lOA9ItNYYEffiSmXs20
         2ihkvyqpKVvYVvTwE3pe0CjtlERJWte8EZ9E3JaUeE1fordd3QGe7RiVuWpnE0+6ZJ/p
         XFwSoCrYnKmOicjbn4G7hZLxepZJvH9frw6glR7auiCBQTW/7vWOYLyXF5vaIQUVWrtF
         u4dh341jM2bTZw5Fr9t3/UVNAFv6iU4Pay6g0g91LgOowDCcUQzTw9QQ93JDOwKJQN9Z
         DHSZzcLKdFrusrxhQ28M5xs+pd8HTc5lXbEeDwVvs/4lOhBQTyV+cXP1jcDLxCI0mPok
         pQJA==
X-Forwarded-Encrypted: i=1; AFNElJ8W+Wy92906E8Pt6p7pSUS0WLVdkF7MiG2xp8/YcFSUsbS0S6eWFBgMrQ6a26G9NbMl1KWeRXOoFf9r@vger.kernel.org
X-Gm-Message-State: AOJu0YzMFd1OUd9hz3mMEiOQd6iAJveeUs+2wjj2x+TAHrTBsGHrWLw5
	Oi5/cOKLm3CZS6D622ZAnGDBhR/HhdLDWh+u2k78sjQdJTrXeAL3E/J9
X-Gm-Gg: AeBDietFTi3PvAD3qJsoYZ8HSD+vuDTa5u+a4FpCBNbN7HXSmjz9vptf4vmGNhzXA5+
	RdtBWIyagZMcIwaBXiGpGnfKo595Rbd9+TZ7sW6y4Cp2qz8lfb1PX5U2r6wG37Kqb8fFffrRiXL
	xw6Fu4NVn6FdnwWtaq4JE0jpHGFsNmzMnULN6RVKU4w7iJx9lQmUxvPLdzlZdppcFyf38Bnbzio
	SXrOJUosyMrZRZKM5ZtWfIF9zNI0hWF9c1E1eMTWHlUhBiyMp/6euJ22GLtQ+P/NidN4/6kJl7s
	gL/EUUsnhdyGuYLxORZ2LmAgCN6NVTamtqvA9Hu18VJNY5JtZEAcFN7UxgdK+UPMAlANs+V3frR
	j6iKF2oNyUxlugC6UJ6tlndK4BtWtgjPzGWSloMu/Wk7OOvcHjH6jZzYk+ycFjglOeyf3rBz7mq
	XIsYCfaypXT30FHeQptC8ckA==
X-Received: by 2002:a17:903:13c8:b0:2b9:8d39:5e87 with SMTP id d9443c01a7336-2ba78f4589bmr38476715ad.10.1778075479156;
        Wed, 06 May 2026 06:51:19 -0700 (PDT)
Received: from n37-098-250.byted.org ([240e:83:200::738])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ba7bf330a0sm26970375ad.31.2026.05.06.06.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 06:51:18 -0700 (PDT)
From: Diangang Li <diangangli@gmail.com>
To: axboe@kernel.dk,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org
Cc: linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	changfengnan@bytedance.com,
	Diangang Li <lidiangang@bytedance.com>
Subject: [RFC v1 0/1] buffer_head: fail fast on repeated reads after I/O errors
Date: Wed,  6 May 2026 21:50:46 +0800
Message-Id: <20260506135047.2670453-1-diangangli@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Diangang Li <lidiangang@bytedance.com>

A production system reported hung tasks blocked for 300s+ in ext4
buffer_head paths. Hung task reports were accompanied by disk I/O errors,
but profiling showed that most individual reads completed (or failed)
within 10s, with the worst case around 60s.

At the same time, we observed a high repeat rate to the same disk LBAs.
The repeated reads frequently showed seconds-level latency and ended with
I/O errors, e.g.:

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

buffer_head reads serialize I/O via BH_Lock. When one read fails, the
buffer remains !Uptodate. With multiple threads concurrently accessing
the same buffer_head, each waiter wakes up after the previous owner drops
BH_Lock, then submits the same read again and waits again. This makes the
latency grow linearly with the number of contending threads, leading to
300s+ hung tasks.

The failing I/Os are repeatedly issued to the same LBA. The observed 1s+
per-I/O latency is likely from device-side retry/error recovery. On SCSI
the driver typically retries reads several times (e.g. 5 retries in our
environment), so a single filesystem submission can easily accumulate 5s+
delay before failing. When multiple threads then re-submit the same
failing read and serialize on BH_Lock, the delay is amplified into 300s+
hung tasks.

Similar behavior exists for other devices (e.g. NVMe with multiple
internal retries).

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

This series follows an earlier ext4-only RFC and moves the policy to the
generic buffer_head path so other buffer_head users can opt in with the
same per-block-device knob.

Approach
========

Record non-readahead read failures on buffer_head (BH_Read_EIO +
b_err_timestamp). When a per-bdev retry window is configured, submit_bh()
will skip submitting another non-readahead read for a buffer_head that
already failed within the window and complete it immediately with failure.
Clear the state on successful read or rewrite so the buffer can recover
if the error is transient.

The timestamp is recorded on the first failure only, so repeated failures
do not extend the retry window. After the window expires, the next
non-readahead read is submitted normally and can discover that the device
or media has recovered.

The retry window is configured per block device:

  /sys/block/<disk>/read_err_retry_sec
  /sys/block/<disk>/<part>/read_err_retry_sec

The default value is 0, which keeps the current behavior: after a read
error, callers may keep retrying the same read. Set it to a non-zero
value to fail repeated non-readahead reads fast within the window.

Patch summary
=============

  1) Add BH_Read_EIO and b_err_timestamp to buffer_head.
  2) Track non-readahead read failures in the submit_bh() bio completion
     path.
  3) Add per-bdev read_err_retry_sec sysfs knobs for disks and partitions.
  4) Fail repeated non-readahead submit_bh() reads fast within the
     configured window, while leaving readahead and other bio users
     unchanged.

Diangang Li (1):
  buffer_head: fail fast on repeated reads after I/O errors

 Documentation/ABI/stable/sysfs-block | 26 +++++++++++
 block/genhd.c                        | 24 ++++++++++
 block/partitions/core.c              | 24 ++++++++++
 fs/buffer.c                          | 65 ++++++++++++++++++++++++++++
 include/linux/blk_types.h            |  3 ++
 include/linux/buffer_head.h          | 10 +++++
 6 files changed, 152 insertions(+)

-- 
2.39.5
