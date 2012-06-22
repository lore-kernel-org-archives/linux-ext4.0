From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Fri, 22 Jun 2012 16:29:13 +0300
Message-ID: <1340371753.3363.7.camel@koala>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com>
	 <201206122007.28514.arnd.bergmann@linaro.org>
	 <20120612204128.GF12161@thunk.org>
	 <201206131944.35351.arnd.bergmann@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-B95O5XiujiIlHa+XiYYh"
Cc: Ted Ts'o <tytso@mit.edu>, Alex Lemberg <Alex.Lemberg@sandisk.com>,
	HYOJIN JEONG <syr.jeong@samsung.com>,
	Saugata Das <saugata.das@linaro.org>,
	Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org,
	"Luca Porzio (lporzio)" <lporzio@micron.com>
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47169 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab2FVN30 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Jun 2012 09:29:26 -0400
In-Reply-To: <201206131944.35351.arnd.bergmann@linaro.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-B95O5XiujiIlHa+XiYYh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-06-13 at 19:44 +0000, Arnd Bergmann wrote:
> I think using the inode number is a reasonable fit. Using the
> inode number of the parent directory might be more appropriate
> but it breaks with hard links and cross-directory renames (we
> must not use the same LBA with conflicting context numbers,
> or flush the old context inbetween).

I would put it this way.

1. contex =3D inode number for data blocks.
2. context =3D parent directory's inode number for stat data (times,
permissions, etc) blocks and directory entry blocks. Should help things
like readdir and readdir + stat. Besides, this stuff tend to change more
often than the data, so mixing it with the data in the same eraseblock
is not smart.
3. context =3D parent inode number for all the stuff belonging to xattrs.

We do something similar in UBIFS.

--=20
Best Regards,
Artem Bityutskiy

--=-B95O5XiujiIlHa+XiYYh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP5HMpAAoJECmIfjd9wqK0wOMP/0WLtrd2KQF6T1dLk1pdfsoT
C/RVafAySd/Ww9w9c8XNG4CV7I0RwHY6vVO7JmN1Z5IElvF+upEo8JXCqO+JRIRl
WeoencsjCJCXvUvv6xDzxBSxNuMQRJZ6MJ7qmqfmTssreQ3yaPHG7eOs6K5C3mIx
1PTCm1LSTA/LgF36sdF21C9DGb1ycDzndvJcRIuCEOKjO31S+SDhlscuul863MlK
3xtOtHV3pFTWYTNdEBaTQEu9SB03GXgRSMopfIB84Vx/IK8qA4nekU5U9BZ9q72n
0kh8bPjKtD6jxgS3xlJaXoQFjZdCNhIBrZnQay7MYnFx3Lu1CKKsCbEaoz0gMTNM
INW2c3w2UOaH3Ok+GYNFjcjqDXbMWfhUuDE6y4txcJhzaMejwxI3bhAukDROq27A
shnWuvtZcplqkLp9YAECAfXq6x34KHYsdT9fU7CuQ2yRvrvKgidijfZFe2+xKrbU
DJtdgZ7mvSY2ZFGViNCqa/y2kjG/MfooHZkSIh/YbSYdHUEXJ7xmmAuZOzf5XdOq
AAvcnWgS3E7g3bB2acp+hGTaefbv9fIgwzAoW/dunquIcbBdcHnLxmXSXajKS1BZ
z1PLHtIQC42xgYoHDb6w0z/jPO1j+saCCB7ekeP7Px4rvubztbIIxH58IsEoX5ZG
NJoF3aW9aeObP9AO3Eo0
=lMhn
-----END PGP SIGNATURE-----

--=-B95O5XiujiIlHa+XiYYh--

