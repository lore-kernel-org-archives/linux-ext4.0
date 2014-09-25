From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2 v2] Fix data corruption when blocksize < pagesize for
	mmapped data
Date: Thu, 25 Sep 2014 14:41:54 +0200
Message-ID: <1411648916-16773-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ted Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Return-path: <xfs-bounces@oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

  Hello,

  this is a second version of the patches to fix data corruption in mmapped
data when blocksize < pagesize as tested by xfstests generic/030 test.
The patchset fixes XFS and ext4. I've checked and btrfs doesn't need fixing
because it doesn't support blocksize < pagesize. If that's ever going
to change btrfs will likely need a similar treatment. ocfs2, ext2, ext3 are
OK since they happily allocate blocks during writeback. For other filesystems
like gfs2, ubifs, nilfs, ceph,... I'm not sure whether they support blocksize <
pagesize at all. Interesting is also NFS which may care but I don't understand
its ->page_mkwrite() handler good enough to judge.

Changes since v1:
- changed helper function name and moved it to mm/truncate.c - I originally
  thought we can make the helper function update i_size to simplify the
  interface but it's actually impossible due to generic_write_end() lock
  ordering constraints.
- used round_up() instead of ALIGN()
- taught truncate_setsize() to use the helper function

								Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
