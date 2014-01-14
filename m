From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: high write latency bug in ext3 / jbd in 3.4
Date: Mon, 13 Jan 2014 17:55:41 -0700
Message-ID: <098224F1-62F8-4AEC-835B-45201F97243C@dilger.ca>
References: <20140113201320.GD1214@kvack.org> <99F82313-71DA-43E6-A071-05507183D481@dilger.ca> <20140113211610.GE1214@kvack.org> <20140113225219.GD11207@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_E937D774-3B31-4272-ACCA-945162B45D3A"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Benjamin LaHaise <bcrl@kvack.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:44101 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbaANAzu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Jan 2014 19:55:50 -0500
Received: by mail-pb0-f45.google.com with SMTP id rp16so8006691pbb.18
        for <linux-ext4@vger.kernel.org>; Mon, 13 Jan 2014 16:55:49 -0800 (PST)
In-Reply-To: <20140113225219.GD11207@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_E937D774-3B31-4272-ACCA-945162B45D3A
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Jan 13, 2014, at 3:52 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Jan 13, 2014 at 04:16:10PM -0500, Benjamin LaHaise wrote:
>> I had hoped to use ext4, but the recommended fsck after changing the 
>> various feature bits is a non-starter during our upgrade process (a 22 
>> minute outage isn't acceptable).
> 
> You can move to ext4 without necessarily using those features which
> require an fsck after the upgrade process.  That's hwo we handled the
> upgrade to ext4 at Google.  New disks were formatted using ext4, but
> for legacy file systems, we enabled extents feature (maybe one or two
> other ones, but that was the main one) and then remounted those file
> systems using ext4.

We also did this for upgraded Lustre ext3 filesystems in the past
(just enabling the extents feature) without any problems.  So long
as you don't need things like fallocate() (which presumably you don't
since that doesn't work for ext3) then the application can't tell the
difference between new extent-mapped and old block-mapped files.

This only affects new files, so old files are not changed.

Cheers, Andreas

> We called file systems which were upgraded in
> this way "ext2-as-ext4", and our benchmarking indicated that for our
> workload, that "ext2-as-ext4" got roughly half the performance gained
> when comparing file systems still using ext2 with newly formated file
> systems using ext4.
> 
> Given that file systems on a server got reformatted when it needs some
> kind of hardware repairs, betewen hardware refresh and disks getting
> reformatted as part of the refresh, the percentage of file systems
> running in "ext2-as-ext4" dropped fairly quickly.
> 
> Mike Rubin gave a presentation about this two years ago at the LF
> Collab Summit that went into a lot more detail about how ext4 was
> adopted by Google.  That presentation is available here:
> 
> 	http://www.youtube.com/watch?v=Wp5Ehw7ByuU
> 
> Cheers,
> 
> 						- Ted


Cheers, Andreas






--Apple-Mail=_E937D774-3B31-4272-ACCA-945162B45D3A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUtSLDnKl2rkXzB/gAQKgSw//azEEXTre6cehesD+DRCph2GyFzRibdkD
iLjyRcEZod8SQB43MuRsQLuvQ0U22qpJNKTN4oJQY/S4NI4XIOesei5VJ0zUmvyb
rRDhStG0I2IBEgwzZtJQcffMl3UUSWKu3bSgmqS4UZldfFCmN14gmFNkzvJN6TwG
FkIfK/RoYzRkWXmd1AhyTPVEcB91achvKFrC2bda2osT8/3H1NszMVnIDmfxnXHE
33yBuzerAex5/D6Amdk3qvrcR7ZfpbiREfGTVhzW028GxZJcjY7AZrHJlJGC3rG+
p0REOnz9EOu4mF+f/bIL0e/xOuR/jB0wBkqoVXxAyWCLYsZAM+uMgYU0ruHkxGsq
6Q0Ghln40Dio8RgvxTSDQVvwZBSRXK5C/c6hDjQx4DLVF94d7svdTHdRSwKCFl0n
lkOUK4iUoGh4vewTget5TNS+PxfgtHfUh6xJQT96byHnk4dZ7AC7qw27bLeJnrwj
0vnAggIxqtvid0lF7wQv1fkLpTc0LOjQTaIGlJ6BF1n0tL9vVuaYGTsQf8qdVLbu
xzYoWp4UQDgGc2hYsuesTCaugtYzdS543SsZG1rFtR0DffcomrVVMV2BCjZEsV8I
kcpHwnZuUqq/tjQs3IR4Z/Q1b7mDI1NJiOzPkFZW+mS/KfO4vGI99n0Obn9hUqjg
DnoxJK6gx2A=
=B970
-----END PGP SIGNATURE-----

--Apple-Mail=_E937D774-3B31-4272-ACCA-945162B45D3A--
