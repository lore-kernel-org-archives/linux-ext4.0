From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: Regular ext4 error warning with HD in USB dock
Date: Sat, 8 Jan 2011 09:05:20 +0100
Message-ID: <20110108080520.GE12433@bitwizard.nl>
References: <201012280953.46149.kernel@kolivas.org> <20101228025343.GD10149@thunk.org> <20101228081917.GA1351@bitwizard.nl> <AANLkTim_5Yx1RQFHYbmh40xx7c5sU9XsXZEzegC4G=1x@mail.gmail.com> <4D1F6244.7050203@redhat.com> <AANLkTimAe-p1-ApmnueybQY474J3_G9JL+8WJ2WTn+04@mail.gmail.com> <20110107052613.GE2857@thunk.org> <AANLkTinyc+H7t5yF8w81XXts0jfbdt4ROWM8MHEUjNeD@mail.gmail.com> <AANLkTimFA9Can0Oe39Jkw+1X6uxwsgNVW2aKPoV_VLoq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ted Ts'o <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	Rogier Wolff <R.E.Wolff@bitwizard.nl>,
	Con Kolivas <kernel@kolivas.org>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.101.171.8]:38619 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750858Ab1AHIFW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Jan 2011 03:05:22 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTimFA9Can0Oe39Jkw+1X6uxwsgNVW2aKPoV_VLoq@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 07, 2011 at 11:07:23PM +0200, Amir Goldstein wrote:
> On Fri, Jan 7, 2011 at 9:41 PM, Amir Goldstein <amir73il@gmail.com> w=
rote:
> > On Fri, Jan 7, 2011 at 7:26 AM, Ted Ts'o <tytso@mit.edu> wrote:
> >> Am I missing something? =A0The kernel stores up to 3k worth of dat=
a, on
> >> a 4k block file system. =A0Whereas e2fsck patch blindly assume 2k =
worhth
> >> of data regardless of the block size. =A0The kernel patch looks ok=
, but
> >> the e2fsprogs patch seems badly broken....
>=20
> So it's not badly broken, it copies blocksize-2K, which is clumsily
> written like this:
> +	int len =3D ctx->fs->blocksize - 2*SUPERBLOCK_OFFSET;

So this should be:=20

  int len =3D ctx->fs->blocksize - SUPERBLOCK_OFFSET - sizeof (<superbl=
ock>);

Although those two numbers are equal right now, there is no reason to
assume that they will remain so in the future. So if the superblock
size (or the offset) changes in the future, it's much better to have
programmed this so that it will keep on working as opposed to getting
to deal with ugly bugs in code that hasn't changed in years...

	Roger.=20
--=20
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998=
 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233   =
 **
*-- BitWizard writes Linux device drivers for any device you may have! =
--*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous stateme=
nt.=20
Does it sit on the couch all day? Is it unemployed? Please be specific!=
=20
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
