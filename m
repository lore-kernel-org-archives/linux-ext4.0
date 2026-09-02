Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAF33DCDAC
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 07:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335720; cv=none; b=oJ1FTUweSM9kbbd3a8oC/hksJz5LuyzRYfUNofKhfIrnGgFW4klk7dkFpxJE0TnZHh7fTpWSNYO3s5Hz0GYRUF/NTtWNSL2MVLKoXrz+raK/g0HjE4uk9eEmqJyvoP+QaI46I2NmzMzp3dOzR4fMZCwIQJ9PrCs+UTnFw3nU6JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335720; c=relaxed/simple;
	bh=m7kMRyZO8bs5BX+6fuUGLgyiXBLTZYMzP++T4tB6QHE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ipElkyYsmaF95XXNc0oYIJ3+SsTqsoEUCy0tiPQnb2LO8QejQIGmIXLRtIYlfpXvS0vQojA8PfN0LjPIbeavgJea2Ln4ifLOfwGOQHGG/RHeEPhtycYd+tZ8fVnUPQesjZjWuAoVqiI+jaoI1esKGDfSJJxutJ9HgY/bnkYCUoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AtG9Ltp3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AtG9Ltp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C507D1F000E9;
	Wed,  2 Sep 2026 07:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788335719;
	bh=m7kMRyZO8bs5BX+6fuUGLgyiXBLTZYMzP++T4tB6QHE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AtG9Ltp3gGI4YryjH6iv5ZbZggIxI3CCbVYIVxJMWKgzWsMb4hxz9LBx+RrbXbPN+
	 vko2tzbmSAX067nZCrx3c2XYSka1d2EDuUkEC8Z+6zmBBsmMN2PBmk9xxaHFq/Zpku
	 fTMORE4upxx7bY+vdTDcD5Jsc5g/gzRR05WmdJWDX2nruRddQDDCNCOf/A4YGgJHVk
	 lkCVsVW2PHQ/OF4LVYw0m0PTEzUtFXqRgrgC5/C/vBEKtw7rZ+usOFgBFZcO964SAt
	 VsYAO3w8mWFdJ1AZoy43crqAMUjSiMoIRkB7WiiTSylkQJOX1C3kqdZGnW1wUkZLSG
	 uplG2PPdOjG3w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 5/8] pidfs: Use test_bit_acquire() for attr flag
 tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260902074805.398540-6-ruanjinjie@huawei.com>
References: <20260902074805.398540-1-ruanjinjie@huawei.com>
 <20260902074805.398540-6-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 07:55:18 +0000
Message-Id: <20260902075518.C507D1F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902074805.3985=
40-1-ruanjinjie@huawei.com?part=3D5

