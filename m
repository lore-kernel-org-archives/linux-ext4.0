From: Eric <erpo41@gmail.com>
Subject: Re: ext2/3/4 online defrag
Date: Thu, 17 May 2007 22:11:54 -0700
Message-ID: <1179465114.7891.17.camel@eric-laptop>
References: <1178770799.26695.11.camel@eric-laptop>
	 <20070517161119.GB3230@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qUoeIhFoMbE9XWxH8ffI"
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.237]:30172 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050AbXERFL6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 May 2007 01:11:58 -0400
Received: by nz-out-0506.google.com with SMTP id r28so1212868nza
        for <linux-ext4@vger.kernel.org>; Thu, 17 May 2007 22:11:57 -0700 (PDT)
In-Reply-To: <20070517161119.GB3230@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-qUoeIhFoMbE9XWxH8ffI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-05-17 at 18:11 +0200, Jan Kara wrote:
> But me (and several other people
> independently as I've learnt recently) have written some tools which
> should result in something useful. If you're interested, you can join
> prefetch-devel@googlegroups.com - it's led by one guy who is doing
> defrag and stuff as his google summer of code project.

Is this different from the ext4/extent-based defrag patch that's been
mentioned on this list?

> > *An implementation of an ext* filesystem driver can work with any
> > ext2/3/4 filesystem as long as it supports the necessary revision
> > (GOOD_OLD_REV or DYNAMIC_REV) and feature flags set in the filesystem.
>   Not sure what you mean here...

The "ext2 filesystem"/"ext3 filesystem"/"ext4 filesystem" terminology
was confusing to me when I first started reading about them. In my mind,
it implied that those three filesystems were more different than they
actually are.

I think it would be more accurate to say that they are all essentially
the same filesystem, and that any filesystem driver that can mount a
given filesystem can mount any other ext2/3/4 filesystem of the same
revision with the same feature flags set.

I was asking for confirmation of this assumption, but I've since found a
lot of really good documentation that has cleared up a lot of things.

Thanks,

Eric


--=-qUoeIhFoMbE9XWxH8ffI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGTTWae2L37HVup3ARAvTJAJ4m9o/GAAJW8CmO0lL6MGpAWCJPewCdHd3S
cO3EKllDzj7M0cKxIlKovlw=
=yleC
-----END PGP SIGNATURE-----

--=-qUoeIhFoMbE9XWxH8ffI--
