Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795676912;
	b=pqXVdMkUneC8BGfnNkuAd7fSMh9VkvsIfuhETkC9BHQhLJ/hw4PnLKz+ruYDyRXYGQyz
	 6KYIB0Rr0rpxAJzoXu4t52CecwXcSkf/+YQNPXYZpiMs3WFVy6ocLAnWfvgqNbe1djUYs
	 Qd+COlzi4QuFO8zbWcZHw72C7DC4oj/0G8RE+O6yrOMT14Axnp7KLftpL1v1UVWbEgOYR
	 5lIazrJ/YIa/eJqBZpEZe2yvXHf4hXqa5nXF3tJadJrgDIPcvt4P3pRZWtzVA3Iqbp3/l
	 F7lc86VBEeTKXy89I6XSky3WT7LbKoPmVUwoDGw5tf1tnmPxw8GUe3SXmO2JKHejFjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795676912;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MhXRZswgd+U0p/ly0mQ5E1v8PAV92b0lht4ULwHSrRA=;
	b=ODggoxuP0iEPw0K6z9R2d6KtfCMTZg/ybtL9YxWN3rqtQrg4zR+R8zyTbDVorVGlzW8i
	 HNvyrdLWGdxXijv7+8RwwpBken2ksdPH9OdLZloVSShQfKVELxhEhCvwWXerxzgDvqs4S
	 th/aM+cjt5Ge+gdLaYi709CU9JfSDyTUUoQWVhhdlnvnjxgGWraamFsYavPUPjKeBJJU7
	 HHCd7akbvGalzfZOMTZ51GvAn0NENANiYyCV8Ut9MXpj59Cf+RZCUoiFT1Vwhiqyb1Cm2
	 uIXHmbk4vTrNHx9GTgrEHrej72zLx4xBut6NJgxcARfhDmDgY7CTYVFhhYAa+G88AhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z29TyGwS;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2520B606A31E
	for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2026 07:08:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2520B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z29TyGwS
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb9d8e8e90so37642055e9.3
        for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 23:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795676910; x=1796281710; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MhXRZswgd+U0p/ly0mQ5E1v8PAV92b0lht4ULwHSrRA=;
        b=z29TyGwSSWP62Y1nUFqF7ClnFbHIgdsGk0TLzLWtId9e8RFLYn3yD+zJYHB1fRm0JV
         Hx6BVI/6Eu2G89I0iP/Me+OY20byQDnWeiZCA1mMHPrfC+L6n4anMe9slkLF2qFrLRb9
         JdH2NmmZTBKB6lxRtpkkc23kBKPO88OoOmjr6Pny0XQSs0QidFNETLlgzEzQsaEWLK0F
         gcY/EoiUgF7SzDK/kelp/hYp2iOL4LSwi9Jio+S7IDfonveRJHKcQhgt0lWgoWezTNV7
         cm4k1jntyMGGVm1JrI238LBKsLCYeK6JJa2PVnvCu+p1zfpNasz5vu0Bx9FFFKEoBaZv
         2yoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795676910; x=1796281710;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MhXRZswgd+U0p/ly0mQ5E1v8PAV92b0lht4ULwHSrRA=;
        b=U3LuN75gP3I6bj5DDITXSdB/2QVWUqc8A9LXAuS69pHSqOduMrrXKGm/G+u7C8lLKg
         yo/L2TnQZwGKom8jSDEEafyiTAuDV2DiS06q8bPz4XDN0eu8L2OfTvdHPo5ydO6uR+bq
         e5BxyzQ/Ci8X7c2hQ7Jh5GFRP6TAs750xYpPst6pDX544l1xClJ5oS3KsuwB+XPNKAKb
         eR6BwTT7vEW+Ko0GHEJ0WtLNm5W8dr5qokBNHhbaADwai+mTr2BJbHFxgs89ArLFXHjO
         DaIs1gAoIzdb0v/OMK1NJlzAFW9aqDjD83LPi/i6Y2j/icuVFvB1p6Wyds5qYofuBJWA
         MdNg==
X-Forwarded-Encrypted: i=1; AL+hErH/+JcZSKhx4u0HbqKfZDncirI//lMz8JVOjrD4y24EB3mOeT6ls/FoDF/ymk4ONy7473oA6KWW8o+Z@vger.kernel.org
X-Gm-Message-State: APuU4Z8ijMZs9UgJmr8TMdx/MDJTyIXl5T7beNEKZwjVsBltFF2p4tgN
	gLedXK7UBoNyVo9rjYa0eXUwqHhLP2hyrbrE1vPTvxbNVZO9g7j+7boH
X-Gm-Gg: AZFdTZfFupfGsZBRHEYQaBXtX0e8q2yxos/RAiHFC5RGAKqbUDxh1mKbWeLKhkiE3hg
	AHuCrifvV69dx10lySkWgy19jux0EQEmck6oEfq8d8svkJ6U6xMcbx2plBQC+o2iplISrCr/a4X
	c3jLRdaDdo1LGIeyDdMQx5GPF5BqsSwuWZd6SbUwAIP2q/qMrWSG2x7/jI7RhePsFn06Lew/6ep
	UcxgelGRCckeuvVhgom01i8HRKNrf9NiKocEcPnw2GEeE6hbPfjLW4r8Lt8olW5pCwVKDxDTjhu
	oRWQxfiic5p6+sjBEWtXBK69Q9+gsxq7gOdxzWC7MG0Wd0Exc8IYwG+xtD2da+iHewMU0Lil8C2
	fNBGonUH7V6fVtrVSSz+H1ZEhH7Us+AlSbHVl0qFsaT2HT9TFQTjZqqvXxFKRdV7evl9L4zcmNU
	B8iFAHsiBjCLpQT5khjoB4zt89dr6ZJeW6+bKXBzUimUG1rntyk1WbcA+ns/lZKsKFFt03hNnyt
	cYRRxTl+TjR9NOkmBU4wEn9Irp/PkDQX0DzYVe/Dzb+4FAiB+SOO3gFd5v91yTfiArFko3HnAV6
	iDylwt4YW9PFdsTIy5v4e19sOGKUYFUNd4nBNmZ3+G/Ajtm6EhY=
X-Received: by 2002:a05:600c:3555:b0:4a1:f377:5c68 with SMTP id 5b1f17b1804b1-4bb8881da76mr402294455e9.34.1795676910365;
        Wed, 25 Nov 2026 23:08:30 -0800 (PST)
Received: from DESKTOP-V28CTA4.dbs.corp ([110.93.227.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b09bsm1071077895e9.4.2026.11.25.23.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 23:08:28 -0800 (PST)
From: Arbab Haider <arbabhaider649@gmail.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	yebin10@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/5] ext4: re-check inline data under filemap_invalidate_lock in swap_inode_boot_loader
Date: Thu, 26 Nov 2026 12:07:48 +0500
Message-ID: <20261126070748.272109-6-arbabhaider649@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261126070748.272109-2-arbabhaider649@gmail.com>
References: <20261126070748.272109-2-arbabhaider649@gmail.com>
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

swap_inode_boot_loader() checks ext4_has_inline_data(inode) while holding
only i_rwsem (via lock_two_nondirectories()), before acquiring
filemap_invalidate_lock(inode->i_mapping).

A concurrent ext4_page_mkwrite() -> ext4_convert_inline_data_nolock()
(which holds filemap_invalidate_lock_shared, not i_rwsem) transiently
clears EXT4_INODE_INLINE_DATA before ext4_map_blocks().  If
swap_inode_boot_loader() observes !ext4_has_inline_data(inode), waits on
filemap_invalidate_lock(), and ext4_convert_inline_data_nolock() then
rolls back via ext4_restore_inline_data() on -ENOSPC,
swap_inode_boot_loader() proceeds to swap_inode_data() on the still-inline
inode.  Because EXT4_INLINE_DATA_FL is not in EXT4_FL_SHOULD_SWAP, this
swaps raw inline data in ei->i_data with EXT4_BOOT_LOADER_INO's extent
header and corrupts both inodes on disk.

Re-check ext4_has_inline_data(inode) after acquiring
filemap_invalidate_lock(inode->i_mapping).

Signed-off-by: Arbab Haider <arbabhaider649@gmail.com>
---
 fs/ext4/ioctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 83630cd40..e0c53d62d 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -419,6 +419,10 @@ static long swap_inode_boot_loader(struct super_block *sb,
 	}
 
 	filemap_invalidate_lock(inode->i_mapping);
+	if (ext4_has_inline_data(inode)) {
+		err = -EINVAL;
+		goto err_out;
+	}
 	err = filemap_write_and_wait(inode->i_mapping);
 	if (err)
 		goto err_out;
-- 
2.53.0

