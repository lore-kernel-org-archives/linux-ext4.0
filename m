Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E1A441037;
	Wed, 29 Jul 2026 09:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785316116; cv=none; b=RasSk1XsavQzuW8Ez7teamIXIjEtVq/hnzZ0E8SUJi0QFe0bJ0yEs6O34Qg2xtmh1wY0X+gYaUoQAM89jLE7LnNCo6UhUIwd6JGJPQTlfWUAfL3O3WCxlt+ttpCxudG7vT+dtisDIS+XU11Cb3z0SY8EDAJ0kfJv1eoHz92H5oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785316116; c=relaxed/simple;
	bh=FzEvyiCzBVtkYrSK9TyOddjX0/mO2/d7AJSRPcZ3Y0M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mJap10e8NIfYG9oE7E1D/S+hq5Kd8yIr7UuRMQ9IUphDfP8yoZHAoDCqXmTF6ZtjW3x2vthdZXcn4IwM0UO+lbi5yUORswgqwjp5JFCb+vGzkbFZ2ELIlBim9JuRGaFo5YEinbxlu8Y+mGthKNFB/1S9dB+1I9HWHfOVHpBuuMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4h960x6xk0zKHMSG;
	Wed, 29 Jul 2026 17:07:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id B6D0040592;
	Wed, 29 Jul 2026 17:08:24 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgCX1EMCw2lq_g5uAQ--.47619S4;
	Wed, 29 Jul 2026 17:08:24 +0800 (CST)
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
Subject: [PATCH 0/2] ext4: ensure WRITE_ZEROES is power-failure-safe.
Date: Wed, 29 Jul 2026 16:59:16 +0800
Message-ID: <20260729085918.3336221-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCX1EMCw2lq_g5uAQ--.47619S4
X-Coremail-Antispam: 1UD129KBjvJXoW7KrW5CF4DKrWrWFW7JrW3Awb_yoW8Gw4kpF
	nxKrWYg3y8K3Wfua43CF4UKr1Yyw1xGw47ZrW3tr4jva4UWr18Wr12gw1jgFykZ3yrW3W0
	9F47tryUuF1DZrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JUDl19UUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Hello!

This series is extracted from the last patch of my previous series
"ext4: fix unaligned edge handling in FALLOC_FL_WRITE_ZEROES"[1]. It
fixes the issue where FALLOC_FL_WRITE_ZEROES could leave written extents
beyond EOF after a power failure (reported by Jan). This series fixes
the on-disk orphan list corruption and filesystem corruption that could
occur during partial extent conversion in
ext4_convert_unwritten_extents() as reported by sashiko in the previous
version.

The first patch modifies ext4_convert_unwritten_extents() to return the
length that has been successfully converted in case of partial
conversion. The second first uses the converted length to determine
whether to add an orphan list entry, ensuring that any newly converted
written extents are protected by the orphan list before i_disksize is
updated, then well document the behavior of ext4_alloc_file_blocks() as
Ted suggested.

[1] https://lore.kernel.org/linux-ext4/20260714080044.4038124-1-yi.zhang@huaweicloud.com/ 

Thanks,
Yi.

Zhang Yi (2):
  ext4: export converted block count from
    ext4_convert_unwritten_extents()
  ext4: protect WRITE_ZEROES written extents with orphan list

 fs/ext4/ext4.h    |   3 +-
 fs/ext4/extents.c | 129 ++++++++++++++++++++++++++++++++++++----------
 fs/ext4/file.c    |   3 +-
 3 files changed, 107 insertions(+), 28 deletions(-)

-- 
2.52.0

