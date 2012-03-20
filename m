From: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Tue, 20 Mar 2012 01:46:06 -0400
Message-ID: <216818.1332222366@turing-police.cc.vt.edu>
References: <20120319153133.GA2502@thunk.org> <CAJL_dMtC9fnOsY=4uDVJD=-h5u-qW=xjaf64gtDcgnKX2brhPw@mail.gmail.com> <20120319161425.GB2502@thunk.org> <20120319.141402.934377752041508724.davem@davemloft.net> <20120319183126.GA6031@thunk.org> <1332182773.3908.11.camel@joe2Laptop> <20120320010401.GA14363@thunk.org> <1332207202.7847.23.camel@joe2Laptop> <20120320014707.GD14363@thunk.org> <1332208741.7847.46.camel@joe2Laptop> <20120320025835.GE14363@thunk.org>
            <1332212574.7847.49.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1332222366_2016P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>, David Miller <davem@davemloft.net>,
	anca.emanuel@gmail.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lennier.cc.vt.edu ([198.82.162.213]:54632 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab2CTFqO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Mar 2012 01:46:14 -0400
In-Reply-To: Your message of "Mon, 19 Mar 2012 20:02:54 PDT."
             <1332212574.7847.49.camel@joe2Laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--==_Exmh_1332222366_2016P
Content-Type: text/plain; charset=us-ascii

On Mon, 19 Mar 2012 20:02:54 PDT, Joe Perches said:
> On Mon, 2012-03-19 at 22:58 -0400, Ted Ts'o wrote:
>
> [good stuff]
>
> > Of course, the body of the message needs to be standardized too.  But
> > that's orthogonal to the problem of passing the kernel structure which
> > identifies the object which the log message is about.  That part is
> > completely and utterly necessary if you're going to standardize the
> > *first* part of the printable dmesg log, which contains the structured
> > information.
>
> All of what you say is true, but you're neglecting
> the ability to scrape or notify a particular set of
> per subsystem messages that pr_<level> could easily
> provide that a bare printk could not.

OK. Say I'm a scraper.  How do I distinguish between:

pr_info("foo");
printk(KERN_INFO "foo");

Oh my. seems that both result in exactly the same thing ending up in the
dmesg buffer, so a scraper can't tell the difference because there isn't any...

pr_<level> isn't currently providing any ability to scrap or notify that can't
be done equally well by a printk.  Now if you fix things so there's actual
advantage to or_<level>, then I'm sure Ted will be willing to listen.


--==_Exmh_1332222366_2016P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT2gZnQdmEQWDXROgAQJ1dQ//W6haObAbksK8sr6jO22uHQPsDhSGD5Xg
oqAih9ekoePk2mtdm1UZRQorAq4NvLFZv6GD07S+iFaWlpHsd71sxeWlmnNrSIou
zmYvYCsJVNBevVlxFbzkryJMhnu3KJz+cPNudxhei3NWsekWmJwD10Hmo7x8kJpd
utW69jEGAyalO/Ra8xj+HNDihwkOVZOvaEcg4cDHZT/OQAOKDQFLrpKg+X7ZqFMI
9i4Lqk3fxKcyqW/iVn+JjrJZehOMCgOTWCc3ugXTp6Az+9o85322KzPHyQ/ak1VU
joI+CPpeketVs73QBi3qwkwWmyfE1y28MVA3AqzPWrOePzxXT/wlRhMLf1pfdmOB
I6QyEoc7NxriLzONUmLFzRBCqTCks44OLZq884JJY2lclTk6kHt5Sch7xZiMd2Rq
SaawrBM4cB+nlP++WxlnQNWo8xDzePBtOUKL6QNz/zkAI+PLJ9dQtBR6MOWTtYqW
kWZ0EfTkAIh5/bijT2eW3N0g8zIv9tNEZshRUIsSDKH5Ec0LM+ZdWeXStMjwkpB+
QfP9Vn9H8RMd+g4SuA9+WFKn5j7YoabQn20rzos20mCK0dBiwlB+32LGFkPfbu3V
qcFJQUGQowlCStseAVsq+MjuoYR04AQck131nB2g1zHyAQpqokigik16Rq+gftsE
rzqsmL0GXMw=
=xLdu
-----END PGP SIGNATURE-----

--==_Exmh_1332222366_2016P--

