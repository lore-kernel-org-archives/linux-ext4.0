From: Jeff Layton <jlayton@redhat.com>
Subject: [xfstests PATCH v3 5/5] btrfs: allow it to use $SCRATCH_LOGDEV
Date: Wed, 31 May 2017 09:08:20 -0400
Message-ID: <20170531130820.17634-6-jlayton@redhat.com>
References: <20170531130820.17634-1-jlayton@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
        ross.zwisler@linux.intel.com, corbet@lwn.net, dhowells@redhat.com,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-doc@vger.kernel.org
To: fstests@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170531130820.17634-1-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

With btrfs, we can't really put the log on a separate device. What we
can do however is mirror the metadata across two devices and make the
data striped across all devices. When we turn on dmerror then the
metadata can fall back to using the other mirror while the data errors
out.

Note that the current incarnation of btrfs has a fixed 64k stripe
width. If that ever changes or becomes settable, we may need to adjust
the amount of data that the test program writes.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 common/rc | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/common/rc b/common/rc
index 83765aacfb06..078270451b53 100644
--- a/common/rc
+++ b/common/rc
@@ -830,6 +830,8 @@ _scratch_mkfs()
 		;;
 	btrfs)
 		mkfs_cmd="$MKFS_BTRFS_PROG"
+		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+			mkfs_cmd="$mkfs_cmd -d raid0 -m raid1 $SCRATCH_LOGDEV"
 		mkfs_filter="cat"
 		;;
 	ext3)
-- 
2.9.4
