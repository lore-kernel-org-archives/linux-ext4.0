From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking infrastructure and convert ext4 to use it
Date: Fri, 07 Apr 2017 07:53:08 +1000
Message-ID: <871st519vf.fsf@notabene.neil.brown.name>
References: <87h924kh6t.fsf@notabene.neil.brown.name> <20170404115358.GH30811@bombadil.infradead.org> <1491308268.20445.4.camel@redhat.com> <20170404161247.GJ30811@bombadil.infradead.org> <1491323146.309.1.camel@redhat.com> <20170404170909.GK30811@bombadil.infradead.org> <1491421792.18658.20.camel@redhat.com> <87efx6tnbr.fsf@notabene.neil.brown.name> <20170406025530.GB31725@bombadil.infradead.org> <87inmi15md.fsf@notabene.neil.brown.name> <20170406133103.GC31725@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Cc: Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu, jack@suse.cz
To: Matthew Wilcox <willy@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170406133103.GC31725@bombadil.infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 06 2017, Matthew Wilcox wrote:

> On Thu, Apr 06, 2017 at 03:12:42PM +1000, NeilBrown wrote:
>> On Wed, Apr 05 2017, Matthew Wilcox wrote:
>>=20
>> > On Thu, Apr 06, 2017 at 10:02:48AM +1000, NeilBrown wrote:
>> >> If you are concerned about space in 'struct address_space', just prune
>> >> some wastage.
>> >
>> > I'm trying to (via wlists).  still buggy though.
>>=20
>> Cool.
>> (I wonder what a wlist is.... weighted list?)
>
> A homonym ;-)  Waitlists.  Yet Another Variation of a doubly linked list.
> This variation has only a single head pointer (like the hlist), allows
> O(1) deletion from any point in the list (but requires that you know the
> head of the list).  The tail of the list is pointed to by head->prev.
>
> http://git.infradead.org/users/willy/linux-dax.git/shortlog/refs/heads/wl=
ist
>
> It also needs updating to the latest tree; WW locks got revamped.

So nothing points to the head, meaning you need both the node and the
head to delete something.  But the head is smaller.
I can see how that would be useful.
Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljmuMQACgkQOeye3VZi
gblV7BAAul4baewhqW/fO4B97GxfmwiPV7q5ATIUihE8INW8bRYv02zkKqoF7Zp4
3cIQHxf2Lo01nVRYKjh2CO4dOSyiPsBFW84kwrUmRxBZ5jh5T8ESpbnQ4AHGI8pJ
xEcH9GfyWvHCMSPKPMzM7ZEKHxiWKvRsSKUG7KACQA4Tys+1f5ywV/YAaFl2HA3I
ePTL/FtMh/9Mk0WSpdxurBXukA/LwGRMIIr/KC5U4ti1W+MvzwzvkdTLWGzEEHL0
SPDt2bxYrrdq3IqobC4n3g7hwrBpMQ3S6bJW9KlCcRQ4y2Rb/0m7X/zPTJzXDoog
88gnxso0SHeDecXhvlBzQUe9etkiw5LCaBVRFNZ+4mYU5lI2MIjDECKGxYwoznXy
CC5j3/O0RdpFkKcwGN0DUYabYxeE17KeAFi23ytO/+oLXMrihatsfczuEbvWLxSg
Dm1KHLsvHRcjBTEt3ZzqYCNKoenfPbEMhoxkwprrulZNLPvqT+OCXD1ezTw/X4Oz
c+1Y4RLb9e3sudLZhspEFLOiW+PJAviWnUXrf2BhL38lK4mbxjKv/VAptBKx7aqf
2bF8iL2wJ0aUvF3k/f+UiHkMLbH9PYf2FYd5Sdh+Kn/PWf8RV3Y79BNKM/A/q9+E
uugE4/mW/T7lOSBxe7j6ieg8MjUzdGFfeG6c9q75BOen3+HL84I=
=psXi
-----END PGP SIGNATURE-----
--=-=-=--
