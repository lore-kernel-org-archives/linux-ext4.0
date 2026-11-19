Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.230.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795091193;
	b=PiWo+eFGMswDSrdnGF88gs2d0pYVkDd+nKCXkK3LsqGFo8zhlunnEZttLRiMKvSJYI5O
	 7+o+KxYuLB4W3eWL1TOW/Ih7349aJ3YoVFv2HJtjuxakN9slLlIQW01fXbKTSZi0qZ0dP
	 YxSxYnWXb0VvaUKtRb01pzduIH7blFoEJ3ZaoeKk0s4AUq18sLuNGM8Qv+SrpjC/dCaU5
	 K1mxh/Qr/rna/gs01HC2foT0yNCZw1CVLQNHMWuk9TayYDQKKKWAOayi+Z9WEgB0EkYe2
	 n62Rdae3CLjbZCh9DFoQrlFoAa3f5+frIFzELSH5qdII5LQCXij8l49xonZ25azUfZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795091193;
	h=DMARC-Filter:DKIM-Signature:Subject:X-Original-From:Mime-Version:
	 Content-Type:To:Date:X-Mailer:From:Message-Id:
	 Content-Transfer-Encoding:Cc:X-Lms-Return-Path;
	bh=jse7ytWs++1dDBa2AyXcwOH6VrhUJJTlrNBoPj4agAM=;
	b=hf5P/BPuLFjLoleQqrZ51AeIeMgLwJDv6ypozf8NB34RYmtQFHpOxF8ursSs9FLXH9v0
	 lf/4ujwpe9ydQA1VSa3xCoZJSfwnWXoPx2C3Lc4rIse8N6ugXZ5Nv6/zk61QuUqqmanYD
	 7PD3Yqeg5E9oJtJRR0RnY8cvzdnCIxHHwlEhoEAG1gc9xEHO60359kKa9tTC1lRSGIhPg
	 n4OckvcYfPGYKVEG+t9iJEe4oTme8jTIcKRCNBaQ2bZw3m5Mk2OOdFutC90lm9qH2pCJR
	 LIAOFEUXIwSZFtcgr/41C24df+n0alkrX+dsRM09VkkWNzlWozFYu6F/RPGznysYXGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=Gu7ghLKx;
	arc=none smtp.remote-ip=209.127.230.112
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65B3606A325
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 12:26:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C65B3606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=Gu7ghLKx
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1795091186; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=jse7ytWs++1dDBa2AyXcwOH6VrhUJJTlrNBoPj4agAM=;
 b=Gu7ghLKxmTWROaYmifo2U5oopRSpm99Nv/V85WuOtjdLqtt96droxESn6Waaig+tfIf3tX
 PcENGCXCmBbtiEFqJMNj8DLTpnjGVKetWU5/YnTFDXTfU3m86vqGOnbDK0HtNKESqL93RF
 ja8YFofR3R9F2Li/U8yeHY40tFs1a0J7Dq/bgpWxzBBJnWgKr3QnN/6MRDoEUlmYqJddOz
 2e70qLDRgPERA/Xu1Dm+mShyIiW8J2Z8d+XBGuD79c/j2EN338UFsqgxml/oIk5k31coMW
 44jus+Ci4w94EORojxD7wniJ/SdcPeOOorejgqRAzCiB2p/p/uUwmlkSS6DkgA==
Subject: [PATCH v2 0/2] ext4: reject impossible group free cluster counts
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: <linux-ext4@vger.kernel.org>
Date: Thu, 19 Nov 2026 20:25:59 +0800
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
Message-Id: <20261119122601.85293-1-zhaogongyi@bytedance.com>
Content-Transfer-Encoding: 7bit
Cc: "Zhao Gongyi" <zhaogongyi@bytedance.com>, <linux-kernel@vger.kernel.org>, 
	<tytso@mit.edu>, <adilger.kernel@dilger.ca>, 
	<libaokun@linux.alibaba.com>, <jack@suse.cz>, <ojaswin@linux.ibm.com>, 
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>
X-Lms-Return-Path: <lba+26afeeaf0+a1d40e+vger.kernel.org+zhaogongyi@bytedance.com>

ext4 initializes its free-space counters from the group descriptors. A
corrupt descriptor can advertise more free clusters than its group can
hold. Journal block replay can also replace the superblock and group
descriptors that were examined when mounting.

This series adds an optional JBD2 recovery callback and uses it in ext4
to validate the recovered geometry and group descriptors. It checks the
metadata before fast commit replay consumes it and checks the
descriptors again after fast commit replay. The ext4 check reads both
halves of the free-cluster count while holding the group lock.

Changes since v1

- Defer full descriptor validation on recovery mounts until journal
  block replay completes. Keep the initial checks needed to load the
  internal journal.
- Revalidate the superblock geometry and reload the descriptor table
  when replay changes its layout. Validate the free-cluster counts
  against the recovered geometry.
- Put the JBD2 interface in its own patch. Sample the group free-cluster
  count under the existing group lock.

Testing

The earlier combined patch was tested in an amd64 QEMU/KVM guest
running a 7.4.0-rc2-based kernel. The runs covered these cases.

- ext4 rejected the corrupted bigalloc image before free-space
  accounting. Valid read-only mounts succeeded and read-only mounts
  with an out-of-range count failed.
- Ordinary journal recovery succeeded and mounted read-write when the
  recovered group descriptors were valid.
- The recovery callback rejected an out-of-range count with an empty
  journal and during recovery with a nonempty journal when corruption
  remained in a separate group descriptor block.

The recovery tests used additional diagnostic logging to identify the
callback. The QEMU runs preceded the split and group-lock change.
Fast commit replay and recovery from an online resize that crosses a
group descriptor block boundary still need runtime coverage.

Built fs/ext4/ and fs/jbd2/ on the ext4 dev base with arm64 GCC 15.2
and W=1 after applying each patch in the series.

Link: https://lore.kernel.org/linux-ext4/20261102042428.65204-1-zhaogongyi@bytedance.com/

Zhao Gongyi (2):
  jbd2: add a metadata validation hook to journal recovery
  ext4: reject impossible group free cluster counts

 fs/ext4/balloc.c     |  10 +-
 fs/ext4/ext4.h       |   2 +
 fs/ext4/super.c      | 294 +++++++++++++++++++++++++++++++++----------
 fs/jbd2/journal.c    |  22 +++-
 fs/jbd2/recovery.c   |  38 ++++--
 include/linux/jbd2.h |   7 +-
 6 files changed, 287 insertions(+), 86 deletions(-)

base-commit: 4aa05e642bade8cf8405936b03cabf848fe6c456
