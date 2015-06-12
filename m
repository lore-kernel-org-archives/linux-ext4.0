From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET block/for-4.2/writeback] ext4: implement cgroup writeback support
Date: Fri, 12 Jun 2015 17:02:21 -0500
Message-ID: <1434146543-26358-1-git-send-email-tj@kernel.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org,
	adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Hello,

This patchset implements cgroup writeback support for ext4, which is
enabled for writeback and ordered data modes.  This patchset contains
the following two patches.

 0001-ext4-replace-ext4_io_submit-io_op-with-io_wbc.patch
 0002-ext4-implement-cgroup-writeback-support.patch

0001 is a prep patch which replaces io_submit->io_op w/ ->io_wbc.
0002 implements cgroup writeback support.

This patchset is on top of

 [1] block/for-4.2/writeback
+[2] [PATCHSET] cgroup, writeback: misc updates for cgroup writeback support

and available on in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-writeback-ext4

diffstat follows.  Thanks.

 fs/ext4/ext4.h    |    2 +-
 fs/ext4/page-io.c |    8 ++++++--
 fs/ext4/super.c   |    2 ++
 3 files changed, 9 insertions(+), 3 deletions(-)

--
tejun

[1] git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-4.2/writeback
[2] http://lkml.kernel.org/g/1434146254-26220-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
