Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793644234;
	b=EgXQd1hu93lznrboIS6dh1fv69QjKBWRFi7zFuYvVgL6WREVKe5Bga9mqiZ4Kiqerl2a
	 M5pj4OYcL2a5eABzWb2aXDyYbSDskgtVD1beoDyEg28pkjkB06rqZ/yx8JOn3pMu2Jwt8
	 fqWBEsi/BOOayeZeDWz47i5cj/QcIIb+m2kYELA5QnC2WBgQ7EbLvD5EO4TH5otlulioN
	 ZYDB1SHU17dqoCFkwa/a6/5pdCNvk5RC0ogQesOGg1jGWVWS8ksuR3YmrkP/hor60XvB2
	 OD7zcUj9kTlmcMmACFV4z0nJeE79QU81BJ096SbqrrvtUgJ8gixPXiyBQK3iPZj3x9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793644234;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mFMQCUeyYYYhZz1jcLFllQ3nwPZg46coJSMsmGX9osg=;
	b=tMLDRKo/Q1vonRsq1PLgPtOWkaQa6B2f/FUGQ7OeILFBKzoZQI4f6yqnSKkP8JxAmNbW
	 vz+KoovWm90ge7ZJuNYiWs0e8+M/8/m7YPjnPEHwAjAcH7+ayDUyeSdcwR5hCxOowYsiG
	 fsMqDv0o8Z0a7cX2OnXq2QRaxs17haTPS6H/LnfZ0rfs9qllcSd2okQJDzHXIn75G8+FY
	 vNm5Yvb5uzw20IRMTbmD7Ie8Ga/qsTuFtDze1amvkPcCBcQAemfePeepKO+A3jiDPMDox
	 qupsg03gZIwRsSCQLAor+A1RTmpQ/og71kd4bD+lM6oCsKVMXUk7x7nDjaxyXGy1T9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O6g20EQy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A19D606A324
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 18:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O6g20EQy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D136E1F00A16;
	Mon,  2 Nov 2026 18:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793644234;
	bh=mFMQCUeyYYYhZz1jcLFllQ3nwPZg46coJSMsmGX9osg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O6g20EQyVsj5+wq9VDk9whRyzdYPdHstv4InukdHZgyO2B/fdKjje8tRjXkaiTh0F
	 H3okSRTqI2+Q4rAoH1gSLAJ0CNVpIm2F3nRSjBuUbOZ0a+Gtk5FpxZbOoADel/WRWE
	 HyVYC1SEJERDL9NNABa5Lp7mojXtyGv01B44QdtGfwoSzL2YxC//O680oKU77Is/s7
	 R46mqRwzS8IbbxTzlPjYkFrvd/rtt8pWbx16FPM6xh3HPbgOY9cuxe9IA28e4fZm7E
	 /s85+qOShAXITVoU7xhkEdYkJTd1y1Wt6ay+s7HnfyvGoqsxWjSOSCv+jVunBO2W8b
	 t6FQW5NMWop1A==
Message-ID: <sashiko-outbox-193944@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/8] ext4: add tracing for i_conv_pending_ios tracking
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ojaswin Mujoo" <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261102-ext4-endio-zero-bug-v1-3-266d2bb9e6dc@linux.ibm.com>
References: <20261102-ext4-endio-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com>
 <20261102-ext4-endio-zero-bug-v1-3-266d2bb9e6dc@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 18:30:33 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add tracing to track changes to i_conv_pending_ios count.
>=20
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-ext4-endio=
-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com?part=3D3

