Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792680771;
	b=mjo0AJhzHT5m3Ig98PbaSkzEeJvSOoby3UD9nFewy6TzHK4hnYKZZ7zgzYvQ8dxxHcC8
	 phs8dWWgtt1supKh7f+SPHw6kCMrUyKA6F6InV5JUrfEqLKef/hAEqAe38dVBk3PJwY62
	 mHApzjDkB4vbh1TbS1w2MxO3g+myfXM78L4Nr8N6bQxQ45Th1JLOpnTvFi1NayS36rg6a
	 fY/0ry+yyB2NncMc9m2z4keiyCETiMa041SwKPX/5kVw0g9A3DAyRiB20hpxiJvG3sgQ/
	 jLK7ujCq7WYc7aJRAEOqZPyRlrG/aVv9jmzyjnJCh421Tph962RyrqIsMmUFy6zHNxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792680771;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SCaogKi71PFtUSWXRjd3cOixXULyWR6y4CuVMAWg7j4=;
	b=ugaQGcmS6Gpni/LXJkyQim+S5Dezb5DyEAzQnojvP/SGdWKcJUqBGpyPylBILH2X4UzS
	 9ZLJvmMY9WPVNAHAtgz03Z30U6W3694oU3gKaZXn7ExKFiZXsooKEworDhv7B1VsoIDye
	 /ashrdFQ3aa6TR/XT0oz+ELu+BCohXuNhvdmv2cOLZYK1flhdMML0O5/9oCmCBHQ8TWoC
	 6rJtFAAQ1+maKyUBPs3YXjtRv7uW0EcjYuwCQ4dGGiXeXhFOdBOMNIYDk910ENce/HrRm
	 pCt4LyT5tFEGjMJjiqAZtAz7pZnIG2A26XcP7loErXn13sTgqgAOOHz41rymrjmHSow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=DWDfdxos;
	arc=none smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17358606A31A
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 14:52:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17358606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=DWDfdxos
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8a06b436dffso827388b3a.3
        for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 07:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792680770; x=1793285570; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SCaogKi71PFtUSWXRjd3cOixXULyWR6y4CuVMAWg7j4=;
        b=DWDfdxosaLRWdCfQamEqowbdvCEILimBpiNWRYpYtvhL/+26TK5bOoRdjCC6zWHl3n
         TVza+utdSCoe/T61ogKhwihj70Q8u7XM0Cca5TFRlAKjmg7Q3aAIVcF9SRDHe6pUJ48/
         +YOWnUoLkVYOWOkIWypIiO7Rm+IwGeibwFgBCcKP4Bfh5hPPk/U3ZbMe9gVIWGWs9k1O
         bUQ0vYnTfqc75CIMwKhFNj91RisV3tFirZer7DRqeFXtprbAhm4ejIwtr1qb3FnyKTRZ
         nzwFG8Mn616JYYQ+X0Zb3yyizng+16JytdU13103v9E3ksQCFK2TPmZrPKVS5d80Zne+
         FN6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792680770; x=1793285570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SCaogKi71PFtUSWXRjd3cOixXULyWR6y4CuVMAWg7j4=;
        b=JQJ6+54VGUAxHuCXkJWBzN+5nlNeXRU2Bj8RSNi3NyY55g3hvy7DM5k71Wwb5h0W6e
         xcpojWH2Kquw42pMlK2cTflPuPKrZsaRxTPjuuw+fod2tAkaLlrZLHK+IjAD0siTpaH7
         3NCLd8LItdP6GRTiotldjtWrM2fyybM9MUUIDxGmafKy8tWY6nUJZwVRwOo+UezkH83/
         aHelQU0GQScB7uCz99IYqkZ7U+AvUS+ug10FkoaWJVvI0Vs9pgz4L7prMCDhUhXSk6eP
         aQBtN3R9ZJub6F+9LANXEsJalxyBnoqfzSod1wCXWh+8c9o4tu+jHlAGgnUxkfGiipm4
         JFkg==
X-Gm-Message-State: AFq9FYJO6femxyXdODJ80ifxQINyyROvApWTlCNG/9foBdzKi9xbZqTp
	/sLfEYveNDjg05D2afhnc8jCBgkbWmUn3nkrGKB6Kq6JBePyTTZQjwgUnmo+ziu2s+XlPt8P9ou
	01GNY7v8=
X-Gm-Gg: AYBFou27FBeA6r0ottXZt0LRfjyPaJ2dmYI7G7BmPkmAvByau5/HOgrAeBFpSw9AlQH
	/Fu5K3YOyynG6BuoJtk8oW72pfn4G5Mm+i2R7EVlNl/A3I5epj+/B2JE4E+J+EPsfL0sgcszls2
	bnHDrEyuvT9yz9LWoubWNSgC+a4Sbpl2+uvV3A/7/SHMH1TXZEuY75yhKUT+zsinM4vWRyQ1XKj
	/TqKxTWb8312oQRjWO/PeoRdy4DHCCO3mcWA2lYFvGVlIe9BgindZud05HrnNiDMpufmqjCkp8L
	RH3FaORqaeDYhmu1hEjt0EylzSpIibaMI4hpm2CWzKOHbJTekj/QHnnHWZw0lD3v2wUdhvdlKFv
	wGmhb2b0T6/OqnkHYScsTUKauSN9GyVnHRQHS6n0JTwVuBDSr/dSjxSxd04as21AJvpGfrhHMd3
	QhZvVBGiguL7l3E5FoIPiXGweM/7NjFA+rexWXvlznqXkndhA1etY+LL5BSHit1JwxKpoquU05p
	4arNpEwVbNOTQdtRWnhj7E/NqTxlNBubtuEDLI/hhU7yQAJAw3qZJjqMhp8sSJ68PvsYFKLxvSD
	UxkLHA==
X-Received: by 2002:a05:6a00:3698:b0:8a0:6414:a54c with SMTP id d2e1a72fcca58-8a089e3fddfmr4280965b3a.32.1792680770224;
        Thu, 22 Oct 2026 07:52:50 -0700 (PDT)
Received: from localhost ([106.38.226.229])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0895db551sm2381881b3a.34.2026.10.22.07.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:52:49 -0700 (PDT)
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
Subject: [PATCH 1/6] ext4: move extent mapping error handling out of the loop
Date: Thu, 22 Oct 2026 22:52:36 +0800
Message-Id: <20261022145241.2950379-2-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261022145241.2950379-1-sunjunchao@bytedance.com>
References: <20261022145241.2950379-1-sunjunchao@bytedance.com>
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
index 9a9ec02dce9f..bacead801709 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2467,46 +2467,8 @@ static int mpage_map_and_submit_extent(handle_t *handle,
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
@@ -2517,6 +2479,47 @@ static int mpage_map_and_submit_extent(handle_t *handle,
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

