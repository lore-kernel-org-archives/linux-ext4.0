Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794855774;
	b=XWEGcF4GO8y3WBeh3yG0kQkzGItKLWgMzuwWpL2eDas2a3X09Vlz5mmrW0dcTuV4Lg4r
	 L0nVWmGSYTUcIDwkZ0gPwTqUyrGOvQJCqGm8ANo4F80lOtW/ifZO+Gyc20nWXpM3+SEHI
	 2yBBbLl35w69lh4dJAMUYTD/NmqgQ2HIYOqpm9pVB2V6FTTT6c9eiaX+bAK0iwxvO9yXA
	 IM6gH/StgsM3bNxLTxiGUTBnR9gNdvGqD0ODGyDKB6sPelA2E2yyfIrmV/o6VeMFY+5+F
	 hLfGzP6vNLQFN7oXcJgD5sPMTEuNK3OrMchXAXAwFrEneDVHx6AXwyS20u12vRRAcGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855774;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=r58LJI5+NJhx8Y/Y8MlOqigdXnzIyYGXP5F7U+nmksI=;
	b=ymd3TXqb4VYBAFK5QSKaP822wwwXAUOXPj5uUhgsIRNwL+doxoB7803FWoXgUidpC5Q3
	 YOjM8kfMLZ2rtyl3gBb6ExG4Ao67ledRO2Il+MAX2BeCCnHmXA679fNyqpfk7eWhVFIdi
	 xEi2R0NrSB8qvMmB3BAxVp2//uHBjIczIIwkhIThvU/0tzM092UIsN+psUMjM1llM1KRU
	 GlqPM+PsGfYNwFTenjCSrm5WqqAvf8POCK4ilkrYEhThSUrxB8gfuiHu0yiD4cZ41mZzA
	 qAB03Li+bJciUuJWl0gG4p5xaTamLElE7AzwXmYRR7Htd7ySgFH6qNL0K07YH4JFBuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mdPGEaNy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA01F606A323
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 19:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mdPGEaNy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F5B1F000CB;
	Mon, 16 Nov 2026 19:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794855774;
	bh=r58LJI5+NJhx8Y/Y8MlOqigdXnzIyYGXP5F7U+nmksI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mdPGEaNyQ/e5Wl9fSHcoLopAu5cMs6aPJrWCMXf3QiQnTlKQKBp8je8RtAKk2I13X
	 sZ5oGNqoE5OGMnfhcuxO7K2a4zkxDUSkJOFjqnnQvyzy7kAQ9Lof9Z5cI8ZVY5Edno
	 NHcz1epaTulXPNI2iaAp4BmP2Pief3c0R5BHBdNE4SK0RtogfN9e6L97Q3tHHJk1QV
	 IiZh2xiitKe6XXCeztyN+8tRU/xj5JOYfqle6LkeMAchvNom5sMYcY/LVJ7FfmqRsQ
	 3Y2Q1f6MQDQ5graQpcMayKsMN9QlL2MzB3wvBAi9pMYqT/9PdCq3RdzEwCNM27MnOG
	 ontFgAWLEqnEw==
Message-ID: <sashiko-outbox-217523@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: check RLIMIT_FSIZE in insert range
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hungyu Lin" <dennylin0707@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261116185810.82581-1-dennylin0707@gmail.com>
References: <20261116185810.82581-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 19:02:53 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ext4_insert_range() grows the file by len bytes but only checks the new
> size against s_maxbytes. FALLOC_FL_INSERT_RANGE can therefore make a
> file larger than RLIMIT_FSIZE allows, while ftruncate() and the
> fallocate() modes that extend a file fail with -EFBIG and SIGXFSZ. xfs,
> f2fs and ntfs3 already refuse to insert a range past the limit.
>=20
> Fix this by validating the new size with inode_newsize_ok(), as
> ext4_do_fallocate() and ext4_zero_range() do.
>=20
> Fixes: 331573febb6a ("ext4: Add support FALLOC_FL_INSERT_RANGE for falloc=
ate")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116185810.8258=
1-1-dennylin0707@gmail.com?part=3D1

