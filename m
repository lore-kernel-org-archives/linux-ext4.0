From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC][PATCH 0/1] ext4: Fix ext4_mb_normalize_request
Date: Tue, 24 Jun 2014 10:25:56 -0600
Message-ID: <A4318EB6-BE6B-4D69-877C-5CC7F3518C66@dilger.ca>
References: <1402667736-7843-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1406241435320.4772@localhost.localdomain>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: multipart/signed; boundary="Apple-Mail=_9EE3444B-7CE7-4D4F-BF0D-235DBCCD2C2C"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Alex Zhuravlev <alexey.zhuravlev@intel.com>
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:61585 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437AbaFXQ0C (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jun 2014 12:26:02 -0400
Received: by mail-pd0-f182.google.com with SMTP id y13so433220pdi.41
        for <linux-ext4@vger.kernel.org>; Tue, 24 Jun 2014 09:26:01 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1406241435320.4772@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_9EE3444B-7CE7-4D4F-BF0D-235DBCCD2C2C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

On Jun 24, 2014, at 6:36 AM, Luk=E1=9A Czerner <lczerner@redhat.com> =
wrote:
> On Fri, 13 Jun 2014, Lukas Czerner wrote:
>=20
>> Date: Fri, 13 Jun 2014 15:55:35 +0200
>> From: Lukas Czerner <lczerner@redhat.com>
>> To: linux-ext4@vger.kernel.org
>> Subject: [RFC][PATCH 0/1] ext4: Fix ext4_mb_normalize_request
>>=20
>> This is my first attempt to fix the ext4_mb_normalize_request()
>> function in in ext4 which deals with file preallocations.
>>=20
>> This is not yet a final version as it needs more testing, however
>> I'd like to see some suggestions.
>=20
> Does anyone have any comments on this and the related patch ?

Comments inline.

>> Currently there are couple of problems with =
ext4_mb_normalize_request().
>>=20
>> - We're trying to normalize unwritten extents allocation which is
>>  entirely unnecessary, because user exactly knows what how much space
>>  he is going to need - no need for file system to do preallocations.
>>=20
>> - ext4_mb_normalize_request() unnecessarily divides bigger allocation
>>  requests to small ones (8MB). I believe that this is a bug rather
>>  than design.

The reason that the large requests were broken into smaller ones is
because it becomes increasingly difficult to find large contiguous
extents as the filesystem becomes more full.  If there was a single
buddy bitmap for the whole filesystem then it would be possible to
scan for e.g. 64MB extents of free blocks, but with the current code
this may require loading up a new block bitmap for each allocation.

It may be that with the optimizations that have been landed since the
mballoc code was originally written (to cache the largest free extent
in memory for each group) that this group descriptor walk may be fast
enough to handle large allocations.  In that case, the limit on the
number of groups to scan for an allocation may need to be increased.

>> - For smaller allocations (or smaller files) we do not even respect =
the
>>  fe_logical. Although we do respect it for bigger files.

This is done so it is possible to pack many small allocations into a
single large RAID stripe to avoid read-modify-write overhead.

>> - Overall the logic within ext4_mb_normalize_request() is weird and
>>  no-one really understand why it is the way it is.
>>=20
>> Fix all of this by:
>>=20
>> - Disabling preallocation for unwritten extent allocation. However
>>  because the maximum size of the unwritten extent is one block =
smaller
>>  than written, in order to avoid unnecessary fragmentation we limit =
the
>>  request to EXT_INIT_MAX_LEN / 2

That should work out well.  Once the extents are converted to =
initialized
extents they can be merged, and this will also leave some room to split
uninitialized extents if they are not completely overwritten.

>> - Get rid of the "if table" in ext4_mb_normalize_request() and =
replace
>>  it with simply aligning the assumed end of the file up to power of
>>  two. But we still limit the allocation size to =
EXT4_BLOCKS_PER_GROUP.
>>  Also do this on file system block units to take into account =
different
>>  block sized file systems.

We have a patch to make this table tunable, but in the end we never used
anything other than the default power-of-two values, so I don't think it
is a loss to remove this code.  That said, it would actually be better =
to
align with the s_stripe_width instead of the next power-of-two value.

It is important to note that having more extents is not a significant
performance impact if they are at least 4-8MB in size, but if the =
allocator
causes read-modify-write on a RAID array can cut performance in half.

>> It passes xfstests cleanly in default configuration, I've not tried =
any
>> non-default options yet.
>>=20
>> I've tried to test how much it changes allocation. The test and some =
results
>> can be found at
>>=20
>> http://people.redhat.com/lczerner/mballoc/
>>=20
>> normalize.sh is the simple script I run and output.normalize_orig[34]
>> contains result from the vanila  3.15.0 while =
output.normalize_patch[56]
>> contains results with this patch.
>>=20
>> =46rom the performance stand point I do not see any major differences =
except
>> that untar seems to always generate better results (which might be =
because
>> of bigger continuous extents).

Actually, looking at the results, while the extent allocations look more
"regular" with the patched code, the actual performance is significantly
worse for some tests, both in terms of speed and in terms of free space
fragmentation:

orig3:					patch5:
[+] Fallocate test			[+] Fallocate test

real	0m0.216s			real	0m0.290s
user	0m0.000s			user	0m0.001s
sys	0m0.061s			sys	0m0.037s
Device: /dev/loop0			Device: /dev/loop0
Blocksize: 4096 bytes			Blocksize: 4096 bytes
Total blocks: 22282240			Total blocks: 22282240
Free blocks: 3535514 (15.9%)		Free blocks: 3535512 (15.9%)

Min. free extent: 32 KB 		Min. free extent: 32 KB=20
Max. free extent: 2064256 KB		Max. free extent: 2064256 KB
Avg. free extent: 235700 KB		Avg. free extent: 228096 KB

orig3:					patch5:
[+] Copy linux source			[+] Copy linux source

real	4m17.888s			real	5m24.326s
user	0m2.265s			user	0m2.486s
sys	2m4.205s			sys	2m34.918s
Device: /dev/loop0			Device: /dev/loop0
Blocksize: 4096 bytes			Blocksize: 4096 bytes
Total blocks: 22282240			Total blocks: 22282240
Free blocks: 17536027 (78.7%)		Free blocks: 17536042 (78.7%)

Min. free extent: 4 KB 			Min. free extent: 4 KB=20
Max. free extent: 2064256 KB		Max. free extent: 2064256 KB
Avg. free extent: 267724 KB		Avg. free extent: 209384 KB

orig3:					patch5:
[+] Untar linux source			[+] Untar linux source

real	3m34.945s			real	3m43.807s
user	0m3.459s			user	0m3.687s
sys	1m35.126s			sys	1m42.839s
Device: /dev/loop0			Device: /dev/loop0
Blocksize: 4096 bytes			Blocksize: 4096 bytes
Total blocks: 22282240			Total blocks: 22282240
Free blocks: 8852805 (39.7%)		Free blocks: 8852831 (39.7%)

Min. free extent: 4 KB 			Min. free extent: 4 KB=20
Max. free extent: 2064256 KB		Max. free extent: 2064256 KB
Avg. free extent: 102936 KB		Avg. free extent: 72120 KB

The same is true for the "single dd" and "multiple dd" tests.  The only =
one
that shows somewhat better performance and fragmentation results is =
fsstress,
but I wouldn't exactly call that representative of normal user =
workloads.


>> Free space fragmentation seems to be about the same, however with the =
patch
>> there seems to be less smaller free space extents and more bigger =
ones which
>> is expected due to bigger preallocations (and I think it's a good =
thing).

Hmm, this is exactly the opposite of what I see in the output files?

>> The biggest difference which is obvious from the results is that =
extent tree
>> is much smaller (sometimes five times smaller) with the patch. Except =
of the
>> fallocate case because we now limit the requests to (EXT_INIT_MAX_LEN =
/ 2)
>> so we can not merge them - it might be worth experimenting with =
something
>> smaller which is a factor of unwritten extent size.
>>=20
>> But as I said the extent tree is much smaller which means that the =
extents
>> overall are bigger which again is a good thing. This becomes very =
obvious
>> when we look at the extent tree of the image file (the last steps in =
the
>> test).
>>=20
>> What do you think ?

I definitely agree that there is work to be done to improve this code, =
but
since the results are quite mixed I think it makes sense to separate out
some of the changes into different patches and test them independently.  =
That
will simplify the isolation of which changes are affecting the =
performance.


Cheers, Andreas






--Apple-Mail=_9EE3444B-7CE7-4D4F-BF0D-235DBCCD2C2C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU6mmlXKl2rkXzB/gAQJc5RAAnkaoTVI4MSS9OKHcpBfUghd9pWajeaWg
vXHrWNcJuHC8MlcXRYM+F01P73aO5YEpq0ZIOAnWlRUZV6ogGbCZ7iqY9DIh5o93
u9OUr1cufDg/90F7Wm5pZhTSJfzTnrNWyHrEhKSXAIMlcmbEoTUsw6vzW054hS92
zshXAhOUq4xmn0oODEFq/t4X09Y0FET8q4QzVae7eL1/nK4e1kLZMimp8R6z5Yvh
3iIzC2Qh5fV6BoRjhQ9wQIGAO8fO8jHRVzIyYPeLukYJGNIgHL05SR8VUFGiwvLH
5XrxaQF5+KxVIOm7aRHe+BrP4S4McJwHgn7wUx+GUT6SQwuXeTelSy8fyzoTalAn
dnYOsP58qdgvg8INL6pb2KW72mEpv0clymhsdK0kHRp6vrbKS7IuHv0C37drqIHy
TpVZQzvoZOh9t+H6AsXRMZGBKuCl9A/1CBJjw8tgIUQr7RxL50f1RMrW9xy/3cpd
/YKXNV/5NengEArjNnrAtEpeHUg5I7dvNroNNQWTcZLklMmjIyEicibxvkj8QuW6
n95cqEwyIA2ezbgEbmy710ZdRiN6T6bau7djbqWds3u7moiz/d+rehWl5ttwE8Gm
qxLElRP9VrRPx9TurbB5Xm1ALgLhahxi9dO518qVNmHvS35Ka06EAyDDsgFtRa20
lFifhFiXJrs=
=59rZ
-----END PGP SIGNATURE-----

--Apple-Mail=_9EE3444B-7CE7-4D4F-BF0D-235DBCCD2C2C--
