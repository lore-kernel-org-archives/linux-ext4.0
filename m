Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793537938;
	b=MZ4cOg5zeC+au3SE9hBD0B/UifpgFnSbMHcMRaamHRFcEdnt0Qv2crhgVW29Ql2J7ZfX
	 jIawsE/9YQz/Y5QszcC6zpj18PkZaFNOwsovYh7ZKRQjGZnCkeDW94a/24z97auNsT86o
	 oZJwYVhZmgDVNiWYGggzyBtlxnm/3NpFhwGFJhHk+pgxcQgUVKF3R/1KtYiGKYHC2IgVP
	 fpmrBXys7gpuOWnVrJNJkN3dpkjFsAWM6+MRV+D6/2ZN2PMStB/NCrisKr71vxu9z0EaX
	 8L4IaON0fLIqezw1UeAhRDHxau4djrxUViUVdJbgoUSPYwPKARhSCMqoIQZuDjexPSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793537938;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=f1wYtROk1JVShHemw1ffijHkVNneua03omMSYk9W4/I=;
	b=qe8FT6HIL+k+FdPWRd/mevM1IgUBn12VTYUzj/MX1basgJYChMXalHSNjKTCWjj4nno4
	 SiBV19pSNKX0Pti43eC0i5dDmIfvG98D48IH0cu6DPjlcwafgS3310WEu1c11s/UCh3XK
	 V9RiH78qs1ZvuTPeybqSsqqRRNSkljq0poAlNXbvbi5N0IBtj7p5qiTYF7RsKno2AI9gC
	 R9IBITMoX+corw0YoS59yt9PJpt5Y74x2U0vDpjtdu0UZpa0k/Clq2Wtfl6xAHwKEicsV
	 R9eNfJ252AD6dmVKbDVSMNYDY24RPbSU8PJEKLO20h5JbJmUDAFuYexz5V/pLo+MT0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=c4pwIr2c;
	arc=none smtp.remote-ip=74.125.229.137
Received: from mail-dl2-f9.google.com (mail-dl2-f9.google.com [74.125.229.137])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51F5606A325
	for <linux-ext4@vger.kernel.org>; Sun,  1 Nov 2026 12:58:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B51F5606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=c4pwIr2c
Received: by mail-dl2-f9.google.com with SMTP id a92af1059eb24-19305bcb6d5so558728c88.0
        for <linux-ext4@vger.kernel.org>; Sun, 01 Nov 2026 04:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793537937; x=1794142737; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=f1wYtROk1JVShHemw1ffijHkVNneua03omMSYk9W4/I=;
        b=c4pwIr2c/emHOXEN40E5IfXyk15GzTXOji9PPET9yj5joQViGOmQyWLaslV86a+Psh
         hGUdIRE+IFYyukG3ODs21A6x95+aPn7RPYAkOsJxL2jqp5l/Qx3IO4J35R1ebSmkIZnw
         ICmUgPqFQ1fe0uodhPooU4v1VLnaUT5K6ZG7luXyQKLZYYdcoA46amImiVcmWDgAnROe
         5Tan64D4AqK4ovvD7KHGgOatNu/SnRinAvmBZvRH6tGOFyvoYsdvQo6s3kcPXBgF4Pc2
         J3tlT9p24l6NdW4BjheFQ7jHPYxiEWRoydftP5FAkE2bzEyx6mQYgYirVuKxlcGfFrtr
         lbgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793537937; x=1794142737;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f1wYtROk1JVShHemw1ffijHkVNneua03omMSYk9W4/I=;
        b=F+OxIug78L8tdHlbtQb1YNm6xv6CPjQeQ7xg2qDYWs5QriMIh2DG+KiKHpc1uzfVgD
         yj0tBG0FJJSOiYWtwqsh8Gy+3k9joTqG8BuPulHnjgwHQOHN1SPVi5xYOIF+GL4XZXW7
         gF7XUkr7Pac6rjLTHG0dR/2gEQPsuuqpw2Pj9it9mN7R7vNMI5srFz6Zl+QfoZNwFqED
         Xg9AcDBEgAS41wHqD8XQDX3znLeU5S6ue+nPjDIRdk0FC/f4it/iGoTJbT83JA35T7ME
         VlLF0pQ/rzvMzfvQqBHQ0VgcwTWvJdWPMPRjnEF+xd03LUX6Hl9M058jzd/GCTESTUCZ
         o75g==
X-Forwarded-Encrypted: i=1; AKwUvBxum0rMKkMVi3fcipFmZXJ6EFfG3zdUobseGYnpNp+tF+bt5hFeb0yOtp+wNoeA0UUYvix3szh3Fc+L@vger.kernel.org
X-Gm-Message-State: AFq9FYKKstavnGdaOQsyr1dYlOqRkH5CuH/rYjeXPOpSuChj+z8LmFCk
	StIoExk6vidJVLibPbCkbzaw2ECt9gvHhTrvnYgjAaIytibxXuQKAlfM
X-Gm-Gg: AYBFou0kHBEjENvFUA+aP5WQJ+yrgcA5MN1N1ufPn9Rut/hJprDygok6eoppKpwvEqy
	GUNok2fy2UDSIpy5fHruXOop+t3xcXMJfEjkcAS/JwkV6F+enmS6jq4+UyPCnXV/uKgLL9DWIBJ
	v16Y5coKgTiScZpXi735UxWHgdlzKG73mV0gngYk9t21C2PILMRkNMU+voPzkIO3XJiVIXw/oh9
	KryK2UcZkRha3cbXEWr+msnP4Z79c+LJL+WcbMWn0b6IbDQco49P7QMw6tRFw1QNLgeiOLVV0A+
	P0VrI1midab5NiRnGYwyDZ4fvZ2p305EuxCPyyWmlA5136C8/+FRSZQpXEcgXCvCvY+q/owjw93
	fdwK/HzyfFkddzPfd0govfLtKWYCk5J3qcfDmH3Hi2VcsYWMvPDJMmcnCK9cQxRebXCmbnFXxU2
	qIscxV9XxvJQRmAWaASup/7dI98r6/z4427XLB10VcMPEbTnaVwjawbRRzxHRmAbhEu1hj5m88s
	WxMk8f8YBiUtfRqKAINt1UNdKDi1AC3jOapYK3f/pleuMNkVHAQwHs6lvEAPzm8AILy0ASYXoZS
	K0y+ggCiduXQBbigUNFReUUqQoq9vuIZ2ydf7R4QFD9SoRx0YVBUmkAM
X-Received: by 2002:a05:7022:7e0c:b0:147:a685:9125 with SMTP id a92af1059eb24-1ac574556abmr11534422c88.2.1793537936546;
        Sun, 01 Nov 2026 04:58:56 -0800 (PST)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1a13652csm27433334c88.17.2026.11.01.04.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 04:58:56 -0800 (PST)
From: Hungyu Lin <dennylin0707@gmail.com>
To: tytso@mit.edu
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH] ext4: report sub-block project quotas in statfs
Date: Sun,  1 Nov 2026 12:58:47 +0000
Message-ID: <20261101125847.54531-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
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

ext4_statfs_project() converts the selected space limit from bytes to
filesystem blocks before checking whether it is nonzero. A nonzero quota
smaller than one block therefore skips the project space adjustments.

For example, a valid 1 KiB hard limit on a 4 KiB-block filesystem leaves
statvfs() and df reporting the underlying filesystem's space, even when
unprivileged data allocation fails with EDQUOT.

Test the byte limit before converting it to filesystem blocks. The
resulting zero block limit then clamps the project space statistics to
zero. Keep the existing rounding and the rule that a zero byte limit
means no quota.

Fixes: 689c958cbe6b ("ext4: add project quota support")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9cae52471dee..91c1a54730f6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -7001,11 +7001,11 @@ static int ext4_statfs_project(struct super_block *sb,
 
 	limit = min_not_zero(dquot->dq_dqb.dqb_bsoftlimit,
 			     dquot->dq_dqb.dqb_bhardlimit);
-	limit >>= sb->s_blocksize_bits;
 
 	if (limit) {
 		uint64_t	remaining = 0;
 
+		limit >>= sb->s_blocksize_bits;
 		curblock = (dquot->dq_dqb.dqb_curspace +
 			    dquot->dq_dqb.dqb_rsvspace) >> sb->s_blocksize_bits;
 		if (limit > curblock)
-- 
2.43.0

