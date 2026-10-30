Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793326899;
	b=NRp33GZDGq4Hnc8Gw6xwvMTpgkdIT+2xfcR5Obdu0nR2LBK9YvzRx3KDKTqCEstnpyxI
	 bYHk/qYjTguu+4FEl0N0+kzWElnd2s67kAEzlHqmq7orIpFNibFl6IxlT1l16DJBknmdO
	 /RRNp7Eyg7sGVO2V3rD5/IUPIDCjxGveEfA+ybaCCLljGwWCt3oZir8/RQ7zXxSYAIMpw
	 bN4KMXzpsQkuztVuE/Jo0w2kg05XtiVth721ny51MALwvx/DSCcT/6Fe/2fNo73DeBbxc
	 UkdtvO8ag/LRIE1ItJDB0EVwdUAtlq/TAc81ahB8GEF6wCvJZfrghfa3b1RaC+1RLbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793326899;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=fAyHszCWedHKup8jcZLbfQt5on4HkZpXKqwhpziQPHI=;
	b=JDYrXmh4X8tQ33y9Ci+4A94oVv3mHc5K5t8NzwRDpSMwE5o9XwHVJE15wZt/ZVRtd0+y
	 zWLz89eFEOVQqpeGqUmYDwg0N65j4uyjlp4Fqgo6kpTDkf5Ee1G7FyIg9UgJVRcIOlsPJ
	 8k2LijA4JHphZZ773b3LBwrC3NsBBOZcgzb6uxPLJlkkh9cZoosuORb+2R5Vahr8ggdhV
	 S5hp4XP+beKXQbzW93/5sN/XwTrspBoer98Qsm84MmPk35BCuVxlpO4WNWRWYFQBEZ8/G
	 WYvHrbGEk5NxBXsqe72wWDWcax7uQCRoR1aHh9MMw0Tm9uDBB+H5RM+Rr2zsM5y55fA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.112
Received: from dggmsgout12.his.huawei.com (dggmsgout12.his.huawei.com [124.71.93.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB4E606A31D;
	Fri, 30 Oct 2026 02:21:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DB4E606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggmsgout12.his.huawei.com (SkyGuard) with ESMTP id 4jG4bK1ZNpz1yHB;
	Fri, 30 Oct 2026 10:21:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8D28440573;
	Fri, 30 Oct 2026 10:21:33 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCXzewm_+NqieRyCQ--.40911S4;
	Fri, 30 Oct 2026 10:21:33 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
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
Subject: [PATCH v2 0/4] ext4: assorted fixes related to the buffered iomap conversion
Date: Fri, 30 Oct 2026 10:13:34 +0800
Message-ID: <20261030021338.1768292-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXzewm_+NqieRyCQ--.40911S4
X-Coremail-Antispam: 1UD129KBjvJXoW7CF4rWr15GF1rZrWDGFW7urg_yoW8uw1xpF
	9Ikw15Gr18J343Ga93Cay7WFyYkF4fGrWUGr1fG34fZFy5Cry8WFW7Ka1ruFWDArW0v34j
	gr40gr1rCa43ArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUFjjgDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Hi,

This series fixes some small issues introduced by the iomap
conversion [1] as well as some pre-existing issues found by Sashiko. The
first two patches were sent separately before [2]. Packaging them into
this series to facilitate merging.

Patch 1/4: fixes a complaint from smatch, making ext4_iomap_writepages()
           return 0 directly when it encounters an inode that doesn't go
           through the buffered iomap path during leftover writeback,
           instead of reusing the stale ret variable, even though it is
           also 0. Not a functional problem, it just makes the code
           clearer and silences the complaint.

Patch 2/4: fixes a possible extent status cache inconsistency when
           truncating an inode that is in the middle of a delayed inline
           data conversion.

Patch 3/4: fixes the issue reported by Sashiko where
           ext4_alloc_file_blocks() cannot guarantee atomicity when
           converting extents during fallocate WRITE_ZEROES, causing
           fsck to complain.

Patch 4/4: fixes the issue reported by Sashiko where the tracepoint on
           the iomap delalloc write path prints an uninitialized m_pblk
           when it encounters a delalloc-mapped extent.

Changes since v1:
 - In patch 3, when converting unwritten extents, always update
   map.m_len even if no conversion was actually performed, to prevent
   map.m_len from being 0 on ENOSPC retry. [Sashiko]

Thanks,
Yi.

[1] https://lore.kernel.org/linux-ext4/20261009103033.2920530-1-yi.zhang@huaweicloud.com/
[2] https://lore.kernel.org/linux-ext4/20261014021714.2382353-1-yi.zhang@huaweicloud.com/
    https://lore.kernel.org/linux-ext4/20261016095927.1762656-1-yi.zhang@huaweicloud.com/


Zhang Yi (4):
  ext4: return 0 instead of stale ret in ext4_iomap_writepages()
  ext4: fix extent status cache clearing when truncating inline data
  ext4: add inode to orphan list before extent conversion
  ext4: initialize map->m_pblk in ext4_da_map_blocks()

 fs/ext4/extents.c | 47 ++++++++++++++++++++++++++++++++---------------
 fs/ext4/inline.c  |  8 ++++++--
 fs/ext4/inode.c   |  3 ++-
 3 files changed, 40 insertions(+), 18 deletions(-)

-- 
2.52.0

