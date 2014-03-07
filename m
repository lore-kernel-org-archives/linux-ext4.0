From: Phillip Susi <psusi@ubuntu.com>
Subject: chattr: operation not supported ( on symlinks )
Date: Fri, 07 Mar 2014 15:16:24 -0500
Message-ID: <531A2918.9020108@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:41145 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaCGUQ1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Mar 2014 15:16:27 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

It seems that symlinks return -ENOTSUP for lsattr, causing chattr -R
to spew errors.  Why don't symlinks support attributes, and if not,
shouldn't chattr know this and suppress operating on symlinks instead
of spewing errors?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTGikYAAoJEI5FoCIzSKrwXhgH/3ZMK5OBUNRK6Pty+lSk/aj6
P7KkeLkJl16TaeNFp/rFoDju16PA/I3uPQipY25VdNYNCVMEmQOd0i//55gU47ur
ZtdjAD4vMNTpFsV/oxjrx+f6kp1OqYKylConQxo/AAS+YDHq7adCds31N8mny1o8
WI/TYp3M4uGtQQ2yHF5j7jvZNR2gacMrXfN+6fbdIP99I2j4v4eHdvJJRQuo5vun
Q2ZQw5a/GGPlXUYcIcnFkmXlNDJIfGO7WPxXfaUbspQwRH21Ithr61pk1LVLZjN9
eptvSQpXBhKdQzeAMbUKS5AIoN7u0KMcIErfhR2mwDncfCcsI/PPTQSSf8B1L0o=
=vzkc
-----END PGP SIGNATURE-----
