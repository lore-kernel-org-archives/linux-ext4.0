From: Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH v2 7/7] Documentation: Correct s_umount state for freeze_fs/unfreeze_fs
Date: Thu,  8 Dec 2011 10:04:37 -0800
Message-ID: <1323367477-21685-8-git-send-email-kamal@canonical.com>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
Cc: linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Surbhi Palande <csurbhi@gmail.com>,
	Valerie Aurora <val@vaaconsulting.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>
To: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Matthew Wilcox <matthew@wil.cx>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1323367477-21685-1-git-send-email-kamal@canonical.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Valerie Aurora <val@vaaconsulting.com>

freeze_fs/unfreeze_fs ops are called with s_umount held for write, not read.

BugLink: https://bugs.launchpad.net/bugs/897421
Signed-off-by: Valerie Aurora <val@vaaconsulting.com>
Cc: Kamal Mostafa <kamal@canonical.com>
Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/filesystems/Locking |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index d819ba1..7e46a94 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -134,8 +134,8 @@ evict_inode:
 put_super:		write
 write_super:		read
 sync_fs:		read
-freeze_fs:		read
-unfreeze_fs:		read
+freeze_fs:		write
+unfreeze_fs:		write
 statfs:			maybe(read)	(see below)
 remount_fs:		write
 umount_begin:		no
-- 
1.7.5.4

