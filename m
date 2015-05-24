From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 0/9 linux-next] move dir_pages() to pagemap.h
Date: Sun, 24 May 2015 17:19:40 +0200
Message-ID: <1432480791-31396-1-git-send-email-fabf@skynet.be>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Fabian Frederick <fabf@skynet.be>, osd-dev@open-osd.org,
	linux-ext4@vger.kernel.org, linux-nilfs@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This small patchset declares dir_pages() in pagemap.h and
removes declarations in each filesystems.

Fabian Frederick (9):
  pagemap.h: declare dir_pages()
  nilfs2: remove dir_pages() declaration
  ufs: use dir_pages instead of ufs_dir_pages()
  fs/qnx6: remove dir_pages() declaration
  ext2: remove dir_pages() declaration
  minix: remove dir_pages() declaration
  exofs: remove dir_pages() declaration
  sysv: remove dir_pages() declaration
  fs/freevxfs/vxfs_lookup.c: remove dir_pages() declaration

 fs/exofs/dir.c            |  6 ------
 fs/ext2/dir.c             |  5 -----
 fs/freevxfs/vxfs_lookup.c |  7 -------
 fs/minix/dir.c            |  5 -----
 fs/nilfs2/dir.c           |  5 -----
 fs/qnx6/dir.c             |  5 -----
 fs/sysv/dir.c             |  5 -----
 fs/ufs/dir.c              | 13 ++++---------
 include/linux/pagemap.h   |  6 ++++++
 9 files changed, 10 insertions(+), 47 deletions(-)

-- 
2.4.1
