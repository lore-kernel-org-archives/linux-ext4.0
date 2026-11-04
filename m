Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793763352;
	b=Ujad/9lOuCFxnO1MrVe9YRO02feKxM4Hp3SBDalLmmYcX2HcfPR86mXjRZKfZl5L4Gnb
	 Yvmsqq9kY9RVIZ7gUo3Z3FvxmhxTY2KqI1vD6mVMxsdKUn34ESozrSVdAw6UrUAlBOuRo
	 g2ABN0G4BtdJ1TLsdiw/3IW6WvY3wYyFM9g+oZSMA5vMjQeEjlIsuah3MzHJg7M+kv9v+
	 ObshKxY8IpuPp7zeHvvxH+w+KUjTG62QvNre547siKejurUTadDJ6gcFuk2PNYvTBd1gE
	 kkA/hHDgOZ+8HRaQmYcoo34TFOUw9HN5xD4U9ily59nMPloadPCmbkl5QZhQhrhMTpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793763352;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hAHLejY9oB/8f/CfT1Y6ivnfaaSpI9Ek0JXQqjTj05U=;
	b=aENJDtZlb3zKwTL5KlE7xlDJVrycHqN1i2K34R1xsT9ehKHIBDvgL83C0xDBmEeZmmIo
	 UL4xLAz67W9MCHFeXdQQBBT0iQBeyGiRCAtdBOGguH0vFErd2QSaSyzPViOy1Bm37OFGG
	 r5X9phnIe0/fIklSfZHjRjlTGyUnkDr2ZsCQ7Duq8E/maen5+KT/BKGj9R07y+dehyqGP
	 dTxTGBzxcgLjthr+5CIsWGPnjrSq4Y5shYKR8K22XXyhgtJ8T+w634IAJXa9HCGabSUBN
	 zM/wFPrPZGxg8C4SkNccFO+KAYWj9zbqSnaCGCCBCLtREQIZ7wIKHF5M09nQV5uJc8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HLoyn5F0;
	arc=none smtp.remote-ip=209.85.214.175
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E013D606A326
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2026 03:35:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E013D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HLoyn5F0
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2e98798cbddso1134625ad.0
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 19:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793763350; x=1794368150; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hAHLejY9oB/8f/CfT1Y6ivnfaaSpI9Ek0JXQqjTj05U=;
        b=HLoyn5F0DxNrsAHS8+TfkRmfUbGr6VxTYbCCG9BptYSU79sXh3ZQeB7WHhp/zkC1BP
         MEZ+rLSLw2ugKprYH8WjTD5pF+7Z8Hz8Gv5fZ621EIF5PM2cLAEwwxLX64HFuJLccRBI
         dxVePSPgZQPJeTqxTG3UUMjVeROgPoBR65+UD9UOj1/f4wE7/8X/Dn2LnN5pwmLUGopY
         DuXckwzgYGKHgPvgPu9UQFQ6P8/2nW+DzR40cvf/Da7QGFLwnXEkNku+XfwYFv/Cn3Do
         BfHZNn92rijfyVqnq3L4TZyTEPStUwvlAakzjtXd4GvoxZ7OYMwcbtxdI9flcSLIq2IJ
         KFxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793763350; x=1794368150;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hAHLejY9oB/8f/CfT1Y6ivnfaaSpI9Ek0JXQqjTj05U=;
        b=qiqQk79+VbQ0uYO1+8VCdrvYf4pY59a/zCfjFqEElUoPQzVCYTtRaqTIsmhUPvwkGr
         /2ngwv+YQiGRRbQl57DJ8Ye5dqzp9+vX3UFqjyQRL+nVRtckikx2DuyV/Ph1NislTS1Z
         caJTukeFdXXFYW1RlVELNcU/l3wVDZcQrUgChOZywccbMnzoNmqjZULRd/HmJ9Rvd40G
         z3k9PfS/jA1O51Iq9ZnC+83dZlmHD7eax6bxKgVnJzGvOFVxZky84tXi3Q+fkMhYR6Us
         HkScZI25aaWqqshjrzqxM7TltBXARkQPphe9NTjGC2Qc71X3lnntXImYLhJQM+7gnsaD
         oozQ==
X-Forwarded-Encrypted: i=1; AKwUvByE+ZqVl6RORegNuvhGdpzx3ohimUWVwtYNPMaMDE/8HxsAZleK8kgFdt7Y/KmHbGPznflE49Rd+HR6@vger.kernel.org
X-Gm-Message-State: APuU4Z/bDfI4pobKiOaCIbs+pP5fAYrfAnJctDIbn74HcZ/YX/kgHHlw
	bRjHM3Z/zxlqDwpsuEGwTBIul6AICVzPJx2sr0PeyfHY61LabBpPRxzr
X-Gm-Gg: AYBFou1DCTvAl0ZrZzvZTYMx/RrHn+78s3WvPFDxOlyLx8O5VywQAofygZTfD5Io04d
	/7qivPS7/Jgj68hS1lTQpMiyS9IWNzbfzoIjEj4LGaMx6hVnhjIQCfB0QKGq77VAj6XYLNmjD5E
	DH/h3VnudHF3o/wt6EpmONh/sXpYDRK7VX/rVubWufFtVsx7SwJ2fxWXMx0rg4pJHEi98/dB5bg
	cejWn+cX9FW5abSmdOEwYWv26KFam+mukBmd7gn918tqH+k8nV927PjWDkdaejq8tupZ5TkCGmN
	4lm0z/n+mZCN5Ip68iaAjxPwHNkdr3lp4pDpBtK6gVRs674KTct745mneGU1PSKmWfiuLxQzNMv
	Avd4TxL4E9wkFpvd2WvTZT4Z+uSU1apzTc1irN662iz8nFjd8ZeVVfsqCGp0fQhlYs8JC7B2qQR
	bT0uADB1KTFrJcLjPnK4kMbpGM6JhGmF/efc8qTStl+Leni5em14vSf6K9Krp3T4ODw4kGGoSqM
	Fag7/7gzOIZ31R/z2B83LRrsovwY73zbf9RZz00WnS8OoDLSFm7F6sctLBerWhOqzGWH2OxNaPK
	mbGIDBZv5bZqy+xngvRbmMb8h8l+Ly5D7vjDLXPb1xs4WIkel4nsWHCx+m82i7Jr
X-Received: by 2002:a17:902:c405:b0:2df:8733:f229 with SMTP id d9443c01a7336-2eb3649ebc2mr145706335ad.24.1793763350157;
        Tue, 03 Nov 2026 19:35:50 -0800 (PST)
Received: from localhost.localdomain ([14.116.239.40])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed08bd50b5sm1555095ad.4.2026.11.03.19.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 19:35:49 -0800 (PST)
From: Jianping Liu <frankljpliu@gmail.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	frankjpliu@tencent.com,
	linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] ext4: fix soft lockup while shrinking the extent status cache
Date: Wed,  4 Nov 2026 11:35:39 +0800
Message-ID: <20261104033539.3031910-1-frankljpliu@gmail.com>
X-Mailer: git-send-email 2.43.7
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

From: Jianping Liu <frankjpliu@tencent.com>

__es_shrink() walks sbi->s_es_list and reclaims extents from each
inode. On a non-preemptible kernel that walk never gives up the CPU.

There is a soft lockup report on our company's machine. The machine
with millions of active inodes, 256 CPUs, and heavy memory pressure,
concurrent shrinkers run too long.

i_es_lock is dropped after es_reclaim_extents(), and s_es_lock is not
taken again until the next inode. When nr_to_scan remains, call
cond_resched_tasks_rcu_qs() before continuing the scan.

cond_resched() does not report the RCU quiescent state needed here.
It is compiled out when CONFIG_PREEMPTION=y. Otherwise it schedules
through preempt_schedule(), and RCU records that switch as a
preemption. An RCU-tasks read-side section ends only at a voluntary
context switch, cond_resched_tasks_rcu_qs(), idle, or return to
userspace. The helper reports that voluntary quiescent state and still
lets a non-preemptible kernel reschedule.

Changes from v1:
- Delete time out logic.
- Change "cond_resched" to "cond_resched_tasks_rcu_qs".

Link: https://patchwork.ozlabs.org/project/linux-ext4/patch/20261028061628.1209508-1-frankljpliu@gmail.com/
Signed-off-by: Jianping Liu <frankjpliu@tencent.com>
---
 fs/ext4/extents_status.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 018b6146b9d8..62346eaf4350 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1721,6 +1721,16 @@ static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 
 		if (nr_to_scan <= 0)
 			goto out;
+
+		/*
+		 * Report a voluntary RCU-tasks quiescent state before continuing.
+		 * cond_resched() is not enough: it is compiled out under
+		 * CONFIG_PREEMPTION, and otherwise switches via preemption, which
+		 * does not end an RCU-tasks read-side section.
+		 * This also lets a non-preemptible kernel reschedule.
+		 */
+		cond_resched_tasks_rcu_qs();
+
 		spin_lock(&sbi->s_es_lock);
 	}
 	spin_unlock(&sbi->s_es_lock);
-- 
2.43.7

