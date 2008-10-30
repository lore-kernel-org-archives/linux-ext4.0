From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH 1/1] Allow ext4 to run without a journal.
Date: Thu, 30 Oct 2008 17:40:37 -0600
Message-ID: <20081030234037.GU3184@webber.adilger.int>
References: <1225397281.19114.13.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Michael Rubin <mrubin@google.com>,
	Peter Kukol <pkukol@google.com>
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:38718 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbYJ3Xkl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Oct 2008 19:40:41 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m9UNeeu9026920
	for <linux-ext4@vger.kernel.org>; Thu, 30 Oct 2008 16:40:40 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K9K00101S914W00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 30 Oct 2008 16:40:40 -0700 (PDT)
In-reply-to: <1225397281.19114.13.camel@bobble.smo.corp.google.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Firstly,
thanks for working on this.  It is a huge patch, and my suggested
changes are some effort to reduce the size of the patch and keep
this functionality more maintainable.

I'd be terribly interested in ext2 vs. ext4 with/without journal
performance numbers, if you have any.

On Oct 30, 2008  13:08 -0700, Frank Mayhar wrote:
> We have a need to run ext4 on existing ext2 file systems.  To get there
> we need to be able to run ext4 without a journal.  I've managed to come
> up with an early patch that gets us at least partway there.
> 
> This patch just allows ext4 to mount and run with an ext2 root; I
> haven't tried it with anything else yet.  It also scribbles in the
> superblock, so it takes an fsck to get it back to ext2 compatibility.

What is the reason for this?  In the final form all that should happen
is the normal ext2 "mark filesystem dirty" operation.

> @@ -396,7 +396,7 @@ ext4_acl_chmod(struct inode *inode)
> -		if (IS_ERR(handle)) {
> +		if (handle && IS_ERR(handle)) {

Actually, if handle is NULL then "IS_ERR(handle)" is false from my reading:

	unlikely(0UL >= -4095UL)

No need to change all of this code.

> @@ -96,7 +96,7 @@ static int ext4_ext_journal_restart(hand
>  {
> -	if (handle->h_buffer_credits > needed)
> +	if (handle && handle->h_buffer_credits > needed)
>  		return 0;

This should just be "if (!handle) return 0;" as the first condition.

> @@ -1885,7 +1885,7 @@ ext4_ext_rm_leaf(handle_t *handle, struc
>  
>  	while (ex >= EXT_FIRST_EXTENT(eh) &&
>  			ex_ee_block + ex_ee_len > start) {
> -		ext_debug("remove ext %lu:%u\n", ex_ee_block, ex_ee_len);
> +		ext_debug("remove ext %lu:%u\n", (unsigned long)ex_ee_block, ex_ee_len);

This is the wrong fix.  Instead it should just be using "%u" to print the
block number, since it is limited to 32 bits right now.  Same is true of
all similar fixes.

> @@ -2582,7 +2582,7 @@ int ext4_ext_get_blocks(handle_t *handle
>  	ext_debug("blocks %u/%lu requested for inode %u\n",
> -			iblock, max_blocks, inode->i_ino);
> +			iblock, max_blocks, (unsigned)inode->i_ino);

Similarly, the right format for ino_t is %lu instead of casting the value.

> @@ -2842,7 +2842,7 @@ void ext4_ext_truncate(struct inode *ino
> -	if (IS_SYNC(inode))
> +	if (handle && IS_SYNC(inode))
>  		handle->h_sync = 1;

It would be nice to have a helper function that does this transparently:

static inline void ext4_handle_sync(handle)
{
	if (handle)
		handle->h_sync = 1;
}
 
This could be submitted before the rest of the patch without "if (handle)"
and then you only need to change the code in one place.

> -		BUFFER_TRACE(bh2, "call ext4_journal_dirty_metadata");
> -		err = ext4_journal_dirty_metadata(handle, bh2);
> +		BUFFER_TRACE(bh2, "call ext4_handle_dirty_metadata");
> +		err = ext4_handle_dirty_metadata(handle, NULL, bh2);

With this change are you removing the older ext4_journal_*() functions
completely (ensuring that all callers have to be fixed to use ext4_handle*()
instead), or are they still available?  Unfortunately, this part of the
patch is missing.

If the ext4_journal_*() functions are still available this exposes us to
endless bugs from code that doesn't get fixed to work in unjournalled mode,
but 99% of users won't notice it.

> @@ -645,7 +645,8 @@ repeat_in_this_group:
> -			err = ext4_journal_get_write_access(handle, bitmap_bh);
> +			err = ext4_journal_get_write_access(handle,
> +								    bitmap_bh);

I'm not sure why that was changed.

> @@ -653,15 +654,17 @@ repeat_in_this_group:
>  			/* we lost it */
> -			jbd2_journal_release_buffer(handle, bitmap_bh);
> +			if (handle)
> +				jbd2_journal_release_buffer(handle, bitmap_bh);

This should probably also be wrapped in ext4_handle_release_buffer() so we
don't need to expose all of the callsites to this check.

> @@ -820,7 +824,7 @@ got:
> -	if (IS_DIRSYNC(inode))
> +	if (handle && IS_DIRSYNC(inode))
>  		handle->h_sync = 1;

Use ext4_handle_sync(handle) helper as suggested above.

> @@ -232,7 +239,7 @@ void ext4_delete_inode (struct inode * i
> +	if (handle && handle->h_buffer_credits < 3) {

A new helper ext4_handle_has_enough_credits(handle, needed) would be useful
in a few places, and can always return 1 if handle is NULL.

> @@ -881,7 +888,8 @@ int ext4_get_blocks_handle(handle_t *han
>  	J_ASSERT(!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL));
> -	J_ASSERT(handle != NULL || create == 0);
> +	/*J_ASSERT(handle != NULL || create == 0);*/

I would predicate this assertion on sbi->s_journal instead of just
removing it:

	J_ASSERT(create == 0 ||
		 (handle != NULL) == (EXT4_SB(inode->i_sb)->s_journal != NULL));

> @@ -1198,8 +1206,6 @@ struct buffer_head *ext4_getblk(handle_t
>  	struct buffer_head dummy;
>  	int fatal = 0, err;
>  
> -	J_ASSERT(handle != NULL || create == 0);
> @@ -1224,7 +1230,6 @@ struct buffer_head *ext4_getblk(handle_t
>  		if (buffer_new(&dummy)) {
>  			J_ASSERT(create != 0);
> -			J_ASSERT(handle != NULL);

Please keep the assertion in place, as above.

> @@ -2265,33 +2263,37 @@ restart_loop:
>  		/* start a new transaction*/
> +		if (EXT4_HAS_COMPAT_FEATURE(inode->i_sb,
> +					    EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {

Instead of making all of the internal checks dependent upon the on-disk
HAS_JOURNAL flag, it should instead check sbi->s_journal == NULL.  Not
only is that faster (one less pointer deref each time, and no swabbing)
but it would also allow e.g. to mount the filesystem with a "journal=none"
option and check this only in ext4_fill_super().  It also avoids the extra
complication that COMPAT_HAS_JOURNAL can be set on a mounted filesystem
by tune2fs in order to enable journaling on the next reboot (needed to
upgrade ext2->ext3/4 on the root filesystem.

The rest of the ext4 code should never check whether COMPAT_HAS_JOURNAL
is set or not.

> -		err = ext4_journal_stop(handle);
> +		err = ext4_journal_stop(inode->i_sb, handle);

For journal functions it is traditional to put the "handle" argument first
(should we actually need to do this).

> @@ -3311,7 +3315,7 @@ static void ext4_free_branches(handle_t 
> -	if (is_handle_aborted(handle))
> +	if (handle && is_handle_aborted(handle))

This should be wrapped in ext4_handle_is_aborted(handle) that returns 0
if handle == NULL.

> @@ -3381,11 +3385,13 @@ static void ext4_free_branches(handle_t 
>  			 * will merely complain about releasing a free block,
>  			 * rather than leaking blocks.
>  			 */
> +			if (handle) {
> +				if (is_handle_aborted(handle))
> +					return;
> +				if (try_to_extend_transaction(handle, inode)) {
> +					ext4_mark_inode_dirty(handle, inode);
> +					ext4_journal_test_restart(handle, inode);
> +				}

Instead, please put a check into try_to_extend_transaction() that returns 0
if handle == NULL.  Calling it ext4_try_to_extend_transaction() wouldn't hurt.

> @@ -4196,6 +4204,23 @@ int ext4_write_inode(struct inode *inode
> +int __ext4_write_dirty_metadata(struct inode *inode, struct buffer_head *bh)
> +{
> +	mark_buffer_dirty(bh);
> +	if (inode && inode_needs_sync(inode)) {
> +		sync_dirty_buffer(bh);
> +		if (buffer_req(bh) && !buffer_uptodate(bh)) {
> +			printk ("IO error syncing ext4 inode [%s:%08lx]\n",
> +				inode->i_sb->s_id,
> +				(unsigned long) inode->i_ino);

This should be an ext4_error().  Any error that involves filesystem metadata
needs to use ext4_error(), though not file data errors.

> @@ -4283,9 +4308,10 @@ int ext4_setattr(struct dentry *dentry, 
> +		if (EXT4_HAS_COMPAT_FEATURE(inode->i_sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL) &&
> +		    ext4_should_order_data(inode)) {

The ext4_should_order_data() code can just return 0 if
EXT4_SB(inode->i_sb)->sb_journal == NULL.

>  void ext4_dirty_inode(struct inode *inode)
>  {
> +	handle_t *current_handle = ext4_journal_current_handle(inode->i_sb);
> +	if (!current_handle) {
> +	handle_t *current_handle = ext4_journal_current_handle(inode->i_sb);

Wouldn't ext4_journal_current_handle() just return NULL always for an
unjournalled ext4 filesystem?  Unfortunately, I can't see what "sb" is
used for because your patch doesn't include the ext4_journal_current_handle()
code.

One option is to start with a wrapper like "ext4_handle_valid(handle)"
instead of checking "handle == NULL" everywhere.  Then, we could put
a magic value into "handle" and current->journal_info (maybe the
the ext3_sb_info pointer).  Put a magic value at the start of ext4_sb_info
that can be validated as never belonging to a journal handle, and then you
don't need to pass "sb" everywhere.  It also allows you to distinguish
between the "no handle was ever started" case and "running unjournalled".


In any case, I'm not sure if this code is completely correct, since the
previous code allowed calling ext4_dirty_inode() without first starting
a journal handle, and now it would just silently do nothing and cause
filesystem corruption for the journalled case.

> @@ -4673,7 +4705,7 @@ int ext4_change_inode_journal_flag(struc
>  
>  	err = ext4_mark_inode_dirty(handle, inode);
>  	handle->h_sync = 1;

Isn't this missing a handle != NULL check?  This is called from ext4_ioctl()
with EXT4_IOC_SETFLAGS, and it should still be possible to set the "+j"
inode flag even if the filesystem is unjournaled.

> @@ -4478,13 +4480,15 @@ ext4_mb_free_metadata(handle_t *handle, 
>  	struct ext4_free_metadata *md;
>  	int i;
>  
> +	BUG_ON(!handle);
>  	BUG_ON(e4b->bd_bitmap_page == NULL);
>  	BUG_ON(e4b->bd_buddy_page == NULL);
>  
>  	ext4_lock_group(sb, group);
>  	for (i = 0; i < count; i++) {
> +		int htid = handle->h_transaction->t_tid;
>  		md = db->bb_md_cur;
> -		if (md && db->bb_tid != handle->h_transaction->t_tid) {
> +		if (md && db->bb_tid != htid) {
>  			db->bb_md_cur = NULL;
>  			md = NULL;
>  		}

I think Ted just re-wrote this code.

> @@ -60,7 +60,8 @@ static int finish_range(handle_t *handle
>  	/*
>  	 * Make sure the credit we accumalated is not really high
>  	 */
> -	if (needed && handle->h_buffer_credits >= EXT4_RESERVE_TRANS_BLOCKS) {
> +	if (needed && handle &&
> +	    handle->h_buffer_credits >= EXT4_RESERVE_TRANS_BLOCKS) {

All of the functions here should use ext4_handle_has_enough_credits().

> +int __ext4_journal_stop(const char *where, struct super_block *sb, handle_t *handle)
>  {
> +	if (!handle ||
> +	    !(EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL)))
> +		return 0;
> +
> +	BUG_ON(sb != handle->h_transaction->t_journal->j_private);

Couldn't this just check for handle == NULL and return, instead of changing
all of the callsites?

> @@ -214,8 +224,10 @@ static void ext4_handle_error(struct sup
> -		if (journal)
> +		if (journal) {
> +			BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));

You can't BUG_ON() data that is stored on disk.  This should be only checking
the in-memory sbi->s_journal data, as previously discussed.


> @@ -503,8 +519,13 @@ static void ext4_put_super(struct super_
> +	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {
> +		BUG_ON(sbi->s_journal == NULL);
> +		jbd2_journal_destroy(sbi->s_journal);
> +		sbi->s_journal = NULL;
> +	} else {
> +		BUG_ON(sbi->s_journal != NULL);
> +	}

Should only check sbi->s_journal != NULL.

> @@ -1473,13 +1497,15 @@ static int ext4_setup_super(struct super
> +	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {
> +		if (EXT4_SB(sb)->s_journal->j_inode == NULL) {
> +			char b[BDEVNAME_SIZE];
>  
> +			printk("external journal on %s\n",
> +				bdevname(EXT4_SB(sb)->s_journal->j_dev, b));
> +		} else {
> +			printk("internal journal\n");
> +		}

I'd prefer this message be kept, and just print "no journal" in this case.

> @@ -2044,9 +2070,12 @@ static int ext4_fill_super(struct super_
>  	if (!(le32_to_cpu(es->s_flags) & EXT2_FLAGS_TEST_FILESYS)) {
> +		/* As a temp hack, don't give up when there is no journal */
> +		if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {
> +			printk(KERN_WARNING "EXT4-fs: %s: not marked "
> +			       "OK to use with test code.\n", sb->s_id);
> +			goto failed_mount;
> +		}

I don't understand this - it means "if filesystem is not a test filesystem,
but the journal exists fail the mount"?  It should rather be the reverse:

	if (!(le32_to_cpu(es->s_flags) & EXT2_FLAGS_TEST_FILESYS)) {
		/* Unjournalled usage is only allowed for test filesystems */
		if (!EXT4_HAS_COMPAT_FEATURE(sb,
					     EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {
			printk(KERN_WARNING "EXT4-fs: %s: not marked "
			       "OK to use with test code.\n", sb->s_id);
			goto failed_mount;
		}

> @@ -2333,7 +2362,12 @@ static int ext4_fill_super(struct super_
> +		// ISSUE: do we need to do anything else here?
> +		clear_opt(sbi->s_mount_opt, DATA_FLAGS);
> +		  set_opt(sbi->s_mount_opt, WRITEBACK_DATA);

(style) please fix indenting.

This should probably clear the s_mount_state VALID_FS flag in the superblock,
like ext2 does in ext2_setup_super->ext2_write_super()

> @@ -2470,7 +2508,8 @@ static int ext4_fill_super(struct super_
> -	ext4_mb_init(sb, needs_recovery);
> +	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL))
> +		ext4_mb_init(sb, needs_recovery);

mballoc has nothing to do with journaling, I'm not sure why this is here.
The "needs_recovery" parameter is likely a hold-over from when mballoc
stored state on disk instead of recomputing the buddy bitmaps each mount.

> @@ -2482,8 +2521,12 @@ cantfind_ext4:
> +	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {
> +		jbd2_journal_destroy(sbi->s_journal);
> +		sbi->s_journal = NULL;
> +	} else {
> +		BUG_ON(sbi->s_journal != NULL);
> +	}

I'd personally just prefer this to be simpler, since it is concievable that
e.g. some kind of superblock corruption during journal recovery results in
the COMPAT_HAS_JOURNAL flag being cleared.  Instead a more foolproof code:

	if (sbi->s_journal != NULL) {
		jbd2_journal_destroy(sbi->s_journal);
		sbi->s_journal = NULL;
	}

> @@ -2535,6 +2580,8 @@ static journal_t *ext4_get_journal(struc
>  	struct inode *journal_inode;
>  	journal_t *journal;
>  
> +	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));

This would break ext4_create_journal() because the COMPAT_HAS_JOURNAL flag
is only set afterward.

> @@ -2756,6 +2807,8 @@ static int ext4_create_journal(struct su
>  
> +	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));

This is also broken, because the whole point of ext4_create_journal()
is to create a new journal file on an existing ext2 filesystem, and
the COMPAT_HAS_JOURNAL flag is not set until this happens successfully.

To be honest, we could just get rid of ext4_create_journal().  This was
a very old way of upgrading an ext2 filesystem to ext4 before tune2fs
could do this.  That this code sets COMPAT flags from within the ext4
code is frowned upon these days also (this should be done by the admin
with tune2fs).

>  static void ext4_write_super(struct super_block *sb)
>  {
> +	if(EXT4_SB(sb)->s_journal) {

(style) Please put space between "if" and "(".

> +	}
> +	else
> +		ext4_commit_super(sb, EXT4_SB(sb)->s_es, 1);

(style) Should be:
	} else {
		ext4_commit_super(sb, EXT4_SB(sb)->s_es, 1);
	}

> @@ -2925,9 +2998,13 @@ static void ext4_write_super_lockfs(stru
> +		} else {
> +			BUG_ON(EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));

Please wrap all code at 80 columns.

> @@ -3429,7 +3517,8 @@ static ssize_t ext4_quota_write(struct s
>  	struct buffer_head *bh;
>  	handle_t *handle = journal_current_handle();

This is a defect - it should call ext4_journal_current_handle() I think.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

