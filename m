From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Ext4: deadlock occurs when running fsstress and ENOSPC errors
 are seen.
Date: Tue, 15 Apr 2014 08:47:43 -0400
Message-ID: <20140415124743.GD3403@thunk.org>
References: <CADDb1s2RvN_S+abFXCe4ZhZPKZgP_PiocJdpiLzRC_Se5sgVVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, darrick.wong@oracle.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Namjae Jeon <linkinjeon@gmail.com>
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CADDb1s2RvN_S+abFXCe4ZhZPKZgP_PiocJdpiLzRC_Se5sgVVg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 15, 2014 at 01:24:26PM +0530, Amit Sahrawat wrote:
> Initially in normal write path, when the disk was almost full =E2=80=93=
 we got
> hung for the =E2=80=98sync=E2=80=99 because the flusher (which is bus=
y in the
> writepages is not responding). Before the hung task, we also found th=
e
> logs like:
>=20
> EXT4-fs error (device sda1): ext4_mb_generate_buddy:742: group 1493, =
0
> clusters in bitmap, 58339 in gd
> EXT4-fs error (device sda1): ext4_mb_generate_buddy:742: group 1000, =
0
> clusters in bitmap, 3 in gd
> EXT4-fs error (device sda1): ext4_mb_generate_buddy:742: group 1425, =
0
> clusters in bitmap, 1 in gd

These errors indicate that the several block groups contain have
corrupt block bitmap: block group #1493, #1000, and #1425.  The fact
that there are 0 free blocks/clusters in the bitmap indicate that the
bitmap was all zero's, which could be the potential cause of the
corruption.

The other thing which is funny is the number of free blocks/clusters
being greater than 32768 in block group #1493.  Assuming a 4k page
size, that shouldn't be possible.  Can you send the output of
"dumpe2fs -h /dev/sdXX" so we can take a look at the file system parame=
ters?

How much before the hung task did you see these messages?  I normally
recommend that the file system be set up to either panic the system,
or force the file system to be remounted read/only when EXT4-fs error
messages are reported, since that means that the file system is
corrupted, and further operaion can cause more data to be lost.

> JBD2: Spotted dirty metadata buffer (dev =3D sda1, blocknr =3D 0). Th=
ere's
> a risk of filesystem corruption in case of system crash.
> JBD2: Spotted dirty metadata buffer (dev =3D sda1, blocknr =3D 0). Th=
ere's
> a risk of filesystem corruption in case of system crash.
>=20
> EXT4-fs (sda1): error count: 58
> EXT4-fs (sda1): initial error at 607: ext4_mb_generate_buddy:742
> EXT4-fs (sda1): last error at 58: ext4_mb_generate_buddy:742

The "607" and "58" in the "at 607" and "at 58" are normally supposed
to be a unix time_t value.  That is, it's normally a number like:
1397564866, and it can be decoded via:=20

% date -d @1397564866
Tue Apr 15 08:27:46 EDT 2014

The fact that these numbers are numerically so small means that the
time wasn't set correctly on your system.  Was this a test system
running under kvm without a proper real-time clock?

> When we analysed the problem, it occurred from the writepages path in=
 ext4.
> This is because of the difference in the free blocks reported by
> cluster bitmap and the number of free blocks reported by group
> descriptor.

Yes, indicating that the file system was corrupt.

> During ext4_fill_super, ext4 calculates the number of free blocks by
> reading all the descriptors in function ext4_count_free_clusters and
> store it in percpu counter s_freeclusters_counter.
> ext4_count_free_clusters:
> desc_count =3D 0;
> for (i =3D 0; i < ngroups; i++) {
> gdp =3D ext4_get_group_desc(sb, i, NULL);
> if (!gdp)
> continue;
> desc_count +=3D ext4_free_group_clusters(sb, gdp);
> }
> return desc_count;
>=20
> During writebegin call, ext4 checks this s_freeclusters_counter
> counter to know if there are free blocks present or not.
> When the free blocks reported by group descriptor are greater than th=
e
> actual free blocks reported by bitmap, a call to writebegin could
> still succeed even if the free blocks represented by bitmaps are 0.

Yes.  We used to have code that would optionally read every single
bitmap, and verify that the descriptor counts match the values in the
bitmap.  However, that was expensive, and wasn't a full check of all
possible file system inconsistencies that could lead to data loss.  So
we ultimately removed this code.  If the file system is potentially
corrupt, it is the system administrator's responsibility to force an
fsck run to make sure the file system data structures are consistent.

> When searching for the relevant problem which occurs in this path. We
> got the patch-set from =E2=80=98Darrick=E2=80=99 which revolves aroun=
d this problem.
> ext4: error out if verifying the block bitmap fails
> ext4: fix type declaration of ext4_validate_block_bitmap
> ext4: mark block group as corrupt on block bitmap error
> ext4: mark block group as corrupt on inode bitmap error
> ext4: mark group corrupt on group descriptor checksum
> ext4: don't count free clusters from a corrupt block group
>=20
> After adopting the patch-set and performing verification on the
> similar setup, we ran =E2=80=98fsstress=E2=80=99. But now it is resul=
ting in hang at
> different points.
>=20
> In the current logs we got:
> EXT4-fs error (device sdb1): ext4_mb_generate_buddy:743: group 1,
> 20480 clusters in bitmap, 25443 in gd; block bitmap corrupt.
> JBD2: Spotted dirty metadata buffer (dev =3D sdb1, blocknr =3D 0). Th=
ere's
> a risk of filesystem corruption in case of system crash.

OK, what version of the kernel are you using?  The patches that you
reference above have been in the upstream kernel since 3.12, so I'm
assuming you're not using the latest upstream kernel, but rather an
older kernel with some patches applied.  Hmmm, skipping ahead:

> Kernel Version: 3.8
> Test command:
> fsstress -p 10 -n 100 -l 100 -d /mnt/test_dir

There is clearly either some kernel bug or hardware problem which is
causing the file system corruption.  Given that you are using a much
older kernel, it's quite likely that there is some bug that has been
fixed in a later version of the kernel (although we can't really rule
out a hardware problem without know much more about your setup).

Unfortunately, there has been a *large* number of changes since
version 3.8, and I can't remember all of the changes and bug fixes
that we might have made in the past year or more (v3.8 dates from
March 2013).

Something that might be helpful is for you to use xfstests.  That's a
much more thorough set of tests which we've been using so if you must
use an antique version of the kernel, that will probably be a much
better set of tests.  It includes fsstress, and much more besides.
More importantly, there are times when fixes are identified by the
xfstest failure that has gotten fixed up in the commit logs.  So that
might help you find the bug fix that you need to backport.

=46or your convenience, there is a simple test framework that makes it
relatively easy to build and run xfstests under KVM.  You can find it
here:

	git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git

See the documentation found at:

	https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/tree/README

for more details.

I hope this helps,

						- Ted
