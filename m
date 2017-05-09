From: Jeff Layton <jlayton@redhat.com>
Subject: [xfstests PATCH v2 2/3] ext4: allow ext4 to use
	$SCRATCH_LOGDEV
Date: Tue,  9 May 2017 12:12:44 -0400
Message-ID: <20170509161245.29908-3-jlayton@redhat.com>
References: <20170509161245.29908-1-jlayton@redhat.com>
Cc: axboe@kernel.dk, tytso@mit.edu, mawilcox@microsoft.com, neilb@suse.de,
	corbet@lwn.net, josef@toxicpanda.com, dhowells@redhat.com,
	clm@fb.com, bo.li.liu@oracle.com, viro@zeniv.linux.org.uk,
	jack@suse.com, akpm@linux-foundation.org,
	ross.zwisler@linux.intel.com, hubcap@omnibond.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net,
	linux-xfs@vger.kernel.org, cluster-devel@redhat.com,
	linux-f2fs-devel@lists.sourceforge.net,
	v9fs-developer@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	linux-block@vger.kernel.org, fstests@vger.kernel.org
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20170509161245.29908-1-jlayton@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

The writeback error handling test requires that you put the journal on a
separate device. This allows us to use dmerror to simulate data
writeback failure, without affecting the journal.

xfs already has infrastructure for this (a'la $SCRATCH_LOGDEV), so wire
up the ext4 code so that it can do the same thing when _scratch_mkfs is
called.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 common/rc | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/common/rc b/common/rc
index 257b1903359d..8b815d9c8c33 100644
--- a/common/rc
+++ b/common/rc
@@ -675,6 +675,9 @@ _scratch_mkfs_ext4()
 	local tmp=`mktemp`
 	local mkfs_status
 
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+	    $mkfs_cmd -O journal_dev $SCRATCH_LOGDEV && \
+	    mkfs_cmd="$mkfs_cmd -J device=$SCRATCH_LOGDEV"
 
 	_scratch_do_mkfs "$mkfs_cmd" "$mkfs_filter" $* 2>$tmp.mkfserr 1>$tmp.mkfsstd
 	mkfs_status=$?
-- 
2.9.3
