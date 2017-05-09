From: Jeff Layton <jlayton@redhat.com>
Subject: [xfstests PATCH v2 3/3] btrfs: allow it to use
	$SCRATCH_LOGDEV
Date: Tue,  9 May 2017 12:12:45 -0400
Message-ID: <20170509161245.29908-4-jlayton@redhat.com>
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

With btrfs, we can't really put the log on a separate device. What we
can do however is mirror the metadata across two devices and put the
data on a single device. When we turn on dmerror then the metadata can
fall back to using the other mirror while the data errors out.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 common/rc | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/common/rc b/common/rc
index 8b815d9c8c33..2084c1f24f30 100644
--- a/common/rc
+++ b/common/rc
@@ -829,6 +829,8 @@ _scratch_mkfs()
 		;;
 	btrfs)
 		mkfs_cmd="$MKFS_BTRFS_PROG"
+		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+			mkfs_cmd="$mkfs_cmd -d single -m raid1 $SCRATCH_LOGDEV"
 		mkfs_filter="cat"
 		;;
 	ext2|ext3)
-- 
2.9.3
