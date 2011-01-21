From: Jon Leighton <j@jonathanleighton.com>
Subject: Severe slowdown caused by jbd2 process
Date: Fri, 21 Jan 2011 00:13:02 +0000
Message-ID: <1295568782.2459.29.camel@tybalt>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/Oiu5zRDqvGGXD2ibrVR"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from benvolio.jonathanleighton.com ([173.255.230.218]:50671 "EHLO
	benvolio.jonathanleighton.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752617Ab1AUATE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Jan 2011 19:19:04 -0500
Received: from localhost (benvolio.jonathanleighton.com [127.0.0.1])
	by benvolio.jonathanleighton.com (iRedMail) with ESMTP id B7FF0A8C9
	for <linux-ext4@vger.kernel.org>; Fri, 21 Jan 2011 00:13:07 +0000 (GMT)
Received: from benvolio.jonathanleighton.com ([127.0.0.1])
	by localhost (benvolio.jonathanleighton.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0c9Hn76gaJ8v for <linux-ext4@vger.kernel.org>;
	Fri, 21 Jan 2011 00:13:06 +0000 (GMT)
Received: from [192.168.1.147] (unknown [92.14.206.152])
	by benvolio.jonathanleighton.com (iRedMail) with ESMTPSA id A317CA8C5
	for <linux-ext4@vger.kernel.org>; Fri, 21 Jan 2011 00:13:05 +0000 (GMT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-/Oiu5zRDqvGGXD2ibrVR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi there,

I have been experiencing some slowness with an ext4 filesystem. I will
try to explain and hopefully somebody can identify whether this is
"normal" or not. Sorry if I am in any sense unscientific - filesystems
are somewhere near the edge of my computer science knowledge :)

Basically I am involved with doing some development on the Ruby on Rails
web app framework, and the automated tests for one component (Active
Record) does a lot of reading/writing from a database.

I realised that the test suite was running significantly slower for me
than for another developer, so I started to investigate. First I created
an unencrypted partition and put my databases on it, as I had previously
had everything encrypted.

This made it somewhat faster, but not massively.

I then used iotop to see what was going on when I ran the tests. I
discovered that the process jbd2/sda3-8 was doing *lots* of IO when I
run these tests.

I did some googling and tried a few things. Removing the journal solved
the problem (as would be expected, I guess), but also recreating the
partition as ext3 rather than ext4 solved it too (which perhaps
indicates a regression?) When I say 'solved', I mean it took a single
run of this particular test suite from say 4.5 minutes to more like
60-80 seconds.

I found some other people reporting a similar problem:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/607560

They complain of the jbd2 process running every few seconds. This is
something I had not noticed before, but I can observe this on my system
too. It runs and uses a lot of IO for a short period of time maybe every
2 seconds. So I think I am experiencing the same problem.

FWIW, using the noatime option does not help at all. Also, I have tried
using a very recent kernel build with no success. And I have run iotop
on another laptop (which also has an ext4 partition) and I cannot
observe this frequent running of jbd2.

So: does this sound like a bug, and if so, what can be done? I'm very
happy to provide any additional information as needed.

Many thanks,

Jon

--=-/Oiu5zRDqvGGXD2ibrVR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAABAgAGBQJNOM+IAAoJEIeyJN+tUclilAsIAIfX+4dQ5dkJcbogBhPTtW3y
cykRYwzkMbpuE+XjpkJUltNbk8bMxtCjMzNLawNIPXcyJ1lPCNhsUuGDdwJOoyZO
vARpxbtgB7hwM9fXbVSRgLUQyEFFqiadbx3d2HUggzx26IV7/N9DN/J02wXHyD2k
5KvUSJrHpDFX6JSrzzcAHTBsCCJjjLsDK3QzdQ4ZdfLWHFigu8Y5KdX7BRCzYT2T
g1lY8FWJ19Vh7JgnImVwsdTFssxB9edSnBZYx4coQch+t5IX/FIxektTOPnGxLSw
J3E1pan7G3Xmzn7fATiU/ONt/ZVJtjUYFa20zdQQTUktYWFbs2XL2kMmL3e7Wiw=
=Mv9H
-----END PGP SIGNATURE-----

--=-/Oiu5zRDqvGGXD2ibrVR--

