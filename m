Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECC63D891B;
	Fri, 26 Jun 2026 07:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782457783; cv=none; b=Yu1gjL+6Ws70w1LlktUvtw2h+7l0iSS2/pR0+QeYTvNyudrxchE3cvOD4DnHGdy3WYHJ4WsYw9/mgJk6DK3WT76fXXWjwYqk2wMaHPrnKJQpf3h5lUejSmsu2kh9VzmVk32mX+ggtMkOeV5okRiQguPzhvO6VLy2e86pyATJB5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782457783; c=relaxed/simple;
	bh=H0rIl8IMroax6WrZL4md7RY9Ay+Hp5SuVhxcFaXxkcQ=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=jLlD6h8u+FQaCLKU3VZ+tVzEKUQ2dtK+C0rngLLuYZR+i/GZmRfiT2++d0TzGdRMkdknKvtAsmOq+Hy5dYABlPqUT9F+hq/zu6kudthl9bFg2dYCUMoh9i4W/Af8tDtUHxOF6nmu2J6K42oKCX+fR5w5+jwLKEbqcQusAyUH7zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=Q4uD/o4j; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="Q4uD/o4j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1782457771; bh=H0rIl8IMroax6WrZL4md7RY9Ay+Hp5SuVhxcFaXxkcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q4uD/o4j0PZj6eT4cS3gNY94ZMMslIIMKjyGlM+M0l8x/qLMKZgMvTnA0s0VB8RWx
	 iaF7mbRwVgVm+hg0gnSgHNVoE7pnDPPMKBxx/zZSQy1v1jdPK2DZP5vVPk0PB0xZ2z
	 0maVXWXVWUxiVrIYehLKvI3likQgtYjBK9Sw+pAY=
Received: from June.localdomain ([123.121.145.35])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 21586E06; Fri, 26 Jun 2026 15:08:21 +0800
X-QQ-mid: xmsmtpt1782457701tpq07hp1i
Message-ID: <tencent_E1AD8BE1AA3FE434224010902B7526A0BC09@qq.com>
X-QQ-XMAILINFO: MiFcTO7j4Hd/Xgi7YcbabokbXn9GjppQ2RnQR43i//0mq+NZIZK51I7PnjSnHC
	 LIFBA60+NkhD0AbOhwf5N2Xb8UQSY9RrFEnqkEyzGDNafKKc7tWyI0XT97ga4qiofSpJGoFUJtWY
	 ZqyQqGado9juaw8kVYXof3gTWy+pIQdukJzkUdjCgczmJcclkPC0RpuUeYNO1LWzIoUZwMdFfr6p
	 q9oWDfAG5erWFksyZZO65r3hZIQvQT6V75uZ8wmXe6P8HkeUihedmhBSRV1itgzlM9U+jXXeNfOI
	 7R/78D5SKaxiJQ7gSma7qoOTkiFiy3wHnpNCIF3tleX5A3FDAkuQK4pgCOtsnd2My54SQbWP4pjp
	 Lg/VXC184RbZ12a73UoJCOtVu+budkE2JyuiED4FvUFw0Lnc1SGtLsNboRw37CLBJQVE7hDl8hs4
	 kYVoRFz3kTrfDX3fQgKBUTrlQAXbB3HqcP/k7Lf5aG6ezTolGFIxstThIy/j0xz501/vFevW2Egm
	 +x0cJGyS5TYkbcIB/QbxNMtE2jPnpclYTcZptY1HFds68s9c4joEgrtrM2n1KCxdTgld8Lil4D1I
	 1XUTO0+o6cNGdPLd54BcM33NtaMUBocQXClv1JcGaBaqmwYISDDWT2XoKFiLM3XTYwvlVNh6XxJX
	 CKT55KtZfz1uFqQW+qJ1aRwpjgIq6DtSomWzYcgPmILQAhRnRKK/3RCoROfMgHR43bHAfmtnFwo4
	 spCKWaQQ1p5rlHgMEXTZimxX4fxwD4q9dZe4qqt5VUCs4gLnrmsdwxLz1BhearwcnUEyVkJvGDXT
	 WbkbDObX6EurS7YjUTFolf/Ham3kQ/VnL0Fj/TedhOUVBp2L6tE8T7QeslVtUjXUvn5y2Ougw3g+
	 eJ1hJOGN4vFnT2zK7I+rwFSmU8bT3cE+ffcdTeNHSyjdB6dYJxa2uD8N2JQ21Q+Idad4ME73iGrr
	 89U7Blb5Jt+do5BwAbmJQmEhhz7jScQSilgcnSGwlXmO4YfT3DI8Nf75/O/DkW+i7SpspuOJnxNH
	 UOpSUq9A8fEDhDowhK4OC+KsiKnHaqrXV1GG4bOlnLZztg6OSkRpRIVt4TDLfRK5HqHJmzylQggK
	 ivd88gZ2LCT3LYBI75b44TYJRVGRkabKqMdgH7
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
From: Wang Jun <1742789905@qq.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	libaokun1@huawei.com,
	25125332@bjtu.edu.cn
Subject: Re: [PATCH] ext4: fix crash when ext4_ext_insert_extent() returns error
Date: Fri, 26 Jun 2026 15:08:21 +0800
X-OQ-MSGID: <20260626070821.15979-1-1742789905@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <2026062643-tamer-limes-a320@gregkh>
References: <2026062643-tamer-limes-a320@gregkh>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This patch fixes a NULL/error pointer dereference issue that I triggered
and verified on the v6.6.142 kernel using syzkaller.

Based on this, I believe this fix should be backported to the **v6.6.y**
stable kernel series.

For other currently supported stable series (e.g., v6.1.y, v5.15.y,
v5.10.y, etc.), I have not yet verified if they contain the same
vulnerable code path. It would be prudent to check and potentially
backport the fix there as well, if applicable.

Please let me know if you need any further information or testing.

Thanks,
Wang Jun

