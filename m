From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ext4 write performance regression in 3.6-rc1 on RAID0/5
Date: Wed, 22 Aug 2012 01:14:42 -0600
Message-ID: <1B78C9B4-CC2B-43B3-8513-2221925D25A0@dilger.ca>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com> <20120816024654.GB3781@thunk.org> <20120816111051.GA16036@localhost> <20120816152513.GA31346@thunk.org> <20120817060915.GB28786@localhost> <20120817134039.GB11439@thunk.org> <20120817142526.GA1059@localhost> <20120822035702.GF2570@yliu-dev.sh.intel.com> <20120822160025.272188d1@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-22-92778657"
Content-Transfer-Encoding: 7bit
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Li Shaohua <shli@fusionio.com>, Theodore Ts'o <tytso@mit.edu>,
	Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com,
	"Shi, Alex" <alex.shi@intel.com>, linux-fsdevel@vger.kernel.org,
	linux RAID <linux-raid@vger.kernel.org>
To: NeilBrown <neilb@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120822160025.272188d1@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-22-92778657
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=us-ascii

On 2012-08-22, at 12:00 AM, NeilBrown wrote:
> On Wed, 22 Aug 2012 11:57:02 +0800 Yuanhan Liu =
<yuanhan.liu@linux.intel.com>
> wrote:
>>=20
>> -#define NR_STRIPES		256
>> +#define NR_STRIPES		1024
>=20
> Changing one magic number into another magic number might help your =
case, but
> it not really a general solution.

We've actually been carrying a patch for a few years in Lustre to
increase the NR_STRIPES to 2048, and made it a configurable module
parameter.  This made a noticeable improvement to the performance
for fast systems.

> Possibly making sure that max_nr_stripes is at least some multiple of =
the
> chunk size might make sense, but I wouldn't want to see a very large =
multiple.
>=20
> I thing the problems with RAID5 are deeper than that.  Hopefully I'll =
figure
> out exactly what the best fix is soon - I'm trying to look into it.

The other MD RAID-5/6 patches that we have change the page submission
order to avoid the need to merge pages in the elevator so much, and a
patch to allow zero-copy IO submission if the caller marks the page for
direct IO (indicating it will not be modified until after IO completes).
This avoids a lot of overhead on fast systems.

This isn't really my area of expertise, but patches against RHEL6
could be seen at http://review.whamcloud.com/1142 if you want to
take a look.  I don't know if that code is at all relevant to what
is in 3.x today.

> I don't think the size of the cache is a big part of the solution.  I =
think
> correct scheduling of IO is the real answer.

My experience is that on fast systems the IO scheduler just gets in the
way.  Submitting larger contiguous IOs to each disk in the first place
is far better than trying to merge small IOs again at the back end.

Cheers, Andreas






--Apple-Mail-22-92778657
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org

iD8DBQFQNIbipIg59Q01vtYRAkAcAKCGtJsylLo4ETG37VAdEClYoaIN3gCfbuCf
Hnhc3up3Pzt4rcJP0PRnNJQ=
=Q66g
-----END PGP SIGNATURE-----

--Apple-Mail-22-92778657--
