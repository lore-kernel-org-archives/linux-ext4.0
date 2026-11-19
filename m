Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104323;
	b=mHeP+tC+ZUmLut08LZLZkQiDowpppvy1VUKBYLA6xOSk12Qk/7SuAhcpRpJVhtJvzOEg
	 mkIMotvya2Wt+Vt3y+q0HSKdUtd+azdQQVzjAIhYa9Wpfxsp1jHyoOlmaUgi73M3Bx5xE
	 yp5e8q0+sdr6QhmCo/lIijVvGL764aLh4mNxgLmJUOchk6KoUsWnWzeNYULjG8qOvDEWo
	 16m2XgZtng+wu5x+LkaMuKk9a2x2ZkYiJG/s+zpq53ysCCoxhVYbm93OaR2Ls1DXE5c7x
	 BYSLmEu01frrNcPmV5uMkfAxnMSwCxxw4bpJeTPbWnidsQ3xboOg7b3vZBQKQh8zApA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104323;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Lt6AJm/AknsQLbKRdyKCQCMeV59mGjSGuMFLaKVThH4=;
	b=LaZ+YFt+E7+D7CxCYSwEhyN+7VIe55uJKMfJtZbJR9j3WvyXrl6l/WBKtyL674aeB1jG
	 4DY/r52QVGNOIykQd5iy4E3mLmaP6p/S+tn/MrLWsVn46qPd2Sx8PxmW+kxuKLz4U1C1C
	 /vbHndnNql38qQe8NPQjtawwYJzhwYW28QqZOIsVHnSiV480iK/4LBio9EFQ4vfHeT9az
	 ME3l6JMZMygTDWVQwQaKZxD0YTuxtIU1JmZ54LJBeZYPTj2rJeyM+frJIPG52JqwhkEP0
	 en1CHd8e8e7ZNtNO2QC48g520cQprVpKHOD5n2fB9Q944uyE7LyJPG1dtRKHs7UVEbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qax4x1sB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2783606A320
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qax4x1sB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253FF1F000C4;
	Thu, 19 Nov 2026 16:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104323;
	bh=Lt6AJm/AknsQLbKRdyKCQCMeV59mGjSGuMFLaKVThH4=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Qax4x1sB1X40W7Ddg80plNaHoOz16Fj5FNoQbYISOHAPbfTBmqs+9XhpmwrnnwyjV
	 p5Uhd7Kb3EfbuhJnnrYRDUG/cjzdU/4dlxjmmFTuwMfKnRFS9E1tOZ7qgE1piDejq8
	 tEC1FAFNejx3Q6B+upd+bG9GTTWkC/vmRtp1qbHNfQ60PHKT2aOXXUwv5ppWnwL+l0
	 wvcoK+dg7++XAKXSBxXfX3zzyFKmDw4hGvZItUqPUHgg+NDk0K7NT/ATSCFxqHrUNN
	 x+VZoDM7ndISk9LyaGieWhKrx6z7imrnQXh9i0Q7TS2maxW/BEK2JdIO0vXAJ6jHda
	 KHNIE9Fgl3v+Q==
Message-ID: <sashiko-outbox-223460@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 01/26] ext4: add KUinit tests for
 fs/ext4/extents_status.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-2-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-2-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:05:22 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> These tests were created with the help of Gemini Pro and verified by a
> human.
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D1

