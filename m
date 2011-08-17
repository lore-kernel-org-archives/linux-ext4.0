From: Valdis.Kletnieks@vt.edu
Subject: Re: INFO: task jbd2/dm-0-8:3993 blocked for more than 120 seconds
Date: Wed, 17 Aug 2011 19:48:07 -0400
Message-ID: <27048.1313624887@turing-police.cc.vt.edu>
References: <4E4BC296.1040004@mageia.org> <96850198-2253-40F7-B99C-62A6097278FA@dilger.ca>
            <4E4C2DE5.5020100@mageia.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1313624887_2796P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Thomas Backlund <tmb@mageia.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lennier.cc.vt.edu ([198.82.162.213]:58538 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab1HQXsN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Aug 2011 19:48:13 -0400
In-Reply-To: Your message of "Thu, 18 Aug 2011 00:08:53 +0300."
             <4E4C2DE5.5020100@mageia.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--==_Exmh_1313624887_2796P
Content-Type: text/plain; charset=us-ascii

On Thu, 18 Aug 2011 00:08:53 +0300, Thomas Backlund said:
> Andreas Dilger skrev 17.8.2011 17:35:

> > This is a problem with your disk hardware.

> Are you sure?
> I get nothing from smart, even after I had executed the long test...

SMART is nice, but it isn't guaranteed.  In particular, you need to
double-check that what you think it's testing in a "long" test is what
it actually did...

> # smartctl -a /dev/sda
> smartctl 5.39.1 2010-01-28 r3054 [x86_64-mandriva-linux-gnu] (local build)
> Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net
> 
> === START OF INFORMATION SECTION ===
> Device Model:     WDC WD1002FAEX-00Z3A0
> Serial Number:    WD-WCATR3168879
> Firmware Version: 05.01D05
> User Capacity:    1,000,204,886,016 bytes

So we're looking at a terabyte of disk...

> Selective self-test flags (0x0):
>    After scanning selected spans, do NOT read-scan remainder of disk.

And it's *NOT* doing a read-scan of the entire terabyte.


--==_Exmh_1313624887_2796P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOTFM3cC3lWbTT17ARAkMFAJ9dv9vHc/L2OtWOzT+f2ODVgjs3hwCeJlVq
iCIinxQmh0I0JVWt31cy0OA=
=KHlq
-----END PGP SIGNATURE-----

--==_Exmh_1313624887_2796P--

