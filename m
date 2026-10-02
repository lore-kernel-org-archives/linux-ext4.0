Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BDE3E122D
	for <linux-ext4@vger.kernel.org>; Fri,  2 Oct 2026 11:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790942261; cv=none; b=sDITMhR84JolPEPVCovtizR6Y04vkxEOWXUOpLNkGupC0fAYTF6oNFipD3rnOiGKnDKcHmiOpPRyovpATvo5dhO1yTFpdrCbMOLG8pKkOE7Pizk3mxBl2eMbFn/Azj52RiFeUwS4O7okCriBlovLKarVFWMbhc7oVXy8ncvzsA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790942261; c=relaxed/simple;
	bh=jvDnz5oj4xlcmYJXIwy/sSva0JwAm6mUKN3/G0wr4WE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aUn5KWfFpGAyTkZ6L1DZMO0BH0vHbFWsORqCM94ptEa/wlJyVNdQMMzz29o4YIAoinQ5c323W5zd3DuIBXOSMFK4hce7A8fnKrjkmqjMMHeEHpKVdmjZDPjPGudVbHmpga5aJhjcuZRYrn2A0E9xKun/DYKZ48lS4ZDv8NOIq+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CrFOoAx4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CrFOoAx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE221F000FF;
	Fri,  2 Oct 2026 11:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790942260;
	bh=jvDnz5oj4xlcmYJXIwy/sSva0JwAm6mUKN3/G0wr4WE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CrFOoAx4osTUY7wM51bROpv4+DS3aRGAqD/3emrn64Q71FMjBEuh7hXfbaElGhEXn
	 9M7H2l++0jPSNyu3vF1K2oAWcursBnlJyZpNewo9+ZhM0i0Yakrfy0+WiCW1r9Uysu
	 esJz0qD/Reitq78PM0IvNLJbVzu5kuAniljp4qzVDi0q5PFfAnl2GS9wWHJTtlC2rI
	 6V+Gc60vY924aIutpObyy/tVUiIpveZXlD//6yzcgeYWDq4gKfQ3TjUuyrU4CtzBy+
	 7AgDrMmAXKjv8p97WDOpPrs8JkmBxMFR03GY47jfd2JZh8B/PGIhFmu/10HqelRsFj
	 VxbjhySInug3g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: Fix maximum orphan file size check
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Kara" <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261002115040.2783654-2-jack@suse.cz>
References: <20261002115040.2783654-2-jack@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 02 Oct 2026 11:57:39 +0000
Message-Id: <20261002115740.3EE221F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Mikulas reported that e2fsprogs 1.47.4 with 1k fs blocksize by default
> creates orphan file of the size the kernel rejects. This is because that
> version of e2fsprogs creates 2MB file by default regardless of the block
> size and with 1k blocks that's more than the limit of 512 fs blocks.
> Fix the check to make kernel accept any file upto those 2MB regardless
> of the number of blocks.
>=20
> Fixes: 7c11c56eb32e ("ext4: align max orphan file size with e2fsprogs lim=
it")
> CC: stable@vger.kernel.org
> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> Link: https://lore.kernel.org/all/e65cdbfe-3ff9-4638-fbd3-4d8f8880966f@re=
dhat.com
> Signed-off-by: Jan Kara <jack@suse.cz>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002115040.2783=
654-2-jack@suse.cz?part=3D1

