From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking infrastructure and convert ext4 to use it
Date: Mon, 10 Apr 2017 09:15:43 +1000
Message-ID: <8760idyxy8.fsf@notabene.neil.brown.name>
References: <1491250577.2673.20.camel@redhat.com> <87h924kh6t.fsf@notabene.neil.brown.name> <20170404115358.GH30811@bombadil.infradead.org> <1491308268.20445.4.camel@redhat.com> <20170404161247.GJ30811@bombadil.infradead.org> <1491323146.309.1.camel@redhat.com> <20170404170909.GK30811@bombadil.infradead.org> <1491421792.18658.20.camel@redhat.com> <87efx6tnbr.fsf@notabene.neil.brown.name> <1491506092.9621.2.camel@redhat.com> <20170406200543.GE31725@bombadil.infradead.org> <1491570740.2745.12.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        tytso@mit.edu, jack@suse.cz
To: Jeff Layton <jlayton@redhat.com>,
        Matthew Wilcox <willy@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56713 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752591AbdDIXQY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 9 Apr 2017 19:16:24 -0400
In-Reply-To: <1491570740.2745.12.camel@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 07 2017, Jeff Layton wrote:

>
>> ... and then there's no need to update if it's the same errno and nobody=
's
>> seen it:
>>=20
>> 		if (old =3D=3D new)
>> 			break;
>>=20
>
> No, we can't do this. The thing could have just been updated by a task
> that is setting the "seen" bit. We don't want to lose the error here. We
> always have to do the cmpxchg on the set_wb_error side, I think.

I don't follow your logic.
If (old =3D=3D new) then there was a moment since this function started when
performing the cmpxchg() would not have changed the contents of memory.
So let's pretend it did actually happen at that moment, and not change
memory.

If we race with a task setting the "seen" bit, then it will have seen
the error *after* the new error, that this thread is reporting, actually
happened.  So the result is still correct.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljqwJ8ACgkQOeye3VZi
gblqCA/8CksI5fTnlNJiKlqXOggdp8GQcdr29C/dNKwNeLw9ea+q0q/Wy9CIOP94
6Ycofq4D+KP/Sg7vtASpoaVkJ/IorZZeGYM5mK4kMDh/35amJ39B8Vch4CGkiXEO
dhe1zjB2iouI3p3W98QRZwmy/dVxS+5sSOAp3XFqfMtGOVfegcGviwRShVbJ6TCf
TXrHos2OHpTo4mG3G3OcHrrAUcUmBjl4WtqX/goJDi7GWNUf5gDNShjdhZLv5OxX
jO/HVx0DObFAv29bpvsFXY7ozQDwym4ZVAImVfP4rKfj/FWUR2nmLqvmeY34Sff7
MSu/XLjWYDCpP+nX9i1dAhXSkMjlSrCvSd82XABLmsoNz8lN9As5X8k0mgW/pOid
6aDB5TfRyBqMBIQhmn2A9fzaA0CQs13yGFHSdLbRnNGIAyJ5ziTkr/YHW2PEzbfS
xCa827Ht/Fy8jE+6kD0ycZT7575rHq8OSN5dauSA+ctq9sUy7JuvjL73iYpc30TN
Kevn9PGLaS9p288GOD/OHipCXUq8j5h7tWQscqrunieWPydzfVGAqCxPvdNn0hC1
ybTxCxI0AJ0Bplr+SzeF9OeQ//eHf9XDImr87An/TtW2xCa6bLk48z0wV35/xuko
mSAptl7DddGPiCExqxnsLbRbHEDvkm28jA4VUQzt2TLsMQnTskU=
=FKzy
-----END PGP SIGNATURE-----
--=-=-=--
