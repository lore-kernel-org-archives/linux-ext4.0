From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 00/25] e2fsprogs patchbomb 10/2013
Date: Fri, 18 Oct 2013 13:37:14 -0700
Message-ID: <20131018203714.GB6860@birch.djwong.org>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1310181512260.7649@localhost.localdomain>
 <20131018181343.GA19188@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44299 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3JRUhp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Oct 2013 16:37:45 -0400
Content-Disposition: inline
In-Reply-To: <20131018181343.GA19188@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 18, 2013 at 11:13:43AM -0700, Darrick J. Wong wrote:
> On Fri, Oct 18, 2013 at 03:13:57PM +0200, Luk=C3=A1=C5=A1 Czerner wro=
te:
> > On Thu, 17 Oct 2013, Darrick J. Wong wrote:
> >=20
> > > Date: Thu, 17 Oct 2013 21:48:54 -0700
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > To: tytso@mit.edu, darrick.wong@oracle.com
> > > Cc: linux-ext4@vger.kernel.org
> > > Subject: [PATCH v2 00/25] e2fsprogs patchbomb 10/2013
> >=20
> > I was going to review this, but could you please include the
> > information what changed since the last version of each patch (into
> > the patch itself) since it'll make the review much easier.
>=20
> I'm working on providing diffs against last time. :)

Ok, I've sent out emails about what's changed since last time.

Patches 1, 3-8, 15, 17-22, and 25 are new.

Patches 2, 9, 10-11, 16, and 23-24 have changes, as noted separately.

Patches 12-14 are unchanged.

--D
>=20
> --D
> >=20
> > Thanks!
> > -Lukas
> >=20
> > >=20
> > > Well, here we go again.  This is the same patchbomb from a couple=
 of
> > > weeks ago, minus the patches that Ted has already accepted, plus
> > > several fixes to resize2fs that weren't ready back then, and a fe=
w
> > > other fixes that migrated into the other patches.  This series is
> > > against -next.
> > >=20
> > > Ted, since you've accepted patches into -pu, do you want me to se=
nd
> > > patches against -pu as well?  Or put more bluntly, what are your
> > > thoughts about revert-and-replace of patches in -pu?  Patches 2, =
6,
> > > 11, 23, and 24 have changed significantly since 9/30.
> > >=20
> > > The first eight patches fix miscellaneous errors: #1 stops dirent
> > > iteration after we successfully link an inode into a directory.  =
#2
> > > fixes a bug that prohibited us from specifyinng a 64bit superbloc=
k
> > > number when opening an FS.  #3 prohibits running mke2fs with -E
> > > resize=3D and meta_bg.  #4 causes users of the badblocks code to =
reject
> > > 64bit block numbers.  #5 fixes shift overflows errors when punchi=
ng
> > > the end of non-extent files.  #6 refactors all the tests for whet=
her
> > > or not we need to set the LARGE_FILE feature (because someone goo=
fed
> > > earlier).  #7 fixes a problem wherein mkfs ignored non-4096 block=
size
> > > directives in the config file on a device larger than 2^32KB.  #8
> > > cleans up some code in debugfs.
> > >=20
> > > The next two patches fix some 64bit truncation bugs.
> > >=20
> > > Regarding next five patches, I turned on bigalloc and found a num=
ber
> > > of bugs relating to the fact that block_alloc_stats2() takes a bl=
ock
> > > number but operates on clusters.  I've fixed up all the allocatio=
n
> > > errors that I found.  I also decided to make the quota code use
> > > ext2fs_punch rather than try to correct its behavior wrt bigalloc=
=2E
> > > There was also a bug wherein the requirement that 64-bit bitmaps =
be
> > > enabled (via EXT2_FLAG_64BITS) for bigalloc filesystems.  There's=
 also
> > > a patch to reduce the e2fsck output verbosity when there are bloc=
k
> > > bitmap errors.  Note that #11 has been refactored significantly.
> > >=20
> > > The next patch provides the ability to toggle the 64bit feature o=
n any
> > > ext4 filesystem.
> > >=20
> > > The four patches after that fix various resize2fs bugs with bigal=
loc.
> > >=20
> > > The next two patches fix bugs with metadata_csum.  There's a patc=
h to
> > > fix up some code to test if checksums are enabled instead of a
> > > GDT_CSUM open-code.  Finally, there's a patch to resize2fs to rew=
rite
> > > checksums of inodes that were relocated.
> > >=20
> > > The next two patches add the ability to edit extended attributes =
and
> > > add a fuse2fs driver for e2fsprogs.  I admit that the xattr editi=
ng
> > > functions clash with the inline_data patches, though sadly, the i=
nline
> > > data patches don't provide an API to access EAs in a separate EA
> > > block.  The fuse driver should work with the latest versions of L=
inux
> > > fuse (2.9.2) and osxfuse (2.6.1).  I've been using the fuse drive=
r to
> > > test e2fsprogs functionality, which is how I came across most of =
the
> > > bugs fixed above.  Both of these patches (#23 and #24) have recei=
ved
> > > fixes since the 9/30 posting.
> > >=20
> > > The final patch adds my metadata checksum test program to the tes=
ts/
> > > directory, along with a new metadata_check target to run a quick
> > > check.  It includes substitute mount/umount commands for use with
> > > fuse2fs.
> > >=20
> > > For fuse2fs, I think it'd be useful to reintroduce journal replay=
 too.
> > > (Or cheat and call e2fsck -E journal_only...)  Also, fuse2fs does=
n't
> > > yet know how to read or write ACLs yet.
> > >=20
> > > I've tested these e2fsprogs changes against the -next branch as o=
f a
> > > few days ago.  These days, I use a 2GB ramdisk and a 20T "disk" I
> > > constructed out of dm-snapshot to test in an x64 VM.
> > >=20
> > > Comments and questions are, as always, welcome.
> > >=20
> > > --D
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-e=
xt4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
> > >=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
