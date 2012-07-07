From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: e2defrag 0.81 released
Date: Sat, 7 Jul 2012 00:02:26 -0600
Message-ID: <6642BE04-8D3A-4B15-8FB1-05DFB80CB6B9@dilger.ca>
References: <4FF76E37.1020001@ubuntu.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-19-409009938"
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:55091 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab2GGGC3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Jul 2012 02:02:29 -0400
In-Reply-To: <4FF76E37.1020001@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-19-409009938
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii

On 2012-07-06, at 5:01 PM, Phillip Susi wrote:
> Back in the days when dinosaurs walked the earth ( the '90s ), there was
> a defragger for ext2 written by Stephen Tweedie with contributions from
> others including Ted Ts'o.  After many years of abandonment and bit rot,
> I have decided to take over maintainership of the package.  I now feel
> that it is in good enough of a state for a wider audience ( including
> working with extents and other ext4 features ), so I am announcing it
> here and asking for testing.  The project page is
> http://launchpad.net/e2defrag.
> 
> The program opens an unmounted block device and parses the filesystem
> itself, assigns new locations for all blocks, packing them to the left
> within their native block group if possible, then moves all the blocks
> around quickly and efficiently.  The process it fast, but unsafe: should
> anything go wrong or the process be interrupted, your fs will be toast.

I hate to rain on your parade, but, are you aware of e4defrag?

It is already in e2fsprogs, and can be used on a mounted ext4 filesystem...
It also needs some lovin' to make it really robust, but would definitely
be a better starting point than the ancient e2defrag code...

That's why it is always a good idea to post to the mailing list _before_
you start on a project, to see what else is going on...  Definitely there
is a need for such a tool, but I hate to see effort being spent in two
different directions to make two so-so tools, when it could be going in
the same direction to make one excellent tool.

Cheers, Andreas

> Therefore:
> DO NOT USE ON A FS YOU CARE ABOUT AND/OR HAVE NOT BACKED UP FIRST
> 
> Should a bug cause it to trash your fs, a raw e2image ( e2image -r
> /dev/sda1 - | bzip2 -c > sda1.e2i.bz2 ) made before the defrag, and
> obviously saved on another fs, would be most helpful in debugging.
> 
> One of the more interesting features is the ability to pass a list of
> inodes to be given priority over others.  This can be used to pack a set
> of files together at the start of the disk to allow for faster booting.
> I cobbled together a simple python script, dump2inodes, that can obtain
> the list of files that ureadahead ( Ubuntu ) loads during boot and
> generates the inode priority listing you can pass to e2defrag, and this
> gives some nice boot time improvements.
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.11 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
> 
> iQEcBAEBAgAGBQJP9243AAoJEJrBOlT6nu75GPAIAJuZ7IiBH1YinJXFTil+R6z9
> EtLI4lZkHeWUGbVr/CnhV9l1iYIVo/aqPCBo4yH0efFGPSxF9z/KN8zIEvqs3Q30
> nDe1dNACyvkeIfzyP7wkFxuqK7hX7wkF+cIYT24MftTGTfaXssnoJ5bGd9TyJ0+s
> 8fNM/Erq4saRBnq4aty/Q3FsAF9sc4ke5042FHNSM+xCFfHjZcsciTdPZP5svAcH
> 8crQFmR9ieDIbn1M54mWWp3hYTd368ScJSoiM+K+d8ofbrXRSapJ9bSvuhLjvoxE
> Tx7QXFdHoJb+Id4yf6xI/OZjg9egPW6otkPWwUJfAIE2Wh2AAfnAsGNg4QA86Ws=
> =PK87
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail-19-409009938
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org

iD8DBQFP99DypIg59Q01vtYRAu66AKCraj1UJ43CHdK9djT13VbcqwR+EwCg4BKP
IILAkOZTMZGKeY/8q2SFJhA=
=azXa
-----END PGP SIGNATURE-----

--Apple-Mail-19-409009938--
