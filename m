Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794811674;
	b=jvPWtuU1WDzuTJ0mLFGIwdRzHSSCHeiJWDX2AjoyCS4Q48vlKAXHY1WxobOpLmWyQ0ze
	 pKv3n+wD42BsuSwexb4NBRpEY0+jARn1ll6FqRMB45sG9VewuCE5oDx3hLY8utPyJSG5t
	 7os25p/LPDM5k4hXqos5saS818y4YCCQoPdyPHHTqmM5xA0nlXO3cOv/ctGs+KHJIU5P8
	 8/UkLS2OFwesA7evz7Gk+KvHn4lZa2PUcnkjJi8Bx3cVXxNHE5kSjEzKyPcLSfsIE3N/P
	 8otgivrDyVezhXSLKDvJY2Y2mwX1Aej5wnXEc1s3XbgaeW3CTojdCr1T03ulppu6WiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794811674;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1xMijYxEq2DY42+gfrgrYfxYgWe0jA8VIyoiqLP2xVo=;
	b=FMW4yJfzUnvGSF0lYziyeyFrDajqYUfkkKlf4K3kVvoxuX2MVfwu8DGLIx2dQ3CNpgN/
	 rSxa+Qy2UhPM7v96kzWHPuiQlx3U6BQ64W5J+kvTj2K7kwRd9HaQf44QanLKTJrdGrPkk
	 5FTk5PPg0TJXEAj5SW4nOOFRnPrdkAU9ZKVofkewQum9VCqgVaM72eWTo2swIPnPNKgXU
	 7gznjXV0ciqOcRlwxwmvq/3+GMr3aTcftVSfJzJUjDJdUUHLK3eGmbaH5NgayJip6XmmR
	 VaaT7CVVZjPJdwZ76Nbg8xk6md1fts/qNSVNhDzPvrZG3Sq20UoMYyJZbJ+EW0INZzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=GzZ7YPHo;
	arc=none smtp.remote-ip=209.85.215.180
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BC5606A33A
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 06:47:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02BC5606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=GzZ7YPHo
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cddac941ed1so1373584a12.2
        for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2026 22:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794811673; x=1795416473; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1xMijYxEq2DY42+gfrgrYfxYgWe0jA8VIyoiqLP2xVo=;
        b=GzZ7YPHoPJwiEq77cUWOFAFNHwimuZWlqnFCyZugpe/FX6nS71j4oUZSAB1iRR+l0g
         9pBvONrVloINn0qwaXugC4i1iQu4vRoDECsqokJ6BQa5+AZ3UlxLvxDCGKn2e0JhLTHI
         p/xJV9oHA0aCeGzXoYZIQn95MsMFXb9bIGuI8mFBMghn0JKHWAdsF6677viyfv7WCMlk
         fU0zrPmgHjuPJfycphuzL+LELUDwx9JY3T35Kp+7SdSWngWCwpnxRVj2TSixw+gWhkU+
         4EWRunkcjshmptZ5RRxcr4nJw5osi/eu/8hsCcttH9pQkQYd1GWn1snPy9qy9GRT8kTA
         XjIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794811673; x=1795416473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1xMijYxEq2DY42+gfrgrYfxYgWe0jA8VIyoiqLP2xVo=;
        b=sUb6O0s+3BSiqFBFcfdzJ/sk5V3sO7XiC0aqBQwa1R7fLCo5hVmCqX3ewDj+AEyMgG
         +BWkXq0Tx7MF/aczg7Wmam86E5Kot3PZTX+RGINXIJqGIuCa8+ODCXKuVKIkWqmBxDpx
         lVn8gM/hf4RojHI3GbDbeIbgs3vQOykCy8zW3HNCjfKFe0ICrOPj4tv7BKSQ1w/T/Kxp
         1C/46PHuiwF0ci/x891vlJgonLeB7zEVlCeGFJh1IenQdZMVvNiUVqgvo0IXof0ASuUk
         9EY0Hw0nLQTDBDCOexxNG7tGhbXBBlezL0hkeh2/MmqIo+blyZd0TAUJWGHm+o+6Un9q
         K1mg==
X-Gm-Message-State: APuU4Z9bmLmQXs5dMg9zThZfoCtzZFAy0n9I/SmwHVvUHZduyh4khxgG
	/dsUtxknHjD4wy3mXurSGqZpjZgIij5j7/5T0O1AYhsQ+Wld/rK2USikzQgnh+KKYCV5lcx3/9V
	3NBBw0G4=
X-Gm-Gg: AYBFou3Q7YQ0lF0g27VgQK11DOpM0Oi4tH5e2Nc6cQJN5dTowy3s+buWYdoXqC3AgkM
	yMszjSkMzjhpvh4hyxJ/psOtmf7djmcYfmtZXkmk3pzqz63pgvnfroFLPed7NKsc02LylkgeUh+
	+NuJxZbQCuTQF9zg9k2aJbY/WQHGousa3kB+uRjz4EkBdn8AUr7yn5bN6LTFRTnUmW69ZHRNYVr
	/lw0wdDUYc20szrR+w4yi2nN6g+sThS4ZUIrO+IMJopzyMAth1Bgp1jrtG1owf9p7KOrV09eYzd
	5+zW/4VjOlqXbv2cNvk+JzSrc41422YKhRZ4Ozaw1KJDxjk9Vjaiz8onLHt4BQr8E78rlf98Oii
	+Eu/UIudX1M20HIR+JKevS9qTDT2/Jl4avdlFPnrBWUtaP1gWCxsYyq3+DS+ccqR8y8urg2aTjD
	hN0uLsSNGqgSl/m0+O0MaHSiXHqR5jDmiI0D4FpyjyIqY9AU6ELIz9DqfnFBODgfSxCEI4li/aq
	hrpJ8aINpt4VAU6gVZpEzRX1cs6ugwFLpVE43FyOoggHUgqth6r6NuFY6j0Fg+KyRW9WMXqEl4O
	buYg4rp92SDhGmU5TBMys/lspSV5dVRpUB/eKE19z1mHINX1tE0+OalK
X-Received: by 2002:a05:6300:8095:b0:3e0:da23:874a with SMTP id adf61e73a8af0-3f7a75bfd52mr6847823637.18.1794811673236;
        Sun, 15 Nov 2026 22:47:53 -0800 (PST)
Received: from localhost ([116.132.239.159])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cddc186fc81sm3863213a12.8.2026.11.15.22.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 22:47:52 -0800 (PST)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-ext4@vger.kernel.org
Cc: yi.zhang@huaweicloud.com,
	jack@suse.cz,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	ojaswin@linux.ibm.com,
	riteshh@linux.ibm.com
Subject: [PATCH v3 2/3] ext4: submit mapped buffers after fatal mapping errors
Date: Mon, 16 Nov 2026 14:47:48 +0800
Message-Id: <20261116064749.194146-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261116064404.189911-1-sunjunchao@bytedance.com>
References: <20261116064404.189911-1-sunjunchao@bytedance.com>
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

When the block size is smaller than the folio size, mapping an earlier
extent in a folio can succeed before mapping a later extent fails.
mpage_map_and_submit_extent() submits the mapped buffers after retryable
mapping errors, but discards them along with the rest of the folio after
fatal errors. Mapped buffers are also left unsubmitted if allocating an
io_end_vec for a later extent fails.

Besides losing dirty data that could still be submitted, this can expose
stale data with dioread_nolock: the mapped ranges remain in io_end's
unwritten conversion list and can be converted without their data having
been submitted.

A failure to map a later extent does not invalidate the mappings already
established for earlier buffers. Submit those buffers after a fatal
mapping error when the filesystem is not in an emergency state. Also
submit them if allocating an io_end_vec for a later extent fails.

Buffers still needing mapping remain dirty for a later writeback attempt.
Preserve their extent status entries and delayed allocation reservations,
and invalidate only the unused folios after the partially submitted folio
on fatal errors. If a later attempt encounters a fatal mapping error
before making progress, the existing invalidation path can discard the
folio.

Suggested-by: Zhang Yi <yi.zhang@huaweicloud.com>
Fixes: c8cc88163f40 ("ext4: Add support for blocksize < pagesize in dioread_nolock")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 fs/ext4/inode.c |   43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6dad9eea7824..ff33ae870b35 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2600,6 +2600,7 @@
 	int progress = 0;
 	ext4_io_end_t *io_end = mpd->io_submit.io_end;
 	struct ext4_io_end_vec *io_end_vec;
+	bool fatal = false;
 
 	io_end_vec = ext4_alloc_io_end_vec(io_end);
 	if (IS_ERR(io_end_vec))
@@ -2610,8 +2611,10 @@
 		if (err < 0) {
 			struct super_block *sb = inode->i_sb;
 
-			if (ext4_emergency_state(sb))
-				goto invalidate_dirty_pages;
+			if (ext4_emergency_state(sb)) {
+				*give_up_on_write = true;
+				return err;
+			}
 			/*
 			 * Let the uper layers retry transient errors.
 			 * In the case of ENOSPC, if ext4_count_free_blocks()
@@ -2619,18 +2622,7 @@
 			 */
 			if ((err == -ENOMEM) || (err == -EAGAIN) ||
 			    (err == -ENOSPC && ext4_count_free_clusters(sb))) {
-				/*
-				 * We may have already allocated extents for
-				 * some bhs inside the folio, issue the
-				 * corresponding data to prevent stale data.
-				 */
-				if (progress) {
-					if (mpage_submit_partial_folio(mpd,
-								       release_start))
-						goto invalidate_dirty_pages;
-					goto update_disksize;
-				}
-				return err;
+				break;
 			}
 			ext4_msg(sb, KERN_CRIT,
 				 "Delayed block allocation failed for "
@@ -2644,9 +2636,8 @@
 				 "be lost\n");
 			if (err == -ENOSPC)
 				ext4_print_free_blocks(inode);
-		invalidate_dirty_pages:
-			*give_up_on_write = true;
-			return err;
+			fatal = true;
+			break;
 		}
 		progress = 1;
 		/*
@@ -2655,10 +2646,24 @@
 		 */
 		err = mpage_map_and_submit_buffers(mpd);
 		if (err < 0)
-			goto update_disksize;
+			break;
 	} while (map->m_len);
 
-update_disksize:
+	if (err < 0) {
+		/*
+		 * We may have already allocated extents for some bhs inside
+		 * the folio, issue the corresponding data to prevent stale
+		 * data.
+		 */
+		if (progress && mpage_submit_partial_folio(mpd, release_start))
+			fatal = true;
+
+		if (fatal)
+			*give_up_on_write = true;
+		if (!progress)
+			return err;
+	}
+
 	/*
 	 * Update on-disk size after IO is submitted.  Races with
 	 * truncate are avoided by checking i_size under i_data_sem.
-- 
2.39.5
