From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/9] remove i_alloc_sem V2
Date: Fri, 24 Jun 2011 14:29:39 -0400
Message-ID: <20110624182939.401012221@bombadil.infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com, jlbec@evilplan.org
To: viro@zeniv.linux.org.uk, tglx@linutronix.de
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

i_alloc_sem has always been a bit of an odd "lock".  It's the only remaining
rw_semaphore that can be released by a different thread than the one that
locked it, and it's use case in the core direct I/O code is more like a
counter given that the writers already have external serialization.

This series removes it in favour of a simpler counter scheme, thus getting
rid of the rw_semaphore non-owner APIs as requests by Thomas, while at the
same time shrinking the size of struct inode by 160 bytes on 64-bit systems.

The only nasty bit is that two filesystems (fat and ext4) have started
abusing the lock for their own purposes.  I've added a new rw_semaphore
to the fat node structures to keep the current behaviour, and merged a
patch from Jan Kara to remove the i_alloc_sem abuse from ext4.

changes from v1:
 - update the fat patch description
 - replace my ext4 truncate_lock patch with Jan's rewrite of ext4_page_mkwrite
 - do not use wait_on_bit, but replace it with an opencoded hashed waitqueue
 - rename inode_dio_wake to inode_dio_done
 - add kerneldoc comments for inode_dio_wait and inode_dio_done
 - simplify the blockdev_direct_IO prototype
 - move the i_dio_count decrement into the ->end_io handler if present to
   make i_dio_count useful for filesystems delaying AIO completion
 - reorder the patch series - patches 1 to 5 are the meat, the rest is
   additonal tidyups in that area required for future improvements
