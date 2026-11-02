Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793644203;
	b=Y0bdIOWLJU8t+B/tGLBdbycwSA2Ovs6h1/BynH/zQKTYSkr2uTCXDno19LFsXFelevUN
	 tvsfEcHEMeFiM8T0GXA66F+rduAdAErUP7w/Xwwt4dx77jxP/xS3fxnO/ALurO1wAe/Vv
	 fSjc04tD5g7FZE2mZUz9tqIcVnauLhvApweoxOzdTuNZvwmpU2KpW7uxJHR8F2Pxzz1Uh
	 53FH7A6PMijw6L4Nzba8libSnZRKBizDclxej1wLedC76WGzMdyf7ohKcBFKXz6BtJ0PW
	 9cfxfUhzFn7CGEYCtKA7C1iwDNE2Xl0dpmQSUfSiAHaPtsRwREAh6eI1zEVQINZBTug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793644203;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CUn+87fx/w+nRv6+76hZovDJ1yMlhJl20Nd7I3nUWG8=;
	b=3X6CwVmR3l/y4FUtTv9K34Ke775UwLsDzQ/1v2gphZJgO6zwKmSNeXTKLxo0FoKl0s9A
	 CIxWov0KEt/7JvQRzQM/qzLfK4v5HeinX6hkZ2URXkOuo3DaKi/trkYa7z+zo61LDX8TZ
	 JM8JI0Re7LdBaFKa0xBQTxa2I+jrHqKsKXM0zSGFaHKygPkQfEsjhA1na2iSsChVjBuRd
	 hQgaPhV9XztKnvGseJIHmAU8yI8DK0eYhDz7Hr+4I0snle/qP9SZ097djDRJ4gRY2yNNp
	 kXVA6lomCNacg5FMEqIscSo7jw6lC9ZKiyh5+7ug4Pl6JNlS5FqRN8Vjdd00swRGlgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QylZT25J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCC3606A324
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 18:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QylZT25J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE3F1F00A16;
	Mon,  2 Nov 2026 18:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793644203;
	bh=CUn+87fx/w+nRv6+76hZovDJ1yMlhJl20Nd7I3nUWG8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QylZT25JWeZ+lJ6NUEc1i/+gB8Eq7f81Zdv9M2ltym8mZAiYNVaCZWW4SZVp8VfRC
	 dVpoCMIdmEJ30To+dKLXUKGybimdjvNxEoDlV1Zo5MsmZ5BC3HUm+KlJbwC0GBV9gP
	 C7MY4WL+1oRZSrw5Hb1wVocCeR31IBFTOT0yD9XskInv/O+2yQ+sqybvaQAQ67UGdL
	 tvLlFTFJeFUFapeAaaG7x7cAbojU3TLogVWzs2MOX25xaaTsF26BnKQLxSD0TTcT7d
	 eICC5/8emI2fetc5fP84OlIuhwIP/YDvUhcDydQPUjkINWrjR6p7uzMjGdk2axNwY1
	 VMYhZPe0aZrmQ==
Message-ID: <sashiko-outbox-193943@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/8] ext4: add extra_flags param to
 ext4_convert_unwritten_extents()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ojaswin Mujoo" <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261102-ext4-endio-zero-bug-v1-1-266d2bb9e6dc@linux.ibm.com>
References: <20261102-ext4-endio-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com>
 <20261102-ext4-endio-zero-bug-v1-1-266d2bb9e6dc@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 18:30:02 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Let callers pass in additional flags for ext4_map_blocks(). This is in
> preparation of the upcoming changes.
>=20
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-ext4-endio=
-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com?part=3D1

