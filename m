From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCHv6 11/37] HACK: readahead: alloc huge pages, if allowed
Date: Thu, 9 Feb 2017 17:23:31 -0700
Message-ID: <7D35EB8E-29F8-41DA-BB46-8BCF7B6C5A72@dilger.ca>
References: <20170126115819.58875-1-kirill.shutemov@linux.intel.com>
 <20170126115819.58875-12-kirill.shutemov@linux.intel.com>
 <20170209233436.GZ2267@bombadil.infradead.org>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_8EE802F7-5284-4DAC-9401-3B192B06662C";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Theodore Ts'o <tytso@mit.edu>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Jan Kara <jack@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Hugh Dickins <hughd@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Dave Hansen <dave.hansen@intel.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Ross Zwisler <ross.zwisler@linux.intel.com>,
 linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 linux-block@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170209233436.GZ2267@bombadil.infradead.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_8EE802F7-5284-4DAC-9401-3B192B06662C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Feb 9, 2017, at 4:34 PM, Matthew Wilcox <willy@infradead.org> wrote:
>=20
> On Thu, Jan 26, 2017 at 02:57:53PM +0300, Kirill A. Shutemov wrote:
>> Most page cache allocation happens via readahead (sync or async), so =
if
>> we want to have significant number of huge pages in page cache we =
need
>> to find a ways to allocate them from readahead.
>>=20
>> Unfortunately, huge pages doesn't fit into current readahead design:
>> 128 max readahead window, assumption on page size, PageReadahead() to
>> track hit/miss.
>>=20
>> I haven't found a ways to get it right yet.
>>=20
>> This patch just allocates huge page if allowed, but doesn't really
>> provide any readahead if huge page is allocated. We read out 2M a =
time
>> and I would expect spikes in latancy without readahead.
>>=20
>> Therefore HACK.
>>=20
>> Having that said, I don't think it should prevent huge page support =
to
>> be applied. Future will show if lacking readahead is a big deal with
>> huge pages in page cache.
>>=20
>> Any suggestions are welcome.
>=20
> Well ... what if we made readahead 2 hugepages in size for inodes =
which
> are using huge pages?  That's only 8x our current readahead window, =
and
> if you're asking for hugepages, you're accepting that IOs are going to
> be larger, and you probably have the kind of storage system which can
> handle doing larger IOs.

It would be nice if the bdi had a parameter for the maximum readahead =
size.
Currently, readahead is capped at 2MB chunks by =
force_page_cache_readahead()
even if bdi->ra_pages and bdi->io_pages are much larger.

It should be up to the filesystem to decide how large the readahead =
chunks
are rather than imposing some policy in the MM code.  For high-speed =
(network)
storage access it is better to have at least 4MB read chunks, for RAID =
storage
it is desirable to have stripe-aligned readahead to avoid read inflation =
when
verifying the parity.  Any fixed size will eventually be inadequate as =
disks
and filesystems change, so it may as well be a per-bdi tunable that can =
be set
by the filesystem as needed, or possibly with a mount option if needed.


Cheers, Andreas






--Apple-Mail=_8EE802F7-5284-4DAC-9401-3B192B06662C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYnQgEpIg59Q01vtYRAtFGAKDvCrR8jSY6QOy14QScouQScGbDSgCeLM1U
CiznnCvh2NZhwkFRHNE+RvI=
=rebT
-----END PGP SIGNATURE-----

--Apple-Mail=_8EE802F7-5284-4DAC-9401-3B192B06662C--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
