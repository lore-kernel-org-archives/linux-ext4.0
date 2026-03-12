Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57569375AD1
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 15:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773331062; cv=none; b=XJeAyQHf7b6doqnAzhvGSwGwSRLCdg/1ZQBMiQFf4CW6RO8Ivwx2RZ6tTWXa3EPCwOsFxCsAPWm/bTaUr2n5JicUwk83qWtJXCc0vjwDdovXy4Gl0Ic7KKzcOfhhuuE96d3ArtUUaMPNzuDzc8vL/jt0YjsBWZZKFB1QmaohQnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773331062; c=relaxed/simple;
	bh=Fm2aSxMzV98RH+Z5X4lcALr/0P79BwqIvqGNbBp6APE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PVfStnxacvLD2f0HiE1iJuw41w6ZiDdfbYIHN+ZnV9Ua13oJpkM/ihqV1Y1xneNNPWhRT0g83WwuKAMVIMecQT+2sWj1ebp7Ar8ZV+lbIWQF5H27BKcjFlGm2O1fGFX7Y2PHym1VwaDxrU7Qxo05pAyotPO+zGH9fxTD8h1MsW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Scx684Jb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Scx684Jb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41195C4CEF7;
	Thu, 12 Mar 2026 15:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773331062;
	bh=Fm2aSxMzV98RH+Z5X4lcALr/0P79BwqIvqGNbBp6APE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Scx684Jb+CHAWXJbst+wRckvKFYBQ3IryhlZDRqDqxNT/aqPrznLGm9zc9M2lw/VE
	 eny0IB3LCkx12M9OlNrkC4Mfnv74Fgp5rQUCoBu5hSPTOqQqVdQ82unxyx1bP79+Xz
	 u4dTXT+spjlzIQBEb+kFoma5Mk20eE+3FTAlvjDqzTVXIUrUWsSG8OQtVwpcVAtA9i
	 45JW8axQ34jbcPENtdgmsceuguHdtTbkOb5cGj+LlxhUgqsJhoHycliwj4m+c+xawe
	 0da88Cj+h8BNB9gqXGIutlZITZQEI5G9O7LVgVnIzohZjuWy2lsPQg4eeNR0KM0pN8
	 ZU13hKDSXj7Hw==
Date: Thu, 12 Mar 2026 15:57:38 +0000
From: Mark Brown <broonie@kernel.org>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-ext4@vger.kernel.org, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [PATCH] ext4: kunit: extents-test: Fix percpu_counters list
 corruption
Message-ID: <f6d26b93-e21c-45bf-b377-1896010e59fe@sirena.org.uk>
References: <5bb9041471dab8ce870c191c19cbe4df57473be8.1772381213.git.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UwPGllpRQ4qkhmTd"
Content-Disposition: inline
In-Reply-To: <5bb9041471dab8ce870c191c19cbe4df57473be8.1772381213.git.ritesh.list@gmail.com>
X-Cookie: rugged, adj.:


--UwPGllpRQ4qkhmTd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 01, 2026 at 09:44:26PM +0530, Ritesh Harjani (IBM) wrote:
> commit 82f80e2e3b23 ("ext4: add extent status cache support to kunit tests"),
> added ext4_es_register_shrinker() in extents_kunit_init() function but
> failed to add the unregister shrinker routine in extents_kunit_exit().

This is breaking KUnit in -next which is causing problems for other
trees, can we please get it merged promptly?  Discussion here:

   https://lore.kernel.org/r/abJe1PAf4JbwGGRI@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com

--UwPGllpRQ4qkhmTd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmy4nEACgkQJNaLcl1U
h9Ai9wf/XNCd0GNUQZ14jqtJn93YcTRvkhfafF0H2B7/q+646C5bP7Om/5+5RvR0
Ekb4uHcKBcbOQu5qigjbYrLEsg804Z3cAp2aUzYUFDH7sHyVZhLjouXoFKUoDgSh
yN2XFi9lCXI8+DvrwEHHGMNfJA1u/MLtrLadqlmwR4ByVUYE2XOdvPerwupCUm0P
VqMQFeYzPdxxSIWfELlBKrcRSJdkPdcSjgzOFmnKTUqSMwS7SZpqxRZBvZMZKXVA
isay6pivlQkpy0x/USWPMJVmAeLJVn6Zg/aTu3njo6+7EVSNIOR9ixxxucm+KKBf
xlpthfYlCc8UEEn9oeiVbKeCEb+D6A==
=Grn0
-----END PGP SIGNATURE-----

--UwPGllpRQ4qkhmTd--
