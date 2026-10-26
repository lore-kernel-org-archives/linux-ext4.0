Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793034440;
	b=l1hJY6MiyCQTHCzzYwfK6pxaCauyFaS7jJimajLuBAGHGit1upW2b4o8oJBN2dWPY8NF
	 kdeNM4Ri+1iEK+UYMm/Zpfvhp7HbPyS2yE3hsoOozqRxBA5V9ILlflTiZl0C2KrjsUGAU
	 VKwY+VUFnEGuXfic/e9l14jJ9dG9vnSpsU0fzZ/gdxfSbH8l2doT2cumzCenIEcwuGryR
	 RKNDo5k63jgL0aaML8hBdWSp4rHvt0owJi3Al2MzE9IqJe25wCnidZzL5Y3RcobmJxTvS
	 cK9xRocvGQratbggOKZULcdCLhJRXqZmYH/knAIE5NeE6s7lSJOK9DWp2e9ZmdDkb0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793034440;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/3rJ8/Al60DrQWFoem+UA7vypW/OjaSz9+xHzh1QZzE=;
	b=SczylKpfEI4ob7C1KiSy2N7b+L6rlef+cRuJKHCMmnCwbi/9UlZ8yHDKEwt8L/zoOjTF
	 6j17hBX+0m0G/YFnfEgHxwMnrhKY/JmZja7qlPGIEzaAmoHm0jDPCenyaTO5CkLjlV6BZ
	 02RRr3Uyhh1YnsykQCAyBY7x7glZEDfRtt8KXGO2YOXM+2jU6fiNG8rXor0NRQSCwW2Mm
	 uPuX7aTaAIWnmT4PYxBgEGOkeuzYaZFyCIqnPA7mDiJKX5VgsmdjX2pVRFDAr52nBI7sV
	 +leKvFmcLDAgJkJnYSKqH7L+z7lRLV9y5CCJVdpMxQofbadeU2m3qXKH2mBbMvvnGvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lj118Qut;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78F5606A31A
	for <linux-ext4@vger.kernel.org>; Mon, 26 Oct 2026 17:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lj118Qut
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BB11F01825;
	Mon, 26 Oct 2026 17:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793034439;
	bh=/3rJ8/Al60DrQWFoem+UA7vypW/OjaSz9+xHzh1QZzE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Lj118QutSNlev0ir+Uy2f2B3IuwexQ63tS4tEHauJktxhPsmHPyRyi7G9SuHuJ79n
	 SARnhLlKMywgYSobhhgp5+eeu5xPZVQ+boxiA9Hli0wdRJNDS2ESTqUTKZGw/W7ZMC
	 36Q45mDavwXvKLqdohw0Qxq5h/XPWmFW2F4JsAtiIDnYxSE1pNQsK7y4FuYh4F6qdi
	 kLl43159PkBFFCUbCT+1s3WHYJY4zFkpUHuwUN1FuYoLorzzkf5AeHoNnLxlzoTxMS
	 2HJpkCOXR7awTB03Ku3aqSm/NScI4S27rdy3mfOs7wP90eCOepm7w5rFrBb3PBS6ld
	 H+qitxZbmykig==
Message-ID: <sashiko-outbox-185572@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: validate inode block references during fast
 commit replay
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hamza Mahfooz" <hamzamahfooz@linux.microsoft.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261026164853.3125835-1-hamzamahfooz@linux.microsoft.com>
References: <20261026164853.3125835-1-hamzamahfooz@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 17:07:18 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> __ext4_iget() currently skips ext4_ext_check_inode() and
> ext4_ind_check_inode() when EXT4_FC_REPLAY is set in s_mount_state.
> As a result, an extent-mapped inode loaded from disk during fast commit
> replay never has its in-inode extent header or root extent entries
> validated before replay paths such as ext4_fc_replay_inode() and
> ext4_fc_replay_add_range() walk or modify i_data[].
>=20
> A crafted filesystem image with a fast commit journal and an inode whose
> eh_max / eh_entries exceed the four-extent capacity of i_data[] triggers
> slab-out-of-bounds reads in ext4_cache_extents() and slab-out-of-bounds
> writes in ext4_ext_insert_extent() into adjacent fields of struct
> ext4_inode_info and beyond the ext4_inode_cache slab allocation.
>=20
> ext4_ext_check_inode() and ext4_ind_check_inode() only validate the
> in-inode extent header and check block numbers against static superblock
> bounds via ext4_inode_block_valid(), not block allocation bitmaps. So,
> drop the EXT4_FC_REPLAY exemption in __ext4_iget() so inodes read during
> fast commit replay are validated.
>=20
> Cc: stable@vger.kernel.org
> Reported-by: Simon Brakhane <simon@brakhane.net>
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026164853.3125=
835-1-hamzamahfooz@linux.microsoft.com?part=3D1

