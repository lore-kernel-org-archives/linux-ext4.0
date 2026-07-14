Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C3635BDC7
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 11:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784029492; cv=none; b=HllGBl1xzqCWE2Tk8ruW0v2Kb5DGIS/TIaze6cmTuGCVAMNsk0FJukNnor01zYZRWryvMGgGS2Rox6DFBbIdPkQORPEGTl4d0aqE7RMESq0+NjEERntOzflTRBvfj5HKHKCo5P+SFp7nw/t+K0YHS1F86hNkXVd72n94ZBeNpbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784029492; c=relaxed/simple;
	bh=6Mz3a0Iu5kJvm1dNf+Gg+LchH+4sIqwxFxDv0JXHc2A=;
	h=Date:To:Message-Id:Cc:Content-Type:From:Subject:Mime-Version; b=YA6vO/9pBP2HAKZq/CG58S0WdxrBgNk+qhbiCFmHZKNguPIOSYgtGbaAgcu52+8Q51gS5bUYx7AsYIi3r+L+/qio5SQhqmjRL/A52zSSm9Rmvv6056ZSr2HITgEQe7qne3FbEq16uMtYtA1tT9sLBGoInXiPn1fDh15GfTOqStE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=RxPv2dGT; arc=none smtp.client-ip=209.127.230.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="RxPv2dGT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784029472; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=OeSOJ5ANe/eMM5QzqfYkPsf3URy1CIks25LM33ykpCQ=;
 b=RxPv2dGTTFeeZwS42WVw8EIxkPR8Us0eM6m+xPDl5I3crfZ1+GZvv1xv4lYG6UzmbmfinI
 5AHmXm9LbUsak9AC2veEwFvMJO3zdkNbxegh0O7OVIhHFrDuo6DDPtWRUqw66Z0CMJtBxC
 jaUWoz8T5nSMIfKaFlow5LrJkqniP9qdASv2I3v/vCtn7UIWjT8hg1IHggiuBMycjtXpYf
 zlGdnXu3jfWR/wjhsmiEs8Mnfi+25/rCcJviMTxxH7CRXPqadLe49qtiLFgEZUTMMyLqZF
 JP5xEy5eMMdCvCIc8+WOLJ/Mqf1mVQtaLm99JjYiMVZQFIwduTEC9m3tkxQCOg==
Date: Tue, 14 Jul 2026 19:43:56 +0800
X-Original-From: Fengnan Chang <changfengnan@bytedance.com>
X-Lms-Return-Path: <lba+26a56211e+e2f844+vger.kernel.org+changfengnan@bytedance.com>
To: <tytso@mit.edu>
Message-Id: <20260714114358.93335-1-changfengnan@bytedance.com>
Cc: <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>, <jack@suse.cz>, 
	<ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>, <yi.zhang@huawei.com>, 
	<linux-ext4@vger.kernel.org>, 
	"Fengnan Chang" <changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
From: "Fengnan Chang" <changfengnan@bytedance.com>
Subject: [RFC PATCH 0/2] ext4: fix DIO read slowdown after extent status reclaim
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

Hi,

This series fixes a slowdown in ext4 random direct reads that appears after
extent status entries are reclaimed.

Problem:

The extent status tree and the extent-tree leaf buffers do not have the same
lifetime.  Memory pressure can reclaim an extent status entry while the
corresponding metadata buffer_head stays in the buffer cache with its
"verified" flag set.  The next lookup then takes this path:

  1. ext4_es_lookup_extent() misses--the entry was reclaimed.
  2. ext4_find_extent() reads the leaf, but __read_extent_tree_block()
     returns the already verified buffer without calling
     ext4_cache_extents().
  3. ext4_ext_map_blocks() returns the part of the extent starting at
     m_lblk, and ext4_map_query_blocks() caches only that suffix.

Reads to earlier blocks in the same extent miss the extent status tree again
and walk the extent tree on every I/O.

Testing with fio 4K random direct reads (io_uring, iodepth=128) on a
128 GiB file (75 on-disk extents) after triggering extent status reclamation:

  Baseline (full extent status cache): 525k IOPS, clat avg 241.96 us
  After extent status reclaim (no patch): 296k IOPS, clat avg 428.69 us
  Degradation:                      -43.6% IOPS, +77.2% latency

Fix:

Patch 1 makes ext4_es_cache_extent() report whether the requested range is
cached when it returns.  The result is passed through ext4_find_extent() and
the internal map flags, so ext4_map_query_blocks() can skip the second cache
update when the leaf was fully cached.  If population was skipped or an
insertion failed, the existing query cache remains as a fallback.  This avoids
taking i_es_lock for writing a second time after a leaf read has already
populated the extent status tree.

Patch 2 handles the extent status lookup miss described above.
ext4_iomap_begin() opts into a new EXT4_GET_BLOCKS_CACHE_READ_EXTENT flag for
DIO reads.  If the leaf lookup did not populate the extent status tree,
ext4_ext_map_blocks() caches the full matching written extent (ee_block,
ee_len) before cropping the mapping to the requested block.  Later reads
within that extent can then use the extent status tree directly.

Fengnan Chang (2):
  ext4: avoid caching an extent twice after a leaf read
  ext4: cache the full extent after a DIO extent status miss

 fs/ext4/ext4.h           |  9 ++++++++-
 fs/ext4/ext4_extents.h   |  4 +++-
 fs/ext4/extents.c        | 43 ++++++++++++++++++++++++++++++++--------
 fs/ext4/extents_status.c | 20 +++++++++++++------
 fs/ext4/extents_status.h |  6 +++---
 fs/ext4/inode.c          | 40 ++++++++++++++++++++++++++-----------
 6 files changed, 91 insertions(+), 31 deletions(-)

-- 
2.39.5 (Apple Git-154)
