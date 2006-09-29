From: Peter =?iso-8859-1?q?Kjellstr=F6m?= <cap@nsc.liu.se>
Subject: Re: Newbie ext2 forensics question...
Date: Fri, 29 Sep 2006 14:03:39 +0200
Message-ID: <200609291403.43906.cap@nsc.liu.se>
References: <loom.20060929T063450-383@post.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1430960.oOxrXa2Pa1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.nsc.liu.se ([130.236.101.9]:21669 "EHLO papput.nsc.liu.se")
	by vger.kernel.org with ESMTP id S932303AbWI2MDm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Sep 2006 08:03:42 -0400
To: Dave Edwards <ext2@dpe.lusars.net>
In-Reply-To: <loom.20060929T063450-383@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--nextPart1430960.oOxrXa2Pa1
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 29 September 2006 06:47, Dave Edwards wrote:
> ...
> Is there any way to work back from block to inode to (hopefully) location
> in the directory structure this is happening? For some reason, I don't get

from man debugfs:
icheck block ...
              Print a listing of the inodes which use the one or more block=
s=20
specified on the command line.

/Peter

> app and file name (like I do with other programes), just some blocks that
> the disk got spun up to write.
>
> My appologies if there's a well-known tool for doing this; the furthest
> down I've been able to dig is the inode level.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--nextPart1430960.oOxrXa2Pa1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFHQufWkaLDtAygc8RAmyFAJ9KZ9Kn9fz4qaTmpBEn7VruOoH8hQCfaQmf
92Nn1EizxpRnQp+hu+N/+D0=
=nv1N
-----END PGP SIGNATURE-----

--nextPart1430960.oOxrXa2Pa1--
