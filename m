Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792573606;
	b=hf2X5Uiuh6uNmOlkQEORKj2OxjWNGWi729EB1CcdUj/6LSJBCX9CC1L1cQ1XQno0LfoJ
	 xIugVhQrv3OpNs/NzlszJHeIlSCk7XL+HotPOMO9bIACIywZU37MIfv/Tt90X3HyyXYd7
	 vytOqqwPoLEduKGY1ES5oDlmeaBrxpWTU5zdFTIgx/0U0NXgqyJ1SXIgFErKm9iEV3iID
	 jkN6gXKB2M5XpuOswZaMU/HfgPn8mdRPyKa7UeFGBhVMQu5u5E5z9VBVtcGD8I7ooYK2C
	 7jmOvNsAs4BQpUXJEF49ijdLHp3khqldRlohz8fmlsTOPeVELRxMsX+CLjyHWOer6xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792573606;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0q88S8f0/kL02s/+s0j/C2ZlnDsuZotHYMPvXN7ADME=;
	b=vWcIrpmx0Jr5FHlx52nzPnZQUWgsOMzaHtmgEjmzslyrzz5rmrT1OXxriGgoyib0yYa4
	 39PBNZqC9c9i2Q0Z8s6MGCv4RZNRkynUItJprqkmtmaNf5FjBZE0grMZtN8+mdtPdrl4y
	 jntvO8ssHKNPIHDRFa33CGn/qzMz+OVQykPIAzy3x7sWNUxccibWa1suEqBiXEZ1cuuMX
	 jJpM7SEs2EqixyTHtT58marD5a4kzVT61q/dDndf06bU5zg07RZQMVHE7UbUjWe//xLP2
	 /OHOKoKFmNHH0+5sGPTpdPD44RTIkp2bWPrekG4ia+iQB9YxT58q5Q3WhPA9GOTmkhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PJMYQ1ZT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E87606A31B
	for <linux-ext4@vger.kernel.org>; Wed, 21 Oct 2026 09:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PJMYQ1ZT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1B71F000C9;
	Wed, 21 Oct 2026 09:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792573605;
	bh=0q88S8f0/kL02s/+s0j/C2ZlnDsuZotHYMPvXN7ADME=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PJMYQ1ZTSWFI4jADL+a7jzpDbgE8kgM5WODz7D8tTDTgXoQikaBK8QcHssBNCQEdh
	 1yNY1rMqcvz2tJ47pH/+6SaR+hjKOp+szNo0QFHFZkfgCOKpLuD7GPAWJKp5Z3AGpi
	 3n9ax/ngmGfqsp+mb3IQAqFyYM/Gmt2R993cXJtLkTdg3khXpJvs6/ZmR8D62qDQf9
	 OxrXnsMZoCXOflcA7XJTPi5i2Y6uIfHtY6bmx7GftRQElSv47VQUvVkfQnNQ7LTvSU
	 vEv1grlRJMPMsMJ8215NbKltT46Mge06Auzh7D8Mk9Ecta3NiQtN5+euM6RxbWpGY5
	 lILvB8IBnPG3Q==
Message-ID: <sashiko-outbox-180005@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: clear in-inode xattr space before adding the
 first xattr
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiaming Zhang" <r772577952@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261021085635.3633692-1-r772577952@gmail.com>
References: <20261021085635.3633692-1-r772577952@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 09:06:44 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> An inode can hold extended attributes in the space that follows its extra
> fields, whose size is given by i_extra_isize.  When ext4 loads an inode,
> ext4_iget_extra_inode() validates that space only if it starts with the
> xattr magic, and only then sets EXT4_STATE_XATTR.  Without the magic, the
> space is treated as empty and is not checked.
>=20
> ext4_xattr_ibody_set() passes the space to ext4_xattr_set_entry() whether
> or not EXT4_STATE_XATTR is set.  ext4_xattr_set_entry() walks the entries
> there to find min_offs, the lowest value offset.  That offset decides
> whether the new value fits and where the value is copied:
>=20
> 	free =3D min_offs - ((void *)last - s->base) - sizeof(__u32);
> 	...
> 	void *val =3D s->base + min_offs - new_size;
>=20
> [ ... ]
> Fixes: ac27a0ec112a ("[PATCH] ext4: initial copy of files from ext3")
> Closes: https://lore.kernel.org/lkml/CANypQFZzxTAH=3D4QRRDoqH6VAw1daAq88N=
DWiQKoM7QTOnP40sg@mail.gmail.com/
> Cc: stable@vger.kernel.org
> Assisted-by: Claude Code:claude-opus-5-5
> Signed-off-by: Jiaming Zhang <r772577952@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021085635.3633=
692-1-r772577952@gmail.com?part=3D1

