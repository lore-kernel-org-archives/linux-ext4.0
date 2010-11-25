From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] exofs: simple fsync race fix
Date: Thu, 25 Nov 2010 12:52:08 +0200
Message-ID: <4CEE3FD8.6080202@panasas.com>
References: <20101125074909.GA4160@amd> <4CEE2C2E.4010003@panasas.com> <20101125100603.GA3164@amd> <4CEE3F9F.9070108@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
	"Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Bob Copeland <me@bobcopeland.com>,
	reiserfs-devel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Evgeniy Dushistov <dushistov@mail.ru>, Jan Kara <jack@suse.cz>
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CEE3F9F.9070108@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Nick Piggin <npiggin@kernel.dk>

It is incorrect to test inode dirty bits without participating in the inode
writeback protocol. Inode writeback sets I_SYNC and clears I_DIRTY_?, then
writes out the particular bits, then clears I_SYNC when it is done. BTW. it
may not completely write all pages out, so I_DIRTY_PAGES would get set
again.

This is a standard pattern used throughout the kernel's writeback caches
(I_SYNC ~= I_WRITEBACK, if that makes it clearer).

And so it is not possible to determine an inode's dirty status just by
checking I_DIRTY bits. Especially not for the purpose of data integrity
syncs.

Missing the check for these bits means that fsync can complete while
writeback to the inode is underway. Inode writeback functions get this
right, so call into them rather than try to shortcut things by testing
dirty state improperly.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/exofs/file.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/exofs/file.c b/fs/exofs/file.c
index b905c79..4c0d6ba 100644
--- a/fs/exofs/file.c
+++ b/fs/exofs/file.c
@@ -48,11 +48,6 @@ static int exofs_file_fsync(struct file *filp, int datasync)
 	struct inode *inode = filp->f_mapping->host;
 	struct super_block *sb;
 
-	if (!(inode->i_state & I_DIRTY))
-		return 0;
-	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
-		return 0;
-
 	ret = sync_inode_metadata(inode, 1);
 
 	/* This is a good place to write the sb */
-- 
1.7.2.3
