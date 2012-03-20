From: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Tue, 20 Mar 2012 14:47:23 -0400
Message-ID: <35179.1332269243@turing-police.cc.vt.edu>
References: <20120320025835.GE14363@thunk.org> <1332212574.7847.49.camel@joe2Laptop> <216818.1332222366@turing-police.cc.vt.edu>
            <20120320.031001.1532841232287663716.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1332269243_2520P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: joe@perches.com, tytso@mit.edu, anca.emanuel@gmail.com,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lennier.cc.vt.edu ([198.82.162.213]:55820 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab2CTSr2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Mar 2012 14:47:28 -0400
In-Reply-To: Your message of "Tue, 20 Mar 2012 03:10:01 EDT."
             <20120320.031001.1532841232287663716.davem@davemloft.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--==_Exmh_1332269243_2520P
Content-Type: text/plain; charset=us-ascii

On Tue, 20 Mar 2012 03:10:01 EDT, David Miller said:
> From: Valdis.Kletnieks@vt.edu
> Date: Tue, 20 Mar 2012 01:46:06 -0400
>
> > OK. Say I'm a scraper.  How do I distinguish between:
> >
> > pr_info("foo");
> > printk(KERN_INFO "foo");
> >
> > Oh my. seems that both result in exactly the same thing ending up in the
> > dmesg buffer
>
> No it doesn't result in the same output, read the definitions again.
>
> pr_info can be influenced by pr_fmt, plain printk cannot

So if nobody screws around with a #define pr_fmt, you can't tell the
difference, and if somebody *does* screw around wiht a #define pr_fmt, you have
no good way to know what *this* build of the kernel produces as output without
tracking down the actual define in use. Consider Joe Perche's example "you can
do things like" - you don't have a good programmatic way to tell what that
pr_info() actually outputs, so an actual human is going to have to review that
and figure out what needs to be pattern-matched.

Not a situation you want to be in if you're a scraper.

At least the perf subsystem is nice enough to *tell* you "I've added an extra
field you may not know about" and provides a mechanism to skip over it.
And I can see why Ted doesn't want to have code churn to do a half-assed
conversion, when there will just be *more* churn if and when we ever get off
our collective butts and deploy a structured solution.


--==_Exmh_1332269243_2520P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT2jQugdmEQWDXROgAQLf8Q//TsehQmCxbb6gQUti3bUdpfzmYao4gHR7
984jo5bR24UVi9mXQrc4s21O10LGZMl4GZZZjlrbZYMWzSwz93CkPivf78K7Cab+
a5GcZiQLktiaYa27UMMf5I2h+5CqEF83HBpXCHnSnZ0Z9s+Oenw/uHTk5fdmaYwW
mMxNqWRCWI9EA6MXu9SXctJJB6Bh5UrVGfI1nV/2whIFw1NecV4j8gMJpG7FjX/Y
GygYuwu1z1jynlaEujaFWUlW0j2Kp+Zk2UhRV0DEcq6OHZ+/XymJk5XGGlJweIiL
XRP74tConsIqCY+q2VGvW7sirOd4u/BAeINHDOK7WxAIXNjVmmsMy95T40ePqv57
YCJa94QI7dshEyC2BIPErSINDQY4HJm0YNQj6nqlurdFAs0VTnRYSMvKCkuv4INd
dHdwspqKh8rJ8fY/L/gJyyEu7LJ51nwlUGlLYhSqiVnm1tjemHADvYUFzM7UgPQz
zR+e10+8ExFaJp5aErcdmlYgxj+2/DYhQ230K9G+Zv2289jnNxx3WOipCupotdnJ
7gv9BtfAUUtKFgQPILdttY5zg+obXGXCjPI2GMMCbwZ/BztO70aG43HbZPEnTXIN
FpuMxu82IShgvcHx08EODSPS7pflot/d2EmhuXhgYfiar3mbMmt4Bc4nC875EDYF
g89dqa2TWi0=
=jDAI
-----END PGP SIGNATURE-----

--==_Exmh_1332269243_2520P--

