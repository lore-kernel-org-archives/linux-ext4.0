Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.230.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795491576;
	b=5OzlyUOuB5OczTOwCoDEkkoXY2alEQ0KmNsk9ygS/Y2dxllBeqDgDYC3EAhQ0DnB5Jv4
	 7wpOknE5oFNlrxCJ7gnV2yo+oeexdxQf4d7CtDieGXrJxUBP82nqTFnEvF5xqKuFK0gPE
	 uyfKuxieYXG4vswy3waNUJlAT9UwEAFk5CCLoNZU2Sm7tvlyjXKeweHj+oqAYe57fq02G
	 dZS5euloQSQ5EWQj8KVSqFjGQ7DA5s0aa1baB2rykzLE2e/EARqxE5kS7Htjlw/6EAkep
	 6lbb9fRPpljvHxw5Y5sfldkClLSFRBZa9ronEppTF7+X0FrjgiN+PiQyFLMLDQm3Fug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795491576;
	h=DMARC-Filter:DKIM-Signature:Date:X-Lms-Return-Path:Cc:Subject:
	 Message-Id:X-Mailer:To:From:Mime-Version:Content-Transfer-Encoding:
	 X-Original-From:Content-Type;
	bh=dlbuhAn+tEV4C47nJtxGZ63JKuJQ15avO1MyMdM9WME=;
	b=2mMpzs/c18VKJUjkeZvGzSb1YZu1eW4aDb9MxqYIO8fDr9HWFKR9NKD8IhyHLRueMerZ
	 UIHQ/QL8ry3p/KzYym3x3MwIRJkxqRS9CHVV7QXqAuwWjBouBHeWHRqrnf5KDZDKkhBym
	 vC38UKsLdZ9XTNjP64ppHpKOEb3YWSnTg1ahT9DbZalOzU5EeXwq8/BK0CgT7y1RoPo49
	 7B0R1KO3Oas1hyWNseOQ2ioce/A7eC2Rpzd5f+ICi0oQopi2uagqyfbnpa/FXQKn8ew+8
	 /f1g2Pw0Xu34qEmYpPDiY9afwpPUmSoIk+czKPX0myZfYyw3mbKqq8gIqcTikoqwwxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=glN8E9NI;
	arc=none smtp.remote-ip=209.127.230.113
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EE6606A321
	for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 03:39:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80EE6606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=glN8E9NI
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1795491569; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=dlbuhAn+tEV4C47nJtxGZ63JKuJQ15avO1MyMdM9WME=;
 b=glN8E9NIeeKMB7+geCVFSPSu6ghA6dhgmI3YYMDmuLBvNTIsJt8gXTIXg9I13zn6H9l3Oc
 hyYpsQcXtztCGqeBzwF8Gbq6pyb5HxrdfxsoeOd2+9Z+IYax8ero5cEyPMUB25uNuCapm+
 JrbgY0EVFW0unOjkS8UUAP6MMt2gFhJB76/Y7OLFm4n8RZU0ANLL95eFqL/3EP+dVqAQ0O
 kY3oHajbVdsfcs+HV8Mf2tTVsl+PgZGGCGV//9HnALtqFuKw/E2N6XWTbO1iwAE9+v3bAj
 R7rhT+pqgmQQhIRjEGUjCf/vDPUq4JNyig0SHlyjVq2Hu6hziNHUwv9BFs9qqg==
Date: Tue, 24 Nov 2026 11:38:58 +0800
X-Lms-Return-Path: <lba+26b0506ef+2a76bd+vger.kernel.org+zhaogongyi@bytedance.com>
Cc: <linux-kernel@vger.kernel.org>, <tytso@mit.edu>, 
	<adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>, <jack@suse.cz>, 
	<ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>, <yi.zhang@huawei.com>
Subject: [PATCH v4 0/2] ext4: reject impossible group free cluster counts
Message-Id: <20261124033900.76700-1-zhaogongyi@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
To: <linux-ext4@vger.kernel.org>
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
Content-Type: text/plain; charset=UTF-8

ext4 initializes its free-space counters from the group descriptors. A
corrupt descriptor can advertise more free clusters than its group can
hold. Journal block replay can also replace the superblock and group
descriptors that were examined when mounting.

This series adds an optional JBD2 recovery callback and uses it in ext4
to validate the recovered geometry and group descriptors. It checks the
metadata before fast commit replay and checks the descriptors again
after fast commit replay. Both halves of the group free-cluster count
are read under the group lock.

Changes since v3

- Reject loss of HAS_JOURNAL before fast commit replay or journal
  reset.
- Recheck the extra inode size settings and the checksum seed,
  including EA_INODE and CSUM_SEED without METADATA_CSUM.
- Validate feature and field changes that affect mount setup.
  Recheck encryption constraints and initialize the VFS encoding
  when replay applies online feature enablement.
- Preserve JBD2's failed-commit diagnostic when recovery uses a
  validation callback. Document the callback context and lifetime.

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

Built v4 with arm64 GCC 15.2 and W=1 at both patch boundaries
for fs/jbd2/ and fs/ext4/, with CONFIG_UNICODE enabled.
Also built the complete series with CONFIG_UNICODE disabled
and CONFIG_FS_ENCRYPTION enabled.

A host-side control-flow test covered the failed-commit diagnostic
for callback and legacy callers, callback errors, and fast commit
replay ordering.

Ran v4 in an instrumented amd64 QEMU/KVM guest on 7.4.0-rc2-syz
(7475ea8b5), with both patches applied to that test tree.

- Recovery accepted valid descriptors after block replay. The callback
  rejected out-of-range free-cluster counts with an empty journal and
  when corruption persisted in a separate descriptor block after block
  replay.
- Recovery of an online resize grew the filesystem from 32 to 128
  groups, reloaded the descriptor table from one block to two, and
  completed a read-write mount.
- Read-write recovery with fast commit enabled reached the second
  callback and passed descriptor validation. Read-only recovery
  reached the first callback and mounted without errors or warnings.
- Recovery mounted an existing casefold filesystem. On the empty
  journal path, failed descriptor validation left the superblock
  unchanged.

Earlier v3 tests covered deferred EA inode eviction on successful
read-only fast commit recovery and on fast commit replay failure.

Application of fast commit tags and the read-only path through the
second callback remain unverified on v4. Replay of online feature
enablement and rejection of invalid replayed superblock settings,
including casefold settings, still need runtime coverage.

Link: https://lore.kernel.org/linux-ext4/20261102042428.65204-1-zhaogongyi@bytedance.com/
Link: https://lore.kernel.org/linux-ext4/20261119122601.85293-1-zhaogongyi@bytedance.com/
Link: https://lore.kernel.org/linux-ext4/sashiko-outbox-223131@kernel.org/
Link: https://lore.kernel.org/linux-ext4/20261120025459.70290-1-zhaogongyi@bytedance.com/
Link: https://sashiko.dev/#/patchset/20261120025459.70290-1-zhaogongyi@bytedance.com?part=2

Zhao Gongyi (2):
  jbd2: add a metadata validation hook to journal recovery
  ext4: reject impossible group free cluster counts

 fs/ext4/balloc.c     |  10 +-
 fs/ext4/ext4.h       |   2 +
 fs/ext4/super.c      | 452 +++++++++++++++++++++++++++++++++----------
 fs/jbd2/journal.c    |  33 +++-
 fs/jbd2/recovery.c   |  42 ++--
 include/linux/jbd2.h |   7 +-
 6 files changed, 425 insertions(+), 121 deletions(-)

base-commit: 4aa05e642bade8cf8405936b03cabf848fe6c456
