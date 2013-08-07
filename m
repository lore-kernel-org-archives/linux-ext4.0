From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
Date: Wed, 7 Aug 2013 03:21:47 -0600
Message-ID: <1CC5EF89-C66F-4AB7-A3E6-162D7E17E671@dilger.ca>
References: <1374699833.7083.2.camel@localhost> <20130724233628.GD3641@logfs.org> <51F14136.30409@mozilla.com> <51F1556A.20909@mozilla.com> <51FB2C87-854F-4250-9587-B5BBF4E85EE8@dubeyko.com> <51F17005.7030309@mozilla.com> <1374825683.3671.35.camel@slavad-ubuntu> <20130726132034.GB21977@logfs.org> <20130804003316.GA19781@thunk.org> <20130804022114.GA24655@logfs.org> <20130804234824.GB7118@dastard>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?iso-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Vyacheslav Dubeyko <slava@dubeyko.com>,
	Dhaval Giani <dgiani@mozilla.com>,
	Taras Glek <tglek@mozilla.com>, linux-kernel@vger.kernel.org,
	vdjeric@mozilla.com, glandium@mozilla.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130804234824.GB7118@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2013-08-04, at 5:48 PM, Dave Chinner wrote:
> On Sat, Aug 03, 2013 at 10:21:14PM -0400, J=F6rn Engel wrote:
>> On Sat, 3 August 2013 20:33:16 -0400, Theodore Ts'o wrote:
>>>=20
>>> P.P.S.  At least in theory, nothing of what I've described here has=
 to be ext4 specific.  We could implement this in the VFS
>>> layer, at which point not only ext4 would benefit, but also btrfs, =
xfs, f2fs, etc.
>>=20
>> Except for an inode bit that needs to be stored in the filesystem,
>> agreed.  The ugliness I see is in detecting how to treat the
>> filesystem at hand.
>>=20
>> Filesystems with mandatory compression (jffs2, ubifs,...):
>> - Just write the file, nothing to do.
>> Filesystems with optional compression (logfs, ext2compr,...):
>> - You may or may not want to chattr between file creation and writin=
g
>>  the payload.
>> Filesystems without compression (ext[234], xfs,...):
>> - Just write the file, nothing can be done.
>> - Alternatively fall back to a userspace version.
>> Filesystems with optional uncompression (what is being proposed):
>> - Write the file in compressed form, close, chattr.
>=20
> There's way more than that on the filesystem specific side. For
> example, if we have to store a special flag to say it's a compressed
> file, then we have to be able to validate that flag is correctly set
> when doing filesystem checks (i.e. e2fsck, xfs_repair, etc), and
> probably also validate that the *data is in a decodable format*.
>=20
> That is, if the data is not in a compressed state and the flag is
> set, then that's a filesystem corruption. It might be metadata
> corruption, it might be data corruption, but either way it is
> something that we need to be able verify as being correctly set.

I don't see how this _has_ to exist for any of the userspace tools.
If the file is corrupt (i.e. cannot be decompressed), then that is
no different than if the file is corrupt and it is a regular file.
e2fsck doesn't detect file content corruption, and AFAIK neither
does xfs_repair.  Why is the bar raised just because there is a
flag that reports the file is in compressed format?

> So, we need support for this new format in all the filesystem
> userspace tools as well.

I'm not saying that a tool to check this would be a bad thing, but
if the compression support is a generic feature of the VFS, then it
makes sense that the checker can also be generic and unrelated to
the filesystem metadata checking as well.  It may be "gunzip -t"
or LZO equivalent is enough to determine if the file is/isn't in a
valid state, and if not then the flag can be cleared from userspace
in the same way it was set (presumably chattr is enough).

Possibly a per-file hook could be added to the fsck tools to run an
arbitrary data verification command?  That would be generically
useful for all kinds of things and not just this compression code.

>> I would like to see the compression side done in the kernel as well.
>> Then we can chattr right after creat() and, if that fails, either
>> proceed anyway or go to a userspace fallback.  All decisions can be
>> made early on and we don't have to share the format with lots of
>> userspace.
>>=20
>> Sure, we still have to share the format with fsck and similar
>> filesystem tools.  But not with installers.
>=20
> Yup, you are effectively saying that the compression format becomes
> a fixed on-disk format defined by the VFS and that all filesystems
> have to be able to support in their userspace tools. That's *lots*
> of code that will need to share with, and so now you're talking
> about needing a library to match the kernel implementation. How do
> you propose shipping that so that userspace tools can keep up with
> the kernels that ship?

Presumably if the userspace checking is independent of the fsck tool
this would be much less of a burden.  As you write below, we'd also
want to avoid flavour-of-the-month for compression formats, to keep
the ongoing burden down.

> Indeed, how are we going to test it? This is absolutely going to
> require xfstests support, which means we'll need an independent
> method of doing compression and decompression so we can validate
> that the kernel code is doing the right thing (e.g. xfs_io support).
> We'll need data validation tests, tests that validate mmap and
> direct IO behaviour, data corruption and fsck tests, seek tests,
> etc.

The testing is definitely needed in order for this to become robust.
I'm not sure if any of this is filesystem-specific.  It might even
be possible to change things minimally to generate all files in
compressed mode when running some other test (e.g. LD_PRELOAD hook
on close() that compresses the file and sets the flag if it isn't
already set)? =20

> Then we'll need man pages, documentation in the kernel code about
> the compression format, etc.
>=20
> The kernel compression/decompression code is the *easy bit*, and
> only about 10% of the work needed to bring this functionality in
> robust manner to the VFS....

Sure, but it all has to start somewhere...

> And, like all compression formats in the kernel, they last about 3
> months before someone comes up with some fancy new one that is 1%
> faster or smaller at something, and we end up with a proliferation
> of different supported compression formats. What's the plan to stop
> this insanity from occurring for such a VFS provided compression
> format?

Definitely agree with this part.

Cheers, Andreas
