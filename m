Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62F31C860B;
	Thu, 19 Mar 2026 15:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773933303; cv=none; b=ubqFToToOnSFlivc3wOjm40WzdQCLQppP7QcZm9YvufEo0TexngWAM3WEBYwWnGznBfbWqEuj5TYakFd24i2LYfKjjZ+jKFj4lcAFnMo/vI8gE6XSCDe0LpRHhO2LynXmCwQs8E2afG4KhDSFTU/H19uElmYqIdSYDhnydMv664=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773933303; c=relaxed/simple;
	bh=sApKhOkBup+34lkgJ8p9XDzaHOvdKBiZF+jNOasL/hM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OT264LCVPnQjO1sOV7FxDQFmWVhFljo+buy4EIvVj9f7IMRTkg6BeJjAnNKLRyUA8qVWkZtEU3p+FWnDYlGzICrAXw9FhFkw8XLswuYACxjlY9S4VDJyoWtAvjTiw7Jy7E59k0bQys3bAQX/G80QLrzGJUBNJPWvdv6k/47jaNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WUuqeVQg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WUuqeVQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFFBC19424;
	Thu, 19 Mar 2026 15:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773933303;
	bh=sApKhOkBup+34lkgJ8p9XDzaHOvdKBiZF+jNOasL/hM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WUuqeVQg40WIxAUkDJChkBWQKBkBoziERo5Z6ZXtpyVIjdlUsPqGJ0jl3uoxwqn7/
	 nun7spxaYC23vZU/pYOk9ly5agX71HO99s7r4RKb+kYEaEMDquh1gbibbeYlbQ7kOw
	 VXhjKdKHR4nCFpY6nmKfomlSPvK/AFsqJYf6wrMom2GBcat2FBdPkLCuBzNGDajEFw
	 7PYAzhnzlLLni/jp8TCY4rG7NVLY3UUiLf+JF3cX0gC1HezN2+hI8eUkNN7Eruz29U
	 WwAclZn92n+PEnAGPukYXwfg2HcidoL74axqyd5+LxU7EISXeiiBIxfl9E1AYUfzXo
	 DhV3p2zT/gsKg==
Date: Thu, 19 Mar 2026 15:14:58 +0000
From: Mark Brown <broonie@kernel.org>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, Jan Kara <jack@suse.cz>,
	libaokun1@huawei.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/8] ext4: Add extent status cache support to kunit
 tests
Message-ID: <a333c3bf-5344-4cc9-aabb-e1502945b7f8@sirena.org.uk>
References: <cover.1769149131.git.ojaswin@linux.ibm.com>
 <5f9d2668feeb89a3f3e9d03dadab8c10cbea3741.1769149131.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Nxxu/amzl1X78y7o"
Content-Disposition: inline
In-Reply-To: <5f9d2668feeb89a3f3e9d03dadab8c10cbea3741.1769149131.git.ojaswin@linux.ibm.com>
X-Cookie: List at least two alternate dates.


--Nxxu/amzl1X78y7o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 23, 2026 at 11:55:34AM +0530, Ojaswin Mujoo wrote:
> Add support in Kunit tests to ensure that the extent status cache is
> also in sync after the extent split and conversion operations.

I'm carrying a patch in -next that fixes regressions that were tracked
down to this patch:

  https://lore.kernel.org/linux-ext4/5bb9041471dab8ce870c191c19cbe4df57473be8.1772381213.git.ritesh.list@gmail.com/

Any news on getting a fix integrated into the ext4 tree?

--Nxxu/amzl1X78y7o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmm8EvEACgkQJNaLcl1U
h9AR9Qf/dmtJi/R4cTmV6XIeguWNB01Y/jgk2BOc7b+spJDl+XxVErhH6k0lDuhR
EM549Jc8OTmeorAJKc/9IYJ9E0LKHRatgJC3TGKr2nyhjAhLycSgy4I+QrxDMrMO
hX2/Ecxy6EYr8mM0hSqtaTKZmw7byccrwVwVo6tSXkAb74LBruXlNaY9kSyYV4La
3ea3MNyO7fuyWaTydUrb4YN58urvmHwxc08/djNojwtSHGntCRwtuHuuAUMbqNmD
/Nmc8fRHISD7rHDpVeMLjKG/WxptY0bCN6dtzpq/EsxPTaa/gA+xitgGJvSvjHUw
wvUkJcdPswCeGsQSVgoQT+j04aAVlA==
=MUmj
-----END PGP SIGNATURE-----

--Nxxu/amzl1X78y7o--
