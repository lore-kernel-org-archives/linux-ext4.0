Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793277096;
	b=sDR9B/Yb/taBiXp1/+jIZO81898PUj4VGqyKVin66MAPtY62/ygQRmQ4+fcpOOpetP4V
	 7Lxpr6QnNPdft3J1kfqcz1y+ptMWwBZUGxV+ySkljx87EQV2ARBzmQT163mOZFzwfBqDm
	 LW6G5fC6C0nTVbPWPJ6ROi/ZqREjW27kiu8c5HVKaIYBfE8h+UT9T4om1ukIhoiRWl9Ku
	 pxNn2pSltg5ExVd4Ewk2KPwd+w/46OLtuZ+YeoLYOLzYaLsce/kR0UjoCJaLGF7zxkvB9
	 fEPrhXNzwDsWiQaCkvSY0H8xDrKhNKTbF4v/oQ5u6LI7HX3pDQn3LyBZmta+4APK34w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793277096;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=OgaQ0xRsVTqhbynKaR5A5QiT04cOmawD982kYURwvV0=;
	b=O6BVmu4c5ZxUubeVQc+4Y/yPqXyQu4PSJRgqs4JCd5/A6IvKCugAmVKwv3rBlEuHLcWH
	 2rZFBLg17Woz1Uks+wD7H/lAbAe8yMz7SJ+T9aPFT4J0GnyZLdMu0AYsKzOd/sGek/zmm
	 qx1I4dVl7j6kB5vaGtEde9kF6QTJ7Sr2QJdMY+/hcu4Vex91VPdjnKZl5Y4lVtNDHrDYj
	 x2c3WPICNRByRDa5gyjahjwjIy8OlmojNwUn9QejixMcYPAOzsxweI6SyGyYU4LRku0PX
	 EnnKaQGzW2VdUppyYn8yp+6QIHbxtBcf9w/Jb59WLSTcpn0T802CLa03cpIiux0MOYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QpsbVxfB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2E7606A31D
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QpsbVxfB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248431F01182;
	Thu, 29 Oct 2026 12:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793277095;
	bh=OgaQ0xRsVTqhbynKaR5A5QiT04cOmawD982kYURwvV0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QpsbVxfBmvUZihEKt6+QZ4xJlqLbyfITEfe77seRg5wh2D26BqhJNakH/hPnkAYpP
	 KSwj2wCAauyelMELkRxQLimGwYHy9wOiuefBqzJjzT72N4k87DPPnwrJSWuaQZrUre
	 OzJsdUDh52fNIE+P5AUJtKY1zU+aDoHLvtcWeKRZ6qQArwnQalIvBOmwoLhLp5YbiF
	 NbSHwMz9FMLp6DlMHERk973bl+AfoVC5H5ea3I9lgOeqgJsNyoTkOYqMvouSQQBLgw
	 0TtU3risM8DVrxjD0w/M0sk1333hBvyvyU4LflQEtN2AfQGLdOUvKWfZj+vEDAz+2O
	 e+eaoifJMFInw==
Message-ID: <sashiko-outbox-189284@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 04/11] ext4: add dirdata format definitions and
 access helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261029122413.230409-5-ablagodarenko@thelustrecollective.com>
References: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
 <20261029122413.230409-5-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 12:31:34 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Define the on-disk format for ext4 directory entry extension data.
>=20
> The upper four bits of de->file_type indicate the presence of
> optional data stored after the filename NUL terminator.  This patch
> defines flags for LUFID, 64-bit inode numbers, and casefold hash
> data stored in that area.
>=20
> Add struct ext4_dirent_data_header to describe variable-length
> extension records and struct ext4_dirent_hash for hash storage used
> by casefold and fscrypt.
>=20
> Provide ext4_dirdata_next() to advance to the next extension record
> and ext4_dirent_get_data_len() to compute the total extension data
> length associated with a directory entry.
>=20
> No functional changes.
>=20
> Signed-off-by: Pravin Shelar <pravin.shelar@sun.com>
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029122413.2304=
09-1-ablagodarenko@thelustrecollective.com?part=3D4

