Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4387189F43
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 02:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788316956; cv=none; b=Tgt+QvU+Mjdl+CePRmMr44wz95AYzSckgmB9NwW/cbWm54egKbEhVke4aP14Dn+2GCs8Q9JDb9tODgXyJXRiqU7Hy4dfOFfsxKBYdSfU5Qwlr04hCd+GPC7yVjsnPQguHLwiZL0CTixy1yypdxj62cRxu7TVXryBbDvV1Ahem2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788316956; c=relaxed/simple;
	bh=TJebWQCDqgGzpvXrgj3E8gmARffgws9Fbvabl7bbUbs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eJ3ngqn6Vz80Id6P6EbjBLyYebpZEI7uEJy/9b5CpW8Yu+Ednzko8hwaIT8BkSg5EIip3d3fLlvu8ZJd+f3wlEA0F72MhGc6wMmK+dp/A535piSYw+fvkDBXGXRRsttrcxPiLgMPeQoUa868ZM3omB43De8M9d1z8y3vf9XjfCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b1IvL0UG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b1IvL0UG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB521F000E9;
	Wed,  2 Sep 2026 02:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788316955;
	bh=TJebWQCDqgGzpvXrgj3E8gmARffgws9Fbvabl7bbUbs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b1IvL0UGYXcjHRNEDPHdjSnPtvTXk/8l4SGFaOw4jJfzjc2nhqCPoBKeKjh2OWCx0
	 7bIJUErV58i9NU+wR1F6YTZSftetSkKvBEd9nse2L9FLb3I/MQMdTskbAMjMmnoZw2
	 3k5O/mwp9uUApLx5fi9SaNWadXpy/1Pu08q4WZvldOMjAUEf3TNkk/6AY7XtPXLxcn
	 bQArUV+CMzPKPMDvVeLbmzkT7xU4aW7gloZgzBLsEft6zAEXMpRCzY8VsGK9CeaAcf
	 d9BzyHpzcwEfENeWJ+WesMn3orgNRKDq3Z2UMYSFhC1ltCGcBEpx+lrQal74uyMyGf
	 64RlmbPctWb8Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 05/12] pidfs: Use test_bit_acquire() for attr flag
 tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260901024234.135119-6-ruanjinjie@huawei.com>
References: <20260901024234.135119-1-ruanjinjie@huawei.com>
 <20260901024234.135119-6-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 02:42:34 +0000
Message-Id: <20260902024235.1EB521F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Replace test_bit() + smp_rmb() with test_bit_acquire() for
> PIDFS_ATTR_BIT_EXIT and PIDFS_ATTR_BIT_COREDUMP tests in pidfd_info().
>=20
> The acquire semantics ensure that if the flag is observed set, the
> associated attr fields written before smp_wmb() + set_bit() are
> also visible.
>=20
> Writers keep smp_wmb() + set_bit() since no release bitop exists.
>=20
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901024234.1351=
19-1-ruanjinjie@huawei.com?part=3D5

