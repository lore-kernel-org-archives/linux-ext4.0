From: Andreas Dilger <adilger@dilger.ca>
Subject: ext4-lazy (SMR-optimizations) landing to kernel?
Date: Mon, 10 Apr 2017 21:06:23 -0600
Message-ID: <6B0F0C59-6930-41B3-8EE4-EA5BEECEB9F9@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_D923EC4E-59AD-4E35-9A28-3C444786267C";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Ts'o Theodore <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:34514 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751564AbdDKDG2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Apr 2017 23:06:28 -0400
Received: by mail-io0-f174.google.com with SMTP id a103so55753585ioj.1
        for <linux-ext4@vger.kernel.org>; Mon, 10 Apr 2017 20:06:28 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_D923EC4E-59AD-4E35-9A28-3C444786267C
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

Hi Ted,
now that FAST'17 is behind us, is there any plan to land the ext4-lazy code
(SMR optimizations) to the upstream kernel?  This looks like it improves
some workloads even without SMR disks, and doesn't have any noticeable
overhead for other workloads.

I'd guess the one thing that we might want to do is still allow the journal
to optionally checkpoint the metadata to the filesystem in the background,
when the filesystem is otherwise idle, so that in case of journal loss for
some reason the whole filesystem is not lost?

Cheers, Andreas






--Apple-Mail=_D923EC4E-59AD-4E35-9A28-3C444786267C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFY7EgxpIg59Q01vtYRAgTPAJ98/LTrZDaRC8ZKyGlEKs17cY15qwCdEAcC
g6QeLPG3tmystkYeHeMk+88=
=6vwv
-----END PGP SIGNATURE-----

--Apple-Mail=_D923EC4E-59AD-4E35-9A28-3C444786267C--
