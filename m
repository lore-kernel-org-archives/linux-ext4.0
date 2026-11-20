Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190334;
	b=czSSW1f/dp7Jt1PE6ERNj61mTpy1V9VsEEocHi4a+PazFdmwMA3MPTtSqWxpkXMdgCZT
	 qPneZrcvGSx5wvP7/PuAtg/X9E+Ys7EbbL/RvMd+elM19QrXNwRgU9YbuZPrIhuUFBBjj
	 cVFi+IsMCGCWVNRvIBEAIvID43DO8Gqsh207UN7XsvyWd3/035/eXdMLWXBQg9Yhgil/J
	 cKJl27c+F5AO5VYUy5AnSYD7aIFGImuNuM+APp7Gtbb3hlGC1RpPvrWnce6GN15Fn8MiJ
	 cy8YUn216zXiExvkUeeR4daSV8f6ZJiHDs180ITqDWz+l5Y+oTBm4s6ghe/+ZH70u/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190334;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=iLYZDa5KPGtsGNonUbJysRazayGF4ybP9n+MBXhrj5M=;
	b=XmhZfaDv4Ts/SaGnlhRGxl5L2y0Kq7kQaSVY2Vlunoe2d72en7Iyyh0qxI7gJXXA/4CV
	 AjEp3A5cUW7nKyPHVymBOSQBtxmzpS1FnfaxddzXwHHN1s+fawD4kJtQCX0tWgy8Dv3Hn
	 8vb0bA8dTW+KwS/yHwPxVA/eZmITshgjkKj+UJy0lm5wVkQEEKbBgVa213Tmrvu5C+hvm
	 bo5KO/gtTKiRiLoqSdICkoMebsVAgb+dbLnoPHAD+c1tpYg+BveUQq08wDNkkAb5yFzYc
	 KEzueg5iyEVxmBs3GzCHaUK7ssYc8fF1QuuwH0PGzZ2OM1heT6MQnVwWSu5QlzaXFug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=goPDyLcg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716E7606A335
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 15:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=goPDyLcg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20C01F000C0;
	Fri, 20 Nov 2026 15:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190334;
	bh=iLYZDa5KPGtsGNonUbJysRazayGF4ybP9n+MBXhrj5M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=goPDyLcg9bdTPos3HW6LmmbAHb6UEhmpEaGmpNBkdoghvkORvxkeG1xkyYjOLpfzj
	 rNjDtPsTjZUPPeIFihL8MPsCsmgRLCz52ka/KIJUyGZexszxTkpERVSBuj+je7VrRx
	 n769KfycoLVodqJgufnUAObHw1YkqUZl4NIftkhQNzJvX+sBJKcyrF3nLSiIVLglmA
	 lNqXljKh/AhlL/owxjtDQG+NDBcBMqN5jMw/Xm1tXIXWmOR/EdPM5SaQH5/8uqULTi
	 vJ3pbjky3wkCkdK0DPWMs4kBP4pO+9sxNupkYp7JFJDxq7moHEHk7v8mN4qjpVi13o
	 NmMK3MJuxpukQ==
Message-ID: <sashiko-outbox-225494@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 7/7] f2fs: use I_VERITY_BUILDING instead of private
 flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
Cc: tytso@mit.edu
In-Reply-To: <20261120155032.187246-8-aalbersh@kernel.org>
References: <20261120155032.187246-1-aalbersh@kernel.org>
 <20261120155032.187246-8-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 15:58:53 +0000
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
> generic fs-verity enable path, drop the inode runtime flags that
> duplicated this state.
>=20
> Replace f2fs own helper f2fs_verity_in_progress() with
> fsverity_is_building(), and remove the and FI_VERITY_IN_PROGRESS flags.
> It's fine to remove IS_ENABLED() guard as fsverity_is_building() has
> stub.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120155032.1872=
46-2-aalbersh@kernel.org?part=3D7

