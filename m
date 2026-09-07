Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7817647140C;
	Mon,  7 Sep 2026 10:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778523; cv=none; b=S7rzmMjgIh5AYdEbctHIGVRe7hDyvotXGyzusqUqcxyMye7im69KKfmDo+rB/NW1cH/cK7yIZWm//CVYM/Lzahd3I8J4efQKNCDw6OHr6sNDAXRhGQTtwnO3XDaapTm8lDgAQKdbjWfRym+DQoA3MiWSZPHEB8fuOn7kRrI9TTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778523; c=relaxed/simple;
	bh=bYBrPU0xif+B3+bsnE4RSXFKKh/2YZk/Z4rHk3hTsro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+rNdY7KS6L/ap5Hr9fLPvULgTaMLrltTcILK701OfY4FWaeJcrmOcv/rvaoBQYUNetU9Lgn+d07NS8ttzDv9IxugxjgRPZ5np/cQIfc1L5BxxtJlavZpWHC5JVaoxEwG1Jee2hiWb6TvOqN6yL3FLu8Eh1mJZfc5HSWbCzMqO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
Received: from zhaoxin.com (unknown [127.0.0.1])
	by mx1.zhaoxin.com (MTA) with ESMTP id 4hdkVs24F8zdBP1x;
	Mon,  7 Sep 2026 18:55:17 +0800 (CST)
Received: from zhaoxin.com (unknown [10.28.208.166])
	by mx1.zhaoxin.com (MTA) with ESMTP id 4hdkVr3mmYzdBP1x;
	Mon,  7 Sep 2026 18:55:16 +0800 (CST)
Received: from zjh-os.zhaoxin.com (zjh-os.zhaoxin.com [10.28.24.13])
	by zhaoxin.com (8.30) with ESMTPac8d2beeee5e15094cb1e48a48af50df
	Mon, 07 Sep 2026 18:55:15 +0800
X-Eyou-Smtpauth: jonaszhou-oc@zhaoxin.com
X-Eyou-EnvelopeSender: jonaszhou-oc@zhaoxin.com
X-Eyou-From: JonasZhou <jonaszhou-oc@zhaoxin.com>
From: "=?UTF-8?B?Sm9uYXNaaG91LW9j?=" <jonaszhou-oc@zhaoxin.com>
To: jack@suse.cz,
	Jan Kara <jack@suse.com>
Cc: adilger.kernel@dilger.ca,
	jianhuizzzzz@gmail.com,
	jonaszhou-oc@zhaoxin.com,
	jonaszhou@zhaoxin.com,
	libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	louisqi@zhaoxin.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	tytso@mit.edu,
	yi.zhang@huawei.com
Subject: Re: [PATCH] ext4: isolate s_orphan_lock from read-mostly fields
Date: Mon,  7 Sep 2026 18:55:07 +0800
Message-ID: <20260907105507.96774-1-jonaszhou-oc@zhaoxin.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <tf24u75hmpjhb2iqabyx6n3qur2kyda7vwz2eo5zcc2ek7utwp@m5sepatzqx2x>
References: <tf24u75hmpjhb2iqabyx6n3qur2kyda7vwz2eo5zcc2ek7utwp@m5sepatzqx2x>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Eyou-Sender: <jonaszhou-oc@zhaoxin.com>

Hi Jan,

Thanks for the review. My original test filesystem did not have
orphan_file enabled. I agree that enabling it is the main scalability
improvement; this change only targets filesystems still using the
legacy list.

For v2, I exchanged s_journal and s_ext4_flags with s_err_report_sec
and s_li_request. Moving the readers keeps the orphan lock/list and
the intervening allocator fields at their original offsets. It adds
no padding and preserves the mutex comment.

sizeof(struct ext4_sb_info) remains 2496 bytes with my x86-64 config.
Compiled checks with quota disabled, lockdep, PREEMPT_RT and i386 also
show only these four offsets changing, with no structure-size increase.

Test results comparing v7.3-rc1 and v2 on two Xeon Silver 4208 sockets:

                      Mean throughput change    Paired 95% interval
legacy      dnotify                  +13.52%       [+4.83%, +22.92%]
legacy      unlink                   +31.70%      [+22.53%, +41.48%]
legacy      fallocate                 +0.25%        [-1.40%, +1.94%]
orphan_file dnotify                   -0.43%        [-5.44%, +4.96%]
orphan_file unlink                    -0.34%        [-2.76%, +2.13%]
orphan_file fallocate                 +0.29%        [-0.82%, +1.42%]

The intervals use four paired log ratios; the mean-change column uses
the ratio of arithmetic means. All four legacy dnotify/unlink pairs
improved. The orphan_file results show boot-to-boot variation, so I am
not claiming equivalence or a general filesystem speedup. These are
new measurements on memory-backed images, not the original v1 numbers.

Separate perf c2c dnotify captures on legacy filesystems show remote
HITM samples on the original journal/flags offsets in all four base
captures and none on their new cache line in the four v2 captures.

Thanks,
Jonas

