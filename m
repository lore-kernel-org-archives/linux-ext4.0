From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/6 v4] scope GFP_NOFS api
Date: Mon,  6 Feb 2017 15:07:12 +0100
Message-ID: <20170206140718.16222-1-mhocko@kernel.org>
Cc: <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
        djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>,
        Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-AlSwsSmVLrQ@public.gmane.org>,
        Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        logfs-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
        linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
        linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Brian Foster <bfoster-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
        Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>,
        "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
        <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Hi,
I have posted the previous version here [1]. There are no real changes
in the implementation since then. Few acks added and one new user of
memalloc_noio_flags (in alloc_contig_range) converted. I have decided
to drop the last two ext4 related patches. One of them will be picked up
by Ted [2] and the other one will probably need more time to settle down.
I believe it is OK as is but let's not block the whole thing just because
of it.

There didn't seem to be any real objections and so I think we should
go and merge this to mmotm tree and target the next merge window. The
risk of regressions is really small because we do not remove any real
GFP_NOFS users yet.

I hope to get ext4 parts resolved in the follow up patches as well as
pull other filesystems in. There is still a lot work to do but having
the infrastructure in place should be very useful already.

The patchset is based on next-20170206

Diffstat says
 fs/jbd2/journal.c         |  7 +++++++
 fs/jbd2/transaction.c     | 11 +++++++++++
 fs/xfs/kmem.c             | 12 ++++++------
 fs/xfs/kmem.h             |  2 +-
 fs/xfs/libxfs/xfs_btree.c |  2 +-
 fs/xfs/xfs_aops.c         |  6 +++---
 fs/xfs/xfs_buf.c          |  8 ++++----
 fs/xfs/xfs_trans.c        | 12 ++++++------
 include/linux/gfp.h       | 18 +++++++++++++++++-
 include/linux/jbd2.h      |  2 ++
 include/linux/sched.h     | 32 ++++++++++++++++++++++++++------
 kernel/locking/lockdep.c  |  6 +++++-
 lib/radix-tree.c          |  2 ++
 mm/page_alloc.c           | 10 ++++++----
 mm/vmscan.c               |  6 +++---
 15 files changed, 100 insertions(+), 36 deletions(-)

Shortlog:
Michal Hocko (6):
      lockdep: allow to disable reclaim lockup detection
      xfs: abstract PF_FSTRANS to PF_MEMALLOC_NOFS
      mm: introduce memalloc_nofs_{save,restore} API
      xfs: use memalloc_nofs_{save,restore} instead of memalloc_noio*
      jbd2: mark the transaction context with the scope GFP_NOFS context
      jbd2: make the whole kjournald2 kthread NOFS safe

[1] http://lkml.kernel.org/r/20170106141107.23953-1-mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[2] http://lkml.kernel.org/r/20170117030118.727jqyamjhojzajb-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
