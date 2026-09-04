Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17B03A783F;
	Fri,  4 Sep 2026 07:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788507139; cv=none; b=EBXlI9M6TfxVn8BcvGj98LXUY4rlzpPog8WkDPMdlur6t+30MbDDZZJOWeLapRXjeqOyGXGRetdZ7bLi/WJAAJhezAp/iSBtJ9KNrsfW1G9z8AooopWRhon2WfkZMHqe/R6GEQOJZcQTYvh4vKG5tVb2wJARoc1utwxt7rPQNJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788507139; c=relaxed/simple;
	bh=96iE3pexa8+cVUmhYJ8vR50DHeJyU5qK1fBDRSbj9nI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sOko8Aw9SOEniKhtb0AztkUkNzlNVXuzss1yShuSoVNY7kvdWhATpwuI5N85E0y8jlk7GvPPmq4KTzwWGRz4VAzQnmem8XjbRdiRGhFwsdiqVDLbBe36Fl2xvSVWIzAeppQBKmh8yN4wAqLYiemRP1ppez92oXA84svQvTz0Voo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=l7mzQPYV; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="l7mzQPYV"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XjfCMP4NwSOTn0SHs1G8Px3vzp4+ZrUltUoVuQRiktk=;
	b=l7mzQPYVLFubr+qV+PJlfvHfo01pGz9d472FXqRddmhTuNiSUjLCRsH4+KhJOAJ1coVxroDux
	pJMePa7/E5DKRHDNhsD5yUGB+5ff7Lv6NfLadu+xzMbkHW6L5T8EGrOEgnDsS0Zq3LWD6nvMY2U
	1qCMqD/UVJhBJ2gxdxp0Mjg=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hbnvL2rt7zcbP5;
	Fri,  4 Sep 2026 15:21:18 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 956EE4056D;
	Fri,  4 Sep 2026 15:32:07 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 4 Sep
 2026 15:32:06 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
	<jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
	<yi.zhang@huawei.com>, <linux-ext4@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH v4 0/2] ext4: Convert group-count barrier protocol to acquire/release
Date: Fri, 4 Sep 2026 15:32:51 +0800
Message-ID: <20260904073253.663243-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk200008.china.huawei.com (7.202.194.74)

Hi all,

This series fix out-of-bounds read in ext4_get_group_info() and
convert the ext4 group-count barrier protocol to acquire/release.

Changes in v4:
- Split ext4 patches out as Theodore suggested.
- Link to v3: https://lore.kernel.org/all/20260902074805.398540-1-ruanjinjie@huawei.com/

Jinjie Ruan (2):
  ext4: Fix out-of-bounds read in ext4_get_group_info()
  ext4: Convert group-count barrier protocol to acquire/release

 fs/ext4/balloc.c  |  2 +-
 fs/ext4/ext4.h    | 10 +++-------
 fs/ext4/mballoc.c |  6 ++----
 fs/ext4/resize.c  | 19 +++++++++++--------
 4 files changed, 17 insertions(+), 20 deletions(-)

-- 
2.34.1

