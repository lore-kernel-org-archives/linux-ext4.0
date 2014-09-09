From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 00/25] e2fsprogs Summer 2014 patchbomb, part 5.2
Date: Tue, 9 Sep 2014 16:53:16 -0600
Message-ID: <427E29B6-1780-4CD1-8E31-FE50490F153E@dilger.ca>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_74CFB3C2-62E4-4C8C-8B80-C6A219E7501C"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:57263 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaIIWwn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2014 18:52:43 -0400
Received: by mail-pa0-f44.google.com with SMTP id kx10so6381750pab.3
        for <linux-ext4@vger.kernel.org>; Tue, 09 Sep 2014 15:52:42 -0700 (PDT)
In-Reply-To: <20140908231135.25904.66591.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_74CFB3C2-62E4-4C8C-8B80-C6A219E7501C
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Sep 8, 2014, at 5:11 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> Patch 1 introduces journal_csum v3 to fix numerous journal block tag
> size handling bugs when metadata_csum+journal_checksum are turned on.
> The test of 64bitness should not rely on guessing the tag size when it
> could simply query the feature flags, since it was guessing
> incorrectly.  Furthermore, the journal_csum v2 structure had memory
> access alignment issues.  Just replace this all with a 16-byte tag
> with everything in it; the overhead for checksums is no more than
> 0.1%.

It's really too bad that we are introducing a new journal checksum
feature, when the current journal checksum implementation is
essentially unusable.  Any minor corruption in one transaction block
that has following un-checkpointed transactions will almost certainly
result in _more_ corruption of the filesystem rather than less, due
to all of the *committed* but uncheckpointed blocks being discarded
from the journal.  This would also result in a silent rollback of
filesystem state and loss of user data if running with data=journal.

As a result, there is no practical value (IMHO) to enabling this
feature at all currently.

We've discussed in the past that having per-block checksums is
necessary in order to fix this, so that only corrupt blocks in the
journal are skipped during replay, and may not result in any visible
filesystem corruption if the blocks are overwritten later during
replay.  Otherwise, this will itself result in yet a new block tag
format and journal checksum feature.

Is there any chance you could take a look at implementing this as
part of journal_checksum_v3 instead of fixing the current bugs only
to have a "correctly working" but not usable feature?

Cheers, Andreas

> NOTE: The test "j_corrupt_journal_block" in patch 21 ensures that
> e2fsck will replay everything but the corrupt block, and then proceeds
> with the fsck to fix up whatever might be broken.  You can decompress
> the image.gz and try to mount it to verify that it's unmountable (and
> hence requires e2fsck to be run).
> 
> Patches 23-25 implement v2 of the e2fsck readahead functionality,
> which promises to reduce fsck runtime by 10-30%.  You might want to
> read the report: http://marc.info/?l=linux-ext4&m=140755433701165&w=2
> ("e2fsck readahead speedup performance report") for all the juicy
> details!
> 
> I've tested these e2fsprogs changes against the -next branch as of
> 8/29.  The patches have been tested against the 'make check' suite and
> some amount of e2fuzz testing.
> 
> Comments and questions are, as always, welcome.
> 
> --D
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_74CFB3C2-62E4-4C8C-8B80-C6A219E7501C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVA+E3HKl2rkXzB/gAQI2Iw/+K3jpp7AHrOkVXXgzmwacqsoalxN5wRbx
Cf45No1MMnuJO08XKYshxpqK6LaHJeyVZALcY5oLZ8IgnoyUrhiHxpmxj8nFqWop
OzOZy0h7OIgW3LBjM3MJxsBBLA3y+GE7Q5AtzUSeATzP36ykFhxkV1oXrcUvNLpV
zFqqeLNYVWkmdEkNVJQnpytm1cVL/Bo/bc45JIawN8dulDwT2bVXOtbPUAmwmF60
cOdYZDR0iVbilstUzPoyMDu95MLGnnP1xKt8Ka6ebWwbwUs8exmo2bH8eOqUzJcI
9X2QdG7klrterAKh7+ecyrFiPHGFYAICurOLqn2qbGgMXUdBvvYfQgvjaMTDd9Dg
e6TpatzPzPJ0IQHBrrwywzk3kBk1dhBNZrG93R2Mv8NyIVzV2P+vSjsGgmpbpolw
fjmTyUCgBIUbZe8GsqdHrh/iTzbJHuad0pdhABsMwoQV475zD4bT3SffViFhexv/
KwkzP9lM6NIBGZ0slfk4P9KG+lL0JZpf9GtGT9UwMAZdNfGz4tRa7rrrrWJhQhE7
OFJGI/huFVdhQqM5vGD3T0nNfDQu2g0kAdCXlSTapllkbT5MH4vZG8hCuNVhPt6J
Z6AihPTKlpozXadOxQ5VWKqyCtSOGf7eQM8HZa4cdkfwYpH1+lg4dSGngSFTgykM
CooFcbfR/ao=
=MBf6
-----END PGP SIGNATURE-----

--Apple-Mail=_74CFB3C2-62E4-4C8C-8B80-C6A219E7501C--
