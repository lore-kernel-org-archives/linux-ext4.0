Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794808541;
	b=czD3AWmt8RtuChrbbGsian87YGNzxr82wdKiUGHsZwG6xA0VPrjNfa5gT4GCmpuP5Ta8
	 VY5rybiyEtlbgj2xP/KQMbU+TIEnv9UjcQ1DzmCpuiNf7FKpRaPVRZtO2yxAmeU4D3uBY
	 PXDKeCsnDuy5IdhHKE4uglAKbcnQ3VYvNPEjCstLId+H0GXGUeCWJKs9DEMsTJVCj41FQ
	 yxtwFPUXARgn+4ADfvOkP3OTnCbSOfQcZjnKwbEsrw/rNddpDLrV43cuLWAL6cXwRVSot
	 r9QJg0plXX+MMZIlbHUPsxXnwOITd/X7f3mlATXVe0/rIimQgar6qFZH4W1cDHeBnjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794808541;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9Du4okdrx7JgvMmM59Qw4HM07U2f7Q1l1qnDTNCy/dA=;
	b=YSzlcJTmn6bMgcil51eUBHoEaE3vc2m8aQ2CFYxxMG2+DFsJ2u1YGpExcD1A1/gY/aku
	 jt8TZNBNp9QHXNnIIXsD2RCwo3xYnLniACcoEKYkkONW2ua5LScXGFQuUpYX1oNyNmqoe
	 wFegXl+zDtBRtdBMqhfMWmSKNIhrC9193wYJ8r/TisexySvxDZyF0uj/7WC0HRBlgEykx
	 Ty5+7ayeIL8SfV3e/fxQXLCx4k1rZYUsYrpJqVOiSXQCYxHUpwU60UVDWIGempV9fUjrZ
	 aKg0IAHFDICJxvoQ3HgNT/wow7gr0vuj6K2HuLkajam177rPJ0I4YTUFtx+Dm55IsfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HfHUxnXK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505DF606A31C
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 05:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HfHUxnXK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98F21F000C5;
	Mon, 16 Nov 2026 05:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794808540;
	bh=9Du4okdrx7JgvMmM59Qw4HM07U2f7Q1l1qnDTNCy/dA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HfHUxnXKnbmSvT/OQBUYxBjJdXVSz1pgtfN37IXnHqW2V6NCEmM+wmUt+87D7LAMi
	 l6adVf5hlYySPvrvX172v56SlVHxAT0GYK3HnfiI00KSO2OppuG7F6u6KwTYe+vRkd
	 g8F72297IAN/t6Wd9hZSxk3V9s2v/Tvbv/CWXtmIZP/q3muiXxvOcWd4asShvuRh2y
	 N8q1QZ0LP2jeLP+UrKvmEbXsYe3zt810U+ycaKjTHGpZqjrYNr6wtzxInEMTJx6uwx
	 XCtFz78JuF2sHAxuk5ZhW2qV+BhLKu+xSIMY6z/h151Mwqkxkyjcie4xDueCI8dIew
	 bzKsXeOPKN5WQ==
Message-ID: <sashiko-outbox-216235@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: attach jinode before inline data conversion in
 setattr
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qing Zhang" <diasyzhangqing@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261116054424.62067-1-diasyzhang@tencent.com>
References: <6afa2521.84fe3b82.798c4.0005.GAE@google.com>
 <20261116054424.62067-1-diasyzhang@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 05:55:40 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Commit ed9356a30e59 ("ext4: convert inline data to extents when
> truncate exceeds inline size") added inline data conversion to
> ext4_setattr(). Pathname-based truncate bypasses ext4_file_open(),
> so the inode may lack a jinode. In ordered mode, the conversion
> can pass this NULL jinode to jbd2_journal_file_inode(), causing a
> NULL pointer dereference.
>=20
> Attach the jinode before ext4_convert_inline_data() and propagate
> attachment errors. The attachment in ext4_truncate_up() occurs
> after the conversion and is too late.
>=20
> Fixes: ed9356a30e59 ("ext4: convert inline data to extents when truncate =
exceeds inline size")
> Reported-by: Ahmed Khan <ahmadpsn95@gmail.com>
> Link: https://lore.kernel.org/r/CAOaS1=3D=3Dg3mdoqmS2AjOC0_-woXJbA_X0LJQt=
7+M7d1=3D+gfyQqw@mail.gmail.com
> Reported-by: syzbot+9c29b92a3b6500bb347d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D9c29b92a3b6500bb347d
> Cc: stable@vger.kernel.org
> Signed-off-by: Qing Zhang <diasyzhang@tencent.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116054424.6206=
7-1-diasyzhang@tencent.com?part=3D1

