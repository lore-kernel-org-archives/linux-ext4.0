Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79EF301004
	for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2026 17:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773683406; cv=none; b=dlsxEmjjDhlQLrL0tXRWy2seF+OI87lCieqIbHVI7dzHJQykQfYqY/Aeh65kspj++V/n86EiO9QU3CVvlewLh3aSa/Lxkw67CWuu4/0qocaSTBFSvXlNs8qyXJZbFWxBJKBWOfDTkZ6WfIRy2Ew8lwYAcd3Ghs9JhWJZAmzcENg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773683406; c=relaxed/simple;
	bh=yEA8ZU0k+k+wwmxfodELuHWd4ic/P3kdkFB7i8zvPjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sr5DftelK5piwED3IQzpVOz1bijq63Krxhcn/y85/b8ZA1FUkmC7SSvDCZOCjIAIxOL6krwGut8+GdhH3ESLIikHL08AhLl37MnszEacGDYmy7R3YzfJjWh9UFWkQFWSx9r2CLikZxXK66mvkbonGV8CnohWB178AOebw1o73l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bmPCSQoJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bmPCSQoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA342C19421;
	Mon, 16 Mar 2026 17:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773683406;
	bh=yEA8ZU0k+k+wwmxfodELuHWd4ic/P3kdkFB7i8zvPjo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bmPCSQoJvSEwFrTpc/JTRRP0l0Fn/4AoxA8KTrdyGTIRfeoQCCdTQMwwHi7BQB77O
	 KsZYbowFzrXsK3nqrleMIRo6CpGz+sVvLt8Kux/XWLtDDYHVPLPHEpX3b1ALkSrt65
	 dcVu8DsZY0JgMI4y+UEolzB6CH8vcSG467azHWkeSUFOjD4tauWHWfg9vfMRZ4JCRa
	 4iki6dlArLuv19nlUR3oIfbUf4NxO54suTe1uLwVTLs+YQFcNCUd6hOWMPnTexQAZx
	 60tTk7sZfhfx/QS0vOkg7yjyPNcF495wsY2Gf6z0zvMZ/ck3HHHuk6zS37UaC4N4QW
	 QWp+quh8IT7dA==
Date: Mon, 16 Mar 2026 17:50:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: kunit: extents-test: Fix percpu_counters list
 corruption
Message-ID: <ce9feb4b-60b9-4be2-b1e0-2f0a2828abd1@sirena.org.uk>
References: <5bb9041471dab8ce870c191c19cbe4df57473be8.1772381213.git.ritesh.list@gmail.com>
 <f6d26b93-e21c-45bf-b377-1896010e59fe@sirena.org.uk>
 <abO6o3RFQM24dYK9@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <abPh6GX0t22m628D@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0aqa5n30Fh+7Y0Re"
Content-Disposition: inline
In-Reply-To: <abPh6GX0t22m628D@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-Cookie: Not a flying toy.


--0aqa5n30Fh+7Y0Re
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 13, 2026 at 03:37:36PM +0530, Ojaswin Mujoo wrote:

> Hence this patch is needed for the immediate fix of linux-next. And then
> we can look into merging Ye's fixes separately, once the review is
> complete.

Given the disruption to other trees I've started carrying this as a fix
but that's not ideal, any news on getting this applied?

--0aqa5n30Fh+7Y0Re
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmm4QsoACgkQJNaLcl1U
h9Dlrwf/SZi3iAUOc6UdlsQAOMx9xDi+FWP7f3jrdigXXwxzZfJaagJuPG9vlMyY
xlUz0diuvcmu0GWbQ1ryK5YRGbAxr1YxOAZQQkADr445oevOWLnlpbT3mh75cU31
oTn6kwS3qK5EYegSmaPqOHn8v2aBTHWmkjyZWRL8n6bt6pri3AFCO64+r5vEnBA1
C1GssMlNWbbF7y9KSVPdAD61RA2oUNbriMfqJsob5RvtZwqxoLFayiIDlKX38GJr
bVUluyZ5So6XWHFUD20vmpZIYatVG9GHuzwmXff7Ut6VNv57BWL68yu2a/wtrOYh
kZfdMOhSKCch1cvzrchqMEFbta3mRA==
=3XZx
-----END PGP SIGNATURE-----

--0aqa5n30Fh+7Y0Re--
