From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 07/17] vfs: Introduce new helpers for syncing after writing to O_SYNC file or IS_SYNC inode
Date: Sun, 30 Aug 2009 17:35:51 +0100
Message-ID: <20090830163551.GA7129@shareable.org>
References: <1250875447-15622-1-git-send-email-jack@suse.cz> <1250875447-15622-8-git-send-email-jack@suse.cz> <20090827173540.GA19115@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	hch@lst.de, linux-fsdevel@vger.kernel.org,
	Evgeniy Polyakov <zbr@ioremap.net>, ocfs2-devel@oss.oracle.com,
	Joel Becker <joel.becker@oracle.com>,
	Felix Blyakher <felixb@sgi.com>, xfs@oss.sgi.com,
	Anton Altaparmakov <aia21@cantab.net>,
	linux-ntfs-dev@lists.sourceforge.net,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:41325 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbZH3QhC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Aug 2009 12:37:02 -0400
Content-Disposition: inline
In-Reply-To: <20090827173540.GA19115@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christoph Hellwig wrote:
> int generic_write_sync(struct file *file, loff_t pos, loff_t count)
> {
> 	if (!(file->f_flags & O_SYNC) && !IS_SYNC(file->f_mapping->host))
> 		return 0;
> 	return vfs_fsync_range(file, file->f_path.dentry, pos,
> 			       pos + count - 1, 1);
> }
> 
> and we can look into replacing the datasync flag with something more
> meaningfull later through the whole fsync stack.

I like that.  It looks really clear and self-documenting, if
vfs_fsync_range does what it sounds like, which is a nice change.

If I've guessed right what that code does, proper O_RSYNC will be easy:

int generic_sync_before_read(struct file *file, loff_t pos, loff_t count)
{
	int is_sync = ((file->f_flags & O_SYNC)
		       || IS_SYNC(file->f_mapping->host));
	int is_dsync = is_sync || (file->f_flags & O_DSYNC);

	if (!is_dsync || !(file->f_flags & O_RSYNC))
		return 0;
	return vfs_fsync_range(file, file->f_ath.denty, pos,
			       pos + count - 1, is_sync);
}

(By the way, did I mention Irix has range-fsync and range-fdatasync
system calls too :-) (actually fcntls))

-- Jamie
