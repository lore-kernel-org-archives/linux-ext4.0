Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2354423ABB9
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786702571; cv=none; b=nNxZ+nR05aBxLthcy1/H6iJuw+Ua/BYlxGrdy3akGyiARhQYvxZtfpHX0hR37PkWKZldF/WZd5lSFDdvUR/LJlXwQOq2E2G5RdYNT+oECwi9c6jE2dXlDco/lkKRNME2PJbqLWUtZ+X3zLz30kvQemK6eEFxoFFmNV6P9gGjYUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786702571; c=relaxed/simple;
	bh=UE+3f++M8NhsYlZ+lfljcqQgJDQ7xq0pXW4kWNrNU+c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iYR0R4vBv0K6JF/YZyJ67np/yR5+EqfVMRuYeBxf6KoiNhsgUvIR7rwxR5mDjFqEkKrGB+SUDIEmfl+/xASzT/ooZ2LS8Urqs8V+gOY2AnvP1/iDyV+7aLKKRbxKQ8Rp0YsBiTrqR/3zzklFpzroB7eSwL6zCv7Xx30p1tkoPD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xf2L6QXl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xf2L6QXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B341F00A3A;
	Fri, 14 Aug 2026 10:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786702560;
	bh=UE+3f++M8NhsYlZ+lfljcqQgJDQ7xq0pXW4kWNrNU+c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Xf2L6QXljC711vXTKuNE7fwrroJFUu7T5hf31pYhZuWBpzmDUr6a0rChjhWnVsbaB
	 d0Ledznj95f/rIxmucyCrG5gn4/t0aI2YImN7FUkm6bNPZpr7y6NxR/A6UT46zttov
	 lu1EOdI5OCh6Kurq07ua/38/K+vQXwkB99s8XODXKmxsZJbWls2rHpuBxG7r3LkX9z
	 BttLf3DrJi10yXeQ4JtDV9hsfBPqW/5yQvs7kuTY14ChXRjsTGbLries8fx50Ixjhc
	 8huQXWdOO8JrOtLjoXz56ROGEjHh6DLL8A76NAKTom7o8j2/d/c51DKDL9//0h5GGi
	 e6QU8urBX9Tvg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 09/32] ext4: avoid unnecessary transaction in
 ext4_map_blocks() for unwritten extents
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260814093331.1703882-10-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-10-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:15:59 +0000
Message-Id: <20260814101600.04B341F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> When ext4_map_blocks() finds an unwritten extent in the extent cache and
> the caller is willing to accept unwritten extents without conversion,
> there is no need to start a journal transaction since no metadata update
> is required. This avoids unnecessary transaction overhead in the
> upcoming iomap writeback path when overwriting already-allocated
> unwritten extents.
>=20
> One thing to be careful about, as the comment in ext4_map_blocks()
> states, if the flags contain EXT4_GET_BLOCKS_CREATE, the function will
> mark @map as mapped.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D9

