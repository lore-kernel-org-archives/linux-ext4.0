From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC] mke2fs -E hash_alg=siphash: any interest?
Date: Wed, 24 Sep 2014 00:25:53 +0200
Message-ID: <24F09699-B86B-4F73-8D93-1650B2BFC483@dilger.ca>
References: <20140921095339.9074.qmail@ns.horizon.com> <20140921175515.GA30646@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_6378235F-7835-4519-8AD5-69C637415E8E"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: George Spelvin <linux@horizon.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42793 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275AbaIWW0H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Sep 2014 18:26:07 -0400
Received: by mail-wi0-f172.google.com with SMTP id em10so5824195wid.17
        for <linux-ext4@vger.kernel.org>; Tue, 23 Sep 2014 15:26:06 -0700 (PDT)
In-Reply-To: <20140921175515.GA30646@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_6378235F-7835-4519-8AD5-69C637415E8E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 21, 2014, at 7:55 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sun, Sep 21, 2014 at 05:53:39AM -0400, George Spelvin wrote:
>>=20
>> Basically, it offers security similar to teahash with a faster, and =
better studied, primitive designed specifically for this application.
>>=20
>> I'm thinking of turning this into a patch for ext2utils and fs/ext4.
>>=20
>> Could I ask what the general level of interest is?  On a scale of =
"hell,
>> no, not more support burden!" to "thank you, I've been meaning to =
find
>> time to add that!"
>=20
> I'm certainly not against adding a new hash function.  The reality is
> that it would be quite a while before we could turn it on by default,
> because of the backwards compatibility concerns.
>=20
> The question I would ask is whether we can show an anctual performance
> improvement with the hash being used in situ.  Let's give it the best
> possible chance of making a difference; let's assume a RAM disk with a
> very metadata intensive benchmark, with journalling turned off.  What
> sort of difference would we see, either in terms of system CPU time,
> wall clock time, etc.?
>=20
> The results of such a benchmark would certainly make a difference in
> how aggressively we might try to phase in a new hash algorithm.

Now that the patches are available, it makes sense to run some
directory-intensive benchmark to see whether the improved hash
function actually shows improved performance.  The hash may be
somewhat faster, but since this is only hashing the filename and
not KB/MB of data, it isn't clear whether this is going to improve
observable performance of directory operations.

I'm not sure what a suitable benchmark for this is, however.  It
needs to be doing filename lookups to exercise the hashing, but
in the workloads that I can think of there is always a lot more
work after the name is looked up (e.g. open(), stat(), etc) on
the filename.  Some possibilities include "ls -l" or "mv A/* B/".
It may be the only way to see the difference is via oprofile.

It also isn't clear whether the strength of siphash is significantly
better than "halfmd4", which is already cryptographically-strong.
Since the filename hash is also a function of the filesystem-unique
s_hash_seed, mounting an "attack" on a directory needs to be specific
to a particular filesystem, and isn't portable to other filesystems.

Cheers, Andreas






--Apple-Mail=_6378235F-7835-4519-8AD5-69C637415E8E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVCHzcXKl2rkXzB/gAQKdyhAAgrqIouHdyDaKvIuIGXLwQhCTaSXR9Dh7
XUt4AuUVtcXRSPM9xbZKOzkisO3yuzrxuZXwIb7HqY7NqCfVHarfL0+UbIf+Pb3T
exRkJ27lLc2hlKBNEEwdMPvUOlfliL0/9daFVu5RZ1dQ1k6mXLQAr3acUQZdLSo1
6uyMUYX3lndlCvpQ/ODi/fMMD+pz612g0Q4gimtT9mhyTboYjq7Eifly9qFvR9rb
g8B/BU4D9wJ+f7ZGsm0xbJ702cqYyzacigMSHwtd09vNiO+4i8mqkyd5RGBw9Vwb
DAsO4hJQ59AoOHKTubFmrXud1AguYNAwhdJmYiDm1ZISUA8XLjeelnVCGaK5r/MX
aKPtXOKNG7/mFpaW14YpXS4eF9LuPaQxwgGr4g9iLXe6wnt9SONP3Ua1C0nvCq8r
pyLEg2+feJYFMg3MC9QPW/wIoOPnoBQf8A3X1hh3odtceDev5y+1EaR89U/g5kyg
yM4hpvwNwynHjDA2lp7iNsuIBoVJJuajenEirBdxCpoNW6iYouNjUFMVXvbfWjex
ndYEMQgAqtAsQk/qtmw4BXzmAweo2hWqTmTCZ7Ui15UrlJTdncl1CvFMEzRX4NCM
btBnDIg81K5iYhwYwIrIqVi7EKlfEC8p15ZjCEy4V/Ki/15PAIbTBL+Wb+SKK3AW
0dKgBXDCeBI=
=gAAe
-----END PGP SIGNATURE-----

--Apple-Mail=_6378235F-7835-4519-8AD5-69C637415E8E--
