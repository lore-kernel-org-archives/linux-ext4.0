Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com [14.137.139.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903C727A462;
	Mon, 15 Jun 2026 10:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=14.137.139.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781517856; cv=none; b=ZHnLqPSRz/ijFHq3ocwcZoHRfwG8JUtr6eUC23aFep9IQhGSShmVSCDnr7FJqjxrhoEGix7zaYowyZsooiF0vZg7/VRW0577+eA3P1aP8ptXX1wx/ykSooOMNI90a6f9HN0nLGw6HdS7FbErITrKt1BRH0We54RhbnAhNHdasvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781517856; c=relaxed/simple;
	bh=c8pyBttAh9W9HuFV8YLq7+aCGEcznEiHyHKeYHy5OrU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RpOS9oV+BaWjrYCZgV9/pcuO0IfpfdvMLhc+W6Pl7v/3AV2k8SSHqt5QcqXpWZSPSCMvKhGufhpW8wFCR64a6wvxDw5YMKTF0HV3P8M5C/mTs6RkUc3SAfVGb8hnOpTZQFI0qMkIiE7c6ANat1xrZHmtb8shxSHcjEPILmpBsWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=14.137.139.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from frasgout11.his.huawei.com (unknown [172.29.8.25])
	by frasgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gf5Dh39jhzsWmK;
	Mon, 15 Jun 2026 17:59:00 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.196])
	by frasgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gf5DH3WzVz1HCJH;
	Mon, 15 Jun 2026 17:58:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [7.182.16.47])
	by mail.maildlp.com (Postfix) with ESMTP id D18C140562;
	Mon, 15 Jun 2026 18:04:10 +0800 (CST)
Received: from huaweicloud.com (unknown [10.224.106.87])
	by APP1 (Coremail) with SMTP id LxC2BwDXRNANzi9qVqj9AA--.13415S2;
	Mon, 15 Jun 2026 11:04:09 +0100 (CET)
From: Bohdan Trach <bohdan.trach@huaweicloud.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>
Cc: mchehab+huawei@kernel.org,
	bohdan.trach@huawei.com,
	lilith.oberhauser@huawei.com,
	Bohdan Trach <bohdan.trach@huaweicloud.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] ext4: optimize ext4_mb_prefetch
Date: Mon, 15 Jun 2026 12:03:27 +0200
Message-ID: <20260615100331.163997-1-bohdan.trach@huaweicloud.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:LxC2BwDXRNANzi9qVqj9AA--.13415S2
X-Coremail-Antispam: 1UD129KBjvJXoWxKr48uw1xAr1DKF1fJr4xZwb_yoWxXry7pr
	W3KFnxCr15XrsrJwsFka1jgF1jvr48Jr18JryUGw1rXr15Zr1jqr4xWrW0gr9rAr9xWw1U
	Jw1UXr1UJr1UGrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4j6r
	4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: xerkvtvqow2ttfk6x35dzhxuhorxvhhfrp/

v3:
  Rebase to latest ext4/dev.
  Added R-b by Jan Kara for patch 1/2.
v2:
  Fix issues found by Jan Kara, added R-b for patch 2/2.
  Extend commit message of patch 1/2 a bit.
v1:
https://lore.kernel.org/linux-ext4/20260521125931.16474-1-bohdan.trach@huaweicloud.com/

Original cover letter below:

Dear Ted,

We have been profiling scalability of some rocksdb-related workloads on
ext4 file system and have found a case where significant time ends up
being spent in ext4_mb_prefetch() function. This happens because
ext4_mb_scan_groups_linear() path is triggered in ext4_mb_scan_groups().
We have noticed that on larger, filled disks, this function can take
lots of time.

We have added a test for this issue to our fork of will-it-scale [1],
which you can use to reproduce the issue.(the actual workload does a few
writes after fallocate, they have been dropped to better illustrate the
issue).
1) https://github.com/open-s4c/will-it-scale/blob/master/tests/fallocate3.c

On this series, we optimize this code path:
Patch 1: change EXT4_MB_GRP_TEST_AND_SET_READ() to reduce the rate of
         atomic RMW operation via test_and_set_bit, which has quite
         high cost on large multicore CPUs, especially under
         contention for the group's flag cache lines.
         As this bit is only ever set, but never unset, it should be
         possible to reduce the cost of this check by calling
         test_bit[_acquire]() first.
Patch 2: restructure the ext4_mb_prefetch loop operations such that
         ext4_group_desc is fetched only after the checks based on
         ext4_group_info succeed.

This series has been tested with
        kvm-xfstests -c ext4/all -g auto
and did not introduce any new issues.

Performance test: we have used a our will-it-scale drop-in test we have
provided above, and used three machines for running it:
- Kunpeng 920 (arm64, 96 CPUs * 1 socket, 128G RAM, SAS HDD: Seagate
  Exos 10E2400 1.2TB)
- Kunpeng 920b (arm64, 80 CPUs * 2 sockets, 502G RAM, SATA SSD: Huawei
  ES3000 V6 0.96TB)
- AMD 9654 (x86_64, 96 CPUs * 2 sockets, 1.5T RAM, NVME SSD: Samsung SSD
  970 EVO Plus 1TB)
We have performed tests with existing file systems, as well as more limited
tests with a fixed-size file systems.

Benchmark on an existing file system for Kunpeng 920 (842G FS, 31% space
used) with the patch based on kernel 7.0.6:
| thr. | base | patched |      improv. |
|      | perf |    perf |              |
|------|------|---------|--------------|
|    1 | 1286 |    1608 |  +25.0388802 |
|    2 | 1673 |    1680 |   +0.4184100 |
|    4 | 1698 |    1712 |   +0.8244994 |
|    8 | 1721 |    1730 |   +0.5229518 |
|   16 | 1739 |    2313 |  +33.0074756 |
|   32 | 1742 |    3571 | +104.9942595 |
|   64 | 1735 |    3427 |  +97.5216138 |
|   96 | 1688 |    1814 |   +7.4644550 |

Benchmark on an existing file system for Kunpeng 920b (802G ext4 FS, 68%
space used) with the patch based on kernel 6.6:
| thr. | base | patched |  improv. |
|      | perf |    perf |          |
|------|------|---------|----------|
|    1 | 1613 |   1625  |   +0.74% |
|    2 | 1620 |   2603  |  +60.67% |
|    4 | 1624 |   4894  | +201.35% |
|    8 | 2505 |   8328  | +232.45% |
|   16 | 4736 |  11632  | +145.60% |
|   32 | 7784 |  13124  |  +68.60% |
|   64 | 8094 |   8636  |   +6.69% |
|  128 | 6914 |   7890  |  +14.11% |

Benchmark on an existing file system for AMD 9654 (15T FS, 6% space
used), kernel 7.1-rc3. This shows the performance impact on a mostly
free file system.
| thr. |  base | patched |    improv. |
|      |  perf |    perf |            |
|------|-------|---------|------------|
|    1 | 30901 |   31191 | +0.9384810 |
|    2 | 50874 |   50504 | -0.7272870 |
|    4 | 66068 |   64108 | -2.9666404 |
|    8 | 63963 |   61927 | -3.1830902 |
|   16 | 47809 |   47044 | -1.6001171 |
|   32 | 42441 |   42326 | -0.2709644 |
|   64 | 39773 |   39929 | +0.3922259 |
|  128 | 37065 |   36413 | -1.7590719 |

We have also performed the test with kernel 6.6 on both Kunpeng920b and
AMD 9654 with much smaller FS image (133G) to have more controlled
benchmarking environment, although this reduces the measured benefits as
well compared to a bigger FS with more groups to iterate over:

AMD 9654 performance:
| thr. |  base | patched |  improv. |
|      |  perf |    perf |          |
|------|----------------------------|
| 25% full file system:             |
|------|----------------------------|
|    1 |  5964 |    6778 |  +13.64% |
|    2 | 11811 |   13415 |  +13.58% |
|    4 | 20111 |   23570 |  +17.19% |
|    8 | 30083 |   36296 |  +20.65% |
|   16 | 27781 |   38302 |  +37.87% |
|   32 | 28325 |   36930 |  +30.37% |
|   64 | 26044 |   29952 |  +15.00% |
|  128 | 19969 |   20882 |   +4.57% |
|------|----------------------------|
| 50% full file system:             |
|------|----------------------------|
|    1 |  4093 |    7380 |  +80.30% |
|    2 | 13168 |   13906 |   +5.60% |
|    4 | 21440 |   22623 |   +5.51% |
|    8 | 30523 |   32360 |   +6.01% |
|   16 | 27502 |   34017 |  +23.68% |
|   32 | 27189 |   32480 |  +19.46% |
|   64 | 24146 |   26463 |   +9.59% |
|  128 | 18386 |   18631 |   +1.33% |
|------|----------------------------|
| 75% full file system:             |
|------|----------------------------|
|    1 |  5738 |    7208 |  +25.61% |
|    2 | 13869 |   15309 |  +10.38% |
|    4 | 21803 |   23447 |   +7.54% |
|    8 | 29004 |   30766 |   +6.07% |
|   16 | 25542 |   30584 |  +19.74% |
|   32 | 24242 |   28631 |  +18.10% |
|   64 | 20631 |   22833 |  +10.67% |
|  128 | 14603 |   15086 |   +3.30% |

Kunpeng K920b performance:
| thr. |  base | patched | improv. |
|      |  perf |    perf |         |
|------|---------------------------|
| 25% full file system:            |
|------|---------------------------|
|    1 |  5398 |    7025 | +30.14% |
|    2 |  7451 |   12299 | +65.06% |
|    4 | 12574 |   20899 | +66.20% |
|    8 | 18645 |   27694 | +48.53% |
|   16 | 25088 |   31739 | +26.51% |
|   32 | 26699 |   27632 |  +3.49% |
|   64 | 14943 |   19547 | +30.81% |
|  128 | 13047 |   14544 | +11.47% |
|------|---------------------------|
| 50% full file system:            |
|------|---------------------------|
|    1 |  4881 |    6618 | +35.58% |
|    2 |  6544 |   11660 | +78.17% |
|    4 | 11156 |   19506 | +74.84% |
|    8 | 16842 |   25835 | +53.39% |
|   16 | 23305 |   29260 | +25.55% |
|   32 | 24622 |   25303 |  +2.76% |
|   64 | 13814 |   17707 | +28.18% |
|  128 | 12061 |   13180 |  +9.27% |
|------|---------------------------|
| 75% full file system:            |
|------|---------------------------|
|    1 |  7037 |   10580 | +50.34% |
|    2 |  9216 |    9075 |  -1.52% |
|    4 | 14534 |   22076 | +51.89% |
|    8 | 19341 |   25936 | +34.09% |
|   16 | 23592 |   27409 | +16.17% |
|   32 | 23680 |   23078 |  -2.54% |
|   64 | 12836 |   15902 | +23.88% |
|  128 |  9614 |   10341 |  +7.56% |

Thanks,
Bohdan.

Bohdan Trach (2):
  ext4: avoid RWM atomic in EXT4_MB_GRP_TEST_AND_SET_READ
  ext4: get ext4_group_desc in ext4_mb_prefetch only when necessary

 fs/ext4/ext4.h    |  8 +++++++-
 fs/ext4/mballoc.c | 21 +++++++++++----------
 2 files changed, 18 insertions(+), 11 deletions(-)

-- 
2.43.0

