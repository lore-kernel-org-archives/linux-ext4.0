From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC PATCH 1/2] bdi: Create a flag to indicate that a backing
 device needs stable page writes
Date: Tue, 30 Oct 2012 11:34:41 +1100
Message-ID: <20121030113441.7f62df51@notabene.brown>
References: <20121026101909.GB19617@blackbox.djwong.org>
	<20121027013524.GA19591@blackbox.djwong.org>
	<20121029181358.GG18767@quack.suse.cz>
	<20121029183051.GJ18767@quack.suse.cz>
	<20121030104837.2e4b06fc@notabene.brown>
	<20121030001008.GA372@quack.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3wkcIiEQu82F8kqH3pyvNIM"; protocol="application/pgp-signature"
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58951 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761016Ab2J3Ae2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Oct 2012 20:34:28 -0400
In-Reply-To: <20121030001008.GA372@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Sig_/3wkcIiEQu82F8kqH3pyvNIM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Oct 2012 01:10:08 +0100 Jan Kara <jack@suse.cz> wrote:

> On Tue 30-10-12 10:48:37, NeilBrown wrote:
> > On Mon, 29 Oct 2012 19:30:51 +0100 Jan Kara <jack@suse.cz> wrote:
> >=20
> > > On Mon 29-10-12 19:13:58, Jan Kara wrote:
> > > > On Fri 26-10-12 18:35:24, Darrick J. Wong wrote:
> > > > > This creates BDI_CAP_STABLE_WRITES, which indicates that a device=
 requires
> > > > > stable page writes.  It also plumbs in a sysfs attribute so that =
admins can
> > > > > check the device status.
> > > > >=20
> > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > >   I guess Jens Axboe <axboe@kernel.dk> would be the best target for=
 this
> > > > patch (so that he can merge it). The patch looks OK to me. You can =
add:
> > > >   Reviewed-by: Jan Kara <jack@suse.cz>
> > >   One more thing popped up in my mind: What about NFS, Ceph or md RAI=
D5?
> > > These could (at least theoretically) care about stable writes as well=
. I'm
> > > not sure if they really started to use them but it would be good to at
> > > least let them know.
> > >=20
> >=20
> > What exactly are the semantics of BDI_CAP_STABLE_WRITES ?
> >=20
> > If I set it for md/RAID5, do I get a cast-iron guarantee that no byte i=
n any
> > page submitted for write will ever change until after I call bio_endio(=
)?
>   Yes.
>=20
> > If so, is this true for all filesystems? - I would expect a bigger patc=
h would
> > be needed for that.
>   Actually the code is in kernel for quite some time already. The problem
> is it is always enabled causing unnecessary performance issues for some
> workloads. So these patches try to be more selective in when the code gets
> enabled.
>=20
> Regarding "all filesystems" question: If we update filemap_page_mkwrite()
> to call wait_on_page_writeback() then it should be for all filesystems.

Cool.  I didn't realise it had progressed that far.

I guess it is time to look at the possibility of removing the
'copy-into-cache' step for full-page, well-aligned bi_iovecs.

I assume this applies to swap-out as well ??  It has been a minor source of
frustration that when you swap-out to RAID1, you can occasionally get
different data on the two devices because memory changed between the two DMA
events.

NeilBrown

--Sig_/3wkcIiEQu82F8kqH3pyvNIM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIUAwUBUI8goTnsnt1WYoG5AQKlcA/4rnIhDcDlbOv9PLnagojoDKuiPJEZ9Dmc
2Y5LWmVMqMJ3S2+wWWcGu18zvBEywpkrAgECR7aV3NpwEot7m+AWwHn1eQSLPntW
7M9RDO+b+l95koHqqa0a8A09gHElQ9Eini1KcbrkPjSYGvg73z8SYuRiyPWTUaF8
+Q8bjQDsXaNYKIyMpgRCQ68Phbdw+OTA39kRt6i3WYAauM+y6GP94BFnjEzVXMUt
OVoW0EtT/1FyeeEMooW3SM3hVxGhrDko+ATi/exs+PdfKS4VaIzFVFcNU7k7gill
7bZCwEQ5nYawCSGjCs7igoF0FEDzjAWhtZdP17Z7t5jHojeLR/aot72XqP3RuOkf
ADGC5+ncwGf0HOLTymOoBN8WyjcicgFlnYIKMOa+oa45GmCtI4v48CtOck2xlX/w
YuBZX/dJdtneHq03b2H6VwI1IR1Kurdf37nU/t/EGXWS4d36NDJ2WM84uUsE8znj
kcKqI9h96kYJdvto5mgxxocGfzZcgJbYp6ObSouvuHVlDG51YLskp50qBqVrFGcO
AOM7K3/7UKt5luedvckLcuPUGFAWBaWEHHXHRukhYuYuQswFQ1AnLtM16jJ8MvNV
se/Vq8XOYNNThVXZ3OZSLPBmqLZbsMN3VAEOUAyl6g64eFXg+x0iVzaNrAbtWV65
9Zo592G1yg==
=LKIf
-----END PGP SIGNATURE-----

--Sig_/3wkcIiEQu82F8kqH3pyvNIM--
