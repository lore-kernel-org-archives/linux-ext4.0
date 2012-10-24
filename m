From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: EXT4-fs error w/ external USB drive
Date: Wed, 24 Oct 2012 19:31:57 +0200
Message-ID: <5088260D.7080403@gmx.de>
References: <507C4BDA.20205@gmx.de> <20121019210723.GA4721@thunk.org> <5085923F.9050801@gmx.de> <20121024011128.GG28626@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:59284 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935272Ab2JXReH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2012 13:34:07 -0400
In-Reply-To: <20121024011128.GG28626@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/24/2012 03:11 AM, Theodore Ts'o wrote:
> Toralf,
>=20
> Are you using any kind of special mount options on your usb stick?
>=20
> Thanks,
>=20
> 						- Ted
nope

tfoerste@n22 ~/devel/linux $ grep ext4 /etc/fstab
/dev/sdb3               /               ext4            noatime
        0 1


--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
