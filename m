From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsck doesn't repair broken ext4
Date: Fri, 12 Mar 2010 17:06:53 -0600
Message-ID: <4B9AC90D.6040904@redhat.com>
References: <20100312205435.GG32664@alea.gnuu.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rg_Sommer?= <joerg@alea.gnuu.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933282Ab0CLXHC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Mar 2010 18:07:02 -0500
In-Reply-To: <20100312205435.GG32664@alea.gnuu.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

J=F6rg Sommer wrote:
> Hi,
>=20
> after a system crash, I had a problem with ext4 that e2fsck didn't fi=
x. I
> don't know if e2fsck or ext4 was wrong. In the end, I had to remove t=
he
> broken directory, which succeed and solved my problem.
>=20
> These are the steps I did:
>=20
> 01 % e2fsck -fy /dev/root
> 02 % dumpe2fsck -x /dev/root
> 03 % e2image -r /dev/root

Great, thanks for gathering the images.

What version of e2fsprogs were you using?

-Eric

> 04 % apt-get install
> 05 % dmesg
> 06 % dumpe2fs -x /dev/root
> 07 % e2image -r /dev/root
> 08 % e2fsck -y /dev/root
> 09 % dumpe2fs -x /dev/root
> 10 % e2image -r /dev/root
> 11 % apt-get install
> 12 % dmesg
>=20
> I've put the output and images of all these commands at
> <http://alioth.debian.org/~jo-guest/ext4/>. I hope they help you some=
how.
>=20
> Regards, J=F6rg.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
