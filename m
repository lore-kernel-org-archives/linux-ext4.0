From: NeilBrown <neilb@suse.de>
Subject: Re: ext4 write performance regression in 3.6-rc1 on RAID0/5
Date: Wed, 22 Aug 2012 16:00:25 +1000
Message-ID: <20120822160025.272188d1@notabene.brown>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
	<20120816024654.GB3781@thunk.org>
	<20120816111051.GA16036@localhost>
	<20120816152513.GA31346@thunk.org>
	<20120817060915.GB28786@localhost>
	<20120817134039.GB11439@thunk.org>
	<20120817142526.GA1059@localhost>
	<20120822035702.GF2570@yliu-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/doLWNd9A289=bYVeFpiGDTq"; protocol="application/pgp-signature"
Cc: Fengguang Wu <fengguang.wu@intel.com>,
	Li Shaohua <shli@fusionio.com>, Theodore Ts'o <tytso@mit.edu>,
	Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com,
	"Shi, Alex" <alex.shi@intel.com>, linux-fsdevel@vger.kernel.org,
	linux RAID <linux-raid@vger.kernel.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120822035702.GF2570@yliu-dev.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--Sig_/doLWNd9A289=bYVeFpiGDTq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 22 Aug 2012 11:57:02 +0800 Yuanhan Liu <yuanhan.liu@linux.intel.com>
wrote:

> =20
> -#define NR_STRIPES		256
> +#define NR_STRIPES		1024

Changing one magic number into another magic number might help your case, b=
ut
it not really a general solution.

Possibly making sure that max_nr_stripes is at least some multiple of the
chunk size might make sense, but I wouldn't want to see a very large multip=
le.

I thing the problems with RAID5 are deeper than that.  Hopefully I'll figure
out exactly what the best fix is soon - I'm trying to look into it.

I don't think the size of the cache is a big part of the solution.  I think
correct scheduling of IO is the real answer.

Thanks,
NeilBrown



--Sig_/doLWNd9A289=bYVeFpiGDTq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUDR1gznsnt1WYoG5AQIvMBAAnwqYNlar29oqFwn2sT2XzxABU10uA6SW
px7PJihjVfckygzmPTIibCXb7CdDnKUflXvdTi6YP+ZUEjAmbKVg4OQwkkpZcFoz
Xevjdk+SyvSAYZFpiZFqgTpWV8XySW1HO8hfC8aagB3mEKYwd7pLaT0SF5Arer9P
e91hUF3SR4Kvytoig45Ucf6KiXHBghbJ6oU2ARGFKWLv4yrOdR/WKs8z9nvGmDHL
HMvXY2FONYtxevJ1nWPUp1/gk0cbkpfd/qrZhGopKok/ezQ6CDm4/WpQZZ04dYF9
cQ0ML57fJT8gR9deSIHKyiu89xVgItFoa5YQpa7gZMyk/9Cr1bierN4OCe8YDV2E
9gydeFhw1kbWDUEotPhr5Tk2qazjZg1Kt26Ea0zxBetJNX1jwTPaRnsPFyUMsGCj
WUYQ3pBLLUrcec3kJcVz77+HN78AtvoxDE/ZKC35OrlAU0Lh5T3qJ8dThx31jM8C
wAqABoqPDeqBUKCe+OA7SRxugvXrpolZ5JH+mGywl3Cp1PHQ7J4G0tHCImHLme+r
9gMrj6uCVacof/W+g+of0n2fKYC1AekxrRcyRXmzZi4AEla06kCy+DOv0ipb99if
FaJORbwfZjcd3dOKp+jZg+6UFKWiZ+Clhs5muS2ejkVlagcI/ByP6W53R6EsA8Ds
Bei+hDYJNEw=
=6+qx
-----END PGP SIGNATURE-----

--Sig_/doLWNd9A289=bYVeFpiGDTq--
