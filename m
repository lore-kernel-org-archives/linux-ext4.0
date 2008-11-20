From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/5] ext4: unlock group before ext4_error
Date: Thu, 20 Nov 2008 17:38:52 -0500
Message-ID: <20081120223852.GD14212@mit.edu>
References: <1227205580-27596-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:35155 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751395AbYKTWjL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Nov 2008 17:39:11 -0500
Content-Disposition: inline
In-Reply-To: <1227205580-27596-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 20, 2008 at 11:56:18PM +0530, Aneesh Kumar K.V wrote:
> Otherwise ext4_error will cause BUG because of
> scheduling in atomic context.

Granted that it isn't necessarily safe as it is when errors-behaviour
is set to continue, that is the default on a large number of
filesystems.  And unlocking the group, calling the ext4_error(), and
then relocking the group can't possibly be safe; after all, we're
holding the lock for a reason!  

In the errors=continue case, we don't actually need to unlock and
relock the group, since all we need to do is to printk a message to
the console.  In the errors=panic case, we'll never return; and in the
errors=remount-ro case, relocking is kind of pointless but harmless,
since once the journal is aborted, there's no way the allocation is
going to succeed anyway, and a subsequent call will return an error.

This gets ugly to get right.  Since the situation where we need to
call ext4_error() while holding a spinlock which should be preserved
in the errors=continue case seems to be unique to mballoc, maybe
something like this?

static int ext4_grp_locked_error(struct super_block *sb, ext4_group_t grp,
       	    		          const char *function,
            		          const char *fmt, ...)
{

	va_start(args, fmt);
	printk(KERN_CRIT "EXT4-fs error (device %s): %s: ", sb->s_id, function);
	vprintk(fmt, args);
	printk("\n");
	va_end(args);

	if (test_opt(sb, ERROR_CONT)) {
		EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
		es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
		ext4_commit_super(sb, es, 0);
		return 0;
	}
	ext4_unlock_group(sb, grp);
	ext4_handle_error(sb);
	/* 
	 * We only get here in the ERRORS_RO case; relocking the group
	 * may be dangerous, but nothing bad will happen since the
	 * filesystem will have already been marked read/only and the
	 * journal has been aborted.  We return 1 as a hint to callers
	 * who might what to use the return value from
	 * ext4_grp_locked_error() to distinguish beween the
	 * ERRORS_CONT and ERRORS_RO case, and perhaps return more
	 * aggressively from the ext4 function in question, with a
	 * more appropriate error code.
	 */
	ext4_lock_group(sb, grp);
}

This requires access to two static functions in fs/ext4/super.c, so
probably the best thing to do is to put this function in
fs/ext4/super.c, and move the definition of ext4_[un]lock_group from
mballoc.h to ext4.h.

Comments?

						- Ted
