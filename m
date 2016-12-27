From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 00/54] block: support multipage bvec
Date: Tue, 27 Dec 2016 23:55:49 +0800
Message-ID: <1482854250-13481-1-git-send-email-tom.leiming@gmail.com>
Cc: linux-block@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Ming Lei <tom.leiming@gmail.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bart Van Assche <bart.vanassche@sandisk.com>,
	Chaitanya Kulkarni <chaitanya.kulkarni@hgst.com>,
	cluster-devel@redhat.com (open list:GFS2 FILE SYSTEM),
	Damien Le Moal <damien.lemoal@hgst.com>,
	Dan Williams <dan.j.williams@intel.com>,
	dm-devel@redhat.com (open list:DEVICE-MAPPER  (LVM)),
	drbd-dev@lists.linbit.com (open list:DRBD DRIVER),
	Eric Wheeler <git@linux.ewheeler.net>,
	Guoqing Jiang <gqjiang@suse.com>,
	Hannes Reinecke <hare@suse.com>,
	Hannes Reinecke <hare@suse.de>,
	Jiri Kosina <jkosina@suse.cz>,
	Joe Perches <joe@perches.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Johannes Thumshirn <jthumshirn@suse.de>,
	Kent Overstreet <kent.overstreet@gmail.com>,
	linux-bcache@vger.kernel.org (
To: Jens Axboe <axboe@fb.com>,
	linux-kernel@vger.kernel.org
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Hi,

This patchset brings multipage bvec into block layer. Basic
xfstests(-a auto) over virtio-blk/virtio-scsi have been run
and no regression is found, so it should be good enough
to show the approach now, and any comments are welcome!

1) what is multipage bvec?

Multipage bvecs means that one 'struct bio_bvec' can hold
multiple pages which are physically contiguous instead
of one single page used in linux kernel for long time.

2) why is multipage bvec introduced?

Kent proposed the idea[1] first. 

As system's RAM becomes much bigger than before, and 
at the same time huge page, transparent huge page and
memory compaction are widely used, it is a bit easy now
to see physically contiguous pages from fs in I/O.
On the other hand, from block layer's view, it isn't
necessary to store intermediate pages into bvec, and
it is enough to just store the physicallly contiguous
'segment'.

Also huge pages are being brought to filesystem[2], we
can do IO a hugepage a time[3], requires that one bio can
transfer at least one huge page one time. Turns out it isn't
flexiable to change BIO_MAX_PAGES simply[3]. Multipage bvec
can fit in this case very well.

With multipage bvec:

- bio size can be increased and it should improve some
high-bandwidth IO case in theory[4].

- Inside block layer, both bio splitting and sg map can
become more efficient than before by just traversing the
physically contiguous 'segment' instead of each page.

- there is possibility in future to improve memory footprint
of bvecs usage. 

3) how is multipage bvec implemented in this patchset?

The 1st 9 patches comment on some special cases. As we saw,
most of cases are found as safe for multipage bvec,
only fs/buffer, MD and btrfs need to deal with. Both fs/buffer
and btrfs are dealt with in the following patches based on some
new block APIs for multipage bvec. 

Given a little more work is involved to cleanup MD, this patchset
introduces QUEUE_FLAG_NO_MP for them, and this component can still
see/use singlepage bvec. In the future, once the cleanup is done, the
flag can be killed.

The 2nd part(23 ~ 54) implements multipage bvec in block:

- put all tricks into bvec/bio/rq iterators, and as far as
drivers and fs use these standard iterators, they are happy
with multipage bvec

- bio_for_each_segment_all() changes
this helper pass pointer of each bvec directly to user, and
it has to be changed. Two new helpers(bio_for_each_segment_all_sp()
and bio_for_each_segment_all_mp()) are introduced. 

Also convert current bio_for_each_segment_all() into the
above two.

- bio_clone() changes
At default bio_clone still clones one new bio in multipage bvec
way. Also single page version of bio_clone() is introduced
for some special cases, such as only single page bvec is used
for the new cloned bio(bio bounce, ...)

- btrfs cleanup
just three patches for avoiding direct access to bvec table.

These patches can be found in the following git tree:

	https://github.com/ming1/linux/commits/mp-bvec-0.6-v4.10-rc

Thanks Christoph for looking at the early version and providing
very good suggestions, such as: introduce bio_init_with_vec_table(),
remove another unnecessary helpers for cleanup and so on.

TODO:
	- cleanup direct access to bvec table for MD

V1:
	- against v4.10-rc1 and some cleanup in V0 are in -linus already
	- handle queue_virt_boundary() in mp bvec change and make NVMe happy
	- further BTRFS cleanup
	- remove QUEUE_FLAG_SPLIT_MP
	- rename for two new helpers of bio_for_each_segment_all()
	- fix bounce convertion
	- address comments in V0

[1], http://marc.info/?l=linux-kernel&m=141680246629547&w=2
[2], https://patchwork.kernel.org/patch/9451523/
[3], http://marc.info/?t=147735447100001&r=1&w=2
[4], http://marc.info/?l=linux-mm&m=147745525801433&w=2


Ming Lei (54):
  block: drbd: comment on direct access bvec table
  block: loop: comment on direct access to bvec table
  kernel/power/swap.c: comment on direct access to bvec table
  mm: page_io.c: comment on direct access to bvec table
  fs/buffer: comment on direct access to bvec table
  f2fs: f2fs_read_end_io: comment on direct access to bvec table
  bcache: comment on direct access to bvec table
  block: comment on bio_alloc_pages()
  block: comment on bio_iov_iter_get_pages()
  block: introduce flag QUEUE_FLAG_NO_MP
  md: set NO_MP for request queue of md
  dm: limit the max bio size as BIO_MAX_PAGES * PAGE_SIZE
  block: comments on bio_for_each_segment[_all]
  block: introduce multipage/single page bvec helpers
  block: implement sp version of bvec iterator helpers
  block: introduce bio_for_each_segment_mp()
  block: introduce bio_clone_sp()
  bvec_iter: introduce BVEC_ITER_ALL_INIT
  block: bounce: avoid direct access to bvec table
  block: bounce: don't access bio->bi_io_vec in copy_to_high_bio_irq
  block: introduce bio_can_convert_to_sp()
  block: bounce: convert multipage bvecs into singlepage
  bcache: handle bio_clone() & bvec updating for multipage bvecs
  blk-merge: compute bio->bi_seg_front_size efficiently
  block: blk-merge: try to make front segments in full size
  block: blk-merge: remove unnecessary check
  block: use bio_for_each_segment_mp() to compute segments count
  block: use bio_for_each_segment_mp() to map sg
  block: introduce bvec_for_each_sp_bvec()
  block: bio: introduce single/multi page version of
    bio_for_each_segment_all()
  block: introduce bio_segments_all()
  block: introduce bvec_get_last_sp()
  block: deal with dirtying pages for multipage bvec
  block: convert to singe/multi page version of
    bio_for_each_segment_all()
  bcache: convert to bio_for_each_segment_all_sp()
  dm-crypt: don't clear bvec->bv_page in crypt_free_buffer_pages()
  dm-crypt: convert to bio_for_each_segment_all_sp()
  md/raid1.c: convert to bio_for_each_segment_all_sp()
  fs/mpage: convert to bio_for_each_segment_all_sp()
  fs/direct-io: convert to bio_for_each_segment_all_sp()
  ext4: convert to bio_for_each_segment_all_sp()
  xfs: convert to bio_for_each_segment_all_sp()
  gfs2: convert to bio_for_each_segment_all_sp()
  f2fs: convert to bio_for_each_segment_all_sp()
  exofs: convert to bio_for_each_segment_all_sp()
  fs: crypto: convert to bio_for_each_segment_all_sp()
  fs/btrfs: convert to bio_for_each_segment_all_sp()
  fs/block_dev.c: convert to bio_for_each_segment_all_sp()
  fs/iomap.c: convert to bio_for_each_segment_all_sp()
  fs/buffer.c: use bvec iterator to truncate the bio
  btrfs: avoid access to .bi_vcnt directly
  btrfs: use bvec_get_last_sp to get the last singlepage bvec
  btrfs: comment on direct access bvec table
  block: enable multipage bvecs

 block/bio.c                      | 110 +++++++++++++++----
 block/blk-merge.c                | 227 +++++++++++++++++++++++++++++++--------
 block/blk-zoned.c                |   5 +-
 block/bounce.c                   |  75 +++++++++----
 drivers/block/drbd/drbd_bitmap.c |   1 +
 drivers/block/loop.c             |   5 +
 drivers/md/bcache/btree.c        |   4 +-
 drivers/md/bcache/debug.c        |  30 +++++-
 drivers/md/bcache/super.c        |   6 ++
 drivers/md/bcache/util.c         |   7 ++
 drivers/md/dm-crypt.c            |   4 +-
 drivers/md/dm.c                  |  11 +-
 drivers/md/md.c                  |  12 +++
 drivers/md/raid1.c               |   3 +-
 fs/block_dev.c                   |   6 +-
 fs/btrfs/check-integrity.c       |  12 ++-
 fs/btrfs/compression.c           |  12 ++-
 fs/btrfs/disk-io.c               |   3 +-
 fs/btrfs/extent_io.c             |  26 +++--
 fs/btrfs/extent_io.h             |   1 +
 fs/btrfs/file-item.c             |   6 +-
 fs/btrfs/inode.c                 |  34 ++++--
 fs/btrfs/raid56.c                |   6 +-
 fs/buffer.c                      |  24 +++--
 fs/crypto/crypto.c               |   3 +-
 fs/direct-io.c                   |   4 +-
 fs/exofs/ore.c                   |   3 +-
 fs/exofs/ore_raid.c              |   3 +-
 fs/ext4/page-io.c                |   3 +-
 fs/ext4/readpage.c               |   3 +-
 fs/f2fs/data.c                   |  13 ++-
 fs/gfs2/lops.c                   |   3 +-
 fs/gfs2/meta_io.c                |   3 +-
 fs/iomap.c                       |   3 +-
 fs/mpage.c                       |   3 +-
 fs/xfs/xfs_aops.c                |   3 +-
 include/linux/bio.h              | 164 ++++++++++++++++++++++++++--
 include/linux/blk_types.h        |   6 ++
 include/linux/blkdev.h           |   2 +
 include/linux/bvec.h             | 138 ++++++++++++++++++++++--
 kernel/power/swap.c              |   2 +
 mm/page_io.c                     |   2 +
 42 files changed, 829 insertions(+), 162 deletions(-)

-- 
2.7.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
