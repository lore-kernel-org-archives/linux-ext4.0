From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [Ext4 Secure Delete 7/7v4] ext4/jbd2: Secure Delete: Secure
	delete journal blocks
Date: Fri, 7 Oct 2011 13:58:18 -0700
Message-ID: <20111007205818.GJ12447@tux1.beaverton.ibm.com>
References: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com> <1317971465-8517-8-git-send-email-achender@linux.vnet.ibm.com> <20111007183531.GI12447@tux1.beaverton.ibm.com> <4E8F5932.5060704@linux.vnet.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E8F5932.5060704@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 07, 2011 at 12:55:30PM -0700, Allison Henderson wrote:
> On 10/07/2011 11:35 AM, Darrick J. Wong wrote:
>> On Fri, Oct 07, 2011 at 12:11:05AM -0700, Allison Henderson wrote:
>>> This patch modifies both ext4 and jbd2 such that the journal
>>> blocks which may contain file data, are securely deleted
>>> after the files data blocks are deleted.
>>>
>>> Because old journal blocks may contain file data, we need
>>> a way to find those blocks again when it comes time to secure
>>> delete the file.  This patch adds a new list to the journal
>>> structure to keep track of which vfs blocks the journal blocks
>>> contain.
>>>
>>> After a truncate or a punch hole operation has completed, a
>>> new function ext4_secure_delete_jblks is called that flushes
>>> the journal, and then searches the list for any journal blocks
>>> that were used to journal the blocks that were just removed.
>>> The found journal blocks are then secure deleted.
>>>
>>> Signed-off-by: Allison Henderson<achender@linux.vnet.ibm.com>
>>> ---
>>> :100644 100644 0cba63b... fdf73b5... M	fs/ext4/ext4.h
>>> :100644 100644 984fac2... 81df943... M	fs/ext4/extents.c
>>> :100644 100644 bd1facd... 083c516... M	fs/ext4/inode.c
>>> :100644 100644 eef6979... 2734e7b... M	fs/jbd2/commit.c
>>> :100644 100644 f24df13... 6dd8af7... M	fs/jbd2/journal.c
>>> :100644 100644 38f307b... 8b84b43... M	include/linux/jbd2.h
>>>   fs/ext4/ext4.h       |    3 +
>>>   fs/ext4/extents.c    |   12 +++++
>>>   fs/ext4/inode.c      |  110 +++++++++++++++++++++++++++++++++++++++++++++++++
>>>   fs/jbd2/commit.c     |    6 +++
>>>   fs/jbd2/journal.c    |  112 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>>   include/linux/jbd2.h |   21 +++++++++
>>>   6 files changed, 264 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>>> index 0cba63b..fdf73b5 100644
>>> --- a/fs/ext4/ext4.h
>>> +++ b/fs/ext4/ext4.h
>>> @@ -2230,6 +2230,9 @@ extern int ext4_secure_delete_lblks(struct inode *inode,
>>>   			ext4_lblk_t first_block, unsigned long count);
>>>   extern int ext4_secure_delete_pblks(struct inode *inode,
>>>   			ext4_fsblk_t block, unsigned long count);
>>> +extern int ext4_secure_delete_jblks(struct inode *inode,
>>> +				ext4_lblk_t first_block, unsigned long count);
>>> +
>>>
>>>   /* move_extent.c */
>>>   extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
>>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>>> index 984fac2..81df943 100644
>>> --- a/fs/ext4/extents.c
>>> +++ b/fs/ext4/extents.c
>>> @@ -4159,6 +4159,7 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
>>>   	struct super_block *sb = inode->i_sb;
>>>   	struct ext4_ext_cache cache_ex;
>>>   	ext4_lblk_t first_block, last_block, num_blocks, iblock, max_blocks;
>>> +	ext4_lblk_t first_secrm_blk, last_secrm_blk, secrm_blk_count;
>>>   	struct address_space *mapping = inode->i_mapping;
>>>   	struct ext4_map_blocks map;
>>>   	handle_t *handle;
>>> @@ -4317,6 +4318,17 @@ out:
>>>   	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
>>>   	ext4_mark_inode_dirty(handle, inode);
>>>   	ext4_journal_stop(handle);
>>> +
>>> +	if (!err&&  EXT4_I(inode)->i_flags&  EXT4_SECRM_FL) {
>>> +		first_secrm_blk = offset>>  EXT4_BLOCK_SIZE_BITS(sb);
>>> +		last_secrm_blk = (offset + length + sb->s_blocksize - 1)>>
>>> +			EXT4_BLOCK_SIZE_BITS(sb);
>>> +		secrm_blk_count = last_secrm_blk - first_secrm_blk;
>>> +
>>> +		err = ext4_secure_delete_jblks(inode,
>>> +		   first_secrm_blk, secrm_blk_count);
>>> +	}
>>> +
>>>   	return err;
>>>   }
>>>   int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>> index bd1facd..083c516 100644
>>> --- a/fs/ext4/inode.c
>>> +++ b/fs/ext4/inode.c
>>> @@ -909,6 +909,110 @@ int ext4_secure_delete_lblks(struct inode *inode, ext4_lblk_t first_block,
>>>   	return err;
>>>   }
>>>
>>> +/*
>>> + * ext4_secure_delete_jblks()
>>> + *
>>> + * Secure deletes the journal blocks that contain
>>> + * the specified logical blocks
>>> + *
>>> + * @inode: The files inode
>>> + * @first_block: Starting logical block
>>> + * @count: The number of blocks to secure delete
>>> + *         from the journal
>>> + *
>>> + * Returns 0 on sucess or negative on error
>>> + */
>>> +int ext4_secure_delete_jblks(struct inode *inode,
>>> +				ext4_lblk_t first_block, unsigned long count){
>>> +
>>> +	unsigned long long jbd2_pblk_start = 0;
>>> +	unsigned long long jbd2_pblk_count = 0;
>>> +	ext4_lblk_t last_block = 0;
>>> +	struct list_head *tmp = NULL;
>>> +	struct list_head *cur = NULL;
>>> +	struct jbd2_blk_pair *b_pair = NULL;
>>> +	int err = 0;
>>> +	journal_t *journal = EXT4_JOURNAL(inode);
>>> +
>>> +	/* Do not allow last_block to wrap */
>>> +	last_block = first_block + count;
>>> +	if (last_block<  first_block)
>>> +		last_block = EXT_MAX_BLOCKS;
>>> +
>>> +	/*
>>> +	 * Force the journal to finnish up any pending transactions
>>> +	 * before we start secure deleteing journal blocks
>>> +	 */
>>> +	err = ext4_force_commit((inode)->i_sb);
>>> +	if (err)
>>> +		return err;
>>> +
>>> +	spin_lock(&journal->j_pair_lock);
>>> +
>>> +	/* Loop over the journals blocks looking for our logical blocks */
>>> +	list_for_each_safe(cur, tmp,&journal->blk_pairs) {
>>> +		b_pair = list_entry(cur, struct jbd2_blk_pair, list);
>>
>> Um.... I don't think ext4 should be accessing journal internals.  At a bare
>> minimum the stuff that mucks around with jbd2 ought to be in fs/jbd2 and
>> the ext4 parts stuffed in a wrapper in ext4_jbd2.[ch], since ocfs2 also uses
>> jbd2.
>
> Ok, I can move the looping the jbd2 and set up a call back for doing the  
> actual secure deleting
>
>>
>> I'm also wondering -- this logical<->  journal block mapping doesn't seem to be
>> committed to disk anywhere.  What happens if jbd2 crashes before we get to
>> zeroing journal blocks?  Specifically, would the journal recovery code know
>> that a given journal block also needs secure deletion?
>>
>> Here's a counterproposal: What if ext4 told jbd2 which blocks need to be
>> securely deleted while ext4 is creating the transactions?  jbd2 could then set
>> a JBD2_FLAG_SECURE_DELETE flag in journal_block_tag_t.t_flags (the descriptor
>> block), which would tell the recovery and commit code that the associated
>> journal block needs secure deletion when processing is complete.  I _think_ you
>> could just extend the functions called by ext4_jbd2.c to take a flags
>> parameter.  Does this sound better?  Or even sane? :)
>>
>> (Not sure if ocfs2 cares about secure delete at all.)
>>
>> --D
>>
>
> Well actually I had initially started out with something that tried to  
> do the secure delete when the transactions had completed, but it didnt  
> work out because most of the time the transactions had already long  
> since completed before the secure delete flag even gets turned on. And  

Ahh, I see, you're concerned that:

$ touch /mnt/afile		# A
$ sync
$ chattr +s /mnt/afile
$ rm -rf /mnt/afile

...doesn't secure delete the journal blocks associated with the inode creation
in step A, because one cannot create files with the secure deletion flag set.
I could think of a few ways out of this...

0) Simply accept that there's no way to create files with "secure delete" set;
therefore, the inode creation and dir entry creation will always be hanging out
in the journal.  This requires users to notice this little detail and get the
following details correct: if filenames are important, then they'll have to
create the file with a bogus name, chattr +s, create a hard link with the real
name, and then unlink the first bogus name. (ha ha....)

1) When creating a file, lie to the journal by always telling it to securely
delete the blocks associated with the file create.  If the user really wants
secure deletion, the next step after creating the file ought to be setting the
+s flag.  This has the advantage that even the generic "new inode" contents are
also protected by secure deletion, which #0 doesn't provide.  However, we'd
take a speed hit for a feature that isn't necessarily the common case.

2) Teach the journal to keep track of the pblocks and go back and retroactively
delete older copies, sort of like what your current patch does.

As a side note, we could probably discard journal blocks when the transaction
finishes committing and flushing.

> then when we turn on the flag and start deleting, I have to get those  
> old journal blocks back.  So I think the new idea might have the same  
> problem.  But I think your right about needing to somehow commit it to  
> the disk, otherwise those old journal blocks will still be there after a  
> crash.



--D

