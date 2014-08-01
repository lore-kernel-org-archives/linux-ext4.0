From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/2] new API to allocate buffer-cache for superblock in
 non-movable area
Date: Fri, 1 Aug 2014 15:36:18 +0200
Message-ID: <20140801133618.GJ19379@twins.programming.kicks-ass.net>
References: <20140722093838.GA22331@quack.suse.cz>
 <53D8A258.7010904@lge.com>
 <20140730101143.GB19205@quack.suse.cz>
 <53D985C0.3070300@lge.com>
 <20140731000355.GB25362@quack.suse.cz>
 <53D98FBB.6060700@lge.com>
 <20140731122114.GA5240@quack.suse.cz>
 <53DADA2F.1020404@lge.com>
 <53DAE820.7050508@lge.com>
 <20140801095700.GB27281@quack.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SzFONp+077xxuUwz"
Cc: Gioh Kim <gioh.kim@lge.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>,
	Joonsoo Kim <js1304@gmail.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140801095700.GB27281@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--SzFONp+077xxuUwz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 01, 2014 at 11:57:00AM +0200, Jan Kara wrote:
> So the quiestion really is how hard guarantee do you need that a page in
> movable zone is really movable. Or better in what timeframe should it be
> movable? It may be possible to make e.g. migratepage callback for ext4
> blkdev pages which will handle migration of pages that are just idly
> sitting in a journal waiting to be committed. That may be reasonably doable
> although it won't be perfect. Or we may just decide it's not worth the
> bother and allocate all blkdev pages from unmovable zone...

So the point of CMA is to cater to those (arguably broken) devices that
do not have scatter gather IO, and these include things like the camera
device on your phone.

Previously (and possibly currently) your android Linux kernel will
simply preallocate a massive physically linear chunk of memory and
assign it to the camera hardware and not use it at all.

This is a terrible waste for most of the time people aren't running
their camera app at all. So the point is to allow usage of the memory,
but upon request be able to 'immediately' clear it through
migration/writeback.

So we should be fairly 'quick' in making the memory available,
definitely sub second timeframes.


Sadly its not only mobile devices that excel in crappy hardware, there's
plenty desktop stuff that could use this too, like some of the v4l
devices iirc.

--SzFONp+077xxuUwz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT25fSAAoJEHZH4aRLwOS6+1EP/iMZzyhlVxyDx/F8DuyuTS08
fpyAN5FSmfs/0/StWuZFH3KYiBLCgHd0jmDQVg4/uaPZQUOxRi+l4Rgd1XCyYK6Y
bBkFHcY/GPfk5lkbieyg1EOP4wVWU6I7MkE1v/qCCcmQoX/lHIw7op5g3Xs8LhZp
BOmFWRBQpBW64ErXwrRgnAJFPP6bGmmXrKLJ8i1EcQketsMep5rij/xJc/NRYmxK
sOmuR1G7h+afVVQ21c0azDCqR8+NUJJENErl2IcQCDSxl5snK9jwGDapXXw6xWDf
kyFUD+TV+orUkjxtm6nsSl5C1/JMbiCRRxf7JdLFgCYS1ibZtr5Pks2Fx5MRbHx3
kWZAHgDjy87cxYwKcuglpp5XfNm4lQdSWict2o9AQIQgqPDj+oopjbaz9yPAMaT+
uLQ6/4yZWhuJF/Bkzg4JHecyZIbK2BvxaiZr6tgpDsLl8LJ++FADscWeNpLkTUZY
yKM/925zBeKz+34bdwKNe0a4dCvvMGg/XezJnC0vfS7qR5+M9nYi5eie23Nb008V
1wJn3C7I+8r3RH+0cASFeYNwT0Tg7ZgEPVPuO1MPf6XMNg3/QpKMPLFWBOB87w9W
oDM8GOilyi6jo/ayW6opGO4Hecwc4Vs4+ihsYkpFKgUV2X6S0Dv3ohR4sGHe7cmS
+OSRGzlCtC3dFuwwBVtc
=zq7I
-----END PGP SIGNATURE-----

--SzFONp+077xxuUwz--
