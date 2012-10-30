From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC PATCH 1/2] bdi: Create a flag to indicate that a backing
 device needs stable page writes
Date: Wed, 31 Oct 2012 08:49:11 +1100
Message-ID: <20121031084911.7d7c5050@notabene.brown>
References: <20121026101909.GB19617@blackbox.djwong.org>
	<20121027013524.GA19591@blackbox.djwong.org>
	<20121029181358.GG18767@quack.suse.cz>
	<20121029183051.GJ18767@quack.suse.cz>
	<20121030104837.2e4b06fc@notabene.brown>
	<20121030001008.GA372@quack.suse.cz>
	<20121030113441.7f62df51@notabene.brown>
	<20121030133825.GA2260@quack.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+uE7onn75zqqfppxxN9V6H3"; protocol="application/pgp-signature"
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20121030133825.GA2260@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--Sig_/+uE7onn75zqqfppxxN9V6H3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Oct 2012 14:38:25 +0100 Jan Kara <jack@suse.cz> wrote:

> On Tue 30-10-12 11:34:41, NeilBrown wrote:
> > On Tue, 30 Oct 2012 01:10:08 +0100 Jan Kara <jack@suse.cz> wrote:
> >=20
> > > On Tue 30-10-12 10:48:37, NeilBrown wrote:
> > > > On Mon, 29 Oct 2012 19:30:51 +0100 Jan Kara <jack@suse.cz> wrote:
> > > >=20
> > > > > On Mon 29-10-12 19:13:58, Jan Kara wrote:
> > > > > > On Fri 26-10-12 18:35:24, Darrick J. Wong wrote:
> > > > > > > This creates BDI_CAP_STABLE_WRITES, which indicates that a de=
vice requires
> > > > > > > stable page writes.  It also plumbs in a sysfs attribute so t=
hat admins can
> > > > > > > check the device status.
> > > > > > >=20
> > > > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > >   I guess Jens Axboe <axboe@kernel.dk> would be the best target=
 for this
> > > > > > patch (so that he can merge it). The patch looks OK to me. You =
can add:
> > > > > >   Reviewed-by: Jan Kara <jack@suse.cz>
> > > > >   One more thing popped up in my mind: What about NFS, Ceph or md=
 RAID5?
> > > > > These could (at least theoretically) care about stable writes as =
well. I'm
> > > > > not sure if they really started to use them but it would be good =
to at
> > > > > least let them know.
> > > > >=20
> > > >=20
> > > > What exactly are the semantics of BDI_CAP_STABLE_WRITES ?
> > > >=20
> > > > If I set it for md/RAID5, do I get a cast-iron guarantee that no by=
te in any
> > > > page submitted for write will ever change until after I call bio_en=
dio()?
> > >   Yes.
> > >=20
> > > > If so, is this true for all filesystems? - I would expect a bigger =
patch would
> > > > be needed for that.
> > >   Actually the code is in kernel for quite some time already. The pro=
blem
> > > is it is always enabled causing unnecessary performance issues for so=
me
> > > workloads. So these patches try to be more selective in when the code=
 gets
> > > enabled.
> > >=20
> > > Regarding "all filesystems" question: If we update filemap_page_mkwri=
te()
> > > to call wait_on_page_writeback() then it should be for all filesystem=
s.
> >=20
> > Cool.  I didn't realise it had progressed that far.
> >=20
> > I guess it is time to look at the possibility of removing the
> > 'copy-into-cache' step for full-page, well-aligned bi_iovecs.
> >=20
> > I assume this applies to swap-out as well ??  It has been a minor sourc=
e of
> > frustration that when you swap-out to RAID1, you can occasionally get
> > different data on the two devices because memory changed between the tw=
o DMA
> > events.
>   Really? I'm somewhat surprised. I was under the impression that when a
> page is added to a swap cache it is unmapped so there should be no
> modification to it possible while it is being swapped out. But maybe it
> could get mapped back and modified after we unlock the page and submit the
> bio. So mm/memory.c:do_swap_page() might need wait_on_page_writeback() as
> well. But I'm not an expert on swap code. I guess I'll experiment with th=
is
> a bit. Thanks for a pointer.
>=20
> 								Honza

Thanks for looking into it.  I should mention that it was some years ago th=
at
this occasional inconsistency in RAID1 was reported and that I concluded th=
at
it as due to swap (though I don't recall how deeply I examined the code).
It could well be different now.  I never bothered pursuing it because I don=
't
think that behaviour is really wrong, just mildly annoying.

Thanks,
NeilBrown

--Sig_/+uE7onn75zqqfppxxN9V6H3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUJBLVznsnt1WYoG5AQKowQ/8C8WrZWT0L4RZ5g7rjA959KhWNG1sNBn8
yJnyii2Juq8ZhE+zinT20KSV+Vd+So7G9AqGfR7qEV14G8RoB+oH74kOmO3XVyfD
mMhGHADHQ/yxNpqRpqtc5T+q+QdQ0dhGUoMzFPRuAqY19dIFSOF0GVvXve9wOqgP
3mtdXbjhJ8xo8XhsmMqG3vCZuuWchwdIC4IHww9JmNbj/IEi3OCujXHkHZ91OsjK
clHpdCbx4ZvMCmr1Z1GlDiAEF2CHS/Twva5nrUmVua532jBozW/J3s0y8fHq619E
N3mdL+Goovn1n1y1IhKtIF00b6q83/b75Fyq9qQnE1doWumb+HH61RskJwDyAsGT
JPhql8WnNxZmFU57N6ri/fQWRKlWaIjPTUSF6NwQLc8/9flEWIOifTxLvsPWIDLq
2+DVKZBrPvRePtlYrLtpV8fL75bod/xTqk3CuWMUt2YpkMIpOzJY7vyWz1+AAGWC
u1Dt528V8ZgMs042Gx5iihATPPrIolP4NSXqNiuJnC6dcsREOhIqczzevCEEPsLO
EDu/J5X5bYKP955m/HBegQYQ3zYm+y6OiPVpIfDm3GZCgfNOFbHKfk7IMnDv4tn2
mzfy0TQnaw77rWH/XzxhlMYjmVymbbPCJkd09lgMrfe4j7wx9ake/+JmnL5sXzEO
xPwdHKYQa+I=
=bJ2C
-----END PGP SIGNATURE-----

--Sig_/+uE7onn75zqqfppxxN9V6H3--
