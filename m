From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 15/16] ext4: Calculate and verify superblock checksum
Date: Fri, 2 Sep 2011 11:40:32 -0700
Message-ID: <20110902184032.GE12086@tux1.beaverton.ibm.com>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com> <20110901003214.31048.36055.stgit@elm3c44.beaverton.ibm.com> <2882FBB2-797C-4D27-8569-B6826DD34F68@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2882FBB2-797C-4D27-8569-B6826DD34F68@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 01, 2011 at 01:52:43AM -0600, Andreas Dilger wrote:
> On 2011-08-31, at 6:32 PM, Darrick J. Wong wrote:
> > Calculate and verify the superblock checksum.  Since the UUID and block group
> > number are embedded in each copy of the superblock, we need only checksum the
> > entire block.  Refactor some of the code to eliminate open-coding of the
> > checksum update call.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> > ---
> > fs/ext4/ext4.h      |    8 +++++++-
> > fs/ext4/ext4_jbd2.c |    9 ++++++++-
> > fs/ext4/ext4_jbd2.h |    7 +++++--
> > fs/ext4/inode.c     |    3 +--
> > fs/ext4/namei.c     |    4 ++--
> > fs/ext4/resize.c    |    6 +++++-
> > fs/ext4/super.c     |   43 +++++++++++++++++++++++++++++++++++++++++++
> > 7 files changed, 71 insertions(+), 9 deletions(-)
> > 
> > 
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index b7aa5b5..1e93410 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -1067,7 +1067,9 @@ struct ext4_super_block {
> > 	__u8	s_last_error_func[32];	/* function where the error happened */
> > #define EXT4_S_ERR_END offsetof(struct ext4_super_block, s_mount_opts)
> > 	__u8	s_mount_opts[64];
> > -	__le32	s_reserved[112];        /* Padding to the end of the block */
> > +	__u32	s_reserved1[3];		/* Padding */
> 
> Rather than mark these as reserved, it would be better to fill in the
> intended field names so that there is no confusion later on.  I believe
> that there is s_usr_quota_inum and s_grp_quota_inum immediately following
> s_mount_opts, but I'm not sure what the 3rd reserved field is for.

"s_overhead_blocks", which I think is somehow related to bigalloc.  They
haven't appeared in the kernel yet, which made me wary of adding fields that
aren't used by this patchset.

> > +	__u32	s_checksum;		/* crc32c(superblock) */
> > +	__le32	s_reserved2[108];       /* Padding to the end of the block */
> > };
> > 
> > #define EXT4_S_ERR_LEN (EXT4_S_ERR_END - EXT4_S_ERR_START)
> > @@ -1901,6 +1903,10 @@ extern int ext4_group_extend(struct super_block *sb,
> > 				ext4_fsblk_t n_blocks_count);
> > 
> > /* super.c */
> > +extern int ext4_superblock_csum_verify(struct super_block *sb,
> > +				       struct ext4_super_block *es);
> > +extern void ext4_superblock_csum_set(struct super_block *sb,
> > +				     struct ext4_super_block *es);
> > extern void *ext4_kvmalloc(size_t size, gfp_t flags);
> > extern void *ext4_kvzalloc(size_t size, gfp_t flags);
> > extern void ext4_kvfree(void *ptr);
> > diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> > index f5240aa..04ddc97 100644
> > --- a/fs/ext4/ext4_jbd2.c
> > +++ b/fs/ext4/ext4_jbd2.c
> > @@ -136,16 +136,23 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
> > }
> > 
> > int __ext4_handle_dirty_super(const char *where, unsigned int line,
> > -			      handle_t *handle, struct super_block *sb)
> > +			      handle_t *handle, struct super_block *sb,
> > +			      int now)
> > {
> > 	struct buffer_head *bh = EXT4_SB(sb)->s_sbh;
> > 	int err = 0;
> > 
> > 	if (ext4_handle_valid(handle)) {
> > +		ext4_superblock_csum_set(sb,
> > +				(struct ext4_super_block *)bh->b_data);
> > 		err = jbd2_journal_dirty_metadata(handle, bh);
> > 		if (err)
> > 			ext4_journal_abort_handle(where, line, __func__,
> > 						  bh, handle, err);
> > +	} else if (now) {
> > +		ext4_superblock_csum_set(sb,
> > +				(struct ext4_super_block *)bh->b_data);
> > +		mark_buffer_dirty(bh);
> > 	} else
> > 		sb->s_dirt = 1;
> > 	return err;
> > diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> > index 5802fa1..ed9b78d 100644
> > --- a/fs/ext4/ext4_jbd2.h
> > +++ b/fs/ext4/ext4_jbd2.h
> > @@ -141,7 +141,8 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
> > 				 struct buffer_head *bh);
> > 
> > int __ext4_handle_dirty_super(const char *where, unsigned int line,
> > -			      handle_t *handle, struct super_block *sb);
> > +			      handle_t *handle, struct super_block *sb,
> > +			      int now);
> > 
> > #define ext4_journal_get_write_access(handle, bh) \
> > 	__ext4_journal_get_write_access(__func__, __LINE__, (handle), (bh))
> > @@ -153,8 +154,10 @@ int __ext4_handle_dirty_super(const char *where, unsigned int line,
> > #define ext4_handle_dirty_metadata(handle, inode, bh) \
> > 	__ext4_handle_dirty_metadata(__func__, __LINE__, (handle), (inode), \
> > 				     (bh))
> > +#define ext4_handle_dirty_super_now(handle, sb) \
> > +	__ext4_handle_dirty_super(__func__, __LINE__, (handle), (sb), 1)
> > #define ext4_handle_dirty_super(handle, sb) \
> > -	__ext4_handle_dirty_super(__func__, __LINE__, (handle), (sb))
> > +	__ext4_handle_dirty_super(__func__, __LINE__, (handle), (sb), 0)
> > 
> > handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks);
> > int __ext4_journal_stop(const char *where, unsigned int line, handle_t *handle);
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index e24ba98..52e9b67 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -3761,8 +3761,7 @@ static int ext4_do_update_inode(handle_t *handle,
> > 					EXT4_FEATURE_RO_COMPAT_LARGE_FILE);
> > 			sb->s_dirt = 1;
> > 			ext4_handle_sync(handle);
> > -			err = ext4_handle_dirty_metadata(handle, NULL,
> > -					EXT4_SB(sb)->s_sbh);
> > +			err = ext4_handle_dirty_super_now(handle, sb);
> > 		}
> > 	}
> > 	raw_inode->i_generation = cpu_to_le32(inode->i_generation);
> > diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> > index 2d0fdb9..5ebf281 100644
> > --- a/fs/ext4/namei.c
> > +++ b/fs/ext4/namei.c
> > @@ -2407,7 +2407,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
> > 	/* Insert this inode at the head of the on-disk orphan list... */
> > 	NEXT_ORPHAN(inode) = le32_to_cpu(EXT4_SB(sb)->s_es->s_last_orphan);
> > 	EXT4_SB(sb)->s_es->s_last_orphan = cpu_to_le32(inode->i_ino);
> > -	err = ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
> > +	err = ext4_handle_dirty_super_now(handle, sb);
> > 	rc = ext4_mark_iloc_dirty(handle, inode, &iloc);
> > 	if (!err)
> > 		err = rc;
> > @@ -2480,7 +2480,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
> > 		if (err)
> > 			goto out_brelse;
> > 		sbi->s_es->s_last_orphan = cpu_to_le32(ino_next);
> > -		err = ext4_handle_dirty_metadata(handle, NULL, sbi->s_sbh);
> > +		err = ext4_handle_dirty_super_now(handle, inode->i_sb);
> > 	} else {
> > 		struct ext4_iloc iloc2;
> > 		struct inode *i_prev =
> > diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> > index 707d3f1..2ad7008 100644
> > --- a/fs/ext4/resize.c
> > +++ b/fs/ext4/resize.c
> > @@ -511,7 +511,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
> > 	ext4_kvfree(o_group_desc);
> > 
> > 	le16_add_cpu(&es->s_reserved_gdt_blocks, -1);
> > -	err = ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
> > +	err = ext4_handle_dirty_super_now(handle, sb);
> > 	if (err)
> > 		ext4_std_error(sb, err);
> > 
> > @@ -682,6 +682,8 @@ static void update_backups(struct super_block *sb,
> > 		goto exit_err;
> > 	}
> > 
> > +	ext4_superblock_csum_set(sb, (struct ext4_super_block *)data);
> > +
> > 	while ((group = ext4_list_backups(sb, &three, &five, &seven)) < last) {
> > 		struct buffer_head *bh;
> > 
> > @@ -925,6 +927,8 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
> > 	/* Update the global fs size fields */
> > 	sbi->s_groups_count++;
> > 
> > +	ext4_superblock_csum_set(sb,
> > +				 (struct ext4_super_block *)primary->b_data);
> > 	err = ext4_handle_dirty_metadata(handle, NULL, primary);
> > 	if (unlikely(err)) {
> > 		ext4_std_error(sb, err);
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 44d0c8d..b254274 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -38,6 +38,7 @@
> > #include <linux/ctype.h>
> > #include <linux/log2.h>
> > #include <linux/crc16.h>
> > +#include <linux/crc32c.h>
> > #include <linux/cleancache.h>
> > #include <asm/uaccess.h>
> > 
> > @@ -110,6 +111,41 @@ static struct file_system_type ext3_fs_type = {
> > #define IS_EXT3_SB(sb) (0)
> > #endif
> > 
> > +static __le32 ext4_superblock_csum(struct super_block *sb,
> > +				   struct ext4_super_block *es)
> > +{
> > +	int offset = offsetof(struct ext4_super_block, s_checksum);
> > +	__u32 crc = 0;
> > +
> > +	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
> > +					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> > +		return 0;
> > +
> > +	crc = crc32c_le(~0, (char *)es, offset);
> 
> For consistency, shouldn't this also checksum the fields _after_ offset?
> Otherwise, if new fields are used after s_checksum the update to this
> function may easily be missed, and those new fields would not be covered
> by the checksum.  It also means the superblock checksum would be different
> based on which kernel is being used (based on which fields it knows about.

Actually, I had pondered putting the checksum at the very end of the 1k
superblock, which makes the checksum cover the padding too.  On the other hand,
I thought I might save us ~400b of crc32c computation time.  I don't have a big
objection to crc'ing all the padding.

--D
> 
> > +
> > +	return cpu_to_le32(crc);
> > +}
> > +
> > +int ext4_superblock_csum_verify(struct super_block *sb,
> > +				struct ext4_super_block *es)
> > +{
> > +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
> > +				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
> > +	    (es->s_checksum != ext4_superblock_csum(sb, es)))
> > +		return 0;
> > +	return 1;
> > +}
> > +
> > +void ext4_superblock_csum_set(struct super_block *sb,
> > +			      struct ext4_super_block *es)
> > +{
> > +	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
> > +		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> > +		return;
> > +
> > +	es->s_checksum = ext4_superblock_csum(sb, es);
> > +}
> > +
> > void *ext4_kvmalloc(size_t size, gfp_t flags)
> > {
> > 	void *ret;
> > @@ -3151,6 +3187,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
> > 	sb->s_magic = le16_to_cpu(es->s_magic);
> > 	if (sb->s_magic != EXT4_SUPER_MAGIC)
> > 		goto cantfind_ext4;
> > +	if (!ext4_superblock_csum_verify(sb, es)) {
> > +		ext4_msg(sb, KERN_ERR, "VFS: Found ext4 filesystem with "
> > +			 "invalid superblock checksum.  Run e2fsck?");
> > +		silent = 1;
> > +		goto cantfind_ext4;
> > +	}
> > 	sbi->s_kbytes_written = le64_to_cpu(es->s_kbytes_written);
> > 
> > 	/* Set defaults before we parse the mount options */
> > @@ -4107,6 +4149,7 @@ static int ext4_commit_super(struct super_block *sb, int sync)
> > 				&EXT4_SB(sb)->s_freeinodes_counter));
> > 	sb->s_dirt = 0;
> > 	BUFFER_TRACE(sbh, "marking dirty");
> > +	ext4_superblock_csum_set(sb, es);
> > 	mark_buffer_dirty(sbh);
> > 	if (sync) {
> > 		error = sync_dirty_buffer(sbh);
> > 
> 
