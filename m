Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEE52F0C79
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 02:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788316960; cv=none; b=LcxxBmot++SfojTU/ru8rLco5AGxCKPlA+75ZcaF4AIJOUZYIDabEAI2J2CINBGyXWu64hmzLBrdtL/pi6zeU6HZaUZ4QASKfMNR3R6uKqFRftinN75f60fzYn2ZIZqBiTI8OQRLcG56PL0cUlMcW2I801c7SSWEEmNmEvcGUPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788316960; c=relaxed/simple;
	bh=gDiOo3JmDfqiFi1937A4+Zzw4GLSgl4cQ2JuTFtRAv8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UVq19QxaZqMIzevGHec6kelTtlBmchNwx7jnD+w3OixGXYruXcl/RSATl8CrSIJUZIKqd7OmVGkRMJjeRoQJ8zMBEz7ZeDqYUf1a8CuwOS7Fy26iZiuA3dwzEx6Q19ObtBzrJ3mzyfT+ATWLVGjprHLSycS9J4JeAf3elKmTiU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SY20uZNq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SY20uZNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19ED1F00A3A;
	Wed,  2 Sep 2026 02:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788316955;
	bh=gDiOo3JmDfqiFi1937A4+Zzw4GLSgl4cQ2JuTFtRAv8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SY20uZNqu5RDiENEnRh8pLvNqd6LruRGa6IqjKktec4nWhmprdkotg41nhv1eT5ps
	 xdtKGkGy3dLPaoxl0FOzaHOqXZNnNSg/+aeG+0nlNaEtQEpksVH+aJguPoHjTQ1SmO
	 sGydfFMikO9Y7F3OFAAjAewYvfhn16+8FFrBnO2xVc9LX3w4KkQhy5a/+kiYBxajql
	 K/oWX2HEy+5LTmSkEH7A6FM9iRLilz1KqRTxm/6KkVTiR+fCzYBj3zXWlg47WeYyGp
	 QwMX0MS5ezja8m0UKRGMKQheV92uSJE7QkmBvLpaeJMEHG0uFL0lw6+QPPe7mwZlv4
	 tQh4NpG7ASoNg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 02/12] lib/vsprintf: Use acquire/release for ptr_key
 publication
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260901024234.135119-3-ruanjinjie@huawei.com>
References: <20260901024234.135119-1-ruanjinjie@huawei.com>
 <20260901024234.135119-3-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 02:42:35 +0000
Message-Id: <20260902024235.B19ED1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Replace the smp_wmb() + WRITE_ONCE() and READ_ONCE() + smp_rmb() barrier
> pair with smp_store_release()/smp_load_acquire() on filled_random_ptr_key.
>=20
> This expresses the publish/subscribe pattern more clearly and allows
> architectures with native acquire/release instructions (e.g. arm64's
> STLR/LDAR) to avoid the cost of full one-way barriers (DMB ISHST/ISHLD).
>=20
> No functional change intended.
>=20
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901024234.1351=
19-1-ruanjinjie@huawei.com?part=3D2

