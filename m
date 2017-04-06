From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking infrastructure and convert ext4 to use it
Date: Thu, 06 Apr 2017 10:24:22 +1000
Message-ID: <87mvbugz7t.fsf@notabene.neil.brown.name>
References: <20170331192603.16442-1-jlayton@redhat.com> <87fuhqkti0.fsf@notabene.neil.brown.name> <1491215318.2724.3.camel@redhat.com> <20170403143257.GA30811@bombadil.infradead.org> <1491241657.2673.10.camel@redhat.com> <20170403191602.GF30811@bombadil.infradead.org> <1491250577.2673.20.camel@redhat.com> <87h924kh6t.fsf@notabene.neil.brown.name> <20170404115358.GH30811@bombadil.infradead.org> <1491308268.20445.4.camel@redhat.com> <20170404161247.GJ30811@bombadil.infradead.org> <1491323146.309.1.camel@redhat.com> <87h923ix6g.fsf@notabene.neil.brown.name> <1491390849.2991.2.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        tytso@mit.edu, jack@suse.cz
To: Jeff Layton <jlayton@redhat.com>,
        Matthew Wilcox <willy@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1491390849.2991.2.camel@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 05 2017, Jeff Layton wrote:

>>=20
>> O_DIRECT write() can get an EIO from a previous write-back write to the
>> same file.  Maybe non-O_DIRECT writes should too?
>>=20
>
> Some already do this for buffered writes.
>
> This is really a philosophical question, IMO...is it correct to return
> an error on a write call, due to writeback failing previously or during
> the write call, quite possibly to a range that the write call does not
> touch? I can see an argument either way for this.

I like the "we already do" argument.

>
> Also, if we do think that returning an error on the write is the right
> thing to do, should that error advance the sequence counter in the
> struct file, such that an fsync afterward gets back 0? My feeling here
> is that fsync should still report an error after a failed write, but
> maybe that's wrong?

My first thought was that one the error has been returned to any
syscall on a given fd, it has been returned.  Once is enough.
My second thought was that maybe your feeling is right.  Having a well
defined error-return point in fsync feels like a nice design.
My third thought was that this would mean either
 - write continues to fail until fsync is called (probably bad), or
 - we need two counters per "struct file", one for fsync, one for write.
   I don't like that much.

So I'm going back to my first thought.

Thanks,
NeilBrown


>
> This is certainly one area where switching to synchronous writes on
> error would make things a little simpler.
> --=20
> Jeff Layton <jlayton@redhat.com>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljlirYACgkQOeye3VZi
gbmJsw/9HWWv82YW5eahdy237bA3O1h24Gx8Ph1d9x8fe8DoAKWlJjniqCEiU+2i
YZ+5b03qYtXS3YpJuSVNrsd5OXyxweqH59eXiTewvMCrXoTaHjw67DcXAKEJ4jAt
P04ixcvIMMUqZBSEy9rtUj5aLlSPnFtz6A8FECyG9jm8AKWGNWxV7zoeryp6ueLu
+FXyAzYE4EOui5DptNtM6fU4PqaHNQB4tpcTmfFgAt87Z+cY5IGvs4CBIo5pRgJx
tEP5dv31lyOF9rMrJrW9Sz/TMkqnS7xMh4/rRRK9b/VWAX4RzVnp0yoa/cC3Npr+
HiPZV1tngLJDaF/nk7myBfy5BRgoWEb1xSd8+JuZ8FD/Ftdw5OT4R8q9/D8683/d
OGRJzMiWIqELB88L14E7B9fgNV7nmT3yfgc9la03lbDG4yhJYBKH5DXnHUvfOOQq
zFBHyV7qIx3MxxdaxTw2ZcLh6CKHcGvctdldjIHnCNrNyUOAN4DJwtcOKuOekCPN
DLjcQtydioVUhP0NpNbEcZb1RDs3Ok2lheL9+wk5OnLWkFb8ECZYuQE0ahIQRpZx
YqErL6MmVussfZGuoZqJTQLti2xS/1QgI7EsbWmS36410KRJ4NqjfF3Jb8A4Z5dt
2EZmPCSqn+Hobqqj03YXE9p/FisUPsZ6zKFTlmWb50enuda8z0E=
=3H15
-----END PGP SIGNATURE-----
--=-=-=--
