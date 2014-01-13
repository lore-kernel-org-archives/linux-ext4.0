From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH RFC] Add support for new compat feature "one_backup_sb"
Date: Mon, 13 Jan 2014 13:41:27 -0700
Message-ID: <0EBF5E18-D8DD-4602-BE97-9B7E9092052F@dilger.ca>
References: <1389497029-10488-1-git-send-email-tytso@mit.edu> <20140113132707.GA22358@orion.maiolino.org> <20140113140645.GC18029@thunk.org> <20140113161949.GB22541@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_9F36B331-9F63-418B-A8C3-829BE30F7BCF"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52067 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaAMUld (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Jan 2014 15:41:33 -0500
Received: by mail-pa0-f48.google.com with SMTP id lf10so5808001pab.21
        for <linux-ext4@vger.kernel.org>; Mon, 13 Jan 2014 12:41:33 -0800 (PST)
In-Reply-To: <20140113161949.GB22541@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_9F36B331-9F63-418B-A8C3-829BE30F7BCF
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Jan 13, 2014, at 9:19 AM, Theodore Ts'o <tytso@mit.edu> wrote:

> On Mon, Jan 13, 2014 at 09:06:45AM -0500, Theodore Ts'o wrote:
>> I'm just not entirely sure it's worth the extra hair, either way.  I'm
>> curious to hear what other people think.
> 
> After the ext4 concall this morning, I've been convinced by Carlos's
> and Andreas' arguments that we should add a superblock at the end of
> the disk.  So I'll rework the patches to do that.

Instead of adding a new location for the backup superblock at the
"end" of the disk (which is subject to change if the filesystem is
resized), what about using the last group that would otherwise have
a backup superblock with the "sparse_super" feature?  That means
resizing the filesystem by some amount won't change the location of
the backup, and avoids the need to change all of the documentation
for how to find superblocks.

Cheers, Andreas






--Apple-Mail=_9F36B331-9F63-418B-A8C3-829BE30F7BCF
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUtRPeHKl2rkXzB/gAQLBhQ/+IH+IOhmh05B6GdZIRfN2izUJ1EzrXJIF
qefAktD/ML6UEpMGez2pSTRaaohZtWPb811MgqHpXtpgCGnJMLgJh/LhkFpwjSnA
NAzkAwZQXXkJsTzsE6Xteb9XcWPJ46IGqtvtOzsolsugqeBajfRATKr1FInAM7NI
Iki5VOpccHmwz7tSFUrJSwQ7PINKlaWqCkPyQrgO4lUYVdpr7x2LDbpsEmeAaPHi
brgG2t2/dv3ivVbEAUdy5INiAX1hKawCKlaL1+8wlDEslUTjl6aZLQnKQitxi4nX
04HhOayJS5SIBT9vLSHzNCpF29kZ7v8D5mq5cZJywboRQYNG/lm6b7i0Le1vaCIy
Yr9RJuMmSjEMCVGmpNecovQi/9ahMKv3on4UeQ6vb5zrt5wlu3LtzN8nfp3mBwvB
vR0PAWh5Av2s0ZioKxc9PFZv2SaUuHYB0xXle/U2AMne8t9raTRxIbqsBl2kf7Ap
kAjwBWy+KzSSe+AMm/va+z8lLZHn5svSTGYqeo1b6tAG7NVZpRjpYAz754Y6vYCu
FEd5Q+h3mB76CI0t1iGUCXhRcqO7+W8WUoWifr735PhjULG3QnckhupzEaaGuHv2
pBr1hwEaD8rGf3AlmAJZJHCI/GrianRRM+y0u4XsiQ6jX5XpNcbqrwsd3ko3xtAA
FzEaNx5bbu8=
=cavH
-----END PGP SIGNATURE-----

--Apple-Mail=_9F36B331-9F63-418B-A8C3-829BE30F7BCF--
