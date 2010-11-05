From: Tony Vroon <tony@linx.net>
Subject: Re: BUG in ext4 with 2.6.37-rc1
Date: Fri, 05 Nov 2010 23:09:49 +0000
Message-ID: <1288998589.2961.3.camel@localhost>
References: <20101102202013.GA3861@elliptictech.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-puDy6ThfF+Hryjgr37cA"
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Nick Bowler <nbowler@elliptictech.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gold.linx.net ([195.66.232.40]:44158 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058Ab0KEXRR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Nov 2010 19:17:17 -0400
In-Reply-To: <20101102202013.GA3861@elliptictech.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-puDy6ThfF+Hryjgr37cA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-11-02 at 16:20 -0400, Nick Bowler wrote:
>   ------------[ cut here ]------------
>   kernel BUG at /scratch_space/linux-2.6/fs/ext4/page-io.c:146!
>   invalid opcode: 0000 [#1] PREEMPT SMP=20

Confirmed, it's an issue here too.
I have just hit this one 2 times in a row within 20 minutes. Please CC
me if you need any fix tested; looks like I'm off to 2.6.26 until this
is fixed.

Linux prometheus 2.6.37-rc1-00040-g0660a9b #1 SMP PREEMPT Fri Nov 5
22:09:58 GMT 2010 x86_64 Six-Core AMD Opteron(tm) Processor 2435
AuthenticAMD GNU/Linux

I can provide .config if needed; have digital photos of the oops if they
are deemed useful. The BUG hit at the exact same line as you though.

Regards,
--=20
Tony Vroon
UNIX systems administrator
London Internet Exchange Ltd, Trinity Court, Trinity Street,
Peterborough, PE1 1DA
Registered in England number 3137929
E-Mail: tony@linx.net

--=-puDy6ThfF+Hryjgr37cA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAkzUjr0ACgkQp5vW4rUFj5qX8wCfc/kqVAr/S05pc6+sGZxIvWGu
tawAnjsj1YfDgsAyLVWYorhKKQJ5Vtoz
=+8xe
-----END PGP SIGNATURE-----

--=-puDy6ThfF+Hryjgr37cA--

