Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792790972;
	b=fdgzhAf4pls52YNrsQ/HzPPKP+lZ7Nwc4Gb7cjZ5sMyy4lx3Gq541VsHZagVuOQnNKpU
	 Agid4+riucpdXsDh3qyrCIgmOOZKqVspBVtZ95H6HRsqz5bHAgxGFvuzv/cuB61iMs4cX
	 rjerJSy1cDHQDEJvIZTrv7fXPX5Fd/G5yoZYOhJ327Yx04MhGWfBEdEEl8jvBUNjItZlH
	 e/M8pUgJ/LE1avjI66rnoH0lG3NpLK9UnaXoLe8VNY73GrlMT3inyRBW7MzGNqMCyAHs9
	 pr+1GSrjlyCHEUSC/YvHQVE6Mbyzlm/k7bPzORi7oCozJoAR1QOLAHyefVtzMl4HCEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792790972;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=uZ5TBSJrpkvHPjBs9hCT612E0ykBja/tK97pfOm++jk=;
	b=kDIowO4G7MWqfZOIg83s1500YTlGS0Tz4YfemXaF9NRXTrSk5N1lufg+vhET5/Xs6X4H
	 my+altJxClxzJwC5lA/tibqwcFwGPIjSBCa6ztOlGeWVVwSf03u5X319GPx3R9c8y8ydH
	 WibmqgmIrFssYVo81uhJ5puknvilPoOBhn57/iYcPPLErwyP8lRbBGVuJxIs3tSniyYue
	 RBtrevHrvZMx+6JXQCf/rOSRjuXwT6T3WsP03pfQpdLsBK3/0/7BSGL9syI07k90lQ8TE
	 pSzW1zd9n4iYGlOw9eZ3vAdnTNJewwGFlkgwpIJh/Ry1T3WL6L3GWCTygKGLQ8Xnh1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NsZcdQx2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9578606A320
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 21:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NsZcdQx2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6053A1F01828;
	Fri, 23 Oct 2026 21:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792790971;
	bh=uZ5TBSJrpkvHPjBs9hCT612E0ykBja/tK97pfOm++jk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NsZcdQx2DfUp1n6ZhQ9IfguDTr6I6DgHJ+tYM1bgu6xNoDtXE00AC8IbGgzGurUTs
	 vheBJC4p47XJBKiRDbMxyHLuTram0eWBZqc15EIhDm4nHVSc58AiKc4GgysJaCGFu9
	 SH748WZYtn8O5CaBB0X+ZVKxk/kJXCCki24Dwmh8La2PD3NCElWiTufNgCpcSIt6CG
	 6ZvsKSDbNpSKPT9QfEz5O12rCAdQp1p459rR61osp+TMo9rZwSL2LQSKysi3d7nGRA
	 /mqJFz28EKF3JNYXGZgY1KlFtu+VvQhcL7jl5e1P0HMYxEsU/6vWUsK7kCYbS5g/IF
	 qTF9T/ZCRnT6g==
Message-ID: <sashiko-outbox-183258@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext2: Make sbi an proper alias for EXT2_SB(sb) in
 ext2_fill_super()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nathan Chancellor" <nathan@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261023-ext2-fix-context-analysis-clang-24-v2-1-a33961453899@kernel.org>
References: <20261023-ext2-fix-context-analysis-clang-24-v2-1-a33961453899@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 21:29:30 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> A recent LLVM change to fix parsing and validating __guarded_by on
> structure members [1] reveals a couple of warnings in ext2_fill_super()
> from the annotations added by commit 023051c2d0f1 ("ext2: mark
> s_mount_state as guarded by s_lock") and commit c23746524faf ("ext2:
> annotate s_rsv_window_root as requiring s_rsv_window_lock"):
>=20
>   fs/ext2/super.c:1040:7: error: writing variable 's_mount_state' require=
s holding spinlock '_res->s_lock' exclusively [-Werror,-Wthread-safety-prec=
ise]
>    1040 |         sbi->s_mount_state =3D le16_to_cpu(es->s_state);
>         |              ^
>   fs/ext2/super.c:1040:7: note: found near match 'EXT2_SB(sb).s_lock'
>   fs/ext2/super.c:1138:8: error: writing variable 's_rsv_window_root' req=
uires holding spinlock '_res->s_rsv_window_lock' exclusively [-Werror,-Wthr=
ead-safety-precise]
>    1138 |                 sbi->s_rsv_window_root =3D RB_ROOT;
>         |                      ^
>   fs/ext2/super.c:1138:8: note: found near match 'EXT2_SB(sb).s_rsv_windo=
w_lock'
>=20
> Context analysis does very minimal alias detection [2], so it is not
> able to figure out that sbi =3D=3D sb->s_fs_info =3D=3D EXT2_SB(sb). The =
only
> reason there were no warnings before the above LLVM change is because
> the annotation was not parsed and verified correctly.
>=20
> Rework the allocation and assignment of sbi to have a direct assignment
> of EXT2_SB(sb) to sbi so that the analysis knows that sbi and
> EXT2_SB(sb) refer to the same object, clearing up the warnings.
>=20
> Fixes: 9708538ba204 ("ext2: enable context analysis support for ext2 file=
system")
> Link: https://github.com/llvm/llvm-project/commit/217e229a1f32785fccdd3b3=
f51429f0d309dea45 [1]
> Link: https://clang.llvm.org/docs/ThreadSafetyAnalysis.html#no-alias-anal=
ysis [2]
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023-ext2-fix-c=
ontext-analysis-clang-24-v2-1-a33961453899@kernel.org?part=3D1

