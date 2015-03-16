From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [v9 3/5] ext4: adds project quota support
Date: Mon, 16 Mar 2015 17:57:45 +0300
Message-ID: <5506EF69.4020205@yandex-team.ru>
References: <1426043003-31043-1-git-send-email-lixi@ddn.com> <1426043003-31043-4-git-send-email-lixi@ddn.com> <CALYGNiN1bfStzKTNX+f6uUUNrhzE4qNFRgCWLF0rZxKXAtn9BQ@mail.gmail.com> <A88EFAED-81C2-430E-A225-879D577BE5C4@dilger.ca> <20150316144727.GP4934@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Konstantin Khlebnikov <koct9i@gmail.com>,
	Li Xi <pkuelelixi@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	=?UTF-8?B?0JTQvNC40YLRgNC40Lkg0JzQvtC90LDRhdC+0LI=?=
	<dmonakhov@openvz.org>
To: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from forward-corp1m.cmail.yandex.net ([5.255.216.100]:51313 "EHLO
	forward-corp1m.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933367AbbCPO5v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Mar 2015 10:57:51 -0400
In-Reply-To: <20150316144727.GP4934@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 16.03.2015 17:47, Jan Kara wrote:
> On Thu 12-03-15 11:01:54, Andreas Dilger wrote:
>> Ted, I was looking at ext2_fs.h in the upstream e2fsprogs and see that
>> all of the reserved inodes have already been used. The last reserved
>> inode was "EXT4_REPLICA_INO", so there is no space for the project
>> quota inode.
>>
>> This patch is using inode #9 which conflicts with EXT2_EXCLUDE_INO,
>> while the patch from Konstantin is using inode #11 which is not reserved
>> and conflicts with lost+found on most filesystems.
>>
>> What is the best road forward here? Should a new inode be allocated
>> and stored into the superblock?
>    So my preference would be following:
> Repurpose one of EXT2_UNDEL_DIR_INO, EXT2_EXCLUDE_INO, EXT4_REPLICA_INO
> since neither of these seems to be getting wide use to be 'system inode
> directory'. All new special inodes will be linked into that directory under
> appropriate names.
>
>  From kernel side this is rather simple to do. There's some work to be done
> on the tools side so that e2fsck knows about this special directory,
> tune2fs and mke2fs can work with it etc. Thoughts?

In this case hiding special inodes might be non-trivial.
Kernel uses this when inode is accessed from userspace or via NFS export 
operations:

struct inode *ext4_iget_normal(struct super_block *sb, unsigned long ino)
{
	if (ino < EXT4_FIRST_INO(sb) && ino != EXT4_ROOT_INO)
		return ERR_PTR(-EIO);
	return ext4_iget(sb, ino);
}

>
> 								Honza
>>
>> Cheers, Andreas
>>
>>> On Mar 11, 2015, at 03:40, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
>>>
>>>> On Wed, Mar 11, 2015 at 6:03 AM, Li Xi <pkuelelixi@gmail.com> wrote:
>>>> This patch adds mount options for enabling/disabling project quota
>>>> accounting and enforcement. A new specific inode is also used for
>>>> project quota accounting.
>>>>
>>>> Signed-off-by: Li Xi <lixi@ddn.com>
>>>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>>>> Reviewed-by: Jan Kara <jack@suse.cz>
>>>> ---
>>>> fs/ext4/ext4.h  |    8 +++-
>>>> fs/ext4/super.c |   99 ++++++++++++++++++++++++++++++++++++++++++++++++-------
>>>> 2 files changed, 93 insertions(+), 14 deletions(-)
>>>>
>>>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>>>> index 7acb2da..3443456 100644
>>>> --- a/fs/ext4/ext4.h
>>>> +++ b/fs/ext4/ext4.h
>>>> @@ -208,6 +208,7 @@ struct ext4_io_submit {
>>>> #define EXT4_UNDEL_DIR_INO      6      /* Undelete directory inode */
>>>> #define EXT4_RESIZE_INO                 7      /* Reserved group descriptors inode */
>>>> #define EXT4_JOURNAL_INO        8      /* Journal inode */
>>>> +#define EXT4_PRJ_QUOTA_INO      9      /* Project quota inode */
>>>
>>> This special inode is reserved for:  EXT2_EXCLUDE_INO 9 /* The
>>> "exclude" inode, for snapshots */
>>> I'm not sure if it's ok to use it for project quota.
>>>
>>>>
>>>> /* First non-reserved inode for old ext4 filesystems */
>>>> #define EXT4_GOOD_OLD_FIRST_INO        11
>>>> @@ -987,6 +988,7 @@ struct ext4_inode_info {
>>>> #define EXT4_MOUNT_DIOREAD_NOLOCK      0x400000 /* Enable support for dio read nolocking */
>>>> #define EXT4_MOUNT_JOURNAL_CHECKSUM    0x800000 /* Journal checksums */
>>>> #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT        0x1000000 /* Journal Async Commit */
>>>> +#define EXT4_MOUNT_PRJQUOTA            0x2000000 /* Project quota support */
>>>> #define EXT4_MOUNT_DELALLOC            0x8000000 /* Delalloc support */
>>>> #define EXT4_MOUNT_DATA_ERR_ABORT      0x10000000 /* Abort on file data write */
>>>> #define EXT4_MOUNT_BLOCK_VALIDITY      0x20000000 /* Block validity checking */
>>>> @@ -1169,7 +1171,8 @@ struct ext4_super_block {
>>>>         __le32  s_overhead_clusters;    /* overhead blocks/clusters in fs */
>>>>         __le32  s_backup_bgs[2];        /* groups with sparse_super2 SBs */
>>>>         __u8    s_encrypt_algos[4];     /* Encryption algorithms in use  */
>>>> -       __le32  s_reserved[105];        /* Padding to the end of the block */
>>>> +       __le32  s_prj_quota_inum;       /* inode for tracking project quota */
>>>> +       __le32  s_reserved[104];        /* Padding to the end of the block */
>>>>         __le32  s_checksum;             /* crc32c(superblock) */
>>>> };
>>>>
>>>> @@ -1184,7 +1187,7 @@ struct ext4_super_block {
>>>> #define EXT4_MF_FS_ABORTED     0x0002  /* Fatal error detected */
>>>>
>>>> /* Number of quota types we support */
>>>> -#define EXT4_MAXQUOTAS 2
>>>> +#define EXT4_MAXQUOTAS 3
>>>>
>>>> /*
>>>>   * fourth extended-fs super-block data in memory
>>>> @@ -1376,6 +1379,7 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
>>>>                 ino == EXT4_BOOT_LOADER_INO ||
>>>>                 ino == EXT4_JOURNAL_INO ||
>>>>                 ino == EXT4_RESIZE_INO ||
>>>> +               ino == EXT4_PRJ_QUOTA_INO ||
>>>>                 (ino >= EXT4_FIRST_INO(sb) &&
>>>>                  ino <= le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count));
>>>> }
>>>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>>>> index 04c6cc3..e057daa 100644
>>>> --- a/fs/ext4/super.c
>>>> +++ b/fs/ext4/super.c
>>>> @@ -1036,8 +1036,8 @@ static int bdev_try_to_free_page(struct super_block *sb, struct page *page,
>>>> }
>>>>
>>>> #ifdef CONFIG_QUOTA
>>>> -#define QTYPE2NAME(t) ((t) == USRQUOTA ? "user" : "group")
>>>> -#define QTYPE2MOPT(on, t) ((t) == USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
>>>> +static char *quotatypes[] = INITQFNAMES;
>>>> +#define QTYPE2NAME(t) (quotatypes[t])
>>>>
>>>> static int ext4_write_dquot(struct dquot *dquot);
>>>> static int ext4_acquire_dquot(struct dquot *dquot);
>>>> @@ -1135,7 +1135,8 @@ enum {
>>>>         Opt_journal_path, Opt_journal_checksum, Opt_journal_async_commit,
>>>>         Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
>>>>         Opt_data_err_abort, Opt_data_err_ignore,
>>>> -       Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
>>>> +       Opt_usrjquota, Opt_grpjquota, Opt_prjjquota,
>>>> +       Opt_offusrjquota, Opt_offgrpjquota, Opt_offprjjquota,
>>>>         Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
>>>>         Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err,
>>>>         Opt_usrquota, Opt_grpquota, Opt_i_version,
>>>> @@ -1190,6 +1191,8 @@ static const match_table_t tokens = {
>>>>         {Opt_usrjquota, "usrjquota=%s"},
>>>>         {Opt_offgrpjquota, "grpjquota="},
>>>>         {Opt_grpjquota, "grpjquota=%s"},
>>>> +       {Opt_prjjquota, "prjjquota"},
>>>> +       {Opt_offprjjquota, "offprjjquota"},
>>>>         {Opt_jqfmt_vfsold, "jqfmt=vfsold"},
>>>>         {Opt_jqfmt_vfsv0, "jqfmt=vfsv0"},
>>>>         {Opt_jqfmt_vfsv1, "jqfmt=vfsv1"},
>>>> @@ -1412,11 +1415,14 @@ static const struct mount_opts {
>>>>         {Opt_grpquota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_GRPQUOTA,
>>>>                                                         MOPT_SET | MOPT_Q},
>>>>         {Opt_noquota, (EXT4_MOUNT_QUOTA | EXT4_MOUNT_USRQUOTA |
>>>> -                      EXT4_MOUNT_GRPQUOTA), MOPT_CLEAR | MOPT_Q},
>>>> +                      EXT4_MOUNT_GRPQUOTA | EXT4_MOUNT_PRJQUOTA),
>>>> +                                                       MOPT_CLEAR | MOPT_Q},
>>>>         {Opt_usrjquota, 0, MOPT_Q},
>>>>         {Opt_grpjquota, 0, MOPT_Q},
>>>> +       {Opt_prjjquota, 0, MOPT_Q},
>>>>         {Opt_offusrjquota, 0, MOPT_Q},
>>>>         {Opt_offgrpjquota, 0, MOPT_Q},
>>>> +       {Opt_offprjjquota, 0, MOPT_Q},
>>>>         {Opt_jqfmt_vfsold, QFMT_VFS_OLD, MOPT_QFMT},
>>>>         {Opt_jqfmt_vfsv0, QFMT_VFS_V0, MOPT_QFMT},
>>>>         {Opt_jqfmt_vfsv1, QFMT_VFS_V1, MOPT_QFMT},
>>>> @@ -1433,16 +1439,25 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
>>>>         kuid_t uid;
>>>>         kgid_t gid;
>>>>         int arg = 0;
>>>> -
>>>> #ifdef CONFIG_QUOTA
>>>> +       char *prj_qf_name = "aquota.project";
>>>
>>> If you already have inode numer in super-block why do you need this name here?
>>> Modern journalled quota is stored in special inodes and invisible from
>>> user-space.
>>>
>>>> +       substring_t prj_qf_string = {
>>>> +               .from = prj_qf_name,
>>>> +               .to = &prj_qf_name[strlen(prj_qf_name)],
>>>> +       };
>>>> +
>>>>         if (token == Opt_usrjquota)
>>>>                 return set_qf_name(sb, USRQUOTA, &args[0]);
>>>>         else if (token == Opt_grpjquota)
>>>>                 return set_qf_name(sb, GRPQUOTA, &args[0]);
>>>> +       else if (token == Opt_prjjquota)
>>>> +               return set_qf_name(sb, PRJQUOTA, &prj_qf_string);
>>>>         else if (token == Opt_offusrjquota)
>>>>                 return clear_qf_name(sb, USRQUOTA);
>>>>         else if (token == Opt_offgrpjquota)
>>>>                 return clear_qf_name(sb, GRPQUOTA);
>>>> +       else if (token == Opt_offprjjquota)
>>>> +               return clear_qf_name(sb, PRJQUOTA);
>>>> #endif
>>>>         switch (token) {
>>>>         case Opt_noacl:
>>>> @@ -1668,19 +1683,28 @@ static int parse_options(char *options, struct super_block *sb,
>>>>         }
>>>> #ifdef CONFIG_QUOTA
>>>>         if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) &&
>>>> -           (test_opt(sb, USRQUOTA) || test_opt(sb, GRPQUOTA))) {
>>>> +           (test_opt(sb, USRQUOTA) ||
>>>> +            test_opt(sb, GRPQUOTA) ||
>>>> +            test_opt(sb, PRJQUOTA))) {
>>>>                 ext4_msg(sb, KERN_ERR, "Cannot set quota options when QUOTA "
>>>>                          "feature is enabled");
>>>>                 return 0;
>>>>         }
>>>> -       if (sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA]) {
>>>> +       if (sbi->s_qf_names[USRQUOTA] ||
>>>> +           sbi->s_qf_names[GRPQUOTA] ||
>>>> +           sbi->s_qf_names[PRJQUOTA]) {
>>>>                 if (test_opt(sb, USRQUOTA) && sbi->s_qf_names[USRQUOTA])
>>>>                         clear_opt(sb, USRQUOTA);
>>>>
>>>>                 if (test_opt(sb, GRPQUOTA) && sbi->s_qf_names[GRPQUOTA])
>>>>                         clear_opt(sb, GRPQUOTA);
>>>>
>>>> -               if (test_opt(sb, GRPQUOTA) || test_opt(sb, USRQUOTA)) {
>>>> +               if (test_opt(sb, PRJQUOTA) && sbi->s_qf_names[PRJQUOTA])
>>>> +                       clear_opt(sb, PRJQUOTA);
>>>> +
>>>> +               if (test_opt(sb, GRPQUOTA) ||
>>>> +                   test_opt(sb, USRQUOTA) ||
>>>> +                   test_opt(sb, PRJQUOTA)) {
>>>>                         ext4_msg(sb, KERN_ERR, "old and new quota "
>>>>                                         "format mixing");
>>>>                         return 0;
>>>> @@ -1740,6 +1764,9 @@ static inline void ext4_show_quota_options(struct seq_file *seq,
>>>>
>>>>         if (sbi->s_qf_names[GRPQUOTA])
>>>>                 seq_printf(seq, ",grpjquota=%s", sbi->s_qf_names[GRPQUOTA]);
>>>> +
>>>> +       if (sbi->s_qf_names[PRJQUOTA])
>>>> +               seq_printf(seq, ",prjjquota=%s", sbi->s_qf_names[PRJQUOTA]);
>>>> #endif
>>>> }
>>>>
>>>> @@ -3944,7 +3971,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>>>>                 sb->s_qcop = &ext4_qctl_sysfile_operations;
>>>>         else
>>>>                 sb->s_qcop = &ext4_qctl_operations;
>>>> -       sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
>>>> +       sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP | QTYPE_MASK_PRJ;
>>>> #endif
>>>>         memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
>>>>
>>>> @@ -5040,6 +5067,46 @@ restore_opts:
>>>>         return err;
>>>> }
>>>>
>>>> +static int ext4_statfs_project(struct super_block *sb,
>>>> +                              kprojid_t projid, struct kstatfs *buf)
>>>> +{
>>>> +       struct kqid qid;
>>>> +       struct dquot *dquot;
>>>> +       u64 limit;
>>>> +       u64 curblock;
>>>> +
>>>> +       qid = make_kqid_projid(projid);
>>>> +       dquot = dqget(sb, qid);
>>>> +       if (!dquot)
>>>> +               return -ESRCH;
>>>> +       spin_lock(&dq_data_lock);
>>>> +
>>>> +       limit = dquot->dq_dqb.dqb_bsoftlimit ?
>>>> +               dquot->dq_dqb.dqb_bsoftlimit :
>>>> +               dquot->dq_dqb.dqb_bhardlimit;
>>>> +       if (limit && buf->f_blocks * buf->f_bsize > limit) {
>>>> +               curblock = dquot->dq_dqb.dqb_curspace / buf->f_bsize;
>>>> +               buf->f_blocks = limit / buf->f_bsize;
>>>> +               buf->f_bfree = buf->f_bavail =
>>>> +                       (buf->f_blocks > curblock) ?
>>>> +                        (buf->f_blocks - curblock) : 0;
>>>> +       }
>>>> +
>>>> +       limit = dquot->dq_dqb.dqb_isoftlimit ?
>>>> +               dquot->dq_dqb.dqb_isoftlimit :
>>>> +               dquot->dq_dqb.dqb_ihardlimit;
>>>> +       if (limit && buf->f_files > limit) {
>>>> +               buf->f_files = limit;
>>>> +               buf->f_ffree =
>>>> +                       (buf->f_files > dquot->dq_dqb.dqb_curinodes) ?
>>>> +                        (buf->f_files - dquot->dq_dqb.dqb_curinodes) : 0;
>>>> +       }
>>>> +
>>>> +       spin_unlock(&dq_data_lock);
>>>> +       dqput(dquot);
>>>> +       return 0;
>>>> +}
>>>> +
>>>> static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
>>>> {
>>>>         struct super_block *sb = dentry->d_sb;
>>>> @@ -5048,6 +5115,7 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
>>>>         ext4_fsblk_t overhead = 0, resv_blocks;
>>>>         u64 fsid;
>>>>         s64 bfree;
>>>> +       struct inode *inode = dentry->d_inode;
>>>>         resv_blocks = EXT4_C2B(sbi, atomic64_read(&sbi->s_resv_clusters));
>>>>
>>>>         if (!test_opt(sb, MINIX_DF))
>>>> @@ -5072,6 +5140,9 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
>>>>         buf->f_fsid.val[0] = fsid & 0xFFFFFFFFUL;
>>>>         buf->f_fsid.val[1] = (fsid >> 32) & 0xFFFFFFFFUL;
>>>>
>>>> +       if (ext4_test_inode_flag(inode, EXT4_INODE_PROJINHERIT) &&
>>>> +           sb_has_quota_limits_enabled(sb, PRJQUOTA))
>>>> +               ext4_statfs_project(sb, EXT4_I(inode)->i_projid, buf);
>>>>         return 0;
>>>> }
>>>>
>>>> @@ -5152,7 +5223,9 @@ static int ext4_mark_dquot_dirty(struct dquot *dquot)
>>>>
>>>>         /* Are we journaling quotas? */
>>>>         if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) ||
>>>> -           sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA]) {
>>>> +           sbi->s_qf_names[USRQUOTA] ||
>>>> +           sbi->s_qf_names[GRPQUOTA] ||
>>>> +           sbi->s_qf_names[PRJQUOTA]) {
>>>>                 dquot_mark_dquot_dirty(dquot);
>>>>                 return ext4_write_dquot(dquot);
>>>>         } else {
>>>> @@ -5236,7 +5309,8 @@ static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
>>>>         struct inode *qf_inode;
>>>>         unsigned long qf_inums[EXT4_MAXQUOTAS] = {
>>>>                 le32_to_cpu(EXT4_SB(sb)->s_es->s_usr_quota_inum),
>>>> -               le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum)
>>>> +               le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum),
>>>> +               le32_to_cpu(EXT4_SB(sb)->s_es->s_prj_quota_inum)
>>>>         };
>>>>
>>>>         BUG_ON(!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA));
>>>> @@ -5264,7 +5338,8 @@ static int ext4_enable_quotas(struct super_block *sb)
>>>>         int type, err = 0;
>>>>         unsigned long qf_inums[EXT4_MAXQUOTAS] = {
>>>>                 le32_to_cpu(EXT4_SB(sb)->s_es->s_usr_quota_inum),
>>>> -               le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum)
>>>> +               le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum),
>>>> +               le32_to_cpu(EXT4_SB(sb)->s_es->s_prj_quota_inum)
>>>>         };
>>>>
>>>>         sb_dqopt(sb)->flags |= DQUOT_QUOTA_SYS_FILE;
>>>> --
>>>> 1.7.1
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

