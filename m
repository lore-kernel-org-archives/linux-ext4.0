Received: from out28-76.mail.aliyun.com (out28-76.mail.aliyun.com [115.124.28.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2370437A83D;
	Tue, 13 Oct 2026 06:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791874545; cv=none; b=ntG4bY7TKUw3/fK5ZRrAc7m4OcRheZVJuB76QuDQmE+cbxye+za020P1UfflSN2J0W/vMARnYQImF24k6YcH7JDfIXXgi00/xauPepdzKcZACGfme1cDM9Yea4jn1rVUUaEaDbSDAWk15DbNz1Wo1tvi5K/vu7SpP+wG+H0hYZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791874545; c=relaxed/simple;
	bh=PISy3SVABn67fHF04ulOdcSzl+QWbkqPBYMDO8qiwLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DF/GvQB1X8uLg39kuBwbhyju48maNQEEL5uNnkqf4ZYgruvwqLeskCdgb+L3PNYEacnwccBtOXcX9srPgx9cigLhf1jYRCgFx8deygCQ8akQv2P2fp0mj6xZzIrEFbFiPhPMvgEextf61p3Ul/1r+uj8IpSdtGRhnDMUDeu3ijs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com; spf=pass smtp.mailfrom=xiaopeng.com; dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b=EN84N+Fj; arc=none smtp.client-ip=115.124.28.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b="EN84N+Fj"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1791874531; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=wGtB/w4Xo1n8Ww942ixcm7IXYpRnUR6HTfNkgTYaXbM=;
	b=EN84N+Fj39AT0DADR8j/XqFsRhw6UwVBY7WEH/TkdYnN0fa9mZC0s/1uspKJFoRXyugt9I0wxaCMqCg/mfE91t9dr6+ZVq3vBVtRAMF3czVXZuwzS6as/shqwG7EHfP4xdDEdIenBBfnuBE8xBKRlGOyi9MJRSM23is3apcD98c=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.198318|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0324748-0.0025322-0.964993;FP=8616361359640773361|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033040074035;MF=zhugl3@xiaopeng.com;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.jbIOHT9_1791874530;
Received: from DESKTOP-UL5U09E.xiaopeng.local(mailfrom:zhugl3@xiaopeng.com fp:SMTPD_---.jbIOHT9_1791874530 cluster:ay29)
          by smtp.aliyun-inc.com;
          Tue, 13 Oct 2026 14:55:30 +0800
From: Guanglei Zhu <zhugl3@xiaopeng.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guozh23@xiaopeng.com
Subject: Re: [PATCH] ext4: check CAP_SYS_ADMIN in ext4_ioctl_get_tune_sb()
Date: Tue, 13 Oct 2026 14:55:30 +0800
Message-ID: <20261013065530.1395507-1-zhugl3@xiaopeng.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013020145.1297074-1-zhugl3@xiaopeng.com>
References: <20261013020145.1297074-1-zhugl3@xiaopeng.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for confirming, and for the pointer to
/proc/fs/ext4/<block>/options - I wasn't aware of that interface.

Agreed, this was not a real leak.  Dropping the patch.
