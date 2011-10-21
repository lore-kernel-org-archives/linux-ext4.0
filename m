From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Metadata Replication for Ext4
Date: Fri, 21 Oct 2011 11:09:59 +1100
Message-ID: <20111021000959.GC14993@dastard>
References: <CAGr1F2EHCE2D-Sf+RS7q20huToUtqD3xqn9G8dtKrVxxpP4Hcw@mail.gmail.com>
 <alpine.LFD.2.00.1110191553500.29698@dhcp-27-109.brq.redhat.com>
 <FF85E3C6-8AB3-4A63-9E3D-06D06C778CEC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Lukas Czerner <lczerner@redhat.com>,
	Aditya Kali <adityakali@google.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Nauman Rafique <nauman@google.com>,
	TheodoreTso <tytso@google.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	"Alasdair G.Kergon" <agk@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:35468 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751946Ab1JUAPH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Oct 2011 20:15:07 -0400
Content-Disposition: inline
In-Reply-To: <FF85E3C6-8AB3-4A63-9E3D-06D06C778CEC@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 19, 2011 at 10:19:15AM -0600, Andreas Dilger wrote:
> On 2011-10-19, at 8:10 AM, Lukas Czerner <lczerner@redhat.com>
> wrote:
> > On Tue, 18 Oct 2011, Aditya Kali wrote:
> >=20
> >> This is a proposal for new ext4 feature that replicates ext4
> >> metadata and provides recovery in case where device blocks
> >> storing filesystem metadata goes bad. When the filesystem
> >> encounters a bad block during read, it returns EIO to the user.
> >> If this is a data block for some inode then the user
> >> application can handle this error in many different ways. But
> >> if we fail reading a filesystem metadata block (bitmap block,
> >> inode table block, directory block, etc.), we could potentially
> >> lose access to much larger amount of data and render the
> >> filesystem unusable. It is difficult (and not expected) for the
> >> user application to recover from such filesystem metadata loss.
> >> This problem is observed to be much more severe on SSDs which
> >> tend to show more frequent read errors when compared to disks
> >> over the same duration.
> >>=20
> >> There are different ways in which block read errors in
> >> different metadata could be handled. For example, if the
> >> filesystem is unable to read a block/inode allocation bitmap
> >> then we could just assume that all the blocks/inodes in that
> >> block group are allocated and let fsck fix this later. For
> >> inode table and directory blocks, we could play some (possibly
> >> unreliable) tricks with fsck. In either case, the filesystem
> >> will be fully usable only after it=E2=80=99s fsck=E2=80=99d (which=
 is a
> >> disruptive process on production systems). Darrick Wong=E2=80=99s
> >> recent patches for metadata checksumming will detect even more
> >> non-hardware failure related problems, but they don=E2=80=99t offe=
r
> >> any recovery mechanism from the checksum failures.
> >>=20
> >> Metadata replication is another approach that can allow the
> >> filesystem to recover from the device read errors or
> >> checksumming errors at runtime and allow continued usage of the
> >> filesystem. In case of read failures or checksum failures,
> >> reading from the replica can allow live recovery of the lost
> >> metadata. This document gives some details about how the Ext4
> >> metadata could be replicated and used by the filesystem.
> >=20
> > Hi Aditya,
> >=20
> > While reading those three paragraphs I found the idea
> > interesting, however it would be just great to have more generic
> > solution for this problem. One, which comes immediately to mind,
> > is mirroring, however this will, of course, mirror all data, not
> > just metadata.
> >=20
> > But, we are already marking metadata-read bios (REQ_META), so it
> > has better priority. What about doing the same thing on write
> > side and having metadata-mirroring dm target which will mirror
> > only those ?
>=20
> While I like the idea of metadata mirroring, I share Lukaz's
> concern about the added complexity to the code.=20
>=20
> I've already done a bunch of experimentation with formatting the
> filesystem with flex_bg and storing the metadata in the first
> block group of every 256 block groups, and then allocating these
> block groups on flash via DM, and the other 255 block groups in
> the flex_bg are on RAID-6. =20

I've tried playing these sorts of metadata location constraining and
DM mapping games with XFS, too, and came to the conclusion it was
just too fragile to be considered for production use.  Not to
mention it's difficult to configure and maintain from an admin point
of view as well.

> This locates all of the static metadata in 1 of 256 block groups,
> and ext4 will already prefer to allocate the dynamic metadata in
> the first group of a flex_bg.
>=20
> It wouldn't be very difficult to set up the metadata groups as
> RAID-1 mirrors.=20
>
> > This way we'll get generic solution for all file systems, the
> > only thing that file system should do in order to take an
> > advantage of this is to mark its metadata writes accordingly.

This is similar to the conclusion I've come to for XFS - replicating
metadata inside the filesystem is simply too invasive and difficult
to implement sanely. To do correctly, the filesystem has to know
exactly what areas of the filesystem address space are independent
failure domains to make the correct decision as to where to place
replicated metadata. That's not simple to communicate to the
filesystem from the lower layers of the storage stack.

The solution I'm looking at is to give XFS a separate "metadata
device" (like we have support for an external log device) and
allocating all metadata on that device. It is a much simpler
solution from a code, maintenance and administration point of view,
and doesn't require a special new device mapper target that
replicates only metadata writes.  All it requires is:

> Right, there needs to be some way for the upper layer to know
> which copy was read, so that in case of a checksum failure it can
> request the other copy.  For RAID-5/6 it would need to know which
> disks were used for parity (if any) and then request parity
> reconstruction with a different disk until it matches the
> checksum.=20

=2E..this. And if it can't be done, we get a hard failure. I even
suspect the upper layer doesn't even need to care what copy it got
that was bad - if the underlying device has a concept of "primary
copy" for replication/recovery purposes, then all we need is a "read
alternate/secondary version" request, which could simply be a new
REQ_META_ALT request tag....

The use of an external device for metadata also allows admins to
easily separate data and metadata, grow the metadata space
separately to data space, put metadata on SSDs instead of spinning
disks, etc. IOWs, this approach kills about 5 XFS feature request
birds with the one stone. :)

There are many, many benefits to this style metadata replication and
error recovery, the least being that it is filesystem
independent....

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
