Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7552F4AA403;
	Wed, 16 Sep 2026 09:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789551188; cv=none; b=osmMxVJaMv4+FfmeaydHyUG34l3dwMq4yJGtbXZK6eeVLgFnb53Po9NpaUnP/4+GG7Py3uCH3PELwehqlfWDnDmL6J1R7PuVAKMO+tE5j9ixjcuFiU1YnOu1uhEKArgD95hefPQ6XaA/vSkYXvpZ6vpUzDY9zUp4ZE2d+EB48d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789551188; c=relaxed/simple;
	bh=w9YzhxR2KtmehvMZOMS47J7SkbrCJL8hM2CVGO/cSXI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mn85RGmc3kl/64mBNGdm0z9vTHzrV5a0yDIYBL483r3NLr0CawLa4A0+6RY5Jhxi21wSjRjgGNECMFRrCCel2E6SR8WahgND73WoIp9YHDzOczPg6U+wQscFAVbf25dxrSuC2sYuw4E/iivgyzEwfXetdQb4Cc+UllG7HFe5pBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hlDFD3xWTzKHMcC;
	Wed, 16 Sep 2026 17:32:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B40AC40561;
	Wed, 16 Sep 2026 17:32:46 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCHVikvYqpq8i0GAg--.65015S4;
	Wed, 16 Sep 2026 17:32:46 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	bfoster@redhat.com,
	joannelkoong@gmail.com,
	djwong@kernel.org,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wangkefeng.wang@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v3 0/3] mm/truncate: fix data loss when truncating straddling large folios
Date: Wed, 16 Sep 2026 17:24:47 +0800
Message-ID: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHVikvYqpq8i0GAg--.65015S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Zry3GFW3XFyrKry8ArW8JFb_yoW8uw17pF
	WfG3y5Jrn5G3yxCws3Ca15Wr15tayxJF17Ca4fJwn2kFWYyr1j9r4Iqa1ru3yUAr92gry0
	yw17KFs8ua4DA37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0pRl_MsUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Hello,

This is the third version fixing data loss when truncating straddling
large folios caught on the upcomming ext4 + iomap buffered I/O
conversion[1]. I've clarify the split logic as Joanne and Brian
suggested, also slove the concurrent issue pointed out by sashiko and
split the patch into 3 small ones as Zi Yan suggested.

Patch 1: Add pstart and pend parameters to
         truncate_inode_partial_folio() and fix the data loss issue when
         the second splitting straddling large folios fails.
Patch 2: Fix the similar data loss issue also could encountered on the
         filesystem with min_order > 0.
Patch 3: Clarify the existing confusing return value of
         truncate_inode_partial_folio().

Thanks,
Yi.

[1] https://lore.kernel.org/linux-fsdevel/a638a8fb-c184-4069-ae33-379ec12cd514@huaweicloud.com/

v2->v3:
 - Rework the folio2 validity check logic to fix the invalid
   folio->index issue. (sashiko)
 - Clarify the pstart and pend setting logic and the corresponding
   comments to make it more readable. (Brian, Joanne)
 - Split the patch into 3 small patches. (Zi Yan)
v1->v2:
 - Export pstart as a new parameter so that the generic and shmem
   truncate paths don't need to recompute the start value from the
   return value. (Brian)
 - When min_order is nonzero, align [pstart, pend] to the inner
   boundaries of the folio to ensure they do not point into the middle
   of a large folio, which could otherwise cause valid data within the
   folio to be incorrectly cleared. (Joanne)

v2: https://lore.kernel.org/linux-mm/20260909062339.473816-1-yi.zhang@huaweicloud.com/
v1: https://lore.kernel.org/linux-mm/20260903115018.2034541-1-yi.zhang@huaweicloud.com/


Zhang Yi (3):
  mm/truncate: fix data loss when splitting straddling large folios
    fails
  mm/truncate: align truncation boundaries to mapping minimum folio
    order
  mm/truncate: clarify return value of truncate_inode_partial_folio()

 mm/internal.h |   4 +-
 mm/shmem.c    |  13 +++----
 mm/truncate.c | 105 ++++++++++++++++++++++++++++++++++----------------
 3 files changed, 79 insertions(+), 43 deletions(-)

-- 
2.52.0

