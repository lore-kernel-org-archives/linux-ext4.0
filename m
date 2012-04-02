From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH v1 0/9] do not use s_dirt in ext4
Date: Mon, 02 Apr 2012 16:46:58 +0300
Message-ID: <1333374418.22146.5.camel@sauron.fi.intel.com>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
	 <20120322095342.GC14485@quack.suse.cz>
	 <1332410747.18717.12.camel@sauron.fi.intel.com>
	 <20120322103309.GA14484@quack.suse.cz>
	 <1332854998.31549.40.camel@sauron.fi.intel.com>
	 <20120327201401.GF5020@quack.suse.cz>
	 <1333121035.5440.49.camel@sauron.fi.intel.com>
	 <20120330153530.GH5587@quack.suse.cz>
	 <1333122195.5440.60.camel@sauron.fi.intel.com>
	 <20120331114926.GA4569@quack.suse.cz>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-U+0zOUbbIg/K1UOhMPwd"
Cc: Ted Tso <tytso@mit.edu>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:43621 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737Ab2DBNnq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Apr 2012 09:43:46 -0400
In-Reply-To: <20120331114926.GA4569@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-U+0zOUbbIg/K1UOhMPwd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-03-31 at 13:49 +0200, Jan Kara wrote:
> > Well, I ran vanilla the tests in vanilla 3.3 overnight, they were fine.
> > But may be I was lucky. I'll try to run the tests with vanilla kernel
> > some more. I mean, it would make more sense to report something against
> > vanilla 3.3, not a patched 3.3.
>   That's true. Frankly I think you were lucky with hitting the bug with
> patched kernel rather than not hitting it with vanilla :). What test did
> you run exactly?

I've sent a separate report (Subject: 3.3 oops). The oops there is a bit
different comparing to this one, though. For this oops I used the same
kvm setup.

--=20
Best Regards,
Artem Bityutskiy

--=-U+0zOUbbIg/K1UOhMPwd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPea3SAAoJECmIfjd9wqK0NF4P/i4Ab7tylwTOhX62OIl9O/jl
4/ClO2jvq4QBzWCuusX+V4hxVgY7BW6MydX1GmRQYBGjRzZg5zA/7lVa/TEN8I44
wATap01cm7wUDHMyBxDa7naR84gT8ODny50VJs9Ihsqwo56x9X4dMvIAhDxYea5j
Ldy1TXVfiGyEWUvbcUVLNAxQ4A2z/i2CDPP6Q2bd1U16HmNGQMGCEwvEEmM0rno3
cqDXh0xv6nEpvcGfsMk/iLOjMqWPuqPCYjeveB05pkLhVBXzhhWBSmZC2xKOcA2Y
1DBJxtXHJrayfZeiFbVy9Oh554wxe74JZNVAkQZxX0huvboZcMWolB8zJ3kp61LW
N7EDw7ARCpWEFaDT8x72c1pYXxHmuhiHFcgZm8jpNEQzBCYa2Y4wrj8aqmlCBZFi
TM2R+B8+ECwswWeF68Yd32fxaMvtb0FftO2goes5kXWJq2yo00xVNNK+AeRV0yTx
8WGdi537LMW0ZZbddg0rkUFgj3oi+OQeXImBjas7PW8nH/IXbjJUwI5hkH5yAspc
XL0Z5hGoMGYmGGQJMPv09LkI8nznIrOfsmgb16NmKMvhb3hbzwLrJ8DnWz3Lrb1Z
XakkjDs/9xRCeBHEzCO5432ULfaqJfwd+OG4vH7OJ+2uxrYuanjhL5dHOipQZ3ul
+CSW8lZXSyOPgj815gN/
=PqxT
-----END PGP SIGNATURE-----

--=-U+0zOUbbIg/K1UOhMPwd--

