Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.230.115
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795143329;
	b=nbbDHsBOSgfXQyP0Mp4PTaHlvyEHdNgh9S1dy3IN/h/TZ1QDtAyHQolQzj3OwucUNMwM
	 +OIowFF69B/CvRe3DZbMD2wlwWjHd6+n5xQDxuO7dAYWKqcyVgwXdyFKl4wut5lmZL5Wx
	 cW/bQEhdYvpga9pNfco/SnLlqYP+vq22ePPuP9R+ruzQfqC4/jR+Vhi/0puNM1vMnm3MK
	 jOCoR4kf2c9ugbcDGDd7NUkMbXoAyD4YA8DV4dXjQB3tU1ydX33DtBJu2ioTp4rSsAjS0
	 O91Mm5xBenlC4QdXSVzHgM/04/XXfvdtpnjvFDjofIvTZdmRtI1volWICb/m5BRGglw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795143329;
	h=DMARC-Filter:DKIM-Signature:Content-Transfer-Encoding:To:Message-Id:
	 Mime-Version:X-Mailer:Content-Type:Subject:X-Original-From:
	 X-Lms-Return-Path:Cc:From:Date;
	bh=JxYQWk4OJe8idSu6UNkb8TEj89mTwP1uH2AqM7RQiCk=;
	b=P9/S4yjnNUa4MbDSO2pmn+qUoWApQkLQQf+7bqlvY0Wh5vzAwB4ltoxILTPtD0f05fEQ
	 qAxiMHkbN/m6dgLoDk3YGwtmiK0/NHbo+5wmDh0v1NL6skFvlWBVQ/cyefF3lzLLRCibr
	 nIM8/LgZ3kfSknr5iJWt8PZdyIMXHzTvhLZKfjp5vdYNQPRR7RAfxcUS/57tMFSgPvz6g
	 N3GiTK2opBd7Rpr2BQr3fyqBiCp3ostCqnOuLLT/YZdc6788Wf8BeOMCeVTIgUOvxv0Rz
	 grJ6ctSE0qR3k8vVhhm+g4mtnK3JL4FZskRNB9Esb0DrKufPQ5STSIq2gVrY0BgtrgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=dYL3NRMh;
	arc=none smtp.remote-ip=209.127.230.115
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C51606A326
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 02:55:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63C51606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=dYL3NRMh
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1795143322; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=JxYQWk4OJe8idSu6UNkb8TEj89mTwP1uH2AqM7RQiCk=;
 b=dYL3NRMhnBhEKId8d++mXkhPk9wXMOxL9vnlZRQaPoLytEsF9cPbCad0HD4Xt8Hza6BppK
 6Srf4WtXQ1gSsBR3D/hAvdf1e8BISKvZhjGUx+X+g3ef6cxG8blzoH8h7bfkb+ZSB+7i1m
 6ZqBNiZaPfHLci2ZjqxbF6D965J0k70ITw4HW6MjttcZe5ImH0jzOK9AH3OjRi4fM+Q/c5
 zrJkJVTFUJRVFAvspDuUWo9IYEl02l1+t8ZNRhdGlOpqpsCjoAZmNmIKo62VWb7yZLo3+A
 F860e9xX0aQlZCckVEinZD7i2YHpMRMsJkZRkJUfGgbrEpXSLtPrHAtUKecZAg==
Content-Transfer-Encoding: 7bit
To: <linux-ext4@vger.kernel.org>
Message-Id: <20261120025459.70290-1-zhaogongyi@bytedance.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v3 0/2] ext4: reject impossible group free cluster counts
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
X-Lms-Return-Path: <lba+26affb698+dc4492+vger.kernel.org+zhaogongyi@bytedance.com>
Cc: <linux-kernel@vger.kernel.org>, <tytso@mit.edu>, 
	<adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>, <jack@suse.cz>, 
	<ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>, <yi.zhang@huawei.com>
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
Date: Fri, 20 Nov 2026 10:54:57 +0800

ext4 initializes its free-space counters from the group descriptors. A
corrupt descriptor can advertise more free clusters than its group can
hold. Journal block replay can also replace the superblock and group
descriptors that were examined when mounting.

This series adds an optional JBD2 recovery callback and uses it in ext4
to validate the recovered geometry and group descriptors. It checks the
metadata before fast commit replay and checks the descriptors again
after fast commit replay. Both halves of the group free-cluster count
are read under the group lock.

Changes since v2

- Skip restoring and writing out superblock error information when
  journal load fails.
- Drain deferred EA inode evictions before checking descriptors after
  fast commit replay. If replay fails, drain the work before restoring
  the read-only flag. Leave fast commit state cleanup to the mount
  failure path.
- Reject changes to the casefold feature and encoding settings during
  journal recovery.
- The JBD2 patch is unchanged.

Changes since v1

- Keep the descriptor checks needed to load the internal journal and
  defer full validation on recovery mounts until block replay completes.
- Revalidate the recovered geometry and reload the descriptor table
  when replay changes its layout.
- Put the JBD2 interface in its own patch and read the free-cluster
  count under the group lock.

Testing

Built fs/jbd2/ and fs/ext4/ with arm64 GCC 15.2 and W=1 at both
patch boundaries with CONFIG_UNICODE enabled.

Runtime tests of v3 covered these cases.

- Mount rejected out-of-range free-cluster counts. The recovery
  callback rejected corrupt descriptors with an empty journal and
  when corruption persisted in a separate descriptor block after block
  replay. Recovery succeeded with valid descriptors after block replay.
- When post-replay validation failed, ext4 skipped the superblock
  writeback used to restore error information.
- Read-only recovery completed fast commit replay and reached the
  second callback. Deferred EA inode eviction completed without an
  EROFS error or warning.
- When fast commit replay failed with pending EA inode evictions,
  recovery drained the work before clearing the replay state.
- Recovery of an existing casefold filesystem loaded its encoding.

Earlier testing verified recovery of a previously resized image at
the expected size. In a separate test, the recovered superblock
reported four groups, up from two before replay. Recovery reached
descriptor validation and rejected the block bitmap location for
group 2. It remains to be established whether JBD2 replayed a valid
group 2 descriptor into the block that ext4 read.

Successful recovery of an online resize across a group descriptor
block boundary remains unverified. Rejection of casefold settings
changed by journal block replay also remains untested.

Link: https://lore.kernel.org/linux-ext4/20261102042428.65204-1-zhaogongyi@bytedance.com/
Link: https://lore.kernel.org/linux-ext4/20261119122601.85293-1-zhaogongyi@bytedance.com/
Link: https://lore.kernel.org/linux-ext4/sashiko-outbox-223131@kernel.org/

Zhao Gongyi (2):
  jbd2: add a metadata validation hook to journal recovery
  ext4: reject impossible group free cluster counts

 fs/ext4/balloc.c     |  10 +-
 fs/ext4/ext4.h       |   2 +
 fs/ext4/super.c      | 332 +++++++++++++++++++++++++++++++++----------
 fs/jbd2/journal.c    |  22 ++-
 fs/jbd2/recovery.c   |  38 +++--
 include/linux/jbd2.h |   7 +-
 6 files changed, 316 insertions(+), 95 deletions(-)

base-commit: 4aa05e642bade8cf8405936b03cabf848fe6c456
