From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Mon, 5 Mar 2007 12:49:45 +0100
Message-ID: <20070305114945.GB454@lazybastard.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <1172789056.11165.42.camel@kleikamp.austin.ibm.com> <20070301233819.GB31072@infradead.org> <200703032345.33137.arnd@arndb.de> <0DA8B217-DDD4-4E05-B000-DEBE3BE55B94@cam.ac.uk> <45EB4A55.3060908@redhat.com> <20070305001621.GB18691@lazybastard.org> <CDA7A0DF-D744-416F-83B1-76C148B46A5F@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ulrich Drepper <drepper@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com
To: Anton Altaparmakov <aia21@cam.ac.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CDA7A0DF-D744-416F-83B1-76C148B46A5F@cam.ac.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 5 March 2007 00:32:14 +0000, Anton Altaparmakov wrote:
>=20
> I don't know how your compression algorithm works [...]

LogFS is designed for flash media, so it does not have to worry much
about reducing disk seeks.  It is log-structured, which simplifies
compression further.

When writing a block, it basically compresses it and appends it to the
log.  Writes only have to be byte-aligned, so no space is lost for
padding.

The bad news for posix_fallocate() is that even if libc is smart enough
to write random data, mmap() can still cause problems.  If the VM
decides to write a given page twice, the second write compresses better
and the medium has filled up between the two writes, the users will hav=
e
fun.

J=C3=B6rn

--=20
Joern's library part 9:
http://www.scl.ameslab.gov/Publications/Gus/TwelveWays.html
-
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
