From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/6 v5] fiemap: introduce DATA_COMPRESSED and PHYS_LENGTH flags
Date: Wed, 30 Jul 2014 19:18:29 +0200
Message-ID: <cover.1406739708.git.dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>, adilger@dilger.ca,
	hch@infradead.org, mfasheh@suse.com, viro@zeniv.linux.org.uk,
	david@fromorbit.com, xfs@oss.sgi.com, linux-nilfs@vger.kernel.org,
	ocfs2-devel@oss.oracle.com, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The original FIEMAP patch did not define the bits, btrfs would like to use a
flag for compressed extents. The PHYS_LENGTH flag emerged during patchset
revisions to keep backward compatibility and flexible fiemap API.

Currently, the 'filefrag' utility has no way to recognize and denote a
compressed extent. As implemented in btrfs right now, the compression step
splits a big extent into smaller chunks and this is reported as a heavily
fragmented file. Adding the flag to filefrag will at least give some
explanation why, this has been confusing users for some time already.

fiemap_fill_next_extent is extended and takes argument to fill the physical
length.

V5:
Physical length is by default undefined. Btrfs use of compressed flag was
enhanced to reflect the fiemap changes. Patches reordered so the generic fiemap
go first.

V4:
The physical length is always set and equal to logical, or different and
then sets the COMPRESSED flag.
fiemap_extent::fe_length renamed to fe_logi_length

V3:
Based on feedback from Andreas, implement #1 from V2, current users of
fiemap_fill_next_extent (fs/, ext4, gfs2, ocfs2, nilfs2, xfs) updated
accordingly, no functional change.

V2:
Based on feedback from Andreas, the fiemap_extent is now able to hold the
physical extent length, to be filled by the filesystem callback.

1) extend fiemap_fill_next_extent to take phys_length and update all
   users (ext4, gfs2, ocfs2, nilfs2, xfs)


David Sterba (6):
  fiemap: fix comment at EXTENT_DATA_ENCRYPTED
  fiemap: add fe_phys_length and EXTENT_PHYS_LENGTH flag
  fiemap: add FIEMAP_EXTENT_DATA_COMPRESSED flag
  Documentation/fiemap: Document DATA_COMPRESSED and PHYS_LENGTH flags
  fiemap: rename fe_length to fe_logi_length
  btrfs: set FIEMAP_EXTENT_DATA_COMPRESSED for compressed extents

 Documentation/filesystems/fiemap.txt | 24 ++++++++++++++++++++----
 fs/btrfs/extent_io.c                 | 11 ++++++++---
 fs/ext4/extents.c                    |  4 ++--
 fs/ext4/inline.c                     |  2 +-
 fs/gfs2/inode.c                      |  2 +-
 fs/ioctl.c                           | 21 ++++++++++++++-------
 fs/nilfs2/inode.c                    |  8 +++++---
 fs/ocfs2/extent_map.c                |  4 ++--
 fs/xfs/xfs_iops.c                    |  2 +-
 include/linux/fs.h                   |  2 +-
 include/uapi/linux/fiemap.h          | 16 +++++++++++++---
 11 files changed, 68 insertions(+), 28 deletions(-)

-- 
1.8.4.5

