From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Wed, 17 Sep 2008 16:18:42 +0200
Message-ID: <20080917141840.GB8750@logfs.org>
References: <E1Kea9F-0004L5-Ds@closure.thunk.org> <1221331767-16870-1-git-send-email-tytso@mit.edu> <20080914134711.GA21746@infradead.org> <20080914180132.GC13074@mit.edu> <20080914180843.GA31649@infradead.org> <20080914195811.GE13074@mit.edu> <20080915144754.GA16491@infradead.org> <20080916064514.GH3241@webber.adilger.int> <20080916220346.GB10562@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@sun.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org, Mark Fasheh <mfasheh@suse.com>,
	mtk.manpages@gmail.com
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080916220346.GB10562@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 16 September 2008 18:03:46 -0400, Theodore Tso wrote:
> On Mon, Sep 15, 2008 at 11:49:43PM -0700, Andreas Dilger wrote:
> > The intent of this flag was a "catch-all" to indicate it isn't safe
> > to try and read this block from disk, either because it is encrypte=
d,
> > compressed, on a remote system (HSM or over a network), or maybe no=
t
> > even written to disk yet (delalloc).
> >=20
> > In some cases (e.g. dump on a snapshot, or boot with LILO) it IS ok=
 to
> > read directly from a block device underneath the filesystem, but th=
at
> > would completely fail for the above cases.
>=20
> Indeed, I thought it was pretty clear and obvious, but let me give an
> quick but formal definition, and a potential name: DATA_ENCODED
>=20
> If this flag is not set, then applications that who wish to access th=
e
                                             ^^^^^^^^
> file data may do so by accessing the block device at the indicated
> offset when the filesystem is unmounted.  If the filesystem is
> mounted, it is undefined whether accessing via the block device will
> return valid data.  If the flag DATA_ENCODED flag is set, it is almos=
t
> certain that an application will never be able to access the file dat=
a
> via the block device.
>=20
> Would this make people happy?

Apart from the typo above, here is a more discouraging version:

  In general, accessing the block device directly is strongly discourag=
ed.
  Exceptions exist mainly in the form of boot loaders like lilo and gru=
b,
  at a time when the filesystem is not (cannot be) mounted.

  If the flag DATA_ENCODED is set, however, even this exception is no
  longer valid.  The content is encoded in some form.  Details are
  unknown, it could be compressed, encrypted or something else.

J=C3=B6rn

--=20
Man darf nicht das, was uns unwahrscheinlich und unnat=C3=BCrlich ersch=
eint,
mit dem verwechseln, was absolut unm=C3=B6glich ist.
-- Carl Friedrich Gau=C3=9F
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
