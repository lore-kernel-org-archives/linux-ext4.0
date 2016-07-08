From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add project quota mount options
Date: Thu, 7 Jul 2016 23:10:02 -0400
Message-ID: <20160708031002.GF19871@thunk.org>
References: <1467875386-28092-1-git-send-email-wangshilong1991@gmail.com>
 <b7ac32ea-b70d-0dc1-4b3e-f4f47dbad737@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wang Shilong <wangshilong1991@gmail.com>,
	linux-ext4@vger.kernel.org, sihara@ddn.com, lixi@ddn.com,
	Wang Shilong <wshilong@ddn.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40562 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbcGHDKI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Jul 2016 23:10:08 -0400
Content-Disposition: inline
In-Reply-To: <b7ac32ea-b70d-0dc1-4b3e-f4f47dbad737@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 07, 2016 at 11:06:10AM -0500, Eric Sandeen wrote:
> > add prjquota, prjjquota, offprjjquota mount options
> > for project quota.
> > 
> > These kind of mount options are used for old
> > quota design, and we can use quotas like these
> > way:
> > 
> >  # mkfs.ext4 /dev/sda
> >  # mount /dev/sda -o prjquota /mnt/test
> >  # quotacheck -p /mnt/test
> >  # quotaon /mnt/test
> > 
> > This new mount options are also useful to unify
> > some generic tests for xfs and ext4.

I think we want to really think about whether we want to support this
mode.  Right now we have so *many* different permutations of quota
that it's a whole lot more than "old" vs "new".  We have different
versions of the quota files, "journaled quota", "first class quota"
(where the quota files are hidden), etc.

For user quota and project quota, we do need to support the older
quota systems, where usrquota and grpquota are in fact no-ops as far
as the kernel is concerned, and are only used as a signal to some init
files so they know how to run quotacheck and to the quotatools
userspace tools, and where quotaon is used to pass the quota files to
the file system using the quotactl system call.

Then there is the "journalled quota" system, where filenames are
passed via the mount options usrjquota= and grpjquota= and where quota
updates are done using data journal mode.  In this mode, at least in
theory, you don't need to run quotacheck, so the fact that usrquota
and grpquota mount options aren't present don't matter as far as the
init scripts are concerned.  (Although if they get corrupted, good
luck to you.)

With both of the above systems, there are three possible quota
formats: old, v0, and v1.  I never remember the details of the
differences between them, but IIRC there are differences in terms of
the width (e.g., number of bits) used for the uids, gids, and number
of blocks and files.

OK, so if you look at the above, the test matrix is at six: journaled
vs. non-journaled quota files, old vs v0 vs v1.  And this doesn't take
into account whether or not project quota is enabled or not.  I propose
that we ***not*** support any of this for project quota.


The mode that I *do* suggest supporting for project quota for ext4
requires that you create a file system using -O quota, which enables
"internal quotas", which is sometimes also referred to as "first class
quotas".  In this mode, the quota files become hidden files so
userspace can't screw them up or otherwise corrupt them.  The quota
files are journalled, and are checked and consistency corrected by
e2fsck.  This is *much* faster than having quotacheck do a separate
user-space walk of the entire file system, which is slow, and subject
to files being hidden underneath mountpoints, etc., etc.

This mode is supported by quotatools, so it's not a matter of "xfs"
versus "vfs/quotatools".  It's just a question of a different way of
setting up file system.  And for ext4, it means "don't use any magic
mount option", and creating the file system with "mke2fs -O
project,quota".

Yes, for the sake of those poor, unfortunate souls who have to support
RHEL 6 (really, you couldn't pay me enough :-), it probably makes
sense to support the legacy style quota system using either the
usrquota/grpquota mount options, and so it makes sense for xfstests to
user the old-style aquota.user files that can be messed with by
confused userspace utilities, and which are dog-slow to check becuase
a separate quotacheck run is required.

But RHEL 6 doesn't have project quota, and so I don't see any reason
to try to support the legacy quota setup for project quota.  Yes, we
still want to test the quotatools VFS interfaces, and that means using
quotatools binaries --- but it doesn't follow from that choice that we
have to support the ancient ways of storing the quota files as
user-visible files, or using the ancient mount options which are just
horrible hacks to keep the old enterprise linux initscripts from
breaking.

Does this make sense?

							- Ted
