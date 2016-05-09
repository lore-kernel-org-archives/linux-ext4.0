From: Jeff Layton <jlayton@poochiereds.net>
Subject: Re: [PATCH 1/6] statx: Add a system call to make enhanced file info
 available
Date: Mon, 09 May 2016 08:02:58 -0400
Message-ID: <1462795378.4481.31.camel@poochiereds.net>
References: <20160429125736.23636.47874.stgit@warthog.procyon.org.uk>
	 <20160429125743.23636.85219.stgit@warthog.procyon.org.uk>
	 <20160508083543.GA14316@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-afs@vger.kernel.org,
	linux-nfs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:35620 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbcEIMDE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2016 08:03:04 -0400
Received: by mail-qk0-f170.google.com with SMTP id n62so19274606qkc.2
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2016 05:03:03 -0700 (PDT)
In-Reply-To: <20160508083543.GA14316@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 2016-05-08 at 01:35 -0700, Christoph Hellwig wrote:
> >=20
> > 	int ret =3D statx(int dfd,
> > 			const char *filename,
> > 			unsigned int flags,
> > 			unsigned int mask,
> > 			struct statx *buffer);
>=20
> Please move the flags and mask after the buffer, similar to how all
> the AT_ flags were added to the end for the statat calls.
>=20
> > AT_FORCE_ATTR_SYNC can be set in flags.=C2=A0=C2=A0This will requir=
e a network
> > filesystem to synchronise its attributes with the server.
> >=20
> > AT_NO_ATTR_SYNC can be set in flags.=C2=A0=C2=A0This will suppress =
synchronisation
> > with the server in a network filesystem.=C2=A0=C2=A0The resulting v=
alues should be
> > considered approximate.
>=20
> And what happens if neither is set?
>=20

I'd suggest we have the documentation state that the lack of either
flag leaves it up to the filesystem. In the case of NFS, you'd get
"normal" attribute cache behavior, for instance which is governed by
the ac* attributes.

We should also note that in the case of something like AT_NO_ATTR_SYNC
on NFS, you might _still_ end up talking to the server if the client
has nothing in-core for that inode.

> > mask is a bitmask indicating the fields in struct statx that are of
> > interest to the caller.=C2=A0=C2=A0The user should set this to STAT=
X_BASIC_STATS to
> > get the basic set returned by stat().
>=20
> No a very good name for the constant.=C2=A0=C2=A0I don't really see h=
ow this macro
> is useful to start with.=C2=A0=C2=A0And _ALL? sure, but what's basic?
>=20
> > buffer points to the destination for the data.=C2=A0=C2=A0This must=
 be 256 bytes in
> > size.
>=20
> 256 bytes or sizeof(struct statx)?=C2=A0=C2=A0Even if they end up the=
 same the
> latter is a much more useful value.
>=20

ACK. We should also consider that while we have a fair bit of padding
in this structure now, we could end up running out of space in it at
some point. We should at least have a clear idea of how we'll handle
such a situation.

The obvious solution would be to add a new flag that says that we're
passing in an extended statx structure. The kernel would know not to
touch stuff in the extended part unless the flag was set. Userland
would know that that part had not been touched by the kernel if the
outbound flag wasn't set.


> > where st_information is local system information about the file,
>=20
> What the heck is "local system information"?=C2=A0=C2=A0Please define=
 each
> newly added field in detail.
>=20
> > st_gen is
> > the inode generation number, st_btime is the file creation time, st=
_version
> > is the data version number (i_version),
>=20
> Please define semantics for st_gen and st_version.
>=20
> > Time fields are split into separate seconds and nanoseconds fields =
to make
> > packing easier and the granularities can be queried with the filesy=
stem
> > info system call.=C2=A0=C2=A0Note that times will be negative if be=
fore 1970; in such
> > a case, the nanosecond fields should also be negative if not zero.
>=20
> Please coordinate with Arnd on the timespamp format - I'd hate to hav=
e
> a different encoding than he plans for all y2028/64-bit-time_t syscal=
ls
> to be added soon.
>=20
> > 	STATX_MTIME		Want/got st_mtime
> > 	STATX_CTIME		Want/got st_ctime
> > 	STATX_INO		Want/got st_ino
> > 	STATX_SIZE		Want/got st_size
> > 	STATX_BLOCKS		Want/got st_blocks
> > 	STATX_BASIC_STATS	[The stuff in the normal stat struct]
> > 	STATX_BTIME		Want/got st_btime
> > 	STATX_VERSION		Want/got st_data_version
>=20
> What is st_data_version?
>=20
> > 	STATX_GEN		Want/got st_gen
> > 	STATX_ALL_STATS		[All currently available stuff]
>=20
> Where does the STATS_ come from?=C2=A0=C2=A0Why no simply _ALL?
>=20
> How are the semantics defined when userspace asks for fields not
> available?=C2=A0=C2=A0I'd expect them to be ignored, but we should do=
cumentat that
> fact.
>=20
> > The defined bits in the st_information field give local system data=
 on a
> > file, how it is accessed, where it is and what it does:
>=20
> Oh, here we get st_information.=C2=A0=C2=A0The name sounds very wrong=
 for these
> flags, though.
>=20
> > 	STATX_INFO_ENCRYPTED		File is encrypted
>=20
> How do you define "encrypted", and what can the user do with this
> information?
>=20
> > 	STATX_INFO_TEMPORARY		File is temporary
>=20
> How do you define "temporary", and what can the user do with this
> information?
>=20
> > 	STATX_INFO_FABRICATED		File was made up by filesystem
>=20
> How do you define "fabricated", and what can the user do with this
> information?
>=20
> > 	STATX_INFO_KERNEL_API		File is kernel API (eg: procfs/sysfs)
>=20
> How do you define "kernel API" and what can the user do with this
> information?
>=20
> > 	STATX_INFO_REMOTE		File is remote
>=20
> How do you define "remote" and what can the user do with this
> information?
>=20
> > 	STATX_INFO_AUTOMOUNT		Dir is automount trigger
>=20
> How do you define "automount trigger" and what can the user do with t=
his
> information?
>=20
> > 	STATX_INFO_AUTODIR		Dir provides unlisted automounts
>=20
> How do you define "unlisted automount" and what can the user do with =
this
> information?
>=20
> > 	STATX_INFO_NONSYSTEM_OWNERSHIP	File has non-system ownership detai=
ls
>=20
> How do you define "non-system ownership" and what can the user do wit=
h this
> information?
>=20

Good questions all around.

My personal opinion is that if we have any attrs that are of
questionable value or that don't have a clear definition, that we
should just leave them out for now. This interface is designed to be
extendable, so there's no need to add it all in in the first pass. We
should focus on getting the API right and sort out the gory details of
specific attributes on a case-by-case basis.

> >=20
> > These are for the use of GUI tools that might want to mark files sp=
ecially,
> > depending on what they are.
>=20
> So far I don't see good definition of either flag, nor a good reason
> to add.
>=20
> > Fields in struct statx come in a number of classes:
>=20
> I really disagree with all these special cases.=C2=A0=C2=A0You should=
 get
> what you ask for, or rather what you ask for IFF the fs can provide i=
t.
> And we need to document for each field if it's optional if we want
> to treat it as option.=C2=A0=C2=A0A hodge podge bag of special cases =
is not an
> API that a normal person can use.
>=20

Agreed. In fact, the required attributes might be a good place to draw
the line on the initial submission of this patchset. Maybe just say "no
optional attributes yet" and we'll add them in later patches?

> > The following test program can be used to test the statx system cal=
l:
> >=20
> > 	samples/statx/test-statx.c
>=20
> Please add xfstests test cases that test all the corner cases.
>=20
> And please prepare a man page to document this system call properly.

Nothing wrong with preparing that ahead of time, but I see that as
something that should go along with the userland submission. In fact,
what's the plan for userland here? Should this be added to glibc or do
would it be better/simpler to have a new library for this?

Either way, what would be best for now though is to do What Neil
suggested, and lift most of this commit log into a file under
Documentation/.

=46urthermore, it'd probably be nice to document each mask bit in the
header file that userland will end up including. It's often the case
that the manpage may not reflect what the currently installed kernel
actually supports. The kernel headers are often more authoritative.
Being able to look at the header file for would be ideal.

--=20
Jeff Layton <jlayton@poochiereds.net>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
