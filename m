From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/4] bdi: Track users that require stable page writes
Date: Thu, 22 Nov 2012 09:06:43 +1100
Message-ID: <20121122090643.7c9551dc@notabene.brown>
References: <20121121020027.10225.43206.stgit@blackbox.djwong.org>
	<20121121020034.10225.51692.stgit@blackbox.djwong.org>
	<20121121105624.GA19050@infradead.org>
	<20121121215207.GB32202@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PVceyAK9qxlxdwKpsA1PF=h"; protocol="application/pgp-signature"
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
	lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com, tytso@mit.edu,
	rminnich@sandia.gov, viro@zeniv.linux.org.uk,
	martin.petersen@oracle.com, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121121215207.GB32202@blackbox.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--Sig_/PVceyAK9qxlxdwKpsA1PF=h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Nov 2012 13:52:07 -0800 "Darrick J. Wong"
<darrick.wong@oracle.com> wrote:

> > Can you add a rationale on why we'd want to allow users to change the
> > value?  I can't really think of any.
>=20
> I dislike the idea that if a program is dirtying pages that are being wri=
tten
> out, then I don't really know whether the disk will write the before or a=
fter
> version.  If the power goes out before the inevitable second write, how d=
o you
> know which version you get?  Sure would be nice if I could force on stable
> writes if I'm feeling paranoid.

I don't think this fear is at all rational (but then you did suggest
paranoia).

If the power goes out, then any write that has been requested, but for which
an 'fsync' hasn't completed, may - or may not - have been written.   Setting
this flag doesn't really change that.

The filesystem should provide some degree of certainty - i.e. either old
data or new data and I believe they mostly do - though ext3 with
journal=3Dwriteback explicitly doesn't promise very much.  Beyond that, if =
you
want any certainty then the app must provide that by using fsync.

So I'm with Christoph here: I don't think the flag should be user-settable.

NeilBrown

--Sig_/PVceyAK9qxlxdwKpsA1PF=h
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUK1Qcznsnt1WYoG5AQKCyhAAruA5qi89b/eRoKsp+7jjblOX8YkyS7Pa
9fXi3yMkpsL+mAnfFCxpdLfPeha0gb+or4lSRilmZBI5zt5ZWjn7O+qtk1NwrjLo
WRh3DAl+wo5G4bJqwClIQyPc+qkYJ/z+gI69gvgCh79R2x5cWs/NUflhQnAInNC2
xC905mS6e4pNbRJZlb6p4uj6lO52qtMVPscUVCGHCJt5aOrmBt774dtliVUsEkiK
dChHlBFvwgnU4iDkI3WpPKDUEvt+tHDfwWUpipq+9K6auJeSxrmUgUAmekyKb9Yg
5YtPeSrwBf9X3AKp/zEwekSijXIwz2schppw2636wZ9KpBkuoOqgvR84Nideq7OW
jrIP2htUAce80ANlM5YGbDfKyesCVcitJpz1jK9u3yXUiqzgjH/SDXU0l76X40XA
YIXI3QxQqnZl+OVj5bf+oS+tmXfSiv+klatPO9n9N6FWPsNfoddLUauW1jMOxHq3
XMCJ1WSWQh+Hskp3XkW1ffFPi+GCFYHPJ54xzstCN9KVbFy+o6GJEL70FzO31rkz
TPveCV86XKCpSp5CRQXMcR7s33VysMWaYY33BzcKgY7JQw6pdxq4nUeqpk/jxeHt
RrbcJvae+tXcTbdEpB5h/43Y/+YzGfBjB13Dbg9zLt8HeQ//+jro4G4oP5rDUDhf
Z4JqCUCgbxI=
=0UCN
-----END PGP SIGNATURE-----

--Sig_/PVceyAK9qxlxdwKpsA1PF=h--
