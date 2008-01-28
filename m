From: Theodore Tso <tytso@MIT.EDU>
Subject: Oops, incorrect tag: v1.40.5 in e2fsprogs git repository
Date: Mon, 28 Jan 2008 13:19:23 -0500
Message-ID: <20080128181923.GB24206@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; x-action=pgp-signed
Cc: pasky@suse.cz
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:47102 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751900AbYA1ST1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2008 13:19:27 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

I screwed up, and incorrectly tagged v1.40.5 in the e2fsprogs git
repository.  I accidentally tagged the "next" branch instead of the
"maint" branch, so the the wrong commit was tagged as v1.40.5.  Argh...

This has been fixed on git.kernel.org, but it's still busted on
repo.or.cz.  

If you've pulled from the e2fsprogs git repository incorrectly, you'll
need to run the command:

     git tag -d v1.40.5

... and then re-pull from the git repository to get the correct tag.

Petr, if you could run the same command on the e2fsprogs repository on
repo.or.cz, it would be much appreciated!!

				- Ted
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHnhyr7To545NnTEARAr3gAKD1ikMgB74Qw+65fdZRn0kaEXry8ACcDIva
bEVF2ZqTSaaf5hOE3hmfZyw=
=wRDe
-----END PGP SIGNATURE-----
