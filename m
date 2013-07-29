From: Mike Hommey <glandium@mozilla.com>
Subject: Re: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
Date: Tue, 30 Jul 2013 08:15:39 +0900
Message-ID: <20130729231539.GA28383@glandium.org>
References: <1374699833.7083.2.camel@localhost>
 <20130724233628.GD3641@logfs.org>
 <51F14136.30409@mozilla.com>
 <51F1556A.20909@mozilla.com>
 <51FB2C87-854F-4250-9587-B5BBF4E85EE8@dubeyko.com>
 <51F17005.7030309@mozilla.com>
 <1374825683.3671.35.camel@slavad-ubuntu>
 <20130726132034.GB21977@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>,
	Dhaval Giani <dgiani@mozilla.com>,
	Taras Glek <tglek@mozilla.com>, linux-kernel@vger.kernel.org,
	tytso@mit.edu, vdjeric@mozilla.com, glandium@mozilla.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: =?iso-8859-15?Q?J=F6rn?= Engel <joern@logfs.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130726132034.GB21977@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 26, 2013 at 09:20:34AM -0400, J=F6rn Engel wrote:
> On Fri, 26 July 2013 12:01:23 +0400, Vyacheslav Dubeyko wrote:
> >=20
> > We are discussing not about good or bad idea. We need to elaborate =
a
> > right solution. I think that suggested idea is not clear. Do you
> > want to support compression in ext4? Or do you want to add some new
> > compression feature (likewise file-oriented compression)? If we are
> > talking about compression in ext4 then it needs to use e2compr patc=
h
> > set. Otherwise, if we are talking about file compression then it is
> > not question of concrete filesystem. And we need to make
> > implementation on VFS level. It is only architectural point of view=
=2E
>=20
> I don't think the e2compr patches are strictly necessary.  They are a
> good option, but not the only one.
>=20
> One trick to simplify the problem is to make Dhaval's compressed file=
s
> strictly read-only.  It will require some dance to load the compresse=
d
> content, flip the switch, then uncompress data on the fly and disallo=
w
> writes.  Not the most pleasing of interfaces, but yet another option.
>=20
> > Why do you try to implement likewise concept on kernel level? It
> > looks like you try to move some user-space concept in kernel-space.
>=20
> The kernel controls the page cache.  Once the page cache is filled
> with uncompressed file content, you can do mmap, regular file io, etc=
=2E
> Putting uncompression code into the kernel makes sense to me.  Whethe=
r
> a solution different from e2compr makes sense is yet to be seen.
>=20
> Whatever you do, it will require support from the on-disk format and
> the userspace ABI.  Setting the compression bit on a file has the
> clear advantage that it is an established interface and also supporte=
d
> by other filesystems.  Introducing yet another interface requires a
> fairly strong case to be made.  But who knows, maybe Dhaval can pull
> it off.

Come to think of it, the whole thing could be handled entirely in user
space through fuse. While this is probably a workable solution on
desktop/server environments, it doesn't pan out on Android: /dev/fuse i=
s
rarely available, and even if it were, fusermount needs to be there and
be a setuid program (or have the right capabilities). So, another angle
could be to allow some things to happen without privileges, such as
mounting filesystems in a private namespace. That wouldn't solve the
lack of /dev/fuse, though.

Mike
