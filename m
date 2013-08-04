From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
Date: Mon, 5 Aug 2013 09:48:24 +1000
Message-ID: <20130804234824.GB7118@dastard>
References: <1374699833.7083.2.camel@localhost>
 <20130724233628.GD3641@logfs.org>
 <51F14136.30409@mozilla.com>
 <51F1556A.20909@mozilla.com>
 <51FB2C87-854F-4250-9587-B5BBF4E85EE8@dubeyko.com>
 <51F17005.7030309@mozilla.com>
 <1374825683.3671.35.camel@slavad-ubuntu>
 <20130726132034.GB21977@logfs.org>
 <20130804003316.GA19781@thunk.org>
 <20130804022114.GA24655@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>,
	Vyacheslav Dubeyko <slava@dubeyko.com>,
	Dhaval Giani <dgiani@mozilla.com>,
	Taras Glek <tglek@mozilla.com>, linux-kernel@vger.kernel.org,
	vdjeric@mozilla.com, glandium@mozilla.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130804022114.GA24655@logfs.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Aug 03, 2013 at 10:21:14PM -0400, J=F6rn Engel wrote:
> On Sat, 3 August 2013 20:33:16 -0400, Theodore Ts'o wrote:
> >=20
> > P.P.S.  At least in theory, nothing of what I've described here has=
 to
> > be ext4 specific.  We could implement this in the VFS layer, at whi=
ch
> > point not only ext4 would benefit, but also btrfs, xfs, f2fs, etc.
>=20
> Except for an inode bit that needs to be stored in the filesystem,
> agreed.  The ugliness I see is in detecting how to treat the
> filesystem at hand.
>=20
> Filesystems with mandatory compression (jffs2, ubifs,...):
> - Just write the file, nothing to do.
> Filesystems with optional compression (logfs, ext2compr,...):
> - You may or may not want to chattr between file creation and writing
>   the payload.
> Filesystems without compression (ext[234], xfs,...):
> - Just write the file, nothing can be done.
> - Alternatively fall back to a userspace version.
> Filesystems with optional uncompression (what is being proposed):
> - Write the file in compressed form, close, chattr.

There's way more than that on the filesystem specific side. For
example, if we have to store a special flag to say it's a compressed
file, then we have to be able to validate that flag is correctly set
when doing filesystem checks (i.e. e2fsck, xfs_repair, etc), and
probably also validate that the *data is in a decodable format*.

That is, if the data is not in a compressed state and the flag is
set, then that's a filesystem corruption. It might be metadata
corruption, it might be data corruption, but either way it is
something that we need to be able verify as being correctly set.

So, we need support for this new format in all the filesystem
userspace tools as well.

> I would like to see the compression side done in the kernel as well.
> Then we can chattr right after creat() and, if that fails, either
> proceed anyway or go to a userspace fallback.  All decisions can be
> made early on and we don't have to share the format with lots of
> userspace.
>
> Sure, we still have to share the format with fsck and similar
> filesystem tools.  But not with installers.

Yup, you are effectively saying that the compression format becomes
a fixed on-disk format defined by the VFS and that all filesystems
have to be able to support in their userspace tools. That's *lots*
of code that will need to share with, and so now you're talking
about needing a library to match the kernel implementation. How do
you propose shipping that so that userspace tools can keep up with
the kernels that ship?

Indeed, how are we going to test it? This is absolutely going to
require xfstests support, which means we'll need an independent
method of doing compression and decompression so we can validate
that the kernel code is doing the right thing (e.g. xfs_io support).
We'll need data validation tests, tests that validate mmap and
direct IO behaviour, data corruption and fsck tests, seek tests,
etc.

Then we'll need man pages, documentation in the kernel code about
the compression format, etc.

The kernel compression/decompression code is the *easy bit*, and
only about 10% of the work needed to bring this functionality in
robust manner to the VFS....

And, like all compression formats in the kernel, they last about 3
months before someone comes up with some fancy new one that is 1%
faster or smaller at something, and we end up with a proliferation
of different supported compression formats. What's the plan to stop
this insanity from occurring for such a VFS provided compression
format?

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
