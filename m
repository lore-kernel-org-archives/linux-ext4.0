From: Sami Liedes <sami.liedes@iki.fi>
Subject: Re: Announcing the Berserker toolkit for (semi-)automated fs fuzz
 testing
Date: Sun, 6 May 2012 19:20:47 +0300
Message-ID: <20120506162047.GF13332@sli.dy.fi>
References: <20120428013904.GE20648@sli.dy.fi>
 <20120506102727.GA11619@amd.home.annexia.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="APlYHCtpeOhspHkB"
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: "Richard W.M. Jones" <rjones@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120506102727.GA11619@amd.home.annexia.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--APlYHCtpeOhspHkB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 06, 2012 at 11:27:27AM +0100, Richard W.M. Jones wrote:
> I wrote something similar a while back, trying to use systemtap to do
> feedback-directed fuzz testing.  By putting a tracepoint on every line
> in the filesystem module, you can find out how many lines of code are
> actually executed when mounting/using the fuzzed filesystem and use
> that as a cost function for feedback (maximizing the # of lines
> executed, rather than blindly fuzzing).  Unfortunately it doesn't work
> yet because of a bug in Linux[1].

I guess something like that could also be used for trying to generate
a small(ish) set of test case filesystem images that maximally
exercise the code.

> Anyway I was going to say: why not use libguestfs to provide a simpler
> framework for running KVM and the fuzzer?

I didn't even know about libguestfs. Very interesting; I need to take
a closer look at it.

I'd be glad quite glad if I could somehow get rid of the root
filesystem image, or to build and update it automatically. Right now
it's a headache for version control purposes.

	Sami

--APlYHCtpeOhspHkB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJPpqTfAAoJEKLT589SE0a06gwQAJ91SJAWHOJXHO4ZgsXbYl2Z
qVhxNoyEK3IJTQqLqI5mAM3jdjOyI9DDSAwDuF00CbZv2gPL92yBrxaSCypMoqhE
5k3BCQl0PaLuoeeU6D3xgyF4MNCoHglWGEhATvFn1vY+9DuGWd3wk6ojY6SF2Lcg
ukA4SXXA5th/i1wX9ncdcpzuGKWD1RwE0zaMCqsB2u31hflOM+iTdIjnBA2JfotO
smUvhTN+kAUq3hQhldFeXlYk9MEwV+qSukWyFy3MgixObispJTQVRTWAZTstNxI4
nzBbSFogxDwdF9R269kH2l0DzjUjuvztbtlLgLUEjuAfurJD8gmUTMkLVoK3fXxa
1wdY6JA7K077364da34n4xt0XZK+QZXLyV3cn4rfxguTgh/1NZo0cJHNFNB8/i8T
ek9c6lP2vWbm0psYd6282pmm3iikxi8wTaP8m4PRnvikQsQIbzLxp48A6nx69hXo
9xUo0s/BGZYPITHKZmS1IyB3g3vbLJb/yxNm9Pk32FbL4XCxtVY6VTHCRqsSjFNW
8xrW7wFzsysGPmeHQmzlnd59TJ9TFdlGKV12VzLkpo4b6F49h/VGD7+ICHFS49+n
teY+DW0nG82hqVlYvqW8DXAFPaHfLAQ7+KQLTEwUjkInzT97wAKp8RmXZd65gxSj
k/6v9KmcrtJgoJcbeikk
=PFNS
-----END PGP SIGNATURE-----

--APlYHCtpeOhspHkB--
