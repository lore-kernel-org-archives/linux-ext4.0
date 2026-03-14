Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659AC175A8B
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 07:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773474890; cv=none; b=taoaX3MXbNVfruWp8lPGZaSAs2qi68NHHmk2Mnk/FvzveLyjowfvvCJDcqOBl4kq9YfJR9aJciumQwCC8vuigfKcYcIMoj0bLq4oat3AM75vGkGhpVAy51AE0Mtk+qkH8V4pILn44VxCY1KVUrgDFxQMTeBFtRuLwGaHikyje4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773474890; c=relaxed/simple;
	bh=Qy2vh7hpxkwIFIYy2GOofY5nc9b6x76cz+c11eyiUnk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FwAjlOarcWmCP6rDstAldqgfyFMNuryijcFSyuXnAZW9UJRkwdWSUwtB95s1FlVz3ujOTtQbIEAz2MXpG36EKyXJJ/gYa59IteVZOG5jvv5oR8jrWzCl4779UtV2RbEObbJvKQUlrU4QDtyNhHb5aRfr6nh1AqWCTyGN2IywCIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fXtsq3TBYzKHMS0
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 15:54:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AA9C440574
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 15:54:44 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgDX_UhEFLVpFaZvAw--.31331S4;
	Sat, 14 Mar 2026 15:54:44 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v2 0/3] decoupling the ext4 test module
Date: Sat, 14 Mar 2026 15:52:55 +0800
Message-Id: <20260314075258.1317579-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDX_UhEFLVpFaZvAw--.31331S4
X-Coremail-Antispam: 1UD129KBjvdXoWruw48CF18CrWUXF45ZFy7Wrg_yoWfArg_Ka
	47GF95Jr43XaySgFyUGr1Utry8Jr4xK3WrJas8Kr45ZFy7Zr48Cw1DGrW7Zr4jgr45C3y7
	Jr1DJr18XayIqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbo8YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMI
	IF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVF
	xhVjvjDU0xZFpf9x07UWHqcUUUUU=
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

This patchset is split out from the "Fix some issues about ext4-test"
patchset. It decouples mballoc-test.c and extents-test.c from the
ext4 module, resolving the issue where these two tests could not be run
when EXT4_KUNIT_TESTS is set to M.

Ye Bin (3):
  ext4: introduce EXPORT_SYMBOL_FOR_EXT4_TEST() helper
  ext4: fix mballoc-test.c is not compiled when EXT4_KUNIT_TESTS=M
  ext4: fix extents-test.c is not compiled when EXT4_KUNIT_TESTS=M

 fs/ext4/Makefile       |   5 +-
 fs/ext4/ext4.h         |   5 ++
 fs/ext4/ext4_extents.h |  12 +++++
 fs/ext4/extents-test.c |   8 ++--
 fs/ext4/extents.c      |  39 +++++++++++++---
 fs/ext4/mballoc-test.c |  81 ++++++++++++++++----------------
 fs/ext4/mballoc.c      | 102 +++++++++++++++++++++++++++++++++++++++--
 fs/ext4/mballoc.h      |  30 ++++++++++++
 8 files changed, 227 insertions(+), 55 deletions(-)

-- 
2.34.1

