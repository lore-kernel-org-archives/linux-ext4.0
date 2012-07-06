From: Phillip Susi <psusi@ubuntu.com>
Subject: e2defrag 0.81 released
Date: Fri, 06 Jul 2012 19:01:11 -0400
Message-ID: <4FF76E37.1020001@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:22924 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab2GFXBN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jul 2012 19:01:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

It's back!

Back in the days when dinosaurs walked the earth ( the '90s ), there was
a defragger for ext2 written by Stephen Tweedie with contributions from
others including Ted Ts'o.  After many years of abandonment and bit rot,
I have decided to take over maintainership of the package.  I now feel
that it is in good enough of a state for a wider audience ( including
working with extents and other ext4 features ), so I am announcing it
here and asking for testing.  The project page is
http://launchpad.net/e2defrag.

The program opens an unmounted block device and parses the filesystem
itself, assigns new locations for all blocks, packing them to the left
within their native block group if possible, then moves all the blocks
around quickly and efficiently.  The process it fast, but unsafe: should
anything go wrong or the process be interrupted, your fs will be toast.
 Therefore:

DO NOT USE ON A FS YOU CARE ABOUT AND/OR HAVE NOT BACKED UP FIRST

Should a bug cause it to trash your fs, a raw e2image ( e2image -r
/dev/sda1 - | bzip2 -c > sda1.e2i.bz2 ) made before the defrag, and
obviously saved on another fs, would be most helpful in debugging.

One of the more interesting features is the ability to pass a list of
inodes to be given priority over others.  This can be used to pack a set
of files together at the start of the disk to allow for faster booting.
 I cobbled together a simple python script, dump2inodes, that can obtain
the list of files that ureadahead ( Ubuntu ) loads during boot and
generates the inode priority listing you can pass to e2defrag, and this
gives some nice boot time improvements.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJP9243AAoJEJrBOlT6nu75GPAIAJuZ7IiBH1YinJXFTil+R6z9
EtLI4lZkHeWUGbVr/CnhV9l1iYIVo/aqPCBo4yH0efFGPSxF9z/KN8zIEvqs3Q30
nDe1dNACyvkeIfzyP7wkFxuqK7hX7wkF+cIYT24MftTGTfaXssnoJ5bGd9TyJ0+s
8fNM/Erq4saRBnq4aty/Q3FsAF9sc4ke5042FHNSM+xCFfHjZcsciTdPZP5svAcH
8crQFmR9ieDIbn1M54mWWp3hYTd368ScJSoiM+K+d8ofbrXRSapJ9bSvuhLjvoxE
Tx7QXFdHoJb+Id4yf6xI/OZjg9egPW6otkPWwUJfAIE2Wh2AAfnAsGNg4QA86Ws=
=PK87
-----END PGP SIGNATURE-----
