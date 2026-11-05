Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793845160;
	b=Pwm852uru71Za/BbRG+reu1cDJqZyJeN6e/P6oWbrtjBbotZwfKhf2jfnXZeMQC78qrX
	 VMqfJeHy62MBuK6uXLdPrERsHyAfBWutKJMS348nBjFdzh6ef2pek3l+obW2pjLBIKxEJ
	 gVsHVYIXP3qeLv9pUyAs+FY5SLRRHIY/ySUnVdvMv4u6MgZ2DglWbCcDFFr0iZKBcziin
	 7mcGDVujbJ9TFao7f7nCcngM88GfiSh7NgyeslMkbidq9W1h74bOgd8FNBNT6wH271+TS
	 lP1em4VCzDeFYSX2FVhXm8KFhyFVx6ACWbV1EIQ4fPHpmgkzzb4UheTRmalQaFlsNrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793845160;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=rnbDQwdfwxrm9+3LCSppoOPuWINNM8e0ohNBW+S7Ync=;
	b=UUceiZFCvPBy+Yl+nvfc4UdnWcNPnqXiVZRao9FQ8azzBGzI+cNGfyW+bk54aCgoldfy
	 SsxzopV20Zgc6geFh4fus2kkRSF5aLH2RCjyZqo+lSpke0xVsw0HCPpdH65dbUlhZQKiA
	 10/e88EQYZ6wNHJunzFM5srvVm4WlTjFXa+6eiX/RfUkZbWRrWn/DN6dJuGUIwp8ImoXT
	 IkFJR+nIt1LuM/jELCQLrB8LI++tyTy78KkPYZKqY8mAM8WGF1hhx+IlRJ2/WPxbqhBwp
	 tAwZ8E4nqxVypjIymCIsd4iyTsNcuP6eYlkegScpXctBIpLAN0BVcc7p8kZfcfrT6PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YhQhSu5G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6032606A326
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 02:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YhQhSu5G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3CD1F000C1;
	Thu,  5 Nov 2026 02:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793845159;
	bh=rnbDQwdfwxrm9+3LCSppoOPuWINNM8e0ohNBW+S7Ync=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YhQhSu5GOuTPRAL8aZWWcO3iR58La4k/GqpPe5zoMuo7240qm+FK6fkLXPSjO7v8V
	 XCX+IJACA7rojZBxebRRfPKXm6sqLpW29W2C4A2+g/O2mYuW3t4jmVqNaN/nnYRExl
	 VsBI2Gwb+9s5+fQ4PcWolyB+J4KR23LUVBGhIAeLpshdMZgTWLjtuVVYXKm5yrFJ1K
	 yVgptPajmHM0ggZwjgNP3sL8aCUG8CB/D7qWpj5yUTaBBzQ4szwLbn4GSIjwP/w/Gw
	 pp63+7m6sIBp6xoulpdAjOgqwp6xecYGS4v7E8WSIZME3u7OwdNgVBquuO1AcRQsvs
	 EuZdU0q5/0iAw==
Message-ID: <sashiko-outbox-198448@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8] ext4: fix slab-use-after-free in do_split()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shuai Liu" <847807867@qq.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <tencent_BA3A8C65555EB74908B7404C6562DC5D5705@qq.com>
References: <sashiko-outbox-198398@kernel.org>
 <tencent_BA3A8C65555EB74908B7404C6562DC5D5705@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 02:19:18 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> do_split() allocates a new directory block with ext4_append() to hold
> the second half of the entries of the leaf block being split, then
> dx_move_dirents() copies entries from the old block (*bh) into the new
> one (bh2).  Nothing verifies that the newly allocated block differs
> from the block being split.
>=20
> On a filesystem whose block bitmap is inconsistent with the directory
> tree, a block already referenced as a directory leaf or as an htree
> index block can still be marked free, so ext4_append() can return that
> same block.  With concurrent operations on such a filesystem (as
> exercised by the syzbot reproducer), the block can even be freed
> between allocations, resulting in bh2 aliasing *bh.  dx_move_dirents()
> then copies the block onto itself, corrupting directory entries
> mid-copy: a rec_len field can be overwritten with name bytes, so the
> subsequent wipe of the stale entry memset()s a bogus length, causing
> [ ... ]
> Reported-by: syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D09bec78ee77613a3efdd
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shuai Liu <847807867@qq.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_BA3A8C65555=
EB74908B7404C6562DC5D5705@qq.com?part=3D1

