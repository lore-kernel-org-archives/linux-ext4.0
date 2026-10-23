Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792736356;
	b=azFDkIzLJgLnnT93Yv+jIFMUTALzLbzPebfyZWD3ra4YgjIh3qpG286mLmfncFiCRQGY
	 nPF+ws0U2AHfrczJR+S6ysMyhZ4GMLEawF1f4w0vpOw6twF+Ut49reW8Dvsnh8//R6U17
	 Lk1xKSOAipoJwtisdn7OUMtYwvbkU35VXcPUhcUhyipt6koABIAQoBSDoTyTUIQtN7aAp
	 g6V/s8fZdDyHAHf0xl9P8cTn06EltvWKNdtdGlxN7QcJpO3Fm7WH+yGjEsWv1mQVT3gHg
	 j/U+D3DIf8XWjjhE8i36hu9uPn47wblRHxJclTdonfc1hHyFsO2Qhq3EN1Vmq1ngOEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792736356;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qVDmG0M9omOHvh5ZlCyXuU68Ah5lRgEuatajeAjqqJc=;
	b=hPIQJND3a2ysPVInLVwjMZaUApZZN9mdUN8NzF5/swgKJp9CcsF7rWuyo1GavfOgoGW/
	 ly+IJwhBUU1d7XO/yWDiQY5rPjV9ocEhAJlcUnnCTkPNuExd9AHGtJfA4uwCjikST/wBd
	 jqybZLuo+IJcPJy/U5Vie2G7rntzmLmWpcS8XH77BliG0ZzmBDC2hlcRbkVhiiev8AjzW
	 +frIB7O8bf5LOnEYcthfPPLnxcv6GKaVDkury+3IgtHnqJAaO37ZU6jyjkHVxtCvV4Xzk
	 Rf/9i/3SuXWOtqy+xhgkdck0zQaqGmEh9hR17Ho7cQKByqn6jfkY+DmvVsDqiOJ8COQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=khXYniWB;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5340C606A31A
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 06:19:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5340C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=khXYniWB
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3ab98332238so300724a91.3
        for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 23:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792736354; x=1793341154; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qVDmG0M9omOHvh5ZlCyXuU68Ah5lRgEuatajeAjqqJc=;
        b=khXYniWBMqleeWVNSpvFZM49na+DlbULH3cQs0N4id5Jg/9nyVnyr+omlIZBrfFz3+
         aZt8WYapbnamHjiFgz3ne6pNu/9F5Wqhq7lzT3+NhoCRE2lkkVH3PzyPTod820toQVdz
         Lil5FdU8c4bGghdRiWS04bByZJf3Sx9ufVT5oznzdnXIFa0kfYlKp/KH2ek5okvgy0X8
         To2Z6NJjUBDg0HUbZczyMvWjN62nHxsP2wPm/pzBhXm0HfqXK0PWDnU4aDVZpvSIHAMn
         K9ZC/E87VQnJDMcYK1a3mmVFf1Qd582jEbbOXefQ9D6As0E4g1TeCKX00ab0HLoFTajb
         8iJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792736354; x=1793341154;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qVDmG0M9omOHvh5ZlCyXuU68Ah5lRgEuatajeAjqqJc=;
        b=hjMBbhN8/gDaPftpCGG8pvc+T11ouDN7zJLENN+S7odg8bM7eQsLo/ZxrXJKKtUn50
         63E/70gH6O03MPzQUktQQ79c3YiDEyyryCE7aez2xAh2gLEBW3QJgGMTmhuiDkHbs5hf
         BSYN5oV7OOmhqaJ4jOF+TGQ5QCuGl7Tlcm/nSBoFTIjFPvFVqY/EmFAFLIipgJTS6Vf+
         IRTMdhYph5yWqbnK09CfEMQALh7kH/OBqomnKqLZ4nOkrUZYNU7ZB638RPIo07BlAFvy
         8bz284CUBX/v0pYBw48DlMuFNBKPnXHuyhP6WLCdywapRBtEXY56G/6Vub1nrLHDXyks
         X42w==
X-Gm-Message-State: AFq9FYIA6XRUUC0YS8RtOt7flxtg05OhHP3a909NUU5xRYKzwbrrlnJS
	QpoRAME7/s/BA4bGNRLU5oYbXuExDDK3W7crl596KJFMKM7OtXNNMRwmMNnN1kkAshATdieOy2J
	l6x8hYCQ=
X-Gm-Gg: AYBFou3+VUMQwtEhSYEJv/oC1qZyPM8mJtrUaOpOJRUdZ1RhEAX36R0Yfirom+Tyqxh
	0GAI8cQyFmKidVP7CijG+QuAYvkSZt5PpNyNiT/wwxOLy5NbOLoGh6p/WOxggIi7mqCkyybF8AK
	7wlh2tfsQQ8Yp+I/AzGOs7ZfPsxsOL7z4ur73hlFUuNnlWbnSt9t19q2Qzl9RC4F8ToY107jLU+
	Tml/GnkgR3ucsA6S5r2xjZKiH9vwH4LyY7NT2gpzO8A2EMUAkLFIhbpduHkmn/BkuEtzbyee8wF
	beQqjbQf4QqcANWrUCjMMJ0rayewDduUwIatHMwrRfkkmNkQR6fKAgyn7QIkBTdLcZ+8khFFPQc
	dwwTgfSDlJyVDRe8lH4q+W+kZwxwu77xf1m/Hs6Kh5IyCTItrLVS2gQRMky9A8pdxzB3lqRbllX
	eZcgctIrTNd7PcoQRuS+oDxb8hwSaMzyCs8zE4V2DKhq5XftBNkAbIhD2QwMQku1iQh3c6KbyvR
	ydeANSMF9hpCcx0wE1jzDaYhrddL7Tpj63IKEgffIg7W35ZpN2dLJVaB0g=
X-Received: by 2002:a17:90b:4a4b:b0:3aa:fdad:7d6c with SMTP id 98e67ed59e1d1-3adce1151fdmr954525a91.58.1792736354375;
        Thu, 22 Oct 2026 23:19:14 -0700 (PDT)
Received: from localhost ([106.38.226.67])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada47f8ff1sm7513291a91.0.2026.10.22.23.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 23:19:14 -0700 (PDT)
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
Subject: [PATCH v2 5/6] ext4: report unwritten extent conversion errors to fsync
Date: Fri, 23 Oct 2026 14:18:50 +0800
Message-Id: <20261023061851.45579-6-sunjunchao@bytedance.com>
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

Buffered writeback can complete data I/O successfully but fail to convert
unwritten extents, for example when allocating an extent path returns
ENOMEM. ext4_end_io_end() logs the failure and returns an error, but the
conversion worker discards that return value. As a result, fsync() can
report success while the extents remain unwritten and direct reads return
zeros instead of the data written.

Record the error in the inode mapping before ext4_release_io_end() ends
folio writeback. This lets fsync() observe the error after waiting for
writeback.

Fixes: b82e384c7bb9 ("ext4: optimize locking for end_io extent conversion")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 fs/ext4/page-io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 734d856a6d47..d409821fefa2 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -193,6 +193,10 @@ static int ext4_end_io_end(ext4_io_end_t *io_end)
 	} else {
 		ret = ext4_convert_unwritten_io_end_vec(handle, io_end);
 	}
+
+	if (ret < 0)
+		mapping_set_error(inode->i_mapping, ret);
+
 	if (ret < 0 && !ext4_emergency_state(sb) &&
 	    io_end->flag & EXT4_IO_END_UNWRITTEN) {
 		ext4_msg(sb, KERN_EMERG,
-- 
2.39.5

