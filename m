Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99B854EEAA
	for <linux-ext4@vger.kernel.org>; Tue, 22 Sep 2026 14:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790085668; cv=none; b=FxEE92iWCJqtp+FY60e26aNYDHZPBUs2rqLORTrDRb2+y25TquQ+4fOkdIUfe+FTEhEqAfarXAoUqN2XoRvBFjFcy7JMqGAu1+vSpRFq71HglzHSWLgxx+4ptlr1nAJ7dmSVrHBCWt4eVAnfc6citMpy+0IbMWoYynNjo4zc3aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790085668; c=relaxed/simple;
	bh=4UF6nc5BCz9zx+xSLGS7HQ/9U3cADukSxTifJALDbXY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=W+jtMaqa8/NzterQPMQ++HroCuW/k2JJ0JotPg3cEy4e1FsBUZuIIIAiy1R0reYyPcJm4iNlxqAArf+ubsQPMJP80kSiytnyxvQzo3M05yCT63CuJ4tgPqooshj1TCLg29toQQi8JcnOb8i1p10lndVpOGn/VHq+QKjlzSUQinA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h7WR52ca; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h7WR52ca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E461F000FF;
	Tue, 22 Sep 2026 14:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790085666;
	bh=FFcqg1qDX+6Pz/sQ55AdRyfwPXFOZ1CVcICQMme7w0A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h7WR52caoqndLqH/9CO1uuj4e659NlBy19g6vRcnsJYdaxfV+gP6z/py0GNe2w44z
	 6p4TOqhIELGf7cy3r9TIxKp5f93FGyGNDqmOWRwtfWL6AvsA6Wsnyj0UCUUB44pmn+
	 aEt4uKNXMfV5B/m672C45kzNZZAa9vAlL4JvK4oyegkmYx7hFxyQnd06OoTlQWUmFm
	 COYVXMGDWr+1T/GRuIX8L3zEDYJg54r0waVrWcX8/b10e8s9vId1jpl7JKcsNgvqwE
	 mN73+oQQ9rmL7lEWTWOH3nlCEtsNyrZFwmItvjKeBMdeva4m0eqpbb883+27UUGzSL
	 n6o0hL2YTLY2g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: Fix sparse warning in extents kunit test when
 EXT4_KUNIT_TESTS=m
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ojaswin Mujoo" <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260922135808.3371159-1-ojaswin@linux.ibm.com>
References: <20260922135808.3371159-1-ojaswin@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 14:01:05 +0000
Message-Id: <20260922140106.34E461F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> When kunit tests are compiled as modules, the extents kunit test emits
> a sparse warning:
>=20
> >> fs/ext4/extents-test.c:59:3: sparse: sparse: symbol 'k_ctx' was not
>    declared. Should it be static?
>=20
> Fix this by declaring it as static.
>=20
> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversi=
on")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202609221900.Pgwrcp41-lkp@i=
ntel.com/

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922135808.3371=
159-1-ojaswin@linux.ibm.com?part=3D1

