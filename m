From: NeilBrown <neilb@suse.de>
Subject: Re: ext4 write performance regression in 3.6-rc1 on RAID0/5
Date: Thu, 23 Aug 2012 07:59:45 +1000
Message-ID: <20120823075945.4dd02cbd@notabene.brown>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
	<20120816024654.GB3781@thunk.org>
	<20120816111051.GA16036@localhost>
	<20120816152513.GA31346@thunk.org>
	<20120817060915.GB28786@localhost>
	<20120817134039.GB11439@thunk.org>
	<20120817142526.GA1059@localhost>
	<20120822035702.GF2570@yliu-dev.sh.intel.com>
	<20120822160025.272188d1@notabene.brown>
	<CAA9_cmc4t_P3p-72iZx4UALNe3fupVqBKvvsvCtMH6G3HZUdww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4_+e5+VL34ObpP6rg+7KLCz"; protocol="application/pgp-signature"
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Li Shaohua <shli@fusionio.com>,
	"Theodore Ts'o" <tytso@mit.edu>, Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com,
	"Shi, Alex" <alex.shi@intel.com>, linux-fsdevel@vger.kernel.org,
	linux RAID <linux-raid@vger.kernel.org>
To: Dan Williams <djbw@fb.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59278 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab2HVWAM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Aug 2012 18:00:12 -0400
In-Reply-To: <CAA9_cmc4t_P3p-72iZx4UALNe3fupVqBKvvsvCtMH6G3HZUdww@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Sig_/4_+e5+VL34ObpP6rg+7KLCz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 22 Aug 2012 13:47:07 -0700 Dan Williams <djbw@fb.com> wrote:

> On Tue, Aug 21, 2012 at 11:00 PM, NeilBrown <neilb@suse.de> wrote:
> > On Wed, 22 Aug 2012 11:57:02 +0800 Yuanhan Liu <yuanhan.liu@linux.intel=
.com>
> > wrote:
> >
> >>
> >> -#define NR_STRIPES           256
> >> +#define NR_STRIPES           1024
> >
> > Changing one magic number into another magic number might help your cas=
e, but
> > it not really a general solution.
> >
> > Possibly making sure that max_nr_stripes is at least some multiple of t=
he
> > chunk size might make sense, but I wouldn't want to see a very large mu=
ltiple.
> >
> > I thing the problems with RAID5 are deeper than that.  Hopefully I'll f=
igure
> > out exactly what the best fix is soon - I'm trying to look into it.
> >
> > I don't think the size of the cache is a big part of the solution.  I t=
hink
> > correct scheduling of IO is the real answer.
>=20
> Not sure if this is what we are seeing here, but we still have the
> unresolved fast parity effect whereby slower parity calculation gives
> a larger time to coalesce writes.  I saw this effect when playing with
> xor offload.

I did find a case where inserting a printk made it go faster again.
Replacing that with msleep(2) worked as well. :-)

I'm looking for a most robust solution though.
Thanks for the reminder.

NeilBrown

--Sig_/4_+e5+VL34ObpP6rg+7KLCz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUDVWUTnsnt1WYoG5AQJCbg//cV3klQTHJr6ReUaxedXIeb6G2VfpFlpE
0C8epq3N0RQtz7Mm3hUjuvN2kleXUpegiQ2QoG9VTm0Mr/8LIDU3k8lHgd2AnKSh
t4QKjHjDbBNe3Vpl5ceFYEZJAscF6z/xFAsGxxuoqMarLRGCF/UFzbSpygk4DrnF
JdI3xyMwx5SgpTIkyj6Ef14EJevTC1I3glGCqYGpZn6Do4JurWtpr314VbSTaQhI
FnNNHENzp4D4YokqmSat4bxR83u+AiH5pgJYZ0T9yt2ABoyTKQDj8ztidcUXNvLj
YHSWHNATS5FazBPavcS8CnOZX0H3rd9Q6pUEFcJxSvOQwMzZOydakN8SAiTycwoU
RBMkPN0nZtKmZfgMMa5sAfYNtt7UMCvbflo6Szjy+Ee2iqh9M6gb0Occ6cDmVTx/
RomBZBZopn3jphgu/NPIWQsWDDp3Y7+8IiTeRVBQPEuNbogUJgONxwQ2LY13Kp7t
ZbmGbsSy2/ZF2PvIsTMdAH1UbK8qsAAGtsz3jZVDYjwDk0CmpEx3/bA9vKLjQqXa
D+l+vFlWUT6brvmf3xjQWBgUZOoyx4DmfRJjfkxXbb59WmmgU0+pQNYWjaN4Slyz
qxQydPVJxsl8Vsj8zMVpnL4I5D+9S5JvlwZ+KSY0vrM1dzcFG4RC+nIy6/Th7gj5
7ag5uNoaMu0=
=shyY
-----END PGP SIGNATURE-----

--Sig_/4_+e5+VL34ObpP6rg+7KLCz--
