From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mm: add missing mutex lock arround notify_change
Date: Tue, 20 Dec 2011 17:09:01 -0500
Message-ID: <20111220220901.GA1770@thunk.org>
References: <20111216112534.GA13147@dztty>
 <20111216125556.db2bf308.akpm@linux-foundation.org>
 <20111217214137.GY2203@ZenIV.linux.org.uk>
 <20111217221028.GZ2203@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Djalal Harouni <tixxdz@opendz.org>, Hugh Dickins <hughd@google.com>,
	Minchan Kim <minchan.kim@gmail.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Neil Brown <neilb@suse.de>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20111217221028.GZ2203@ZenIV.linux.org.uk>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Dec 17, 2011 at 10:10:28PM +0000, Al Viro wrote:
> 
> Oh, for fsck sake...  People, this is *obviously* broken - if nothing else,
> removing suid after modifying the file contents is too late.  Moreover,
> this mext_inode_double_lock() thing is asking for trouble; it's deadlock-free
> only because nothing else takes i_mutex on more than one non-directory inode
> and does that as the innermost lock.

Well, we need to define *some* kind of lock ordering for i_mutex
belonging to regular files within a single file system, and ordering
them by inode number seemed to make the most amount of sense.  If it
turns out some other routine needs to do i_mutex locking of regular
files with some other lock ordering, we're certainly open to using
something else.

> BTW, is ordering really needed in
> double_down_write_data_sem()?  IOW, can we get contention between several
> callers of that thing?
>
> From my reading of that code, all call chains leading to this sucker
> are guaranteed to already hold i_mutex on both inodes.  If that is true,
> we don't need any ordering in double_down_write_data_sem() at all...

Yes, you're right, the ordering in double_down_write_data_sem() can go
away; it's harmless, and doesn't cost much, but it's strictly speaking
not necessary.

> AFAICS, the minimal fix is to move file_remove_suid() call into
> ext4_move_extents(), just after we have acquired i_mutex in there.
> Moreover, I think it should be done to *both* files, since both have
> contents modified.  And I see no point in making that conditional...

Actually, we're not modifying the contents of the file that is being
defragged, only the donor file, so there shouldn't be any need to nuke
the suid flag for the target file, just the donor.  But yes, we should
move the call into ext4_move_extents(), and since the donor file
should never have the suid flag on it anyway (unless someone is trying
to play tricks on us), the conditional shouldn't be necessary.  

				- Ted

P.S.  Maybe it would be a good idea to add a mention of the fact that
file_remove_suid() needs i_mutex, either in mm/filemap.c as a comment,
or in Documentation/filesystems/vfs.txt, or both?


>From 5e8af306ef8025a4c98bcc51b6b2ed63e1df31c4 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Tue, 20 Dec 2011 17:06:08 -0500
Subject: [PATCH] ext4: fix potential deadlock with setuid files and EXT4_IOC_MOVE_EXT

file_remove_suid() must be called with i_mutex down, since it calls
notify_change().  In addition, we really want to remove the suid file
*before* we modify the donor file, to avoid someone from trying to
exploit a race.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/ioctl.c       |    2 --
 fs/ext4/move_extent.c |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index a567968..ff1aab7 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -247,8 +247,6 @@ setversion_out:
 		err = ext4_move_extents(filp, donor_filp, me.orig_start,
 					me.donor_start, me.len, &me.moved_len);
 		mnt_drop_write(filp->f_path.mnt);
-		if (me.moved_len > 0)
-			file_remove_suid(donor_filp);
 
 		if (copy_to_user((struct move_extent __user *)arg,
 				 &me, sizeof(me)))
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index c5826c6..7403e1b 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -1222,6 +1222,8 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 	if (ret1)
 		goto out;
 
+	file_remove_suid(d_filp);
+
 	file_end = (i_size_read(orig_inode) - 1) >> orig_inode->i_blkbits;
 	block_end = block_start + len - 1;
 	if (file_end < block_end)
-- 
1.7.8.11.gefc1f.dirty

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
