From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck shouln't consider superblock summaries as fatal
Date: Wed, 27 Aug 2008 09:44:25 -0400
Message-ID: <20080827134425.GA29950@mit.edu>
References: <20080826104502.GH3392@webber.adilger.int> <20080826170420.GE8720@mit.edu> <20080826212743.GP3392@webber.adilger.int> <20080827002516.GC29936@mit.edu> <20080827073242.GU3392@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:52047 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753931AbYH0No3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 09:44:29 -0400
Content-Disposition: inline
In-Reply-To: <20080827073242.GU3392@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 27, 2008 at 01:32:42AM -0600, Andreas Dilger wrote:
> I don't think this is the issue at all.  It isn't that the journal has the
> right summary values either, otherwise waiting 1 commit interval would
> be enough.  The issue is that the kernel NEVER updates the summaries
> by itself, so the effort to replay the journal in memory would be cool,
> but wouldn't help at all.

If you reboot and replay the journal, the summary values are right.
So the correct values are indeed in the journal.  The problem is that
we *never* write the superblock to disk, but only to the journal.
Consider:

/*
 * Ext3 always journals updates to the superblock itself, so we don't
 * have to propagate any other updates to the superblock on disk at this
 * point.  Just start an async writeback to get the buffers on their way
 * to the disk.
 *
 * This implicitly triggers the writebehind on sync().
 */

static void ext3_write_super (struct super_block * sb)
{
	if (mutex_trylock(&sb->s_lock) != 0)
		BUG();
	sb->s_dirt = 0;
}

The comment is a little out of date, since we don't even start an
async writeback these days.  All ext3_write_super does is mark the
superblock as non-dirty, so we are 100% dependent on the summary
values getting written to the journal.  Even if we call fsync on the
filesystem, we don't actually write the superblock to its permanent
location on disk, but only to the journal.

static int ext3_sync_fs(struct super_block *sb, int wait)
{
	tid_t target;

	sb->s_dirt = 0;
	if (journal_start_commit(EXT3_SB(sb)->s_journal, &target)) {
		if (wait)
			log_wait_commit(EXT3_SB(sb)->s_journal, target);
	}
	return 0;
}

It's only if we unmount or freeze the filesystem that we call
ext3_commit_super().

						- Ted
