From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH v1 0/9] do not use s_dirt in ext4
Date: Thu, 22 Mar 2012 13:25:37 +0200
Message-ID: <1332415537.18717.21.camel@sauron.fi.intel.com>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
	 <20120322095342.GC14485@quack.suse.cz>
	 <1332410747.18717.12.camel@sauron.fi.intel.com>
	 <20120322103309.GA14484@quack.suse.cz>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-m7BzqZp205qfFoP0txw4"
Cc: Ted Tso <tytso@mit.edu>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33815 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab2CVLXJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Mar 2012 07:23:09 -0400
In-Reply-To: <20120322103309.GA14484@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-m7BzqZp205qfFoP0txw4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-03-22 at 11:33 +0100, Jan Kara wrote:
> > However, if there is _no_ journal, the 'write_super' is initialized, an=
d
> > in many places the 's_dirt' flag is set, and thus VFS services seem to
> > be actively used.
>   Which many places are you speaking about? Grep shows 4 places with
> sb->s_dirt =3D 1;

Well, with 'ext4_mark_super_dirty()' there are still 6 or something
places.

>   You remove two of those in your cleanups so only
> __ext4_handle_dirty_super() remains. That is called from 3 (4 after your
> cleanups) places and they happen so rarely (during filesystem resize or
> when we start using some feature on the filesystem) that if you use
> sync_buffer() from all of them, it should be fine.

But AFAIKC, the whole '__ext4_handle_dirty_super()' also falls-back to
marking the superblock as dirty if the file-system has no journal for
some reasons, right?. But I do not really understand what
'ext4_handle_valid()' does. If I grep for 'ext4_handle_dirty_super()' -
there are many places places where it is used, and a few are obviously
for the superblocks.


--=20
Best Regards,
Artem Bityutskiy

--=-m7BzqZp205qfFoP0txw4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPawwxAAoJECmIfjd9wqK0LJEP/1KCA9fBdQvnZuoRMKsCCEom
rFsuWStPynTbB95PruUj3C7tJs4H3NrqPIZTfZ9p5F2mULSd+VVhHaAEJz/xOEy4
4MLboIgRkJTtO73LbXW9x2UngP1yKohti3R9wYbHvMnwJFCgDA+HY54JHURd+6mG
eJ2cWphuyZy6rTJbBkruXhvhb0qS/Iqmdp9aj2/tvf+23WSU9j41qejrqH7ZVxpg
NiAtP4ErdzEfi9OBEEYHJkMvyuXZtBfeZatqKGGVnR0eA9WjGLWArAFCxXiZ7UXV
EqYLKZjSIhA9m2RUWfM6IX9/ZEKyct3klXQPEvKwpDGJ1mZh23AQDWOEZC0b/HYo
JH1r8GnZ2VXP7cgGh1xmjt78aH0nLGHaHrXZOA9eED+F22zB89EgbdLv0Kr3P0Tr
Pye59QjhKH4n6ntJPlJWjLQx1XMSRnN7sToBxMu31HXH8ua8wc6pbTEOv6bRUSh8
Yd8nyystKXV6+JQkcbz836sNQSKG1moljCGfOCO3u6WqaktkkpjMSUy5BEaTVNFM
fm0GMmMTgTvtYM+NDehtFpMAH6WMASTRZQR8SwU/qwF91kyvRsOjIowUzZblsF5j
SOBRDo8/C8Y2YtJ27dKWQpjJ/cv35se438fMeuoYJ78s9/a+S0qVFIyVDg5RrzsO
ujYHLJhzm3PBqifaGRN0
=FB1n
-----END PGP SIGNATURE-----

--=-m7BzqZp205qfFoP0txw4--

