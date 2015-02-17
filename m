From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v4] ext4: fix indirect punch hole corruption
Date: Tue, 17 Feb 2015 10:59:52 -0800
Message-ID: <20150217185952.GC3297@mew>
References: <20150209212805.GA10892@mew.cs.washington.edu>
 <bdb70d657b83644c6ee6eaaaf4f95460f937f05c.1423602557.git.osandov@osandov.com>
 <54DAC58B.8030600@canonical.com>
 <20150211033720.GA20820@mew>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150211033720.GA20820@mew>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 10, 2015 at 07:37:20PM -0800, Omar Sandoval wrote:
> On Tue, Feb 10, 2015 at 08:59:23PM -0600, Chris J Arges wrote:
> > On 02/10/2015 03:44 PM, Omar Sandoval wrote:
> > > Commit 4f579ae7de56 (ext4: fix punch hole on files with indirect
> > > mapping) rewrote FALLOC_FL_PUNCH_HOLE for ext4 files with indirec=
t
> > > mapping. However, there are bugs in several corner cases. This fi=
xes 5
> > > distinct bugs:
> > >=20
> > > 1. When there is at least one entire level of indirection between=
 the
> > > start and end of the punch range and the end of the punch range i=
s the
> > > first block of its level, we can't return early; we have to free =
the
> > > intervening levels.
> > >=20
> > > 2. When the end is at a higher level of indirection than the star=
t and
> > > ext4_find_shared returns a top branch for the end, we still need =
to free
> > > the rest of the shared branch it returns; we can't decrement part=
ial2.
> > >=20
> > > 3. When a punch happens within one level of indirection, we need =
to
> > > converge on an indirect block that contains the start and end. Ho=
wever,
> > > because the branches returned from ext4_find_shared do not necess=
arily
> > > start at the same level (e.g., the partial2 chain will be shallow=
er if
> > > the last block occurs at the beginning of an indirect group), the=
 walk
> > > of the two chains can end up "missing" each other and freeing a b=
unch of
> > > extra blocks in the process. This mismatch can be handled by firs=
t
> > > making sure that the chains are at the same level, then walking t=
hem
> > > together until they converge.
> > >=20
> > > 4. When the punch happens within one level of indirection and
> > > ext4_find_shared returns a top branch for the start, we must free=
 it,
> > > but only if the end does not occur within that branch.
> > >=20
> > > 5. When the punch happens within one level of indirection and
> > > ext4_find_shared returns a top branch for the end, then we should=
n't
> > > free the block referenced by the end of the returned chain (this =
mirrors
> > > the different levels case).
> > >=20
> > > Signed-off-by: Omar Sandoval <osandov@osandov.com>
> > > ---
> > > Okay, two more bugfixes folded in, all described in the commit me=
ssage.
> > > I'm finally no longer seeing xfstest generic/270 cause corruption=
s, even
> > > after running it overnight, so hopefully this is it. Chris, would=
 you
> > > mind trying this out?
> > >
> >=20
> > Omar,
> > I've completed 80 iterations of this patch so far without failure!
> > Normally failures have occurred between 2-15 runs. Great job, and t=
hanks
> > for your persistence in fixing this issue!
> >=20
> > Tested-by: Chris J Arges <chris.j.arges@canonical.com>
> >=20
>=20
> Awesome, I was starting to run out of ideas ;) Thanks for all of your
> testing.
>=20
> Luk=C3=A1=C5=A1, would you like to take a look at this?
>=20
> Also, Ted and Andreas, would you prefer this all in one patch, or sho=
uld
> I split out each individual fix into its own patch?
>=20
> Thanks!
> --=20
> Omar

Hi,

I figure things are busy because of the merge window, but I wanted to
check on the status of this patch. I also have some regression tests fo=
r
xfstests ready to go.

Thanks!
--=20
Omar
