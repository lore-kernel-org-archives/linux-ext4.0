Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793822453;
	b=UTOzrAQD8dEMT/QUJthhFMbWVhM5odAgwCaGmquqcxrxGnIgq2pPEXaFsqVQ95J42dTn
	 LdhxB8f/7HXIIS5d3LMyMc8RdXC7d8QaRFfbPDsdl3M7m8cz8ptw7qfTpXYuYbrtXItrY
	 GX88xJG898aQ2twPMek/YBuVfv+fvEhJEFlt9KOtu/ASkjOV2FoocpKxX1YUMP8/iWMBu
	 2+lCG23xK7FFFO4TFdCFCCd9EFTVeCbMoBvpyVDUFAOhJuoJCy3sNOhoxrvy8XSEDU736
	 joauGe+2Np3MaIDN16HwNmwcI7Q67YjOSnCumsCjw86nfRoTWeAdD9itW6mitsgAL8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793822453;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=InkgJANeqcPX1MvWjiRLEvl4hlBukOQTKTUy8KEtyEs=;
	b=qcLBdABUSbUL9mPxY2u03/mDscujMR0VgpgZyO3QU54m5zf0Yj4fVQstF2eJIJwWxRRB
	 orqc3MB65jQciHslAAzBkm6rffDYN48Bq7UrFukzwAvYv9AG1RDbELI0vYHtK2n7nTpGP
	 QdrQMQSzcUWTPdKxdqXDFQiQ81EYQSQsBoaJu3e2zACkSyo1rxyyrYMMkyvq3Gt/3zcta
	 gCYQ2sGe2qOBgy7V3t3gsZwIY20utwX3fO+qevb93YqfnkdhjF/m54l5x/Q1TJlERrQp4
	 l9bc58AialiGl3pkYU4bTDllHMBqNdQF84Vm6mIR7kUqSDrJWxYtgXlmSzvpt5fCrPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ks7stMOM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57606606D4C6;
	Wed,  4 Nov 2026 20:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ks7stMOM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDE81F000C1;
	Wed,  4 Nov 2026 20:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822453;
	bh=InkgJANeqcPX1MvWjiRLEvl4hlBukOQTKTUy8KEtyEs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ks7stMOMPvS8skog53DxEP0NoXulOmi/wXJ+GDFiv9ocxytLze0fUBpCihRlPeJbt
	 /aHUnr93ckMZYZN6zj6P5k4AjcEzvbd9bsWkwm/164vYkxKrEn1ytJ/6PtTx/lpinZ
	 Y5wLZ89Xp+cr3dwcJO7AX3fmfl+zUeXXN2nNKyCOoBH3RhWcyty8SjB3reaspIz/ku
	 YTGmaB56KRmpQ5GSoVkWtbMIQ6JNZll+3rWObM+jIECRebtT2wNHirE2eawnf6Ahnm
	 QOZQ9jxAwJ3tWUq0/3Z1ZGmTN9Ji3plw22FKQi2IGCRWYyHcD+9SE8Jh3easWP95wJ
	 xvezDp9jANI6w==
Message-ID: <sashiko-outbox-197985@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/5] btrfs: use I_VERITY_BUILDING instead of private
 flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>, ebiggers@kernel.org, hch@lst.de, fsverity@lists.linux.dev
Cc: linux-ext4@vger.kernel.org, dsterba@suse.cz, tytso@mit.edu
In-Reply-To: <20261104194618.103332-4-aalbersh@kernel.org>
References: <20261104194618.103332-1-aalbersh@kernel.org>
 <20261104194618.103332-4-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 20:00:52 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] btrfs: unpropagated btrfs_orphan_add() error in btrfs_begin_enab=
le_verity()
--

commit d32a0bd97250023398879e80e49ecc247da4ccdf
Author: Andrey Albershteyn via Linux-f2fs-devel <linux-f2fs-devel@lists.sou=
rceforge.net>

btrfs: use I_VERITY_BUILDING instead of private flags

This commit removes the BTRFS_INODE_VERITY_IN_PROGRESS inode runtime flag n=
ow
that the generic VFS fs-verity path tracks in-progress Merkle tree
construction via I_VERITY_BUILDING.

> diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
> index b34d2247cf84e..82e2ebad0d3e6 100644
> --- a/fs/btrfs/verity.c
> +++ b/fs/btrfs/verity.c

[ ... ]

> @@ -606,8 +600,6 @@ static int btrfs_begin_enable_verity(struct file *fil=
p)
>  		return PTR_ERR(trans);
> =20
>  	ret =3D btrfs_orphan_add(trans, inode);
> -	if (!ret)
> -		set_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
>  	btrfs_end_transaction(trans);
> =20
>  	return 0;

[Severity: Medium]
In btrfs_begin_enable_verity(), removing the if (!ret) check leaves the ret=
urn
value of btrfs_orphan_add() in ret unread (which triggers an unused-but-set
variable compiler warning) while the function still ends with return 0.

Previously, if btrfs_orphan_add() failed during the
fsverity_ioctl_enable() -> enable_verity() -> btrfs_begin_enable_verity()
path, BTRFS_INODE_VERITY_IN_PROGRESS was not set. Now, enable_verity() in
fs/verity/enable.c checks the return value of begin_enable_verity():

    err =3D vops->begin_enable_verity(filp);
    if (!err) {
        spin_lock(&inode->i_lock);
        inode_state_set(inode, I_VERITY_BUILDING);
        spin_unlock(&inode->i_lock);
    }

Because btrfs_begin_enable_verity() returns 0 even when btrfs_orphan_add()
fails and aborts the transaction, enable_verity() will still set
I_VERITY_BUILDING and proceed to build_merkle_tree() without an orphan item.

Should btrfs_begin_enable_verity() return ret instead of 0?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104194618.1033=
32-1-aalbersh@kernel.org?part=3D3
