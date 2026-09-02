Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AB0314D1A
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 02:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788316959; cv=none; b=iZDOj2lQ0ZDhLovSnSdjnShupbWjvlCPLq8e3K72x+hUhGBHhflibnYTRifrSomnMucye1U8MN1h111U1UrcN1IFud5rpFsatkwev4DMfr1W8lFxUnsQ6ti/UjksYtzSGrf9ZlqI5uVIT3oO2UEKKUOWWV/rK+IVkoLopEjnrsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788316959; c=relaxed/simple;
	bh=0vHMrOXmbhj4PPugMlPLLy7Ucl2baR2C3SQpTxJ4AZM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Fk3CeF+5auw4HurNPmF0LmmoE8ZizITfDuSkbO4erlth8hS7BYendKzXGyRIKGhz7jZ2WmviNiikHjDdBMzeOt5q7ZlAyrJMz5ZYEUl71ueCw0qohJRXLhSeiCIXvrdDl8pg1r+ziZrce6nkv1mY0VP9sF8xaxazSx5gyLfeikk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lfNQea1f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lfNQea1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7471F00A3E;
	Wed,  2 Sep 2026 02:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788316957;
	bh=0vHMrOXmbhj4PPugMlPLLy7Ucl2baR2C3SQpTxJ4AZM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lfNQea1fojWbGrU1Z543unPQi8RzozdiqxL2R7r/6V60zlTHxi3gZ1SjvTjV6VT5T
	 o5u8NWLzQ0StPVbwsPrjoKx0+d6X88upIVmBMAU4HsEg61B7mTxwQHQn4OJWZgNJpt
	 P8aKdjfXOFnKdi8S9iIzAQA65zKegAkaFGYKJyrKbaAybD0zrLZ4AioZ8d7H19O4dG
	 n5UnzSOk6DOij3pl2xQOtTvRYalsLyBD1tvxpbmWN8Q1J4FePvAXwHUxrEmWdNizZ2
	 ZUyCaO+6j1lHtNfg8DSOgI5Fyn2JlIgKJHpDl0wpyuizzXGzKhZ5OGDTERNjp8wAOT
	 SobNUSaKWdIxg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 01/12] user_namespace: Use acquire/release for
 nr_extents synchronization
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260901024234.135119-2-ruanjinjie@huawei.com>
References: <20260901024234.135119-1-ruanjinjie@huawei.com>
 <20260901024234.135119-2-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 02:42:37 +0000
Message-Id: <20260902024237.9F7471F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Replace smp_wmb()/smp_rmb() with smp_store_release()/smp_load_acquire()
> when publishing and consuming `nr_extents`. This expresses the
> publish/subscribe pattern more clearly and allows architectures with
> native acquire/release instructions (e.g. arm64's STLR/LDAR) to avoid
> the cost of full one-way barriers (DMB ISHST/ISHLD).
>=20
> No functional change intended.
>=20
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Seth Forshee <sforshee@kernel.org>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Aleksa Sarai <cyphar@cyphar.com>
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901024234.1351=
19-1-ruanjinjie@huawei.com?part=3D1

