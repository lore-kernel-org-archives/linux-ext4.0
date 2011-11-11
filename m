From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH v3] ext4: make quota as first class supported feature
Date: Thu, 10 Nov 2011 16:59:58 -0800
Message-ID: <CAGr1F2H6DhtmpviBLF+4re1Q9_s0ZB01+ob9WkCqX+TcLW6CFg@mail.gmail.com>
References: <1320372920-21308-1-git-send-email-adityakali@google.com> <20111108135514.GB9658@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: adilger@dilger.ca, tytso@mit.edu, dmonakhov@openvz.org,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44855 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab1KKBAT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Nov 2011 20:00:19 -0500
Received: by ywf7 with SMTP id 7so3664909ywf.19
        for <linux-ext4@vger.kernel.org>; Thu, 10 Nov 2011 17:00:18 -0800 (PST)
In-Reply-To: <20111108135514.GB9658@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for the feedback. I will address all the comments in next revisi=
on.
Some comments inline:

On Tue, Nov 8, 2011 at 5:55 AM, Jan Kara <jack@suse.cz> wrote:
> =C2=A0Thanks for the patch. I did a detailed review of it. I have qui=
te some
> comments but all of them are easily fixable so I think we should be m=
ostly
> ready in the next iteration.
>
> On Thu 03-11-11 19:15:20, Aditya Kali wrote:
>> +static const struct quotactl_ops ext4_new_qctl_operations =3D {
> =C2=A0ext4_new_qctl_operations is rather poor name. What if you need =
to create
> even newer set of operations in future? So I'd rather name them by "w=
hat
> they do" - so something like ext4_sysfile_qctl_operations - meaning t=
hat these
> operations handle quota stored in hidden system files.
>
>> + =C2=A0 =C2=A0 =C2=A0 .quota_on_meta =C2=A0=3D ext4_quota_on_meta,
>> + =C2=A0 =C2=A0 =C2=A0 .quota_off =C2=A0 =C2=A0 =C2=A0=3D ext4_quota=
_off,
>> + =C2=A0 =C2=A0 =C2=A0 .quota_sync =C2=A0 =C2=A0 =3D dquot_quota_syn=
c,
>> + =C2=A0 =C2=A0 =C2=A0 .get_info =C2=A0 =C2=A0 =C2=A0 =3D dquot_get_=
dqinfo,
>> + =C2=A0 =C2=A0 =C2=A0 .set_info =C2=A0 =C2=A0 =C2=A0 =3D dquot_set_=
dqinfo,
>> + =C2=A0 =C2=A0 =C2=A0 .get_dqblk =C2=A0 =C2=A0 =C2=A0=3D dquot_get_=
dqblk,
>> + =C2=A0 =C2=A0 =C2=A0 .set_dqblk =C2=A0 =C2=A0 =C2=A0=3D dquot_set_=
dqblk
> ..
>> @@ -3610,6 +3623,15 @@ static int ext4_fill_super(struct super_block=
 *sb, void *data, int silent)
>> =C2=A0#ifdef CONFIG_QUOTA
>> =C2=A0 =C2=A0 =C2=A0 sb->s_qcop =3D &ext4_qctl_operations;
>> =C2=A0 =C2=A0 =C2=A0 sb->dq_op =3D &ext4_quota_operations;
>> +
>> + =C2=A0 =C2=A0 if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_C=
OMPAT_QUOTA)) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Use new qctl operatio=
ns with quota on function that does not
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* require user spe=
cified quota file path. */
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sb->s_qcop =3D &ext4_new=
_qctl_operations;
>> +
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sbi->s_qf_inums[USRQUOTA=
] =3D es->s_usr_quota_inum;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sbi->s_qf_inums[GRPQUOTA=
] =3D es->s_grp_quota_inum;
> =C2=A0You need to convert from ondisk format here - i.e. use le32_to_=
cpu().
>
>> + =C2=A0 =C2=A0 }
>> =C2=A0#endif
>> =C2=A0 =C2=A0 =C2=A0 memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uui=
d));
>>
>> @@ -3815,8 +3837,21 @@ no_journal:
>> =C2=A0 =C2=A0 =C2=A0 } else
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 descr =3D "out jour=
nal";
>>
>> - =C2=A0 =C2=A0 ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. =
"
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"Opts: %s%s%s", de=
scr, sbi->s_es->s_mount_opts,
>> +#ifdef CONFIG_QUOTA
>> + =C2=A0 =C2=A0 /* Enable quota usage during mount. */
>> + =C2=A0 =C2=A0 if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_C=
OMPAT_QUOTA) &&
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 !(sb->s_flags & MS_RDONLY)) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_quota_enable(sb, US=
RQUOTA, QFMT_VFS_V1,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 DQUOT_USAGE_ENABLED);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_quota_enable(sb, GR=
PQUOTA, QFMT_VFS_V1,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 DQUOT_USAGE_ENABLED);
>> + =C2=A0 =C2=A0 }
> =C2=A0You should check the return value here and fail the mount in ca=
se turning
> quotas on fails... Also you should set DQUOT_QUOTA_SYS_FILE in
> sb_dqopt(sb)->flags before calling ext4_quota_enable() to indicate th=
at
> quota file is a hidden system file and generic quota code can then sk=
ip
> some rather costly steps during quota handling to keep user visible a=
nd
> kernel visible content in sync.
>
>
>> +#endif =C2=A0/* CONFIG_QUOTA */
>> +
>> + =C2=A0 =C2=A0 ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. =
quota=3D%s. "
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"Opts: %s%s%s", de=
scr,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sb_any_quota_loade=
d(sb) ? "on" : "off",
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sbi->s_es->s_mount=
_opts,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*sbi->s_es->s=
_mount_opts ? "; " : "", orig_data);
> =C2=A0Should info about quotas really be in the message? After all it=
's just
> another feature and we definitely don't report all the features files=
ystem
> has set.
>
>> @@ -4183,6 +4218,12 @@ static int ext4_commit_super(struct super_blo=
ck *sb, int sync)
>> =C2=A0 =C2=A0 =C2=A0 es->s_free_inodes_count =3D
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu_to_le32(percpu_=
counter_sum_positive(
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &EXT4_SB(sb)->s_freeinodes_counter)=
);
>> +#ifdef CONFIG_QUOTA
>> + =C2=A0 =C2=A0 if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_C=
OMPAT_QUOTA)) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 es->s_usr_quota_inum =3D=
 EXT4_SB(sb)->s_qf_inums[USRQUOTA];
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 es->s_grp_quota_inum =3D=
 EXT4_SB(sb)->s_qf_inums[GRPQUOTA];
>> + =C2=A0 =C2=A0 }
>> +#endif
> =C2=A0Is there really need to reset these numbers? They should be sta=
ble
> during the whole lifetime of a filesystem, no (modulo changes by tune=
2fs)?
> If I'm missing something and numbers indeed can change, you should co=
nvert
> them to on disk format - i.e. cpu_to_le32().
>
Currently tune2fs does not support enabling quota feature on mounted
filesystem. (I think we should probably make it enable quotas on a
read-only mount though). Even in that case, this is incorrect. I will
remove this.


>> @@ -4814,6 +4855,59 @@ static int ext4_quota_on(struct super_block *=
sb, int type, int format_id,
>> =C2=A0 =C2=A0 =C2=A0 return dquot_quota_on(sb, type, format_id, path=
);
>> =C2=A0}
>>
>> +static int ext4_quota_enable(struct super_block *sb, int type, int =
format_id,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0unsigned int flags)
>> +{
>> + =C2=A0 =C2=A0 struct ext4_sb_info *sbi =3D EXT4_SB(sb);
>> + =C2=A0 =C2=A0 struct inode *qf_inode;
>> + =C2=A0 =C2=A0 int err;
>> +
>> + =C2=A0 =C2=A0 if (!sbi->s_qf_inums[type])
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EPERM;
>> +
>> + =C2=A0 =C2=A0 qf_inode =3D ext4_iget(sb, sbi->s_qf_inums[type]);
>> + =C2=A0 =C2=A0 if (IS_ERR(qf_inode)) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_error(sb, "Bad quot=
a inode # %lu", sbi->s_qf_inums[type]);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return PTR_ERR(qf_inode)=
;
>> + =C2=A0 =C2=A0 }
>> +
>> + =C2=A0 =C2=A0 /*
>> + =C2=A0 =C2=A0 =C2=A0* When we journal data on quota file, we have =
to flush journal to see
>> + =C2=A0 =C2=A0 =C2=A0* all updates to the file when we bypass pagec=
ache...
>> + =C2=A0 =C2=A0 =C2=A0*/
>> + =C2=A0 =C2=A0 if (sbi->s_journal &&
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_should_journal_data(qf_inode)) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* We don't need to=
 lock updates but journal_flush() could
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* otherwise be liv=
elocked...
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 jbd2_journal_lock_update=
s(sbi->s_journal);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D jbd2_journal_flu=
sh(sbi->s_journal);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 jbd2_journal_unlock_upda=
tes(sbi->s_journal);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (err)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return err;
>> + =C2=A0 =C2=A0 }
> =C2=A0Why do you have the above check? Since this function is called =
only for
> reserved quota inodes which are hidden, ext4_should_journal_data() wi=
ll
> never be true for them.
>
This inode could refer to a user-visible file if existing quota file
was used by tune2fs. We will need to remove the journal flag on the
inode if present at tune2fs time.

>> +
>> + =C2=A0 =C2=A0 err =3D dquot_enable(qf_inode, type, format_id, flag=
s);
>> + =C2=A0 =C2=A0 iput(qf_inode);
>> +
>> + =C2=A0 =C2=A0 return err;
>> +}
>> @@ -4837,7 +4931,12 @@ static int ext4_quota_off(struct super_block =
*sb, int type)
>> =C2=A0 =C2=A0 =C2=A0 ext4_journal_stop(handle);
>>
>> =C2=A0out:
>> - =C2=A0 =C2=A0 return dquot_quota_off(sb, type);
>> + =C2=A0 =C2=A0 /* Disable only the limits if QUOTA feature is set. =
*/
>> + =C2=A0 =C2=A0 if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_C=
OMPAT_QUOTA))
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return dquot_disable(sb,=
 type, DQUOT_LIMITS_ENABLED);
>> + =C2=A0 =C2=A0 else
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return dquot_disable(sb,=
 type,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENAB=
LED);
>> =C2=A0}
> =C2=A0Hmm, most of the work ext4_quota_off() does is unnecessary when=
 quota is
> handled internally - there's no need to sync the filesystem, no need =
to
> update mtime or ctime... So I'd rather provide a new ext4_quota_off()
> function in case quota feature is enabled and that would just call
> dquot_disable(sb, type, DQUOT_LIMITS_ENABLED).
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>



--=20
Aditya
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
