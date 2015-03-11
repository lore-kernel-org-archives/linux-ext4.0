From: Beata Michalska <b.michalska@samsung.com>
Subject: Re: [RFC] ext4: Add pollable sysfs entry for block threshold events
Date: Wed, 11 Mar 2015 17:45:52 +0100
Message-ID: <55007140.6060700@samsung.com>
References: <1426068993-1051-1-git-send-email-b.michalska@samsung.com>
 <1426068993-1051-2-git-send-email-b.michalska@samsung.com>
 <alpine.LFD.2.00.1503111314230.11156@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kyungmin.park@samsung.com
To: =?ISO-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <alpine.LFD.2.00.1503111314230.11156@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

On 03/11/2015 03:12 PM, Luk=E1=B9 Czerner wrote:
> On Wed, 11 Mar 2015, Beata Michalska wrote:
>=20
>> Date: Wed, 11 Mar 2015 11:16:33 +0100
>> From: Beata Michalska <b.michalska@samsung.com>
>> To: tytso@mit.edu, adilger.kernel@dilger.ca
>> Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
>>     kyungmin.park@samsung.com
>> Subject: [RFC] ext4: Add pollable sysfs entry for block threshold ev=
ents
>>
>> Add support for pollable sysfs entry for logical blocks
>> threshold, allowing the userspace to wait for
>> the notification whenever the threshold is reached
>> instead of periodically calling the statfs.
>> This is supposed to work as a single-shot notifiaction
>> to reduce the number of triggered events.
>=20
> Hi,
>=20
> I though you were advocating for a solution independent on the file
> system. This is ext4 only solution, but I do not really have
> anything against this.
>=20

I definitely was/am, but again, that would be an ideal case.
Until we work out some sensible solution, possibly based on your idea y=
ou
have mentioned in another thread, I guess we have to stick to
what we've got. The ext4 is within our interest, thus the changes propo=
sed.

> However I do have couple of comments. First of all you should add
> some documentation for the new sysfs file into
> Documentation/filesystems/ext4.txt and describe how are you supposed
> to use this.
>=20
> Also I can see that you introduced ext4_mark_group_tainted() helper,
> preferably this should go into a separate patch.
>=20

Consider it done for the v2.

> More comments below.
>=20
>>
>> Signed-off-by: Beata Michalska <b.michalska@samsung.com>
>> ---
>>  fs/ext4/balloc.c  |   17 ++++-------------
>>  fs/ext4/ext4.h    |   12 ++++++++++++
>>  fs/ext4/ialloc.c  |    5 +----
>>  fs/ext4/inode.c   |    2 +-
>>  fs/ext4/mballoc.c |   14 ++++----------
>>  fs/ext4/resize.c  |    3 ++-
>>  fs/ext4/super.c   |   52 ++++++++++++++++++++++++++++++++++++++++++=
++++++++--
>>  7 files changed, 74 insertions(+), 31 deletions(-)
>>
>> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
>> index 83a6f49..bf4a669 100644
>> --- a/fs/ext4/balloc.c
>> +++ b/fs/ext4/balloc.c
>> @@ -193,10 +193,7 @@ static int ext4_init_block_bitmap(struct super_=
block *sb,
>>  	 * essentially implementing a per-group read-only flag. */
>>  	if (!ext4_group_desc_csum_verify(sb, block_group, gdp)) {
>>  		grp =3D ext4_get_group_info(sb, block_group);
>> -		if (!EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
>> -			percpu_counter_sub(&sbi->s_freeclusters_counter,
>> -					   grp->bb_free);
>> -		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
>> +		ext4_mark_group_tainted(sbi, grp);
>>  		if (!EXT4_MB_GRP_IBITMAP_CORRUPT(grp)) {
>>  			int count;
>>  			count =3D ext4_free_inodes_count(sb, gdp);
>> @@ -252,7 +249,7 @@ unsigned ext4_free_clusters_after_init(struct su=
per_block *sb,
>>  				       ext4_group_t block_group,
>>  				       struct ext4_group_desc *gdp)
>>  {
>> -	return num_clusters_in_group(sb, block_group) -=20
>> +	return num_clusters_in_group(sb, block_group) -
>>  		ext4_num_overhead_clusters(sb, block_group, gdp);
>>  }
>> =20
>> @@ -379,20 +376,14 @@ static void ext4_validate_block_bitmap(struct =
super_block *sb,
>>  		ext4_unlock_group(sb, block_group);
>>  		ext4_error(sb, "bg %u: block %llu: invalid block bitmap",
>>  			   block_group, blk);
>> -		if (!EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
>> -			percpu_counter_sub(&sbi->s_freeclusters_counter,
>> -					   grp->bb_free);
>> -		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
>> +		ext4_mark_group_tainted(sbi, grp);
>>  		return;
>>  	}
>>  	if (unlikely(!ext4_block_bitmap_csum_verify(sb, block_group,
>>  			desc, bh))) {
>>  		ext4_unlock_group(sb, block_group);
>>  		ext4_error(sb, "bg %u: bad block bitmap checksum", block_group);
>> -		if (!EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
>> -			percpu_counter_sub(&sbi->s_freeclusters_counter,
>> -					   grp->bb_free);
>> -		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
>> +		ext4_mark_group_tainted(sbi, grp);
>>  		return;
>>  	}
>>  	set_buffer_verified(bh);
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index f63c3d5..ee911b7 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -1309,6 +1309,7 @@ struct ext4_sb_info {
>>  	unsigned long s_sectors_written_start;
>>  	u64 s_kbytes_written;
>> =20
>> +	atomic64_t block_thres_event;
>>  	/* the size of zero-out chunk */
>>  	unsigned int s_extent_max_zeroout_kb;
>> =20
>> @@ -2207,6 +2208,7 @@ extern int ext4_alloc_flex_bg_array(struct sup=
er_block *sb,
>>  				    ext4_group_t ngroup);
>>  extern const char *ext4_decode_error(struct super_block *sb, int er=
rno,
>>  				     char nbuf[16]);
>> +extern void ext4_block_thres_notify(struct ext4_sb_info *sbi);
>> =20
>>  extern __printf(4, 5)
>>  void __ext4_error(struct super_block *, const char *, unsigned int,
>> @@ -2535,6 +2537,16 @@ static inline spinlock_t *ext4_group_lock_ptr=
(struct super_block *sb,
>>  	return bgl_lock_ptr(EXT4_SB(sb)->s_blockgroup_lock, group);
>>  }
>> =20
>> +static inline
>> +void ext4_mark_group_tainted(struct ext4_sb_info *sbi,
>> +			     struct ext4_group_info *grp)
>=20
> Why to call this tainted since we're setting
> EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT ? It might be better just to
> call it simply ext4_mark_group_corrupted().
>=20

Agree, it might.

>> +{
>> +	if (!EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
>> +		percpu_counter_sub(&sbi->s_freeclusters_counter, grp->bb_free);
>> +	set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
>> +	ext4_block_thres_notify(sbi);
>> +}
>> +
>>  /*
>>   * Returns true if the filesystem is busy enough that attempts to
>>   * access the block group locks has run into contention.
>> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
>> index ac644c3..65336b3 100644
>> --- a/fs/ext4/ialloc.c
>> +++ b/fs/ext4/ialloc.c
>> @@ -79,10 +79,7 @@ static unsigned ext4_init_inode_bitmap(struct sup=
er_block *sb,
>>  	if (!ext4_group_desc_csum_verify(sb, block_group, gdp)) {
>>  		ext4_error(sb, "Checksum bad for group %u", block_group);
>>  		grp =3D ext4_get_group_info(sb, block_group);
>> -		if (!EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
>> -			percpu_counter_sub(&sbi->s_freeclusters_counter,
>> -					   grp->bb_free);
>> -		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
>> +		ext4_mark_group_tainted(sbi, grp);
>>  		if (!EXT4_MB_GRP_IBITMAP_CORRUPT(grp)) {
>>  			int count;
>>  			count =3D ext4_free_inodes_count(sb, gdp);
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 5cb9a21..0dfe147 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -1203,7 +1203,7 @@ static int ext4_da_reserve_space(struct inode =
*inode, ext4_lblk_t lblock)
>>  	}
>>  	ei->i_reserved_data_blocks++;
>>  	spin_unlock(&ei->i_block_reservation_lock);
>> -
>> +	ext4_block_thres_notify(sbi);
>>  	return 0;       /* success */
>>  }
>> =20
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index 8d1e602..94bef9b 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -760,10 +760,7 @@ void ext4_mb_generate_buddy(struct super_block =
*sb,
>>  		 * corrupt and update bb_free using bitmap value
>>  		 */
>>  		grp->bb_free =3D free;
>> -		if (!EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
>> -			percpu_counter_sub(&sbi->s_freeclusters_counter,
>> -					   grp->bb_free);
>> -		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
>> +		ext4_mark_group_tainted(sbi, grp);
>>  	}
>>  	mb_set_largest_free_order(sb, grp);
>> =20
>> @@ -1448,9 +1445,7 @@ static void mb_free_blocks(struct inode *inode=
, struct ext4_buddy *e4b,
>>  				      "freeing already freed block "
>>  				      "(bit %u); block bitmap corrupt.",
>>  				      block);
>> -		if (!EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info))
>> -			percpu_counter_sub(&sbi->s_freeclusters_counter,
>> -					   e4b->bd_info->bb_free);
>> +		ext4_mark_group_tainted(sbi, e4b->bd_info);
>>  		/* Mark the block group as corrupt. */
>>  		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT,
>>  			&e4b->bd_info->bb_state);
>=20
> This bit is already in your ext4_mark_group_tainted() helper.
>=20

An oversight on my side.

>> @@ -2362,7 +2357,7 @@ int ext4_mb_alloc_groupinfo(struct super_block=
 *sb, ext4_group_t ngroups)
>>  	}
>>  	sbi->s_group_info =3D new_groupinfo;
>>  	sbi->s_group_info_size =3D size / sizeof(*sbi->s_group_info);
>> -	ext4_debug("allocated s_groupinfo array for %d meta_bg's\n",=20
>> +	ext4_debug("allocated s_groupinfo array for %d meta_bg's\n",
>>  		   sbi->s_group_info_size);
>>  	return 0;
>>  }
>> @@ -2967,7 +2962,6 @@ ext4_mb_mark_diskspace_used(struct ext4_alloca=
tion_context *ac,
>>  	if (err)
>>  		goto out_err;
>>  	err =3D ext4_handle_dirty_metadata(handle, NULL, gdp_bh);
>> -
>=20
> No reason to change that.
>=20
>>  out_err:
>>  	brelse(bitmap_bh);
>>  	return err;
>> @@ -4525,8 +4519,8 @@ out:
>>  						reserv_clstrs);
>>  	}
>> =20
>> +	ext4_block_thres_notify(sbi);
>=20
> I wonder whether it would not be better to have this directly in
> ext4_claim_free_clusters() ? Or maybe even better in
> ext4_has_free_clusters() where we already have some of the counters
> you need ?
>=20
> This would avoid the overhead of calculating this again since especia=
lly
> the percpu_counter might get quite expensive.
>=20

The idea was to call the notify once all the necessary arithmetic
has been done, to get the most up-to date data. And to limit the
number of calls to notify. In both cases: ext4_claim_free_clusters
and ext4_has_free_clusters, smth might go wrong afterwards so the count=
ers
might get updated thus affecting the final outcome of ext4_block_thres_=
notify.

>>  	trace_ext4_allocate_blocks(ar, (unsigned long long)block);
>> -
>=20
> Again no reason to change that.
>=20
>>  	return block;
>>  }
>> =20
>> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
>> index 8a8ec62..7ae308b 100644
>> --- a/fs/ext4/resize.c
>> +++ b/fs/ext4/resize.c
>> @@ -1244,7 +1244,7 @@ static int ext4_setup_new_descs(handle_t *hand=
le, struct super_block *sb,
>>  	ext4_group_t			group;
>>  	__u16				*bg_flags =3D flex_gd->bg_flags;
>>  	int				i, gdb_off, gdb_num, err =3D 0;
>> -=09
>> +
>> =20
>>  	for (i =3D 0; i < flex_gd->count; i++, group_data++, bg_flags++) {
>>  		group =3D group_data->group;
>> @@ -1397,6 +1397,7 @@ static void ext4_update_super(struct super_blo=
ck *sb,
>>  	 */
>>  	ext4_calculate_overhead(sb);
>> =20
>> +	ext4_block_thres_notify(sbi);
>=20
> I wonder whether we need to do that since there is no way to shrink
> file system online, so the number of blocks should only grow.
>=20

 The decision whether to send the notification depends=20
on the total number of block vs free & dirty blocks. The counters for
two of those are being modified here - thus the call to ext4_block_thre=
s_notify.
You might be right here, this might not be needed, though I'm not sure =
we can
rule out corner cases. Guess it needs more testing.

>>  	if (test_opt(sb, DEBUG))
>>  		printk(KERN_DEBUG "EXT4-fs: added group %u:"
>>  		       "%llu blocks(%llu free %llu reserved)\n", flex_gd->count,
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index e061e66..36f00f3 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -2558,10 +2558,56 @@ static ssize_t reserved_clusters_store(struc=
t ext4_attr *a,
>>  	if (parse_strtoull(buf, -1ULL, &val))
>>  		return -EINVAL;
>>  	ret =3D ext4_reserve_clusters(sbi, val);
>> -
>> +	ext4_block_thres_notify(sbi);
>=20
> I do not think you count in reserved clusters at the moment. But
> it's definitely something you should count in.
>=20

Well, this is the difference between the free and available blocks.
AFAIK, the reserved blocks just mark the difference between those two,
and they are not being counted in as far as used blocks are being conce=
rned,
at least from the user-space perspective, though I might be missing smt=
h here.

>>  	return ret ? ret : count;
>>  }
>> =20
>> +void ext4_block_thres_notify(struct ext4_sb_info *sbi)
>> +{
>> +	struct ext4_super_block *es =3D sbi->s_es;
>> +	unsigned long long bcount, bfree;
>> +
>> +	if (!atomic64_read(&sbi->block_thres_event))
>> +		/* No limit set -> no notification needed */
>> +		return;
>> +	/* Verify the limit has not been reached. If so notify the watcher=
s */
>> +	bcount =3D ext4_blocks_count(es) - EXT4_C2B(sbi, sbi->s_overhead);
>> +	bfree =3D percpu_counter_sum_positive(&sbi->s_freeclusters_counter=
) -
>> +		percpu_counter_sum_positive(&sbi->s_dirtyclusters_counter);
>> +	bfree =3D EXT4_C2B(sbi, max_t(s64, bfree, 0));
>=20
> Hmm is it even possible to have s_dirtyclusters_counter higher than
> s_freeclusters_counter ? If so, we might have a big problem
> somewhere.
>=20
=20
Looking at the code I would agree that this should not happen, though=20
this precaution is being used by ext4_statfs, so I assume it actually
did happen (?).

>> +
>> +	if (bcount - bfree > atomic64_read(&sbi->block_thres_event)) {
>> +		sysfs_notify(&sbi->s_kobj, NULL, "block_thres_event");
>> +		/* Prevent flooding notifications */
>> +		atomic64_set(&sbi->block_thres_event, 0);
>> +	}
>> +}
>> +
>> +static ssize_t block_thres_event_show(struct ext4_attr *a,
>> +					struct ext4_sb_info *sbi, char *buf)
>> +{
>> +	return snprintf(buf, PAGE_SIZE, "%llu\n",
>> +		atomic64_read(&sbi->block_thres_event));
>> +
>> +}
>> +
>> +static ssize_t block_thres_event_store(struct ext4_attr *a,
>> +					struct ext4_sb_info *sbi,
>> +					const char *buf, size_t count)
>> +{
>> +	struct ext4_super_block *es =3D sbi->s_es;
>> +	unsigned long long bcount, val;
>> +
>> +	bcount =3D ext4_blocks_count(es) - EXT4_C2B(sbi, sbi->s_overhead);
>=20
> Hmm this might get confusing since user would not expect that they
> can not set the limit up to the number of block in the file system.
> But even if they set it to the value where EXT4_C2B(sbi,
> sbi->s_overhead) would come to the play, they would get the
> notification immediately right ? So is it really needed ?
>=20

Is there much sens to set the threshold on the total number of blocks?
If there is an overhead - the used blocks will never hit such threshold=
,
would they? The notification gets triggered whenever the number of used=
 blocks
exceeds the one specified as threshold, so in order to get it fired
we have to be actually using at least that much, so I'm not sure we can=
 get
the case when total =3D=3D used.

> Also it would be nice to have a simple test in xfstests just to make
> sure that this method is reliable, which should be easy enough to
> do.
>=20

Will do.

> Thanks!
> -Lukas
>=20
>> +	if (parse_strtoull(buf, bcount, &val))
>> +		return -EINVAL;
>> +	if (val !=3D atomic64_read(&sbi->block_thres_event)) {
>> +		atomic64_set(&sbi->block_thres_event, val);
>> +		ext4_block_thres_notify(sbi);
>> +	}
>> +	return count;
>> +}
>> +
>>  static ssize_t trigger_test_error(struct ext4_attr *a,
>>  				  struct ext4_sb_info *sbi,
>>  				  const char *buf, size_t count)
>> @@ -2631,6 +2677,7 @@ EXT4_RO_ATTR(delayed_allocation_blocks);
>>  EXT4_RO_ATTR(session_write_kbytes);
>>  EXT4_RO_ATTR(lifetime_write_kbytes);
>>  EXT4_RW_ATTR(reserved_clusters);
>> +EXT4_RW_ATTR(block_thres_event);
>>  EXT4_ATTR_OFFSET(inode_readahead_blks, 0644, sbi_ui_show,
>>  		 inode_readahead_blks_store, s_inode_readahead_blks);
>>  EXT4_RW_ATTR_SBI_UI(inode_goal, s_inode_goal);
>> @@ -2658,6 +2705,7 @@ static struct attribute *ext4_attrs[] =3D {
>>  	ATTR_LIST(session_write_kbytes),
>>  	ATTR_LIST(lifetime_write_kbytes),
>>  	ATTR_LIST(reserved_clusters),
>> +	ATTR_LIST(block_thres_event),
>>  	ATTR_LIST(inode_readahead_blks),
>>  	ATTR_LIST(inode_goal),
>>  	ATTR_LIST(mb_stats),
>> @@ -4153,7 +4201,7 @@ no_journal:
>>  	}
>> =20
>>  	block =3D ext4_count_free_clusters(sb);
>> -	ext4_free_blocks_count_set(sbi->s_es,=20
>> +	ext4_free_blocks_count_set(sbi->s_es,
>>  				   EXT4_C2B(sbi, block));
>>  	err =3D percpu_counter_init(&sbi->s_freeclusters_counter, block,
>>  				  GFP_KERNEL);
>>
>=20

Thanks for your feedback.

BR
Beata
