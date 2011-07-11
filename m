From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/2] always default to issue cache flushes
Date: Mon, 11 Jul 2011 14:25:33 -0400
Message-ID: <20110711182532.GA12099@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jeffm@suse.com, chris.mason@oracle.com, jack@suse.cz,
	reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: viro@zeniv.linux.org.uk
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

It's bad enough that we still have filesystems who can't deal with
the volatile write caches present on all modern consumer disks, but
let's at least make use of this feature where present instead of
playing fast and lose with users data.  Switch ext3 and reiserfs
to the same default already applied in btrfs, ext4, gfs2, hfsplus,
nilfs2 and XFS.
