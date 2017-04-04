From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking infrastructure and convert ext4 to use it
Date: Wed, 05 Apr 2017 09:13:11 +1000
Message-ID: <87h923ix6g.fsf@notabene.neil.brown.name>
References: <20170331192603.16442-1-jlayton@redhat.com> <87fuhqkti0.fsf@notabene.neil.brown.name> <1491215318.2724.3.camel@redhat.com> <20170403143257.GA30811@bombadil.infradead.org> <1491241657.2673.10.camel@redhat.com> <20170403191602.GF30811@bombadil.infradead.org> <1491250577.2673.20.camel@redhat.com> <87h924kh6t.fsf@notabene.neil.brown.name> <20170404115358.GH30811@bombadil.infradead.org> <1491308268.20445.4.camel@redhat.com> <20170404161247.GJ30811@bombadil.infradead.org> <1491323146.309.1.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        tytso@mit.edu, jack@suse.cz
To: Jeff Layton <jlayton@redhat.com>,
        Matthew Wilcox <willy@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1491323146.309.1.camel@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 04 2017, Jeff Layton wrote:

> On Tue, 2017-04-04 at 09:12 -0700, Matthew Wilcox wrote:
>> On Tue, Apr 04, 2017 at 08:17:48AM -0400, Jeff Layton wrote:
>> > Agreed that we should focus on POSIX compliance. I'll also note that
>> > POSIX states:
>> >=20
>> > "If more than one error occurs in processing a function call, any one
>> > of the possible errors may be returned, as the order of
>> > detection is undefined."
>> >=20
>> >     http://pubs.opengroup.org/onlinepubs/9699919799/functions/V2_chap0=
2.html#tag_15_03
>> >=20
>> > So, I'd like to push back on this idea that we need to prefer reporting
>> > -EIO over other errors. POSIX certainly doesn't mandate that.=20
>>=20
>> I honestly wonder if we need to support ENOSPC from writeback at all.
>> Looking at our history, the AS_EIO / AS_ENOSPC came from this patch
>> in 2003:
>>=20
>> https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/commit/=
?id=3Dfcad2b42fc2e15a94ba1a1ba8535681a735bfd16
>>=20
>> That seems to come from here:
>> http://lkml.iu.edu/hypermail/linux/kernel/0308.0/0205.html
>> which is marked as a resend, but I can't find the original.
>>=20
>> It's a little misleading because the immediately preceding patch
>> introduced mapping->error, so there's no precedent here to speak of.
>> It looks like we used to just silently lose writeback errors (*cough*).
>>=20
>> I'd like to suggest that maybe we don't need to support multiple errors
>> at all.  That all errors, including ENOSPC, get collapsed into EIO.
>> POSIX already tells us to do that for close() and permits us to do that
>> for fsync().
>>=20
>
> That is certainly allowed under POSIX as I interpret the spec. At a
> minimum we just need a single flag and can collapse all errors under
> that.
>
> That said, I think giving more specific errors where we can is useful.
> When your program is erroring out and writing 'I/O error' to the logs,
> then how much time will your admins burn before they figure out that it
> really failed because the filesystem was full?

What if you don't have an admin?  What if it was an over-quota error?
I think precise error messages are valuable.
I am leaning towards "last error wins" though.  The complexity of any
scheme that reports "worst recent error" seems to out weigh the value.

I think we should present this as a service to filesystems. e.g. create
a "recent_wb_error" structure which the filesystem can record errors in
when they occur, and syscalls can read errors from.
One of these would be provided in 'struct address_space', but
filesystems can easily embed one in their own data structure
(e.g. nfs_open_context) if they want to.

I don't think we should return a recent_wb_error on close by default,
but individual filesystems can ("man 2 close" implies NFS does this for
EDQUOT at it should continue to do so).

fsync() (and file_sync_range()) should return a recent_wb_error, but
what about write()?  It would be a suitable way to stop an application
early, but it isn't exactly the requested write that failed...
Posix says of EIO from write:

    A physical I/O error has occurred.

which is rather vague.  Where and when did this error in physics (:-)
occur?

O_DIRECT write() can get an EIO from a previous write-back write to the
same file.  Maybe non-O_DIRECT writes should too?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljkKIcACgkQOeye3VZi
gblzMA/8DTyC0RurhOpSp0z7VMNGbXMJKoqAOalWkeZDmo6sgNff5gEYA4ESqfrC
NC1SAQMKQ2sOn0WSsk2y8LGazH2C/UFnb6ytMRbG0fnEZqiW/PgG/r1ScVlr1TO/
veNmAa5aJU+6aBdbdM3KU9upLCPCBYDVwrlxzupjPF2asG2l8sCeUFHRWyKdqciq
rkdC8Q1qOHrnwE9eT8PcjsjQPrEiTzk8zChZnHodTNQ0u2W6rPbWkcdloSsF4w2W
ijcWhnMaCb2K0Sn5ausbE269i0Iu6sKdV5U6We4f8SYRPUMoWIpr4/UKjcBba/fF
ocsnYEReVtiWfPjYtmH5eIhZB6BqU7QGMnWXJtPQAF7fLV5gh/sHZaB9LAeVA8F4
aQZNIiW4hVh2F+oVcpWRnHJgoM9+/OtpWDQny7KucU1fdz5O2FXxZYfZei3/g0Pd
WaWfzQHia2VzashqG9t4iToIeObEfek0UlNFMvcz/t199mZZ2HFq0+VBU41zhiLD
kTWjSUGX38oHDWpMwD6OcSE+Ux8lXA1+a7Q12hW0MAX+H5KQ51Zv/hC5mOd7dAsU
SDWhXVnbzAGBOny+NkfDjVA1P2q9EmW/5DrqiHSK0TEyFCBCIHllwWxpkkQ6YZko
rO3IYoFfwvZYchcKJdy/18JYqrf6EBqNP7vE3FnG++deS8QGtrQ=
=Uo8h
-----END PGP SIGNATURE-----
--=-=-=--
