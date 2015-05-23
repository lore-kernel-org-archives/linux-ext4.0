From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Unused block group, but all blocks not free?
Date: Sat, 23 May 2015 11:39:52 -0400
Message-ID: <55609F48.2040609@ubuntu.com>
References: <555BDEF4.1020704@ubuntu.com> <20150520151007.GK2871@thunk.org> <555CA52F.3010109@ubuntu.com> <20150520163148.GA23989@thunk.org> <555D0541.1000804@ubuntu.com> <20150521235940.GB2750@thunk.org> <555E7371.9060207@ubuntu.com> <20150522022837.GC2750@thunk.org> <555F2306.8010607@ubuntu.com> <20150523030553.GD2750@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:29663 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757881AbbEWPj5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 May 2015 11:39:57 -0400
In-Reply-To: <20150523030553.GD2750@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 05/22/2015 11:05 PM, Theodore Ts'o wrote:
> We didn't check e2defrag because I didn't realize you had
> ressurected it.  (At least when I last looked at it, I was too
> scared about its error handling, etc., and so I had deliberately
> declined to try to get it into e2fsprogs as something I wasn't
> willing to support it.  So you are a braver person than I....)

Of course... I rescued it a few years ago after debian removed it (
before e4defrag was around ) and got it fixed up to work on modern
filesystems and it's hosted at launchpad.net/e2defrag.  I break it out
every now and again for performance testing since it does a full
defrag rather than only files ( maximize large free extents ) and the
ability to pack files in a specified order, such as the order they are
read during boot.  Well, that and I still find the ANSI block map just
as fun to watch as when I first used it in the '90s on a 486 with 2mb
of ram ;)

I really like the algorithm you guys came up with back then for moving
blocks from where they are to their optimal position in mostly large
sequential chunks and without having to move them more than once.
Yea, it's not crash resilient, but it is FAST.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJVYJ9IAAoJENRVrw2cjl5R5+YIAIjUyZ869wMO1LOMpcmjt0Rs
XRt2VJHwkT8y1U+STsEeMOOR5TydR+xWyG4ExaoPW+WOzROQNs+vbEH9tQZvBVNm
e6BLnKPPAYX392Ar3siufF87ivcGlM3SyQxrZgaj+EIlSpVbOVE6pnx2aSLhPhz5
znXL0sEioK+F/KxHNRfQyAtqPOc/OkJ1l1csanPUJFlEgQEuu4rSgaLvc3e4Y1pO
M0b09dqQHLJcGOSn+me22laLKAlTxhZWYkRoJrHielgX7sCukYMe5hEu6Nc/Gzt4
T/rAca/vmM9R5owExrbNydwNExnwZcB0bZT5ZBqU+9U/BwouJalKkGUhsH+zbpE=
=ahhy
-----END PGP SIGNATURE-----
