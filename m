From: NeilBrown <neilb@suse.de>
Subject: Re: ext4 write performance regression in 3.6-rc1 on RAID0/5
Date: Sat, 18 Aug 2012 06:44:57 +1000
Message-ID: <20120818064457.7e94d266@notabene.brown>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
	<20120816024654.GB3781@thunk.org>
	<20120816111051.GA16036@localhost>
	<20120816152513.GA31346@thunk.org>
	<20120817060915.GB28786@localhost>
	<20120817134039.GB11439@thunk.org>
	<20120817142526.GA1059@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JF6F84O2BVSjr5cCV0mGbUN"; protocol="application/pgp-signature"
Cc: Theodore Ts'o <tytso@mit.edu>, Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com,
	"Shi, Alex" <alex.shi@intel.com>, linux-fsdevel@vger.kernel.org,
	linux RAID <linux-raid@vger.kernel.org>,
	Li Shaohua <shli@fusionio.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54574 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758896Ab2HQUpQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Aug 2012 16:45:16 -0400
In-Reply-To: <20120817142526.GA1059@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Sig_/JF6F84O2BVSjr5cCV0mGbUN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 17 Aug 2012 22:25:26 +0800 Fengguang Wu <fengguang.wu@intel.com>
wrote:

> [CC md list]
>=20
> On Fri, Aug 17, 2012 at 09:40:39AM -0400, Theodore Ts'o wrote:
> > On Fri, Aug 17, 2012 at 02:09:15PM +0800, Fengguang Wu wrote:
> > > Ted,
> > >=20
> > > I find ext4 write performance dropped by 3.3% on average in the
> > > 3.6-rc1 merge window. xfs and btrfs are fine.
> > >=20
> > > Two machines are tested. The performance regression happens in the
> > > lkp-nex04 machine, which is equipped with 12 SSD drives. lkp-st02 does
> > > not see regression, which is equipped with HDD drives. I'll continue
> > > to repeat the tests and report variations.
> >=20
> > Hmm... I've checked out the commits in "git log v3.5..v3.6-rc1 --
> > fs/ext4 fs/jbd2" and I don't see anything that I would expect would
> > cause that.  The are the lock elimination changes for Direct I/O
> > overwrites, but that shouldn't matter for your tests which are
> > measuring buffered writes, correct?
> >=20
> > Is there any chance you could do me a favor and do a git bisect
> > restricted to commits involving fs/ext4 and fs/jbd2?
>=20
> I noticed that the regressions all happen in the RAID0/RAID5 cases.
> So it may be some interactions between the RAID/ext4 code?

I'm aware of some performance regression in RAID5 which I will be drilling
down into next week.  Some things are faster, but some are slower :-(

RAID0 should be unchanged though - I don't think I've changed anything ther=
e.

Looking at your numbers, JBOD ranges from  +6.5% to -1.5%
                        RAID0 ranges from  +4.0% to -19.2%
                        RAID5 ranges from +20.7% to -39.7%

I'm guessing + is good and - is bad?
The RAID5 numbers don't surprise me.  The RAID0 do.

>=20
> I'll try to get some ext2/3 numbers, which should have less changes on th=
e fs side.

Thanks.  That will be useful.

NeilBrown


>=20
> wfg@bee /export/writeback% ./compare -g ext4 lkp-nex04/*/*-{3.5.0,3.6.0-r=
c1+}    =20
>                    3.5.0                3.6.0-rc1+
> ------------------------  ------------------------
>                   720.62        -1.5%       710.16  lkp-nex04/JBOD-12HDD-=
thresh=3D1000M/ext4-100dd-1-3.5.0
>                   706.04        -0.0%       705.86  lkp-nex04/JBOD-12HDD-=
thresh=3D1000M/ext4-10dd-1-3.5.0
>                   702.86        -0.2%       701.74  lkp-nex04/JBOD-12HDD-=
thresh=3D1000M/ext4-1dd-1-3.5.0
>                   702.41        -0.0%       702.06  lkp-nex04/JBOD-12HDD-=
thresh=3D1000M/ext4-1dd-2-3.5.0
>                   779.52        +6.5%       830.11  lkp-nex04/JBOD-12HDD-=
thresh=3D100M/ext4-100dd-1-3.5.0
>                   646.70        +4.9%       678.59  lkp-nex04/JBOD-12HDD-=
thresh=3D100M/ext4-10dd-1-3.5.0
>                   704.49        +2.6%       723.00  lkp-nex04/JBOD-12HDD-=
thresh=3D100M/ext4-1dd-1-3.5.0
>                   704.21        +1.2%       712.47  lkp-nex04/JBOD-12HDD-=
thresh=3D100M/ext4-1dd-2-3.5.0
>                   705.26        -1.2%       696.61  lkp-nex04/JBOD-12HDD-=
thresh=3D8G/ext4-100dd-1-3.5.0
>                   703.37        +0.1%       703.76  lkp-nex04/JBOD-12HDD-=
thresh=3D8G/ext4-10dd-1-3.5.0
>                   701.66        -0.1%       700.83  lkp-nex04/JBOD-12HDD-=
thresh=3D8G/ext4-1dd-1-3.5.0
>                   701.17        +0.0%       701.36  lkp-nex04/JBOD-12HDD-=
thresh=3D8G/ext4-1dd-2-3.5.0
>                   675.08       -10.5%       604.29  lkp-nex04/RAID0-12HDD=
-thresh=3D1000M/ext4-100dd-1-3.5.0
>                   676.52        -2.7%       658.38  lkp-nex04/RAID0-12HDD=
-thresh=3D1000M/ext4-10dd-1-3.5.0
>                   512.70        +4.0%       533.22  lkp-nex04/RAID0-12HDD=
-thresh=3D1000M/ext4-1dd-1-3.5.0
>                   524.61        -0.3%       522.90  lkp-nex04/RAID0-12HDD=
-thresh=3D1000M/ext4-1dd-2-3.5.0
>                   709.76       -15.7%       598.44  lkp-nex04/RAID0-12HDD=
-thresh=3D100M/ext4-100dd-1-3.5.0
>                   681.39        -2.1%       667.25  lkp-nex04/RAID0-12HDD=
-thresh=3D100M/ext4-10dd-1-3.5.0
>                   524.16        +0.8%       528.25  lkp-nex04/RAID0-12HDD=
-thresh=3D100M/ext4-1dd-2-3.5.0
>                   699.77       -19.2%       565.54  lkp-nex04/RAID0-12HDD=
-thresh=3D8G/ext4-100dd-1-3.5.0
>                   675.79        -1.9%       663.17  lkp-nex04/RAID0-12HDD=
-thresh=3D8G/ext4-10dd-1-3.5.0
>                   484.84        -7.4%       448.83  lkp-nex04/RAID0-12HDD=
-thresh=3D8G/ext4-1dd-1-3.5.0
>                   470.40        -3.2%       455.31  lkp-nex04/RAID0-12HDD=
-thresh=3D8G/ext4-1dd-2-3.5.0
>                   167.97       -38.7%       103.03  lkp-nex04/RAID5-12HDD=
-thresh=3D1000M/ext4-100dd-1-3.5.0
>                   243.67        -9.1%       221.41  lkp-nex04/RAID5-12HDD=
-thresh=3D1000M/ext4-10dd-1-3.5.0
>                   248.98       +12.2%       279.33  lkp-nex04/RAID5-12HDD=
-thresh=3D1000M/ext4-1dd-1-3.5.0
>                   208.45       +14.1%       237.86  lkp-nex04/RAID5-12HDD=
-thresh=3D1000M/ext4-1dd-2-3.5.0
>                    71.18       -34.2%        46.82  lkp-nex04/RAID5-12HDD=
-thresh=3D100M/ext4-100dd-1-3.5.0
>                   145.84        -7.3%       135.25  lkp-nex04/RAID5-12HDD=
-thresh=3D100M/ext4-10dd-1-3.5.0
>                   255.22        +6.7%       272.35  lkp-nex04/RAID5-12HDD=
-thresh=3D100M/ext4-1dd-1-3.5.0
>                   243.09       +20.7%       293.30  lkp-nex04/RAID5-12HDD=
-thresh=3D100M/ext4-1dd-2-3.5.0
>                   209.24       -23.6%       159.96  lkp-nex04/RAID5-12HDD=
-thresh=3D8G/ext4-100dd-1-3.5.0
>                   243.73       -10.9%       217.28  lkp-nex04/RAID5-12HDD=
-thresh=3D8G/ext4-10dd-1-3.5.0
>                   214.25        +5.6%       226.32  lkp-nex04/RAID5-12HDD=
-thresh=3D8G/ext4-1dd-1-3.5.0
>                   207.16       +13.4%       234.98  lkp-nex04/RAID5-12HDD=
-thresh=3D8G/ext4-1dd-2-3.5.0
>                 17572.12        -1.9%     17240.05  TOTAL write_bw
>=20
> Thanks,
> Fengguang


--Sig_/JF6F84O2BVSjr5cCV0mGbUN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUC6tSTnsnt1WYoG5AQI6gA/+Os4LBdN77tmEAc2rdiiqPK0ZmnbsI09B
+vgiqg/HJyhxptZnKU3GzyQ6gUCCegA45inZP1IddYH4SiRgNxlzctNQ6Je2vmkd
Wg6FQ/ZQoWxBhpJvldBAWt5aO6Rj1TnYZ8X/i4HoSGaA/pxrvF3KBNmWCpi12mE5
gVT5Mefw61NSpbm1gzC8I7jBbCwytQnVLCFGSVissJOaLDA8kwaaNU2XchzYGmfm
Wh5iEKBzTsjCAOK7wbkIWsd8RLubWlAl4EDAwKUdckIDFqRMeaAS+ykk19+h3VKG
TYrC+9ThbPgQmRl9ObIhKcScPCSpr5mAkE/oedvLA7FtO3IfQld/TBDTOnGrcC7a
vdPue/AVtwEtyrTc2glC1kcYU8GRXK6s93dgF65c2ymX4GIbPJ4/BPgOn4+iC6aX
6dolP53LUDmHLzhN4lmWdo9WxfRfiRMKUR/fC8WXr7er4yH8zTXXgwpgyjMg2Ldk
d6T4iELQW09XuX/MUhTh8w6MbIgRCV7tXTYC0IfXAEN595S6ei689W/WwgHD5EDO
J96YzggNjgMRIGPe30TGhGpxun5JRRNGUNI7IZqLigEXV0xr8Ch+wVTz0MvSyVGE
ldNs1I0nu4RDO09UclT2uoZFBKzSanvLv/Wm2fvNc+26Y2pnDtyLZ7xgSJnywlIS
x9qYVWhfHBM=
=1tkN
-----END PGP SIGNATURE-----

--Sig_/JF6F84O2BVSjr5cCV0mGbUN--
