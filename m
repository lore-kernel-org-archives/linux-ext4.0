From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v3 20/20] gfs2: clean up some filemap_* calls
Date: Mon, 24 Apr 2017 09:22:59 -0400
Message-ID: <20170424132259.8680-21-jlayton@redhat.com>
References: <20170424132259.8680-1-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: axboe@kernel.dk, hch@infradead.org, tytso@mit.edu, mawilcox@microsoft.com,
	corbet@lwn.net, dhowells@redhat.com, clm@fb.com,
	viro@zeniv.linux.org.uk, jack@suse.com,
	akpm@linux-foundation.org, ross.zwisler@linux.intel.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-mm@kvack.org,
	jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org,
	cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net,
	v9fs-developer@lists.sourceforge.net, osd-dev@open-osd.org,
	linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20170424132259.8680-1-jlayton@redhat.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

In some places, it's trying to reset the mapping error after calling
filemap_fdatawait. That's no longer required. Also, turn several
filemap_fdatawrite+filemap_fdatawait calls into filemap_write_and_wait.
That will at least return writeback errors that occur during the write
phase.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/gfs2/glops.c | 12 ++++--------
 fs/gfs2/lops.c  |  4 +---
 fs/gfs2/super.c |  6 ++----
 3 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 5db59d444838..7362d19fdc4c 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -158,9 +158,7 @@ static void rgrp_go_sync(struct gfs2_glock *gl)
 	GLOCK_BUG_ON(gl, gl->gl_state != LM_ST_EXCLUSIVE);
 
 	gfs2_log_flush(sdp, gl, NORMAL_FLUSH);
-	filemap_fdatawrite_range(mapping, gl->gl_vm.start, gl->gl_vm.end);
-	error = filemap_fdatawait_range(mapping, gl->gl_vm.start, gl->gl_vm.end);
-	mapping_set_error(mapping, error);
+	filemap_write_and_wait_range(mapping, gl->gl_vm.start, gl->gl_vm.end);
 	gfs2_ail_empty_gl(gl);
 
 	spin_lock(&gl->gl_lockref.lock);
@@ -225,12 +223,10 @@ static void inode_go_sync(struct gfs2_glock *gl)
 	filemap_fdatawrite(metamapping);
 	if (ip) {
 		struct address_space *mapping = ip->i_inode.i_mapping;
-		filemap_fdatawrite(mapping);
-		error = filemap_fdatawait(mapping);
-		mapping_set_error(mapping, error);
+		filemap_write_and_wait(mapping);
+	} else {
+		filemap_fdatawait(metamapping);
 	}
-	error = filemap_fdatawait(metamapping);
-	mapping_set_error(metamapping, error);
 	gfs2_ail_empty_gl(gl);
 	/*
 	 * Writeback of the data mapping may cause the dirty flag to be set
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index b1f9144b42c7..565ce33dec9b 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -586,9 +586,7 @@ static void gfs2_meta_sync(struct gfs2_glock *gl)
 	if (mapping == NULL)
 		mapping = &sdp->sd_aspace;
 
-	filemap_fdatawrite(mapping);
-	error = filemap_fdatawait(mapping);
-
+	error = filemap_write_and_wait(mapping);
 	if (error)
 		gfs2_io_error(gl->gl_name.ln_sbd);
 }
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 361796a84fce..675c39566ea1 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1593,10 +1593,8 @@ static void gfs2_evict_inode(struct inode *inode)
 out_truncate:
 	gfs2_log_flush(sdp, ip->i_gl, NORMAL_FLUSH);
 	metamapping = gfs2_glock2aspace(ip->i_gl);
-	if (test_bit(GLF_DIRTY, &ip->i_gl->gl_flags)) {
-		filemap_fdatawrite(metamapping);
-		filemap_fdatawait(metamapping);
-	}
+	if (test_bit(GLF_DIRTY, &ip->i_gl->gl_flags))
+		filemap_write_and_wait(metamapping);
 	write_inode_now(inode, 1);
 	gfs2_ail_flush(ip->i_gl, 0);
 
-- 
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
