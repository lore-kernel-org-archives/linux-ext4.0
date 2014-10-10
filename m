From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] ext4: Fix block zeroing when punching
	holes in indirect block files
Date: Fri, 10 Oct 2014 16:23:15 +0200
Message-ID: <1412951028-4085-11-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
	tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>,
	Mark Fasheh <mfasheh@suse.com>, Dave Chinner <david@fromorbit.com>,
	reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com,
	cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Steven Whitehouse <swhiteho@redhat.com>,
	ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk
To: linux-fsdevel@vger.kernel.org
Return-path: <jfs-discussion-bounces@lists.sourceforge.net>
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=jfs-discussion>
List-Post: <mailto:jfs-discussion@lists.sourceforge.net>
List-Help: <mailto:jfs-discussion-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=subscribe>
Errors-To: jfs-discussion-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

free_holes_block() passed local variable as a block pointer
to ext4_clear_blocks(). Thus ext4_clear_blocks() zeroed out this local
variable instead of proper place in inode / indirect block. We later
zero out proper place in inode / indirect block but don't dirty the
inode / buffer again which can lead to subtle issues (some changes e.g.
to inode can be lost).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/indirect.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 8a57e9fcd1b9..9d381707a6fc 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -1329,8 +1329,8 @@ static int free_hole_blocks(handle_t *handle, struct inode *inode,
 		if (level == 0 ||
 		    (bh && all_zeroes((__le32 *)bh->b_data,
 				      (__le32 *)bh->b_data + addr_per_block))) {
-			ext4_free_data(handle, inode, parent_bh, &blk, &blk+1);
-			*i_data = 0;
+			ext4_free_data(handle, inode, parent_bh,
+				       i_data, i_data + 1);
 		}
 		brelse(bh);
 		bh = NULL;
-- 
1.8.1.4


------------------------------------------------------------------------------
Meet PCI DSS 3.0 Compliance Requirements with EventLog Analyzer
Achieve PCI DSS 3.0 Compliant Status with Out-of-the-box PCI DSS Reports
Are you Audit-Ready for PCI DSS 3.0 Compliance? Download White paper
Comply to PCI DSS 3.0 Requirement 10 and 11.5 with EventLog Analyzer
http://pubads.g.doubleclick.net/gampad/clk?id=154622311&iu=/4140/ostg.clktrk
