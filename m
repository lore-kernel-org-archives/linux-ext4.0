From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: journal superblock modifications in
	ext4_statfs()
Date: Sat, 14 Nov 2009 22:29:41 -0500
Message-ID: <20091115032941.GB4323@mit.edu>
References: <4AF4A429.7090507@redhat.com> <6BDA2C94-6FA5-48EE-9E68-56BDFC4B558A@sun.com> <20091108214804.GC7592@mit.edu> <AB457F38-7E3A-43CE-B334-AE363BAE040C@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45115 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbZKOD3l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Nov 2009 22:29:41 -0500
Content-Disposition: inline
In-Reply-To: <AB457F38-7E3A-43CE-B334-AE363BAE040C@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 08, 2009 at 09:41:28PM -0700, Andreas Dilger wrote:
>
> The reason we added this was for running a read-only e2fsck on a
> filesystem without getting spurious errors just because the superblock
> summaries were incorrect.  The other alternative is to change e2fsck
> so that it doesn't consider just a block/inode summary an error.
>

We've been doing this for a while --- e2fsprogs 1.34, since April
2003.  In e2fsck/super.c:check_super_block():

	/*
	 * Update the global counts from the block group counts.  This
	 * is needed for an experimental patch which eliminates
	 * locking the entire filesystem when allocating blocks or
	 * inodes; if the filesystem is not unmounted cleanly, the
	 * global counts may not be accurate.
	 */
	if ((free_blocks != sb->s_free_blocks_count) ||
	    (free_inodes != sb->s_free_inodes_count)) {
		if (ctx->options & E2F_OPT_READONLY)
			ext2fs_unmark_valid(fs);
		else {
			sb->s_free_blocks_count = free_blocks;
			sb->s_free_inodes_count = free_inodes;
			ext2fs_mark_super_dirty(fs);
		}
	}

I suppose I should edit out the bit about "experimental patch", which
might have been true in 2003, but it's certainly not true any more.

Hence, I think it's safe to eliminate the updates in ext4_statfs()
altogether.

						- Ted

commit 48efef97e03811e4492607ed7a7aefb35e2c0c00
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Nov 14 21:37:52 2009 -0500

    ext4: Don't update the superblock in ext4_statfs()
    
    commit a71ce8c6c9bf269b192f352ea555217815cf027e updated ext4_statfs()
    to update the on-disk superblock counters, but modified this buffer
    directly without any journaling of the change.  This is one of the
    accesses that was causing the crc errors in journal replay as seen in
    kernel.org bugzilla #14354.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8662b2e..3cd519b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3668,13 +3668,11 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_blocks = ext4_blocks_count(es) - sbi->s_overhead_last;
 	buf->f_bfree = percpu_counter_sum_positive(&sbi->s_freeblocks_counter) -
 		       percpu_counter_sum_positive(&sbi->s_dirtyblocks_counter);
-	ext4_free_blocks_count_set(es, buf->f_bfree);
 	buf->f_bavail = buf->f_bfree - ext4_r_blocks_count(es);
 	if (buf->f_bfree < ext4_r_blocks_count(es))
 		buf->f_bavail = 0;
 	buf->f_files = le32_to_cpu(es->s_inodes_count);
 	buf->f_ffree = percpu_counter_sum_positive(&sbi->s_freeinodes_counter);
-	es->s_free_inodes_count = cpu_to_le32(buf->f_ffree);
 	buf->f_namelen = EXT4_NAME_LEN;
 	fsid = le64_to_cpup((void *)es->s_uuid) ^
 	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));
