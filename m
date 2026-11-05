Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793887251;
	b=2jkpck5XPoBfIVOBzBxiJ/MjgsAL/w6kQGsqu9EQXhjRbkShcInxVKSvEwzdaBRXNJxy
	 b+lbOk0K4OQVi/8dlkjV5xw+CFeIYmqyEA8o6fBDydBQeL+iLl6Q6yucrcEJK7xTq79op
	 0rhqM1kgobyKvII1ywQJTPTYT/kaFPpMCZnl2pJNr0R3O7fB8U1Uyb4+ot8m+pWeE8645
	 hyLodl8/UWAm35haY49gA7V7ms7QWKE5juyAflL3s02IqqnDL4mclt1PjUhl3AfFosMtY
	 ZKdUxKG2VQTttX27RlyoOCZ0zesWBtHsagdTz8IlyI4vmkAyourm66RKnMXO8GqMZ6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793887251;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer;
	bh=s074/WGaEZodvb8MrBC/plqFT0cVs1hNQbBNRgLS+7A=;
	b=tMeOxRaRMBjHfqT9HPFu9cohT3nnCP9lrIhPQIH7dH6ZMRP3OqwgCiDKfEtKsvXjCwLO
	 JTlEIhE3Vbnug+VTZRPdqN8Zdngjgn/KoJ2F+zlDyagVAG4U2qR/vA93ApvPSFrNGuRxy
	 TtjJXf9+Zau5zOawPWvXhbgA19foN13NYa1v9R0H+42H2lr73AwZQ0Vm1Gqq2Xe5GvRkN
	 vLcEWxW1e2kLbdzBI/RFwP6Vf5p68KvarQAuKI+t+Y5f4OEIug98iCD03wGPyyIVWK2c2
	 8OVgbkpW+rNo7Nug6v3xIDk+KKGHhO89oh1upjjyftcCeqPUiiiwGqnwqUKD8ZneDhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nxY9Jccf;
	arc=none smtp.remote-ip=74.125.224.50
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52BE606A326
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 14:00:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A52BE606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nxY9Jccf
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-677d35fd1d2so2160319d50.1
        for <linux-ext4@vger.kernel.org>; Thu, 05 Nov 2026 06:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793887249; x=1794492049; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=s074/WGaEZodvb8MrBC/plqFT0cVs1hNQbBNRgLS+7A=;
        b=nxY9JccfHr/AUQr5sZcoBDbdnqV2s5ymUY6k8leyIxTDI+P2/s3U/f4FtFBr5zEDy+
         hhjwvuWVVISEoxcC68qQC9W8qMSVsOw7dtqwzjGWKP1Gzo7O6+7mZxMJsZHzbB/KqlPK
         zKfSTNpzdR9y9YriGZWXguMcQFhPSbpcFILwe0zICxAFLuCt0qL2h+DubEOyPkJSLRrY
         gns4wXEEpBO/ooPpmQ7DbrOPDTh4PdF05cIZ3lQ+Q3X43+pUJRb+XZbu1g8jp62beAtU
         y4DOzWRswBA7uA4nO1VgbMWIA0KFVApSoQ0kgcP7XJwvF0W7e6IkM4IJBwvRQOvEIWVK
         88CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793887249; x=1794492049;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=s074/WGaEZodvb8MrBC/plqFT0cVs1hNQbBNRgLS+7A=;
        b=H0unZ/Qh2BS6EuVEiuCeUpjMq74L5xvKS6b1dra/oFuwyrSgK+aMwOPEBtGWnuEtxQ
         SgWSzuBFIV5785c8t0IZvDKNn8aIQ5wVSvujnqWFYoZMrx19JvZnF86zp41yHlZ5zBud
         1q5S0U3HSuQ7qgKYvGIBPGdZFbbDdxmt0QJykSXj37e2jfTPEMU2eL3UkexYa1p0vDiX
         5w+lb0LCK+GZe7s6iaRhvSJL8rLGjt/TZ+otA4hhButiPVCsFVmpJQ80lAMAWBSzwwKf
         8neac7HM1mHrGTC4nTQ3+81jY1f/sRy3OoRdLjotYq0wp/6eV+XB2JUR5LNAjUOTtzeW
         K5bQ==
X-Gm-Message-State: APuU4Z9L+KL4ONmL+AQ7O2pA/Wlg1gzrbra0GoeR4V/xrWridEzaVOUK
	pE0VZ2MXc6UEl/p3/ZY7acRsTgqtz47Il0fGzwl8OjY33X4eKcLol1Jo
X-Gm-Gg: AYBFou1s0TFw+VQhyGwDUYG4w2hYS1TcTU0kU2yPsYQSqNLDcv2H9XJHw3A3+FL9JGi
	rpJL7bEQ/7SNG0638CGnpmAeFGw4CRQpApOqFpZ12YMdOURVoD9eNrbqcsA7B7VF4oYvlvQAll/
	9p3gvQNMxFcikf/ou99ObPYMQWRH1cJpYgZGgMTPMP1c5C21KnQslMrnhi3UXebuo0lSBPVQuZz
	FI6yfWW7uQ9KPQUIYdhpdtqE1/cTBBkoMb55wW+DLaxgzqWHAfp81J6eeqZyRobNELjXPoPONzO
	UEYCA7PUq/g80NPcWr3aW5NgzKfrlENbeCdRAcueXmTYeQm7tWoqe4ZX1JU+yPbnR3AW/j9NKyz
	oxDTeN17pUR01oU/uytBHR/FjcXcpt6JqIcjP+V512CXBiivI8nQ5Psf2pUnbqtEd6nwh4gKiiZ
	kYEXdjBr2JQ7RoXaIuDpLrMzayZ3alfCgHSWRc6dFTTLzJANWwxhY9ifT/7ujlYXbjjBYedqUcK
	9LuGSjtNOZxSZC15MIFTSKqzVFzycel9xAQY4zBI1qMKXy1wBzIwQhjiuQPh0K+dblTujqpYh0n
	Jq8pHcapxczxQAan/Co1HrKL5OvCRAkSYHULM3hlQGYb5NW9seKi57jj37m/R/gDsefMp4QTyhK
	HPak9bM8C+MJcBN1UluguqLHHFMK2n0aNXdmYRuqrboswQEAT7NIBi9xQ6425
X-Received: by 2002:a05:690e:d86:b0:679:bec4:aef with SMTP id 956f58d0204a3-67ba4fa93dcmr9290626d50.32.1793887249206;
        Thu, 05 Nov 2026 06:00:49 -0800 (PST)
Received: from lab01.myowncloud.network ([2601:cb:4000:1c5:5396:7ba1:d08a:ebca])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67bee202a69sm3492991d50.5.2026.11.05.06.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 06:00:45 -0800 (PST)
From: Amit Patole <amit.patole@gmail.com>
Date: Thu, 05 Nov 2026 09:00:36 -0500
Subject: [PATCH] jbd2: document the h_invalid handle flag
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-kdoc-jbd2-h_invalid-v1-1-4bc224f7d0a2@gmail.com>
X-B4-Tracking: v=1; b=H4sIAASM7GoC/yXMQQqDMBBA0avIrDuQBKrVq0gRkxnraImSqBTEu
 5vq8i3+3yFyEI5QZTsE3iTK5BP0IwPXt/7DKJQMRplca/XEkSaHgyWDfSN+a79C+DJlQaTyTpc
 KUjkH7uR3Xev37bjagd3yX8FxnIQaoEB3AAAA
X-Change-ID: 20261105-kdoc-jbd2-h_invalid-8297dd06f190
To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, 
 Andreas Dilger <adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Amit Patole <amit.patole@gmail.com>
X-Mailer: b4 0.15.2

Commit 61e2a90a910c ("ext4: enable scoped NOFS when starting a handle
in nojournal mode") added the h_invalid bit to struct
jbd2_journal_handle but did not add it to the kernel-doc comment above
the structure, so kernel-doc now warns:

  include/linux/jbd2.h:523 struct member 'h_invalid' not described in
  'jbd2_journal_handle'

Describe the new flag. It is set by ext4_get_nojournal() on a handle
that is not attached to any journal and is tested by
ext4_handle_valid().

The warning was found by running scripts/kernel-doc over the headers
pulled into the htmldocs build. An AI coding assistant (Claude Opus
5.5) was used to locate the warning and draft this change; it was
verified with scripts/kernel-doc (no warnings left) and checkpatch.

Fixes: 61e2a90a910c ("ext4: enable scoped NOFS when starting a handle in nojournal mode")
Signed-off-by: Amit Patole <amit.patole@gmail.com>
---
Comment-only change. Built with W=1 on x86_64 (fs/jbd2/, fs/ext4/)
with no new warnings.
---
 include/linux/jbd2.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index e3886963ba00..69f12366a09a 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -482,6 +482,7 @@ struct jbd2_revoke_table_s;
  * @h_sync: Flag for sync-on-close.
  * @h_reserved: Flag for handle for reserved credits.
  * @h_aborted: Flag indicating fatal error on handle.
+ * @h_invalid: Flag for a handle not attached to a journal (ext4 nojournal mode).
  * @h_type: For handle statistics.
  * @h_line_no: For handle statistics.
  * @h_start_jiffies: Handle Start time.

---
base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
change-id: 20261105-kdoc-jbd2-h_invalid-8297dd06f190

Best regards,
--  
Amit Patole <amit.patole@gmail.com>

