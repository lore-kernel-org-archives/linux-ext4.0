Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA54F352032
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 06:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784010717; cv=none; b=gEdUcJpkYR/tNdcMgREgKkFFHl4IwrFykZx97cLVZt1026IXvj+GfURr1RqUZZsaJCwEP+s6p8LeBgs3Et9KCJ3DBCbnRFObemo0jqPaA9wCHKR/25+J1sx0AkV0Hmie8hX1jhC3/+QCcXSgAaK23jgfRhMbqKsOkVmI1lP28hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784010717; c=relaxed/simple;
	bh=oF3HQQtQNOnvDr8hOHkwzDMrFqJhC7eaK2VkTuQWHM4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eqaksVU5+w5UmxnJIencnIHaGR6Y9wZFdc9gw2NA2Sm16qkaZMp9pXQC5ItLoWUKLW1jIbSj2bdiAKbjXBySUzEZGhwjF+ZAeVWZS8BpGfMzckL6UJpqzCynSz37GAoN8htaaWO8wTgEWbk7+/34kHBVzVFAq0bPNlQumo0vy1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=lQxUGXxS; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="lQxUGXxS"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784010706; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=XUdMQpeK3M3cQzRIN2LgwoHQP2nK1eMYMi0VwyC/pmk=;
	b=lQxUGXxSFqXFbeZuVBBL4Q5PG0tH7zKOmmpOj73sqzRHkdInRED9Re53MjS9LyFX6+RrmSQF7O+JibXT6bOQ6zIYHPEv2oVn1hpKcpIzNwp3xQmS+gDtYppxdNY5rTHl2S+1WCIV4GYr70BlGI79x5qE2Z9d7SPdh8WCMMFmrF4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X73I9yt_1784010696;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X73I9yt_1784010696 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Jul 2026 14:31:45 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com
Subject: [PATCH e2fsprogs 0/5] fsck: fix stale "bad orphan inode" after fsck runs
Date: Tue, 14 Jul 2026 14:31:31 +0800
Message-ID: <20260714063136.1284287-1-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

systemd-fsck invokes the fsck wrapper with options (-l, -C <fd>) that
the e2fsprogs wrapper mis-parses and leaks to e2fsck, where they get
eaten as a bad_blocks_file. e2fsck then aborts after orphan cleanup but
before flushing the superblock, leaving s_last_orphan stale on disk and
the kernel reporting "bad orphan inode" on next mount.

This series fixes both wrapper parsing bugs (consume -l; parse a
separate "-C <fd>"), and, as defense-in-depth, flushes the superblock
right after orphan cleanup so an early abort can no longer corrupt the
on-disk orphan state. Two regression tests are added. See the
individual patches for details.

Comments and review are welcome.

Thanks,
Baokun

Baokun Li (5):
  fsck: consume -l option instead of passing to e2fsck
  fsck: fix -C fd option parsing when fd is a separate argument
  e2fsck: flush superblock immediately after orphan cleanup
  tests: add fsck option-parsing regression test
  tests: add orphan-cleanup flush regression test

 e2fsck/super.c                      | 11 ++++++
 misc/fsck.c                         |  5 ++-
 tests/f_fsck_opt_parse/expect.1     |  2 +
 tests/f_fsck_opt_parse/name         |  1 +
 tests/f_fsck_opt_parse/script       | 61 +++++++++++++++++++++++++++++
 tests/f_orphan_flush_abort/expect.1 |  7 ++++
 tests/f_orphan_flush_abort/name     |  1 +
 tests/f_orphan_flush_abort/script   | 61 +++++++++++++++++++++++++++++
 tests/test_config                   |  2 +
 9 files changed, 150 insertions(+), 1 deletion(-)
 create mode 100644 tests/f_fsck_opt_parse/expect.1
 create mode 100644 tests/f_fsck_opt_parse/name
 create mode 100644 tests/f_fsck_opt_parse/script
 create mode 100644 tests/f_orphan_flush_abort/expect.1
 create mode 100644 tests/f_orphan_flush_abort/name
 create mode 100644 tests/f_orphan_flush_abort/script

-- 
2.43.7

