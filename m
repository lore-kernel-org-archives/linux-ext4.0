From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Sun, 4 Mar 2007 21:53:32 +0100
Message-ID: <200703042153.35425.arnd@arndb.de>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <200703032345.33137.arnd@arndb.de> <0DA8B217-DDD4-4E05-B000-DEBE3BE55B94@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com,
	Ulrich Drepper <drepper@redhat.com>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <0DA8B217-DDD4-4E05-B000-DEBE3BE55B94@cam.ac.uk>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sunday 04 March 2007, Anton Altaparmakov wrote:
> > A generic_fallocate makes sense to me iff we can do it in the kerne=
l
> > more significantly more efficiently than in glibc, e.g. by using on=
ly
> > a single page in page cache instead of one for each page to be =A0
> > preallocated.
> >
> > If =A0glibc is smart enough to do an optimal implementation, I full=
y =A0
> > agree
> > with you.
>=20
> glibc cannot ever be smart enough because a file system driver will =A0
> always know better and be able to do things in a much more optimized =
=A0
> way.

Ok, that's not what I meant. It's obvious that the file system itself
can do better than both VFS and glibc. The question is whether VFS can
be better than glibc on file systems that don't offer their own
implementation of the fallocate operation.

	Arnd <><
-
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
