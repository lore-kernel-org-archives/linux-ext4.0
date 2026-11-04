Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793822271;
	b=XD13nKG7i52KrEsH5UTR/IlqlaLvllgqJb5NxsManN9NmXQzjNU4rfVFxCXXAhj0pqVy
	 4WQEColn+D+U7vwdCFdfuu7LR9VSvUvbbF6jbOhYlO/EKn+qrpLNy/DMD3d3rKa5JNr+u
	 K7B1STCAq0jTe8mcGkq/KifyJeVsBJQqeo6adIXH3X1ePulPN4QaDeA3J1PIw3kvYFJ2x
	 rskgGjX1uks2bcTZIJvHlrm85Po/sPS+ii3hPdNhE/7D4M603XF1rHZFLe0ARQCtI7Yq9
	 Hh7s26kqQIKbF+883aPU7eJKvGY+9F3kLKJbCLyq+ij221JmsIVo7VtNVhNIwHRQ0TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793822271;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5OUhRCz++RjRDToIUo0hzbNCG2hFwoevNS8O/we7dMY=;
	b=YmoHlK/cw9cTHce5QAhiMnUZgzCRTCZmjsPGyTLTLvqDUOtBM/RbtgCH2qXC6g2t8kfG
	 5lpqYLhKcBiKP1oXtHfXByVYAaVPKJteQjbw55j0BiH+D3EoI6XYJD1o2vsypTqYKBTb2
	 V2qR41YLhC6acRF8eaxfJzNyqdh18zCg3bDoRpEWr9mhQGX+Ka6Ed6sYX/uNEFnMatSkL
	 R/ffOd8viyr1M4XEOVyt5RzxJo5/1NMwyflavJxlgGPinAUoDT5NeN7eKgVgT4BdRT3Up
	 8Sw1N9bW9DKUNqt006PPXbmzSdugpllWOwnEr7k6H0/nBMHBqHw/SZeOZvqS7SSdBVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="h/SKTJ2N";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA60606A328
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2026 19:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h/SKTJ2N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDDB1F000C1;
	Wed,  4 Nov 2026 19:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822270;
	bh=5OUhRCz++RjRDToIUo0hzbNCG2hFwoevNS8O/we7dMY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h/SKTJ2NdP39eAf3510w6spOZM7XKq2iDISLzT84hYxWlrSExFwFfCAiYKX4It+/Y
	 9RKY7Qp7kJsMJpcMNzqEydVlcdiR0h+VD5ErGICIOtY8asNkmZoLx8iEFsDKQPRpiS
	 dq+5UHXeL+8Qz+Grk6TzRvY7i51ZIyVxypJpb7HIJlIqppUr8X6O+4mZzODysVhy0Q
	 8euca1JhhZQPgiY0Dp45MwPFnkcs+dDZyXeDWEg4xXybi3i2VetHVcCHzTLqu0tlAg
	 e3kj8W/ws+W/e7gLkhuUZG8y54OZ4j3iMZ3wmYn/2wM0+QtvvpoKbW+IdS/rKNO4E0
	 1P/nRykTICePw==
Message-ID: <sashiko-outbox-197983@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/5] fsverity: add I_VERITY_BUILDING inode state flag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261104194618.103332-3-aalbersh@kernel.org>
References: <20261104194618.103332-1-aalbersh@kernel.org>
 <20261104194618.103332-3-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 19:57:50 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Every filesystem that supports fs-verity keeps a private runtime inode
> flag meaning Merkle tree is currently being built *_VERITY_IN_PROGRESS.
> They all serve the same two purposes: reject a concurrent enable with
> -EBUSY and let the write paths recognize the special writes done while
> the tree is under construction.
>=20
> Hoist this flag into the VFS as a new inode state flag,
> I_VERITY_BUILDING, and manage its lifetime in the generic fs-verity
> enable path. The flag is set after ->begin_enable_verity() succeeds and
> cleared after ->end_enable_verity() returns (both on the success and the
> rollback paths). Add the concurrent-enable guard.
>=20
> A new helper, fsverity_is_building(), is provided for filesystems to
> query the flag. No filesystem uses it yet; the per-fs flags are
> converted in following patches.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104194618.1033=
32-1-aalbersh@kernel.org?part=3D2

