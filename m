Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794250737;
	b=1xGQGSRM067ZNw4DHsxVEbhmKpTg3Gqq9FlpfES0WWQnW+0AMzlbtLEuiSOKqAOAnNLj
	 XMDoRkRkaRNBk0qVNNLzvP2kp2C53m7mviqHlDqYwXzYlXrAlY2Ah5UqmeJh3aFjWGg1e
	 YzrKT07lNUWWIWiFdJKk4QPKRcugm/lcWFl0MclDIJFRZywSpFTRwjt9xrUIkvCmFED+2
	 vp8thJ0x3XS0e0OSxmFGbg1DrGGtNhcA0yVWCpXxNAtmjXpDqSUZQpTXua1eDxrhNi/fF
	 p857DjD0y3uDOFpvNJW0KLK4nZ4apVUgpp8bReHYKC86Ym+X2gRyum6Z9SIf4rpTM7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794250737;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=02noVvq8cjGPCyV+FXKLZFzXSuIZ5u2L646IxEq79HI=;
	b=iIReZuZhS4bOjh5pMNM2md/8hzZFzIg+Oi93ttplECU6qS7OWthhWdtZsykjnUzmy4Hm
	 NWET8VxTZrNO4JW/s/hn4YViHPIGDAsTjJmUKv5jSweKgTRkRovfXG9/OcVRXkc+hjj4l
	 HMnUKl7o5iOQQZ61/UmOGh6IV7Hf8oOU12t6BQY4vbxnmwxE1w1NNjKjqF3+ySjxEWS21
	 rSbCEponMzDcx4Y0DrkkzjdnyeCA0DqPMA8wFHZljQyE61FZXqvby4U9NIhFJJLIwOS5n
	 vqovQzqEkGdfuxNgKb0H1IKWyNpjrjsC9LrnsWEgHtAwi2whHNaxSPRFfuonISY6MpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GWT1EgrB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32961606A325
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2026 18:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GWT1EgrB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B31E1F008A2;
	Mon,  9 Nov 2026 18:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794250736;
	bh=02noVvq8cjGPCyV+FXKLZFzXSuIZ5u2L646IxEq79HI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GWT1EgrBze2GZZ3hb79CBOKlgOksKaU06QHr3tEEY59NL0jb5jM/L9E24iUFV4BW3
	 wK3x9FjMZtYvfzorGiXtccukr1CpEXdrVkPVhXJBe1Ec8Lh11v5K+AQkBJIqJdcuPK
	 aRrTUgmtYunqS7UOzXDKDTIMq2cIuIbJn6zDWuY9BJnaJCiuCm5xP8NjwDU1alwVh5
	 ovHh5bgAmNrFjlkytiOAy5Cfgx5Xf6krSHdOLQ2xGd1YeJKfMW1HH6z/ogZoI+tPWt
	 crbm+7q7yUyJ9375d/+HNArQS03/Qw65jBbBXqo9iBwSu5joMkeTNHIRQ4oLCt8gFF
	 R/LoU03MDikFQ==
Message-ID: <sashiko-outbox-205454@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 12/14] minix: drop mmb_sync() from
 minix_evict_inode()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-12-91ac6c024018@kernel.org>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
 <20261109-work-inode-metadata_writeback-v3-12-91ac6c024018@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 18:58:56 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> evict() writes out what I_METADATA_WRITEBACK tracks before it calls
> ->evict_inode() and since mmb_mark_buffer_dirty() sets the bit that
> includes the tracked metadata buffers. So there's nothing left for
> minix_evict_inode() to sync.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-work-inode=
-metadata_writeback-v3-0-91ac6c024018@kernel.org?part=3D12

