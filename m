Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8513C1D60
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2026 08:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789549024; cv=none; b=MZNaTa0bEHEectQ6e5bHV5Fop0PXk24Rs3ReFEnowM9FnUY/bAibggqVSuBzIfcYchxv8DV6HkmFquAI/CFq80ivuqkFmKlIZhHuXeaj1fVCWpcAhWKoUZtnLRjZvnIpctAqI/EK2gWFscguAirLgKs8WjwJ8eJg0RhEVsA2Iag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789549024; c=relaxed/simple;
	bh=sbWK34ygieywmn9zCXD5vBBY4v4OYTo/6yMO5n7Q9FU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=W86vhQ2cvzJFyEFxJbh1RqmEIU39o/ZZgBegd9tBwi3rsZW8FychPBpKakQ2igWIk1W8VqCuYgqVRMHA7N096Ruc7ebubSjyqr1Y7np53bl6UX9y1MTDSVccsfrCujMUmdMCnVpW9Lhia12RX3xI6Gl/88FeN7Omeiw3/OpCCGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TAybVr4o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TAybVr4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5071F000FF;
	Wed, 16 Sep 2026 08:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789549017;
	bh=PV8puHwSAnGy8ZbP1s+WEAmvLRFqo5ptsGbcTEtH6Ow=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TAybVr4oyGI79Gwqggoav/jaDCqg/lX2zPMculGU/NrsDoEpUtn/p4RUCVGfatZTg
	 BaMFGh/EQH3H3novaYlHOnPLr1RYLBGoxBy3KoGguE/YjsTqi6gPqpMn98Qic6THwM
	 l0fOf946gJapvIYx/8drNoqhZmdnB0swBJk1Nq05YN1D1WDgsUUToBoHaIi8qH8Dnq
	 2BE++N3wPt6fDH9lryTT60fe279GlzKheS5RyvqWCnUO7PKqNIvyaQSqi2isJ68xEn
	 Ch2vxe6jf789XmRB9Fi4fe6Pgi1DF7ZHYr+ls1uoHgurqaYSmpMVll5buBdSQizqld
	 MYJfMgMT/kLhQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: clear in-inode xattr space before adding the
 first xattr
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiaming Zhang" <r772577952@gmail.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260916084723.877552-1-r772577952@gmail.com>
References: <CANypQFZzxTAH=4QRRDoqH6VAw1daAq88NDWiQKoM7QTOnP40sg@mail.gmail.com>
 <20260916084723.877552-1-r772577952@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 08:56:56 +0000
Message-Id: <20260916085657.1A5071F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

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
> Assisted-by: Claude Code:claude-opus-5
> Signed-off-by: Jiaming Zhang <r772577952@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916084723.8775=
52-1-r772577952@gmail.com?part=3D1

