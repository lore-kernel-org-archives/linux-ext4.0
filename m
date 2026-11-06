Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793935909;
	b=KS8UymKtNnXmPQ4eUaitq5nrRhfaa2gbaxY1Ijym/P6vTe7/gj4mEmqb00Evq2R/POyU
	 fymy0miXQOGi7/c+lRr3NdmhOPbrpgn6aP4QkncnaDTNqYnGQe5JvYiht+WkccHqbJNpM
	 pV5zCy3PiJo5M5LPQXHzG7ni0s48kz/FWSubfzLPa1wODVIbRZMib4pzqfqmT4CKmp1ud
	 YUvGQMrfx0JLOPajKoxiIoadAVsYXAaTD0+ZoCOrzFDZ7eoCIk2p3Y3xFiXc/4Lf5NpAL
	 5X18cMiL0CN+2YP1NbW3IUapgAn1adq+JdgHgIZchvLn7WOXTBmfx+Tbf3nAYVxmHiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793935909;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ac+FbFNWk1nqhg8Ij/ZKtiTVGqbMyhCel/9hHECenKU=;
	b=NNTtdTIyeW2b+wXwUv/6Ssdj4/x2OnPVroXpEwpVJtGhS93QAXtW+esKuq1fFFBSf4i6
	 myLlJgnzgN3tEh8WUNSX38eagbrVECGo5oxX4OCSSV7lLFgsw8Nd7saamhoT2pKW+o3vy
	 cR6YQQM4TRmIQXzhtdAlvdTRuvj/AZIzrRdRg6rqBkk1Tc8cDvvH8MERv3cvPzsL8HATs
	 qziRivMhM5J7Bm/q8gZsLU1E9ntyxeoSZT/tTRR0jGGDP4LjTp7Mz09zAjpqQU7m5b+Zd
	 aUv63jb4rxOxx4OpL4A8XRrCMLrY25UYZmQvJHbKvf6RzclCKHB84Jlxc3/MuPR05RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FMsvOSDz;
	arc=none smtp.remote-ip=209.85.215.180
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1935B606A326
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2026 03:31:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1935B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FMsvOSDz
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cdb2893531bso106304a12.1
        for <linux-ext4@vger.kernel.org>; Thu, 05 Nov 2026 19:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793935908; x=1794540708; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ac+FbFNWk1nqhg8Ij/ZKtiTVGqbMyhCel/9hHECenKU=;
        b=FMsvOSDzwM2v7+5eDgZB9sDPglRg4HR5NrFAPKms9VvxZn+H2InHvKUOP0fcot4vKH
         PB0+F6nej3ehuhv5g+Tb/Dm8tfx26r2Sl1rR5Og12UI4K1zji0KEvbmC7KOhJtc2VN1g
         gd8BuOqcEeeLhit/JNx0dNfB1INAlZvpm14SE+PZ6juGL/QNQwl/hp3VUMtlcoeRWU8l
         3TsTuvINl6yG2crjyKJW/m6Tu7KAgG5AymPqwkp6PMu19FaNOPfSn1T7Enh7yuadCHda
         pBw9cEkPSRPPQPGTiDmp0uPOckAxW7wBJxlPa8uDKBMznTqHS1Z9sh6Hxs7sPTFdWYZm
         LHnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793935908; x=1794540708;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ac+FbFNWk1nqhg8Ij/ZKtiTVGqbMyhCel/9hHECenKU=;
        b=PaUU38oLf84nWGAqiRhbs+tRaG8Vdpcv9OG+OGnzm13bP3Ab4ZkHPZroAMkYe+j0uB
         WVn9Fvh6qaErOPn+Tc86fO9nLJzOP4OwaatWXY+gYR9IkrsQjlBNAI/gD7t0jZIkkuyv
         uVZjmhjB5KxLlXdWA/8QJ73Oxtj2HbkjY0PHPL6NtTUej6vs8PFmCyt3cz93QQioJNn1
         H+eb51/kQfmByxzIA/+2K8Ga9psXvq9oqqMoFKJBdISR4Ap6ir4BWeWJAB062K0lgNPF
         usZq0J3+FqgbbLMzNC9kXrEbV8YX8XOXaUKTJPzRyUrHR7p/7PC31c4iDHXT8Z7pUX13
         Kirw==
X-Forwarded-Encrypted: i=1; AL+hErGqkbjUFX1p71wMpfYfDbYAmYjHImhSCGkCM9S4TztO2DnzoEiTr2nX9StO5U/IOEudJRxObtQnzOkH@vger.kernel.org
X-Gm-Message-State: APuU4Z9OrkWiztgO83YQta6JaV4a6p1hmCCm7Jq2YNK5qsGWDPRdluCr
	XpDkQq1NWD24U4DlmdQ2AQXcbvxWUD6tOfD2Ylx5yQzT44CefDEJ227E
X-Gm-Gg: AYBFou2kEihIEXteJPzBhgRlwemo/qpQHazcgiCOpBomKVXQgXYyhaREpemAwvSuAAI
	L/SqS0pKRjFc7b6BOp5oCQd2yDTwdaKceS1QLim085BR1pzCmfO4vAxFe45kpvXV4OOvs/kxazD
	5gPBMqk3DX5N1cVKfJJkrHM70t9erl2+zLdmjxl2KzNXqMzsqx0L2oLcrxlAPmaVQQzsc6W/WB4
	6DYSSn9nV8nyoEOCUh9+nmEoswrFGWUEDkr4jYN3aNMlTN2ZYUuhKW5acOzR/+MLPvQVQCUFmZL
	T+tqEeTojpmOLrMx4Z07zN8DFuDSjQrt+LGFCmkt5WCyjSvtUVtCKmjfs+67D4Tglxm1pXuD1d/
	dWD6rlxVE5BAbznjWjIaQvH3bBxc4XbDjZB6dF0JxGf0mfyaf2wndVUIkvgcM472Cu/nG9RMGRl
	jXSYJ9FvtcAd7LJDydoCAKN80uHCH4K/60b2bFw34k2rpJMtujSavqsfzLBbyeu+WZKracLPEvk
	5SUVcwY0Ogrbkfm7u8Sger2GbHMTt6Hf3Ab9Crp84bZjxCcBKx6f9FSYROvtvFbUxQGs1N7ZExC
	PxHrV1cQl0fBjtbtfr6IGDwrzuaFbImtDrcE8BCZh8BFhPnomOpQAFyfjL7qXrbY
X-Received: by 2002:a17:90b:3804:b0:3ad:b7d1:8631 with SMTP id 98e67ed59e1d1-3b0db6bb484mr1239958a91.17.1793935908218;
        Thu, 05 Nov 2026 19:31:48 -0800 (PST)
Received: from localhost.localdomain ([14.22.11.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b323cd3csm5899802a91.3.2026.11.05.19.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 19:31:47 -0800 (PST)
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
Date: Fri,  6 Nov 2026 11:31:41 +0800
Message-ID: <20261106033141.1509656-1-frankljpliu@gmail.com>
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

---
Changes from v1:
- Delete time out logic.
- Change "cond_resched" to "cond_resched_tasks_rcu_qs".
---
====================

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

