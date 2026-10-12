Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BFE32B126
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791802303; cv=none; b=I+hbrcW4gYbcOpUGtrn6glhlLrAYlMYCHJz3qbs3MpHiHAVn5Dl8Dd339lDu8l603PHkmsTtXTenRi1z8g9le3rUNAAQZJfm8h6g+vdFaq7urKvABxN0YQi6gaGvcr1SBntQIUrLer7S5UjaoFqY5fyGJzQx1wrDT4Iy7R98ew8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791802303; c=relaxed/simple;
	bh=0YdChC4C8lZXXqt6NyYkh0uc3O6h2v684QzX4eup/TI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=gF5A+b0hzJw1VX/JpkdE8I2ILmAglA1H5/zGVyOtIHGHK9qUnSGXLTmWSpPiNW1FSRF7qM/6nC2uiMNUS6N0hW/7V3NPp2DMALwoN14X6orBLxYKDer4yhOhT4W5lE+TDyKE0AZgY8ETpJ1/H8LRbRVEWTUr5JnJjHCApHh2H7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hbbKBB1S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hbbKBB1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B384C1F0089B;
	Mon, 12 Oct 2026 10:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791802302;
	bh=0YdChC4C8lZXXqt6NyYkh0uc3O6h2v684QzX4eup/TI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hbbKBB1SKCqDdzMy+BxZwV2PVE834nS8bVgZztW5pHhxqukmrujs2u0blaC1KBMw1
	 sT17e89s/Ix07EbAwAYO1hGzOrJs3GtL45mKuhbOtuwS+T3JcPdibYxl/WUNnKanal
	 PZFWAHeMx1GOzT1ot7vIOjm9zQ1R+jsVhWgrIaUSF6aaeLY/C+WqXBjXNTN3/ZWwlB
	 WKJhtS0211aCjfExlAALhso8cD0lNOLnjxTIf1xRTfYbloUNRRNYWEzvD8eRloWBXW
	 akfLpkeHpsXSKTLx9PNcTUmjAqEQt7hhtsgxAdYJLXH4zuTnmfJJlt7kmU24Q3ublO
	 V8aoTYWqeAvhA==
Message-ID: <sashiko-outbox-167989@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 28/28] selftests/filesystems: test xfs remounts
 after a shutdown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Joseph Qi" <joseph.qi@linux.alibaba.com>, tytso@mit.edu, "Joel Becker" <jlbec@evilplan.org>, linux-ext4@vger.kernel.org, dsterba@suse.cz, "Mark
 Fasheh" <mark@fasheh.com>
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-28-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-28-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:51:41 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Add tests for remounting xfs after FS_IOC_SHUTDOWN with the default, the
> logflush and the nologflush flags and after a shutdown that the remount
> to read-only causes itself:
>=20
> - option-only remount keeps it read-write
> - remount to read-only works
> - remount to read-write fails with EIO
>=20
> For the last variant the image lives on a tmpfs of its own. The test
> punches out the log and shrinks the tmpfs so the log write during the
> remount fails with ENOSPC.
>=20
> The tests need root, loop devices and mkfs.xfs.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D28

