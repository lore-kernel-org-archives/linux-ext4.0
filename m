From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext3/jbd: Avoid WARN() messages when failing to write the	superblock
Date: Mon, 11 Oct 2010 10:05:34 -0500
Message-ID: <4CB327BE.8000003@redhat.com>
References: <20101004193505.GC25624@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab0JKPFv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Oct 2010 11:05:51 -0400
In-Reply-To: <20101004193505.GC25624@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Darrick J. Wong wrote:
> This fixes a WARN backtrace in mark_buffer_dirty() that occurs during unmount
> when the underlying block device is removed.  This bug has been seen on System
> Z when removing all paths from a multipath-backed ext3 mount; on System P when
> injecting enough PCI EEH errors to make the SCSI controller go offline; and
> similar warnings have been seen (and patched) with ext2/ext4.
> 
> The super block update from a previous operation has marked the buffer as in
> error, and the flag has to be cleared before doing the update.  (Similar code
> already exists in ext4).
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---

Probably worth mentioning the ext4 version is:

commit 914258bf2cb22bf4336a1b1d90c551b4b11ca5aa
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Oct 6 21:35:40 2008 -0400

    ext4/jbd2: Avoid WARN() messages when failing to write to the superblock
    
    This fixes some very common warnings reported by kerneloops.org
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>


-Eric

>  fs/ext3/super.c  |   24 +++++++++++++++++++++++-
>  fs/jbd/journal.c |   30 ++++++++++++++++++++++++++++--
>  2 files changed, 51 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 5dbf4db..5a19796 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -2361,6 +2361,21 @@ static int ext3_commit_super(struct super_block *sb,
>  
>  	if (!sbh)
>  		return error;
> +
> +	if (buffer_write_io_error(sbh)) {
> +		/*
> +		 * Oh, dear.  A previous attempt to write the
> +		 * superblock failed.  This could happen because the
> +		 * USB device was yanked out.  Or it could happen to
> +		 * be a transient write error and maybe the block will
> +		 * be remapped.  Nothing we can do but to retry the
> +		 * write and hope for the best.
> +		 */
> +		printk(KERN_ERR "ext3: previous I/O error to "
> +		       "superblock detected for %s.\n", sb->s_id);
> +		clear_buffer_write_io_error(sbh);
> +		set_buffer_uptodate(sbh);
> +	}
>  	/*
>  	 * If the file system is mounted read-only, don't update the
>  	 * superblock write time.  This avoids updating the superblock
> @@ -2377,8 +2392,15 @@ static int ext3_commit_super(struct super_block *sb,
>  	es->s_free_inodes_count = cpu_to_le32(ext3_count_free_inodes(sb));
>  	BUFFER_TRACE(sbh, "marking dirty");
>  	mark_buffer_dirty(sbh);
> -	if (sync)
> +	if (sync) {
>  		error = sync_dirty_buffer(sbh);
> +		if (buffer_write_io_error(sbh)) {
> +			printk(KERN_ERR "ext3: I/O error while writing "
> +			       "superblock for %s.\n", sb->s_id);
> +			clear_buffer_write_io_error(sbh);
> +			set_buffer_uptodate(sbh);
> +		}
> +	}
>  	return error;
>  }
>  
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index 2c4b1f1..8bfd226 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -84,6 +84,7 @@ EXPORT_SYMBOL(journal_force_commit);
>  
>  static int journal_convert_superblock_v1(journal_t *, journal_superblock_t *);
>  static void __journal_abort_soft (journal_t *journal, int errno);
> +static const char *journal_dev_name(journal_t *journal, char *buffer);
>  
>  /*
>   * Helper function used to manage commit timeouts
> @@ -1010,6 +1011,23 @@ void journal_update_superblock(journal_t *journal, int wait)
>  		goto out;
>  	}
>  
> +	if (buffer_write_io_error(bh)) {
> +		char b[BDEVNAME_SIZE];
> +		/*
> +		 * Oh, dear.  A previous attempt to write the journal
> +		 * superblock failed.  This could happen because the
> +		 * USB device was yanked out.  Or it could happen to
> +		 * be a transient write error and maybe the block will
> +		 * be remapped.  Nothing we can do but to retry the
> +		 * write and hope for the best.
> +		 */
> +		printk(KERN_ERR "JBD: previous I/O error detected "
> +		       "for journal superblock update for %s.\n",
> +		       journal_dev_name(journal, b));
> +		clear_buffer_write_io_error(bh);
> +		set_buffer_uptodate(bh);
> +	}
> +
>  	spin_lock(&journal->j_state_lock);
>  	jbd_debug(1,"JBD: updating superblock (start %u, seq %d, errno %d)\n",
>  		  journal->j_tail, journal->j_tail_sequence, journal->j_errno);
> @@ -1021,9 +1039,17 @@ void journal_update_superblock(journal_t *journal, int wait)
>  
>  	BUFFER_TRACE(bh, "marking dirty");
>  	mark_buffer_dirty(bh);
> -	if (wait)
> +	if (wait) {
>  		sync_dirty_buffer(bh);
> -	else
> +		if (buffer_write_io_error(bh)) {
> +			char b[BDEVNAME_SIZE];
> +			printk(KERN_ERR "JBD: I/O error detected "
> +			       "when updating journal superblock for %s.\n",
> +			       journal_dev_name(journal, b));
> +			clear_buffer_write_io_error(bh);
> +			set_buffer_uptodate(bh);
> +		}
> +	} else
>  		write_dirty_buffer(bh, WRITE);
>  
>  out:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

