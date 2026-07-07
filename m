Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE31A1A08AF;
	Tue,  7 Jul 2026 02:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783390903; cv=none; b=SRDbSd7oY2sSs5HCtYe3ww4wO0FNyIXgkv2lumdWJd4vwprNPwi6MtTddgWaZE7H2goq5sbTb0cr8Qfv6A2QoH+W8N/H483WPU7Sj8AtIOnE9lC6pQHu88DY0uThxARUd8ih9gfrcAJ0rUXhL/UoNer6uP2A3x6kOtIhxcK61OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783390903; c=relaxed/simple;
	bh=3TOiFIOEG/CJoghp/45/sY1XKypMiJreAVS18yKQ8/I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iUrn7AaDorR7qht8bxgrYn0m4kEVNiKYmzmobMX6r8bGc2B/MGDNWS3h6AHybr70lo+v4qr+AG9x9SRCdAZ5QUS1FuesU4VbBpgRbBrn5B4Ui3ACrDS3AJtQ9BRiSS6jS3+foJhzDIxsxHZnJM1gUUpurOE9VJCnbYPpvVELx+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gvQ2k6nRfzYQthl;
	Tue,  7 Jul 2026 10:21:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 7F03B40B48;
	Tue,  7 Jul 2026 10:21:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgA3SHShYkxqYSBRAQ--.61087S4;
	Tue, 07 Jul 2026 10:21:37 +0800 (CST)
From: Zhang Yi <yi.zhang@huawei.com>
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	chengzhihao1@huawei.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v2 0/6] ext4: fix unaligned edge handling in FALLOC_FL_WRITE_ZEROES
Date: Tue,  7 Jul 2026 10:13:32 +0800
Message-ID: <20260707021338.1182268-1-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgA3SHShYkxqYSBRAQ--.61087S4
X-Coremail-Antispam: 1UD129KBjvJXoWxAF4UCr18Gw43Gry8Zr1xGrg_yoWrGry7pa
	9IgFW5tw4DG3sruan3CF1jgrn0v3Z7GFWUGrW7KrW8ZayUXr1xAFnIga10vFyDGws5CF9F
	vF45tr1j93WUAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0aVACjI8F5VA0II8E6IAqYI8I648v4I1l
	FIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr4
	1l42xK82IY64kExVAvwVAq07x20xyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUF9NV
	DUUUU
Sender: yi.zhang@huaweicloud.com
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

Hi,

This is v2 of the series to fix unaligned edge handling in
FALLOC_FL_WRITE_ZEROES. This version drops the last cleanup patch in v1
and adds a new patch protecting the WRITE_ZEROES crash window reported
by Jan[1]. The two pre-existing fixes around ext4_block_zero_eof() and
ext4_load_tail_bh()[2] that reported by Sashiko will be sent separately.

Changes since v1:
 - Pick up Jan's Reviewed-by on patches 1, 3, and 5.
 - Expand patch 2 to also explain why a clean unwritten buffer returns
   NULL (a lookup-only get_block never sets BH_Mapped for unwritten
   extents), per Jan's review.
 - Drop the last cleanup patch "skip ext4_update_disksize_before_punch()
   in WRITE_ZEROES" because it's wrong.
 - Add a new patch to protect the WRITE_ZEROES crash window by adding
   the inode to the orphan list in the same handle that does the
   unwritten-to-written conversion, and removing it once i_disksize
   has caught up.

v1: https://lore.kernel.org/linux-xfs/0b7f1a4f-da1c-4297-8099-98d738070ab7@huaweicloud.com/

Origin cover-letter
===================

The current FALLOC_FL_WRITE_ZEROES implementation in ext4 does not
correctly handle unaligned edge blocks. FALLOC_FL_WRITE_ZEROES is needed
to convert the requested range to written extents with zeroed content,
but the existing code only partially zero the edges and never guarantees
that:

  1) edges that are clean unwritten extents or holes get promoted to
     written extents, and
  2) edges that are dirty unwritten or delalloc get their underlying
     extents converted to written before the syscall returns.

Both cases leave the on-disk extent type unwritten, violating the
WRITE_ZEROES contract, and in these cases a subsequent sync buffered
overwrite would still observe pending metadata changes from the
conversion work that should have been completed by WRITE_ZEROES itself.

This series fixes the unaligned edge handling and cleans up a related
redundant i_disksize update. The first three patches are preparatory:
moving ext4_zero_partial_blocks() earlier in ext4_zero_range(),
documenting the return semantics of ext4_load_tail_bh(), and replacing
the single bool output of ext4_zero_partial_blocks() with a per-edge
bitmask (EXT4_PARTIAL_ZERO_START/END). The next two patches fix the two
scenarios above by expanding the aligned allocation range outward for
skipped (clean unwritten or hole) edges, and by writing back
partial-zeroed edges so the underlying extents are converted to written.
The final patch drops the now-redundant
ext4_update_disksize_before_punch() call on the WRITE_ZEROES path, since
WRITE_ZEROES is mutually exclusive with KEEP_SIZE and the i_disksize
update is already handled by ext4_alloc_file_blocks().

Thanks,
Yi.

[1] https://lore.kernel.org/linux-ext4/3f6ao5amv7glbgigndtegcucgo3n34ij3lau6l3da3hgdxgn3v@ev66wv3r5umt/
[2] https://sashiko.dev/#/patchset/20260701142009.1510104-1-yizhang089%40gmail.com?part=2

Discussion Link:
  https://lore.kernel.org/linux-ext4/3f6ao5amv7glbgigndtegcucgo3n34ij3lau6l3da3hgdxgn3v@ev66wv3r5umt/


Zhang Yi (6):
  ext4: move partial block zeroing earlier in ext4_zero_range()
  ext4: clarify return semantics of ext4_load_tail_bh()
  ext4: track partial-zero outcome per edge in
    ext4_zero_partial_blocks()
  ext4: zero out whole block for clean edges in WRITE_ZEROES
  ext4: write back partial-zeroed edges in WRITE_ZEROES
  ext4: protect WRITE_ZEROES written extents with orphan list

 fs/ext4/ext4.h    |  5 +++-
 fs/ext4/extents.c | 71 +++++++++++++++++++++++++++++++++++++++--------
 fs/ext4/inode.c   | 47 ++++++++++++++++++++++++++-----
 3 files changed, 104 insertions(+), 19 deletions(-)

-- 
2.52.0

