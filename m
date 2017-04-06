From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking infrastructure and convert ext4 to use it
Date: Thu, 06 Apr 2017 15:12:42 +1000
Message-ID: <87inmi15md.fsf@notabene.neil.brown.name>
References: <20170403191602.GF30811@bombadil.infradead.org> <1491250577.2673.20.camel@redhat.com> <87h924kh6t.fsf@notabene.neil.brown.name> <20170404115358.GH30811@bombadil.infradead.org> <1491308268.20445.4.camel@redhat.com> <20170404161247.GJ30811@bombadil.infradead.org> <1491323146.309.1.camel@redhat.com> <20170404170909.GK30811@bombadil.infradead.org> <1491421792.18658.20.camel@redhat.com> <87efx6tnbr.fsf@notabene.neil.brown.name> <20170406025530.GB31725@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Cc: Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu, jack@suse.cz
To: Matthew Wilcox <willy@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170406025530.GB31725@bombadil.infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 05 2017, Matthew Wilcox wrote:

> On Thu, Apr 06, 2017 at 10:02:48AM +1000, NeilBrown wrote:
>> If you are concerned about space in 'struct address_space', just prune
>> some wastage.
>
> I'm trying to (via wlists).  still buggy though.

Cool.
(I wonder what a wlist is.... weighted list?)

>
>> The "host" field brings no value.  It is only ever assigned in
>> inode_init_always():
>>=20
>> 	struct address_space *const mapping =3D &inode->i_data;
>> ......
>> 	mapping->host =3D inode;
>>=20
>> So you could change all references to use
>>    container_of(mapping, struct inode, i_data)
>
> Alas, no:
>
> drivers/dax/dax.c:      inode->i_mapping->host =3D dax_dev->inode;

	inode->i_mapping =3D dax_dev->inode->i_mapping;
	inode->i_mapping->host =3D dax_dev->inode;
so that second line is equivalent to
        dax_dev->inode->i_mapping->host =3D dax_dev->inode;
so inode->mapping->host leads back to inode.  So this doesn't break the
invariant.
=20=20=20=20=20=20=20

> fs/gfs2/glock.c:                mapping->host =3D s->s_bdev->bd_inode;
> fs/gfs2/ops_fstype.c:   mapping->host =3D sb->s_bdev->bd_inode;

Hmm.. that's weird.  I cannot quite follow what is happening there.
It creates an address-space for metadata which doesn't have a real
inode, and borrows bits of the bdev inode ... possibly just to be able
to find the blocksize deep in buffer.c or similar.
I suspect that using an 'inode' instead of a 'mapping' would make the
code clearer.

> fs/nilfs2/page.c:       mapping->host =3D inode;

A nilfs inode is allocated with 2 address spaces,
one for the data and one for btree indexing metadata.
And then there are a couple of extra address spaces for the
global metadata-file (mtd).

I wonder what the ->host pointer is actually used for.
buffer.c uses it:
 - to mark the inode 'dirty' when the page is marked dirty
 - to find the blocksize of the inode, for creating buffer_heads
 - find the size of the mapping (i_size)

I could probably argue that the 'dirty' flag (at least for the data) and
the size really belong in the address_space, not in the inode.
The blocksize, I'm less sure of.

I suspect gfs2 and nilfs2 could be changed to allocate a separate inode
(instead of address_space), or to not make use of the ->host pointer.
It would be more work than I at first thought though.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljlzkoACgkQOeye3VZi
gbnvHQ/9E6wc2R3Y5cycKcyM+n+xXTBqe5preIO9UCCEkX1VqAGHEVnFbeukhiNP
w8fyKUf8elszu9yGByl2fHjuPRwhcd9jaX53DTbR2eCQpZw+5/wzi4+KShi+SiIy
kFpqbSr3wSE7B9euLKob8nMyuTPXojupXZXMYZb5vXJxDQ3MbKgx/gaPbLjQCA2j
jQcZfvZbpKvH8QY5JwUSPXI5Qne/HtcH5oVpPPFzwqYcUQMR+Stol1rD/e23mfA5
U4nF6vIhnrtXGRdFUSPhuQeAKPG4GtFyXMTJlehvR5pSjHrOqgLj1XX5aehq4xKT
An/psQVltGbyhLYnShIwIOUIN6RYMye+HpEZ2XIuJcW/zyVtghLcjjvHc+hhIbra
q9G3SRx3cb2CToX7wKTn9ErUpJwKISL72UMZbrxEgJ/94V8l2uwVKz4ivtGknkAJ
+2iobmrgFlN+36ER8TyE89QeeuL/IYOkKRh68ywi9LDdFJa27F0oWWMi2/QMtDVA
R5L2lUNOka1J/Nd7RQLLrOzA6zvJAW9Fnhsv7s7KNSl4YekwE2amQ5mYBQuI7ItB
vLEXw/h88STPHTLcnPqECHVx8w1cJ3HCNiY60g7LlpiVL0zxQbD5WftPbgBFcl2S
2pB78Oe8rOUTv3sDdKLMlR6Hz7SYktDfeSKS73J/RSBoBxRgaZI=
=YQR/
-----END PGP SIGNATURE-----
--=-=-=--
