From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/2] ext4: fix bug in ext4_mb_normalize_request()
Date: Fri, 7 Mar 2014 14:09:10 -0700
Message-ID: <A0F40696-AABF-4D2D-AA37-3E4D4BC8EBBE@dilger.ca>
References: <1393855228-13592-1-git-send-email-mlombard@redhat.com> <1393855228-13592-3-git-send-email-mlombard@redhat.com> <20140306154407.GA28226@thunk.org> <20140306165416.GA2182@dhcp-27-189.brq.redhat.com> <alpine.LFD.2.00.1403061842240.2249@localhost.localdomain> <20140306183232.GB30706@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: multipart/signed; boundary="Apple-Mail=_B9184F1E-8E39-453A-A8B8-73989595A460"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>,
	Alexey Zhuravlev <alexey.zhuravlev@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:52791 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaCGVKN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Mar 2014 16:10:13 -0500
Received: by mail-pb0-f54.google.com with SMTP id ma3so4652885pbc.41
        for <linux-ext4@vger.kernel.org>; Fri, 07 Mar 2014 13:10:12 -0800 (PST)
In-Reply-To: <20140306183232.GB30706@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_B9184F1E-8E39-453A-A8B8-73989595A460
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

On Mar 6, 2014, at 11:32 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Mar 06, 2014 at 06:54:05PM +0100, Luk=E1=9A Czerner wrote:
>>=20
>> All that said, I was getting to rewrite this mess a long time ago,
>> it's just a reminder that it's something that needs to be done.
>> Especially since the bigger requests are getting split unnecessarily
>> which hurts especially in fallocate case.
>=20
> We should try to get input from Andreas about what some of the more
> interesting hueristics in mballoc were trying to accomplish, since
> there's a lot going on that's not obvious, and one of the reasons why
> I've always been worried about trying to do cleanups was because
> something that looks ugly might be papering over some other dark
> corner of mballoc.c ---- and so I was fairly certain that one we
> started opening up mballoc.c, we'd have to do a lot of work on it, and
> a lot of performance measurements to make sure we didn't accidentally
> introduce some performance regression.

There is actually quite a lengthy description of mballoc at the start
of the file.  I guess it would make sense to turn anything in this
thread into comments for ext4_mb_normalize_request() once verified.

So, below is hopefully a summary of what ext4_mb_normalize_request()
is actually doing.  I've CC'd Alex to correct my mistakes.  I think
the first few cases are commented accurately and self explanatorily:

* don't prealloc blocks for non-regular files (!EXT4_MB_HINT_DATA)
  - should we reconsider this for larger directories?
* don't use prealloc if caller wants exact (EXT4_MB_HINT_GOAL_ONLY)
  - currently unused, but would be useful for defrag
* don't reserve blocks if caller doesn't want it =
(EXT4_MB_HINT_NOPREALLOC)
  - used for small files or if requested data fits exactly into extent
* if write is a small file, use group prealloc =
(EXT4_MB_HINT_GROUP_ALLOC)
  - this combines multiple small writes into a single prealloc region
    and avoids read-modify-write of RAID stripes

The rest of the function is about handling large file writes =
efficiently.
* round up small writes to a power-of-two value for better alignment
  - we have a patch that makes the preallocation region sizes tunable,
    if that is something of interest.  That said, we don't really use =
it.
* if the request is large, align it to a power-of-two boundary
  - the allocation goal is based on the logical file offset, so that if
    a file is written sparsely by multiple threads, it can coalesce into
    a densely packed file in the end.  This is common for HPC jobs, or
    applications like bittorrent.
* the list_for_each() loops align the prealloc region with other regions
  - this helps when the file becomes fully allocated that the regions
    will be contiguous on disk

I'm pretty sure some of this is not 100% accurate, hopefully Alex can
comment and correct any inconsistencies.

Cheers, Andreas






--Apple-Mail=_B9184F1E-8E39-453A-A8B8-73989595A460
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUxo1dnKl2rkXzB/gAQLnKBAAvP3uBuFdQ/ORHx7Wt2lpfCi6roh97DzS
mNJpWlZl7fqiJ6UG854bnHEoDmPC9kYspZI4JEUl+82QPVCYRe98OdmSWLbB++4B
7AExWkZ23KQa9po6nf7+27RjpMWmkxsHPAXdeyApP5n+EF1adsC4p9Yq6a63x3Vj
INyCmCn6R1Lo2E0SoJKGZN0iQ5EJNFCfVR6AHEhUGQRlfD71+LI4VDqv4OR2Q5ZJ
wDmCIiAG+Emcl+nvhbcreWc133T+kjuMJSktkHQGb/AZSLvFJxLnKVuIs8+4MB96
Mp1XNKGbSRj7KgDJeacPjSJ0kSO0Z70VLgfvfVqso60VGCFOTjBw5p3d01jgC6Zr
PJkhdSFVURAlOrn0xTesoV09reaOsR0ArYRqt5/US8CSGS7P7oInQjB1Y3KiEXuC
ydFJf6Drly9No2dolhkzpUDohhaNQ/Uz1tVUSXH09GWQTv0q03FU68cFBoRp6gOT
Xo+dw6jZHPX6hD2tXkyFWEEg3mOfqz1kIdrH6tqLJaDwXQmnJP3bOSCNEmduQns5
ZgmTNWm5aKd8/304qn3CGohX6jxEGmrRnqzTxKVR0loS0cQ+k6npkX/XmcL/sWfn
K/kkRqYKkpQo9uvvAN/5v828Y4/XCxIjupOYYdGTFNnq+DAkcyyP90FXh+nxpJ05
pokcIhDyNfo=
=RRsP
-----END PGP SIGNATURE-----

--Apple-Mail=_B9184F1E-8E39-453A-A8B8-73989595A460--
