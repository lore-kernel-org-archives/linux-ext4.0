From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Fri, 19 Sep 2008 18:38:02 +0100
Message-ID: <20080919173802.GB17666@shareable.org>
References: <20080914134711.GA21746@infradead.org> <20080914180132.GC13074@mit.edu> <20080914180843.GA31649@infradead.org> <20080914195811.GE13074@mit.edu> <20080915144754.GA16491@infradead.org> <20080916064514.GH3241@webber.adilger.int> <20080916220346.GB10562@mit.edu> <20080917141840.GB8750@logfs.org> <20080917150212.GD22613@shareable.org> <20080919140502.GA6985@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org, Mark Fasheh <mfasheh@suse.com>,
	mtk.manpages@gmail.com
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080919140502.GA6985@think.oraclecorp.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Chris Mason wrote:
> On Wed, Sep 17, 2008 at 04:02:12PM +0100, Jamie Lokier wrote:
> > J=F6rn Engel wrote:
> > > Apart from the typo above, here is a more discouraging version:
> > >=20
> > >   In general, accessing the block device directly is strongly dis=
couraged.
> > >   Exceptions exist mainly in the form of boot loaders like lilo a=
nd grub,
> > >   at a time when the filesystem is not (cannot be) mounted.
> > >=20
> > >   If the flag DATA_ENCODED is set, however, even this exception i=
s no
> > >   longer valid.  The content is encoded in some form.  Details ar=
e
> > >   unknown, it could be compressed, encrypted or something else.
> >=20
> > I'm not clear about something from the above description.
> >=20
> > If I were writing a journalling / tree-like filesystem, and I did
> > store data in blocks without encoding, but fsync() only waits for t=
hem
> > to be committed to journal, not their final destination, and also t=
hey
> > might be moved around - should I set DATA_ENCODED or not?  (And sho=
uld
> > I return the temporary location in the long-running journal since
> > that's the only place the data is committed at the time of the call=
?)
> >=20
> > Assume that even reading after unmounting is not 100% safe, because
> > the data blocks could be relocated after calling FIEMAP (when the
> > filesystem must be mounted), and before the unmount.
>=20
> For the journal case at least, grub can walk through the log of the F=
S
> looking for up to date copies of things.  It does this already for
> reiserfs because the btree can't be trusted at all without a log repl=
ay.

Ok, that's good - grub doesn't need FIEMAP, it reads the filesystem pro=
perly.

So if I were writing a filesystem, what am I expected to return in
=46IEMAP for these cases?  I'm thinking I should set DATA_ENCODED, even
though the examples in J=F6rn's description don't cover this.

I'm thinking there are three main uses for FIEMAP:

  1. LILO and similar.  LILO itself is fine with FIBMAP though.

  2. Fragmentation measurement and possibly defragmentation tools.

  3. Something wants to have an idea of which areas of disk will be
     accessed, so it can optimise I/O at a higher level - i.e. a databa=
se.
     This isn't foolproof, especially for writes on recent filesystems
     which don't overwrite in place.

1 means DATA_ENCODED should be set whenever there's any likelihood
that the result isn't reliable, so that would include when data is
stored in a journal or other temporary place and not a permanent place
on disk.

2 and 3 don't care about DATA_ENCODED at all.

-- Jamie
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
