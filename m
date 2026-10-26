Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793015965;
	b=Q5nNsI5AdI5ov+isz61JnHemHnCJg1v3asYOLjcedQ3sRB1nmX0Asojclag4SlBXb+3b
	 LgzaCV+/ErLlreNJoUY9RF0qTX777N7U7jgjlUuIyrgSj+Md9NoIK4C7lFca+jFTy6En0
	 xgPR1fUd198khXpBjPhNcFDKEVdG1RV3oqScZYYQnsATrtLVhD0u1S3Lalx8344C7Byrv
	 GKP1TnMGpiKklo+DWgvUHkeMADLBIQ9obOkFIXTmsbDB6swqy/zrSxcxf3+zFhMNyXDcM
	 MZ6RmOaeY8U/FHXeMyZif4ueHMzpGo4CXUYL8ZL8+xao6cr8aME2E9dIgwTJ+IyHIoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793015965;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=wMECFGf1dJ+JUL/cAgZjhtFU7GiFidhwDrY0vvhSt6w=;
	b=Q5UAv04zxAdAw72ffQ44psCFfliMUsCszqf6BTFVeW4dIBvqHA+Da8gm4EhuYVXzu82G
	 bIvGpPjvNbKzEjKjvP7UuMPXiWYFMs1gS1sbtJSqRne3FdbZPM3yrum4XUSZwMmnYV6YI
	 1LPoPYUmLEXBg1+Sb63vfzDzADcUFtYgV90tkwtzFnK29P9KbaT8fc1+ikOEfBIs1wa4Y
	 eq47DWXktgSxaaIZRWMgqq6U9s0TQ8PdYVCYhHvm61I8u33XdalMmfsGWyIBPMSoacuvC
	 t3YjHPfQsJVk9GROVqihYEtj3eqlWp/tpbWvRAOuNaIPJ3hR8NkJYVYv2iYHYdd5rtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.112
Received: from dggmsgout12.his.huawei.com (dggmsgout12.his.huawei.com [124.71.93.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEAD606A320;
	Mon, 26 Oct 2026 11:59:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BCEAD606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggmsgout12.his.huawei.com (SkyGuard) with ESMTP id 4jCsbs7509z1yZd;
	Mon, 26 Oct 2026 19:59:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D48AD4056B;
	Mon, 26 Oct 2026 19:59:15 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAnZvWLQN9q6RyfBw--.40032S4;
	Mon, 26 Oct 2026 19:59:15 +0800 (CST)
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
Subject: [PATCH 0/4] ext4: assorted fixes related to the buffered iomap conversion
Date: Mon, 26 Oct 2026 19:51:27 +0800
Message-ID: <20261026115131.1735014-1-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAnZvWLQN9q6RyfBw--.40032S4
X-Coremail-Antispam: 1UD129KBjvJXoW7CF4rWr15GF1rZrWDGFW7urg_yoW8Zr4DpF
	9Ik3W5Gr1UX343CFZ3CayUWFyYkF4fGFWUGr4fG34fZFWYkry8XF47Ka1ruF9rArW0va4j
	gr40grn5C345ArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JUQID7UUUUU=
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

 fs/ext4/extents.c | 49 +++++++++++++++++++++++++++++++----------------
 fs/ext4/inline.c  |  8 ++++++--
 fs/ext4/inode.c   |  3 ++-
 3 files changed, 40 insertions(+), 20 deletions(-)

-- 
2.52.0

