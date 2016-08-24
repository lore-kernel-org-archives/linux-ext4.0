From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 0/6 linux-next] ext4: fix extent leaking and clean-up
Date: Wed, 24 Aug 2016 22:03:14 +0200
Message-ID: <1472069000-18897-1-git-send-email-fabf@skynet.be>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        fabf@skynet.be
To: tytso@mit.edu, Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Last patch of this small patchset fixes an extent path memory leak.
The rest is some clean-up.

Fabian Frederick (6):
  ext4: avoid EXT4_INODE_EXTENTS double checking
  ext4: remove unneeded test in ext4_alloc_file_blocks()
  ext4: create EXT4_MAX_BLOCKS() macro
  ext4: use bool for check in ext4_ext_space_()
  ext4: remove unused definition
  ext4: fix memory leak in ext4_insert_range()

 fs/ext4/ext4.h    |  3 +++
 fs/ext4/extents.c | 70 ++++++++++++++++++++-----------------------------------
 fs/ext4/file.c    |  3 +--
 fs/ext4/ioctl.c   |  2 --
 4 files changed, 29 insertions(+), 49 deletions(-)

-- 
2.8.1
