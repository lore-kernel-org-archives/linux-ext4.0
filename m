From: Jan Kara <jack@suse.cz>
Subject: [PATCH] fs: Avoid userspace mounting anon_inodefs
	filesystem
Date: Fri, 10 Oct 2014 16:23:22 +0200
Message-ID: <1412951028-4085-18-git-send-email-jack@suse.cz>
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

anon_inodefs filesystem is a kernel internal filesystem userspace
shouldn't mess with. Remove registration of it so userspace cannot
even try to mount it (which would fail anyway because the filesystem is
MS_NOUSER).

This fixes an oops triggered by trinity when it tried mounting
anon_inodefs which overwrote anon_inode_inode pointer while other CPU
has been in anon_inode_getfile() between ihold() and d_instantiate().
Thus effectively creating dentry pointing to an inode without holding a
reference to it.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/anon_inodes.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 24084732b1d0..4b4543b8b894 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -177,9 +177,6 @@ static int __init anon_inode_init(void)
 {
 	int error;
 
-	error = register_filesystem(&anon_inode_fs_type);
-	if (error)
-		goto err_exit;
 	anon_inode_mnt = kern_mount(&anon_inode_fs_type);
 	if (IS_ERR(anon_inode_mnt)) {
 		error = PTR_ERR(anon_inode_mnt);
-- 
1.8.1.4


------------------------------------------------------------------------------
Meet PCI DSS 3.0 Compliance Requirements with EventLog Analyzer
Achieve PCI DSS 3.0 Compliant Status with Out-of-the-box PCI DSS Reports
Are you Audit-Ready for PCI DSS 3.0 Compliance? Download White paper
Comply to PCI DSS 3.0 Requirement 10 and 11.5 with EventLog Analyzer
http://pubads.g.doubleclick.net/gampad/clk?id=154622311&iu=/4140/ostg.clktrk
