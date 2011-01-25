From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH 2/3] ext4 : Pass GFP_KERNEL for transaction allocation if
 caller can handler failures
Date: Tue, 25 Jan 2011 12:05:07 -0800
Message-ID: <AANLkTiniUaD8SN53BKFC2ayku-4m=4EATKxBc148d51G@mail.gmail.com>
References: <AANLkTinVBicZyTthnp5SjOoHUWHcKc1Css46RjpfEEnh@mail.gmail.com> <20110125161745.GC4088@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44367 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab1AYUF3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Jan 2011 15:05:29 -0500
Received: by qwa26 with SMTP id 26so161787qwa.19
        for <linux-ext4@vger.kernel.org>; Tue, 25 Jan 2011 12:05:27 -0800 (PST)
In-Reply-To: <20110125161745.GC4088@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks a lot Jan, I will have a look at the functions you mentioned
and send an updated version.

On Tue, Jan 25, 2011 at 8:17 AM, Jan Kara <jack@suse.cz> wrote:
> =A0Hi,
>
> On Sat 22-01-11 19:34:55, Manish Katiyar wrote:
>> Pass GFP_KERNEL for transaction allocation for ext4 routines if call=
er
>> can handler failures
> =A0Some error recovery paths will need cleaning up before you actuall=
y start
> using them - see below:
>
>> diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
>> index e0270d1..1a4a944 100644
>> --- a/fs/ext4/acl.c
>> +++ b/fs/ext4/acl.c
>> @@ -351,7 +351,7 @@ ext4_acl_chmod(struct inode *inode)
>>
>> =A0 =A0 =A0 retry:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_DATA_=
TRANS_BLOCKS(inode->i_sb));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_DATA_=
TRANS_BLOCKS(inode->i_sb), true);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D PTR_ERR(handle=
);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_std_error(inode->i_=
sb, error);
> =A0We shouldn't call ext4_std_error() (that possibly logs the message=
 in
> the kernel log and remounts the fs read-only, panics the kernel or so=
) in
> case of ENOMEM...
>
>> @@ -449,7 +449,8 @@ ext4_xattr_set_acl(struct dentry *dentry, const
>> char *name, const void *value,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 acl =3D NULL;
>>
>> =A0retry:
>> - =A0 =A0 handle =3D ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCK=
S(inode->i_sb));
>> + =A0 =A0 handle =3D ext4_journal_start(inode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EX=
T4_DATA_TRANS_BLOCKS(inode->i_sb), true);
>> =A0 =A0 =A0 if (IS_ERR(handle))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(handle);
> =A0It's actually not your bug, but the above should be:
> =A0error =3D PTR_ERR(handle);
> =A0goto release_and_out;
>
>> =A0 =A0 =A0 error =3D ext4_set_acl(handle, inode, type, acl);
>> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
>> index eb9097a..e0e27a3 100644
>> --- a/fs/ext4/ialloc.c
>> +++ b/fs/ext4/ialloc.c
>> @@ -1257,7 +1257,7 @@ extern int ext4_init_inode_table(struct
>> super_block *sb, ext4_group_t group,
>> =A0 =A0 =A0 if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>>
>> - =A0 =A0 handle =3D ext4_journal_start_sb(sb, 1);
>> + =A0 =A0 handle =3D ext4_journal_start_sb(sb, 1, true);
>> =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D PTR_ERR(handle);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> =A0Well, this might be disputable. This function is used to lazily
> initialize inode table. =A0If the initialization fails, thread remove=
s the
> request for initialization from the queue. But in case of ENOMEM, it =
might
> be more suitable to just postpone the initialization work to a more
> suitable time...
>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 9f7f9e4..76c20b8 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
> ...
>> @@ -1398,7 +1398,7 @@ static int _ext4_get_block(struct inode *inode=
,
>> sector_t iblock,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (map.m_len > DIO_MAX_BLOCKS)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 map.m_len =3D DIO_MAX_BL=
OCKS;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 dio_credits =3D ext4_chunk_trans_blocks(=
inode, map.m_len);
>> - =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode, dio_c=
redits);
>> + =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode, dio_c=
redits, false);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D PTR_ERR(handle);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> =A0Hmm, this would be actually another useful prerequisite cleanup of=
 this
> series. _ext4_get_block() should need to start a transaction only whe=
n
> called from direct IO path (otherwise transaction should be already s=
tarted
> when creating blocks). But this is only implicit so it would be good =
to
> create ext4_get_block_directIO() which would start a transaction, use=
 it
> as a callback of __blockdev_direct_IO(), and remove the code from sta=
ndard
> _ext4_get_block() function. Then you can also make ext4_journal_start=
()
> possibly fail and still it will be clear you do not introduce any pot=
ential
> problems.
>
>> @@ -1621,7 +1621,7 @@ static int ext4_write_begin(struct file *file,
>> struct address_space *mapping,
>> =A0 =A0 =A0 to =3D from + len;
>>
>> =A0retry:
>> - =A0 =A0 handle =3D ext4_journal_start(inode, needed_blocks);
>> + =A0 =A0 handle =3D ext4_journal_start(inode, needed_blocks, false)=
;
>> =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D PTR_ERR(handle);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> =A0Failing this with ENOMEM is OK. Note that grab_cache_page_write_be=
gin()
> called just below can fail with ENOMEM as well.
>
>> @@ -3553,7 +3554,7 @@ static ssize_t ext4_ind_direct_IO(int rw, stru=
ct
>> kiocb *iocb,
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (final_size > inode->i_size) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Credits for sb + inod=
e write */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_st=
art(inode, 2);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_st=
art(inode, 2, false);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D =
PTR_ERR(handle);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out=
;
> =A0This can fail without introducing problems. It's standard directIO=
 write
> path.
>
>> @@ -3596,7 +3597,7 @@ retry:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 int err;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Credits for sb + inode write */
>> - =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode, 2);
>> + =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode, 2, fa=
lse);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* This is really bad lu=
ck. We've written the data
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* but cannot extend i=
_size. Bail out and pretend
> =A0This one can fail just fine as well.
>
>> @@ -5329,8 +5330,10 @@ int ext4_setattr(struct dentry *dentry, struc=
t
>> iattr *attr)
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* (user+group)*(old+new) structure, ino=
de write (sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* inode block, ? - but truncate inode=
 update has it) */
>> - =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode, (EXT4=
_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3);
>> + =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 (EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 true);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D PTR_ERR(handle=
);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_out;
>> @@ -5365,7 +5368,7 @@ int ext4_setattr(struct dentry *dentry, struct
>> iattr *attr)
>> =A0 =A0 =A0 =A0 =A0 =A0(ext4_test_inode_flag(inode, EXT4_INODE_EOFBL=
OCKS)))) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 handle_t *handle;
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode, 3);
>> + =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode, 3, tr=
ue);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D PTR_ERR(handle=
);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_out;
> =A0The above two sites are fine but note that err_out calls ext4_std_=
error()
> which we don't want to happen in case of ENOMEM.
>
>> @@ -5822,7 +5825,7 @@ int ext4_change_inode_journal_flag(struct inod=
e
>> *inode, int val)
>>
>> =A0 =A0 =A0 /* Finally we can mark the inode as dirty. */
>>
>> - =A0 =A0 handle =3D ext4_journal_start(inode, 1);
>> + =A0 =A0 handle =3D ext4_journal_start(inode, 1, true);
>> =A0 =A0 =A0 if (IS_ERR(handle))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(handle);
> =A0This can fail OK, but you should undo inode flag and aops change b=
efore
> returning error (that would be probably better as a separate preparat=
ory
> patch because it won't be completely trivial - you need to lock the u=
pdates
> again etc. possibly create a helper function for that so that you don=
't
> duplicate the code).
>
>> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
>> index eb3bc2f..3e7977b 100644
>> --- a/fs/ext4/ioctl.c
>> +++ b/fs/ext4/ioctl.c
>> @@ -101,7 +101,7 @@ long ext4_ioctl(struct file *filp, unsigned int
>> cmd, unsigned long arg)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (oldflags & EXT4_EOFBLOCKS_FL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_truncate(inode);
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode, 1);
>> + =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode, 1, fa=
lse);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D PTR_ERR(handle);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto flags_out;
> =A0This can handle failure just fine...

I wasn't sure about this since this was calling ext4_truncate if the
old_flags had EXT4_EOFBLOCKS_FL. And then in ext4_truncate() had
start_transaction which was passing false.


>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index cb10a06..7714a15 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -4487,7 +4488,7 @@ static int ext4_acquire_dquot(struct dquot *dq=
uot)
>> =A0 =A0 =A0 handle_t *handle;
>>
>> =A0 =A0 =A0 handle =3D ext4_journal_start(dquot_to_inode(dquot),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EX=
T4_QUOTA_INIT_BLOCKS(dquot->dq_sb));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EX=
T4_QUOTA_INIT_BLOCKS(dquot->dq_sb), true);
>> =A0 =A0 =A0 if (IS_ERR(handle))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(handle);
>> =A0 =A0 =A0 ret =3D dquot_acquire(dquot);
>> @@ -4503,7 +4504,7 @@ static int ext4_release_dquot(struct dquot *dq=
uot)
>> =A0 =A0 =A0 handle_t *handle;
>>
>> =A0 =A0 =A0 handle =3D ext4_journal_start(dquot_to_inode(dquot),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EX=
T4_QUOTA_DEL_BLOCKS(dquot->dq_sb));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EX=
T4_QUOTA_DEL_BLOCKS(dquot->dq_sb), true);
>> =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Release dquot anyway to avoid endless=
 cycle in dqput() */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 dquot_release(dquot);
> =A0For now put 'false' in these quota functions. Because failure here
> results in a failure of dquot_initialize() which is not tested in mos=
t
> places and thus results in quota miscomputations... Properly handling=
 this
> would require another set of cleanups.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>



--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
