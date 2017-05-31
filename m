From: Jeff Layton <jlayton@redhat.com>
Subject: [xfstests PATCH v3 2/5] ext4: allow ext4 to use $SCRATCH_LOGDEV
Date: Wed, 31 May 2017 09:08:17 -0400
Message-ID: <20170531130820.17634-3-jlayton@redhat.com>
References: <20170531130820.17634-1-jlayton@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
        ross.zwisler@linux.intel.com, corbet@lwn.net, dhowells@redhat.com,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-doc@vger.kernel.org
To: fstests@vger.kernel.org
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20170531130820.17634-1-jlayton@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The writeback error handling test requires that you put the journal on a
separate device. This allows us to use dmerror to simulate data
writeback failure, without affecting the journal.

xfs already has infrastructure for this (a'la $SCRATCH_LOGDEV), so wire
up the ext4 code so that it can do the same thing when _scratch_mkfs is
called.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/common/rc b/common/rc
index 743df427c047..391d36f373cd 100644
--- a/common/rc
+++ b/common/rc
@@ -676,6 +676,9 @@ _scratch_mkfs_ext4()
 	local tmp=`mktemp`
 	local mkfs_status
 
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+	    $mkfs_cmd -O journal_dev $SCRATCH_LOGDEV && \
+	    mkfs_cmd="$mkfs_cmd -J device=$SCRATCH_LOGDEV"
 
 	_scratch_do_mkfs "$mkfs_cmd" "$mkfs_filter" $* 2>$tmp.mkfserr 1>$tmp.mkfsstd
 	mkfs_status=$?
-- 
2.9.4

