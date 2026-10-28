Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168197;
	b=X3BlTReD+g0HtfT/BXwP14K3sIpCvsS81qfpOhUWN7q3/nj5UbXLap0yABHy43FppfGG
	 9/BJEl2bZmOO9jxqjmae05UL9Hf/BOKXRQBsq9q7CkO/bArJLjw5LpwbkAiSqYKR8ZGQE
	 zr9sp1hmwfaLSDChgnN4c/S72vr2cSPWkAQW8XawcHMvlNpOg2V6MdXigKURLYSTiIkFn
	 njTZAO460eQY59+vX3wnRfphXccEvH+wZ2ZjxermfypRomC67tf9tCJj+YmlRhK19PHCs
	 e0wNznptQkcPxwY1VuvKrYawFa7RkXoSqmCX6C5s2DCJFJi/oi3ptGuQEqen36aSMoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168197;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9R9LaBRh9udXMBlJBNWQe1InqKAXJ/9+XRSXSIVZido=;
	b=sGMG96LxXE+lOWCItMoGT3xBv8tuP3rnnLVwwWgfbLfwip4ihhEdagd13nuIIQDLOYjh
	 LLn4zshG7IyXpCwphNnKFDCsiTVnYsMb89SQUwcTiQyxWqPWE4Iey5sRwip8gwHTgmkwn
	 Y7UlLo97EEAiU4Gsa5vLa5LImzFo6Cb6N97wrMPvGHS6BaNzxZSlvsQeRog0nqjucWOVc
	 1kWuGWP32RgyG2sHHmstabAtnMIhT/uVxFAaawrOc+taVh+Qf6Tk/zBFRAGj5VS1Gqwmt
	 AWsRwbkt3Mha9aOJkzGyYi0IdNN+fhDlFdCaw+QWiYlLcBYe8gH3AQTUfRv2t1i7kqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qL75CXXS;
	arc=none smtp.remote-ip=209.85.215.169
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA386606A31A
	for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2026 06:16:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA386606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qL75CXXS
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cc52c1b8286so329289a12.1
        for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 23:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793168196; x=1793772996; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9R9LaBRh9udXMBlJBNWQe1InqKAXJ/9+XRSXSIVZido=;
        b=qL75CXXSLAU/Gv2tLrwqvQXPx4mu4GWPyIo9Q1zgJBv85dLOVQzwja3aT+nCxp3GUm
         8X8u4UylayMON4X/Kgu2lHWAB2MwBylTV3UA5khPFMl62Ukuv3Bge+LBhjqYP4Js5L8O
         ZhZETSZ4kfYzJdQ2V0177tWGB/K3S7HavVD06xvtKzVXOkgUejx4C8HO+ElqiadTmQuy
         pzAmR4utmFQ8sNiFITD5YKCQFHKGCvOAoB3ltnvQ3st19NO6obqIVr9J3hnSFs6j2J4v
         2mC8pEGgACy1uvaN8XVNcLuM7BOTHFprhVwT5MQEaUBRaFnObKL9qmWYdG/tGFAwPF7G
         jViw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793168196; x=1793772996;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9R9LaBRh9udXMBlJBNWQe1InqKAXJ/9+XRSXSIVZido=;
        b=QsLaqSWWLgGp6rnpXUXbRSxCkl07dUvxxe66phouCwyAB2L/fl9rOdkUw9H5SO1QuX
         /bkh2oGL4BndFyyDnv6DqtnnQfBW65nZdfSuUwLRYeDhvd3PJ95HdiZA3W5WF8AyyE9y
         YgCyEhd4Sgln+Txn3aXJPaTq6tqb1Da1RXvMKoYOUiJ484/DBh15jpFu+ACaCLiLY/Nj
         6W5uu+Tquk2MTZh9rj0HAg4sh9iYZpdvvqElNeNlh/eY3Qi3TH1f02zXOiEmtkeZxzs7
         HSdfl1GvueNa1hJP9GmubZDE79je6Loi6rCdvy3wfb5MggFHj6fdsx9d8ZvEmsp53xgc
         woww==
X-Forwarded-Encrypted: i=1; AKwUvBx9cXdjhTLKW8Eqn7WQ8LF22ptLETuQXIFGWSALO75FdCF3cnbNp+BrlCmUB+U5v+6U9YPKBe6zNrXh@vger.kernel.org
X-Gm-Message-State: AFq9FYJAwodn/pJNNcRO1TNCrWitldFG+y7/XbjPqpsd6nsgjks4APzO
	ThcBPaJXIplzMwTfLmRoNf+Fat/ej3iTT1YeqslkbdSoIcEJ0a5wi4Ee
X-Gm-Gg: AYBFou0i13wRKqZPEL5kjy8lvCijPP+MfR7M5n9UVeTB7bw32kOJgKZiv0/VCITmrOC
	GBfUQktzFewhtWzkBnP1+vmwUam2t2r3eNLVUuo9Tt1d1f45OFrZ91xcEu4yKMGJ5NEk4PRZeLT
	465ZOoghgWiYsW04mhyZr5AX0M1Ddd3DdfjxwWQE1IHQZkkDQ7XsAfL3LTUcq0p9IvgQIA9x377
	k7XLaQNi44+wbukffnFUoEnf9m7vz7u8hS6MQeNKHPx1YbRYc0OCaBpP6DnDPwD4umMc7jo3SWw
	464BQktV9KXxoD9g4xXccinc6subs06NB7gzSii6rBPCStY5k3+mUBuyUt/5Y84GBwKqTB7UAKD
	l31uiAwZszDGRH4xxjXfWd4zcuXk8Jhfzw1657cBU4WO3/Yr/JrEMOk3hHuoRFd2vXaqpaNLKpl
	b71Pjf2qBHAPYnj7nSd4vPOiBG9UdhTBIoBMCTWRiBJPQ9Q4DDjxqwsNHvDmnJy70fcDhU35X3q
	cDxr/r9CR8JGcaCpJnxKBN3BnhaLc9eet656oGTZDR4/6TDNCJr6cH6YtXnp/EL/hbh4CZSFtcj
	WcXP9wYCzkgBmBh4fjwq9jNuZQrxhXL3bTbwVEUtexdgMx56r7s6JRGU4Om+MIbieg==
X-Received: by 2002:a17:90b:2ec7:b0:3a0:cca0:4a8c with SMTP id 98e67ed59e1d1-3ae5c6c4568mr318608a91.7.1793168196136;
        Tue, 27 Oct 2026 23:16:36 -0700 (PDT)
Received: from localhost.localdomain ([14.116.239.34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a586662sm1433996a91.14.2026.10.27.23.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 23:16:35 -0700 (PDT)
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
Subject: [PATCH] ext4: fix soft lockup while shrinking the extent status cache
Date: Wed, 28 Oct 2026 14:16:28 +0800
Message-ID: <20261028061628.1209508-1-frankljpliu@gmail.com>
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
taken again until the next inode. Once the shrink has run for one
second, call cond_resched() so the CPU can be scheduled before the
scan continues.

Signed-off-by: Jianping Liu <frankjpliu@tencent.com>
---
 fs/ext4/extents_status.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 018b6146b9d8..c9c70db5eb71 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1679,6 +1679,7 @@ static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 	int nr_to_walk;
 	int nr_shrunk = 0;
 	int retried = 0, nr_skipped = 0;
+	unsigned long end_jiffies = jiffies + HZ;
 
 	es_stats = &sbi->s_es_stats;
 	start_time = ktime_get();
@@ -1719,6 +1720,15 @@ static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 		nr_shrunk += es_reclaim_extents(ei, &nr_to_scan);
 		write_unlock(&ei->i_es_lock);
 
+		/*
+		 * Call cond_resched to avoid soft lockup if a kernel with
+		 * preempt disabled.
+		 */
+		if (time_after(jiffies, end_jiffies)) {
+			cond_resched();
+			end_jiffies = jiffies + HZ;
+		}
+
 		if (nr_to_scan <= 0)
 			goto out;
 		spin_lock(&sbi->s_es_lock);
-- 
2.43.7

