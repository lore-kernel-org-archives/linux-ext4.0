From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v4] ext4: fix indirect punch hole corruption
Date: Tue, 10 Feb 2015 19:37:20 -0800
Message-ID: <20150211033720.GA20820@mew>
References: <20150209212805.GA10892@mew.cs.washington.edu>
 <bdb70d657b83644c6ee6eaaaf4f95460f937f05c.1423602557.git.osandov@osandov.com>
 <54DAC58B.8030600@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Chris J Arges <chris.j.arges@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:37930 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbbBKDhX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Feb 2015 22:37:23 -0500
Received: by mail-pa0-f43.google.com with SMTP id fa1so1316397pad.2
        for <linux-ext4@vger.kernel.org>; Tue, 10 Feb 2015 19:37:22 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <54DAC58B.8030600@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 10, 2015 at 08:59:23PM -0600, Chris J Arges wrote:
> On 02/10/2015 03:44 PM, Omar Sandoval wrote:
> > Commit 4f579ae7de56 (ext4: fix punch hole on files with indirect
> > mapping) rewrote FALLOC_FL_PUNCH_HOLE for ext4 files with indirect
> > mapping. However, there are bugs in several corner cases. This fixe=
s 5
> > distinct bugs:
> >=20
> > 1. When there is at least one entire level of indirection between t=
he
> > start and end of the punch range and the end of the punch range is =
the
> > first block of its level, we can't return early; we have to free th=
e
> > intervening levels.
> >=20
> > 2. When the end is at a higher level of indirection than the start =
and
> > ext4_find_shared returns a top branch for the end, we still need to=
 free
> > the rest of the shared branch it returns; we can't decrement partia=
l2.
> >=20
> > 3. When a punch happens within one level of indirection, we need to
> > converge on an indirect block that contains the start and end. Howe=
ver,
> > because the branches returned from ext4_find_shared do not necessar=
ily
> > start at the same level (e.g., the partial2 chain will be shallower=
 if
> > the last block occurs at the beginning of an indirect group), the w=
alk
> > of the two chains can end up "missing" each other and freeing a bun=
ch of
> > extra blocks in the process. This mismatch can be handled by first
> > making sure that the chains are at the same level, then walking the=
m
> > together until they converge.
> >=20
> > 4. When the punch happens within one level of indirection and
> > ext4_find_shared returns a top branch for the start, we must free i=
t,
> > but only if the end does not occur within that branch.
> >=20
> > 5. When the punch happens within one level of indirection and
> > ext4_find_shared returns a top branch for the end, then we shouldn'=
t
> > free the block referenced by the end of the returned chain (this mi=
rrors
> > the different levels case).
> >=20
> > Signed-off-by: Omar Sandoval <osandov@osandov.com>
> > ---
> > Okay, two more bugfixes folded in, all described in the commit mess=
age.
> > I'm finally no longer seeing xfstest generic/270 cause corruptions,=
 even
> > after running it overnight, so hopefully this is it. Chris, would y=
ou
> > mind trying this out?
> >
>=20
> Omar,
> I've completed 80 iterations of this patch so far without failure!
> Normally failures have occurred between 2-15 runs. Great job, and tha=
nks
> for your persistence in fixing this issue!
>=20
> Tested-by: Chris J Arges <chris.j.arges@canonical.com>
>=20

Awesome, I was starting to run out of ideas ;) Thanks for all of your
testing.

Luk=C3=A1=C5=A1, would you like to take a look at this?

Also, Ted and Andreas, would you prefer this all in one patch, or shoul=
d
I split out each individual fix into its own patch?

Thanks!
--=20
Omar
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
