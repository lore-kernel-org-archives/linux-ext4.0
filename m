From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/1] Allow ext4 to run without a journal.
Date: Tue, 16 Dec 2008 22:12:10 -0500
Message-ID: <20081217031210.GA17588@mit.edu>
References: <1228953270.14314.15.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:42970 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751699AbYLQDMN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Dec 2008 22:12:13 -0500
Content-Disposition: inline
In-Reply-To: <1228953270.14314.15.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 10, 2008 at 03:54:30PM -0800, Frank Mayhar wrote:
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index b455c68..3a05ae7 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -19,6 +19,8 @@
>  #include <linux/jbd2.h>
>  #include "ext4.h"
>  
> +#define EXT4_NOJOURNAL_MAGIC	(void *)0x457874344e6a6e6c /* "Ext4Njnl" */
> +

This will cause warnings on systems where pointers are 32-bits.  I'd
suggest using a 32-bit magic number.  Also, the number you have picked
is divisble by 4, which means at least in theory it could be a valid
pointer.  If we make EXT4_NOJOURNAL_MAGIC a 32-bit number, then a
number which is divisible by 4 definitely could be a valid pointer on
a 64-bit system.  I'd suggest keeping it simple, and simply using 0x1.
This is known not be a valid pointer, since it's not 32-bit word
aligned, and there is precedent for using such a number --- for
example, SIG_IGN is ((void *) 1) on many architectures, and page 0 is
generally unmapped to catch null pointer dereferences.  So I'd suggest
keeping things simple instead of using a fancy char string.

Also, why not use EXT4_NOJOURNAL_MAGIC constant directly, instead of
assigning it as a constant value to s_nojournal_flag in struct
ext4_sb_info?  That bloats the data structure for no good reason that
I can tell.

> +static inline int ext4_handle_dirty_metadata(handle_t *handle,
> +				struct inode *inode, struct buffer_head *bh)
> +{
> +	int err;
> +
> +	if (ext4_handle_valid(handle)) {
> +		err = __ext4_journal_dirty_metadata(__func__, handle, bh);
> +	} else {
> +		err = __ext4_write_dirty_metadata(inode, bh);
> +	}
> +	return err;
> +}

I don't see the point in doing this as an inline function; either way,
each time the inline function is executed, it will result a function
call, either to __ext4_journal_dirty_metadata() or
__ext4_write_dirty_metadata(), both of which are called exactly once
by this inline function.  So why not move the conditional and the
contents of _ext4_write_dirty_metadata() and
__ext4_journal_dirty_metadata() into __ext4_handle_dirty_metadata(),
and then do this:

#define ext4_handle_dirty_metadata(handle, inode, bh) \
	__ext4_handle_dirty_metadata(__func__, handle, inode, bh)

Ext4_handle_dirty_metadata() gets called a *lot*, so this will shrink
the icache footprint of ext4 filesystem, and for CPU's that have
decent branch prediction, centralizing the condition into a single
location instead of an inline will also be a win, once again
demonstrating that with modern CPU's, optimizations that minimize code
size often also faster.

>  /* super.c */
> @@ -208,6 +270,9 @@ int ext4_force_commit(struct super_block *sb);
>  
>  static inline int ext4_should_journal_data(struct inode *inode)
>  {
> +	BUG_ON(EXT4_JOURNAL(inode) == NULL &&
> +	       (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA ||
> +	        EXT4_I(inode)->i_flags & EXT4_JOURNAL_DATA_FL));
>  	if (!S_ISREG(inode->i_mode))
>  		return 1;
>  	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)

This shouldn't be a BUG_ON; this gets triggered if there is an inode
which is marked as needing data journalling.  So it is not a *bug*,
but at worst either a filesystem corruption, or more charitably a
conflict between a mount option and a setting in an inode flag.  In
any case, these should not cause a BUG; at worst an ext4_error(), or
ext4_warning().  However, today, if a filesystem with inodes
requesting data journalling are mounted on ext2, the request is simply
ignored.  So I'd argue that a similar treatmeant should be used for
ext4 filesystem running w/o a journal.  At worst perhaps there should
be a one-time ext4_warning(), but I'm not convinced even this is
warranted.  If the system administrator mounts a filesystem without a
journal, it's pretty clear what was meant.

> @@ -219,6 +284,8 @@ static inline int ext4_should_journal_data(struct inode *inode)
>  
>  static inline int ext4_should_order_data(struct inode *inode)
>  {
> +	BUG_ON(EXT4_JOURNAL(inode) == NULL &&
> +	       EXT4_I(inode)->i_flags & EXT4_JOURNAL_DATA_FL);

See above discussion.

>  static inline int ext4_should_writeback_data(struct inode *inode)
>  {
> +	BUG_ON(EXT4_JOURNAL(inode) == NULL &&
> +	       EXT4_I(inode)->i_flags & EXT4_JOURNAL_DATA_FL);

Again, see above.

> --- a/fs/ext4/ext4_sb.h
> +++ b/fs/ext4/ext4_sb.h
> @@ -28,6 +28,7 @@
>   * fourth extended-fs super-block data in memory
>   */
>  struct ext4_sb_info {
> +	int *s_nojournal_flag;		/* Null to indicate "not a handle" */
>  	unsigned long s_desc_size;	/* Size of a group descriptor in bytes */

See above discussion; I don't understand why this is necessary, and
why it is an int * here, especially given that it is assigned a
constant value which is a (void *), and it is eventually cast into a
(handle_t *).

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e4a241c..e0f433c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2284,7 +2314,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			printk(KERN_ERR
 			       "ext4: No journal on filesystem on %s\n",
 			       sb->s_id);
-		goto failed_mount3;
+		clear_opt(sbi->s_mount_opt, DATA_FLAGS);
+		set_opt(sbi->s_mount_opt, WRITEBACK_DATA);
+		sbi->s_journal = NULL;
+		es->s_state &= cpu_to_le16(~EXT4_VALID_FS);
+		needs_recovery = 0;
+		goto no_journal;
 	}

In the case where there is no journal, please remove the KERN_ERR
printk; that's just excess noise, and some day, Google System
Administrators will thank you for getting rid of it.  :-)

@@ -2748,6 +2798,9 @@ static int ext4_create_journal(struct super_block *sb,
 
 	EXT4_SB(sb)->s_journal = journal;
 
+	if (journal_inum == 0)
+		return 0;
+
 	ext4_update_dynamic_rev(sb);
 	EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 	EXT4_SET_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL);

If journal_inum == 0, ext4_create_journal will never be called (see
line 2429 in ext4fill_super), so this check is not really necessary.

Actually, what we should probably do (as a separate patch before this
one), is to remove ext4_create_journal() and the journal_inum mount
option altogether.  It's pointless code that was originally added to
ext3 by Stephen Tweedie back when he wanted to convert ext2
filesystems to ext3 before e2fsprogs supported tune2fs -j.  It's been
obsolete for over eight years, in both ext3 and ext4.


In any case, these are all pretty tiny nits; on the whole I think this
patch is quite clean, so I'll add it to the ext4 patch queue for
testing.  I would appreciate getting an updated patch which addresses
these suggested cleanups, though.  Also, although I haven't tested it,
I suspect we need to add a check so that if there is no journal, and
the EXT4_FEATURE_INCOMPAT_RECOVERY feature is set, the mount should be
aborted with an error, instead of just clearning the recovery flag and
moving on.  In actual practice, such a combination should never
happen, but if it does, failing the mount is probably a safer thing
to do.

Regards,

							- Ted
