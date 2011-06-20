From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/8] remove i_alloc_sem
Date: Mon, 20 Jun 2011 16:15:33 -0400
Message-ID: <20110620201533.847236272@bombadil.infradead.org>
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
to their filesystem-specific inode structures to keep the current behaviour,
but I suspect the maintainers might have smarted ideas to archive the same
goal.
