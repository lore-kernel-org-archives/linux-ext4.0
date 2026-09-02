Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0CC34B1AD
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 01:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788313157; cv=none; b=nz5537j5N2Q4ZZ0tIUluzckGsyBcIj3rTvtncwugKu3y35600k4h8jyeSqnN3nbifecxu9+2Zlwch8IJZ1Iw8F5ToRloM68C7bEt1v4Ozsfpu/aAyXvElxx92UFsJp2QgOuFW9hWhwZRdQNMOvTjLKifQxR7Drnnn+VlxSC7dSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788313157; c=relaxed/simple;
	bh=ph35yuaPbe4a1kRl7n0wA80CztQRGSsQgXbFgGsU16A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dQgpa3VY6MEjOL6av1Ox5T1nTXEFto2VkdLTyVR+4NrnYE833edz0W0HY72aWnkM8ONnuQ6eDs/ba+ODRDPgU6x31JztDIG46b6uXhbofsgS4Tr3uZEmFwg2che92VuG7Zm6dAVgbC3Ro5RbngDuuUgnkII77RE5UPetg9pxxBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lEkl3wXM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lEkl3wXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFBD1F000E9;
	Wed,  2 Sep 2026 01:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788313126;
	bh=QbfIMJiwoyftl/CQALHTWP0e8YvdmzJFWnfhR9AF5VE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lEkl3wXMx5n1hEw6VyjpgYJsW68CNVnyY5P88sOdFidkjxqppY3JSlRyjeAxWCvNw
	 MElrSGMf9Ho+OpNn73tXNLlGW7tf1SaWsJso9GZNLBSpYp9V7rKGBd1fsX6SZbZjom
	 KKTj6CdHw4BzVS0b8fKX8+KeJnJ04B3Uhs+lDubWgMpYMXzJupsUDtPPF44z/nnRjr
	 tk644zCjI0Auc/IdMUUqtnneRvfUTKKMQ2FIPDGbGfmuZJX9yMg62Udh/x9ycsKLOQ
	 tKZIwcb130r42LRu/X8HYooDCbF5Y+t+oJSQHlG5sAzcqHdq+oEFs4QpKCiNHb4pR9
	 5ZUDQufi0pvRw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] buffer: fix NULL dereference of bh->b_folio in
 __bh_submit()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joseph Qi" <joseph.qi@linux.alibaba.com>
Cc: "Mark Fasheh" <mark@fasheh.com>, tytso@mit.edu, "Joel Becker" <jlbec@evilplan.org>, "Joseph
 Qi" <joseph.qi@linux.alibaba.com>, linux-ext4@vger.kernel.org
In-Reply-To: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
References: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 01:38:45 +0000
Message-Id: <20260902013846.5FFBD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Commit a2c924c240e7 ("buffer: set BIO_COMPLETE_IN_TASK for dropbehind
> writeback") added an unconditional folio_test_dropbehind(bh->b_folio) in
> __bh_submit().  But jbd2 shadow buffers have a NULL b_folio since commit
> 5febcba29792 ("jbd2: point the shadow buffer at the frozen data
> directly") made them point b_data at the kmalloced frozen data rather
> than a folio.  Submitting such a buffer during journal commit oopses:
>=20
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   RIP: 0010:__bh_submit.constprop.0+0x87/0x120
>   Call Trace:
>    jbd2_journal_commit_transaction+0x932/0x1b10
>    kjournald2+0xb2/0x250
>=20
> Hit by the ocfs2-testsuite fill_verify_holes test running with
> data=3Dwriteback.
>=20
> Dropbehind only applies to buffers backed by a folio, so skip the check
> when b_folio is NULL.
>=20
> Fixes: 5febcba29792 ("jbd2: point the shadow buffer at the frozen data di=
rectly")
> Tested-by: Srikanth Aithal <Srikanth.Aithal@amd.com>
> Tested-by: Luca Weiss <luca.weiss@fairphone.com> # sm7225-fairphone-fp4
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902013357.2815=
214-1-joseph.qi@linux.alibaba.com?part=3D1

