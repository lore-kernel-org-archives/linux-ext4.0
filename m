Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190460;
	b=BseDlRmjFFsxQKQWpBF8/X83/tPVrLo3RXcfhbUOvne8GiprAct8+Do4WNzQYs2DS6ax
	 88aKVufxOaydqzccPV7zns/Lu4mL8E2dKS+GybOURoEnQ8ba9I0fpplr49j0vaEFCnNLF
	 nZfJRC2cO5Evg1jN/hmjn91TCC3/F2HSffTcLdwysPrgFMRKl/BDSuWrcdhlgWg/4nSxA
	 2cQVRKqRcIVf5hQm69DdrrBPjI+H8Gl8sZE8pJ3TI/KACp0htXtxSBP+AiH4rHm2SXSX3
	 LSXVk7+oJ+RqhodkiEvyLGvzLh/XIUlbSDJPf+H9Jt3Q3m8vmtbB6G4Ecsl2ZnRYMMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190460;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=fCfJqkTK1lk3175Ge9uTPn/L3ek0OJjM1PoO+ofC5pQ=;
	b=jPrtsABXB8wYNQLclEQ1fFf4+7YdayAf2F5PMzcjoCSCw+c7stdmzLc+d7sEWC7ljpZ+
	 l28VTa31Z8R61188EPoxJaEN0w72eQVZciiWHzX/x7il5GTyZs1sru0dr1WL7CHPlMr30
	 HGktwww0DzvEYrlsKo2DFltSxzCl72gA1qhFe5F7esq5ZHUscL+0k98oVk2z9R3egjRe1
	 jKOVkHlEeg+/bSze3ttf+Li2ujkdwkQnSOe4wHT8v2syRTa8oU87TZH27gwPNRHQQHG3C
	 oknvpP2NumKMs/UWTgW2y98ZN3dPF9IxkRy0lBSwhd9JUY1TClbpWDShBXDvqtep9Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VQTWvsVH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6D8606A330
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 16:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VQTWvsVH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BBC1F000C0;
	Fri, 20 Nov 2026 16:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190459;
	bh=fCfJqkTK1lk3175Ge9uTPn/L3ek0OJjM1PoO+ofC5pQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VQTWvsVH9HlkKgPgCSoulcbagqS50PslqHSCtrWnstwEC7gp9G0+IZjPVsNCIhfRB
	 lFrg7SshYOPqOcWR50yDkLMdLx1oorEHm+gsdr9SHI4RxmXL02ENaUGWPErYVaCwG3
	 6pL1Piy/vETXacChdOmn4BzDLD+ROoxdH+K82VgvL4WQQqhcoS21RtWScVaydH35r0
	 +CuuZa4GvaskdCYwwWrHXZ3z3DsWTseGroHMU1HIVuKaZrN6VXBHDIS+V5f0MFHXtl
	 XEJDdT7C6EAE4kAF29Xc7Mvs1LxNbIxHyy9+XC1xX6OO1PkzWqMIcTUoNTkzjg8SUV
	 RjjSf4ECOyFlw==
Message-ID: <sashiko-outbox-225506@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 6/7] ext4: use I_VERITY_BUILDING instead of private
 flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
Cc: tytso@mit.edu
In-Reply-To: <20261120155032.187246-7-aalbersh@kernel.org>
References: <20261120155032.187246-1-aalbersh@kernel.org>
 <20261120155032.187246-7-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 16:00:59 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Now that the VFS tracks an inode whose Merkle tree is under construction
> via I_VERITY_BUILDING and handles the concurrent-enable guard in the
> generic fs-verity enable path, drop the per-filesystem runtime flags that
> duplicated this state.
>=20
> Replace ext4 own helper ext4_verity_in_progress() with
> fsverity_is_building(), and remove the EXT4_STATE_VERITY_IN_PROGRESS
> flags. The IS_ENABLED() guard is fine to remove now as
> fsverity_is_building() has stub for disabled fsverity.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120155032.1872=
46-2-aalbersh@kernel.org?part=3D6

