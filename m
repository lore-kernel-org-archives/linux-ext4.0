Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0D83C1094
	for <linux-ext4@vger.kernel.org>; Fri, 25 Sep 2026 14:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790346470; cv=none; b=XBDlz1+5Ig/h7j2SzIxI4/rs9GzB0uxOr0TNGG6RWp77qh1u8Aru3j7OeGnqxWG+zr4z2gKMXtAdLs3MNcDcBnQBTly+vCgVrDFjRq1ZLdbMOzUd5DfmYMYN2MvbymQLK0IAqfqHjbpL0IZ+pDS30pwHDaUdPdPWdOCBCPPm1tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790346470; c=relaxed/simple;
	bh=zg5LUigg7XE9VDtvXFyVOvFj8K0zPSdBGPNza/Sl7AU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QMIVwNtQ22ZJq0mBBpTMwBSEiZmbfhsyj+NbNz93KF3LMG6zwJXrKRCGiJI0/Xp9WbdEX4BFQYOwuVZqELHXhQLKj7sGj788r/tYzqp3pCrCTIVuyvvcpnZfKvA0ywSl9Ct3bov9HISJwGq0+y9egJXwUvIe2bxmOJcJUkHnClE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aQrGoA0B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aQrGoA0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB451F000FF;
	Fri, 25 Sep 2026 14:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790346468;
	bh=zg5LUigg7XE9VDtvXFyVOvFj8K0zPSdBGPNza/Sl7AU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aQrGoA0B0trM6rYCU5QfIWjlgMJZNziYnqz599GaDXBZpWn7Mn5ajEqxNCjDnJ+6T
	 hfIbAO0CAxRIOASkwjBZb/62+AoCOF+7gNxk+dqMr2xfFcGMGBrBvvzpyt0+7mfY6F
	 /hiA7PBJcUCmjHIpzqCzcq+8ISN1i0vfhyVLpxugLZEeKhZ6N4AXcfXZ+10rQOus+b
	 6UFzIGcizOQHrjEaYTcAJr3Lvqtv6xeHKxQvPG0z6CVqTHYswipVEaV7cS4ZCUEba7
	 Lxr4K+4Nnikk9/LAbdfGijgw9GM0ZHXbo16QMgNnUDoTLegEVE2r9YcmqTkthMcZ6b
	 vm9zsBxLt23eQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] ext4: refuse encryption when block size > page size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alberto Garcia" <berto@igalia.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <093b40e9df29fc102907092f4ff73461f4cfcbfd.1790343958.git.berto@igalia.com>
References: <cover.1790343958.git.berto@igalia.com>
 <093b40e9df29fc102907092f4ff73461f4cfcbfd.1790343958.git.berto@igalia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 25 Sep 2026 14:27:47 +0000
Message-Id: <20260925142748.7AB451F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Encryption is not supported when a filesystem's block size is larger
> than the page size, and commit 709f0f1f1bf5 ("ext4: add checks for
> large folio incompatibilities when BS > PS") added a check to refuse
> mounting such a filesystem.
>=20
> However, it is also possible to enable the "encrypt" feature on a
> filesystem that is already mounted (with tune2fs -O encrypt). Once
> that happens it won't be possible to mount the filesystem again in
> the future, but there is nothing preventing the user from setting an
> encryption policy while the filesystem is still mounted.
>=20
> Fix this by refusing to set an fscrypt context in ext4_set_context()
> when the block size is larger than the page size.
>=20
> Fixes: 709f0f1f1bf5 ("ext4: add checks for large folio incompatibilities =
when BS > PS")
> Cc: stable@vger.kernel.org # v6.19+
> Signed-off-by: Alberto Garcia <berto@igalia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790343958.gi=
t.berto@igalia.com?part=3D1

