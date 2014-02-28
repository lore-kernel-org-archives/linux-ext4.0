From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/2] libext2fs/e2fsck: implement metadata prefetching
Date: Fri, 28 Feb 2014 11:54:55 -0700
Message-ID: <E7F923E4-91D6-4F9B-97CD-0A4C305EC507@dilger.ca>
References: <20140130235044.31064.38113.stgit@birch.djwong.org> <20140130235058.31064.21096.stgit@birch.djwong.org> <45DEEA58-69FD-42EF-BB51-1A8D80000469@dilger.ca> <20140131135325.GF7118@thunk.org> <530F6FFC.4040903@ubuntu.com> <20140228022826.GA31809@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: multipart/signed; boundary="Apple-Mail=_4903F464-F637-42CF-B2FF-646BBB8BD723"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Phillip Susi <psusi@ubuntu.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60129 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaB1SzQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Feb 2014 13:55:16 -0500
Received: by mail-pa0-f43.google.com with SMTP id bj1so1034132pad.16
        for <linux-ext4@vger.kernel.org>; Fri, 28 Feb 2014 10:55:15 -0800 (PST)
In-Reply-To: <20140228022826.GA31809@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_4903F464-F637-42CF-B2FF-646BBB8BD723
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Feb 27, 2014, at 7:28 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Feb 27, 2014 at 12:03:56PM -0500, Phillip Susi wrote:
>> 
>> Why build your own cache instead of letting the kernel take care of
>> it?  I  believe the IO elevator already gives preferential treatment
>> to blocking reads so just using readahead() to prefetch and sticking
>> with plain old read() should work nicely.
> 
> The reason why it might be better for us to use our own cache is
> because we can more accurately know when we're done with the block,
> and we can drop it from the cache.

One argument in favour of using the kernel buffer cache is that the
common case of e2fsck followed by mounting the filesystem would be
much faster because e2fsck has already populated the kernel cache.
Otherwise, all of the IO done to populate the userspace cache would
be lost when e2fsck exits.  Similarly, repeated runs of e2fsck would
not see any benefit of the userspace cache.

> I suppose we could use posix_fadvise(POSIX_FADV_DONTNEED) --- and
> hopefully this works on block devices for the buffer cache, but it
> wouldn't all surprise me that if we can get finer-grained control if
> we use O_DIRECT and manage the buffers ourselves.  Whether it's worth
> the extra complexitry is a fair question --- but simply adding
> metadata prefetching is going to add a fair amount of complexity
> already, and we should test to make sure that readahead() and
> posix_fadvise() actually work correctly on block devices --- a couple
> of years ago, I had explored readahead() precisely as a cheap way of
> adding metadata precaching for e2fsck, and it was a no-op when I tried
> the test back then.

We tested several different mechanisms for readahead a few years ago
for the e2scan tool, and that resulted in the readahead patch that
Darrick updated recently.  It definitely shows performance improvement.

Whether POSIX_FADV_DONTNEED actually flushes pages from cache is a
separate question.  My preference would be that if this is currently
a no-op that we work to fix it in the kernel so that it is working
for everyone rather than investing time and effort into code that is
only useful for e2fsprogs.

Cheers, Andreas






--Apple-Mail=_4903F464-F637-42CF-B2FF-646BBB8BD723
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUxDbgHKl2rkXzB/gAQIeZRAAtSpeZydGNTYivhFw3bAkdtpTFplAxYsm
MOksTqfRFlXOnQJdaJNbJj/vjWpELrQepZK+3QsQzLQNiPz9cz85Xqf7CHODcEX8
wM5lCWDxfnh7K3EEmFJGVBz4LavRXIJ+skXgcGOb95wXXY5dekXNzgSd+YALy3Wd
mbilElbWOV6ynzac5REFzuTJ2qMXP+yt0q9w3B1jQ56Fn+GsdFmoAjmvNNgM0aVh
2gNGJ4ecfp3mhazr0Nj4/tRiANlMYXFvmWNU1ovWqlC8ZTiaNSRiyBKZlOrLrRHl
9CQ+FvzyKFvLMajQ5OSLmwcpr3Y3s8vJLoNf55UMzCiHeo3jk3Zidp112eSG8Biw
oFHvHGhLzARQlIaWT2iAm+hHDWgUoP4XK/MvR5rjzZOWsWKTlTEt2XEV/08DZo0L
XsI2qXA4y/lGuKGnY75vVpEKrSvx3aolMsOefkLcqLh7wHuMbuTfEmi2ytqZbLwj
LTq5uooC0WnHOy6fuzLwTPjNvl7AkZqW2e410eJzX371q9zniHTol944jvdLI40Q
kEKGOZ4mw4EqmldO3koZWkUQBuhO/PUU0NxyxeoxqUktfJtOYwda17Hw1TSqAad/
8k2J/BWDqu1mMqZX7YLFsHVA7l+9ErRmcOuFizo8bEAv4zYHOee+07gDv+M5NWAw
uEVDLVhoLlE=
=kD4A
-----END PGP SIGNATURE-----

--Apple-Mail=_4903F464-F637-42CF-B2FF-646BBB8BD723--
