Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9270386C22
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 15:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512330; cv=none; b=XfqQr7hNPLWBK4XkRAtOgeki3ucxyzx1TLfox0SKT908MjMH+xusa6iPX2wCaZTXG7+pnYhvH0I0qq9+TV+s/rZVuP0rZAaawBQ/wdtzDZRyEAwmK3Uj52Hce4o8TrgVAwwkzHfnvP/3+py3A/NJ/RufFMqY1QkVvY3CA+z0uIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512330; c=relaxed/simple;
	bh=mMwmh8CunMxX79/11+cozJ4+J2RN0zZKe8Q4zjY9iCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHolEh6E2LnXLZ7cOVcs4qZB3C4d4wTlIihgi31asSfE1dcoQZVu+HjG7YW/wCWR0xEF2PnWnbWC2L4GiophYbyqk0MJuYxZ+CYkBpaynU857JIclfSf4VOsLgu7aKXsJCIXc0QuGF644kG08IYgXQzKMg+ZZaomqM3/w6rR9Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T0gEeBDv; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T0gEeBDv"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-472326ca506so830672f8f.2
        for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 08:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785512327; x=1786117127; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wFueboZLPWAkgNDj6HQNTjnIe1s16kAVfyJgzcPKDFk=;
        b=T0gEeBDvDL01mquRyYMhnxB/FcKmZnyk5K0mj9Zzjuvg9f850I88TdK+sFn1UICJTI
         9LvWR0UEu3VouuPg9ppP8b+cmHRFJx+dgKDI59v/ST8IB3MNy7Fh2o/K3Ycm+8qgExYE
         81depDrxO60kfl6sfUq7t9rB/trQxP/bIz7gP7A81R7OZMMGZlib6rPwBTHyQdgM68fh
         36oKm+9F7KPUZ5/DMDderyMjEE4br3iKyDw30DswLCCdAb2jfVoNTsI5plN2u5IMDLN9
         HXVWfonHmH/JFVY4MB4JIby69LRBuqIusK999RYHU9sCvPfrteJxed7lbEvdLX7EWklN
         k+6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785512327; x=1786117127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wFueboZLPWAkgNDj6HQNTjnIe1s16kAVfyJgzcPKDFk=;
        b=QcPxU1prKEPU2Oc9Sirtpln9uiewmDHr36Xeiv0yPW+wVBuyz8dS6T/3VQXUYJgOCD
         xt7IfL/kdfBDIFWsGQUBeH1xtQiw5sLwsiAGIwFKicvsyiRvgYmGc4oIXi7/uhaL+w9+
         /UVEPMFoVs7YxFxLJZLVIqdr8JDxnvd7hyZPnbq77Vh/h6J2iK2ZdwbggjgTDXomMEsl
         Vrpp/LSr1NN5r4I5nl5VSHE+pfjfytt7dC3sSn2X7BhJ7qMgMV5NtabZoTlXsXTAaijr
         5v7cOj1vq6WebCo7OxcIBGCcJ36k+rKHiUpX10p2eXZVaXXP7ujx8Y/yrg/0a1dEYDBE
         Z3YA==
X-Gm-Message-State: AOJu0YxgNbpGPBhnCAJUoePG+tVRq3QpKjMEMDueyhpTWXbs1KmMzEQH
	Hg+tMhFmoaDXxN52h0/Wqflau1Mj1vCkSusRbokQZsl4dXL5jmqqI0hCGxBaO1pO
X-Gm-Gg: AR+sD11iwwU7959pzILOU9Ld9qqyV49brwQcw+J940CCwbVvgCgDrgP4ZuW28a6zg89
	fhYo6UVweQ9wWlmikBGUZA+GGL9ucSXogYINl8iEhkh+pHR26V7JKfqc5NR+gKHt9K3nee7lZzn
	KOlaNDzrUZ6ntbGCJ2A60cuRq2jli+ZmGzSva2FRwCb9UX0GwMY+a/VHzNZSL5dLzfH/X02TEdH
	ECq/P/xBYiJvBdCnJxSODOi3tvl811ivHxi3ldX/is3SM7+PHUIFESUnhly4dafvVEJO73VfGK8
	lXgKlSN39u9MUoXw2IVi7YTV9FGWR4P80bvcCg7p2/z3dYZuNHpr1yQwQxjNCB28c97Zuai6N1r
	T7R6oz2dXNg2+nXIqK7ZzDWedaEuBKhq9J+bOjdmWlxz85U7sFr3Mnd6sR+8HWlysH2YNP821LZ
	9YsD85rHUV2wiad993GKVAYM0sjtpXE5qgRlxC4JbkGmPMJBXsZzg7VvoEOK7+SK8T/ZfA1VqEV
	h/mFfPBzqoBcu1C/FgZ
X-Received: by 2002:a5d:59c8:0:b0:47f:9404:5185 with SMTP id ffacd0b85a97d-47fd72c78ebmr229874f8f.24.1785512326978;
        Fri, 31 Jul 2026 08:38:46 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd41cfde0sm5098345f8f.3.2026.07.31.08.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:38:46 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	xiaowu.417@qq.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v10 01/11] ext4: validate count against limit in ext4_dx_csum_verify/_set
Date: Fri, 31 Jul 2026 11:37:35 -0400
Message-ID: <20260731153753.28309-2-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260731153753.28309-1-ablagodarenko@thelustrecollective.com>
References: <20260731153753.28309-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dx_countlimit's count field was read from disk and used directly to
compute the checksummed range (count_offset + count * sizeof(dx_entry))
without ever being checked against limit -- only limit itself was
bounds-checked against the block size. A corrupted or maliciously
crafted filesystem image that sets count to a large value (e.g. 65535)
makes ext4_chksum() read far past the end of the directory block
buffer, hitting adjacent slab objects.

Reported-by: xiaowu.417@qq.com
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 fs/ext4/namei.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index cc49ae04a6f6..a283e285937a 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -477,6 +477,10 @@ static int ext4_dx_csum_verify(struct inode *inode,
 		warn_no_space_for_csum(inode);
 		return 0;
 	}
+	if (count > limit) {
+		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+		return 0;
+	}
 	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
 
 	if (t->dt_checksum != ext4_dx_csum(inode, dirent, count_offset,
@@ -506,6 +510,10 @@ static void ext4_dx_csum_set(struct inode *inode, struct ext4_dir_entry *dirent)
 		warn_no_space_for_csum(inode);
 		return;
 	}
+	if (count > limit) {
+		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+		return;
+	}
 	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
 
 	t->dt_checksum = ext4_dx_csum(inode, dirent, count_offset, count, t);
-- 
2.43.7

