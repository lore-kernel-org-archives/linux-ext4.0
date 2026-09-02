Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC8A1E5B9A
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 02:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788316960; cv=none; b=oiHqaxL+BsdBYas8iW2IhdVCx9Sw+8Gdd9KeUctleFDL30wzWIf3CWDBqfD3/As7b9usmzmUzfsM4AR3BuBp/4J8aPrQvfBa9hxklAkh4F561YWGr088exdOMKwGZwG3fdYlq1BwOkUpARBO4uoKMSFN20t1IiisLGrc5s3O/o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788316960; c=relaxed/simple;
	bh=iOb6gG9wdrjDbYTYKxOZniWuPQkv2kPYwd8PEeBBFRo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bA1MX9NiIaobqtOgQtabZDWI6yQDDEIxARejQcaIOZBzqL6iuEARzQoSksuBsrjUuMICxOdA1D9v5pzn+spQizq5lcugUTSTIMBRi8jA+GTGQ56kvOk3Orjs8XtZ2abe0EhhtS9h0b00pZJqlE5PKFmIZZds6DacAu0TivvY2tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jztzsQ8P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jztzsQ8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188231F000E9;
	Wed,  2 Sep 2026 02:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788316959;
	bh=iOb6gG9wdrjDbYTYKxOZniWuPQkv2kPYwd8PEeBBFRo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jztzsQ8PQk7NJTjhUCnpkauAWq0i+TUVI9ge5VepkHqXY4pR+tvCyMkDC9XBYSbuF
	 IlilZnn9YgYk7PiN2cUjeP8UxFC/0fw4dWQm8HkgxSyF2dPzGRK26ef7B/wX/hHEZj
	 9S1fdk/Gn6nK5aYefqO7LCr5JaxlQtp21tIr+dOswmHxDzv+XJki0ErM29JuDJwlZw
	 dUqIXT2oAtjDxcXiShmQsHFj+nJY41O1s9fNA+1O8CRzoGubgXlMPnvIjTBFP0Crtz
	 IbJ5a51gncsab57lTj1SWX6lYMLa3fmCvakdYdUmxoA9oRAc9873zSB/3uTv+fPXjW
	 q8TZqFOGgO2PA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 04/12] fs: Use acquire/release for fdtable resize
 synchronization
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260901024234.135119-5-ruanjinjie@huawei.com>
References: <20260901024234.135119-1-ruanjinjie@huawei.com>
 <20260901024234.135119-5-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 02:42:38 +0000
Message-Id: <20260902024239.188231F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Replace the smp_wmb()/smp_rmb() barrier pair with
> smp_store_release()/smp_load_acquire() on `files->resize_in_progress`.
> The flag is the publish point for fdtable expansion: writers clear it
> via release after rcu_assign_pointer(), readers check it via acquire
> before rcu_dereference_sched(). Observing it clear guarantees the new
> fdt pointer is visible.
>=20
> This expresses the pattern more clearly and allows cheaper one-way
> barriers on weakly-ordered architectures (e.g. arm64 STLR/LDAR vs
> DMB ISHST/ISHLD).
>=20
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901024234.1351=
19-1-ruanjinjie@huawei.com?part=3D4

