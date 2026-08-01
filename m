Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA4726E173
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 18:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785607996; cv=none; b=BuSY9ZlaA4etXzTUOxHqPNnNwzZPRSXYpRWQ1VDm8vwqJjpYVz+5G91l/KOqm/tNQB4heBfVo6+fqJko96Qz0GU9MnP42ZAtAHVOmVsMs4rKLl1RXd9hzn9SXVbK4HQqJnmGg3Rv3bSRXW7nZivXn7itPdkG5SJFUBzrcdzJmEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785607996; c=relaxed/simple;
	bh=mMwmh8CunMxX79/11+cozJ4+J2RN0zZKe8Q4zjY9iCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8IiHAiJRn0pTEIH72qvaUrTcrYNPiIMaqvShbW0kt5jNiGa95Q3MPAbx20mhBS2n16t9xW2tXt5pU4BCADj4vBd8EmMGuEcf8doQ+KtJqoJv9geJLJXKv78t6BPYG3PT7+TC6lQhuH470ifW3Kq0Qh+O7vHWHBFRfmTLfSjA+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BrGulAZA; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BrGulAZA"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4954d29264cso3857795e9.2
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 11:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785607993; x=1786212793; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wFueboZLPWAkgNDj6HQNTjnIe1s16kAVfyJgzcPKDFk=;
        b=BrGulAZA8kZ57N9MABaCZeuf+xTyuOjZOc8L1R5jqcKTu0BUevHNMflu6htXvlxjiG
         QMuqsM7tL7yRCKbmfKWC9qUmzPfPBMQwtyIdkXq1xHD74BZ/N643nm7ejehH1qtNvJaz
         kFEEg4FXj6Jl6wMegCeJ6jElv+fcrwNho6bGv5nTEjZkSLYvO4i9tZW43+XRaJHLgBhr
         3uc0LX+a74tiuTPtMMHBOiyDdPxDcoSEqHDJrfZo9L/01Js+u4V+6wzEeztyvx3pgnqZ
         mO3lfh6lxemZdG9d9zU5KryNoV7np55/30lgcF2k0hw9gXGt/IAKy5zkGSvaLPPHZ+m1
         sayA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785607993; x=1786212793;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wFueboZLPWAkgNDj6HQNTjnIe1s16kAVfyJgzcPKDFk=;
        b=XiRMLD2WsngN1C2nqbR4L9ywwZw/pz9OZY9XeQDoloLUuSLLopcvaeM/OQlO1jGLHf
         87zPpxXsJr31NQABcGPx5mJb28Qoa/FCgpXFmqCJtCwbdEfuwvpji/G/fSvNEv26IkKL
         Sy2pGuM09VhyXALOGU52rhD23F+AIaaKfptN+vcJy44uwS8uWG52QnO4+XMTTtS1qm8J
         t2gd7pVXJRzuBaU7wCrjqXbMDWG6V+GQEwHyjkH6I5UFipCVSXWkPcArkx3feMTVSeqh
         AWajVTVPgCN1CPjelV4mc0xvOsJFKJz5cHgURwKEToMS02pasFVwKTf1E65tyHqEK/wg
         MbzA==
X-Gm-Message-State: AOJu0YyghK3tS+ZwZROYlUvpxnUQs2/WBkx82oNn4J4/luLo1e1YYkmf
	cEN5ARfIFhcNp3XeTv8JFt+AoeCOZf7LqugYvNoZtWx/6pYymLkzIMGc7bxHlJHa
X-Gm-Gg: AR+sD10kqsxsAyOvGcTq1W/FesM4CeH/SnLV+i/GFZ5W8PqFoSgch6Ll5sUiZGsX3PJ
	34OryNq7QRrDt74azMW+CHdiya3bvLiHjz2IPecuIY+Z1x3TN0Ex4nOBBWTVSzRRj8/4661/LHG
	FQT1BQ0GOkBOLHZqnsWNYbGJIVDnh3KAqG51rVEoHbl/W9nUXlu5uopxrk7axgwVthMSn9peFJf
	T+mKXF5PlOV3YZz3RGImmfPkgeIQHLchBTq2uUbpfoQbvMllzaiH29fOPsGl9AhY8FUUGrU/3Ti
	HGJoEggy5FourqhCcM/6JvoxxjPl7zpjQqYKnFFKgLXbPNalhZnxcVTUa8Q7eYFFfoR4HeLNNj5
	ivUV4Jwq+m2rPCtaOkHWGqBHPTcIQHv6Qbrs57YodO9pIDJ/nGY8uNu1ZpXESle8TVKZywdzdNv
	Qh8r0QQbXH3Tz3NV8Cld6xLlQ3r9OGxLimOQKqVQrbBbJF/OLsfYGoOkOHCLfE9dI78oJuu+ogr
	I2LxbmcKqTr6Eb6Z49ew20J1mXzMTw=
X-Received: by 2002:a05:6000:1a87:b0:47a:b86f:3ed1 with SMTP id ffacd0b85a97d-47fd72c6dacmr8657868f8f.21.1785607993310;
        Sat, 01 Aug 2026 11:13:13 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd458adc9sm18819761f8f.27.2026.08.01.11.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 11:13:12 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	xiaowu.417@qq.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v12 01/11] ext4: validate count against limit in ext4_dx_csum_verify/_set
Date: Sat,  1 Aug 2026 14:12:15 -0400
Message-ID: <20260801181227.5198-2-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260801181227.5198-1-ablagodarenko@thelustrecollective.com>
References: <20260801181227.5198-1-ablagodarenko@thelustrecollective.com>
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

