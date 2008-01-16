From: Valdis.Kletnieks@vt.edu
Subject: Re: [CALL FOR TESTING] Make Ext3 fsck way faster [2.6.24-rc6 -mm patch]
Date: Tue, 15 Jan 2008 23:25:38 -0500
Message-ID: <25815.1200457538@turing-police.cc.vt.edu>
References: <200801140839.01986.abhishekrai@google.com> <20080114163412.83a8b18d.akpm@linux-foundation.org>
            <20080115030441.a0270609.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1200457538_2966P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: Abhishek Rai <abhishekrai@google.com>,
	linux-kernel@vger.kernel.org, rohitseth@google.com,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from turing-police.cc.vt.edu ([128.173.14.107]:50729 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758257AbYAPE0S (ORCPT
	<RFC822;linux-ext4@vger.kernel.org>); Tue, 15 Jan 2008 23:26:18 -0500
In-Reply-To: Your message of "Tue, 15 Jan 2008 03:04:41 PST."
             <20080115030441.a0270609.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--==_Exmh_1200457538_2966P
Content-Type: text/plain; charset=us-ascii

On Tue, 15 Jan 2008 03:04:41 PST, Andrew Morton said:

> In any decent environment, people will fsck their ext3 filesystems during
> planned downtime, and the benefit of reducing that downtime from 6
> hours/machine to 2 hours/machine is probably fairly small, given that there
> is no service interruption.  (The same applies to desktops and laptops).

I've got multiple boxes across the hall that have 50T of disk on them, in one
case as one large filesystem, and the users want *more* *bigger* still (damned
researchers - you put a 15 teraflop supercomputer in the room, and then they
want someplace to *put* all the numbers that come spewing out of there.. ;)

There comes a point where that downtime gets too long to be politically
expedient.  6->2 may not be a biggie, because you can likely get a 6 hour
window.  24->8 suddenly looks a lot different.

(Having said that, I'll admit the one 52T filesystem is an SGI Itanium box
running Suse and using XFS rather than ext3).

Has anybody done a back-of-envelope of what this would do for fsck times for
a "max realistically achievable ext3 filesystem" (i.e. 100T-200T or ext3
design limit, whichever is smaller)?

(And one of the research crew had a not-totally-on-crack proposal to get a
petabyte of spinning oxide.  Figuring out how to back that up would probably
have landed firmly in my lap.  Ouch. ;)

--==_Exmh_1200457538_2966P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHjYdCcC3lWbTT17ARAlV2AJsE3GzanjcfRTUQdjdcjF3TqfSwmgCgplPV
DUh5XmLiyTCFXOqigQ7nw+s=
=PVZo
-----END PGP SIGNATURE-----

--==_Exmh_1200457538_2966P--
