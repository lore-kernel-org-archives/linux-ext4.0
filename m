Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD287EB64D7
	for <linux-ext4@archiver.kernel.org>; Fri, 16 Jun 2023 19:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbjFPTlH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 16 Jun 2023 15:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjFPTlH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Jun 2023 15:41:07 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05ADA10D8;
        Fri, 16 Jun 2023 12:41:06 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C344B1C0E71; Fri, 16 Jun 2023 21:41:04 +0200 (CEST)
Date:   Fri, 16 Jun 2023 21:41:04 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 9/9] ext4: enable the lazy init thread when
 remounting read/write
Message-ID: <ZIy60MUrKxit2tNq@duo.ucw.cz>
References: <20230615113917.649505-1-sashal@kernel.org>
 <20230615113917.649505-9-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="nCY/47pJ4DONvU+6"
Content-Disposition: inline
In-Reply-To: <20230615113917.649505-9-sashal@kernel.org>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--nCY/47pJ4DONvU+6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit eb1f822c76beeaa76ab8b6737ab9dc9f9798408c ]
>=20
> In commit a44be64bbecb ("ext4: don't clear SB_RDONLY when remounting
> r/w until quota is re-enabled") we defer clearing tyhe SB_RDONLY flag
> in struct super.  However, we didn't defer when we checked sb_rdonly()
> to determine the lazy itable init thread should be enabled, with the
> next result that the lazy inode table initialization would not be
> properly started.  This can cause generic/231 to fail in ext4's
> nojournal mode.
>=20
> Fix this by moving when we decide to start or stop the lazy itable
> init thread to after we clear the SB_RDONLY flag when we are
> remounting the file system read/write.
>=20
> Fixes a44be64bbecb ("ext4: don't clear SB_RDONLY when remounting r/w unti=
l...")
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Link: https://lore.kernel.org/r/20230527035729.1001605-1-tytso@mit.edu
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Normally "Fixes" would be "Fixes:" and in the signed-off block. Plus,
two consecutive sign-offs from tytso are probably wrong, too.

Best regards,
								Pavel
							=09
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--nCY/47pJ4DONvU+6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZIy60AAKCRAw5/Bqldv6
8kD6AKC5pYtkISqX5+402YLAELMp5G2vewCePW5M1cxrWBhh7ZCoVG/gEhv+4r0=
=yqjU
-----END PGP SIGNATURE-----

--nCY/47pJ4DONvU+6--
