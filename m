Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276830;
	b=VqRQyDFkd02hC8/aAc95aRYFC6a9hYOq1zggROPkgwg0Kq6UOEjp1DIAJmhyuMP2VnaF
	 koLolSWVNo2MX73rra7FLUI4dfsF8TWnw5tZzBV2kSz4DIzmkFslnD6HUyn6lnY+T61z0
	 ivGuUcApllKGZ3ZFgLgGffy55NPWwh5rOMWNIXJUiZB/jkTPtqgO5HtLzbiHmvDhVUqRt
	 grNuHx0hS4jmKePouvKfJIOZOenih8owdDijfNM2lnpLmkRL7LE5VpinI1hJ4OLa3L6YJ
	 Ue3SZ+/F7sugxk7Uc/r1O12IT7x7dhnB+N9gA5wEo3lANRTCyL8BkGEVAwN0cqkZYcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276830;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=awDACKIeVrogbGbYFqhsYXsdAMvnrSWHYCkAVzPosm8=;
	b=riFb10XFrGdulBB/e2JSh4gL87fAZqegRsFt2lf1MG0OllTiv09OpUJdpGE8vfwKJZ2N
	 LkR3xhU2N0sccNNxF1N1DyOOwrs20lMRGQBP+/U+3z+wWSORl5T5Wni6qTVXJ44kVxyeY
	 WZGHddDQH452tLOY2KMt4rbgpHfLF8ipVThChIXqBxWy1c6t12KNh5y4U7EAjrkVnaZXe
	 7whaqq6dyk1xLH9PSgOX8yelmxplPFP1srKebvu8B/ZfOOIgZRtwcehEAA6D8iWsvc61b
	 22k9WTLOIx4EkSYP3xJN4Ipnrwd5osxyyNL2Z3FnWBC43xl0WG435vE9HM5Tdx6PqSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z2Oh1poE;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8174C606A31D
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:27:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8174C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z2Oh1poE
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48df4e9d2d4so1225391f8f.3
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276829; x=1793881629; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=awDACKIeVrogbGbYFqhsYXsdAMvnrSWHYCkAVzPosm8=;
        b=z2Oh1poETGwoAjX6kWIA2+B57pXLsxH6yNWqL+ffWvnWTxUOc59KHWg8lo6RamesjP
         s62i9BYy0M71vmGlErV8fpdj/33XVloy7ZroFHg5yO6QSHvqp1IqPwET8Dfhj4D4M615
         WdQAuVrypWwFO9LiFEq60Oe8LNLuZwGMxJ/hcofk1Zatb9HCmOidGMKcmwlAWgDPUZdC
         PnNNwZ8Epvp5SFJipssO/eAUByWV1w4Bjmqrrxl0UHhBG0NoyI1kpycvGFUzYTcXAsmj
         P4GaklTk/8wfDoIrZy58DprUrC13gxBSDfDSV1nibP5A5kdIygHqOHv4Z2LokVCSmqPm
         VEkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276829; x=1793881629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=awDACKIeVrogbGbYFqhsYXsdAMvnrSWHYCkAVzPosm8=;
        b=CzRflNEtat70Mftlyx7yQpStcPXPActF4drl0ZmYbwac8lB8O7W6Hw02TiWcgCDT9D
         a8W3woL0CV0yXJtS+2j522g3vGb9IVibFdtVgi0bxWfI+sv4tE+pWILo03C3z5IIecUK
         NXcF6e9skXyOy7UD9WfqBYh33KmAHFMVV/W0TgZufQkcMFzn8CYlb4WxX0TyCFGLp8b2
         1DiTm691VoipD29ZckVdcYDOT3C7aomBY1UCKsUEkdiWXYuqW8TQzJnTdDtVlzkxQLUO
         FGbeIHPc5UdUSZJRjh/TTWCYiP+ixYYPHp9xHybwUkLKDC+V6m7Zvn+vVjWSKLqt7epk
         O61g==
X-Gm-Message-State: AFq9FYLsHIwxfOsIFW5agGa3CX+ReJF/XAyAWpQ42haIQNFYDNnDnW4G
	tbnXXqwPjXUS46C4ltCLWEsblSwKtKmGEY8fKU45j7ruarP87mcGmch12KwEDXce
X-Gm-Gg: AYBFou3BavDHyVVZtvnK64HQJIDAaebzab8twktAyZqplTIUlXNQcUSpfblAi4+BMHg
	y1lJvXejT6tj0sj5fFbOOEo4BHIBCqpBswOm8FLnXHR+BYcZmWkr1uL5/3+4anlBHRXg5qMn1y7
	Fz3kst4EIybJ4dWqHzW1QcQrPIrCaeQ4XwsPcs5ffMEDrzfYAwHHqriFLd8khe8vqyBtYM7zO/h
	gwv/GyeEy4i7bls5xAanaWoaV3LwE0GRsTjEwYWm6OtHhruJP77VEYGXWh+dZXEONhjmVZru4m4
	CPkODTo926vE8WSPaiPFaWfK47pUitZOv1Q6+/OvACE1+3pVHR7XxGs+sLNHSa9uI5dYZGu2hdS
	LKZB0fxdUME1FmJx5606QwGRwNXyWGhzKTVwXGvyFg/PPh5h82XcC6NkwvAm3bo29M+Lo5Pb9WR
	PscmxwLZZKOYAKxXWoDhkFJKYC2HBriIwunIMCTTgJky3b/chnalQ0emozo/evSsMHoYBUtyRp6
	fBradRaYPphHq1tGSFmGEqctLP8xSxkhv9e++opHB8loQCzzIQkNrwUDdebXJ7hIZwFatmw92R4
	e01hwuSVoiZ8lqHpLRKrBfG+uOXbrZIupIBsJm8Kh5W7RBAQEx+j8og+1zXJoahvZjUcyuJfxgY
	BZm6nGA==
X-Received: by 2002:a05:6000:46c8:b0:48b:10c8:2181 with SMTP id ffacd0b85a97d-48e5d597b40mr8860716f8f.27.1793276828824;
        Thu, 29 Oct 2026 05:27:08 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e412cc164sm32305679f8f.7.2026.10.29.05.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:27:08 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	xiaowu.417@qq.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v13 01/11] ext4: validate count against limit in ext4_dx_csum_verify/_set
Date: Thu, 29 Oct 2026 12:24:00 +0000
Message-ID: <20261029122413.230409-2-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
References: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
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
index 231a274b814e..76b9aa3fb03c 100644
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
2.52.0

