From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
Date: Sat, 3 Aug 2013 20:33:16 -0400
Message-ID: <20130804003316.GA19781@thunk.org>
References: <1374699833.7083.2.camel@localhost>
 <20130724233628.GD3641@logfs.org>
 <51F14136.30409@mozilla.com>
 <51F1556A.20909@mozilla.com>
 <51FB2C87-854F-4250-9587-B5BBF4E85EE8@dubeyko.com>
 <51F17005.7030309@mozilla.com>
 <1374825683.3671.35.camel@slavad-ubuntu>
 <20130726132034.GB21977@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>,
	Dhaval Giani <dgiani@mozilla.com>,
	Taras Glek <tglek@mozilla.com>, linux-kernel@vger.kernel.org,
	vdjeric@mozilla.com, glandium@mozilla.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130726132034.GB21977@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 26, 2013 at 09:20:34AM -0400, J=F6rn Engel wrote:
>=20
> I don't think the e2compr patches are strictly necessary.  They are a
> good option, but not the only one.

Sorry for not chiming in earlier; I've been travelling this past week,
and between that and a bunch of other things I've fallen a bit earlier
on my e-mail.

> One trick to simplify the problem is to make Dhaval's compressed file=
s
> strictly read-only.  It will require some dance to load the compresse=
d
> content, flip the switch, then uncompress data on the fly and disallo=
w
> writes.  Not the most pleasing of interfaces, but yet another option.

Yeah, this is something that I've wanted for a while.  (In fact a few
years ago I shopped around this design to some folks who were
associated with Firefox.)  MacOS has something rather similar to this.
I haven't had a chance to look at Dhaval's patches yet, but the way
I've been thinking about this is that the compression and building the
table mapping compressed clusters to byte offsets in the file would be
done in userspace.  Once the compressed file plus the table is written
to the disk, the userspace program would then close the file
descriptor, and then set the "compressed" bit.

When the bit is set, we flush all of its pages from the page cache,
and the file becomes immutable.  At that point, the kernel will handle
the decompression, by implementing readpages() by reading the pages
into the buffer cache, and then decompressing the compressed cluster
of pages into the page cache.  This gives us transparent compression,
with a fraction of the complexity of supporting read/write
compression.  In addition, since we don't have to worry rewriting a
cluster (and having the modified compressed cluster taking up more
space), the on-disk representation can be a lot more efficient, since
you don't have to use a stacker-style design.

One of the cool things about this design is that the vast majority of
files on a typical distribution are write-once, and better yet, they
are written by the package manager.  So once you teach dpkg, rpm, and
the Android package installer how to write the file in this compressed
format and set the compressed bit, we can the vast majority of the
benefits of using compressed file with minimal effort.

						- Ted

P.S.  This is interesting not just for systems with slow HDD's, but
also for cheap, single-channel MMC flash, the kind found in low-end
handset and embedded systems.

P.P.S.  At least in theory, nothing of what I've described here has to
be ext4 specific.  We could implement this in the VFS layer, at which
point not only ext4 would benefit, but also btrfs, xfs, f2fs, etc.
