Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792736339;
	b=ZEj8/dU4wpXNlw1ZpbL5tEmtcSI2NiphnWAtKCd6ZQt8rxnAZQZQP0rpx13T3QAS4vCS
	 xvlNo1nAHYOVh5dwmgEe+VpEkm6WH+a3t/eqdy8jc3eNq6Yq+NwzG2I9iHBP8gUfHp2Du
	 +DMkGhCjiAafQXaNJb9rFMV9Ows9tjUixMdpIirlxHSJYmpHHMWGjavd2gnNIxUiTiSBJ
	 gE3X6xhXtp4Dx8ySl8nVgm389OhFxp84rqSCFB5fvaYZ7Wu/LsO6LxQVZsnAxOmOkb9PV
	 UziJKNzxd85W3Wlp1TkpBSHknZtR3aZC6HFVVY3PV/CNUA2Z3ElqMe8ifn2OGlp4gbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792736339;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LbXFF+YYPbJMTbGG7xPR1k0t9745cp1pzZx/AeOovqs=;
	b=wSJaB0i4t/4x9DgQcH8HAQQ0G6Pnav9jZPqF2FtwNv1F9+1eZszN5j2P+tDkkTPpg/2H
	 Ng4uUTgbgf8Dqt8xXIOd9MYQab9BFy4WANvo2TzdDKCybrjBnOJWI42Y1rpoFJWU4gm8G
	 9kERfGvjMYDKKlYfYNjIQkl6bQGE6qjG1WV9cFc1d0dgeUY8rNQ4qjSpxAvdd1EAkMg9z
	 LPT4MXw/4bj1puCfIHKYSpDwxZcOFq1uJuLveNnkNpShzpB5eSZQYbNj14erYiU/txfOp
	 6oK1Wy++9C3/GG6JCn8r8vLW/nQpg6ZrD0VKdhQN9Bx3XyHnvkp0SL6/IMb+qapUjzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=LjO5eu6e;
	arc=none smtp.remote-ip=209.85.214.179
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D6F606A31A
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 06:18:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63D6F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=LjO5eu6e
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e987a2ba0cso3624865ad.3
        for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 23:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792736339; x=1793341139; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LbXFF+YYPbJMTbGG7xPR1k0t9745cp1pzZx/AeOovqs=;
        b=LjO5eu6eFd4JRbTBDNbah+vqLj79aFamgOUREZvAqS4z0NcEBsszW+mvhoAIiWPFiC
         7LA0lB/eCONnVdyoAUswdpztASu7HFJXNITj7/2Rt55IKxOFbAyPbdqS67FYNKiQnjju
         sAkyrZ0WR/sKoS1qYbkjchhQGXjw8f1utoV845VHhG8N3Kvkls2BblWpI0ocZVnd83xW
         eQAQ8jbMm8lDry2484SFEUwR+f/ZieK1trm3uFfhjidJkaX1gIfSyBOlCr8Dfh2cNLpo
         5EbM4C139RgbaNxnsHQPx8sWGgSza6ynVVLX+rMRfApjib1l9MXTMdfba1HoY3lEnK8e
         +7eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792736339; x=1793341139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LbXFF+YYPbJMTbGG7xPR1k0t9745cp1pzZx/AeOovqs=;
        b=vpzAGgS2OKKmvuqv7t3XKuf8RpEMzv2l8OLfRDpdvZ2TDIjWN5f48uRXVaoGyV4eyA
         04GxNNafi9i/umO7Pq1hMYPGWL+MuE8Q4yzG1kMld/G9BAqzfip07DVQZj3Fg0hHQZSR
         ss7OkFd3MqT9aYXApEhp433SStt1T/SokajuFBoh+8hhMnSdHOB20K02Z3hCmJdyUTbt
         F6z8d8CzgPOMDSnI05Utj+LF/Qgu9+UptJIfen/ftpkHWxRCqFWn56T80S0hqgrljaap
         St5iDL4HpYF/Q6t4P4d2sbQDxJnj6lVeT410grjv/KsJFnx35kwceFEhXZmGKn9Bj23P
         RyPA==
X-Gm-Message-State: AFq9FYKHIdk5TWjK3oB6MfoM4jRQoEWjZQjlennscmdk9eZNBVj8xFPi
	hfuPaRHEfBffGkT9G/ZnEvYcPHE4xmTMgyLAgoCsCuBW1PhgdX2I/nZ14Gk5ah2ZB/Lng1FMne2
	zgSFtQwQ=
X-Gm-Gg: AYBFou3s03f1AURCWbICV1WqmLS4I9Nm6PnpZHLQhfY0wXfY5QyXJdfOpm6tYaYYyZW
	rdFQw72xFSzeFzhjPn7PpjVAqdgBOyiXNNRqGGvl3XFU8JMzgqAOQ5el3eqU7ilslUTeA58jCfg
	eSNeHcqfwhNxqgfaw6TaAYN6eXiZ/aiupLPBDkNHpQNkdz5rg6ytQ/fR0jW6uKXkUieArWwYOuj
	plzz0a5Gv13Lz5DEIBLCOrPQRbGvvphVo4vpywREwl6mVVl7hY+GUL8unQ/I+JP8hJ4HskXyGOY
	9hbHwyuAT+05Kz19imhpqVzyCh3sDeYF0vYy3XR5MJY9f7BeQCuN0uOah77J1MA8Qd0fm48gkeZ
	kB+hx4nhRNInyeDVQ/OPD0DbMC/gJYuLGETBHJ9e9tDmGzswka5ZhrXWBAacOTsiUctYzj3tbvd
	XrobQkQ8IWqzKBeE+nop6bCnv/pMYO+jhxopJEJdXmMQ2A2TgCQxLBZ3GN7PWKzlvZ8H+ha8145
	qhfTuw+fCbNU5nlAXBsMjACKLawCOKgJXbngDdLeqAV5+LF5PcXfHlkjA6R
X-Received: by 2002:a17:90b:1cce:b0:3ac:8897:7ba5 with SMTP id 98e67ed59e1d1-3adce7cab40mr1063716a91.59.1792736338547;
        Thu, 22 Oct 2026 23:18:58 -0700 (PDT)
Received: from localhost ([106.38.226.105])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adcb1b134csm2028310a91.8.2026.10.22.23.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 23:18:58 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	riteshh@linux.ibm.com
Subject: [PATCH v2 1/6] ext4: move extent mapping error handling out of the loop
Date: Fri, 23 Oct 2026 14:18:46 +0800
Message-Id: <20261023061851.45579-2-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261023061851.45579-1-sunjunchao@bytedance.com>
References: <20261023061851.45579-1-sunjunchao@bytedance.com>
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

Move the error handling for mpage_map_one_extent() failures after the
mapping loop in mpage_map_and_submit_extent(). Keep buffer-processing
errors on the existing update_disksize path and preserve progress
tracking and return values.

This prepares for reusing partial-folio submission when buffer processing
fails. No functional change.

Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 fs/ext4/inode.c | 83 +++++++++++++++++++++++++------------------------
 1 file changed, 43 insertions(+), 40 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6ede3644a738..de6fe4f0117c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2599,46 +2599,8 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 	io_end_vec->offset = EXT4_LBLK_TO_B(inode, map->m_lblk);
 	do {
 		err = mpage_map_one_extent(handle, mpd);
-		if (err < 0) {
-			struct super_block *sb = inode->i_sb;
-
-			if (ext4_emergency_state(sb))
-				goto invalidate_dirty_pages;
-			/*
-			 * Let the uper layers retry transient errors.
-			 * In the case of ENOSPC, if ext4_count_free_blocks()
-			 * is non-zero, a commit should free up blocks.
-			 */
-			if ((err == -ENOMEM) || (err == -EAGAIN) ||
-			    (err == -ENOSPC && ext4_count_free_clusters(sb))) {
-				/*
-				 * We may have already allocated extents for
-				 * some bhs inside the folio, issue the
-				 * corresponding data to prevent stale data.
-				 */
-				if (progress) {
-					if (mpage_submit_partial_folio(mpd))
-						goto invalidate_dirty_pages;
-					goto update_disksize;
-				}
-				return err;
-			}
-			ext4_msg(sb, KERN_CRIT,
-				 "Delayed block allocation failed for "
-				 "inode %llu at logical offset %llu with"
-				 " max blocks %u with error %d",
-				 inode->i_ino,
-				 (unsigned long long)map->m_lblk,
-				 (unsigned)map->m_len, -err);
-			ext4_msg(sb, KERN_CRIT,
-				 "This should not happen!! Data will "
-				 "be lost\n");
-			if (err == -ENOSPC)
-				ext4_print_free_blocks(inode);
-		invalidate_dirty_pages:
-			*give_up_on_write = true;
-			return err;
-		}
+		if (err < 0)
+			break;
 		progress = 1;
 		/*
 		 * Update buffer state, submit mapped pages, and get us new
@@ -2649,6 +2611,47 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 			goto update_disksize;
 	} while (map->m_len);
 
+	if (err < 0) {
+		struct super_block *sb = inode->i_sb;
+
+		if (ext4_emergency_state(sb))
+			goto invalidate_dirty_pages;
+		/*
+		 * Let the uper layers retry transient errors.
+		 * In the case of ENOSPC, if ext4_count_free_blocks()
+		 * is non-zero, a commit should free up blocks.
+		 */
+		if ((err == -ENOMEM) || (err == -EAGAIN) ||
+		    (err == -ENOSPC && ext4_count_free_clusters(sb))) {
+			/*
+			 * We may have already allocated extents for
+			 * some bhs inside the folio, issue the
+			 * corresponding data to prevent stale data.
+			 */
+			if (progress) {
+				if (mpage_submit_partial_folio(mpd))
+					goto invalidate_dirty_pages;
+				goto update_disksize;
+			}
+			return err;
+		}
+		ext4_msg(sb, KERN_CRIT,
+			 "Delayed block allocation failed for "
+			 "inode %llu at logical offset %llu with"
+			 " max blocks %u with error %d",
+			 inode->i_ino,
+			 (unsigned long long)map->m_lblk,
+			 (unsigned)map->m_len, -err);
+		ext4_msg(sb, KERN_CRIT,
+			 "This should not happen!! Data will "
+			 "be lost\n");
+		if (err == -ENOSPC)
+			ext4_print_free_blocks(inode);
+invalidate_dirty_pages:
+		*give_up_on_write = true;
+		return err;
+	}
+
 update_disksize:
 	/*
 	 * Update on-disk size after IO is submitted.  Races with
-- 
2.39.5

