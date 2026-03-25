Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9948B35AC2B;
	Wed, 25 Mar 2026 07:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774424029; cv=none; b=g9qezX9bRxsHSFYjNsWBvbm3TknWoNRVEVB8ErBWoosS80S9xn3fuuat2RJWAF8XS3AlJrlaGiF9jEG9Y6E6R4xFTeCIQ6LK1pxJvm6tidkbEX1Y2R48ezKQwck0mFCfoGqL/dlqsL0Hgw6GtH1MlugAkbia1/Ha17S4QTlWSog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774424029; c=relaxed/simple;
	bh=olD2FM6XLCTdlXmKSTmeRZfT98JoWYF62YvdT8sqDV0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nC/5yrzxyLddf0eLPQ3kuEoevgD8NbjhOzTQRPRJOvOanJ9IccdZWTu27Z3j6IY7uTpqV7Ps066WXthl84iKiB2EJY6012dywaA8xkmpnfqxQkkij23DTuzVSNlOf1BVuuk63m6zQpgWW6L+BdxLW4M1PukEJWqie0hnLs8cT2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fgdt45ZpSzKHMYH;
	Wed, 25 Mar 2026 15:33:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 2286840576;
	Wed, 25 Mar 2026 15:33:39 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgAHC9vFj8NpuR6cCA--.49898S4;
	Wed, 25 Mar 2026 15:33:37 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	libaokun@linux.alibaba.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v2 00/10] ext4: refactor partial block zero-out for iomap conversion
Date: Wed, 25 Mar 2026 15:28:39 +0800
Message-ID: <20260325072850.3997161-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAHC9vFj8NpuR6cCA--.49898S4
X-Coremail-Antispam: 1UD129KBjvJXoWxZw48tr1fKw48Xw15CF45Wrg_yoW5uF1DpF
	W3Kw15ur1xG39F9a97CF4xXw1a9wn3Gr48GrW7G34Du3yUZFyxCF4kK3ZY9FWj9rW7Ga48
	XF4UAa4UGFn8Aa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUFg4SDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Changes since v1:
 - In patch 04, rename ext4_block_get_zero_range() to
   ext4_load_tail_bh() and drop the unused 'length' parameter as Jan
   suggested.
 - In patch 06, modify the commit message, add another reason to drop
   data=ordered mode when zeroing partial blocks in ext4_punch_hole()
   and ext4_punch_hole() as Jan pointed out.
 - In patch 10, modify the commit message, explain the race condition
   between the buffered write and mmap write that pointed out by Jan.
 - Collect reviewed tags from Jan.

v1: https://lore.kernel.org/linux-ext4/20260310014101.4140698-1-yi.zhang@huaweicloud.com/

Original cover letter:

This patch series extracted from my iomap conversion v2 series[1]. It
refactors the ext4 zero partial block code path in preparation for
converting buffered I/O to the iomap infrastructure. The main changes
are:

[1] https://lore.kernel.org/linux-ext4/20260203062523.3869120-1-yi.zhang@huawei.com/

1. Introduce ext4_block_zero_eof(): Extend and rename
   ext4_block_truncate_page() to handle post-EOF partial block zeroing
   for both append writes and truncate operations.
2. Separate ordered data handling: Move data=ordered mode handling from
   __ext4_block_zero_page_range to ext4_block_zero_eof(). Only truncate
   and post-EOF append write/fallocate paths need ordered data mode,
   hole punching and zero range paths don't need ordered data handling.
3. Split journal mode handling: Extract
   ext4_block_journalled_zero_range() from
   __ext4_block_zero_page_range() for data=journal mode, leaving
   ext4_block_do_zero_range() for data=ordered/writeback modes.
4. Refactor ext4_alloc_file_blocks(): Change parameters to loff_t byte
   granularity to simplify callers and prepares removing the zero call
   from the allocation loop for unaligned append writes.
5. Remove handle parameters: Stop passing handle_t * to zero functions.
   Make ext4_block_journalled_zero_range() start its own handle, and
   move zero operations outside active handles. This is required because
   iomap uses "folio lock -> transaction start" lock ordering, opposite
   to the current lock ordering.
6. Centralize zeroing in ext4_write_checks(): Move all post-EOF partial
   block zeroing to ext4_write_checks() so it applies to both regular
   buffered writes and the upcoming iomap path.

Thanks
Yi.

Zhang Yi (10):
  ext4: add did_zero output parameter to ext4_block_zero_page_range()
  ext4: ext4_block_truncate_page() returns zeroed length on success
  ext4: rename and extend ext4_block_truncate_page()
  ext4: factor out journalled block zeroing range
  ext4: rename ext4_block_zero_page_range() to ext4_block_zero_range()
  ext4: move ordered data handling out of ext4_block_do_zero_range()
  ext4: remove handle parameters from zero partial block functions
  ext4: pass allocate range as loff_t to ext4_alloc_file_blocks()
  ext4: move zero partial block range functions out of active handle
  ext4: zero post-EOF partial block before appending write

 fs/ext4/ext4.h    |   5 +-
 fs/ext4/extents.c |  83 +++++++--------
 fs/ext4/file.c    |  14 +++
 fs/ext4/inode.c   | 255 ++++++++++++++++++++++++++++------------------
 4 files changed, 207 insertions(+), 150 deletions(-)

-- 
2.52.0

