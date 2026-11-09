Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794194045;
	b=C42DHHIqpWYtu7AHo3sUuT9gWrIToN6Juh/Q8yToDeZ8Q53e73VHFhhoGOi9XX824cF8
	 +mk7RMWbm1il1cy16cDDkli0HfdJ6I3TlJmdCwukc6+WD6jzTRDbngSzas5ciVpOROOEU
	 sFTntIu+q+seVoWcv+3FnIV2PtR+mVYwH8WWTUICHsfSlXzjA/0fh88OESor3YML29Ugn
	 gszZjGABVFrPsHJVgqUZeICEaNqk6W1Y3BP9DNeENYCGvvpYP4lZcD5jBHyCY56QMyB7+
	 Z9n8ofsWtfZzmbLC3eXSiw1WKmP3pZl12G7oibryJcahPBjTfUYnpqdqAc3duK6eSOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794194045;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VUE9fszBcw5f0gncUDA39x4AdiHZ6gQeZTe6Ek+H6bc=;
	b=FkEkauzb12+B/aWNRXk5v/nuq3BHb2JZ0+VyUGijdQJ7+grSQVEOG4/ufBTLlxJOLHsW
	 pQbRJ2EX2pfxnG1o6g73xSbwQ8GOR0WuqjNEOrMUROHoVqPe3lJlfsPfUsFbZVlAO7g2m
	 fk745NHYMzAOIgMAdBYWDfOFH7z9OM8s9kcsTWwrKY7HdJda5FpcQTsO5CFKi10rUuNto
	 mJ8IewIpbqNyONXTF0OcKn5Mo4iltg7aXyvGxyZBVFxl0nwEdiP7lNVGGvYUxBGiyZTlw
	 eQrlwYbPPkscqnUG8ADhBkxBe3f4233Q80m7O8d28dZRjHVF7p5qDIfREhaDXnQ16ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ii8UOlHk;
	arc=none smtp.remote-ip=209.85.216.49
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A82606A31C
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2026 03:14:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12A82606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ii8UOlHk
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3ada8bc2380so183783a91.3
        for <linux-ext4@vger.kernel.org>; Sun, 08 Nov 2026 19:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794194044; x=1794798844; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VUE9fszBcw5f0gncUDA39x4AdiHZ6gQeZTe6Ek+H6bc=;
        b=ii8UOlHkddhZET9fGcc6EWux8CG0Boen0c/1JgTXitY7GW8Ln513czEzaOXjM6+xQ0
         Dm7tLrYYvqGG0+txWXuYUSf5gByma5Ofn6ZofSd9NPP2gpH7OORvXtVeFQnYuHpQvzzW
         84eYLNq2fbvN7zG9PEEezzcEXYq1Yq0+aIZoWtjcCdC0U0hlXvUpJ7UHYd457TjYoS3d
         szlq7VBduD5xyp7gXBbTQ7DTyEvrlCNDlqBBG91NJljY2KfFEraW0AR3KaWa3KfJo27/
         j+fSbn8Z703kg/cMNwwNIB7UQqXI1yE6V4Ip2qZfDCGOMQG3vfv+G3NYDnigmY1WkABI
         iFsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794194044; x=1794798844;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VUE9fszBcw5f0gncUDA39x4AdiHZ6gQeZTe6Ek+H6bc=;
        b=I6SRqORBSXRMqxneFYcmCzIfx2yJ8gkGffOVR7FELNHG/A0Afk1e53HfvexXBSicHV
         rqtxSt86+6r3spBWCGCukkByr3RFCNIRKOe3gnCr6p3gw02dfBFPRxWjHjnMF9/ubFzd
         Ia2tkJmH4Mu4xlOFYv6WNuY6qiFV4xOcPDQ1mHaE22hacMb/BgU8cGwpEivjUVhgqurO
         HONGNIexNxkaQUnV/1fsqmKiAvGk7hjkgU4fYfyq2KJlF3CeeXlpm3kg61waJ/E32Mqd
         4094vmD9MLqy+h57eCxudpHXdyicr1Fe57l/uOT4ltO6rUNcvyDhoJ4vcnH94AyQaxGf
         5xuQ==
X-Forwarded-Encrypted: i=1; AL+hErG/FLgM+lYPzV3JXlG/Oz8Mj8YpOmF5aTUCUI8qvee2/1kJ6JGpjU0EH2Fdl3sK9TsOsyq+0nwWk9hU@vger.kernel.org
X-Gm-Message-State: APuU4Z/F4+rLymMijxpvzRI3R9JdHG4ADJPHU4revcMt5apRw+7zmni0
	Ex5dvzSChP8xT9jVEGCH0D6mxpCTwI6rBlYjz8pM79yduBwbXr9UfOIl
X-Gm-Gg: AYBFou0dvRNoq6fpc+ltpnr5QxdRdWSFte/95UanTfUThaq20wpshqH/UgSk5Ji/ol/
	tyYfdHPk8W+p9NIwe4i9OBPR7jUOPHJr+0Q2o/IkP+cBvSBUwZWszF1PXsU3U/ai+C4bOWFihWe
	hLgXo7cWFMuvn7ZJeGBQsAoy80sr+WykbQLS0bZiTJyI8zS2XDgrEhrNaRlK2R7y5fBwSqtruKb
	fSa4c8AiVwc3pUJF/L9j6ghW9KkzCmfQpjcg3DNPfybtIywEQCFtHAs9BF39q1XQXlikqiB/TgN
	u0rr6xk0hf7Sh08aBv5rMMhtuvtQa58JuBufVNFaHVgG4wdcgAUHS3UWbKWY292gP1V4rbJnYjg
	jcQHzIz9jOk6B4QRt7h5X+lccdWhlDDyAUbJebbwJCyLrtlvxeaVs65kCiqbBTdc7itw1dZQNxc
	a/Rt5viqD5BQ7uoQ0tOg8JMI41BRn/WHxZhWEwN7gl5uDUftNLwqlTKkzpV1kGG05/2YTdYPjIY
	qF3nUil1S+bu2AuMfGHDj56hSUXUK1/AQR4S5K4c6s9AJQriIAPdmDnEJeBMV6tT46BmNJJLA1Q
	jdd+wsAvMD5uWttHuFeQungmo6KTNzxBXp87hxH5uLtbKOuf12Gp6lb/NSie3WM0wyAUeOV3whV
	5IrIIoVYDQrU=
X-Received: by 2002:a17:90b:380a:b0:3a7:9045:fe29 with SMTP id 98e67ed59e1d1-3b12d0e72eemr3053129a91.4.1794194044360;
        Sun, 08 Nov 2026 19:14:04 -0800 (PST)
Received: from localhost.localdomain ([180.101.244.71])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b127912d62sm5000590a91.11.2026.11.08.19.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 19:14:04 -0800 (PST)
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
Subject: [PATCH v3] ext4: fix soft lockup while shrinking the extent status cache
Date: Mon,  9 Nov 2026 11:13:56 +0800
Message-ID: <20261109031356.10659-1-frankljpliu@gmail.com>
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

Signed-off-by: Jianping Liu <frankjpliu@tencent.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
Changes in v3:
- Put change log below diffstat, and add Reviewed-by.

Changes in v2:
- Delete time out logic.
- Change "cond_resched" to "cond_resched_tasks_rcu_qs".
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

