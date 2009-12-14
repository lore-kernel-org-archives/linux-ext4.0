From: Dmitry Monakhov <rjevskiy@gmail.com>
Subject: Re: [PATCH 1/2] quota: decouple fs reserved space from quota
	reservation. [V3]
Date: Mon, 14 Dec 2009 15:45:23 +0300
Message-ID: <c18d6aa20912140445y51cbf10bg23d902ae1bf4503d@mail.gmail.com>
References: <1260447952-6201-1-git-send-email-dmonakhov@openvz.org>
	 <20091210150203.GC3696@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com,
	cmm@us.ibm.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44258 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbZLNMp0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Dec 2009 07:45:26 -0500
Received: by ewy19 with SMTP id 19so3320549ewy.21
        for <linux-ext4@vger.kernel.org>; Mon, 14 Dec 2009 04:45:24 -0800 (PST)
In-Reply-To: <20091210150203.GC3696@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, Please ignore all messages which I have sent yesterday(sunday). I
have had troubles with my default
smtp server.

I've submitted updated version of the patch-set. It starts from
following message.
Subject: [PATCH 1/5] Add unlocked version of inode_add_bytes() function
Date: Mon, 14 Dec 2009 15:21:12 +0300
Message-id: <1260793276-8511-1-git-send-email-dmonakhov@openvz.org>
Last two patches in the series not directly related with the race bug,
but depends
on the previous patches. We may easily defer this patches until a prope=
r moment.


2009/12/10 Jan Kara <jack@suse.cz>:
> =C2=A0Hi,
>
> On Thu 10-12-09 15:25:51, Dmitry Monakhov wrote:
>> Currently inode_reservation is managed by fs itself and this
>> reservation is transfered on dquot_transfer(). This means what
>> inode_reservation must always be in sync with
>> dquot->dq_dqb.dqb_rsvspace. Otherwise dquot_transfer() will result
>> in incorrect quota(WARN_ON in dquot_claim_reserved_space() will be
>> triggered)
>> This is not easy because of complex locking order issues
>> for example http://bugzilla.kernel.org/show_bug.cgi?id=3D14739
>>
>> The patch introduce quota reservation field for each fs-inode
>> (fs specific inode is used in order to prevent bloating generic
>> vfs inode). This reservation is managed by quota code internally
>> similar to i_blocks/i_bytes and may not be always in sync with
>> internal fs reservation.
>>
>> Also perform some code rearrangement:
>> - Unify dquot_reserve_space() and dquot_reserve_space()
>> - Unify dquot_release_reserved_space() and dquot_free_space()
>> - Also this patch add missing warning update to release_rsv()
>> =C2=A0 dquot_release_reserved_space() must call flush_warnings() as
>> =C2=A0 dquot_free_space() does.
>>
>> Changes from V1:
>> - move qutoa_reservation field from vfs_inode to fs_inode
>> - account reservation in bytes instead of blocks.
> =C2=A0Thanks for looking into this! I have some comments to the patch=
 below
> but generally I like it.
>
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>> ---
>> =C2=A0fs/quota/dquot.c =C2=A0 =C2=A0 =C2=A0| =C2=A0219 +++++++++++++=
+++++++++++++++---------------------
>> =C2=A0include/linux/quota.h | =C2=A0 =C2=A05 +-
>> =C2=A02 files changed, 127 insertions(+), 97 deletions(-)
>>
>> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
>> index 39b49c4..66221f8 100644
>> --- a/fs/quota/dquot.c
>> +++ b/fs/quota/dquot.c
>> @@ -1388,6 +1388,71 @@ void vfs_dq_drop(struct inode *inode)
>> =C2=A0EXPORT_SYMBOL(vfs_dq_drop);
>>
>> =C2=A0/*
>> + * inode_reserved_space is managed internally by quota, and protect=
ed by
>> + * i_lock similar to i_blocks+i_bytes.
>> + */
>> +static qsize_t* inode_reserved_space(struct inode * inode)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^^ it should =
be "qsize_t *"
>> +{
>> + =C2=A0 =C2=A0 /* Filesystem must explicitly define it's own method=
 in order to use
>> + =C2=A0 =C2=A0 =C2=A0* quota reservation interface */
>> + =C2=A0 =C2=A0 BUG_ON(!inode->i_sb->dq_op->get_reserved_space);
>> + =C2=A0 =C2=A0 return inode->i_sb->dq_op->get_reserved_space(inode)=
;
>> +}
>> +
>> +static void inode_add_rsv_space(struct inode *inode, qsize_t number=
)
>> +{
>> + =C2=A0 =C2=A0 spin_lock(&inode->i_lock);
>> + =C2=A0 =C2=A0 *inode_reserved_space(inode) +=3D number;
>> + =C2=A0 =C2=A0 spin_unlock(&inode->i_lock);
>> +}
>> +
> =C2=A0Hmm, I think I have a better solution for this: Each inode will=
 have a
> pointer to "inode features" table. That table will contain offsets of
> general structures (e.g. things needed for quotas) embedded inside
> fs-specific inode. That way we can later move similar structures out =
of
> general VFS inode to inodes of filesystems that need it. When a files=
ystem
> creates an inode, it fills in a proper pointer to the table... That s=
hould
> allow generic code access data in fs-specific part of inode structure=
,
> we don't have to add functions returning pointers, etc.
> =C2=A0But for now I'd go with your solution since mine will require m=
ore
> widespread changes to quota code and we need to fix that bug.
>
>> +static void inode_claim_rsv_space(struct inode *inode, qsize_t numb=
er)
>> +{
>> + =C2=A0 =C2=A0 spin_lock(&inode->i_lock);
>> + =C2=A0 =C2=A0 *inode_reserved_space(inode) -=3D number;
>> + =C2=A0 =C2=A0 inode->i_blocks +=3D number >> 9;
>> + =C2=A0 =C2=A0 number &=3D 511;
>> + =C2=A0 =C2=A0 inode->i_bytes +=3D number;
>> + =C2=A0 =C2=A0 if (inode->i_bytes >=3D 512) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode->i_blocks++;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode->i_bytes -=3D 512;
>> + =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 spin_unlock(&inode->i_lock);
>> +}
> =C2=A0Please add variant of inode_add_bytes() which does not acquire
> inode->i_lock and use it here. I'd suggest __inode_add_bytes and rena=
me
> __inode_add_bytes below to something more appropriate like
> inode_alloc_reserve_bytes or so.
>
> ...
>> @@ -1426,64 +1506,32 @@ int __dquot_alloc_space(struct inode *inode,=
 qsize_t number,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 dquot_incr_space(inode->i_dquot[cnt], number);
>> =C2=A0 =C2=A0 =C2=A0 }
>> - =C2=A0 =C2=A0 if (!reserve)
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode_add_bytes(inode, n=
umber);
>> -out_unlock:
>> - =C2=A0 =C2=A0 spin_unlock(&dq_data_lock);
>> - =C2=A0 =C2=A0 flush_warnings(inode->i_dquot, warntype);
>> - =C2=A0 =C2=A0 return ret;
>> -}
>> -
>> -int dquot_alloc_space(struct inode *inode, qsize_t number, int warn=
)
>> -{
>> - =C2=A0 =C2=A0 int cnt, ret =3D QUOTA_OK;
>> -
>> - =C2=A0 =C2=A0 /*
>> - =C2=A0 =C2=A0 =C2=A0* First test before acquiring mutex - solves d=
eadlocks when we
>> - =C2=A0 =C2=A0 =C2=A0* re-enter the quota code and are already hold=
ing the mutex
>> - =C2=A0 =C2=A0 =C2=A0*/
>> - =C2=A0 =C2=A0 if (IS_NOQUOTA(inode)) {
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode_add_bytes(inode, n=
umber);
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
>> - =C2=A0 =C2=A0 }
>> -
>> - =C2=A0 =C2=A0 down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
>> - =C2=A0 =C2=A0 if (IS_NOQUOTA(inode)) {
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode_add_bytes(inode, n=
umber);
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_unlock;
>> - =C2=A0 =C2=A0 }
>> -
>> - =C2=A0 =C2=A0 ret =3D __dquot_alloc_space(inode, number, warn, 0);
>> - =C2=A0 =C2=A0 if (ret =3D=3D NO_QUOTA)
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_unlock;
>> + =C2=A0 =C2=A0 __inode_add_bytes(inode, number, reserve);
>>
>> + =C2=A0 =C2=A0 if (reserve)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_data_unlock;
>> =C2=A0 =C2=A0 =C2=A0 /* Dirtify all the dquots - this can block when=
 journalling */
>> =C2=A0 =C2=A0 =C2=A0 for (cnt =3D 0; cnt < MAXQUOTAS; cnt++)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (inode->i_dquot[=
cnt])
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 mark_dquot_dirty(inode->i_dquot[cnt]);
>> +out_data_unlock:
>> + =C2=A0 =C2=A0 spin_unlock(&dq_data_lock);
>> + =C2=A0 =C2=A0 flush_warnings(inode->i_dquot, warntype);
> =C2=A0You have to unlock dq_data_lock before mark_dquot_dirty as it c=
an sleep.
>
>> =C2=A0out_unlock:
>> =C2=A0 =C2=A0 =C2=A0 up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
>> =C2=A0out:
>> =C2=A0 =C2=A0 =C2=A0 return ret;
>> =C2=A0}
> ...
>> @@ -1854,6 +1882,7 @@ const struct dquot_operations dquot_operations=
 =3D {
>> =C2=A0 =C2=A0 =C2=A0 .write_info =C2=A0 =C2=A0 =3D dquot_commit_info=
,
>> =C2=A0 =C2=A0 =C2=A0 .alloc_dquot =C2=A0 =C2=A0=3D dquot_alloc,
>> =C2=A0 =C2=A0 =C2=A0 .destroy_dquot =C2=A0=3D dquot_destroy,
>> +
>> =C2=A0};
> =C2=A0I guess the above is a mistake...
>
>> diff --git a/include/linux/quota.h b/include/linux/quota.h
>> index 78c4889..40845f1 100644
>> --- a/include/linux/quota.h
>> +++ b/include/linux/quota.h
>> @@ -313,8 +313,9 @@ struct dquot_operations {
>> =C2=A0 =C2=A0 =C2=A0 int (*claim_space) (struct inode *, qsize_t);
>> =C2=A0 =C2=A0 =C2=A0 /* release rsved quota for delayed alloc */
>> =C2=A0 =C2=A0 =C2=A0 void (*release_rsv) (struct inode *, qsize_t);
>> - =C2=A0 =C2=A0 /* get reserved quota for delayed alloc */
>> - =C2=A0 =C2=A0 qsize_t (*get_reserved_space) (struct inode *);
>> + =C2=A0 =C2=A0 /* get reserved quota for delayed alloc, value retur=
ned is managed by
>> + =C2=A0 =C2=A0 =C2=A0* quota code only */
>> + =C2=A0 =C2=A0 qsize_t* (*get_reserved_space) (struct inode *);
> =C2=A0I think proper coding style is "qsize_t *(*get_reserved_space) =
(...)"
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
