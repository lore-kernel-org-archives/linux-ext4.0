From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH v1 0/9] do not use s_dirt in ext4
Date: Thu, 22 Mar 2012 15:59:32 +0200
Message-ID: <1332424772.18717.37.camel@sauron.fi.intel.com>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
	 <20120322095342.GC14485@quack.suse.cz>
	 <1332410747.18717.12.camel@sauron.fi.intel.com>
	 <20120322103309.GA14484@quack.suse.cz>
	 <1332415537.18717.21.camel@sauron.fi.intel.com>
	 <20120322134253.GA19587@quack.suse.cz>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-6BVtAb9E12r9zLIiv0Rq"
Cc: Ted Tso <tytso@mit.edu>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51126 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964942Ab2CVN4l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Mar 2012 09:56:41 -0400
In-Reply-To: <20120322134253.GA19587@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-6BVtAb9E12r9zLIiv0Rq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-03-22 at 14:42 +0100, Jan Kara wrote:
> > But AFAIKC, the whole '__ext4_handle_dirty_super()' also falls-back to
> > marking the superblock as dirty if the file-system has no journal for
> > some reasons, right?
>   Yes. And I wrote that if you do sync_buffer(EXT4_SB(sb)->s_sbh) instead
> of marking superblock dirty, it would be fine.

OK, sorry for not reading carefully, I will take a look at this and all
the places where we use 's_dirt' and try to think how to just eliminate
them. But since I have 0 experience with ext4, I'll probably need some
help, but let's see.

Thanks for reviewing and the feed-back!

--=20
Best Regards,
Artem Bityutskiy

--=-6BVtAb9E12r9zLIiv0Rq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPazBEAAoJECmIfjd9wqK0YXcP+wWZzC/pm9NSNez+KH2OncIU
uXQvU0bfbCy01pPzmP+3CAzmyvtOms+x4pKlJ5A0Knvf6ddAg56Gk1+QO2WAngmP
gdbUryti/7Zo7UflR4dJmkEM/zW5Ii0EixesJnYViTZZozi67cdM3YU6gp2TBceP
3HVUfjivlkMyBeoADwUhwxU328AcZaGfcZt4Ma6TeeymGhE5Yn+vkMiYpSy21s04
XHf4ZfsLTNzu7SsRZlEgwXJi3mq1GRjeSd1l90blGuSp8D0r0W79/Wb0kARHRvKS
vvt1oWAwHrVeq4ZnVc8UqS8lfsKX4dyZNioBmMYS/HfetapivH+wCWwPdsmYOdnE
aGCRS57Ba3oSsI08KdC7cZelSas/2cwpi0N7Fuhnq525MKMRh28M1C4Ti8fgxA7z
tp545Z5oFbBoImDiTiXF6WIIo6Mj2QT7FP2NpDKkdDbe8NkQQJA0t3mcNcX/akQe
Bwy00cLtYHAoUjXH2rVDXW81kKqPJUjnV+AHKBSGhx/6iJeqLaOm+hZfDb5le3wR
FM/+aoOiFirphw6oe4ohoh3eniJiiPDkZgyJfNG9tex9YeJuPDc6oCAA2UaVmhKD
YUVjT/L+lnfosoJ9aAGVNHBffjYcdVkEbuoJxHkMXg5ravP42fX6+6vYDPYJI0wi
K5vW6ENPZqTWLCcD7pUt
=MXFq
-----END PGP SIGNATURE-----

--=-6BVtAb9E12r9zLIiv0Rq--

