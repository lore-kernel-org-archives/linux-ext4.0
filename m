From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking infrastructure and convert ext4 to use it
Date: Thu, 06 Apr 2017 10:19:55 +1000
Message-ID: <87pogqgzf8.fsf@notabene.neil.brown.name>
References: <1491241657.2673.10.camel@redhat.com> <20170403191602.GF30811@bombadil.infradead.org> <1491250577.2673.20.camel@redhat.com> <87h924kh6t.fsf@notabene.neil.brown.name> <20170404115358.GH30811@bombadil.infradead.org> <1491308268.20445.4.camel@redhat.com> <20170404161247.GJ30811@bombadil.infradead.org> <1491323146.309.1.camel@redhat.com> <20170404170909.GK30811@bombadil.infradead.org> <1491421792.18658.20.camel@redhat.com> <20170405210358.GA31725@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        tytso@mit.edu, jack@suse.cz
To: Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170405210358.GA31725@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 05 2017, Matthew Wilcox wrote:

> On Wed, Apr 05, 2017 at 03:49:52PM -0400, Jeff Layton wrote:
>> > That only gives us 20 bits of counter, but I think that's enough.
>>=20
>> 2^20 is 1048576, which seems a little small to me.
>>=20
>> We may end up bumping the counter on every failed I/O. How fast can we
>> generate 1M failed I/Os? :)
>
> So there's a one-in-a-million chance of missing a failed I/O ... if
> we're generating lots of errors, the next time the app calls fsync(),
> it'll notice the other million times we've hit the problem :-)
>
>> Actually...we could put this field in the inode instead of the mapping.
>> I know we've traditionally tracked this in the mapping, but is that
>> required here?
>>=20
>> If we put this field in the inode then perhaps we can union it with
>> something and mitigate the cost of a larger counter...maybe in the
>> i_pipe union? I don't think S_ISREG inodes use anything in there, do
>> they?
>
> But writeback isn't just done on ISREG inodes, but also on S_ISBLK inodes,
> which use i_bdev (right?)
>
> Another possibility is to move this out of the address_space and into
> either the super_block or the backing_device_info.  Errors don't tend
> to be constrained to a single file but affect the entire filesystem,
> or even multiple filesystems if you have a partitioned block device ...

EDQUOT.  Remember EDQUOT.  It certainly don't affect the whole
filesystem.
Even without that, filesystems can easily treat different files
differently.  We shouldn't assume one-failes-all-fail.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljliasACgkQOeye3VZi
gbn/mg//Z7mVaZQr1dLZ/fmDqhVId3s8WfkqvhHftho0lfL+r3+46pF1iSNOGWSH
todxSDlkSHTyRBhsZ+aDiJQYNFCw1Rw+vaHc1hrYbczpgtQh8sBiqZXg7ICi9e0t
oYS/fTAeWUoCs+P66e3GAYIZsLDKgk8Go8Y1VfDYzBlnoA90lP7K6UoLAVPcMuE/
W8GoFHDESvPTw5+ICkNb5mA1JssiQL+25NecTIbr3nlKAzWqtztatj6czedjPMcS
tDae1MUo+PGVGoW5LUYWG4692rrGnZU1rr02daxO21vHHDHW015g69lQWofXYAcz
7MToIr4ArnVipNq/xWIk1RpKNNtn1yb37Ek4zkQ/qVIIKuQm+UDyr2Hp/Q57dFp4
uSkJonWFcIXhEJz5zvRf9Z+K8yNFi50YQX8vrRRIfBvaes/7OV0RRzPZdsDxf7KN
GjmJocpWvxKJKlWrgrA4rLHSYqyr1+O5fDdPWw3Bm8juZQW0X8yGKzZFjJEwmsjS
2jgZoJXxD9vibnHFPWzZHOM2WOzMOivXWamrjiiJxsY0SHggV0bES7JHEUIZgq7R
fmccFkDjMr+bTr6xbbHYpY2vVKxHIkIjMOYVpDm/OqYMYpaYroYEFel8d3/QQYrW
p1EvVzILxCakZ5Nkmq6hO5KHaF54Rm7bZrnJ+RZsVz12T4yEkA8=
=80ni
-----END PGP SIGNATURE-----
--=-=-=--
