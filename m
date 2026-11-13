Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794554647;
	b=I06LjfmEGv6vu7Us9mqw7l/u5mkv4tfU3E9Xp7rGARDaxIc3UkJU+b0QEWIKPhOwFWP7
	 BpK0+Oh18D4juRPu2Mjm8Vm9eTpy+9LFE0i7qLGkzabp93Xs/LWKK0lxCjPxJzjZ81icn
	 Sokhp73VDrj8DHpKgWsiIReL+Qdoy41nxbxLJsCXADXniIg9xZpecbnYTLznhq1L+B3eS
	 sfkNk0qiYkptUhLacfzLHMT5t7q67QfIcMaYiZWUYKuC4xwV3ZXj3YmsnnWEcsHhkbWMk
	 FXyQyATOc/ggXKUlgaPmk7u7/4j8qaQnngIH9EOikfnlzz9nic0yk3LYTmu8eqdvfZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794554647;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Ubp+QOZxy2Sbd4dvR9FrfKfCqHsUN6/njiZ6VuP+Alg=;
	b=vU/X7BUepyKzLNocYXWRfYzG4sAM2DqGjtr7a8gZ4u1jTfKZqnL7UkaEAlzzVIsgEdIN
	 D0jQMn2q2+uvyPRlPTLVDoS/L+hU9y+FVoSB8zZJb02JOpqYJqFuxHnlVdPFSHkZ+52Vw
	 DCowNBU4ClOV2Ugx8kWimGUoQ+jG1BezTzQrKwWFpZjXhexI+UTol+Q1RH/5v7EDSSNPq
	 9Ne4O6UEcY1MijdowRUgBaMugKc1a5Ze7mwrHkXncFT4DlXCNVbMg7bf9vGn1fnydeuRy
	 0FH3B0GADfbceiMOBcFykuOH9jPGiBoNTi0nTk3uvpbu03CpzkDGQSmO+ci/EmCEGCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aWJ9BB6E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1B9606A31C
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 07:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aWJ9BB6E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB37E1F000C4;
	Fri, 13 Nov 2026 07:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794554647;
	bh=Ubp+QOZxy2Sbd4dvR9FrfKfCqHsUN6/njiZ6VuP+Alg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aWJ9BB6E084G9fdmKRzs6VqNwEfpeJI0mxQol2AH/fi9hYtJ9QcyrjpXduaHObKi4
	 b+YbPc3CJcP2x0c0sXgOOp86pQr7yi4XhQIk52YXrBvAvmiLapmpc6aWYS3GZ6ZFEH
	 d7GbkG+Sk9jTwyX30l1j04TuHkw6h+MTc4s9GF1gpbgSmKYzontv2PSVzxJC/ym9j4
	 3ZW3xMB93OMiJ0v9sauSWJqL3Fof7aCfa5aFy3s+52rYTuHHy943vXRmGB4D5R8Zzs
	 3LjiCp1Dj990OoczSHRjuzvWYhsxyv0gurrkgp/ypDsha6CF44ctx59k2NESg5ORNz
	 AnNbZECzq1aLQ==
Message-ID: <sashiko-outbox-212340@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 5/8] blk-crypto: refuse dma-buf bios in the
 fallback path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mengmeng Zhao" <mengmeng.zhao@linux.dev>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261113070621.273953-6-mengmeng.zhao@linux.dev>
References: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
 <20261113070621.273953-6-mengmeng.zhao@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 07:24:06 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
>=20
> The inline encryption fallback encrypts through the data pages of a bio,
> which a dma-buf bio does not have: its vec pointer holds the
> driver-private dma_buf_io_map.  A crypt context the device supports
> natively is programmed from the request instead, so refuse only where
> the fallback is about to run.
>=20
> blk_mq_submit_bio() is too late for this: submit_bio_noacct() has already
> rejected a context the device does not support natively, while submitters
> reach the fallback before the bio is queued.  No in-tree submitter builds
> such a bio today.
>=20
> Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
> Signed-off-by: Li Wang <liwang@kylinos.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113070621.2739=
53-1-mengmeng.zhao@linux.dev?part=3D5

