From: Phillip Susi <psusi@ubuntu.com>
Subject: e2fsck and backup superblocks
Date: Fri, 17 Feb 2012 22:00:09 -0500
Message-ID: <4F3F1439.5000407@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:5086 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab2BRDAM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Feb 2012 22:00:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I have noticed that e2fsck always complains about block group descriptor checksums being invalid when run on a backup superblock, even when run again immediately after being told to fix them.  Is there some odd intentional behavior here I'm not aware of?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPPxQ5AAoJEJrBOlT6nu75dgUH/19Sv2UASFGCLTfsvJcBBFjC
z6w0LgI/GB37mlan7g06mT3UYSEN5LlD7VYAqWUEOgchu3Y+t735w1MRZy7WmVrc
9PopsJVTUZnc8vCcGAoh/T4OcJkf5zU7EAoL+BQUInTOkermLL/Bp9yGVIVsDXN1
gXnf6BdozDkm4LRCIbN1RStg6IqUClIxbvLwItDYhgdwmMFIVsd0dUPTPhb8s8c3
tMQclqLTx+9lYJXC7ZBKVC5BZhaMmuT4ITrKd66h2goRY4wEWz/v1iwhuLyNfgUo
enXjG65PrxiiqirGiLPS5UtEvoqMQ8PsyaSILnYqpgJKd9AdP9NQjvjnG6PxA/Y=
=TfhG
-----END PGP SIGNATURE-----
