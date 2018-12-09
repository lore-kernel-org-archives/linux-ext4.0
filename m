Return-Path: <SRS0=zSAL=OS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34483 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbeLIAmk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Dec 2018 19:42:40 -0500
Received: by mail-pg1-f193.google.com with SMTP id 17so3334458pgg.1
        for <linux-ext4@vger.kernel.org>; Sat, 08 Dec 2018 16:42:40 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <92DAED5C-8CE8-43C4-B9B3-E5F4A870445D@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_39D81024-A8B9-468F-837A-61C8EC4B707D";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH e2fsprogs v4 0/9] Support encoding awareness and casefold
Date: Sat, 8 Dec 2018 17:42:35 -0700
In-Reply-To: <20181208174538.GB20708@thunk.org>
Cc: Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel@collabora.com, linux-ext4@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>
References: <20181201003910.18982-1-krisman@collabora.com>
 <20181203051806.GA6639@thunk.org> <87ftvetjfn.fsf@collabora.com>
 <20181208174538.GB20708@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_39D81024-A8B9-468F-837A-61C8EC4B707D
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Dec 8, 2018, at 10:45 AM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
> 
> On Mon, Dec 03, 2018 at 04:00:12PM -0500, Gabriel Krisman Bertazi wrote:
>> I didn't want to load the table in those functions because I didn't want
>> to fail there if the nls_table wasn't found.  If the user has some new
>> unsupported encoding, e2fsprogs could provide some functionality, even
>> if it can't deal with the file tree itself.  Failing during open seemed
>> too harsh.
> 
> Unfortunately, I think the only thing we can do is to fail at open or
> mount if the encoding is unknown.  The problem is that we can't
> correctly handle case-folded directories which have htree enabled.
> The problem is that we might have encoding-oblivious applications,
> such as fuse2fs (for example) where if they use the high-level
> libext2fs interfaces, they don't *need* to be encoding aware.
> 
> But if we don't fail the open, then what do we do if the library
> routine to calculate a directory hash is called?  Most applications
> (or callers in libext2fs for that matter) won't gracefully handle an
> error there.
> 
> It's one thing if we only support Unicode version N, and the file
> system is Unicode version N+1.  So long as the user isn't trying to
> use the new scripts, things are mostly OK.
> 
> But what if the alternate encoding is something completely different?
> Say, EBCDIC, or UTF-EBCDIC[1]?  :-) There really is nothing we can do
> sanely but to fail the mount.
> 
> This also effectively means that new encodings are effectively
> incompatible features, but I think that's OK.

Doesn't this meant that if opening a filesystem with an unknown encoding
fails, that any kind of corruption to the encoding type would cause
problems, and opening the filesystem to _remove_ the encoding would also
fail?

I think that it makes more sense to allow the filesystem to be opened
in this case, and only fail operations that need the specific encoding
(e.g. "e2fsck -fD" that needs to know the hashing).  It shouldn't hurt
tune2fs, debugfs, resize2fs, etc. that probably do not need to know the
encoding.  At worst, they could revert the htree directory to a flat
directory if they need to insert an entry and don't understand how to
hash it.

Cheers, Andreas






--Apple-Mail=_39D81024-A8B9-468F-837A-61C8EC4B707D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlwMZPwACgkQcqXauRfM
H+DKMhAAstS0w/ZpqqtrS1CtqEKmbVBOgRE1dLtC94+DolTvjQggFx43z0ZsEIMn
Jm95oDJ/R4vUlAM9/aFAc19DYyTltYkZcT5Dz6JfF0KftUQNVhGrHyts5E/WJpKU
S0FRmjBSvVjhQQZ181TxHi49fJMO83B6+3EBPpDcVCBoQ9wB8OIFWayt2/g2wWAD
Bcxjqx78MTmHj8cMHidTt9YFo4JbX+9MQkzno6XnDZ2wSx+6iWq7pPVnLAjoCPD8
K7yadsM7kF/jzcLZRKfGSM8N0sh6Ul+zeEAz8/aWdssToumcZjUFeEkN1QBBXyim
82zUvuiO2TWJC4BpnAV8qd6GiY3UJ/WKRFpoS02jMENKHKqJKvA83fKbjLiWw/dA
uCQHl0PECKTov0gnqCd4zoEulbZ4uViIwl47luVwog8WlJwU7DjezYP7zRCCjO8s
MFil/erIFhXsiGmkYTVWb1cfa7OD5IcDLZGAliEmhQxg2O8gjBMUUBeBdQaBAqGF
ZNMtp2gmdcdKaznQDd+UBabg7vxl+3Zp48p87F/Zi7la4tztzmksVuqaVtW1HLI3
a4WFybyeg8xU0pbdHy5rzrA2a5z499nJJ2u3Nqd1pYsoI46pOHtcAvhwlXygy0bD
OMXAUmCkTIxzVOduBCPhXgFQcmuXVUwSIqhIFom5ubbnJWvfWOA=
=6UvV
-----END PGP SIGNATURE-----

--Apple-Mail=_39D81024-A8B9-468F-837A-61C8EC4B707D--
