From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: add project quota mount options
Date: Mon, 11 Jul 2016 17:29:30 +0200
Message-ID: <20160711152930.GA9334@quack2.suse.cz>
References: <1467875386-28092-1-git-send-email-wangshilong1991@gmail.com>
 <b7ac32ea-b70d-0dc1-4b3e-f4f47dbad737@redhat.com>
 <20160708031002.GF19871@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Wang Shilong <wangshilong1991@gmail.com>,
	linux-ext4@vger.kernel.org, sihara@ddn.com, lixi@ddn.com,
	Wang Shilong <wshilong@ddn.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030735AbcGKP3n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jul 2016 11:29:43 -0400
Content-Disposition: inline
In-Reply-To: <20160708031002.GF19871@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 07-07-16 23:10:02, Ted Tso wrote:
> On Thu, Jul 07, 2016 at 11:06:10AM -0500, Eric Sandeen wrote:
> > > add prjquota, prjjquota, offprjjquota mount options
> > > for project quota.
> > > 
> > > These kind of mount options are used for old
> > > quota design, and we can use quotas like these
> > > way:
> > > 
> > >  # mkfs.ext4 /dev/sda
> > >  # mount /dev/sda -o prjquota /mnt/test
> > >  # quotacheck -p /mnt/test
> > >  # quotaon /mnt/test
> > > 
> > > This new mount options are also useful to unify
> > > some generic tests for xfs and ext4.
> 
> I think we want to really think about whether we want to support this
> mode.  Right now we have so *many* different permutations of quota
> that it's a whole lot more than "old" vs "new".  We have different
> versions of the quota files, "journaled quota", "first class quota"
> (where the quota files are hidden), etc.
> 
> For user quota and project quota, we do need to support the older
> quota systems, where usrquota and grpquota are in fact no-ops as far
> as the kernel is concerned, and are only used as a signal to some init
> files so they know how to run quotacheck and to the quotatools
> userspace tools, and where quotaon is used to pass the quota files to
> the file system using the quotactl system call.
> 
> Then there is the "journalled quota" system, where filenames are
> passed via the mount options usrjquota= and grpjquota= and where quota
> updates are done using data journal mode.  In this mode, at least in
> theory, you don't need to run quotacheck, so the fact that usrquota
> and grpquota mount options aren't present don't matter as far as the
> init scripts are concerned.  (Although if they get corrupted, good
> luck to you.)

When you use "journalled quota" mode, you still need to run quotacheck
after e2fsck fixes anything or when quota files get corrupted due to bugs,
HW errors, etc. Also quotaon(8) still uses mount options to determine on
which filesystems it should turn on quotas in this mode.

> With both of the above systems, there are three possible quota
> formats: old, v0, and v1.  I never remember the details of the
> differences between them, but IIRC there are differences in terms of
> the width (e.g., number of bits) used for the uids, gids, and number
> of blocks and files.

This is correct.

> OK, so if you look at the above, the test matrix is at six: journaled
> vs. non-journaled quota files, old vs v0 vs v1.  And this doesn't take
> into account whether or not project quota is enabled or not.  I propose
> that we ***not*** support any of this for project quota.
> 
> The mode that I *do* suggest supporting for project quota for ext4
> requires that you create a file system using -O quota, which enables
> "internal quotas", which is sometimes also referred to as "first class
> quotas".  In this mode, the quota files become hidden files so
> userspace can't screw them up or otherwise corrupt them.  The quota
> files are journalled, and are checked and consistency corrected by
> e2fsck.  This is *much* faster than having quotacheck do a separate
> user-space walk of the entire file system, which is slow, and subject
> to files being hidden underneath mountpoints, etc., etc.

Completely agreed. Old modes of operation for project quota were actually
originally implemented but we never merged that code exactly because we
didn't find legacy mode of operation useful for project quotas.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
