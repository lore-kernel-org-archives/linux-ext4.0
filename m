From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Use EXT4_BOOT_LOADER_INO for boot loader GRUB?
Date: Tue, 05 Feb 2013 21:15:40 -0500
Message-ID: <5111BCCC.70709@ubuntu.com>
References: <51023FEA.7000802@reinform.de> <20130126184927.GB20005@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Dr. Tilmann Bubeck" <t.bubeck@reinform.de>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:37381 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab3BFCPm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Feb 2013 21:15:42 -0500
In-Reply-To: <20130126184927.GB20005@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/26/2013 01:49 PM, Theodore Ts'o wrote:
> What I'm thinking about is a new ioctl that would swap the i_block
> and i_blocks array of the BOOT_LOADER_INO and the file descriptor.
> That is, if there were any blocks attached to the boot_loader_ino,
> they would become attached to the inode associated with the file 
> descriptor, and the blocks associated with that inode would be 
> attached to inode #5.

Isn't that what the new defrag ioctl does already?  So you just need a
way to open the reserved and unnamed inode to call the ioctl on.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQEcBAEBAgAGBQJREbzMAAoJEJrBOlT6nu75KrwH/1tMG3rGEsXpIt61kPQDkH77
QDquiA31N57c8DxPVc8/ibZdNhCAjH84TZFW3Lopzr6zCh03ZbOs08AsEyDeXvWw
pTp3mJzmLvI1Lq7x6snYEA3ndd/taswo9bZwf2fwUwi2hQIBux+G65gnFECiybms
EV4zwUJSVtF8l77HTidrUODQgnI9j+MMwKILWtsgoBsGjMX5eHSO/5fgMCfnIvcv
q5MIU7V0JjaQVMTSAPOVXcy3ZAnvHv2rt+JNX5UyA1bST7BKd/uF9GQAxkakfLnH
oGeYzN9bRayGCszlcIeUMv0xv7J3KXFNB/MpKx42zlPyps92boThv1jLnkWrgOg=
=8PlP
-----END PGP SIGNATURE-----
