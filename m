From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [v4 1/6] Always read full inode structure
Date: Sat, 5 Mar 2016 23:27:25 -0700
Message-ID: <3DEDB39A-8511-470C-A438-726E2672B821@dilger.ca>
References: <1457237696-13770-1-git-send-email-lixi@ddn.com> <1457237696-13770-2-git-send-email-lixi@ddn.com> <20160306054622.GK10297@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: multipart/signed; boundary="Apple-Mail=_3BA24B6F-4E53-4F43-84E9-5A12FC49337F"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Li Xi <pkuelelixi@gmail.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:34822 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbcCFG1d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Mar 2016 01:27:33 -0500
Received: by mail-ig0-f173.google.com with SMTP id hb3so22565322igb.0
        for <linux-ext4@vger.kernel.org>; Sat, 05 Mar 2016 22:27:33 -0800 (PST)
In-Reply-To: <20160306054622.GK10297@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_3BA24B6F-4E53-4F43-84E9-5A12FC49337F
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii


> On Mar 5, 2016, at 10:46 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> On Sun, Mar 06, 2016 at 01:14:51PM +0900, Li Xi wrote:
>> Project quota need use some extra field of inode for computing quota
>> accounting, this patch tries to use ext2fs_get_next_inode_full()
>> everywhere to read full inode into memeory.
>> 
>> It also fixes a bug that only copy small inode in the function.
>> 
>> Signed-off-by: Wang Shilong <wshilong@ddn.com>
> 
> Um, no.  Most of the places where we are currently using
> ext2fs_get_next_inode() is because they **don't** need the full inode.
> For example, consider debugfs's icheck command.  Why would it need the
> project quota id?  Answer: it doesn't.
> 
> If you think there is a bug, or some place where we should be using
> the large inode, fine.  Let's take a look at it.  But doing a whole
> sale conversion of ext2fs_get_next_inode() to
> ext2fs_get_next_inode_full() makes e2fsprogs much less efficient, and
> for no good purpose.

Do you think it really makes e2fsprogs less efficient?  The disk IO has
already happened, and definitely included the whole inode even if only
the small inode data was requested.  The ext2fs block cache will still
cache the whole inode block, so fetching the whole inode is no overhead.

In contrast, several places in the code are doing extra work to fetch
the large inode data after having fetched the small inode data.  It is
also fairly confusing in different parts of the code which "know" that
the inode pointer is pointing to a full inode buffer, so it is a lot
cleaner if we just always read the full inode data everywhere.

Even better would be if the API explicitly just passed ext4_inode_large
everywhere, which wouldn't break the ABI, but it might cause problems
for anything that encodes the argument types (e.g. C++).  At least if
the e2fsprogs internal functions are reading the full inode the code is
easier to understand.

Cheers, Andreas






--Apple-Mail=_3BA24B6F-4E53-4F43-84E9-5A12FC49337F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVtvNznKl2rkXzB/gAQhm5A/+MnAZLuJvW331Z2ULQTtLnQ56tchln7A8
cPAoJUFfMBPnNkATjrOE/18QvCN2GvPa4YZN6syq4qAsQM3zxLQ49YFzMa13KgUk
dDjrc5uHDJ64j/JbP23hZ9o/GEaLtyXLNe6rYm2nGbgfiCI/T19taT+ByiqqDDD9
iR2y9UcSDAGlxsA1nMGMlmdKeZaitEjnOMcilFLOTYHCcwR1nb6HeEirNki7+apZ
5NacKWFHhGJjfXNEd9CB0tPKYbfVMZUGOzOLmTrpFbsnzxkHcz4TnXNEXMAGqTEC
cxCvqo8IKWM98YpVVttNtvAF110Vu7lqLynC1WEl8VUltECgoQ6La5DtoHYGitGJ
0q6rMh9bVl/GxZutduhgVwAiwWi6PEmbAUxF9KjYShAjsQs06OnpQd1iuCxxCcVW
MICFbmjDp+o1z+hWDkHQ0oWl7g5D3oOSw6Zsu3GJ+rEXWhlXyVJNamLq64GJbEKw
hXta5L3jN3FTTt2VosR9+SSxmcdfmFt69mfyhpHCrUWlwVxOdGP5eCqfkQXav0UZ
q3/Fmui4tcB83Ocb6hiRVEuBOCsriHq0SVlHkzym8U/qbGtdUSFudaeENspzjipx
z7aavz4NT/tnfyf3TE4YnkSPaw/PuPbLqJzqD6WolldGJWLg3hu7Tm2TN3dN1jRw
cw92pcZlsmY=
=33p1
-----END PGP SIGNATURE-----

--Apple-Mail=_3BA24B6F-4E53-4F43-84E9-5A12FC49337F--
