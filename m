From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 0/4 v3] e2fsprogs journal fixes (UUID and 1k block size issue)
Date: Mon, 28 Jul 2014 14:07:44 -0600
Message-ID: <44E07A0C-5817-4F0A-A58E-87FC2627846D@dilger.ca>
References: <1406533405-6899-1-git-send-email-a3at.mail@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_B2B66702-7479-4A1D-9023-4BD756B82121"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, darrick.wong@oracle.com
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:63950 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaG1UHv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2014 16:07:51 -0400
Received: by mail-pd0-f182.google.com with SMTP id fp1so10481268pdb.13
        for <linux-ext4@vger.kernel.org>; Mon, 28 Jul 2014 13:07:50 -0700 (PDT)
In-Reply-To: <1406533405-6899-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_B2B66702-7479-4A1D-9023-4BD756B82121
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jul 28, 2014, at 1:43 AM, Azat Khuzhin <a3at.mail@gmail.com> wrote:
> Here is patchset with some fixes for journal code in e2fsprogs.
> I've removed first patch from previous version "lib: add EXT2_ prefix =
for
> SUPERBLOCK_{OFFSET,SIZE}", and rebase other patches on top of the =
maint branch.

Any reason you removed that first patch?  I thought the only negative
feedback was because you renamed GFS_SUPERBLOCK_SIZE accidentally?

Cheers, Andreas






--Apple-Mail=_B2B66702-7479-4A1D-9023-4BD756B82121
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU9atkXKl2rkXzB/gAQJ/vBAAgM5gMt5AZL8KSUIYP9awOWCZTBs3j/wp
h2IA6v7QMNPvmxre6GP9oXAOXLtNOt8zv/vXTUgY+9/y6DEhxQ2nI3Rc+OsZdf/t
sQFOobKCujRr15ELDZ1wrC4RzzZ12Ce9sy4MWfW3AanzC2WF0oYwktq5bS1VW7Il
UoC4+CcvWuEtyHIINRWWIW1JAojsaOdeFM4l42KUy/5u5CMJAY9Aw45gf9H0snhj
hhLCtW90soEiBL9VPmj8M65ayYlRbiiFlvuIZJX/WNbJ5Fi2FrCnGmhdZG0+Nsna
XPiDhTFc4dFyP/RVMaElJQrfIDZjkWXNII0EVyD7vmQZlKQuobVhRYAgoviadbx5
AvIY3fTqYbs4we1OHM/BGvwpG22sNO2DVjif5TUjK2KRXbRTeUGHganfj/4Ghlfp
j1/vNm7i6rfJYN9pGOh/0d84+fDzNeUI/kXWGrfMnSOkuJAYKiT4vUJfjt3OYaNd
aXIufRfXZ4rtdR99m6mZVU7p5Etp9zBJGnSqjmnk5U8hcKhKyjTdfQUMNcpjzP5Y
YirkW7+oH7ZMmdcuwx+2IZxPxAK8uRnGKcVB9AWabTxAdE1Z42872cug3t2Z+PTL
u7SCUJl/f2VJwtL7WhQyaIpmWdE0UK5zcMVII3aoRkAB6CNOzxRyg1hLTk8vDmGG
WtuI0uZiVaI=
=q7qE
-----END PGP SIGNATURE-----

--Apple-Mail=_B2B66702-7479-4A1D-9023-4BD756B82121--
