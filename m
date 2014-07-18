From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 00/24] e2fsprogs patchbomb 7/14, part 1
Date: Fri, 18 Jul 2014 15:52:00 -0700
Message-ID: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32850 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376AbaGRWwI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:52:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Since my last patch submission in May, I've been fuzzing both the
in-kernel ext4 driver, and e2fsck.  The main objective of this work
has been to determine if the kernel is capable of detecting invalid
mutations and returning -EIO without crashing; and whether or not
e2fsck can salvage the filesystem (or at least get it back to a
(self-defined) "clean" state) within a finite number of e2fsck runs.

I have a program "e2fuzz" (in patch 24) that formats and populates an
ext4 filesystem, randomly corrupts some number of metadata block
bytes, mounts the FS, tries to do some simple IO, unmounts, then
repeatedly runs fsck until either it says the FS is clean, we've run
too many times, or the output indicates that no progress is being
made.

The kernel, it turns out, seems to be able to handle problems with
grace.  Luckily, it at least has the privilege of simply shutting down
the filesystem.  e2fsck is not so fortunate -- upon detecting badness,
it has to decide a resolution and make it stick.  This exposed a
number of incorrect fixes, infinite loop opportunities, crashes, and
in a few cases, total filesystem destruction.  Lots of patches, though
I swear I'm _not_ paid by the patch. :)

The 24 patches following this mesage fix various problems in the more
mature parts of libext2fs and e2fsck.  Most (18) apply cleanly against
-maint, but a few of them also happen to touch things that only appear
in -next.  There are of course many more patches in the patch set, but
I'm breaking them up to avoid blasting people all at once.  The second
patchbomb will have about 35 fixes against the new features in the
-next branch.  I'll push it out in a few days, since I'm travelling
for OSCON.  The third patchbomb will be the same pile of "new"
features from May's patch series; there's about 20 or so of those.
They haven't changed since May.

The first patch is the e4defrag fix from a few days ago.  There are
three patches to debugfs that made it much easier to figure out what
was going on in the mutated filesystems.  Everything after that are
miscellaneous fixes that e2fuzz turned up.  There are two that I want
to call out specifically -- patch 10 solves the particular problem
that fsck needs to avoid touching corrupt metadata blocks if they're
cross-linked with critical FS metadata.  Patch 11 problem that hidden
allocations (think extra ETB/map blocks when extending a file) were
coming from the wrong block bitmap.  Patch 23 is unchanged from the
May patch set.

I've tested these e2fsprogs changes against the -next branch as of
7/13.  These days, I use several VMs, each with 32M-1G ramdisks to test
with; the test process is "misc/e2fuzz.sh -B <fuzz> -s <size>", where
fuzz is anything from 2 bytes to "0.1%" of metadata bytes.  In the
past month or so I've run about a million iterations of "-B 2" without
incident, and about 100,000 iterations of "-B 0.1%" without problems.
FS size was 256M and yes, some of the testing was done before the most
recent push to git.kernel.org.

Comments and questions are, as always, welcome.

--D
